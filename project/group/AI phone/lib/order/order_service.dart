import 'package:flutter/material.dart';
import '../cart/cart_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http; // Add this to pubspec.yaml


enum OrderStatus { paid, preparing, ready, completed, declined }

class FoodOrder {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime timestamp;
  final String type;
  OrderStatus status;

  FoodOrder({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.timestamp,
    required this.type,
    this.status = OrderStatus.paid,
  });

  static OrderStatus statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'order placed': return OrderStatus.paid; // Use your .paid enum as the base
      case 'preparing': return OrderStatus.preparing;
      case 'ready': return OrderStatus.ready;
      case 'completed': return OrderStatus.completed;
      case 'declined': return OrderStatus.declined;
      default: return OrderStatus.paid;
    }
  }
}

class OrderService extends ChangeNotifier {
  static final OrderService _instance = OrderService._internal();
  OrderService._internal();
  static OrderService get instance => _instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Notification list
  final List<Map<String, dynamic>> _customerNotifications = [];
  List<Map<String, dynamic>> get customerNotifications => _customerNotifications;
  void addNotification({required String title, required String message, required String time}) {
    _customerNotifications.add({ // Use _customerNotifications (the private list)
      'title': title,
      'message': message,
      'time': time,
    });
    notifyListeners(); // This triggers the ListenableBuilder in your UI
  }

  // --- CLOUD STREAMS ---
  Stream<QuerySnapshot> get newOrdersStream =>
      _db.collection('orders').where('status', isEqualTo: 'Order Placed').snapshots();

  Stream<QuerySnapshot> get preparingOrdersStream =>
      _db.collection('orders').where('status', isEqualTo: 'Preparing').snapshots();

  Stream<QuerySnapshot> get readyOrdersStream =>
      _db.collection('orders').where('status', isEqualTo: 'Ready').snapshots();

  Stream<QuerySnapshot> get historyOrdersStream =>
      _db.collection('orders')
          .where('status', whereIn: ['Completed', 'Declined'])
          .orderBy('timestamp', descending: true)
          .snapshots();

// --- MAIN ACTION: PLACE ORDER (Following Admin Queue Settings) ---
  Future<String> placeOrder(List<CartItem> items, double total, String type,
      {String paymentMethod = "Cash", String paymentStatus = "Unpaid"}) async {
    try {
      // 1. Fetch Admin Settings
      DocumentSnapshot snapshot = await _db.collection('settings').doc('queue_config').get();
      String prefix = "A";
      int startNum = 1;
      int maxPerHour = 50;

      if (snapshot.exists) {
        var adminData = snapshot.data() as Map<String, dynamic>;
        prefix = adminData['prefix'] ?? "A";
        startNum = int.tryParse(adminData['startNumber']?.toString() ?? "1") ?? 1;
        maxPerHour = adminData['maxPerHour'] ?? 50;
      }

      // 2. CHECK "MAX PER HOUR" LIMIT
      DateTime oneHourAgo = DateTime.now().subtract(const Duration(hours: 1));
      QuerySnapshot recentOrders = await _db.collection('orders').where('timestamp', isGreaterThan: oneHourAgo).get();

      if (recentOrders.docs.length >= maxPerHour) {
        throw Exception("Kitchen at capacity. Please try again shortly!");
      }

      // 3. QUEUE NUMBER LOGIC
      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day);
      QuerySnapshot todayOrders = await _db.collection('orders').where('timestamp', isGreaterThan: startOfToday).get();

      int nextNumber = startNum + todayOrders.docs.length;
      String queueNumber = "$prefix${nextNumber.toString().padLeft(3, '0')}";

      // 4. GENERATE CUSTOM ORDER ID
      String dateStr = "${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year.toString().substring(2)}";
      String uniqueSuffix = now.millisecondsSinceEpoch.toString().substring(10);
      String customOrderId = "ORD$dateStr$uniqueSuffix";

      // 5. SAVE TO FIREBASE
      final orderData = {
        'orderId': customOrderId,
        'queueNumber': queueNumber,
        'items': items.map((item) => {
          'name': item.name,
          'quantity': item.quantity,
          'price': item.price,
        }).toList(),
        'totalAmount': total,
        'orderType': type,
        'status': 'Order Placed', // Changed from 'Paid' to 'Order Placed'
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus, // Will be 'Unpaid' initially
        'timestamp': FieldValue.serverTimestamp(),
        'customerUid': FirebaseAuth.instance.currentUser?.uid,
      };

      await _db.collection('orders').doc(customOrderId).set(orderData);

      _addNotification("Order Confirmed", "Your queue number is $queueNumber");
      notifyListeners();

      return customOrderId;
    } catch (e) {
      print("Order Placement Error: $e");
      rethrow;
    }
  }

  // --- UPDATE STATUS (With Auto-Paid Logic) ---
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    // 1. Format the status string for Firestore (e.g., 'Preparing')
    String statusString = newStatus.name[0].toUpperCase() + newStatus.name.substring(1);

    // 2. Create the update map
    Map<String, dynamic> updates = {'status': statusString};

    // 3. AUTO-PAID LOGIC: If moving to Preparing, set paymentStatus to Paid
    if (newStatus == OrderStatus.preparing) {
      updates['paymentStatus'] = 'Paid';
    }

    // 4. Update Firestore
    await _db.collection('orders').doc(orderId).update(updates);

    _generateStatusNotification(orderId, newStatus);
    notifyListeners();
  }

  // --- HELPERS ---
  void _generateStatusNotification(String orderId, OrderStatus newStatus) {
    if (newStatus == OrderStatus.preparing) _addNotification("Preparing", "Chef is cooking order $orderId!");
    if (newStatus == OrderStatus.ready) _addNotification("Ready!", "Please collect your order at the counter.");
  }

  void _addNotification(String title, String message) {
    final now = DateTime.now();
    final timeStr = "${now.hour}:${now.minute.toString().padLeft(2, '0')}";

    // Use the public addNotification method to ensure notifyListeners() is called
    addNotification(title: title, message: message, time: timeStr);
  }

  void clearNotifications() {
    _customerNotifications.clear();
    notifyListeners();
  }


}


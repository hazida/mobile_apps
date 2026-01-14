import 'package:flutter/material.dart';
import 'cart_service.dart';

// Enum for the full lifecycle of an order
enum OrderStatus { paid, preparing, ready, completed, declined }

// Order Model
class FoodOrder {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime timestamp;
  final String type; 
  OrderStatus status;
  final String? time; 

  FoodOrder({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.timestamp,
    required this.type,
    this.status = OrderStatus.paid, 
    this.time, 
  });
}

class OrderService extends ChangeNotifier {
  static final OrderService _instance = OrderService._internal();
  OrderService._internal();
  static OrderService get instance => _instance;

  final List<FoodOrder> _orders = [];
  
  // Customer Notification List (Groupmate's addition)
  final List<Map<String, dynamic>> _customerNotifications = [];
  List<Map<String, dynamic>> get customerNotifications => _customerNotifications;

  int _orderCounter = 26; 

  // --- GETTERS ---
  List<FoodOrder> get allOrders => _orders;

  List<FoodOrder> get activeOrders => 
      _orders.where((o) => 
        o.status == OrderStatus.paid || 
        o.status == OrderStatus.preparing || 
        o.status == OrderStatus.ready
      ).toList();

  FoodOrder? get lastCompletedOrder {
    final completed = _orders.where((o) => o.status == OrderStatus.completed).toList();
    if (completed.isNotEmpty) return completed.last; 
    return null;
  }

  // --- ADMIN TABS ---
  List<FoodOrder> get newOrders => _orders.where((o) => o.status == OrderStatus.paid).toList();
  List<FoodOrder> get preparingOrders => _orders.where((o) => o.status == OrderStatus.preparing).toList();
  List<FoodOrder> get readyOrders => _orders.where((o) => o.status == OrderStatus.ready).toList();
  List<FoodOrder> get historyOrders => _orders.where((o) => o.status == OrderStatus.completed || o.status == OrderStatus.declined).toList();

  void placeOrder(List<CartItem> items, double total, String type) {
    String newId = 'A0${_orderCounter++}';
    final newOrder = FoodOrder(
      id: newId,
      items: List.from(items), 
      totalAmount: total,
      timestamp: DateTime.now(),
      type: type,
      status: OrderStatus.paid,
      time: "15-20", 
    );
    _orders.add(newOrder);

    // Add "Order Placed" Notification
    _addNotification(
      "Order Confirmed", 
      "Your order $newId has been placed successfully.",
    );

    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = newStatus;
      
      // Auto-generate Notification based on status
      if (newStatus == OrderStatus.preparing) {
        _addNotification(
          "Order is Being Prepared", 
          "Great news! Our chef is now preparing your delicious meal ($orderId). It won't take long!",
        );
      } else if (newStatus == OrderStatus.ready) {
        _addNotification(
          "Order Ready for Pickup!", 
          "Your order $orderId is ready. Queue number: $orderId. Please collect at the counter now!",
        );
      } else if (newStatus == OrderStatus.declined) {
        _addNotification(
          "Order Declined", 
          "We are sorry, order $orderId could not be fulfilled. Please see the counter.",
        );
      }

      notifyListeners();
    }
  }

  // Helper to add notification with current time
  void _addNotification(String title, String message) {
    final now = DateTime.now();
    final timeStr = "${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";
    
    _customerNotifications.add({
      'title': title,
      'message': message,
      'time': timeStr, 
    });
  }

  // --- NEW: Clear Notifications ---
  void clearNotifications() {
    _customerNotifications.clear();
    notifyListeners(); // Updates the UI immediately
  }
}
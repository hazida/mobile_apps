import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import your screens
import 'user/FoodMenuScreen.dart';
import 'cart/my_cart_page.dart';
import 'order/order_progress_screen.dart';
import 'order/order_invoice_screen.dart';
import 'order/order_service.dart';
import 'cart/cart_service.dart';


class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  Future<void> _handleNavigation(BuildContext context, int index) async {
    if (index == currentIndex) return; // Already on this page

    switch (index) {
      case 0: // Home
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const FoodMenuScreen()),
              (route) => false,
        );
        break;

      case 1: // Cart
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyCartPage()),
        );
        break;

      case 2: // Active Order Tracking
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return;

        final snapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('customerUid', isEqualTo: user.uid)
            .where('status', whereIn: ['Order Placed', 'Paid', 'Preparing', 'Ready'])
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderProgressScreen(orderId: snapshot.docs.first.id)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No active orders.")));
        }
        break;

      case 3: // Latest Receipt
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return;

        final snapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('customerUid', isEqualTo: user.uid)
            .where('status', isEqualTo: 'Completed')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          // Mapping Firestore data to your FoodOrder model
          final data = snapshot.docs.first.data();
          final latestOrder = FoodOrder(
            id: snapshot.docs.first.id,
            items: (data['items'] as List).map((item) => CartItem(
              name: item['name'],
              price: (item['price'] as num).toDouble(),
              quantity: item['quantity'],
              imagePath: item['imagePath'] ?? 'assets/images/default_food.png',
            )).toList(),
            totalAmount: (data['totalAmount'] as num).toDouble(),
            timestamp: (data['timestamp'] as Timestamp).toDate(),
            type: data['orderType'] ?? 'Dine In',
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderInvoiceScreen(order: latestOrder)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No receipts found.")));
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: (index) => _handleNavigation(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
        BottomNavigationBarItem(icon: Icon(Icons.watch_later_outlined), label: "Track"),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Receipt"),
      ],
    );
  }
}
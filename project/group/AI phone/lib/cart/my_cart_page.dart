// my_cart_page.dart

import 'package:flutter/material.dart';
import 'cart_item_card.dart';
import 'cart_service.dart';
import '../payment/PaymentOptionsPage.dart';
import '../order/order_service.dart';
import '../order/order_progress_screen.dart';
import '../notification/user_notification_screen.dart';
import '../custom_bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({super.key});

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  final CartService _cartService = CartService.instance;

  @override
  void initState() {
    super.initState();
    _cartService.addListener(_onCartChange);
    CartService.instance.loadAdminProfile();
    CartService.instance.initPricingListener();
  }

  @override
  void dispose() {
    _cartService.removeListener(_onCartChange);
    super.dispose();
  }

  void _onCartChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<CartItem> cartItems = _cartService.items;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),

      appBar: AppBar(
        toolbarHeight: 180,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: _buildHeader(cartItems.length),
      ),

      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty!", style: TextStyle(fontSize: 20, color: Colors.grey)))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: cartItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CartItemCard(
                      item: item,
                      onAdd: () => _cartService.updateQuantity(item, 1),
                      onSubtract: () => _cartService.updateQuantity(item, -1),
                      onRemove: () => _cartService.removeItem(item),
                    ),
                  );
                }).toList(),
              ),
            ),
              bottomNavigationBar: Column(
             mainAxisSize: MainAxisSize.min, // Important: makes column only as tall as its content
            children: [
            if (cartItems.isNotEmpty) _buildTotalSummary(context),
          const CustomBottomNav(currentIndex: 1),
        ],
      ),

    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildHeader(int itemCount) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFCC33),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        gradient: LinearGradient(
          colors: [Color(0xFFFFCC33), Color(0xFFFF9900)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- UPDATED: Back Button (No White Circle) ---
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  // Decoration removed
                  child: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                ),
              ),

              // --- UPDATED: Notification Icon (No White Circle) ---
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserNotificationScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  // Decoration removed
                  child: const Icon(Icons.notifications_none, color: Colors.black, size: 28),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "My Cart",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.0,
            ),
          ),
          Text(
            "$itemCount items selected",
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSummary(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFCC33),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2)),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "RM ${_cartService.totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to PaymentOptionsPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentOptionsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFFF33),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Proceed to Payment',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UPDATED BOTTOM NAV BAR ---
}
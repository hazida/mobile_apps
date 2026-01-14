import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../cart/cart_service.dart';
import '../order/order_progress_screen.dart';
import '../order/order_service.dart';
import '../notification/user_notification_screen.dart';
// 1. IMPORT YOUR CUSTOM NAV BAR HERE
import '../custom_bottom_nav.dart';

class CashPaymentScreen extends StatelessWidget {
  const CashPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = CartService.instance;
    final items = cartService.items;
    final totalAmount = cartService.totalAmount;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      appBar: AppBar(
        toolbarHeight: 170,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: _buildHeader(context),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildOrderSummaryCard(items, totalAmount),
                    const SizedBox(height: 20),
                    _buildWarningBanner(),
                  ],
                ),
              ),
            ),

            // Checkout Button
            _buildCheckoutButton(context, cartService),
          ],
        ),
      ),
      // 2. USE THE CUSTOM BOTTOM NAV INSTEAD OF LOCAL ONE
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFCC33), Color(0xFFFF9900)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: Colors.black, size: 28),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UserNotificationScreen()));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Payment Method", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
              const Text("Pay at the counter", style: TextStyle(fontSize: 16, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard(List items, double totalAmount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.orange),
              SizedBox(width: 10),
              Text("Order Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 20),
          if (items.isEmpty)
            const Center(child: Text("No items in cart"))
          else
            ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text("${item.quantity}x ${item.name}")),
                  Text("RM ${(item.price * item.quantity).toStringAsFixed(2)}"),
                ],
              ),
            )),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Amount:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("RM ${totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.timer, color: Colors.black),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              "Please complete payment within 15 minutes to secure your order.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context, CartService cartService) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      width: double.infinity,
      height: 85,
      child: ElevatedButton(
        onPressed: () async {
          if (cartService.items.isEmpty) return;

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.orange)),
          );

          try {
            // 1. Place order and get Custom ID
            String customOrderId = await OrderService.instance.placeOrder(
              cartService.items,
              cartService.totalAmount,
              cartService.orderType,
            );

            // 2. Set as Cash payment
            await FirebaseFirestore.instance.collection('orders').doc(customOrderId).update({
              'paymentMethod': 'Cash',
              'paymentStatus': 'Unpaid',
              'status': 'Order Placed',
            });

            // 3. Send Notification to Admin
            DocumentSnapshot doc = await FirebaseFirestore.instance.collection('orders').doc(customOrderId).get();
            String qNum = doc['queueNumber'] ?? "---";
            String userId = FirebaseAuth.instance.currentUser?.uid ?? "Unknown";

            await FirebaseFirestore.instance.collection('notifications').add({
              'userId': 'ADMIN_RECEIVE',
              'title': 'Cash Payment Alert 💵',
              'message': 'Customer is at counter to pay cash for Order #$qNum',
              'queueNumber': qNum,
              'orderId': customOrderId,
              'customerUid': userId,
              'timestamp': FieldValue.serverTimestamp(),
            });

            // 4. Clear local cart
            cartService.clearCart();

            if (context.mounted) {
              Navigator.pop(context); // Close loading
              _showSuccessDialog(context, qNum, customOrderId);
            }

          } catch (e) {
            if (context.mounted) Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFCC00),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Text("I'm At Counter", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String queueNumber, String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Order Placed", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Your Queue Number:"),
            Text(queueNumber, style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.orange)),
            Text("ID: $orderId", style: const TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 10),
            const Text("Please pay at the counter.", textAlign: TextAlign.center),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => OrderProgressScreen(orderId: orderId)),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text("TRACK ORDER", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
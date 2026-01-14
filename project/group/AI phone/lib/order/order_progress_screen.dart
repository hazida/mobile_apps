import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../user/FoodMenuScreen.dart';
import '../order/order_invoice_screen.dart';
import 'order_invoice_screen.dart';
import '../notification/user_notification_screen.dart';
import '../custom_bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../order/order_service.dart';
import '../cart/cart_service.dart';


class OrderProgressScreen extends StatelessWidget {
  final String orderId;

  const OrderProgressScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').doc(orderId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Error loading order."));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Order not found."));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          String status = data['status'] ?? 'Pending';
          String queueNumber = data['queueNumber'] ?? '---';
          double totalAmount = (data['totalAmount'] ?? 0.0).toDouble();
          String orderType = data['orderType'] ?? 'Dine In';
          List items = data['items'] ?? [];

          if (status == 'Completed' || status == 'Declined') {
            return _buildCompletedView(context, status, data);
          }

          return Column(
            children: [
              _buildCustomHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildQueueCard(queueNumber),
                      const SizedBox(height: 20),
                      _buildProgressCard(status),
                      const SizedBox(height: 20),
                      _buildSummaryCard(orderId, orderType, items, totalAmount),
                      const SizedBox(height: 25),
                      _buildRefreshButton(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 2),
    );
  }

  // --- WIDGET HELPER METHODS (All now inside the class) ---

  Widget _buildRefreshButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Status refreshed!")));
        },
        icon: const Icon(Icons.refresh, color: Colors.white),
        label: const Text("Refresh Status", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9900),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget _buildQueueCard(String queueNumber) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("QUEUE NUMBER", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFF9900), Color(0xFFFF7700)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  queueNumber,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const Text("Your order is in queue", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(String status) {
    int currentStep = 0;
    if (status == 'Preparing') currentStep = 1;
    if (status == 'Ready') currentStep = 2;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Order Progress", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (currentStep == 2)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                  child: const Text("NOW!", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              _buildStepIcon(Icons.access_time_filled, "Pending", 0, currentStep),
              _buildStepLine(0, currentStep),
              _buildStepIcon(Icons.soup_kitchen, "Preparing", 1, currentStep),
              _buildStepLine(1, currentStep),
              _buildStepIcon(Icons.inventory_2, "Ready", 2, currentStep),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String ordId, String type, List items, double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Order Summary", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _summaryRow("Order ID", ordId, isBold: true),
          const Divider(height: 20),
          _summaryRow("Order Type", type, isBold: true),
          const Divider(height: 20),
          _summaryRow("Items", "${items.length} Items"),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Amount", style: TextStyle(fontSize: 16, color: Colors.black54)),
              Text("RM ${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }

  // --- Sub-Widgets ---

  Widget _buildStepIcon(IconData icon, String label, int stepIndex, int currentStep) {
    bool isActive = stepIndex <= currentStep;
    bool isCurrent = stepIndex == currentStep;
    Color color = isActive ? (isCurrent && stepIndex == 2 ? Colors.green : Colors.orange) : Colors.grey.shade300;
    Color iconColor = isActive ? Colors.white : Colors.grey;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 45, height: 45,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
          if (isActive) const Text("✓ Done", style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStepLine(int index, int currentStep) {
    bool isActive = index < currentStep;
    return Container(width: 40, height: 3, color: isActive ? Colors.green : Colors.grey.shade300);
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  // Add 'Map data' to the arguments
  Widget _buildCompletedView(BuildContext context, String status, Map<String, dynamic> data) {
    bool isDeclined = status == 'Declined';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isDeclined ? Icons.cancel : Icons.check_circle,
                size: 100,
                color: isDeclined ? Colors.red : Colors.green),
            const SizedBox(height: 20),
            Text(isDeclined ? "Order Declined" : "Order Completed!",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(isDeclined
                ? "We're sorry, your order could not be fulfilled."
                : "Thank you for dining with Yatt's Kitchen!",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  try {
                    List<CartItem> convertedItems = (data['items'] as List<dynamic>).map((item) {
                      return CartItem(
                        name: item['name'] ?? 'Unknown',
                        price: (item['price'] ?? 0.0).toDouble(),
                        quantity: item['quantity'] ?? 1,
                        // FIX: Add the missing imagePath parameter
                        // If your Firestore saves the image, use item['imagePath']
                        // Otherwise, use an empty string or a placeholder path
                        imagePath: item['imagePath'] ?? '',
                      );
                    }).toList();

                    DateTime dateValue = data['timestamp'] != null
                        ? (data['timestamp'] as Timestamp).toDate()
                        : DateTime.now();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderInvoiceScreen(
                          order: FoodOrder(
                            id: orderId,
                            items: convertedItems,
                            totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
                            timestamp: dateValue,
                            type: data['orderType'] ?? 'Dine In',
                            status: FoodOrder.statusFromString(status),
                          ),
                        ),
                      ),
                    );
                  } catch (e) {
                    print("Navigation Error: $e");
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE67E22),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: const Text("View Invoice",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFFFCC33), Color(0xFFFF9900)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 28),
          const Column(
            children: [
              Text("Order Status", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text("Track your order", style: TextStyle(fontSize: 16, color: Colors.black54)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 28),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UserNotificationScreen())),
          ),
        ],
      ),
    );
  }

}
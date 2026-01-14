import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentVerificationScreen extends StatelessWidget {
  const PaymentVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Payment Verification",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      // Use StreamBuilder to listen to all orders with 'Pending' status
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('status', isEqualTo: 'Pending')
            .orderBy('timestamp', descending: false) // Oldest first
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading orders"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(
                child: Text("No payments waiting for verification",
                    style: TextStyle(color: Colors.grey))
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              var data = order.data() as Map<String, dynamic>;

              return _buildVerificationCard(
                context,
                order.id, // Document ID
                data['queueNumber'] ?? "---",
                "RM ${(data['totalAmount'] ?? 0).toStringAsFixed(2)}",
                data['paymentMethod'] ?? "Cash",
                data['items'] != null && data['items'].isNotEmpty
                    ? data['items'][0]['name']
                    : "No items",
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildVerificationCard(BuildContext context, String docId, String queueId, String price, String method, String mainItem) {
    return GestureDetector(
      onTap: () => _showVerifyDialog(context, docId, queueId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 50, width: 50,
              decoration: BoxDecoration(
                  color: method == "DuitNow" ? Colors.pink.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle
              ),
              child: Icon(
                  method == "DuitNow" ? Icons.qr_code : Icons.payments,
                  color: method == "DuitNow" ? Colors.pink : Colors.green
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Order $queueId", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(mainItem, style: const TextStyle(color: Colors.grey, fontSize: 13), overflow: TextOverflow.ellipsis),
                  Text("Via: $method", style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                const Text("Verify now →", style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Action Dialog to verify or decline the payment
  void _showVerifyDialog(BuildContext context, String docId, String queueId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Verify Order $queueId"),
        content: const Text("Has the payment been received? This will move the order to the Kitchen list."),
        actions: [
          TextButton(
            onPressed: () {
              // Mark as Declined
              FirebaseFirestore.instance.collection('orders').doc(docId).update({'status': 'Declined'});
              Navigator.pop(context);
            },
            child: const Text("DECLINE", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              // Update status to 'Preparing' (Kitchen side)
              FirebaseFirestore.instance.collection('orders').doc(docId).update({'status': 'Preparing'});
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("CONFIRM PAYMENT", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
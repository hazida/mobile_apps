import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../cart/cart_service.dart';
import '../order/order_progress_screen.dart';
import '../notification/user_notification_screen.dart';
import '../order/order_progress_screen.dart';
import '../order/order_service.dart';
import '../order/order_service.dart';



class DuitNowPage extends StatelessWidget {
  const DuitNowPage({super.key});

  // --- LOGIC: GENERATE QUEUE NUMBER FROM FIRESTORE SETTINGS ---
  Future<String> _generateQueueId() async {
    DocumentSnapshot config = await FirebaseFirestore.instance
        .collection('settings')
        .doc('queue_config')
        .get();

    String prefix = "A";
    int startNum = 1;

    if (config.exists) {
      var data = config.data() as Map<String, dynamic>;
      prefix = data['prefix'] ?? "A";
      startNum = int.tryParse(data['startNumber']?.toString() ?? "1") ?? 1;
    }

    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);

    QuerySnapshot todayOrders = await FirebaseFirestore.instance
        .collection('orders')
        .where('timestamp', isGreaterThan: startOfToday)
        .get();

    int nextNumber = startNum + todayOrders.docs.length;
    return "$prefix${nextNumber.toString().padLeft(3, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final cartService = CartService.instance;
    final totalAmount = cartService.totalAmount;
    final items = cartService.items;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      appBar: AppBar(
        toolbarHeight: 170,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
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
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const UserNotificationScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.notifications_none, color: Colors.black, size: 28),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Scan to Pay", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
                  const Text("DuitNow QR", style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. ORDER SUMMARY CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Order details:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${item.quantity}x ${item.name}", style: const TextStyle(color: Colors.black87)),
                        Text("RM ${(item.price * item.quantity).toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
                  const Divider(height: 30),
                  const Text("Total Amount", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 5),
                  Text("RM ${totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 2. QR CODE CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.pink.shade100, width: 2),
                boxShadow: [
                  BoxShadow(color: Colors.pink.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                children: [
                  Image.asset('assets/PianLisEnterprise.jpeg', height: 250, fit: BoxFit.contain),
                  const SizedBox(height: 15),
                  const Text("Scan with any banking app", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified_user, color: Colors.pink.shade400, size: 16),
                      const SizedBox(width: 5),
                      Text("Yatt's Kitchen (Pian Lis Enterprise)", style: TextStyle(color: Colors.pink.shade400, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 3. CONFIRM BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(

                // Inside the DuitNowPage ElevatedButton
                // Inside DuitNowPage -> ElevatedButton -> onPressed
                onPressed: () async {
                  if (cartService.items.isEmpty) return;

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.orange)),
                  );

                  try {
                    String customOrderId = await OrderService.instance.placeOrder(
                      cartService.items,
                      cartService.totalAmount,
                      cartService.orderType,
                      paymentMethod: 'Duit Now',
                      paymentStatus: 'Unpaid',
                    );

                    // --- ADD THIS LOGIC HERE ---
                    // This sends a notification to the ADMIN side
                    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('orders').doc(customOrderId).get();
                    String qNum = doc['queueNumber'] ?? "---";
                    String userId = FirebaseAuth.instance.currentUser?.uid ?? "Unknown";

                    await FirebaseFirestore.instance.collection('notifications').add({
                      'userId': 'ADMIN_RECEIVE', // Specific tag if you want to filter later, or leave as is
                      'title': 'New QR Payment 💳',
                      'message': 'Customer has paid via DuitNow. Please verify.',
                      'queueNumber': qNum,
                      'orderId': customOrderId,
                      'customerUid': userId, // Original user ID
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    // ----------------------------

                    cartService.clearCart();
                    if (context.mounted) Navigator.pop(context);
                    if (context.mounted) _showSuccessDialog(context, qNum, customOrderId);

                  } catch (e) {
                    if (context.mounted) Navigator.pop(context);
                    print("Error: $e");
                  }
                },


                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE67E22),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                ),
                child: const Text(
                  "I have made payment",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
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
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => OrderProgressScreen(orderId: orderId)),
                    (route) => false,
              );
            },
            child: const Text("TRACK ORDER", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

}
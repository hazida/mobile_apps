import 'package:flutter/material.dart';
import 'cart_service.dart'; 
import 'order_service.dart'; 
import 'order_progress_screen.dart';
import 'user_notification_screen.dart'; 

class DuitNowPage extends StatelessWidget {
  const DuitNowPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the CartService singleton
    final cartService = CartService.instance;
    final totalAmount = cartService.totalAmount;
    final items = cartService.items;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0), 
      
      // --- CUSTOM GRADIENT HEADER ---
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
                      // Back Button (No Circle, Black Icon)
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                      
                      // Notification Button (Functional)
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
            // 1. ORDER SUMMARY CARD (UPDATED ORDER)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- MOVED UP: Order Details ---
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
                  
                  // --- MOVED DOWN: Total Amount ---
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
                  BoxShadow(color: Colors.pink.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))
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
                onPressed: () {
                  // SIMULATE PAYMENT SUCCESS
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: const Column(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 60),
                            SizedBox(height: 10),
                            Text("Payment Successful"),
                          ],
                        ),
                        content: const Text("Your payment has been verified. We are processing your order!", textAlign: TextAlign.center),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close Dialog

                              // 1. Place Order in Service
                              OrderService.instance.placeOrder(
                                cartService.items,
                                cartService.totalAmount,
                                cartService.orderType,
                              );

                              // 2. Get the new order to pass to Progress Screen
                              final newOrder = OrderService.instance.allOrders.last;

                              // 3. Clear Cart
                              cartService.clearCart();

                              // 4. Navigate to Order Progress
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderProgressScreen(initialOrder: newOrder)
                                ),
                                (route) => false, 
                              );
                            },
                            child: const Text("OK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange)),
                          ),
                        ],
                      );
                    },
                  );
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
}
import 'package:flutter/material.dart';
import 'cart_service.dart';
import 'order_service.dart';
import 'FoodMenuScreen.dart';
import 'my_cart_page.dart';
import 'order_progress_screen.dart';
import 'order_invoice_screen.dart';
import 'user_notification_screen.dart';

class CashPaymentScreen extends StatelessWidget {
  const CashPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = CartService.instance;
    final items = cartService.items; 
    final totalAmount = cartService.totalAmount;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      
      // Custom Gradient Header
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
                      
                      // Notification Button
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
                  const Text("Payment Method", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
                  const Text("Choose how to pay", style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0), // Removed bottom padding here to handle it manually
        child: Column(
          children: [
            // --- SCROLLABLE AREA (Starts here) ---
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 1. Order Summary Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
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
            
                          // --- LIST OF ITEMS ---
                          if (items.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Center(child: Text("No items in cart", style: TextStyle(color: Colors.grey))),
                            )
                          else
                            ...items.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${item.quantity}x ${item.name}",
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    "RM ${(item.price * item.quantity).toStringAsFixed(2)}",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )),
                          // ---------------------
            
                          const Divider(height: 30),
                          _summaryRow("Subtotal:", "RM ${totalAmount.toStringAsFixed(2)}"),
                          // Service charge removed
                          const SizedBox(height: 10),
                          _summaryRow("Total:", "RM ${totalAmount.toStringAsFixed(2)}", isBold: true),
                        ],
                      ),
                    ),
            
                    const SizedBox(height: 20),
            
                    // 2. Warning/Info Card (Yellow)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700), // Gold/Yellow
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.timer, size: 30, color: Colors.black),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Complete Payment Within", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("15 minutes to keep your order active", style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20), // Extra space at bottom of scroll content
                  ],
                ),
              ),
            ),
            // --- SCROLLABLE AREA ENDS ---

            // 3. "I'm At Counter" Button (Pinned to Bottom)
            Container(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              width: double.infinity,
              height: 85, // Height includes padding
              child: ElevatedButton(
                onPressed: () {
                  if (cartService.items.isEmpty) return;

                  // Place Order
                  OrderService.instance.placeOrder(
                    cartService.items,
                    cartService.totalAmount,
                    cartService.orderType,
                  );
                  
                  final newOrder = OrderService.instance.allOrders.last;

                  // Clear Cart
                  cartService.clearCart();

                  // Show Success Dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: const Text("Order Placed"),
                      content: const Text("Thank you, we will process your order quickly."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); 
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => OrderProgressScreen(initialOrder: newOrder)),
                              (route) => false,
                            );
                          },
                          child: const Text("OK", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFCC00), 
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text("I'm At Counter", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isBold ? 18 : 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: isBold ? 18 : 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.grey,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        if (index == 0) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const FoodMenuScreen()), (route) => false);
        if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCartPage()));
        if (index == 2) {
           final activeOrders = OrderService.instance.activeOrders;
           if (activeOrders.isNotEmpty) Navigator.push(context, MaterialPageRoute(builder: (context) => OrderProgressScreen(initialOrder: activeOrders.last)));
        }
        if (index == 3) {
           final lastOrder = OrderService.instance.lastCompletedOrder;
           if (lastOrder != null) Navigator.push(context, MaterialPageRoute(builder: (context) => OrderInvoiceScreen(order: lastOrder)));
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.access_time), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: ""),
      ],
    );
  }
}
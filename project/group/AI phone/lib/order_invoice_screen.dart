import 'package:flutter/material.dart';
import 'order_service.dart';
import 'FoodMenuScreen.dart';
import 'my_cart_page.dart';
import 'order_progress_screen.dart';

class OrderInvoiceScreen extends StatelessWidget {
  final FoodOrder order;

  const OrderInvoiceScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final String invoiceId = "INV-${order.id}5001";
    final String dateStr =
        "${order.timestamp.day} ${_getMonth(order.timestamp.month)} ${order.timestamp.year}, ${order.timestamp.hour}:${order.timestamp.minute.toString().padLeft(2, '0')} ${order.timestamp.hour >= 12 ? 'PM' : 'AM'}";

    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      body: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF1C40F), Color(0xFFE67E22)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order Invoice",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Thank you for your order",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.notifications_none, size: 28),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.asset(
                              'assets/yattskitchenlogo.png',
                              height: 60,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Yatt's Kitchen",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Hutan Melintang Perak",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 5),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone, size: 14, color: Colors.orange),
                              SizedBox(width: 5),
                              Text(
                                "012-8996438",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDEBD0),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                _invoiceRow(
                                  "Invoice ID",
                                  invoiceId,
                                  isBold: true,
                                ),
                                const Divider(
                                  color: Colors.orange,
                                  thickness: 0.5,
                                ),
                                _invoiceRow(
                                  "Order ID",
                                  "ORD-${order.id}",
                                  isBold: true,
                                ),
                                const Divider(
                                  color: Colors.orange,
                                  thickness: 0.5,
                                ),
                                _invoiceRow("Queue No", order.id, isBold: true),
                                const Divider(
                                  color: Colors.orange,
                                  thickness: 0.5,
                                ),
                                _invoiceRow("Date & Time", dateStr),
                                const Divider(
                                  color: Colors.orange,
                                  thickness: 0.5,
                                ),
                                _invoiceRow("Order Type", order.type),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Order Items:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...order.items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          "Qty: ${item.quantity} x RM ${item.price.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "RM ${(item.price * item.quantity).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const Divider(thickness: 1, height: 30),

                          // --- FIXED TOTALS SECTION ---
                          // Only Subtotal is shown here. Service Charge and Tax lines are deleted.
                          _totalRow(
                            "Subtotal",
                            "RM ${order.totalAmount.toStringAsFixed(2)}",
                          ),

                          const Divider(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "RM ${order.totalAmount.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // Helper methods remain the same to preserve structure
  Widget _invoiceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
              color: isBold ? Colors.black87 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  String _getMonth(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: 3,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const FoodMenuScreen()),
            (route) => false,
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyCartPage()),
          );
        } else if (index == 2) {
          final activeOrders = OrderService.instance.activeOrders;
          if (activeOrders.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OrderProgressScreen(initialOrder: activeOrders.last),
              ),
            );
          }
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.watch_later_outlined),
          label: "",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: ""),
      ],
    );
  }
}

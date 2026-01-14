import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_service.dart';
import '../user/FoodMenuScreen.dart';
import '../cart/my_cart_page.dart';
import 'order_progress_screen.dart';
import '../cart/cart_service.dart';
import '../custom_bottom_nav.dart';

class OrderInvoiceScreen extends StatelessWidget {
  final FoodOrder order;

  // Option A: Passing the FoodOrder object directly from the Cart/Checkout
  const OrderInvoiceScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Clean up the ID for the invoice display
    final String cleanId = order.id.replaceAll(' ', '');
    final String invoiceId = "INV-$cleanId";

    final String dateStr =
        "${order.timestamp.day} ${_getMonth(order.timestamp.month)} ${order.timestamp.year}, "
        "${order.timestamp.hour > 12 ? order.timestamp.hour - 12 : (order.timestamp.hour == 0 ? 12 : order.timestamp.hour)}:"
        "${order.timestamp.minute.toString().padLeft(2, '0')} "
        "${order.timestamp.hour >= 12 ? 'PM' : 'AM'}";

    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      body: Stack(
        children: [
          // Header Background
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
                _buildAppBar(context),
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
                          _buildBusinessHeader(),
                          const SizedBox(height: 20),

                          // Invoice Info Box
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
                                _invoiceRow("Order ID", order.id, isBold: true),
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

                          // Items List
                          ...order.items.map((item) => _buildItemRow(item)),

                          const Divider(thickness: 1, height: 30),

                          _totalRow(
                            "Subtotal",
                            "RM ${order.totalAmount.toStringAsFixed(2)}",
                          ),
                          const Divider(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total Paid",
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
                                  color: Color(0xFFE67E22),
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
      bottomNavigationBar: CustomBottomNav(currentIndex: 3),
    );
  }

  // --- UI HELPER COMPONENTS ---

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        children: [
          // IconButton(
          //   icon: const Icon(Icons.arrow_back, color: Colors.black),
          //   onPressed: () => Navigator.pop(context),
          // ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order Invoice",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "Thank you for your order",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.restaurant,
            size: 40,
            color: Colors.orange,
          ), // Use Icon if logo asset missing
        ),
        const SizedBox(height: 10),
        const Text(
          "Yatt's Kitchen",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Text(
          "Hutan Melintang\nHutan Melintang, Perak",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 5),
        const Text("Contact: 012-8996438", style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildItemRow(CartItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            "RM ${(item.price * item.quantity).toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

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
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
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
}

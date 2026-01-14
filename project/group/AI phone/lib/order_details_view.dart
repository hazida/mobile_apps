import 'package:flutter/material.dart';

/// This function is public so it can be called from NewOrdersScreen or HistoryScreen.
void showOrderDetails(BuildContext context, String id) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFFF9EBDD),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grab handle for the bottom sheet
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Header: ID and Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order Details: $id",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),

          // Order Metadata Section
          detailRow("Order Type:", "Take Away", isBadge: true),
          detailRow("Order Time:", "10:42 AM"),
          detailRow("Customer Name:", "Ahmad Zaki"),

          const SizedBox(height: 25),
          const Text(
            "ITEMS ORDERED",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 15),

          // Item List Section
          itemRow("Roti Canai", "2", "RM 4.00"),
          itemRow("Teh Tarik", "1", "RM 2.50"),
          itemRow("Mee Goreng", "1", "RM 12.00"),

          const Spacer(),
          const Divider(thickness: 1),
          const SizedBox(height: 10),

          // Totals Section - Only Subtotal is displayed
          totalRow("Subtotal", "RM 18.50"),
          const SizedBox(height: 10),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "RM 18.50",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE67E22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    ),
  );
}

/// Helper widget for metadata rows (Type, Time, Name)
Widget detailRow(String label, String value, {bool isBadge = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 16),
        ),
        isBadge
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE67E22).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFFE67E22),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
      ],
    ),
  );
}

/// Helper widget for individual food item rows
Widget itemRow(String name, String qty, String price) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "${qty}x",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFE67E22),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

/// Helper widget for calculation rows (Subtotal)
Widget totalRow(String label, String price) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(price, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    ),
  );
}
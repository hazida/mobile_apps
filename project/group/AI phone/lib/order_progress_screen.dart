import 'package:flutter/material.dart';
import 'order_service.dart';
import 'FoodMenuScreen.dart';
import 'my_cart_page.dart';
import 'order_invoice_screen.dart';
import 'user_notification_screen.dart'; // <--- NEW IMPORT

class OrderProgressScreen extends StatelessWidget {
  final FoodOrder initialOrder;

  const OrderProgressScreen({super.key, required this.initialOrder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0), 
      body: ListenableBuilder(
        listenable: OrderService.instance,
        builder: (context, child) {
          // 1. Get latest order status
          FoodOrder currentOrder = initialOrder;
          try {
            currentOrder = OrderService.instance.allOrders.firstWhere((o) => o.id == initialOrder.id);
          } catch (e) {
            // Order not found (rare)
          }

          // --- If Completed/Declined, CLEAR SCREEN ---
          if (currentOrder.status == OrderStatus.completed || currentOrder.status == OrderStatus.declined) {
            return _buildCompletedView(context, currentOrder);
          }

          return Column(
            children: [
              _buildCustomHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildQueueCard(currentOrder),
                      const SizedBox(height: 20),
                      _buildProgressCard(currentOrder),
                      const SizedBox(height: 20),
                      _buildSummaryCard(currentOrder),
                      const SizedBox(height: 25),
                      SizedBox(
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
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // --- View shown when order is cleared/completed ---
  Widget _buildCompletedView(BuildContext context, FoodOrder order) {
    bool isDeclined = order.status == OrderStatus.declined;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDeclined ? Icons.cancel : Icons.check_circle, 
              size: 100, 
              color: isDeclined ? Colors.red : Colors.green
            ),
            const SizedBox(height: 20),
            Text(
              isDeclined ? "Order Declined" : "Order Completed!",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              isDeclined 
                ? "We're sorry, your order could not be fulfilled."
                : "Thank you for dining with Yatt's Kitchen! We hope to see you again.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Go back to Menu
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const FoodMenuScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE67E22),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("Back to Menu", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Spacer for symmetry
          const SizedBox(width: 28), 
          
          const Column(
            children: [
              Text("Order Status", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text("Track your order", style: TextStyle(fontSize: 16, color: Colors.black54)),
            ],
          ),

          // --- UPDATED: Notification Button ---
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserNotificationScreen()),
              );
            },
          ),
          // ------------------------------------
        ],
      ),
    );
  }

  Widget _buildQueueCard(FoodOrder order) {
    bool isReady = order.status == OrderStatus.ready;

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
                  order.id, 
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const Text("Your order is in queue", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          if (isReady) ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD5F5E3), 
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    child: const Icon(Icons.check, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ready for pickup!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("Come get it while it's hot!", style: TextStyle(fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildProgressCard(FoodOrder order) {
    int currentStep = 0; 
    if (order.status == OrderStatus.preparing) currentStep = 1;
    if (order.status == OrderStatus.ready) currentStep = 2;

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

          if (currentStep == 2) ...[
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2ECC71), Color(0xFF27AE60)]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: const Column(
                children: [
                  Text("YOUR ORDER IS READY!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("Head to the counter now!", style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

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
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: isActive ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))] : [],
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? Colors.black : Colors.grey)),
          if (isActive) 
            const Text("✓ Done", style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStepLine(int index, int currentStep) {
    bool isActive = index < currentStep;
    return Container(
      width: 40,
      height: 3,
      color: isActive ? Colors.green : Colors.grey.shade300,
    );
  }

  Widget _buildSummaryCard(FoodOrder order) {
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
          _summaryRow("Order ID", order.id, isBold: true),
          const Divider(height: 20),
          _summaryRow("Order Type", order.type, isBold: true),
          const Divider(height: 20),
          _summaryRow("Items", "${order.items.length} Items"),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Amount", style: TextStyle(fontSize: 16, color: Colors.black54)),
              Text("RM ${order.totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
            ],
          ),
        ],
      ),
    );
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

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: 2, // Highlight the Watch Tab (Index 2)
      onTap: (index) {
        // 0: Home
        if (index == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const FoodMenuScreen()),
            (route) => false,
          );
        } 
        // 1: Cart
        else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyCartPage()),
          );
        } 

        // 2: Watch (Current Page) - Do nothing

        // 3: Receipts (Invoice) - Navigate to Invoice Screen
        else if (index == 3) {
           final lastOrder = OrderService.instance.lastCompletedOrder;
           if (lastOrder != null) {
             Navigator.push(
               context, 
               MaterialPageRoute(builder: (context) => OrderInvoiceScreen(order: lastOrder))
             );
           } else {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text("No completed orders yet."))
             );
           }
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.watch_later_outlined), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: ""), 
      ],
    );
  }
}
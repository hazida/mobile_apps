import 'package:flutter/material.dart';
import 'menu_items_screen.dart';
import 'notifications_screen.dart';
import 'order_service.dart';
import 'welcome_page.dart'; // <--- Import WelcomePage

class AdminDashboard extends StatefulWidget {
  final Function(int) onSwitchTab;

  const AdminDashboard({super.key, required this.onSwitchTab});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListenableBuilder(
                    listenable: OrderService.instance,
                    builder: (context, child) {
                      final allOrders = OrderService.instance.allOrders;
                      final now = DateTime.now();

                      final todayOrders = allOrders.where((o) {
                        return o.timestamp.year == now.year &&
                            o.timestamp.month == now.month &&
                            o.timestamp.day == now.day;
                      }).toList();

                      final todayCount = todayOrders.length;
                      final completedCount = todayOrders
                          .where((o) => o.status == OrderStatus.completed)
                          .length;
                      final inQueueCount =
                          OrderService.instance.newOrders.length +
                          OrderService.instance.preparingOrders.length;
                      final revenue = todayOrders
                          .where((o) => o.status != OrderStatus.declined)
                          .fold(0.0, (sum, order) => sum + order.totalAmount);

                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.4,
                        children: [
                          _buildStatCard(
                            "Today's Orders",
                            "$todayCount",
                            Icons.shopping_cart_outlined,
                            const Color(0xFFF39C12),
                          ),
                          _buildStatCard(
                            "Orders Completed",
                            "$completedCount",
                            Icons.inventory_2_outlined,
                            const Color(0xFF2ECC71),
                          ),
                          _buildStatCard(
                            "In Queue",
                            "$inQueueCount",
                            Icons.access_time,
                            const Color(0xFF5D6D7E),
                          ),
                          _buildStatCard(
                            "Today's Revenue",
                            "RM ${revenue.toStringAsFixed(0)}",
                            Icons.attach_money,
                            const Color(0xFF9B59B6),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Quick Actions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildQuickActions(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
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
      child: Stack(
        children: [
          const Center(
            child: Column(
              children: [
                Text(
                  "Hello, Admin!",
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Yatt's Kitchen",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Hutan Melintang",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),

          // --- NEW: LEAVE BUTTON (TOP LEFT) ---
          Positioned(
            left: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              tooltip: "Leave Dashboard",
              onPressed: () {
                // Navigate back to Welcome Page and clear history so they can't go back
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                  (route) => false,
                );
              },
            ),
          ),

          // ------------------------------------
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: [
        _actionBtn("New Order", Icons.bakery_dining, () {
          widget.onSwitchTab(2);
        }),
        _actionBtn("Menu Items", Icons.restaurant_menu, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MenuItemsScreen()),
          );
        }),
      ],
    );
  }

  Widget _actionBtn(String label, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

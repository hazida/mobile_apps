import 'package:flutter/material.dart';
import 'popular_food_cart.dart';
import 'my_cart_page.dart';
import 'chatbot_screen.dart';
import 'order_service.dart';
import 'order_progress_screen.dart';
import 'order_invoice_screen.dart';
import 'welcome_page.dart';
import 'menu_service.dart';
import 'user_notification_screen.dart'; // <--- UPDATED IMPORT

// --- FOOD ITEM DATA MODEL ---
class FoodItem {
  final String name;
  final String description;
  final String? price;
  final double? rating;
  final String? time;
  final String category;
  final bool isPopular;
  final String imagePath;
  bool isAvailable;

  FoodItem({
    required this.name,
    required this.description,
    this.price,
    this.rating,
    this.time,
    required this.category,
    this.isPopular = false,
    required this.imagePath,
    this.isAvailable = true,
  });
}

class FoodMenuScreen extends StatefulWidget {
  const FoodMenuScreen({super.key});

  @override
  State<FoodMenuScreen> createState() => _FoodMenuScreenState();
}

class _FoodMenuScreenState extends State<FoodMenuScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<FoodItem> get _filteredFoodItems {
    final query = _searchQuery.toLowerCase();
    final allItems = MenuService.instance.items;

    return allItems.where((item) {
      final matchesQuery = item.name.toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == 'All' || item.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      appBar: AppBar(
        toolbarHeight: 180,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: _buildHeader(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotScreen()),
          );
        },
        backgroundColor: const Color(0xFFE67E22),
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
      body: ListenableBuilder(
        listenable: MenuService.instance,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildCategoryRow(),
                  const SizedBox(height: 30),
                  _buildFoodGrid(context),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildHeader() {
    return Container(
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
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomePage(),
                    ),
                    (route) => false,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Yatt's Kitchen",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Hutan Melintang",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              // --- UPDATED NOTIFICATION ICON ---
              IconButton(
                icon: const Icon(Icons.notifications_none, size: 28),
                onPressed: () {
                  // Navigate to UserNotificationScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserNotificationScreen(),
                    ),
                  );
                },
              ),
              // ---------------------------------
            ],
          ),
          const SizedBox(height: 15),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search Delicious Food',
              prefixIcon: const Icon(Icons.search),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow() {
    final categories = ['All', 'Rice', 'Noodles', 'Sides'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final bool isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFF39C12) : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFoodGrid(BuildContext context) {
    final filteredItems = _filteredFoodItems;
    if (filteredItems.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("No items found."),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return PopularFoodCard(item: filteredItems[index]);
      },
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        if (index == 1) {
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
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No active orders found.")),
            );
          }
        } else if (index == 3) {
          final lastOrder = OrderService.instance.lastCompletedOrder;
          if (lastOrder != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderInvoiceScreen(order: lastOrder),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No completed orders yet.")),
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
        BottomNavigationBarItem(icon: Icon(Icons.access_time), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: ""),
      ],
    );
  }
}

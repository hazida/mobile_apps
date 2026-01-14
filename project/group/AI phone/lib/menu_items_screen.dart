import 'package:flutter/material.dart';
import 'FoodMenuScreen.dart'; // Needed for FoodItem model
import 'menu_service.dart'; // Needed for Data
import 'edit_menu_screen.dart'; // Import Edit Screen
import 'add_menu_screen.dart'; // Import Add Screen
import 'notifications_screen.dart'; // Added for notification navigation

class MenuItemsScreen extends StatefulWidget {
  const MenuItemsScreen({super.key});

  @override
  State<MenuItemsScreen> createState() => _MenuItemsScreenState();
}

class _MenuItemsScreenState extends State<MenuItemsScreen> {
  String _searchQuery = '';

  // --- Category Logic ---
  int _categoryIndex = 0;
  final List<String> _categoryOptions = [
    "All Categories",
    "Rice",
    "Noodles",
    "Sides",
  ];

  void _cycleCategory() {
    setState(() {
      _categoryIndex = (_categoryIndex + 1) % _categoryOptions.length;
    });
  }

  // --- NEW: Status Logic ---
  int _statusIndex = 0;
  final List<String> _statusOptions = [
    "All Status",
    "Available",
    "Out of Stock",
  ];

  void _cycleStatus() {
    setState(() {
      _statusIndex = (_statusIndex + 1) % _statusOptions.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E1),
      body: Column(
        children: [
          // 1. Header Section (Updated to match Dashboard)
          _buildHeader(),

          // 2. Filter Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              children: [
                _buildFilterButton(
                  _categoryOptions[_categoryIndex],
                  isSelected: true,
                  onTap: _cycleCategory,
                ),
                const SizedBox(width: 10),
                _buildFilterButton(
                  _statusOptions[_statusIndex],
                  isSelected: true,
                  onTap: _cycleStatus,
                ),
              ],
            ),
          ),

          // 3. Menu List
          Expanded(
            child: ListenableBuilder(
              listenable: MenuService.instance,
              builder: (context, child) {
                final currentCategory = _categoryOptions[_categoryIndex];
                final currentStatus = _statusOptions[_statusIndex];

                final items = MenuService.instance.items.where((item) {
                  final matchesSearch = item.name.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  );
                  final matchesCategory =
                      (currentCategory == "All Categories") ||
                      (item.category == currentCategory);

                  bool matchesStatus = true;
                  if (currentStatus == "Available") {
                    matchesStatus = item.isAvailable;
                  } else if (currentStatus == "Out of Stock") {
                    matchesStatus = !item.isAvailable;
                  }

                  return matchesSearch && matchesCategory && matchesStatus;
                }).toList();

                if (items.isEmpty) {
                  return const Center(child: Text("No menu items found."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildMenuCard(item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
      child: Column(
        children: [
          Stack(
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
              Positioned(
                left: 0,
                top: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
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
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: const InputDecoration(
                      hintText: "Search Delicious Food",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddMenuScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFFFFCC33,
                  ).withValues(alpha: 0.8),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "+ New Menu",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
    String label, {
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF37920),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(FoodItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(item.imagePath),
                    fit: BoxFit.cover,
                    colorFilter: item.isAvailable
                        ? null
                        : ColorFilter.mode(
                            Colors.grey.withValues(alpha: 0.8),
                            BlendMode.saturation,
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildBadge(item.category, Colors.amber),
                const SizedBox(width: 8),
                _buildBadge(
                  item.isAvailable ? "Available" : "Out of Stock",
                  item.isAvailable ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.description,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "RM ${item.price}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF37920),
                  ),
                ),
                Row(
                  children: [
                    _buildIconBtn(Icons.edit_outlined, Colors.blue, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditMenuScreen(item: item),
                        ),
                      );
                    }),
                    const SizedBox(width: 8),
                    _buildIconBtn(Icons.delete_outline, Colors.red, () {
                      _showDeleteConfirm(context, item);
                    }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildIconBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, FoodItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Item"),
        content: Text("Are you sure you want to remove '${item.name}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              MenuService.instance.deleteItem(item);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

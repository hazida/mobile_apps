import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_menu_screen.dart';
import 'edit_menu_screen.dart';
import '../notification/notifications_screen.dart';

class MenuItemsScreen extends StatefulWidget {
  const MenuItemsScreen({super.key});

  @override
  State<MenuItemsScreen> createState() => _MenuItemsScreenState();
}

class _MenuItemsScreenState extends State<MenuItemsScreen> {
  String _searchQuery = '';
  int _categoryIndex = 0;
  final List<String> _categoryOptions = [
    "All Categories",
    "Rice",
    "Noodles",
    "Sides",
  ];

  int _statusIndex = 0;
  final List<String> _statusOptions = [
    "All Status",
    "Available",
    "Out of Stock",
  ];

  final CollectionReference _menuCollection = FirebaseFirestore.instance
      .collection('menu_item');

  void _cycleCategory() => setState(
    () => _categoryIndex = (_categoryIndex + 1) % _categoryOptions.length,
  );
  void _cycleStatus() =>
      setState(() => _statusIndex = (_statusIndex + 1) % _statusOptions.length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E1),
      body: Column(
        children: [
          _buildHeader(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              children: [
                _buildFilterButton(
                  _categoryOptions[_categoryIndex],
                  onTap: _cycleCategory,
                ),
                const SizedBox(width: 10),
                _buildFilterButton(
                  _statusOptions[_statusIndex],
                  onTap: _cycleStatus,
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _menuCollection
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return const Center(child: Text("Something went wrong"));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final currentCategory = _categoryOptions[_categoryIndex];
                final currentStatus = _statusOptions[_statusIndex];

                final items = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = data['name']?.toString().toLowerCase() ?? '';
                  final category = data['category']?.toString() ?? '';
                  final isAvailable = data['isAvailable'] as bool? ?? false;

                  final matchesSearch = name.contains(
                    _searchQuery.toLowerCase(),
                  );
                  final matchesCategory =
                      (currentCategory == "All Categories") ||
                      (category == currentCategory);

                  bool matchesStatus = true;
                  if (currentStatus == "Available")
                    matchesStatus = isAvailable;
                  else if (currentStatus == "Out of Stock")
                    matchesStatus = !isAvailable;

                  return matchesSearch && matchesCategory && matchesStatus;
                }).toList();

                if (items.isEmpty)
                  return const Center(child: Text("No menu items found."));

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) => _buildMenuCard(items[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- UI HELPER METHODS (Restored to fix your error) ---

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
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddMenuScreen(),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFCC33),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "+ New Menu",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, {required VoidCallback onTap}) {
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

  Widget _buildMenuCard(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final String id = doc.id;
    final bool isAvailable = data['isAvailable'] ?? false;
    final String? imageUrl = data['imageUrl'];
    // Added: Get the description from data
    final String description =
        data['description'] ?? 'No description provided.';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
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
            // 1. Image Rectangle
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
                image: DecorationImage(
                  image: (imageUrl != null && imageUrl.isNotEmpty)
                      ? NetworkImage(imageUrl)
                      : const AssetImage('assets/placeholder.png')
                            as ImageProvider,
                  fit: BoxFit.cover,
                  colorFilter: isAvailable
                      ? null
                      : const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 2. Badges
            Row(
              children: [
                _buildBadge(data['category'] ?? 'General', Colors.amber),
                const SizedBox(width: 8),
                _buildBadge(
                  isAvailable ? "Available" : "Out of Stock",
                  isAvailable ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 3. Name
            Text(
              data['name'] ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // --- ADDED: DESCRIPTION SECTION ---
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.3, // Improves readability
              ),
              maxLines: 2, // Prevents the card from getting too tall
              overflow: TextOverflow.ellipsis, // Adds "..." if text is too long
            ),

            // ----------------------------------
            const SizedBox(height: 15),

            // 4. Price and Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "RM ${data['price']}",
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
                          builder: (context) =>
                              EditMenuScreen(itemId: id, currentData: data),
                        ),
                      );
                    }),
                    const SizedBox(width: 8),
                    _buildIconBtn(
                      Icons.delete_outline,
                      Colors.red,
                      () => _showDeleteConfirm(context, id, data['name'] ?? ''),
                    ),
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
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Item"),
        content: Text("Are you sure you want to remove '$name'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await _menuCollection.doc(id).delete();
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

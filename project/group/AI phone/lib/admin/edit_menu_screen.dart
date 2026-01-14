import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditMenuScreen extends StatefulWidget {
  final String itemId;
  final Map<String, dynamic> currentData;

  const EditMenuScreen({
    super.key,
    required this.itemId,
    required this.currentData
  });

  @override
  State<EditMenuScreen> createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late String _selectedCategory;
  late bool _isAvailable;
  final List<String> _categories = ["Rice", "Noodles", "Sides"];

  @override
  void initState() {
    super.initState();
    // Pre-fill from widget.currentData
    _nameController = TextEditingController(text: widget.currentData['name'] ?? '');
    _descController = TextEditingController(text: widget.currentData['description'] ?? '');
    _priceController = TextEditingController(text: widget.currentData['price']?.toString() ?? '');

    _selectedCategory = _categories.contains(widget.currentData['category'])
        ? widget.currentData['category']
        : _categories.first;

    _isAvailable = widget.currentData['isAvailable'] ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      // Logic to update Firestore
      await FirebaseFirestore.instance
          .collection('menu_item')
          .doc(widget.itemId)
          .update({
        'name': _nameController.text.trim(),
        'description': _descController.text.trim(),
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'category': _selectedCategory,
        'isAvailable': _isAvailable,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Menu updated successfully!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Note: Replaced widget.item.imagePath with widget.currentData['imageUrl']
    final String? imageUrl = widget.currentData['imageUrl'];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 220,
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
                Positioned(
                  top: 50,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: (imageUrl != null && imageUrl.isNotEmpty)
                            ? Image.network(imageUrl, height: 160, width: 220, fit: BoxFit.cover)
                            : Image.asset('assets/yattskitchenlogo.png', height: 160, width: 220, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Category"),
                    _buildDropdownField(),
                    const SizedBox(height: 15),
                    _buildLabel("Item Name"),
                    _buildTextField(_nameController),
                    const SizedBox(height: 15),
                    _buildLabel("Description"),
                    _buildTextField(_descController, maxLines: 3),
                    const SizedBox(height: 15),
                    _buildLabel("Price (RM)"),
                    _buildTextField(_priceController, isNumber: true),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _isAvailable,
                          activeColor: Colors.green,
                          onChanged: (val) => setState(() => _isAvailable = val!),
                        ),
                        const Text("Available for order"),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2ECC71)),
                            child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF3B30)),
                            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (val) => setState(() => _selectedCategory = val!),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget _buildTextField(TextEditingController controller, {int maxLines = 1, bool isNumber = false}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      decoration: InputDecoration(filled: true, fillColor: Colors.grey.shade100, border: InputBorder.none),
    );
  }
}
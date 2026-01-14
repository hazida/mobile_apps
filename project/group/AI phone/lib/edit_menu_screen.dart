import 'package:flutter/material.dart';
import 'FoodMenuScreen.dart'; // Model
import 'menu_service.dart';   // Data Logic

class EditMenuScreen extends StatefulWidget {
  final FoodItem item;

  const EditMenuScreen({super.key, required this.item});

  @override
  State<EditMenuScreen> createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  
  // CHANGED: Use String for Dropdown instead of Controller
  late String _selectedCategory;
  final List<String> _categories = ["Rice", "Noodles", "Sides"];

  late bool _isAvailable;

  @override
  void initState() {
    super.initState();
    // Pre-fill data from the item passed in
    _nameController = TextEditingController(text: widget.item.name);
    _descController = TextEditingController(text: widget.item.description);
    _priceController = TextEditingController(text: widget.item.price);
    
    // Initialize dropdown. If current category isn't in list, default to first option.
    _selectedCategory = _categories.contains(widget.item.category) 
        ? widget.item.category 
        : _categories.first;

    _isAvailable = widget.item.isAvailable;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // 1. Create updated object
    final updatedItem = FoodItem(
      name: _nameController.text,
      description: _descController.text,
      price: _priceController.text,
      category: _selectedCategory, // Use the dropdown value
      imagePath: widget.item.imagePath, // Keep original image
      isPopular: widget.item.isPopular, // Keep original flag
      isAvailable: _isAvailable, // Updated status
    );

    // 2. Update via Service
    MenuService.instance.updateItem(widget.item, updatedItem);

    // 3. Close screen
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Menu updated successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E1), // Light cream background
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. Custom Header with Image ---
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Orange Background
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
                
                // Back Button
                Positioned(
                  top: 50,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Status Dropdown (Top Right)
                Positioned(
                  top: 50,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _isAvailable ? Colors.green.shade100 : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _isAvailable ? Colors.green : Colors.red),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<bool>(
                        value: _isAvailable,
                        isDense: true,
                        icon: Icon(Icons.arrow_drop_down, color: _isAvailable ? Colors.green : Colors.red),
                        items: const [
                          DropdownMenuItem(value: true, child: Text("Available", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                          DropdownMenuItem(value: false, child: Text("Out of Stock", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                        ],
                        onChanged: (val) {
                          setState(() => _isAvailable = val!);
                        },
                      ),
                    ),
                  ),
                ),

                // Centered Food Image
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
                        child: Image.asset(widget.item.imagePath, height: 160, width: 220, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50), // Spacer for the overlapping image

            // --- 2. Edit Form ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Category"),
                    
                    // --- UPDATED: Dropdown styled like the text fields ---
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100, // Matches your text field color
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.orange),
                          items: _categories.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(fontSize: 16)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCategory = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    // -----------------------------------------------------
                    
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

                    // Checkbox Row
                    Row(
                      children: [
                        Checkbox(
                          value: _isAvailable,
                          activeColor: Colors.green,
                          onChanged: (val) => setState(() => _isAvailable = val!),
                        ),
                        const Text("Available for order", style: TextStyle(fontSize: 16)),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2ECC71), // Green
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, size: 16, color: Colors.white),
                            label: const Text("Cancel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF3B30), // Red
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildTextField(TextEditingController controller, {int maxLines = 1, bool isNumber = false}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
    );
  }
}
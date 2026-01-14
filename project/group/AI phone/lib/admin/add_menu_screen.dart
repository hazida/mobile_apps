import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Add this to pubspec.yaml
import 'package:image_picker/image_picker.dart'; // Add this to pubspec.yaml
import 'package:cloud_firestore/cloud_firestore.dart';
import '../user/FoodMenuScreen.dart'; // Your existing model

class AddMenuScreen extends StatefulWidget {
  const AddMenuScreen({super.key});

  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  // --- CLOUDINARY CONFIG ---
  final String cloudName = "djqx91khu"; // Replace with yours
  final String uploadPreset = "yattskitchen"; // Replace with yours

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String? _selectedCategory;
  final List<String> _categories = ["Rice", "Noodles", "Sides"];
  bool _isAvailable = true;

  // Image Selection & Loading State
  File? _imageFile;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Compresses image to save bandwidth
    );

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  // Upload to Cloudinary via HTTP
  Future<String?> _uploadToCloudinary() async {
    if (_imageFile == null) return null;

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        return jsonMap['secure_url']; // The public link to the image
      } else {
        debugPrint("Upload failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _saveItem() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Upload Image to Cloudinary (if selected)
      String? uploadedImageUrl = await _uploadToCloudinary();

      // 2. Save to Firestore (Preserving your logic)
      await FirebaseFirestore.instance.collection('menu_item').add({
        'name': _nameController.text.trim(),
        'description': _descController.text.trim(),
        'category': _selectedCategory,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'isAvailable': _isAvailable,
        'imageUrl': uploadedImageUrl ?? 'assets/yattskitchenlogo.png', // Default if no image
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("New item added successfully!")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving item: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFFFF5E1),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Add New Menu Item",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildLabel("Item Name *"),
                  _buildTextField(_nameController, hint: "e.g., Nasi Goreng Special"),

                  const SizedBox(height: 15),

                  _buildLabel("Description *"),
                  _buildTextField(_descController, hint: "Describe your dish in detail", maxLines: 1),

                  const SizedBox(height: 15),

                  _buildLabel("Category *"),
                  _buildDropdown(),

                  const SizedBox(height: 15),

                  _buildLabel("Price (RM) *"),
                  _buildTextField(_priceController, hint: "e.g., 9.00", isNumber: true),

                  const SizedBox(height: 20),

                  // --- IMAGE UPLOAD BOX ---
                  const Text("Upload Image", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
                        // Show preview if image is selected
                        image: _imageFile != null
                            ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: _imageFile == null
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(Icons.camera_alt_outlined, color: Colors.orange, size: 30),
                          ),
                          const SizedBox(height: 10),
                          const Text("Click to upload image", style: TextStyle(color: Colors.grey)),
                          const Text("PNG, JPG up to 5MB", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- AVAILABILITY ---
                  const Text("Availability", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_isAvailable ? "Available" : "Unavailable"),
                        Switch(
                          value: _isAvailable,
                          activeColor: Colors.orange,
                          onChanged: (val) => setState(() => _isAvailable = val),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- BUTTONS ---
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _saveItem,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9933),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text("Save Item", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
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
        // --- LOADING OVERLAY ---
        if (_isLoading)
          Container(
            color: Colors.black45,
            child: const Center(child: CircularProgressIndicator(color: Colors.orange)),
          ),
      ],
    );
  }

  // UI Helpers
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          text: text.replaceAll('*', ''),
          style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w500),
          children: [
            if (text.contains('*'))
              const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          hint: const Text("Select Category", style: TextStyle(color: Colors.grey, fontSize: 14)),
          isExpanded: true,
          items: _categories.map((String category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
          onChanged: (val) => setState(() => _selectedCategory = val),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {String hint = "", int maxLines = 1, bool isNumber = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../cart/cart_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final service = CartService.instance;
    _nameController = TextEditingController(text: service.adminName);
    _emailController = TextEditingController(text: service.adminEmail);
    _phoneController = TextEditingController(text: service.adminPhone);
  }

  // --- LOGIC: SAVE TO FIREBASE ---
  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      // UPDATED TO MATCH YOUR FIRESTORE STRUCTURE
      await FirebaseFirestore.instance.collection('admins').doc(user.uid).set({
        'username': _nameController.text.trim(), // Changed from 'name'
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(), // Changed from 'phone'
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      CartService.instance.updateAdminProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Updated!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : SingleChildScrollView(
        child: Column(
          children: [
            _buildAdminHeader(context, _nameController.text),
            const SizedBox(height: 20),
            const CircleAvatar(
                radius: 70,
                backgroundColor: Color(0xFFFFCC99),
                child: Icon(Icons.person_outline, size: 80, color: Colors.black54)
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  _textField("Username", _nameController),
                  _textField("Email", _emailController),
                  _textField("Phone No", _phoneController),
                  const SizedBox(height: 30),

                  // --- BUTTON ROW (CANCEL & SAVE) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // CANCEL BUTTON
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("CANCEL", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      // SAVE BUTTON
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF7E21),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                        ),
                        onPressed: _saveProfile,
                        child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(color: const Color(0xFFFFCC99), borderRadius: BorderRadius.circular(10)),
            child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10)
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminHeader(BuildContext context, String name) {
    return Container(
      height: 180, width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFF1C40F), Color(0xFFE67E22)]),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Center(
          child: Text(
              "Hello, $name!",
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)
          )
      ),
    );
  }
}
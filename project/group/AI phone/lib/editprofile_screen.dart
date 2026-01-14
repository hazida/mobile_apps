import 'package:flutter/material.dart';
import 'cart_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final service = CartService.instance;
    _nameController = TextEditingController(text: service.adminName);
    _emailController = TextEditingController(text: service.adminEmail);
    _phoneController = TextEditingController(text: service.adminPhone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAdminHeader(context, CartService.instance.adminName),
            const SizedBox(height: 20),
            const CircleAvatar(radius: 70, backgroundColor: Color(0xFFFFCC99), child: Icon(Icons.person_outline, size: 80, color: Colors.black54)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold)),
                  _textField("Username", _nameController),
                  _textField("Email", _emailController),
                  _textField("Phone No", _phoneController),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7E21)),
                      onPressed: () {
                        CartService.instance.updateAdminProfile(
                          name: _nameController.text,
                          email: _emailController.text,
                          phone: _phoneController.text,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text("SAVE", style: TextStyle(color: Colors.white)),
                    ),
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
            height: 35, decoration: BoxDecoration(color: const Color(0xFFFFCC99), borderRadius: BorderRadius.circular(10)),
            child: TextField(controller: controller, decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12))),
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
      child: Center(child: Text("Hello, $name!", style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic))),
    );
  }
}
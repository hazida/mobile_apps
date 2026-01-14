import 'package:flutter/material.dart';
import 'cart_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      body: Column(
        children: [
          _buildAdminHeader(context),
          const SizedBox(height: 20),
          const CircleAvatar(radius: 70, backgroundColor: Color(0xFFFFCC99), child: Icon(Icons.lock_reset, size: 80, color: Colors.black54)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Change Password", style: TextStyle(fontWeight: FontWeight.bold)),
                _textField("New Password", _passController, true),
                _textField("Confirm Password", _confirmPassController, true),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF7E21)),
                    onPressed: () {
                      if (_passController.text == _confirmPassController.text && _passController.text.isNotEmpty) {
                        CartService.instance.updateAdminPassword(_passController.text);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("SAVE", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller, bool obscure) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 5),
          Container(
            height: 35, decoration: BoxDecoration(color: const Color(0xFFFFCC99), borderRadius: BorderRadius.circular(10)),
            child: TextField(controller: controller, obscureText: obscure, decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12))),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminHeader(BuildContext context) {
    return Container(
      height: 180, width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFF1C40F), Color(0xFFE67E22)]),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: const Center(child: Text("Security", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
    );
  }
}
import 'package:flutter/material.dart';
import 'editprofile_screen.dart';
import 'changepassword_screen.dart';
import 'cart_service.dart';

class AdminProfileOptionsScreen extends StatefulWidget {
  const AdminProfileOptionsScreen({super.key});

  @override
  State<AdminProfileOptionsScreen> createState() =>
      _AdminProfileOptionsScreenState();
}

class _AdminProfileOptionsScreenState extends State<AdminProfileOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    final name = CartService.instance.adminName;

    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      body: Column(
        children: [
          _buildAdminHeader(context, name),
          const SizedBox(height: 40),
          const CircleAvatar(
            radius: 80,
            backgroundColor: Color(0xFFFFCC99),
            child: Icon(Icons.person_outline, size: 100, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          _actionButton(context, "View Profile", const EditProfileScreen()),
          const SizedBox(height: 15),
          _actionButton(
            context,
            "Change Password",
            const ChangePasswordScreen(),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, String text, Widget target) {
    return SizedBox(
      width: 200,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF7E21),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => target),
          );
          setState(() {}); // Refresh name when returning
        },
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

Widget _buildAdminHeader(BuildContext context, String name) {
  return Container(
    height: 180,
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
    child: Padding(
      padding: const EdgeInsets.only(top: 40, left: 10),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Hello, $name!",
                    style: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const Text(
            "Yatt's Kitchen",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Text("Hutan Melintang", style: TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}

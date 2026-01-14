import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  bool _isLoading = false;

  // --- LOGIC: UPDATE FIREBASE AUTH PASSWORD ---
  Future<void> _updatePassword() async {
    // 1. Basic Validation
    if (_passController.text.isEmpty || _confirmPassController.text.isEmpty) {
      _showSnackBar("Please fill in all fields", Colors.red);
      return;
    }

    if (_passController.text != _confirmPassController.text) {
      _showSnackBar("Passwords do not match", Colors.red);
      return;
    }

    if (_passController.text.length < 6) {
      _showSnackBar("Password must be at least 6 characters", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // 2. Update the password in Firebase Auth
        await user.updatePassword(_passController.text);

        if (mounted) {
          _showSnackBar("Password updated successfully!", Colors.green);
          Navigator.pop(context);
        }
      }
    } on FirebaseAuthException catch (e) {
      // 3. Handle Re-authentication error
      if (e.code == 'requires-recent-login') {
        _showSnackBar("For security, please log out and log in again to change your password.", Colors.orange);
      } else {
        _showSnackBar(e.message ?? "An error occurred", Colors.red);
      }
    } catch (e) {
      _showSnackBar("Error: $e", Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAdminHeader(context),
            const SizedBox(height: 20),
            const CircleAvatar(
                radius: 70,
                backgroundColor: Color(0xFFFFCC99),
                child: Icon(Icons.lock_reset, size: 80, color: Colors.black54)
            ),
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
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7E21),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                      ),
                      onPressed: _isLoading ? null : _updatePassword,
                      child: _isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  // --- UI COMPONENTS ---
  Widget _textField(String label, TextEditingController controller, bool obscure) {
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
                obscureText: obscure,
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

  Widget _buildAdminHeader(BuildContext context) {
    return Container(
      height: 180, width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFF1C40F), Color(0xFFE67E22)]),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: const Center(
          child: Text(
              "Security",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
          )
      ),
    );
  }
}
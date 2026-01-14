import 'package:flutter/material.dart';
import 'queuesystem_screen.dart'; 
import 'adminprofileoptions_screen.dart'; 
import 'notificationsettings_screen.dart'; 
import 'pricingsettings_screen.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final String adminName = "Admin"; 
  final String? profileImageUrl = null; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      body: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminProfileOptionsScreen()),
                    );
                  },
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFCC99),
                      shape: BoxShape.circle,
                    ),
                    child: profileImageUrl == null 
                      ? const Icon(Icons.person_outline, size: 80, color: Colors.black54)
                      : ClipOval(child: Image.network(profileImageUrl!, fit: BoxFit.cover)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  adminName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              children: [
                _settingsButton("Queue System", Icons.list_alt, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QueueSystemScreen()),
                  );
                }),

                _settingsButton("Notification", Icons.notifications_none, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
                  );
                }),
                _settingsButton("Pricing", Icons.attach_money, () {
                  Navigator.push(
                    context, 
                     MaterialPageRoute(builder: (context) => const PricingScreen()), // Change this line
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 25, left: 20, right: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF1C40F), Color(0xFFE67E22)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: const Column(
        children: [
          Text("Admin Settings", style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text("Configure YATT's Kitchen system", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _settingsButton(String text, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        height: 50, 
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF7E21),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 15),
              Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
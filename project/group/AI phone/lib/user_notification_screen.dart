import 'package:flutter/material.dart';
import 'order_service.dart';

class UserNotificationScreen extends StatelessWidget {
  const UserNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0), // Light cream background
      // Wrap in ListenableBuilder so it updates when notifications are cleared
      body: ListenableBuilder(
        listenable: OrderService.instance,
        builder: (context, child) {
          final notifications = OrderService.instance.customerNotifications;

          return Column(
            children: [
              // --- CUSTOM GRADIENT HEADER ---
              Container(
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 25),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFCC33), Color(0xFFFF9900)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // --- UPDATED: Back Button (No Decoration, Black Icon) ---
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            // Decoration removed
                            child: const Icon(Icons.arrow_back, color: Colors.black),
                          ),
                        ),
                        
                        // Notification Icon (Already has no decoration)
                        const Icon(Icons.notifications_none, color: Colors.black, size: 28),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Notifications",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const Text(
                      "Stay updated with your orders",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              // --- BODY CONTENT ---
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // "Mark all as read" Button
                      TextButton(
                        onPressed: () {
                          // Clear the notifications
                          OrderService.instance.clearNotifications();
                        },
                        child: const Text(
                          "Mark all as read",
                          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // Section Title
                      const Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Today", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                          ),
                          Expanded(child: Divider(color: Colors.grey)),
                        ],
                      ),
                      
                      const SizedBox(height: 20),

                      if (notifications.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text("No notifications yet.", style: TextStyle(color: Colors.grey)),
                        )
                      else
                        ...notifications.reversed.map((notif) => _buildNotificationCard(notif)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notif) {
    IconData icon;
    String title = notif['title'];
    
    // Choose icon based on title/status
    if (title.contains("Ready")) {
      icon = Icons.inventory_2_outlined; // Pickup icon
    } else if (title.contains("Preparing")) {
      icon = Icons.soup_kitchen_outlined; // Chef/Cooking icon
    } else if (title.contains("Verified")) {
      icon = Icons.verified_user_outlined; // Verification
    } else {
      icon = Icons.check_circle_outline; // Default confirm
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: Colors.black),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notif['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  notif['message'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      notif['time'],
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
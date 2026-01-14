import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class UserNotificationScreen extends StatefulWidget {
  const UserNotificationScreen({super.key});

  @override
  State<UserNotificationScreen> createState() => _UserNotificationScreenState();
}

class _UserNotificationScreenState extends State<UserNotificationScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _lastNotifId; // Tracks the newest ID to prevent sound loops

  @override
  void dispose() {
    _audioPlayer.dispose(); // Clean up memory
    super.dispose();
  }

  // Trigger sound alert
  Future<void> _triggerSound() async {
    try {
      await _audioPlayer.play(AssetSource('alert.mp3'));
    } catch (e) {
      debugPrint("Sound Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get current user ID to filter personal notifications
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // Filter: Only show notifications meant for this specific user
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('customerUid', isEqualTo: currentUserId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading notifications."));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.orange));
                }

                final docs = snapshot.data?.docs ?? [];

                // --- SOUND LOGIC ---
                if (docs.isNotEmpty) {
                  var newestDoc = docs.first;
                  // Only play sound if this is a brand new notification ID
                  if (_lastNotifId != newestDoc.id) {
                    _lastNotifId = newestDoc.id;
                    _triggerSound();
                  }
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      _buildDateDivider("Recent Notifications"),
                      const SizedBox(height: 20),

                      if (docs.isEmpty)
                        _buildEmptyState()
                      else
                        ...docs.map((doc) {
                          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

                          // Check if 'isRead' field exists and is false
                          bool isUnread = data['isRead'] == false;

                          return _buildNotificationCard(data, isUnread, doc.id);
                        }),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeader(BuildContext context) {
    return Container(
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
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              const Icon(Icons.notifications_active, color: Colors.black, size: 28),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Notifications", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const Text("Stay updated with your orders", style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notif, bool isUnread, String docId) {
    String displayTime = "Just now";
    if (notif['timestamp'] != null) {
      DateTime dt = (notif['timestamp'] as Timestamp).toDate();
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      displayTime = "$hour:$minute $period";
    }

    return GestureDetector(
      onTap: () {
        // Mark as read in Firestore when tapped
        FirebaseFirestore.instance
            .collection('notifications')
            .doc(docId)
            .update({'isRead': true});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isUnread ? Colors.orange.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: isUnread ? Border.all(color: Colors.orange.withOpacity(0.2), width: 1) : null,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFFDEBD0),
                  child: Icon(Icons.notifications_active_outlined,
                      size: 24,
                      color: isUnread ? Colors.orange : const Color(0xFFE67E22)
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(notif['title'] ?? "Update",
                              style: TextStyle(
                                  fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                  fontSize: 15
                              )
                          ),
                          Text(displayTime, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(notif['message'] ?? "",
                          style: TextStyle(color: Colors.grey[600], fontSize: 13)
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // --- THE RED DOT BADGE ---
            if (isUnread)
              Positioned(
                right: -5,
                top: -5,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text("No notifications yet.", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildDateDivider(String label) {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
        ),
        const Expanded(child: Divider(thickness: 1)),
      ],
    );
  }
}
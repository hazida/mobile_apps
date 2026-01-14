import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../admin_alert_services.dart'; // Ensure this path is correct

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // We store the last notification ID to prevent the sound from playing repeatedly
  String? _lastPlayedId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      // Listen to Admin Settings first
      stream: FirebaseFirestore.instance
          .collection('settings')
          .doc('admin_notifications')
          .snapshots(),
      builder: (context, settingsSnapshot) {
        bool isEnabled = true;
        if (settingsSnapshot.hasData && settingsSnapshot.data!.exists) {
          isEnabled = settingsSnapshot.data!['orderNotifications'] ?? true;
        }

        // If Disabled, show the header with a "Disabled" message
        if (!isEnabled) {
          return Scaffold(
            backgroundColor: const Color(0xFFF9EBDD),
            body: Column(
              children: [
                _buildHeader(context),
                const Spacer(),
                const Icon(
                  Icons.notifications_off,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Order alerts are currently disabled.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const Spacer(),
              ],
            ),
          );
        }

        // If Enabled, show the standard notification list
        return _buildNotificationList(context);
      },
    );
  }

  Widget _buildNotificationList(BuildContext context) {
    final Stream<QuerySnapshot> _notificationStream = FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Live Order Updates",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _notificationStream,
              builder: (context, snapshot) {
                // --- SOUND ALERT LOGIC ---
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  var newestDoc = snapshot.data!.docs.first;
                  var timestamp = (newestDoc['timestamp'] as Timestamp?)
                      ?.toDate();

                  // Trigger sound if notification is newer than 10 seconds AND we haven't played it yet
                  if (timestamp != null &&
                      DateTime.now().difference(timestamp).inSeconds < 10 &&
                      _lastPlayedId != newestDoc.id) {
                    _lastPlayedId =
                        newestDoc.id; // Mark as played to prevent loops
                    AdminAlertService.triggerAlert(newestDoc.id);
                  }
                }

                if (snapshot.hasError)
                  return const Center(
                    child: Text("Error loading notifications"),
                  );
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "No notifications yet.",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    String displayTime = _formatTimestamp(data['timestamp']);

                    String title = data['title'] ?? "Order Update";
                    Color tagColor = _getTagColor(title);

                    // A notification is "New" (Red Dot) if it arrived in the last 2 minutes
                    bool isNew = false;
                    if (data['timestamp'] != null) {
                      DateTime dt = (data['timestamp'] as Timestamp).toDate();
                      isNew = DateTime.now().difference(dt).inMinutes < 2;
                    }

                    return _notifItem(
                      title,
                      data['message'] ?? "",
                      displayTime,
                      "Queue #${data['queueNumber'] ?? 'N/A'}",
                      tagColor,
                      isNew,
                    );
                  },
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
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30),
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
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    "Hello, Admin!",
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
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
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Hutan Melintang",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _notifItem(
    String title,
    String sub,
    String date,
    String tag,
    Color tagColor,
    bool showDot,
  ) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sub,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- THE RED DOT BADGE ---
        if (showDot)
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  // --- HELPER LOGIC ---

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return "Just now";
    DateTime dt = (timestamp as Timestamp).toDate();
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $period";
  }

  Color _getTagColor(String title) {
    if (title.contains("Declined")) return Colors.red;
    if (title.contains("Accepted")) return Colors.green;
    if (title.contains("Ready")) return Colors.blue;
    if (title.contains("Cash"))
      return Colors.teal; // Added color for Cash Payment alert
    return const Color(0xFFE67E22);
  }
}

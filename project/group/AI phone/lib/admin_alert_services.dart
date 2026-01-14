import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AdminAlertService {
  static final AudioPlayer _player = AudioPlayer();
  static String? _lastNotificationId; // Prevents sound looping

  static Future<void> triggerAlert(String docId) async {
    // 1. If we already played sound for this specific notification, stop.
    if (_lastNotificationId == docId) return;

    try {
      // 2. Check Firestore Settings
      var snapshot = await FirebaseFirestore.instance
          .collection('settings')
          .doc('admin_notifications')
          .get();

      if (!snapshot.exists) return;

      bool orderNotifications = snapshot.data()?['orderNotifications'] ?? true;
      bool soundAlerts = snapshot.data()?['soundAlerts'] ?? true;

      // 3. Only play if Admin enabled both
      if (orderNotifications && soundAlerts) {
        _lastNotificationId = docId; // Mark as played
        await _player.play(AssetSource('alert.mp3'));
        debugPrint("Alert Sound Played for: $docId");
      }
    } catch (e) {
      debugPrint("Error in AdminAlertService: $e");
    }
  }
}
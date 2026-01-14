import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user/FoodMenuScreen.dart'; // Ensure this points to where your FoodItem model is

class MenuService extends ChangeNotifier {
  static final MenuService _instance = MenuService._internal();
  factory MenuService() => _instance;
  MenuService._internal();
  static MenuService get instance => _instance;

  final CollectionReference _menuCollection =
  FirebaseFirestore.instance.collection('menu_item');

  // FIX: Added this getter to prevent "items isn't defined" error in UI
  List<FoodItem> get items => [];

  // --- GET DATA (STREAM) ---
  Stream<List<FoodItem>> get menuStream {
    return _menuCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return FoodItem(
          name: data['name'] ?? 'Unknown',
          description: data['description'] ?? '',
          price: data['price']?.toString() ?? '0.00',
          category: data['category'] ?? 'Rice',
          imagePath: data['imageUrl'] ?? '',
          isPopular: data['isPopular'] ?? false,
        );
      }).toList();
    });
  }

  // --- ACTIONS ---
  Future<void> addItem(FoodItem item) async {
    await _menuCollection.add({
      'name': item.name,
      'description': item.description,
      'price': item.price,
      'category': item.category,
      'imageUrl': item.imagePath,
      'isPopular': item.isPopular,
      'isAvailable': true,
    });
  }

  Future<void> deleteItem(String docId) async {
    await _menuCollection.doc(docId).delete();
  }
}
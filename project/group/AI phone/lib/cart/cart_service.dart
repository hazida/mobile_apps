import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --- CART ITEM MODEL ---
class CartItem {
  final String name;
  final double price;
  int quantity;
  final String imagePath;

  CartItem({
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.imagePath,
  });

  // Helper to convert to Map for Firestore orders
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'imagePath': imagePath,
    };
  }
}

// --- CART SERVICE SINGLETON ---
class CartService extends ChangeNotifier {
  // Singleton Setup
  static final CartService _instance = CartService._internal();
  CartService._internal();
  static CartService get instance => _instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Admin Profile State ---
  String _adminName = "Admin";
  String _adminEmail = "";
  String _adminPhone = "";
  String _adminPassword = ""; // For local reference

  String get adminName => _adminName;
  String get adminEmail => _adminEmail;
  String get adminPhone => _adminPhone;

  // --- Pricing State ---
  String _currency = "RM";
  double _taxRate = 0.0;
  double _serviceChargeRate = 0.0;

  String get currency => _currency;
  double get taxRate => _taxRate;
  double get serviceChargeRate => _serviceChargeRate;

  // --- Cart State ---
  final List<CartItem> _items = [];
  List<CartItem> get items => _items;

  String _orderType = "Dine In";
  String get orderType => _orderType;

  // --- 1. FIRESTORE: LOAD PROFILE ---
  Future<void> loadAdminProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await _db
            .collection('admins')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          var data = doc.data() as Map<String, dynamic>;
          _adminName = data['name'] ?? "Admin";
          _adminEmail = data['email'] ?? "";
          _adminPhone = data['phone'] ?? "";
          notifyListeners();
        }
      } catch (e) {
        debugPrint("Error loading profile: $e");
      }
    }
  }

  // --- 2. FIRESTORE: PRICING LISTENER ---
  void initPricingListener() {
    _db.collection('settings').doc('pricing_config').snapshots().listen((
      snapshot,
    ) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        _currency = data['currency'] ?? "RM";
        _taxRate = double.tryParse(data['tax'].toString()) ?? 0.0;
        _serviceChargeRate = double.tryParse(data['service'].toString()) ?? 0.0;
        notifyListeners();
      }
    });
  }

  // --- Logic: Update Operations ---
  void updateAdminProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    _adminName = name;
    _adminEmail = email;
    _adminPhone = phone;
    notifyListeners();
  }

  void updatePricingSettings({
    required String currency,
    required double tax,
    required double service,
  }) {
    _currency = currency;
    _taxRate = tax;
    _serviceChargeRate = service;
    notifyListeners();
  }

  void setOrderType(String type) {
    _orderType = type;
    notifyListeners();
  }

  // --- Logic: Price Calculations ---
  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  double get totalAmount {
    double serviceAmount = subtotal * (_serviceChargeRate / 100);
    double taxAmount = subtotal * (_taxRate / 100);
    return subtotal + serviceAmount + taxAmount;
  }

  // --- Logic: Cart Operations ---
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void updateQuantity(CartItem item, int change) {
    item.quantity += change;
    if (item.quantity < 1) {
      removeItem(item);
    } else {
      notifyListeners();
    }
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void addItemFromData(Map<String, dynamic> data, String docId) {
    final String name = data['name'] ?? 'Unknown';
    final String imageUrl = data['imageUrl'] ?? '';
    double priceValue = double.tryParse(data['price'].toString()) ?? 0.0;

    try {
      final existingItem = _items.firstWhere((item) => item.name == name);
      existingItem.quantity += 1;
    } catch (e) {
      _items.add(
        CartItem(
          name: name,
          price: priceValue,
          quantity: 1,
          imagePath: imageUrl,
        ),
      );
    }
    notifyListeners();
  }
}

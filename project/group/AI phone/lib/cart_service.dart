import 'package:flutter/foundation.dart'; 
import 'FoodMenuScreen.dart'; 

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
}

// --- CART SERVICE SINGLETON ---
class CartService extends ChangeNotifier {
  // Singleton Setup
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();
  static CartService get instance => _instance;

  // --- Admin State ---
  String _adminName = "admin";
  String _adminPassword = "admin1234";
  String _adminEmail = "admin@yattkitchen.com";
  String _adminPhone = "012-3456789";

  String get adminName => _adminName;
  String get adminPassword => _adminPassword;
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
  String _orderType = "Dine In"; 
  String get orderType => _orderType;

  // --- Logic: Update Admin Profile ---
  void updateAdminProfile({required String name, required String email, required String phone}) {
    _adminName = name;
    _adminEmail = email;
    _adminPhone = phone;
    notifyListeners();
  }

  // --- Logic: Update Admin Password ---
  void updateAdminPassword(String newPassword) {
    _adminPassword = newPassword;
    notifyListeners();
  }

  // --- Logic: Update Pricing (Currency only visible in UI) ---
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

  // --- Logic: Set Order Type ---
  void setOrderType(String type) {
    _orderType = type;
    notifyListeners();
  }
  
  List<CartItem> get items => _items;

  // --- Logic: Price Calculations ---
  double get subtotal => _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  double get totalAmount {
    // Math remains valid but results in 0 if rates are set to 0
    double serviceAmount = subtotal * (_serviceChargeRate / 100);
    double taxAmount = subtotal * (_taxRate / 100);
    return subtotal + serviceAmount + taxAmount; 
  }
  
  // --- Logic: Cart Operations ---
  void clearCart() {
    _items.clear(); 
    notifyListeners(); 
  }

  void addItem(FoodItem foodItem) {
    if (foodItem.price == null) return; 
    try {
      final existingItem = _items.firstWhere((item) => item.name == foodItem.name);
      existingItem.quantity += 1;
    } catch (e) {
      _items.add(CartItem(
          name: foodItem.name,
          price: double.tryParse(foodItem.price!) ?? 0.0, 
          quantity: 1,
          imagePath: foodItem.imagePath, 
      ));
    }
    notifyListeners(); 
  }

  void updateQuantity(CartItem item, int change) {
    item.quantity += change;
    if (item.quantity < 1) {
      removeItem(item);
      return; 
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }
}
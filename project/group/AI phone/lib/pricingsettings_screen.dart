import 'package:flutter/material.dart';
import 'cart_service.dart';

class PricingScreen extends StatefulWidget {
  const PricingScreen({super.key});

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  // Logic remains: Controllers still exist to prevent code errors
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _taxController = TextEditingController(text: "0");
  final TextEditingController _serviceController = TextEditingController(text: "0");

  double _subtotal = 10.00;
  double _serviceAmount = 0.00;
  double _taxAmount = 0.00;
  double _total = 10.00;

  @override
  void initState() {
    super.initState();
    final service = CartService.instance;
    _currencyController.text = service.currency;
    
    _currencyController.addListener(_calculateLogic);
    _calculateLogic();
  }

  @override
  void dispose() {
    _currencyController.dispose();
    _taxController.dispose();
    _serviceController.dispose();
    super.dispose();
  }

  void _calculateLogic() {
    setState(() {
      double taxRate = double.tryParse(_taxController.text) ?? 0;
      double serviceRate = double.tryParse(_serviceController.text) ?? 0;

      _serviceAmount = _subtotal * (serviceRate / 100);
      _taxAmount = _subtotal * (taxRate / 100);
      _total = _subtotal + _serviceAmount + _taxAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    String currency = _currencyController.text.isEmpty ? "RM" : _currencyController.text;

    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      body: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Pricing Configuration",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const Text("Set up your preferred currency symbol",
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 25),
                    
                    // Displaying ONLY Currency per your request
                    _inputField("Currency Symbol", _currencyController, isNumber: false),
                    
                    const SizedBox(height: 20),
                    
                    // Calculation Example Box (Hidden Tax/Service lines)
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEEAD4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFCC99)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Pricing Preview",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          _calculationRow("Item Price:", "$currency ${_subtotal.toStringAsFixed(2)}"),
                          const Divider(color: Colors.black54),
                          // Total now shows directly without Tax/Service lines
                          _calculationRow("Display Total:", "$currency ${_total.toStringAsFixed(2)}", isTotal: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          CartService.instance.updatePricingSettings(
                            currency: _currencyController.text.isEmpty ? "RM" : _currencyController.text,
                            tax: 0, // Logic: Force 0 if not displayed
                            service: 0, // Logic: Force 0 if not displayed
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Currency updated!'), backgroundColor: Colors.green),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFCC99),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("SAVE", 
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Center(
            child: Column(
              children: [
                Text("Admin Settings", style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text("System Configuration", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller, {required bool isNumber}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE67E22)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _calculationRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
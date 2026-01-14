import 'package:flutter/material.dart';

class QueueSystemScreen extends StatefulWidget {
  const QueueSystemScreen({super.key});

  @override
  State<QueueSystemScreen> createState() => _QueueSystemScreenState();
}

class _QueueSystemScreenState extends State<QueueSystemScreen> {
  bool resetDaily = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Queue System Configuration", 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text("Manage queue numbers and customer flow", 
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                    
                    const SizedBox(height: 25),
                    
                    _buildInputField("Queue Number Prefix", "e.g. A"),
                    _buildInputField("Starting Queue Number", "e.g. 001"),
                    _buildInputField("Max Queue Per Hour", "e.g. 50"),

                    const SizedBox(height: 10),

                    // Reset Queue Daily Toggle
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Reset Queue Daily", style: TextStyle(fontWeight: FontWeight.bold)),
                              Text("Start from beginning each day", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          Switch(
                            value: resetDaily,
                            activeColor: Colors.orange,
                            onChanged: (val) => setState(() => resetDaily = val),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Queue Format Preview
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Queue Format Preview", style: TextStyle(fontWeight: FontWeight.bold)),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(color: Colors.black, fontSize: 13),
                              children: [
                                TextSpan(text: "Current format: "),
                                TextSpan(text: "A001", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                TextSpan(text: " (e.g A001, A002,...)"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Save Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFCC80),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: const Text("SAVE", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
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
                  child: Text("Admin Settings", 
                    style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 48), // Balancing the back button
            ],
          ),
          const Text("Configure YATT's Kitchen system", 
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            ),
          ),
        ],
      ),
    );
  }
}
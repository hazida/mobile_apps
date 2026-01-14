import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QueueSystemScreen extends StatefulWidget {
  const QueueSystemScreen({super.key});

  @override
  State<QueueSystemScreen> createState() => _QueueSystemScreenState();
}

class _QueueSystemScreenState extends State<QueueSystemScreen> {
  // 1. Define Controllers to manage text input
  final TextEditingController _prefixController = TextEditingController();
  final TextEditingController _startNumberController = TextEditingController();
  final TextEditingController _maxPerHourController = TextEditingController();
  bool resetDaily = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQueueSettings();
  }

  // 2. Load existing settings from Firestore
  Future<void> _loadQueueSettings() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('settings')
          .doc('queue_config')
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          _prefixController.text = data['prefix'] ?? 'A';
          _startNumberController.text = data['startNumber'] ?? '001';
          _maxPerHourController.text = data['maxPerHour']?.toString() ?? '50';
          resetDaily = data['resetDaily'] ?? true;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error loading settings: $e");
      setState(() => isLoading = false);
    }
  }

  // 3. Save settings to Firestore
  Future<void> _saveSettings() async {
    try {
      // Show a loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Prepare the data
      final data = {
        'prefix': _prefixController.text.trim().toUpperCase(),
        'startNumber': _startNumberController.text.trim(),
        'maxPerHour': int.tryParse(_maxPerHourController.text) ?? 50, // Use tryParse to prevent crash
        'resetDaily': resetDaily,
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('settings')
          .doc('queue_config')
          .set(data, SetOptions(merge: true)); // Merge ensures we don't overwrite other settings

      if (mounted) {
        Navigator.pop(context); // Remove loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Settings Saved Successfully!"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Remove loading
      print("FIREBASE SAVE ERROR: $e"); // CHECK YOUR CONSOLE FOR THIS
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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

                    _buildInputField("Queue Number Prefix", "e.g. A", _prefixController),
                    _buildInputField("Starting Queue Number", "e.g. 001", _startNumberController),
                    _buildInputField("Max Queue Per Hour", "e.g. 50", _maxPerHourController),

                    const SizedBox(height: 10),

                    // Reset Daily Toggle
                    _buildResetToggle(),

                    const SizedBox(height: 20),

                    // Live Preview
                    _buildPreview(),

                    const SizedBox(height: 30),

                    // Save Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _saveSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFCC80),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  // --- UI COMPONENTS ---

  Widget _buildInputField(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            onChanged: (val) => setState(() {}), // Update preview as you type
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Queue Format Preview", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            "Current format: ${_prefixController.text}${_startNumberController.text}",
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildResetToggle() {
    return Container(
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
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
          const Expanded(child: Center(child: Text("Admin Settings", style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold)))),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
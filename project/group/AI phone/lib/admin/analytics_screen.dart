import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'report_screen.dart';
import '../notification/notifications_screen.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedView = "Weekly";
  final List<String> _viewOptions = ["Daily", "Weekly", "Monthly"];
  bool _isLoading = false;

  List<Map<String, dynamic>> topSellers = [];
  Map<String, double> salesData = {};
  double totalRevenue = 0.0;
  String totalOrders = "0";
  String avgOrderValue = "RM 0.00";

  @override
  void initState() {
    super.initState();
    _fetchBackendData();
  }

  // --- REAL FIRESTORE LOGIC ---
  Future<void> _fetchBackendData() async {
    setState(() => _isLoading = true);

    DateTime now = DateTime.now();
    DateTime startRange;

    if (_selectedView == "Daily") {
      startRange = DateTime(now.year, now.month, now.day);
    } else if (_selectedView == "Weekly") {
      startRange = now.subtract(const Duration(days: 7));
    } else {
      startRange = DateTime(now.year, now.month - 1, now.day);
    }

    try {
      // 1. MATCHING YOUR DATABASE: 'Completed' with capital C
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('status', isEqualTo: 'Completed')
          .where('timestamp', isGreaterThanOrEqualTo: startRange)
          .get();

      double revenueSum = 0.0;
      Map<String, int> itemQuantities = {};
      Map<String, double> chartData = {};

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // 2. MATCHING YOUR DATABASE: 'totalAmount'
        double amount = (data['totalAmount'] ?? 0.0).toDouble();
        revenueSum += amount;

        // Chart Grouping
        DateTime date = (data['timestamp'] as Timestamp).toDate();
        String label = _selectedView == "Daily"
            ? "${date.hour}:00"
            : "${date.day}/${date.month}";
        chartData[label] = (chartData[label] ?? 0) + amount;

        // 3. TOP SELLERS LOGIC
        List items = data['items'] ?? [];
        for (var item in items) {
          String name = item['name'] ?? "Unknown Item";
          // If you don't have a quantity field yet, we count each entry as 1
          int qty = (item['quantity'] ?? 1).toInt();
          itemQuantities[name] = (itemQuantities[name] ?? 0) + qty;
        }
      }

      // Sort to get Top 3
      var sortedItems = itemQuantities.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      List<Map<String, dynamic>> top3Result = [];
      for (var i = 0; i < sortedItems.length && i < 3; i++) {
        top3Result.add({
          "name": sortedItems[i].key,
          "orders": sortedItems[i].value,
          "desc": "Best seller in Yatt's Kitchen", // Default desc
        });
      }

      setState(() {
        totalRevenue = revenueSum;
        totalOrders = querySnapshot.docs.length.toString();
        avgOrderValue = querySnapshot.docs.isNotEmpty
            ? "RM ${(revenueSum / querySnapshot.docs.length).toStringAsFixed(2)}"
            : "RM 0.00";
        topSellers = top3Result;
        salesData = chartData;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Analytics Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _buildSmallStatCard(
                              "Total Revenue",
                              "RM ${totalRevenue.toStringAsFixed(0)}",
                              12.5,
                              true,
                            ),
                            const SizedBox(width: 8),
                            _buildSmallStatCard(
                              "Total Orders",
                              totalOrders,
                              5.0,
                              true,
                            ),
                            const SizedBox(width: 8),
                            _buildSmallStatCard(
                              "Avg Order Value",
                              avgOrderValue,
                              2.1,
                              true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAnalyticsTitleWithDropdown(),
                              const SizedBox(height: 20),
                              _buildFeaturedRevenueCard(totalRevenue),
                              const SizedBox(height: 30),
                              _buildBarChart(salesData),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Top Sellers 🔥",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: topSellers.isEmpty
                              ? [const Text("No completed orders yet.")]
                              : topSellers
                                    .map((food) => _buildFoodItem(food))
                                    .toList(),
                        ),
                        const SizedBox(height: 20),
                        _buildFullReportButton(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // --- UI COMPONENTS (UIUX UNCHANGED) ---

  Widget _buildAnalyticsTitleWithDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Revenue Analytics",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Performance overview",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedView,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 18,
              ),
              dropdownColor: Colors.orange,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              items: _viewOptions
                  .map(
                    (String value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: (newValue) {
                setState(() => _selectedView = newValue!);
                _fetchBackendData();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 28),
              const Expanded(
                child: Center(
                  child: Text(
                    "Hello, Admin!",
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                ),
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Yatt's Kitchen",
            style: TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Hutan Melintang",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatCard(
    String title,
    String value,
    double percent,
    bool isUp,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 105,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  isUp ? Icons.trending_up : Icons.trending_down,
                  color: isUp ? Colors.green : Colors.red,
                  size: 14,
                ),
                Text(
                  "$percent%",
                  style: TextStyle(
                    color: isUp ? Colors.green : Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedRevenueCard(double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF39C12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total This $_selectedView :",
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            "RM ${total.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Text(
                "Synced with Store Status",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              SizedBox(width: 5),
              Icon(Icons.sync, color: Colors.white, size: 14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(Map<String, double> data) {
    if (data.isEmpty)
      return const SizedBox(
        height: 180,
        child: Center(
          child: Text("No sales data", style: TextStyle(color: Colors.grey)),
        ),
      );
    double maxVal = data.values.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) maxVal = 1.0;

    return SizedBox(
      height: 180,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [maxVal.toStringAsFixed(0), "0"]
                .map(
                  (e) => Text(
                    e,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                )
                .toList(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.entries
                  .map(
                    (e) => Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 15,
                          height: 130 * (e.value / maxVal),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(e.key, style: const TextStyle(fontSize: 8)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(Map<String, dynamic> food) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.fastfood, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  food['desc'],
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            "${food['orders']} Sold",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullReportButton() {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ReportScreen()),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.orange.shade100),
        ),
        child: const Center(
          child: Text(
            "Full Report",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

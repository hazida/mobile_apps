import 'package:flutter/material.dart';
import 'report_screen.dart';
import 'notifications_screen.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  // --- STATE VARIABLES ---
  String _selectedView = "Weekly";
  final List<String> _viewOptions = ["Daily", "Weekly", "Monthly"];
  bool _isLoading = false;

  // --- DYNAMIC DATA HOLDERS ---
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

  Future<void> _fetchBackendData() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      if (_selectedView == "Daily") {
        totalRevenue = 1200.0;
        totalOrders = "45";
        avgOrderValue = "RM 26.60";
        salesData = {"9am": 200, "12pm": 500, "3pm": 300, "6pm": 200};
      } else if (_selectedView == "Weekly") {
        totalRevenue = 4950.0;
        totalOrders = "252";
        avgOrderValue = "RM 28.50";
        salesData = {
          "Mon": 1000,
          "Tue": 900,
          "Wed": 650,
          "Thu": 1100,
          "Fri": 750,
          "Sat": 300,
          "Sun": 250,
        };
      } else {
        totalRevenue = 18500.0;
        totalOrders = "980";
        avgOrderValue = "RM 18.80";
        salesData = {"W1": 4000, "W2": 5000, "W3": 4500, "W4": 5000};
      }

      topSellers = [
        {
          "name": "Nasi Ayam Roasted",
          "orders": 101,
          "desc": "flavorful roasted chicken",
        },
        {
          "name": "Nasi Goreng Seafood",
          "orders": 91,
          "desc": "Fried rice with prawns",
        },
        {
          "name": "Kuey Teow Goreng",
          "orders": 60,
          "desc": "Stir-fried flat noodles",
        },
      ];

      _isLoading = false;
    });
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
                              18.5,
                              true,
                            ),
                            const SizedBox(width: 8),
                            _buildSmallStatCard(
                              "Total Orders",
                              totalOrders,
                              23.0,
                              true,
                            ),
                            const SizedBox(width: 8),
                            _buildSmallStatCard(
                              "Avg Order Value",
                              avgOrderValue,
                              8.0,
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

                        // Section Header for Top Sellers (View All Removed)
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
                          children: topSellers
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
                hoverColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.white.withOpacity(0.3),
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
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(15),
          hoverColor: Colors.orange.shade50,
          child: Container(
            padding: const EdgeInsets.all(12),
            height: 105,
            decoration: BoxDecoration(
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isUp ? Icons.trending_up : Icons.trending_down,
                        color: isUp ? Colors.green : Colors.red,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
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
                ),
              ],
            ),
          ),
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
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE67E22).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                "Compared to last period (+12.5%)",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              SizedBox(width: 5),
              Icon(Icons.trending_up, color: Colors.white, size: 14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(Map<String, double> data) {
    if (data.isEmpty) return const SizedBox(height: 180);
    double maxVal = data.values.isEmpty
        ? 1500
        : data.values.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) maxVal = 1500;

    return SizedBox(
      height: 180,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                [
                      maxVal.toStringAsFixed(0),
                      (maxVal / 2).toStringAsFixed(0),
                      "0",
                    ]
                    .map(
                      (e) => Text(
                        e,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          4,
                          (_) =>
                              Divider(color: Colors.grey.shade100, height: 1),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: data.values
                            .map(
                              (v) => Container(
                                width: 20,
                                height: 140 * (v / maxVal),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade400,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1.5, color: Colors.black12),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: data.keys
                      .map(
                        (k) => Text(
                          k,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(Map<String, dynamic> food) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(15),
          hoverColor: Colors.orange.shade50,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.fastfood, color: Colors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        food['desc'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  "${food['orders']} Sold",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullReportButton() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReportScreen()),
        ),
        borderRadius: BorderRadius.circular(15),
        hoverColor: Colors.orange.shade50,
        splashColor: Colors.orange.withOpacity(0.2),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.orange.shade100),
          ),
          child: const Center(
            child: Text(
              "Full Report",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

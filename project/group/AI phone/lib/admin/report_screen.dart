import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  // --- PDF GENERATION LOGIC ---
  Future<void> _generatePdf(Map<String, dynamic> data) async {
    final pdf = pw.Document();
    final now = DateTime.now();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Yatt's Kitchen",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      pw.Text(
                        "Hutan Melintang, Ground Floor\nHutan Melintang, Perak\nPhone: +011-12740368",
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        "SALES REPORT",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      pw.Text(
                        "Report ID: SR-2024-W50",
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                      pw.Text(
                        "Date: 20/12/2025",
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                      pw.Text(
                        "Generated: ${DateFormat('hh:mm a').format(now)}",
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 10),

              // Monthly Performance Table
              pw.Text(
                "MONTHLY PERFORMANCE",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.TableHelper.fromTextArray(
                context: context,
                headers: ['Month Period', 'Orders', 'Revenue', 'Average'],
                data: [
                  [
                    DateFormat('MMMM yyyy').format(now),
                    data['totalOrders'].toString(),
                    "RM ${data['totalRevenue'].toStringAsFixed(2)}",
                    "RM ${(data['totalOrders'] > 0 ? data['totalRevenue'] / data['totalOrders'] : 0).toStringAsFixed(2)}",
                  ],
                ],
              ),

              pw.SizedBox(height: 20),
              pw.Text(
                "TOP MENU",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.TableHelper.fromTextArray(
                context: context,
                headers: ['Rank', 'Menu Name', 'Qty', 'Revenue'],
                data: List.generate(data['topMenu'].length, (index) {
                  final item = data['topMenu'][index];
                  return [
                    (index + 1).toString(),
                    item.key,
                    item.value.toString(),
                    "RM ${data['menuRevenue'][item.key].toStringAsFixed(2)}",
                  ];
                }),
              ),

              pw.Spacer(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Text("_________________"),
                      pw.Text("Manager Signature"),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text("_________________"),
                      pw.Text("Director Signature"),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    // This triggers the download/print dialog
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Yatts_Kitchen_Report_${DateFormat('MMM_yyyy').format(now)}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Current month range for Firestore query
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('timestamp', isGreaterThanOrEqualTo: startOfMonth)
          .where('timestamp', isLessThanOrEqualTo: endOfMonth)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return const Scaffold(
            body: Center(child: Text("Error loading data")),
          );
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final docs = snapshot.data!.docs;
        final reportData = _processReportData(docs);

        return Scaffold(
          backgroundColor: const Color(0xFFF9EBDD),
          appBar: AppBar(
            title: const Text(
              "SALES REPORT PREVIEW",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            backgroundColor: const Color(0xFFE67E22),
            foregroundColor: Colors.white,
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: const Color(0xFFE67E22),
                child: const Text(
                  "Yatts-Kitchen-Monthly-Sales-Report.pdf",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ],
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildReportHeader(),
                        const SizedBox(height: 25),
                        const Text(
                          "EXECUTIVE SUMMARY",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildExecutiveSummary(reportData),
                        const SizedBox(height: 25),
                        const Text(
                          "MONTHLY PERFORMANCE",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildPerformanceTable(reportData),
                        const SizedBox(height: 25),
                        const Text(
                          "TOP MENU",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildTopMenuTable(reportData),
                        const SizedBox(height: 25),
                        const Text(
                          "ORDER TYPES",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildOrderTypesTable(reportData),
                        const SizedBox(height: 25),
                        const Text(
                          "PEAK HOURS",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildPeakHoursTable(reportData),
                        const SizedBox(height: 40),
                        _buildAuthorizationSection(),
                        const SizedBox(height: 40),
                        Center(
                          child: Text(
                            "This is a computer-generated report from Yatt's Kitchen Management System\nConfidential Business Document • Page 1 of 1",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildDownloadButtons(context, reportData),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDownloadButtons(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _generatePdf(data), // Connected the logic
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE67E22),
            ),
            child: const Text(
              "Download PDF",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportHeader() {
    DateTime now = DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.restaurant_menu, color: Colors.red, size: 30),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Yatt's Kitchen",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Restaurant & Catering Services",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Hutan Melintang, Ground Floor\nHutan Melintang, Perak\nPhone: +011-12740368",
              style: TextStyle(
                fontSize: 10,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "SALES REPORT",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            const Text(
              "Report ID: SR-2024-W50",
              style: TextStyle(fontSize: 9, color: Colors.grey),
            ),
            const Text(
              "Period: Dec 13 - Dec 19, 2025",
              style: TextStyle(fontSize: 9, color: Colors.grey),
            ),
            const Text(
              "Date: 20/12/2025",
              style: TextStyle(fontSize: 9, color: Colors.grey),
            ),
            Text(
              "Generated: ${DateFormat('hh:mm AM').format(now)}",
              style: const TextStyle(fontSize: 9, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  // --- CALCULATION LOGIC ---
  Map<String, dynamic> _processReportData(List<QueryDocumentSnapshot> docs) {
    double totalRevenue = 0;
    Map<String, int> menuUsage = {};
    Map<String, double> menuRevenue = {};
    Map<String, int> orderTypes = {"Dine In": 0, "Take Away": 0};

    Map<String, int> peakHourStats = {
      "9:00 AM - 1:00 PM": 0,
      "1:00 PM - 6:00 PM": 0,
      "6:00 PM - 8:00 PM": 0,
      "Other": 0,
    };

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final double amount = (data['totalAmount'] ?? 0).toDouble();
      final DateTime date = (data['timestamp'] as Timestamp).toDate();
      final int hour = date.hour;
      totalRevenue += amount;

      // Peak Hours Categorization
      if (hour >= 9 && hour < 13) {
        peakHourStats["9:00 AM - 1:00 PM"] =
            peakHourStats["9:00 AM - 1:00 PM"]! + 1;
      } else if (hour >= 13 && hour < 18) {
        peakHourStats["1:00 PM - 6:00 PM"] =
            peakHourStats["1:00 PM - 6:00 PM"]! + 1;
      } else if (hour >= 18 && hour < 20) {
        peakHourStats["6:00 PM - 8:00 PM"] =
            peakHourStats["6:00 PM - 8:00 PM"]! + 1;
      } else {
        peakHourStats["Other"] = peakHourStats["Other"]! + 1;
      }

      // Order Type
      orderTypes[data['orderType'] ?? "Dine In"] =
          (orderTypes[data['orderType'] ?? "Dine In"] ?? 0) + 1;

      // Menu Logic
      final List items = data['items'] ?? [];
      for (var item in items) {
        String name = item['name'] ?? "Unknown";
        int qty = item['quantity'] ?? 0;
        menuUsage[name] = (menuUsage[name] ?? 0) + qty;
        menuRevenue[name] =
            (menuRevenue[name] ?? 0) + (qty * (item['price'] ?? 0));
      }
    }

    return {
      'totalRevenue': totalRevenue,
      'totalOrders': docs.length,
      'topMenu':
          (menuUsage.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .take(5)
              .toList(),
      'menuRevenue': menuRevenue,
      'orderTypes': orderTypes,
      'peakHours': peakHourStats,
    };
  }

  // --- UI TABLE COMPONENTS ---

  Widget _buildPerformanceTable(Map<String, dynamic> data) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: const [
            _TableCell("Month Period", isHeader: true),
            _TableCell("Orders", isHeader: true),
            _TableCell("Revenue", isHeader: true),
            _TableCell("Average", isHeader: true),
          ],
        ),
        TableRow(
          children: [
            _TableCell(DateFormat('MMMM yyyy').format(DateTime.now())),
            _TableCell(data['totalOrders'].toString()),
            _TableCell("RM ${data['totalRevenue'].toStringAsFixed(2)}"),
            _TableCell(
              "RM ${(data['totalOrders'] > 0 ? data['totalRevenue'] / data['totalOrders'] : 0).toStringAsFixed(2)}",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPeakHoursTable(Map<String, dynamic> data) {
    final Map<String, int> peakHours = data['peakHours'];
    final int total = data['totalOrders'];

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: const [
            _TableCell("Time Period", isHeader: true),
            _TableCell("Orders", isHeader: true),
            _TableCell("Percentage", isHeader: true),
          ],
        ),
        ...[
          "9:00 AM - 1:00 PM",
          "1:00 PM - 6:00 PM",
          "6:00 PM - 8:00 PM",
          "Other",
        ].map((label) {
          int count = peakHours[label] ?? 0;
          double pct = total > 0 ? (count / total) * 100 : 0;
          return TableRow(
            children: [
              _TableCell(label),
              _TableCell(count.toString()),
              _TableCell("${pct.toStringAsFixed(1)}%"),
            ],
          );
        }).toList(),
      ],
    );
  }

  // (Note: Keep _buildExecutiveSummary, _buildTopMenuTable, _buildOrderTypesTable,
  // _buildAuthorizationSection, _buildDownloadButtons, _TableCell, and _summaryBox
  // helper methods as provided in previous responses to ensure the UI is complete)

  Widget _buildExecutiveSummary(Map<String, dynamic> data) {
    double rev = data['totalRevenue'];
    int ord = data['totalOrders'];
    return Row(
      children: [
        _summaryBox("Total Revenue", "RM ${rev.toStringAsFixed(2)}"),
        _summaryBox("Total Orders", "$ord"),
        _summaryBox(
          "Avg Transaction",
          "RM ${(ord > 0 ? rev / ord : 0).toStringAsFixed(2)}",
        ),
      ],
    );
  }

  Widget _summaryBox(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 8, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopMenuTable(Map<String, dynamic> data) {
    final List topMenu = data['topMenu'];
    final Map revenues = data['menuRevenue'];
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: const [
            _TableCell("Rank", isHeader: true),
            _TableCell("Menu Name", isHeader: true),
            _TableCell("Qty", isHeader: true),
            _TableCell("Revenue", isHeader: true),
          ],
        ),
        for (int i = 0; i < topMenu.length; i++)
          TableRow(
            children: [
              _TableCell((i + 1).toString()),
              _TableCell(topMenu[i].key),
              _TableCell(topMenu[i].value.toString()),
              _TableCell("RM ${revenues[topMenu[i].key].toStringAsFixed(2)}"),
            ],
          ),
      ],
    );
  }

  Widget _buildOrderTypesTable(Map<String, dynamic> data) {
    final Map types = data['orderTypes'];
    final int total = data['totalOrders'];
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: const [
            _TableCell("Order Type", isHeader: true),
            _TableCell("Total Orders", isHeader: true),
            _TableCell("Percentage", isHeader: true),
          ],
        ),
        ...types.entries.map((e) {
          double pct = total > 0 ? (e.value / total) * 100 : 0;
          return TableRow(
            children: [
              _TableCell(e.key),
              _TableCell(e.value.toString()),
              _TableCell("${pct.toStringAsFixed(1)}%"),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAuthorizationSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _authColumn("Prepared by:", "Manager Signature"),
        const SizedBox(width: 40),
        _authColumn("Approved by:", "Director Signature"),
      ],
    );
  }

  Widget _authColumn(String title, String footer) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 35),
          Container(height: 1, color: Colors.grey),
          Text(footer, style: const TextStyle(fontSize: 8, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;
  const _TableCell(this.text, {this.isHeader = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 9,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

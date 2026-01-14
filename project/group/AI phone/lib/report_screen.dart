import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.picture_as_pdf_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "PDF REPORT PREVIEW",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE67E22),
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFE67E22),
            child: const Text(
              "Yatts-Kitchen-Weekly-Report.pdf",
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
                    const SizedBox(height: 20),
                    const Text(
                      "EXECUTIVE SUMMARY",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildExecutiveSummary(),
                    const SizedBox(height: 25),
                    const Text(
                      "DAILY PERFORMANCE",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPerformanceTable(),

                    const SizedBox(height: 25),
                    const Text(
                      "TOP MENU",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTopMenuTable(),

                    const SizedBox(height: 25),
                    const Text(
                      "ORDER TYPES",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildOrderTypesTable(),

                    const SizedBox(height: 25),
                    const Text(
                      "PEAK HOURS",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPeakHoursTable(),

                    const SizedBox(height: 40),
                    _buildAuthorizationSection(),

                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        "This is a computer-generated report from Yatt's Kitchen Management System\nReport Generated: 20/12/2025, 11:30 am  |  Document ID: SR-2024-W50\nConfidential Business Document • Page 1 of 1",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    _buildDownloadButtons(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            const SizedBox(height: 5),
            const Text(
              "Hutan Melintang, Ground Floor\Hutan Melintang Perak\nPhone: +013-2578500",
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text(
              "SALES REPORT",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              "Report ID: SR-2024-W50",
              style: TextStyle(fontSize: 9, color: Colors.grey),
            ),
            Text(
              "Period: Dec 13 - Dec 19, 2025",
              style: TextStyle(fontSize: 9, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExecutiveSummary() {
    return Row(
      children: [
        _summaryBox("Total Revenue :", "RM 4,750"),
        _summaryBox("Total Orders :", "252"),
        _summaryBox("Average Order :", "RM 28.50"),
        _summaryBox("Total Customers :", "252"),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 8, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(1.5),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: const [
            _TableCell("Date", isHeader: true),
            _TableCell("Day", isHeader: true),
            _TableCell("Orders", isHeader: true),
            _TableCell("Revenue", isHeader: true),
            _TableCell("Average", isHeader: true),
          ],
        ),
        _tableRow("Dec 13", "Monday", "35", "RM 850.00", "RM 22.37"),
        _tableRow("Dec 14", "Tuesday", "29", "RM 650.00", "RM 22.41"),
        _tableRow("Dec 15", "Wednesday", "42", "RM 900.00", "RM 21.43"),
        _tableRow("Dec 16", "Thursday", "48", "RM 950.00", "RM 19.79"),
        _tableRow("Dec 17", "Friday", "35", "RM 750.00", "RM 21.43"),
        _tableRow("Dec 18", "Saturday", "32", "RM 600.00", "RM 18.75"),
        _tableRow("Dec 19", "Sunday", "28", "RM 550.00", "RM 19.64"),
        TableRow(
          decoration: const BoxDecoration(color: Colors.white),
          children: const [
            _TableCell(""),
            _TableCell("TOTAL", isHeader: true),
            _TableCell("252", isHeader: true),
            _TableCell("RM 4750.00", isHeader: true),
            _TableCell("RM 28.50", isHeader: true),
          ],
        ),
      ],
    );
  }

  Widget _buildTopMenuTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: const [
            _TableCell("Rank", isHeader: true),
            _TableCell("Menu Name", isHeader: true),
            _TableCell("Quantity Sold", isHeader: true),
            _TableCell("Revenue", isHeader: true),
          ],
        ),
        _topMenuRow("1", "Nasi Ayam Roasted", "101", "RM 505.00"),
        _topMenuRow("2", "Nasi Goreng Seafood", "91", "RM 455.00"),
        _topMenuRow("3", "Kuey Teow Goreng", "60", "RM 300.00"),
        _topMenuRow("4", "Mee Goreng", "55", "RM 275.00"),
        _topMenuRow("5", "Laksa", "48", "RM 240.00"),
      ],
    );
  }

  Widget _buildOrderTypesTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: const [
            _TableCell("Type", isHeader: true),
            _TableCell("Orders", isHeader: true),
            _TableCell("Percentage", isHeader: true),
          ],
        ),
        _orderTypeRow("Dine-In", "152", "60.3%"),
        _orderTypeRow("Take Away", "100", "39.7%"),
      ],
    );
  }

  Widget _buildPeakHoursTable() {
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
        _peakHourRow("12:00 PM - 1:00 PM", "85", "33.7%"),
        _peakHourRow("6:00 PM - 7:00 PM", "72", "28.6%"),
        _peakHourRow("7:00 PM - 8:00 PM", "48", "19%"),
      ],
    );
  }

  Widget _buildAuthorizationSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _authColumn("Prepared by:", "Staff Name & Signature"),
        _authColumn("Verified & Approved by:", "Manager Name & Signature"),
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
          const SizedBox(height: 40),
          Container(
            height: 1,
            color: Colors.grey.shade400,
            margin: const EdgeInsets.only(right: 20),
          ),
          const SizedBox(height: 5),
          Text(footer, style: const TextStyle(fontSize: 9, color: Colors.grey)),
          const SizedBox(height: 5),
          const Text(
            "Date : _______________",
            style: TextStyle(fontSize: 9, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  TableRow _tableRow(String d, String dy, String o, String r, String a) {
    return TableRow(
      children: [
        _TableCell(d),
        _TableCell(dy),
        _TableCell(o),
        _TableCell(r),
        _TableCell(a),
      ],
    );
  }

  TableRow _topMenuRow(String rk, String nm, String qty, String rev) {
    return TableRow(
      children: [
        _TableCell(rk),
        _TableCell(nm),
        _TableCell(qty),
        _TableCell(rev),
      ],
    );
  }

  TableRow _orderTypeRow(String ty, String ord, String pct) {
    return TableRow(
      children: [_TableCell(ty), _TableCell(ord), _TableCell(pct)],
    );
  }

  TableRow _peakHourRow(String tm, String ord, String pct) {
    return TableRow(
      children: [_TableCell(tm), _TableCell(ord), _TableCell(pct)],
    );
  }

  Widget _buildDownloadButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Close Preview",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Downloading PDF...")),
              );
            },
            icon: const Icon(Icons.download, color: Colors.white, size: 18),
            label: const Text(
              "Download PDF",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE67E22),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 9,
          height: 1.2,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: Colors.black,
        ),
      ),
    );
  }
}

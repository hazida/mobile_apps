import 'package:flutter/material.dart';
import 'admin/admin_dashboard.dart';
import 'admin/analytics_screen.dart';
import 'admin/new_orders_screen.dart';
import 'admin/admin_settings_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      AdminDashboard(onSwitchTab: _onTabChanged),
      const AnalyticsScreen(),
      NewOrdersScreen(onSwitchTab: _onTabChanged), 
      const AdminSettingsScreen(), 
    ];
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
        selectedItemColor: const Color(0xFFE67E22),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Analytics"),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.tune), label: "Settings"),
        ],
      ),
    );
  }
}
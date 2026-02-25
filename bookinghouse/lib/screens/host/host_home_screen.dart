import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../auth/login_screen.dart';
import 'my_properties_screen.dart'; 
import 'host_booking_screen.dart';
import 'host_overview_screen.dart'; // Import Overview
import 'add_edit_property_screen.dart'; // Import AddEdit

class HostHomeScreen extends StatefulWidget {
  const HostHomeScreen({super.key});

  @override
  State<HostHomeScreen> createState() => _HostHomeScreenState();
}

class _HostHomeScreenState extends State<HostHomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HostOverviewScreen(), // Tab 0: Tổng quan (New Dashboard)
    MyPropertiesScreen(), // Tab 1: Tin đăng
    HostBookingScreen(),  // Tab 2: Khách hàng (Was Booking Requests)
    Center(child: Text("Tài khoản Host - Đang phát triển")), // Tab 3: Tài khoản
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      // AppBar is handled by individual screens mostly, or we can keep a generic one if needed. 
      // Current design for Overview has its own header. MyProperties has its own.
      // So we might want to hide AppBar for Tab 0 and 1 if they have their own.
      // For simplicity, let's keep it but maybe make it conditional or remove it if screen has one.
      // Actually HostOverviewScreen HAS a header. MyPropertiesScreen HAS a header.
      // HostBookingScreen DOES NOT have a header? Let's check.
      // HostBookingScreen has Scaffold but maybe we should wrap it.
      
      // For now, I will remove the global Scaffold AppBar because the child screens (Overview, MyProperties) have their own.
      // HostBookingScreen might need one added if it depends on this one.
      body: _widgetOptions.elementAt(_selectedIndex),
      
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildNavItem(0, Icons.dashboard_outlined, "Tổng quan"),
              _buildNavItem(1, Icons.list_alt, "Tin đăng"),
              const SizedBox(width: 40), // Space for FAB
              _buildNavItem(2, Icons.people_outline, "Khách hàng"),
              _buildNavItem(3, Icons.person_outline, "Tài khoản"),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 65, height: 65,
        child: FloatingActionButton(
          onPressed: () {
             // Navigate to Add Property
             // We can access MyPropertiesScreen state or navigate to the form directly
             // For now, simpler to navigate to form
             // But we need to import AddEditPropertyScreen
          },
          backgroundColor: const Color(0xFFD0021B),
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(
              icon,
              color: isSelected ? const Color(0xFFD0021B) : Colors.grey,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFD0021B) : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

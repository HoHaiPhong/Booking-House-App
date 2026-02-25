import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/property_model.dart';
import '../../models/user_model.dart';
import '../../services/property_service.dart';
import '../../widgets/property_card.dart'; // Import Custom Card
import 'property_detail_screen.dart';
import 'my_bookings_screen.dart';
import '../host/my_properties_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PropertyService _propertyService = PropertyService();
  late Future<List<Property>> _propertiesFuture;

  @override
  void initState() {
    super.initState();
    _propertiesFuture = _propertyService.getAllProperties();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- TAB 1: SEARCH / HOME (Batdongsan Style) ---
  Widget _buildSearchTab(User? user) {
    return Column(
      children: [
        // 1. HEADER section (Red Background)
        Container(
          color: const Color(0xFFD0021B), // Batdongsan Red
          padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 16), // SafeArea handled by Scaffold?
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // SEARCH BAR
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Chung cư Vinhomes 2 ngủ',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.black54),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2. FILTER & COUNT
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterButton(Icons.filter_list, "Lọc"),
                    const SizedBox(width: 8),
                    _dropdownFilter("Loại nhà đất"),
                    const SizedBox(width: 8),
                    _dropdownFilter("Khoảng giá"),
                    const SizedBox(width: 8),
                     _dropdownFilter("Diện tích"),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Results Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: const TextSpan(
                       style: TextStyle(color: Colors.black87, fontSize: 13),
                       children: [
                         TextSpan(text: "226.753", style: TextStyle(fontWeight: FontWeight.bold)), // Demo
                         TextSpan(text: " bất động sản"),
                       ]
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Text("Sắp xếp", style: TextStyle(fontSize: 12)),
                        SizedBox(width: 4),
                        Icon(Icons.sort, size: 16),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        
        const Divider(height: 1, color: Color(0xFFEEEEEE)),

        // 3. LISTINGS
        Expanded(
          child: Container(
             color: const Color(0xFFF5F5F5), // Light grey background
             child: FutureBuilder<List<Property>>(
              future: _propertiesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Chưa có tin đăng nào.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final property = snapshot.data![index];
                    return PropertyCard(
                      property: property,
                      onTap: () {
                          Navigator.push(
                           context,
                           MaterialPageRoute(builder: (c) => PropertyDetailScreen(property: property)),
                         );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _filterButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black87),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _dropdownFilter(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black54),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;



    final List<Widget> widgetOptions = <Widget>[
      _buildSearchTab(user),
      const MyBookingsScreen(), 
      const Center(child: Text("Chat - Coming Soon")),
      const ProfileScreen(), // Use ProfileScreen here
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Chức năng bản đồ đang phát triển")));
              },
              backgroundColor: Colors.black,
              icon: const Icon(Icons.map_outlined, color: Colors.white),
              label: const Text("Bản đồ", style: TextStyle(color: Colors.white)),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Tìm kiếm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Lịch hẹn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFD0021B), // Red
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

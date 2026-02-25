import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'property_detail_screen.dart'; // To navigate if needed
import '../../models/property_model.dart';
import 'home_screen.dart'; // For Find Home logic

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _bookingsFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _bookingsFuture = _fetchBookings();
  }

  Future<List<dynamic>> _fetchBookings() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) return [];
    
    try {
      final response = await _apiService.get('/bookings/user/${user.id}');
      return response as List<dynamic>;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch Hẹn"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFD0021B),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFD0021B),
          tabs: const [
            Tab(text: "Chờ duyệt"),
            Tab(text: "Đã lên lịch"),
            Tab(text: "Lịch sử"),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
             return Center(child: Text("Lỗi: ${snapshot.error}"));
          } 
          
          final bookings = snapshot.data ?? [];

          // Filter logic
          final pending = bookings.where((b) => b['trang_thai'] == 'cho_duyet').toList();
          final confirmed = bookings.where((b) => b['trang_thai'] == 'confirmed').toList(); // 'confirmed' from backend
          // History: cancelled, completed, or rejected
          final history = bookings.where((b) => ['cancelled', 'completed', 'rejected'].contains(b['trang_thai'])).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildBookingList(pending, isPendingTab: true),
              _buildBookingList(confirmed),
              _buildBookingList(history),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookingList(List<dynamic> items, {bool isPendingTab = false}) {
    if (items.isEmpty) {
      if (isPendingTab) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today_outlined, size: 60, color: Colors.grey),
              const SizedBox(height: 16),
              const Text("Chưa có lịch hẹn nào đang chờ.", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Search (Index 0 of Home)
                  // This is minimal; proper way depends on root nav setup
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Hãy qua tab Tìm Kiếm để chọn phòng nhé!"))); 
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD0021B), foregroundColor: Colors.white),
                child: const Text("Tìm nhà ngay"),
              )
            ],
          ),
        );
      }
      return const Center(child: Text("Không có dữ liệu.", style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final booking = items[index];
        final bds = booking['bds'] ?? {};
        final status = booking['trang_thai'] ?? 'Unknown';

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.home, color: Color(0xFFD0021B), size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(bds['ten_bds'] ?? "Bất động sản #${booking['bds_id']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    _buildStatusChip(status),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text("Ngày: ${_formatDate(booking['ngay_bat_dau'])}"),
                  ],
                ),
                const SizedBox(height: 4),
                 Row(
                  children: [
                    const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text("Giá: ${bds['gia_thue']} / tháng"), // Add currency format later
                  ],
                ),
                const SizedBox(height: 8),
                if (bds['dia_chi'] != null)
                  Text("Đ/c: ${bds['dia_chi']}", style: const TextStyle(color: Colors.grey, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = Colors.grey;
    String label = status;

    switch (status) {
      case 'cho_duyet':
        color = Colors.orange;
        label = "Chờ duyệt";
        break;
      case 'confirmed':
        color = Colors.green;
        label = "Đã xác nhận";
        break;
      case 'cancelled':
      case 'rejected':
        color = Colors.red;
        label = "Đã hủy";
        break;
      case 'completed':
        color = Colors.blue;
        label = "Hoàn thành";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  String _formatDate(String? isoString) {
    if (isoString == null) return "N/A";
    try {
      final date = DateTime.parse(isoString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return isoString;
    }
  }
}

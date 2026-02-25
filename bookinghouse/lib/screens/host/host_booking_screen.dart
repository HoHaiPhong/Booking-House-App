import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class HostBookingScreen extends StatefulWidget {
  const HostBookingScreen({super.key});

  @override
  State<HostBookingScreen> createState() => _HostBookingScreenState();
}

class _HostBookingScreenState extends State<HostBookingScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _refreshBookings();
  }

  void _refreshBookings() {
    setState(() {
      _bookingsFuture = _fetchHostBookings();
    });
  }

  Future<List<dynamic>> _fetchHostBookings() async {
    try {
      final response = await _apiService.get('/bookings/host');
      return response as List<dynamic>;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _updateStatus(int bookingId, String newStatus) async {
    try {
      await _apiService.put('/bookings/$bookingId', {'trang_thai': newStatus});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Updated to $newStatus')));
      _refreshBookings();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Khách hàng"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
             // Print error to console for debugging
             debugPrint("HOST BOOKING ERROR: ${snapshot.error}");
             return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Chưa có khách hàng nào đặt lịch."));
          }

          final bookings = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              // Safe parsing
              final property = booking['Property'] ?? {};
              final user = booking['User'] ?? {};
              final propertyName = property['ten_bds'] ?? 'Tên BĐS';
              final userName = user['ho_ten'] ?? 'Khách hàng';
              final userPhone = user['so_dien_thoai'] ?? 'N/A';
              final status = booking['trang_thai'] ?? 'unknown';
              final bookingId = booking['dat_lich_id'];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text(propertyName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                           _buildStatusChip(status),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Icon(Icons.person, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text("$userName - $userPhone"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text("${_formatDate(booking['ngay_bat_dau'])} - ${_formatDate(booking['ngay_ket_thuc'])}"),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (status == 'cho_duyet')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => _updateStatus(booking['dat_lich_id'], 'cancelled'),
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: const Text("Từ chối"),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _updateStatus(booking['dat_lich_id'], 'confirmed'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                              child: const Text("Đồng ý"),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = Colors.grey;
    String label = status;
    switch (status) {
      case 'cho_duyet': color = Colors.orange; label = "Chờ duyệt"; break;
      case 'confirmed': color = Colors.green; label = "Đã duyệt"; break;
      case 'cancelled': color = Colors.red; label = "Đã hủy"; break;
      case 'completed': color = Colors.blue; label = "Hoàn thành"; break;
    }
    return Chip(label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)), backgroundColor: color);
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

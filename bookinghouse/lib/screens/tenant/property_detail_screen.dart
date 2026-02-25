import 'package:flutter/material.dart';
import '../../models/property_model.dart';
import '../../services/api_service.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Property property;

  const PropertyDetailScreen({super.key, required this.property});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  final _apiService = ApiService();
  bool _isLoading = false;

  DateTimeRange? _selectedDateRange;

  Future<void> _bookNow() async {
    // 1. Show Date Picker
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Chọn khoảng thời gian thuê',
      cancelText: 'Hủy',
      confirmText: 'Chọn',
      saveText: 'Lưu',
    );

    if (picked == null) return;

    setState(() {
      _selectedDateRange = picked;
    });

    // 2. Confirm Dialog
    if (!mounted) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận đặt lịch"),
        content: Text("Bạn muốn đặt từ ngày ${picked.start.day}/${picked.start.month} đến ${picked.end.day}/${picked.end.month}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Hủy")),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Đồng ý")),
        ],
      ),
    );

    if (confirm != true) return;

    // 3. Send API Request
    setState(() => _isLoading = true);
    try {
      await _apiService.post('/bookings', {
        'bds_id': widget.property.id,
        'ngay_bat_dau': picked.start.toIso8601String(),
        'ngay_ket_thuc': picked.end.toIso8601String(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gửi yêu cầu thành công! Vui lòng kiểm tra tab "Lịch hẹn".')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.property;
    return Scaffold(
      appBar: AppBar(title: Text(p.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            p.images.isNotEmpty
              ? Image.network(p.images[0], height: 250, fit: BoxFit.cover)
              : Container(height: 250, color: Colors.grey, child: const Icon(Icons.home, size: 100)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("${p.price} VND / tháng", style: const TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(children: [
                     const Icon(Icons.location_on, color: Colors.grey),
                     const SizedBox(width: 4),
                     Expanded(child: Text(p.address, style: const TextStyle(fontSize: 16))),
                  ]),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoChip(Icons.square_foot, "${p.area} m2"),
                       _infoChip(Icons.category, "Loại: ${p.categoryId ?? 'Khác'}"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Mô tả", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(p.description ?? "Chưa có mô tả", style: const TextStyle(fontSize: 16, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _bookNow,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD0021B), // Red
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: _isLoading 
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Chọn ngày & Gửi yêu cầu", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      backgroundColor: Colors.blue.withOpacity(0.1),
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/property_model.dart';
import '../../services/property_service.dart';
import '../../services/api_service.dart';
import 'add_edit_property_screen.dart';

class MyPropertiesScreen extends StatefulWidget {
  const MyPropertiesScreen({super.key});

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  late Future<List<Property>> _propertiesFuture;
  final PropertyService _propertyService = PropertyService();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _refreshProperties();
  }

  void _refreshProperties() {
    setState(() {
      _propertiesFuture = _propertyService.getMyProperties();
    });
  }

  Future<void> _deleteProperty(int id) async {
    // ... same as before
    try {
      await _apiService.delete('/properties/$id');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa thành công')));
        _refreshProperties();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Quản lý tin", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.save_outlined, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 12),
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 8),
                        Text("Nhập mã tin hoặc tiêu đề tin", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 45, height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: const Icon(Icons.filter_list, color: Colors.black),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 2. Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip("Tất cả (0)", true),
                const SizedBox(width: 8),
                _buildFilterChip("Hết hạn (0)", false),
                const SizedBox(width: 8),
                _buildFilterChip("Sắp hết hạn (0)", false),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // 3. Content
          Expanded(
            child: FutureBuilder<List<Property>>(
              future: _propertiesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Lỗi: ${snapshot.error}"));
                } 
                
                final properties = snapshot.data ?? [];
                
                if (properties.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Placeholder Icon
                        Opacity(
                          opacity: 0.5,
                          child: Icon(Icons.door_sliding_outlined, size: 120, color: Colors.grey[400]),
                        ),
                        const SizedBox(height: 20),
                        const Text("Chưa có tin đăng nào", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text("Hiện tại chưa có tin đăng nào", style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (c) => const AddEditPropertyScreen()),
                              );
                              if (result == true) _refreshProperties();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD0021B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                          child: const Text("Đăng tin ngay", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    final p = properties[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: p.images.isNotEmpty ? NetworkImage(p.images[0]) : const NetworkImage("https://via.placeholder.com/150"),
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                        title: Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text("${p.price} VND/tháng", style: const TextStyle(color: Color(0xFFD0021B), fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(p.address, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () => _confirmDelete(p.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black87 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  void _confirmDelete(int id) {
     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xóa tin đăng"),
        content: const Text("Bạn có chắc chắn? Hành động này không thể hoàn tác."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProperty(id);
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }
}

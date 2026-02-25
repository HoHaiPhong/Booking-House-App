import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../auth/login_screen.dart';
import '../host/host_home_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HostHomeScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.manage_accounts, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                "Quản lý tin đăng",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER - User Info (Red Background)
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFD0021B), // Batdongsan Red
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                   CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Text(
                      user?.fullName?[0].toUpperCase() ?? "U",
                      style: const TextStyle(fontSize: 40, color: Color(0xFFD0021B), fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.fullName ?? "Người dùng",
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user?.email ?? "email@example.com",
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                         if (user != null && user.phone != null)
                          Text(
                            user.phone!,
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tính năng chỉnh sửa đang phát triển")));
                    },
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. MENU OPTIONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildSectionTitle("Quản lý"),
                  _buildMenuCard([
                    _buildMenuItem(context, Icons.history, "Lịch sử thuê nhà", onTap: () {
                       // Navigate to history if implemented separate or inside MyBookings
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Xem tab 'My Postings' hoặc phát triển thêm")));
                    }),
                    _buildDivider(),
                    _buildMenuItem(context, Icons.favorite_border, "Tin đã lưu", onTap: () {}),
                    _buildDivider(),
                    _buildMenuItem(context, Icons.notifications_none, "Thông báo", onTap: () {}),
                  ]),

                  const SizedBox(height: 20),
                  _buildSectionTitle("Tài khoản"),
                   _buildMenuCard([
                    _buildMenuItem(context, Icons.lock_outline, "Đổi mật khẩu", onTap: () {}),
                    _buildDivider(),
                     _buildMenuItem(context, Icons.language, "Ngôn ngữ", trailing: "Tiếng Việt", onTap: () {}),
                    _buildDivider(),
                    _buildMenuItem(context, Icons.help_outline, "Hỗ trợ & Trợ giúp", onTap: () {}),
                  ]),

                  const SizedBox(height: 30),

                  // 3. LOGOUT BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                         _showLogoutDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: const Text("Đăng xuất", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text("Phiên bản 1.0.0", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 10, left: 5),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, {String? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Colors.black87, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: trailing != null 
          ? Text(trailing, style: const TextStyle(color: Colors.grey, fontSize: 13)) 
          : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 60, endIndent: 20, color: Color(0xFFEEEEEE));
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận"),
        content: const Text("Bạn có chắc chắn muốn đăng xuất?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Hủy")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Provider.of<UserProvider>(context, listen: false).logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text("Đăng xuất", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

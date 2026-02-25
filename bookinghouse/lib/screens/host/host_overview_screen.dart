import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'add_edit_property_screen.dart';

class HostOverviewScreen extends StatelessWidget {
  const HostOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Red Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
              decoration: const BoxDecoration(
                color: Color(0xFFD0021B), // Red
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Text(
                          user?.fullName?.isNotEmpty == true ? user!.fullName![0].toUpperCase() : "H",
                          style: const TextStyle(color: Color(0xFFD0021B), fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Xin chào", style: TextStyle(color: Colors.white70, fontSize: 14)),
                          Text(
                            user?.fullName ?? "Chủ nhà",
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    ],
                  ),
                  const SizedBox(height: 25),
                  
                  // Balance Card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.account_balance_wallet, color: Color(0xFFD0021B)),
                            const SizedBox(width: 8),
                            const Text("0 đ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Promo Image/Card
                  Center(
                    child: Column(
                      children: [
                        // Placeholder for the "House" illustration
                        Container(
                          height: 100, width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.home_work_outlined, size: 50, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Quà tặng 1 tin thường 15 ngày",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Tin đăng của bạn sẽ được tiếp cận hơn 6 triệu\nngười tìm mua/thuê bất động sản mỗi tháng",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (c) => const AddEditPropertyScreen()));
                          },
                          icon: const Icon(Icons.add, color: Colors.black),
                          label: const Text("Tạo tin đăng đầu tiên", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. Account Overview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tổng quan tài khoản", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Card 1: Tin đăng
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.dashboard,
                          title: "Tin đăng",
                          count: "0 tin",
                          status: "Đang hiển thị",
                          actionText: "Đăng tin",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (c) => const AddEditPropertyScreen()));
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Card 2: Liên hệ (Customers)
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.people,
                          title: "Liên hệ trong\n30 ngày",
                          count: "0 người",
                          status: "+ 0 mới vào hôm nay",
                          statusColor: Colors.green,
                          actionText: "", // No action button for this one explicitly in design
                          onTap: () {
                             // Navigate to Customers tab logic if needed
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
             const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon, 
    required String title, 
    required String count, 
    required String status, 
    Color statusColor = Colors.black54,
    String? actionText,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Colors.grey[800]),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(status, style: TextStyle(color: statusColor, fontSize: 12)),
          
          if (actionText != null && actionText.isNotEmpty) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  Text(actionText, style: const TextStyle(color: Color(0xFFD0021B), fontWeight: FontWeight.bold)),
                  const Icon(Icons.chevron_right, size: 16, color: Color(0xFFD0021B)),
                ],
              ),
            )
          ] else 
             const SizedBox(height: 20), // Spacer to align heights
        ],
      ),
    );
  }
}

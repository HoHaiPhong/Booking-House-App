# 🏠 Ứng Dụng Booking House

Một ứng dụng đặt phòng/thuê nhà hoàn chỉnh được xây dựng với **Frontend bằng Flutter** và **Backend bằng Node.js/Express** sử dụng cơ sở dữ liệu **PostgreSQL**.

## 🌟 Tính Năng Nổi Bật
- **Xác Thực Người Dùng**: Đăng nhập và đăng ký an toàn thông qua JWT.
- **Chat Trực Tuyến**: Tích hợp tính năng chat thời gian thực bằng Socket.IO.
- **Quản Lý Bất Động Sản**: Xem, tìm kiếm và quản lý thông tin nhà/phòng cho thuê.
- **Hệ Thống Đặt Phòng**: Kiểm tra tình trạng phòng trống và tiến hành đặt phòng dễ dàng.
- **Phân Quyền Truy Cập**: Được thiết kế với các tính năng và giao diện ưa nhìn cho Người Dùng .

## 🛠️ Công Nghệ Sử Dụng

### Frontend (Ứng Dụng Di Động)
- **Framework**: Flutter (Dart)
- **Quản lí Trạng thái (State Management)**: Provider
- **Giao Tiếp Mạng**: Dio
- **Thời Gian Thực (Real-time)**: Socket.IO Client
- **Lưu Trữ Cục Bộ (Local Storage)**: Flutter Secure Storage, Shared Preferences

### Backend (Máy Chủ)
- **Môi Trường Chạy**: Node.js (v18+)
- **Framework**: Express.js
- **Cơ Sở Dữ Liệu**: PostgreSQL với Sequelize ORM
- **Bảo Mật & Xác Thực**: JWT & bcryptjs
- **Thời Gian Thực (Real-time)**: Socket.IO

## 🚀 Hướng Dẫn Cài Đặt và Khởi Chạy

### Yêu Cầu Hệ Thống
- [Node.js](https://nodejs.org/) (phiên bản 18 trở lên)
- [PostgreSQL](https://www.postgresql.org/) (hoặc PgAdmin)
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio / VS Code

### 1️⃣ Thiết Lập Backend
1. Mở Terminal và đi tới thư mục backend:
   ```bash
   cd booking-house-backend
   ```
2. Cài đặt các thư viện phụ thuộc:
   ```bash
   npm install
   ```
3. Khởi động server (hãy đảm bảo cơ sở dữ liệu PostgreSQL của bạn đang hoạt động và đã được cấu hình đúng với dự án):
   ```bash
   node server.js
   ```
_Backend API hiện tại sẽ chạy tại địa chỉ: `http://localhost:5000`._

### 2️⃣ Thiết Lập Frontend (Flutter)
1. Mở thư mục `bookinghouse` bằng phần mềm Android Studio hoặc VS Code.
2. Tải bộ thư viện Flutter:
   ```bash
   flutter pub get
   ```
3. Cấu hình địa chỉ API:
   Mở file `lib/services/api_service.dart` và cập nhật địa chỉ IP cơ sở (Base URL):
   - Nếu chạy trên **Máy Ảo Android (Emulator)**: Cập nhật địa chỉ IP thành `10.0.2.2:5000`.
   - Nếu chạy trên **Điện thoại thật**: Cập nhật địa chỉ IP thành địa chỉ IPv4 mạng nội bộ (LAN) của máy tính bạn (ví dụ: `192.168.1.5:5000`). Đồng thời đảm bảo máy tính và điện thoại cùng kết nối vào một mạng Wi-Fi.
4. Chạy ứng dụng trên máy ảo hoặc thiết bị thật của bạn.

## 📂 Thu Mục Dự Án
- `/booking-house-backend/` - Mã nguồn mã máy chủ mạng (Backend REST API).
- `/bookinghouse/` - Mã nguồn ứng dụng di động Flutter.

## 📄 Giấy Phép
Dự án được cấp phép dưới dạng mã nguồn mở theo tiêu chuẩn ISC License.

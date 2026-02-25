class User {
  final int id;
  final String fullName;
  final String email;
  final String? phone;
  final int? roleId;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.roleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['nguoi_dung_id'] ?? 0,
      fullName: json['ho_ten'] ?? '',
      email: json['email'] ?? '',
      phone: json['so_dien_thoai'],
      roleId: json['role_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nguoi_dung_id': id,
      'ho_ten': fullName,
      'email': email,
      'so_dien_thoai': phone,
      'role_id': roleId,
    };
  }
}

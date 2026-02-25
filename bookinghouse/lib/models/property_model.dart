class Property {
  final int id;
  final String name;
  final String address;
  final double price;
  final int? area;
  final String? description;
  final String? status;
  final double? lat;
  final double? lng;
  final int? categoryId;
  final int? ownerId;
  final List<String> images;
  final String? ownerName;
  final String? ownerAvatar;

  Property({
    required this.id,
    required this.name,
    required this.address,
    required this.price,
    this.area,
    this.description,
    this.status,
    this.lat,
    this.lng,
    this.categoryId,
    this.ownerId,
    this.images = const [],
    this.ownerName,
    this.ownerAvatar,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['bds_id'] ?? 0,
      name: json['ten_bds'] ?? '',
      address: json['dia_chi'] ?? '',
      price: double.tryParse(json['gia_thue'].toString()) ?? 0.0,
      area: json['dien_tich'],
      description: json['mo_ta'],
      status: json['trang_thai'],
      lat: json['lat'],
      lng: json['lng'],
      categoryId: json['loai_id'],
      ownerId: json['nguoi_dung_id'],
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [], // Safe parse
      ownerName: json['owner_name'], // Backend might need to join table
      ownerAvatar: json['owner_avatar'],
    );
  }
}

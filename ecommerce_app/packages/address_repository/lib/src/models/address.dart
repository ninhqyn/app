class Address {
  int addressId;
  int userId;
  String receiverName;
  String phone;
  int provinceId;
  String provinceName;
  int districtId;
  String districtName;
  int wardId;
  String wardName;
  String detailAddress;
  bool isDefault;
  DateTime createdAt;

  // Constructor
  Address({
    required this.addressId,
    required this.userId,
    required this.receiverName,
    required this.phone,
    required this.provinceId,
    required this.provinceName,
    required this.districtId,
    required this.districtName,
    required this.wardId,
    required this.wardName,
    required this.detailAddress,
    required this.isDefault,
    required this.createdAt,
  });

  // Hàm fromJson để chuyển đổi từ Map sang đối tượng Address
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressId: json['addressId'],
      userId: json['userId'],
      receiverName: json['receiverName'],
      phone: json['phone'],
      provinceId: json['provinceId'],
      provinceName: json['provinceName'],
      districtId: json['districtId'],
      districtName: json['districtName'],
      wardId: json['wardId'],
      wardName: json['wardName'],
      detailAddress: json['detailAddress'],
      isDefault: json['isDefault'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Hàm toJson để chuyển đổi đối tượng Address thành Map
  Map<String, dynamic> toJson() {
    return {
      'addressId': addressId,
      'userId': userId,
      'receiverName': receiverName,
      'phone': phone,
      'provinceId': provinceId,
      'provinceName': provinceName,
      'districtId': districtId,
      'districtName': districtName,
      'wardId': wardId,
      'wardName': wardName,
      'detailAddress': detailAddress,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

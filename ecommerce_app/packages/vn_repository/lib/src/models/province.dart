import 'package:equatable/equatable.dart';

class Province extends Equatable {
  final String name;
  final int code;
  final String divisionType;
  final int phoneCode;

  // Constructor
  const Province({
    required this.name,
    required this.code,
    required this.divisionType,
    required this.phoneCode,
  });

  // Hàm toJson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'divisionType': divisionType,
      'phoneCode': phoneCode,
    };
  }

  // Hàm từ JSON, kiểm tra null và chuyển đổi tên trường
  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      name: json['name'] ?? '', // Kiểm tra null, nếu null thì gán chuỗi rỗng
      code: json['code'] ?? 0, // Kiểm tra null, nếu null thì gán 0
      divisionType: json['division_type'] ?? '', // Sửa lại trường `division_type` thành `divisionType`
      phoneCode: json['phone_code'] ?? 0, // Kiểm tra null, nếu null thì gán 0
    );
  }

  @override
  List<Object?> get props => [name, code, divisionType, phoneCode];
}

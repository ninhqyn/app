import 'package:equatable/equatable.dart';

class Ward extends Equatable {
  final int code;
  final String codename;
  final int districtCode;
  final String divisionType;
  final String name;

  // Hàm tạo
  const Ward({
    required this.code,
    required this.codename,
    required this.districtCode,
    required this.divisionType,
    required this.name,
  });

  // Phương thức fromJson để khởi tạo Ward từ Map
  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      code: json['code'],
      codename: json['codename'],
      districtCode: json['district_code'],
      divisionType: json['division_type'],
      name: json['name'],
    );
  }

  // Override props để Equatable so sánh các thuộc tính
  @override
  List<Object?> get props => [code, codename, districtCode, divisionType, name];
}

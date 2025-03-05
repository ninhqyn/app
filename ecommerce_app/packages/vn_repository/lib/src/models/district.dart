import 'package:equatable/equatable.dart';

class District extends Equatable {
  final String name;
  final int code;
  final String codename;
  final String divisionType;
  final int provinceCode;
  final dynamic wards;

  // Constructor
  const District({
    required this.name,
    required this.code,
    required this.codename,
    required this.divisionType,
    required this.provinceCode,
    this.wards,
  });

  // Factory method fromJson
  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      name: json['name'],
      code: json['code'],
      codename: json['codename'],
      divisionType: json['division_type'],
      provinceCode: json['province_code'],
      wards: json['wards'],
    );
  }

  // Override props to use Equatable
  @override
  List<Object?> get props => [name, code, codename, divisionType, provinceCode, wards];
}

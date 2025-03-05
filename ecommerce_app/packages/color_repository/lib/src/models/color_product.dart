import 'package:equatable/equatable.dart';

class ColorProduct extends Equatable {
  final int colorId;
  final String name;
  final String colorCode;

  const ColorProduct({
    required this.colorId,
    required this.name,
    required this.colorCode,
  });

  @override
  List<Object?> get props => [colorId, name, colorCode];

  // fromJson method to create an instance of ColorProduct from a map
  factory ColorProduct.fromJson(Map<String, dynamic> json) {
    return ColorProduct(
      colorId: json['colorId'] as int,
      name: json['name'] as String,
      colorCode: json['colorCode'] as String,
    );
  }

  // toJson method to convert a ColorProduct instance to a map
  Map<String, dynamic> toJson() {
    return {
      'colorId': colorId,
      'name': name,
      'colorCode': colorCode,
    };
  }
}

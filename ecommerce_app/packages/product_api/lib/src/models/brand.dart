import 'package:equatable/equatable.dart';

class Brand extends Equatable {
  final String brand;

  const Brand(this.brand);

  @override
  // Override props để so sánh đối tượng
  List<Object?> get props => [brand];

  // fromJson: Chuyển đổi từ JSON sang đối tượng Brand
  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(json['brand'] as String);
  }

  // toJson: Chuyển đổi từ đối tượng Brand sang JSON
  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
    };
  }
}

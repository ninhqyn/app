import 'package:equatable/equatable.dart';

class SizeProduct extends Equatable {
  final int sizeId;
  final String name;
  final int sizeOrder;

  const SizeProduct({
    required this.sizeId,
    required this.name,
    required this.sizeOrder,
  });

  @override
  List<Object?> get props => [sizeId, name, sizeOrder];

  // fromJson method to create an instance of ColorProduct from a map
  factory SizeProduct.fromJson(Map<String, dynamic> json) {
    return SizeProduct(
      sizeId: json['sizeId'] as int,
      name: json['name'] as String,
      sizeOrder: json['sizeOrder'] as int,
    );
  }

  // toJson method to convert a ColorProduct instance to a map
  Map<String, dynamic> toJson() {
    return {
      'sizeId': sizeId,
      'name': name,
      'sizeOrder': sizeOrder,
    };
  }
}

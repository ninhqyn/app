import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int productId;
  final int typeId;
  final String name;
  final String description;
  final double basePrice;
  final String brand;
  final String gender;
  final double rating;
  final int totalSold;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.productId,
    required this.typeId,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.brand,
    required this.gender,
    required this.rating,
    required this.totalSold,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  Product.empty()
      : productId = 0,
        typeId = 0,
        name = '',
        description = '',
        basePrice = 0.0,
        brand = '',
        gender = '',
        rating = 0.0,
        totalSold = 0,
        isActive = false,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  // Phương thức fromJson để chuyển đổi JSON thành đối tượng Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      typeId: json['typeId'],
      name: json['name'],
      description: json['description'],
      basePrice: (json['basePrice'] as num).toDouble(),
      brand: json['brand'],
      gender: json['gender'],
      rating: (json['rating'] as num).toDouble(),
      totalSold: json['totalSold'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Phương thức toJson để chuyển đổi đối tượng Product thành JSON
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'typeId': typeId,
      'name': name,
      'description': description,
      'basePrice': basePrice,
      'brand': brand,
      'gender': gender,
      'rating': rating,
      'totalSold': totalSold,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    productId,
    typeId,
    name,
    description,
    basePrice,
    brand,
    gender,
    rating,
    totalSold,
    isActive,
    createdAt,
    updatedAt,
  ];
}

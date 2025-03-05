import 'package:equatable/equatable.dart';

class ProductType extends Equatable {
  final int typeId;
  final String name;
  final String description;
  final bool isActive;
  final DateTime createdAt;
  final int categoryId;

  // Constructor
  const ProductType({
    required this.typeId,
    required this.name,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.categoryId,
  });

  ProductType.empty()
      : typeId = 0,
        name = '',
        description = '',
        isActive = false,
        createdAt = DateTime(2000),
        categoryId = 0;
  // fromJson constructor
  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      typeId: json['typeId'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      categoryId: json['categoryId'] as int,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'typeId': typeId,
      'name': name,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'categoryId': categoryId,
    };
  }

  @override
  List<Object?> get props => [
    typeId,
    name,
    description,
    isActive,
    createdAt,
    categoryId,
  ];
}
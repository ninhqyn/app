import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int categoryId;
  final String name;
  final String description;
  final int? parentId;
  final bool isActive;
  final DateTime createAt;
  final String? image;
  const Category({
    required this.categoryId,
    required this.name,
    required this.description,
    required this.parentId,
    required this.isActive,
    required this.createAt,
    required this.image,
  });
  Category.empty()
      : categoryId = 0,
        name = '',
        description = '',
        parentId = 0,
        isActive = false,
        createAt = DateTime.now(),
        image = '';

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      name: json['name'],
      description: json['description'],
      parentId: json['parentId'] as int?,
      isActive: json['isActive'],
      createAt: DateTime.parse(json['createdAt']),
      image: json['image'] as String?,
    );
  }

  // Phương thức toJson để chuyển đổi đối tượng Category thành JSON
  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'parentId': parentId,
      'isActive': isActive,
      'createdAt': createAt.toIso8601String(),
      'image': image,
    };
  }

  @override
  List<Object?> get props => [
    categoryId,
    name,
    description,
    parentId,
    isActive,
    createAt,
    image,
  ];
}

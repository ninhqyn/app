import 'package:equatable/equatable.dart';

class ProductImage extends Equatable {
  final int imageId;
  final int productId;
  final int variantId;
  final String imageUrl;
  final bool isPrimary;
  final int sortOrder;
  const ProductImage({
    required this.imageId,
    required this.productId,
    required this.variantId,
    required this.imageUrl,
    required this.isPrimary,
    required this.sortOrder,
  });
  const ProductImage.empty()
      : imageId = 0,
        productId = 0,
        variantId = 0,
        imageUrl = '',
        isPrimary = false,
        sortOrder = 0;

  // Phương thức fromJson để chuyển đổi JSON thành đối tượng ProductImage
  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      imageId: json['imageId'],
      productId: json['productId'],
      variantId: json['variantId'],
      imageUrl: json['imageUrl'],
      isPrimary: json['isPrimary'],
      sortOrder: json['sortOrder'],
    );
  }

  // Phương thức toJson để chuyển đổi đối tượng ProductImage thành JSON
  Map<String, dynamic> toJson() {
    return {
      'imageId': imageId,
      'productId': productId,
      'variantId': variantId,
      'imageUrl': imageUrl,
      'isPrimary': isPrimary,
      'sortOrder': sortOrder,
    };
  }

  @override
  List<Object?> get props => [
    imageId,
    productId,
    variantId,
    imageUrl,
    isPrimary,
    sortOrder,
  ];
}

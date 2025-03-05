import 'package:equatable/equatable.dart';

class CartResponse extends Equatable {
  final int cartItemId;
  final int quantity;
  final DateTime addedAt;
  final int variantId;
  final String sku;
  final double price;
  final int stockQuantity;
  final int productId;
  final String productName;
  final double basePrice;
  final String brand;
  final int sizeId;
  final String sizeName;
  final int colorId;
  final String colorName;
  final String imageUrlPrimay;

  const CartResponse({
    required this.cartItemId,
    required this.quantity,
    required this.addedAt,
    required this.variantId,
    required this.sku,
    required this.price,
    required this.stockQuantity,
    required this.productId,
    required this.productName,
    required this.basePrice,
    required this.brand,
    required this.sizeId,
    required this.sizeName,
    required this.colorId,
    required this.colorName,
    required this.imageUrlPrimay,
  });

  @override
  List<Object?> get props => [
    cartItemId,
    quantity,
    addedAt,
    variantId,
    sku,
    price,
    stockQuantity,
    productId,
    productName,
    basePrice,
    brand,
    sizeId,
    sizeName,
    colorId,
    colorName,
    imageUrlPrimay,
  ];

  // From JSON constructor
  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      cartItemId: json['cartItemId'] ?? 0, // Default value if null
      quantity: json['quantity'] ?? 0, // Default value if null
      addedAt: json['addedAt'] != null ? DateTime.parse(json['addedAt']) : DateTime.now(), // Default value if null
      variantId: json['variantId'] ?? 0, // Default value if null
      sku: json['sku'] ?? '', // Default value if null
      price: (json['price'] != null) ? json['price'].toDouble() : 0.0, // Default value if null
      stockQuantity: json['stockQuantity'] ?? 0, // Default value if null
      productId: json['productId'] ?? 0, // Default value if null
      productName: json['productName'] ?? '', // Default value if null
      basePrice: (json['basePrice'] != null) ? json['basePrice'].toDouble() : 0.0, // Default value if null
      brand: json['brand'] ?? '', // Default value if null
      sizeId: json['sizeId'] ?? 0, // Default value if null
      sizeName: json['sizeName'] ?? '', // Default value if null
      colorId: json['colorId'] ?? 0, // Default value if null
      colorName: json['colorName'] ?? '', // Default value if null
      imageUrlPrimay: json['imageUrlPrimay'] ?? '', // Default value if null
    );
  }

  // To JSON conversion
  Map<String, dynamic> toJson() {
    return {
      'cartItemId': cartItemId,
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
      'variantId': variantId,
      'sku': sku,
      'price': price,
      'stockQuantity': stockQuantity,
      'productId': productId,
      'productName': productName,
      'basePrice': basePrice,
      'brand': brand,
      'sizeId': sizeId,
      'sizeName': sizeName,
      'colorId': colorId,
      'colorName': colorName,
      'imageUrlPrimay': imageUrlPrimay,
    };
  }
}

import 'package:equatable/equatable.dart';
import 'package:product_api/product_api.dart';

class ProductModel extends Equatable{
  final Product product;
  final List<ProductImage> productImages;

  const ProductModel({required this.product, required this.productImages});

  @override
  // TODO: implement props
  List<Object?> get props => [product,productImages];

}
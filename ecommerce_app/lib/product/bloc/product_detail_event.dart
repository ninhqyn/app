part of 'product_detail_bloc.dart';

@immutable
sealed class ProductDetailEvent {}
final class FetchedProduct extends ProductDetailEvent{
  final int productId;

  FetchedProduct(this.productId);
}
final class SelectSize extends ProductDetailEvent{
  final int index;
  final SizeProduct size;
  SelectSize(this.index,this.size);
}
final class SelectColor extends ProductDetailEvent{
  final int index;
  final ColorProduct color;

  SelectColor(this.index,this.color);
}
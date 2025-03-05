part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}
class LoadedCart extends CartEvent{}
class AddToCart extends CartEvent{
  final int colorId;
  final int sizeId;
  final int productId;
  final String productName;
  AddToCart({required this.colorId,required this.sizeId,required this.productId,required this.productName});
}
class RemoveToCart extends CartEvent{}
class UpdateQuantity extends CartEvent{
  final int itemId;
  final int currentQuantity;
  final bool add;
  UpdateQuantity({required this.itemId,required this.currentQuantity,required this.add});
}
class CheckOut extends CartEvent{}
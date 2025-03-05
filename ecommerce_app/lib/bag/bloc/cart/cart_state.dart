part of 'cart_bloc.dart';

@immutable
sealed class CartState  extends Equatable {}

final class CartLoading extends CartState{
  @override
  List<Object?> get props => [];
}
final class CartInitial extends CartState {
  final List<CartResponse> cartItems;
  final double totalAmount;
  CartInitial({
    this.cartItems = const<CartResponse>[],
    this.totalAmount = 0
  });
  CartInitial copyWith({
    List<CartResponse>? cartItems,
    double? totalAmount
}){
    return CartInitial(
    cartItems: cartItems ?? this.cartItems,
      totalAmount: totalAmount ?? this.totalAmount
    );
}
  @override
  List<Object?> get props => [cartItems,totalAmount];
}
class CartAddedToCart extends CartState {
  final String productName;

  CartAddedToCart({required this.productName});

  @override
  List<Object> get props => [productName];
}
class FailToAddToCart extends CartState {

  @override
  List<Object> get props => [];
}
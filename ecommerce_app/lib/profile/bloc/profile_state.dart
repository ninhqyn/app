part of 'profile_bloc.dart';

@immutable
sealed class ProfileState extends Equatable {}

final class ProfileInitial extends ProfileState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class Loading extends ProfileState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class Info extends ProfileState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
final class MyOrder extends ProfileState{
  final List<Order> orders;
  final int statusId;
  MyOrder({
    this.orders = const<Order>[],
    this.statusId = 1
});
  MyOrder copyWith({
    List<Order>? orders,
    int? statusId,
}){
    return MyOrder(
      orders: orders ?? this.orders,
      statusId: statusId ?? this.statusId
    );
  }
  @override
  List<Object?> get props => [orders,statusId];
}
final class Setting extends ProfileState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class OrderDetailState extends ProfileState{
  final Order order;

  OrderDetailState(this.order);

  @override
  // TODO: implement props
  List<Object?> get props => [order];
}
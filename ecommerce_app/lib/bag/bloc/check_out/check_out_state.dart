part of 'check_out_bloc.dart';

@immutable
sealed class CheckOutState extends Equatable{}
final class LoadingDataCheckOut extends CheckOutState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class OrderSuccessState extends CheckOutState{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
final class CheckOutInitial extends CheckOutState {

  final Address? address;
  final String? deliveryMethod;
  final double? deliveryPrice;
  final double? order;
  final double? total;
  final int? paymentMethodId;
  CheckOutInitial({
    this.address,
    this.deliveryPrice,
    this.deliveryMethod,
    this.order,
    this.total,
    this.paymentMethodId
});
  CheckOutInitial copyWith({
    Address ? address,
    double ? deliveryPrice,
    double ? order,
    String ? deliveryMethod,
    double ? total,
    int ? paymentMethodId

}){
    return CheckOutInitial(
        order: order ?? this.order,
    address: address ?? this.address,
    deliveryPrice: deliveryPrice  ?? this.deliveryPrice,
    deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      total: total ?? this.total,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId
    );
}
  @override
  // TODO: implement props
  List<Object?> get props =>[address,deliveryPrice,order,deliveryMethod,total,paymentMethodId];
}

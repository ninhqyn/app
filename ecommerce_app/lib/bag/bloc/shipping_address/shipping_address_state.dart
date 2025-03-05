part of 'shipping_address_bloc.dart';

@immutable
sealed class ShippingAddressState extends Equatable {}

final class ShippingAddressInitial extends ShippingAddressState {
  final List<Address> address;
  final Address? addressSelected;
  ShippingAddressInitial(
      {
        required this.address,
        this.addressSelected
      });
  ShippingAddressInitial copyWith({
    List<Address>? address,
    Address? addressSelected
  }) {
    return ShippingAddressInitial(
        address: address ?? this.address,
      addressSelected: addressSelected ?? this.addressSelected
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [address,addressSelected];
}
final class LoadingShipping extends ShippingAddressState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class DefaultAddressSuccess extends ShippingAddressState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

part of 'shipping_address_bloc.dart';

@immutable
sealed class ShippingAddressEvent {}
class FetchAddress extends ShippingAddressEvent{}
class UseDefaultAddress extends ShippingAddressEvent{
  final Address addressSelected;

  UseDefaultAddress(this.addressSelected);
}


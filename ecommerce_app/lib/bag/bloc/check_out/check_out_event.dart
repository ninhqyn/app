part of 'check_out_bloc.dart';

@immutable
sealed class CheckOutEvent {}
final class FetchDataOrder extends CheckOutEvent{
  final double order;

  FetchDataOrder(this.order);
}
final class ChangedAddressShipping extends CheckOutEvent{}
final class ChangedPayment extends CheckOutEvent{}
final class SelectDeliveryMethod extends CheckOutEvent{}
final class SubmitOrder extends CheckOutEvent{}
part of 'form_address_bloc.dart';

@immutable
sealed class FormAddressEvent {}
final class LoadedFormAddress extends FormAddressEvent{}
final class SelectProvince extends FormAddressEvent{
  final Province province;
  SelectProvince(this.province);
}
final class SelectDistrict extends FormAddressEvent{
  final District district;
  SelectDistrict(this.district);
}
final class SelectWard extends FormAddressEvent{
  final Ward ward;
  SelectWard(this.ward);
}
final class ReceiverNameChanged extends FormAddressEvent{
  final String receiverName;

  ReceiverNameChanged(this.receiverName);
}
final class AddressDetailChanged extends FormAddressEvent{
  final String addressDetail;

  AddressDetailChanged(this.addressDetail);
}
final class PhoneChanged extends FormAddressEvent{
  final String phone;

  PhoneChanged(this.phone);
}
final class DefaultChanged extends FormAddressEvent{
  final bool isDefault;

  DefaultChanged(this.isDefault);
}
final class SaveButton extends FormAddressEvent{}
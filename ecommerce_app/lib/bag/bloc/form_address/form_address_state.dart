part of 'form_address_bloc.dart';

@immutable
sealed class FormAddressState extends Equatable{}
final class LoadingFormAddress extends FormAddressState{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
final class FormAddressSuccess extends FormAddressState{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
final class FormAddressInitial extends FormAddressState {
  final List<Province> provinces;
  final List<District> districts;
  final List<Ward> wards;
  final Province? province;
  final District? district;
  final Ward? ward;
  final String? address;
  final String? receiverName;
  final String? phone;
  final bool isDefault;
  FormAddressInitial({
    required this.provinces,
    required this.districts,
    required this.wards,
    this.province,
    this.district,
    this.ward,
    this.address,
    this.receiverName,
    this.phone,
    this.isDefault = false
});
  FormAddressInitial copyWith({
    List<Province>? provinces,
    List<District>? districts,
    List<Ward>? wards,
    Province? province,
    District? district,
    Ward? ward,
    String? address,
    String? receiverName,
    String? phone,
    bool? isDefault

}){
    return FormAddressInitial(
        provinces: provinces ?? this.provinces,
      districts: districts ?? this.districts,
      wards: wards ?? this.wards,
      province: province,
      district: district,
      ward:  ward,
      address:  address ?? this.address,
      receiverName:  receiverName ?? this.receiverName,
      phone:  phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault
    );
  }
  @override
  // TODO: implement props
  List<Object?> get props => [provinces,districts,wards,province,district,ward,address,DateTime.now(),receiverName,isDefault,phone];
}

import 'package:address_repository/address_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vn_repository/vn_repository.dart';

part 'form_address_event.dart';
part 'form_address_state.dart';

class FormAddressBloc extends Bloc<FormAddressEvent, FormAddressState> {
  final VnRepository vnRepository;
  final AddressRepository addressRepository;
  final AuthenticationRepository authenticationRepository;
  final bool isEditing;
  final Address? initialAddress;
  FormAddressBloc({
    required this.vnRepository,
    required this.addressRepository,
    required this.authenticationRepository,
    this.initialAddress,
    this.isEditing = false
}) : super(FormAddressInitial(
      provinces: const<Province>[],
      districts:const<District>[],
      wards: const<Ward>[]),
  ) {
    on<LoadedFormAddress>(_onLoadedAddress);
    on<SelectProvince>(_onSelectProvince);
    on<SelectDistrict>(_onSelectDistrict);
    on<SelectWard>(_onSelectWard);
    on<ReceiverNameChanged>(_onReceiverNameChanged);
    on<PhoneChanged>(_onPhoneChanged);
    on<AddressDetailChanged>(_onAddressDetailChanged);
    on<DefaultChanged>(_onDefaultChanged);
    on<SaveButton>(_onSaveButton);
}
Future<void> _onSaveButton(SaveButton event,Emitter<FormAddressState> emit) async{
    if(state is FormAddressInitial){
      final currentState = state as FormAddressInitial;
      print('receiver name : ${currentState.receiverName}');
      print('province name : ${currentState.province!.name}');
      print('district name : ${currentState.district!.name}');
      print('ward name : ${currentState.ward!.name}');
      print('Address name : ${currentState.address}');
      print('phone name : ${currentState.phone}');
      print('is default  : ${currentState.isDefault}');
      final tokenModel = await authenticationRepository.getTokenModel();

      if(!isEditing){
        Address address = Address(
            addressId: 0,
            userId: 0,
            receiverName: currentState.receiverName!,
            phone: currentState.phone!,
            provinceId: currentState.province!.code,
            provinceName: currentState.province!.name,
            districtId: currentState.district!.code,
            districtName: currentState.district!.name,
            wardId: currentState.ward!.code,
            wardName: currentState.ward!.name,
            detailAddress: currentState.address!,
            isDefault: currentState.isDefault,
            createdAt: DateTime.now()
        );
        final result = await addressRepository.addAddress(address, tokenModel.accessToken);
        print(result);
      }else{
        Address address = Address(
            addressId: initialAddress!.addressId,
            userId: initialAddress!.userId,
            receiverName: currentState.receiverName!,
            phone: currentState.phone!,
            provinceId: currentState.province!.code,
            provinceName: currentState.province!.name,
            districtId: currentState.district!.code,
            districtName: currentState.district!.name,
            wardId: currentState.ward!.code,
            wardName: currentState.ward!.name,
            detailAddress: currentState.address!,
            isDefault: currentState.isDefault,
            createdAt: DateTime.now()
        );
        final result = await addressRepository.updateAddress(address, tokenModel.accessToken);
        print('update success $result');
      }
      emit(FormAddressSuccess());


    }
}
void _onReceiverNameChanged(ReceiverNameChanged event,Emitter<FormAddressState> emit){
    if(state is FormAddressInitial){
      final currentState = state as FormAddressInitial;
      final province = currentState.province;
      final district = currentState.district;
      final ward = currentState.ward;
      emit(currentState.copyWith(province: province,district: district,ward: ward,receiverName: event.receiverName));
    }
}
  void _onPhoneChanged(PhoneChanged event,Emitter<FormAddressState> emit){
    if(state is FormAddressInitial){
      final currentState = state as FormAddressInitial;
      final province = currentState.province;
      final district = currentState.district;
      final ward = currentState.ward;
      emit(currentState.copyWith(province: province,district: district,ward: ward,phone: event.phone));
    }
  }
  void _onAddressDetailChanged(AddressDetailChanged event,Emitter<FormAddressState> emit){
    if(state is FormAddressInitial){
      final currentState = state as FormAddressInitial;
      final province = currentState.province;
      final district = currentState.district;
      final ward = currentState.ward;
      emit(currentState.copyWith(province: province,district: district,ward: ward,address: event.addressDetail));
    }
  }
  void _onDefaultChanged(DefaultChanged event,Emitter<FormAddressState> emit){
    if(state is FormAddressInitial){
      final currentState = state as FormAddressInitial;
      final province = currentState.province;
      final district = currentState.district;
      final ward = currentState.ward;
      emit(currentState.copyWith(province: province,district: district,ward: ward,isDefault: event.isDefault));
    }
  }
  Future<void> _onLoadedAddress(LoadedFormAddress event, Emitter<FormAddressState> emit) async {
    if (state is FormAddressInitial) {
      final currentState = state as FormAddressInitial;
      if(isEditing){
        final results = await Future.wait([
          vnRepository.getAllDistrictByCode(initialAddress!.provinceId),
          vnRepository.getAllWardByCode(initialAddress!.districtId),
          vnRepository.getAllProvince()
        ]);
        if (isEditing && initialAddress != null) {
          final districts = results[0] as List<District>;
          final wards = results[1] as List<Ward>;
          final provinces = results[2] as List<Province>;

          // Tìm district và ward trong danh sách
          District? selectedDistrict;
          Ward? selectedWard;
          Province? selectedProvince;
          try {
            selectedDistrict = districts.firstWhere(
                  (district) => district.code == initialAddress!.districtId,
            );
          } catch (_) {
            selectedDistrict = districts.isNotEmpty ? districts.first : null;
          }

          try {
            selectedWard = wards.firstWhere(
                  (ward) => ward.code == initialAddress!.wardId,
            );
          } catch (_) {
            selectedWard = wards.isNotEmpty ? wards.first : null;
          }
          try {
            selectedProvince = provinces.firstWhere(
                  (province) => province.code == initialAddress!.provinceId,
            );
          } catch (_) {
            selectedProvince = provinces.isNotEmpty ? provinces.first : null;
          }
          emit(currentState.copyWith(
            provinces: provinces,
            receiverName: initialAddress!.receiverName,
            phone: initialAddress!.phone,
            address: initialAddress!.detailAddress,
            districts: districts,
            wards: wards,
            province: selectedProvince,
            district: selectedDistrict,
            ward: selectedWard,
            isDefault: initialAddress!.isDefault,
          ));
        }
      }else{
        final province2 = await vnRepository.getAllProvince();
        emit(currentState.copyWith(provinces: province2));
      }

    }
  }
  Future<void> _onSelectProvince(SelectProvince event,Emitter<FormAddressState> emit) async{
    final districts = await vnRepository.getAllDistrictByCode(event.province.code);
    if(state is FormAddressInitial){
      final currentState  = state as FormAddressInitial;

      emit(currentState.copyWith(districts: districts,province: event.province,ward: null,district: null));
      print('province');
    }
  }
  Future<void> _onSelectDistrict(SelectDistrict event,Emitter<FormAddressState> emit) async{
    final wards = await vnRepository.getAllWardByCode(event.district.code);
    if(state is FormAddressInitial){
      final currentState  = state as FormAddressInitial;

      emit(currentState.copyWith(district: event.district,wards: wards,province: currentState.province,ward: null));
      print('district');
    }
  }
  void _onSelectWard(SelectWard event,Emitter<FormAddressState> emit) {
    //final districts = await vnRepository.getAllDistrictByCode(event.district.code);
    if(state is FormAddressInitial){
      final currentState  = state as FormAddressInitial;
      emit(currentState.copyWith(ward: event.ward,province: currentState.province,district: currentState.district));
      print('ward');
    }


  }
}


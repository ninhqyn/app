import 'package:address_repository/address_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vn_repository/vn_repository.dart';

part 'shipping_address_event.dart';
part 'shipping_address_state.dart';

class ShippingAddressBloc extends Bloc<ShippingAddressEvent, ShippingAddressState> {
  ShippingAddressBloc({
    required this.authenticationRepository,
    required this.addressRepository,
}) : super(
      ShippingAddressInitial(address: const<Address>[])) {
    on<FetchAddress>(_onFetchAddress);
    on<UseDefaultAddress>(_onUseDefaultAddress);
  }
  final AuthenticationRepository authenticationRepository;
  final AddressRepository addressRepository;
  Future<void> _onUseDefaultAddress(UseDefaultAddress event,Emitter<ShippingAddressState> emit) async{
    if(state is ShippingAddressInitial){
      final currentState = state as ShippingAddressInitial;
      final tokenModel = await authenticationRepository.getTokenModel();
      final updateAddress = event.addressSelected;
      updateAddress.isDefault = true;
      final result = await addressRepository.updateAddress(updateAddress,tokenModel.accessToken);
      print('result');
      final address = await addressRepository.getAddresses(tokenModel.accessToken);
      emit(currentState.copyWith(address: address));
      emit(DefaultAddressSuccess());
      emit(currentState.copyWith(address: address));
    }
  }
  Future<void> _onFetchAddress(FetchAddress event,Emitter<ShippingAddressState> emit) async{
    if(state is ShippingAddressInitial){
      final currentState = state as ShippingAddressInitial;
      emit(LoadingShipping());
      try{
        final tokenModel = await authenticationRepository.getTokenModel();
        final address = await addressRepository.getAddresses(tokenModel.accessToken);
        emit(currentState.copyWith(address: address));
        print('fetch address ne');
      }catch(e){
        throw Exception('error to fetch data address');
      }
    }
  }
}

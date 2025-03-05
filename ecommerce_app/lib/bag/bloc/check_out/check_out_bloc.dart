import 'package:address_repository/address_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:order_repository/order_repository.dart';

part 'check_out_event.dart';
part 'check_out_state.dart';

class CheckOutBloc extends Bloc<CheckOutEvent, CheckOutState> {
  final AuthenticationRepository authenticationRepository;
  final AddressRepository addressRepository;
  final OrderRepository orderRepository;
  CheckOutBloc(
  {
    required this.addressRepository,
    required this.authenticationRepository,
    required this.orderRepository
  }
      ) : super(CheckOutInitial(deliveryPrice: 30000)) {
    on<FetchDataOrder>(_onFetchDataOrder);
    on<ChangedAddressShipping>(_onChangedAddressShipping);
    on<SubmitOrder>(_onSubmitOrder);
  }
  Future<void> _onSubmitOrder(SubmitOrder event,Emitter<CheckOutState> emit) async{
    if(state is CheckOutInitial){
      final currentState = state as CheckOutInitial;
      //emit() loading
      final tokenModel  = await authenticationRepository.getTokenModel();
      OrderCreateRequest orderRequest = OrderCreateRequest(
          orderId: 0,
          userId: 0,
          addressId: currentState.address!.addressId,
          orderCode: '123',
          statusId: 1,
          paymentMethodId: 1,
          subTotal: currentState.total!,
          shippingFee: 30000,
          note: 'ko co gi',
          totalAmount: currentState.total!,
          paymentStatus: '12',
          createdAt:DateTime.now(),
          updatedAt: DateTime.now());
      final result = await orderRepository.createOrder(tokenModel.accessToken, orderRequest);
      if(result){
        emit(OrderSuccessState());
        emit(currentState);
      }
    }

  }
  Future<void> _onChangedAddressShipping(ChangedAddressShipping event,Emitter<CheckOutState> emit) async{
    if (state is CheckOutInitial) {
      final currentState = state as CheckOutInitial;
      emit(LoadingDataCheckOut());
      final tokenModel = await authenticationRepository.getTokenModel();
      final addresses = await addressRepository.getAddresses(tokenModel.accessToken);

      Address? defaultAddress;
      for (int i = 0; i < addresses.length; i++) {
        if (addresses[i].isDefault) {
          defaultAddress = addresses[i];
          break;
        }
      }
      if (defaultAddress != null) {
        emit(currentState.copyWith(address: defaultAddress));
      }else{
        emit(currentState);
      }

    }
  }
  Future<void> _onFetchDataOrder(FetchDataOrder event, Emitter<CheckOutState> emit) async {
    if (state is CheckOutInitial) {
      final currentState = state as CheckOutInitial;
      emit(LoadingDataCheckOut());
      final tokenModel = await authenticationRepository.getTokenModel();
      final addresses = await addressRepository.getAddresses(tokenModel.accessToken);

      Address? defaultAddress;
      for (int i = 0; i < addresses.length; i++) {
        if (addresses[i].isDefault) {
          defaultAddress = addresses[i];
          break;
        }
      }
      double total = event.order+ currentState.deliveryPrice!.toDouble();
      if (defaultAddress != null) {
        emit(currentState.copyWith(address: defaultAddress,order: event.order,total:total));
      }else{
        emit(currentState);
      }

    }
  }
}

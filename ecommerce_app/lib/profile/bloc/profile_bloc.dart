import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:order_repository/order_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(
  {
    required this.authenticationRepository,
    required this.orderRepository
}
      ) : super(ProfileInitial()) {
    on<NavigatorMyOrder>(_onNavigatorMyOrder);
    on<LoadInfo>(_onLoadInfo);
    on<NavigatorOrderDetail>(_onNavigatorOderDetail);
    on<NavigatorSetting>(_onNavigatorSetting);
    on<NavigatorBack>(_onNavigatorBack);
    on<OrderTabSelect>(_onOrderTabSelect);
  }
  final OrderRepository orderRepository;
  final AuthenticationRepository authenticationRepository;
  void _onNavigatorBack(NavigatorBack event, Emitter<ProfileState> emit){
    switch(event.index){
      case 0:
        emit(ProfileInitial());
      case 1:
        //emit(MyOrder());
        
    }
  }
  Future<void> _onOrderTabSelect(OrderTabSelect event,Emitter<ProfileState> emit) async{
    if(state is MyOrder){
      int statusId;
      final currentState = state as MyOrder;
      switch (event.tabIndex){
        case 0:
          statusId = 1;
        case 1:
          statusId = 2;
        case 2:
          statusId = 3;
        default:
          statusId = 1;
      }
      final tokenModel = await authenticationRepository.getTokenModel();
      final orders = await orderRepository.getOrders(tokenModel.accessToken, statusId);
      emit(currentState.copyWith(orders:orders,statusId: statusId));
      print('success');
    }
  }
  Future<void> _onNavigatorOderDetail (NavigatorOrderDetail event,Emitter<ProfileState> emit) async{
    emit(Loading());
    try{
      emit(OrderDetailState(event.order));
    }
    catch (e){
      print(e.toString());
    }
  }
  Future<void> _onNavigatorSetting (NavigatorSetting event,Emitter<ProfileState> emit) async{
    emit(Loading());
    try{
      await Future.delayed(Duration(seconds: 1));
      // loading data
      emit(Setting());

    }
    catch (e){
      print(e.toString());
    }
  }
  Future<void> _onNavigatorMyOrder (NavigatorMyOrder event,Emitter<ProfileState> emit) async{
    emit(Loading());
    try{
      emit(MyOrder());
      if(state is MyOrder){
        final currentState = state as MyOrder;
        final tokenModel = await authenticationRepository.getTokenModel();
        final orders = await orderRepository.getOrders(tokenModel.accessToken, currentState.statusId);
        emit(currentState.copyWith(orders:orders));
        print('success');
      }
      
    }
    catch (e){
      print(e.toString());
    }
  }
  Future<void> _onLoadInfo (LoadInfo event,Emitter<ProfileState> emit) async{
    emit(Loading());
    try{
      await Future.delayed(Duration(seconds: 1));
      // loading data
      emit(ProfileInitial());

    }
    catch (e){
      print(e.toString());
    }
  }

}

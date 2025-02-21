import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<NavigatorMyOrder>(_onNavigatorMyOrder);
    on<LoadInfo>(_onLoadInfo);
    on<NavigatorOrderDetail>(_onNavigatorOderDetail);
    on<NavigatorSetting>(_onNavigatorSetting);
    on<NavigatorBack>(_onNavigatorBack);
  }
  void _onNavigatorBack(NavigatorBack event, Emitter<ProfileState> emit){
    switch(event.index){
      case 0:
        emit(ProfileInitial());
      case 1:
        emit(MyOrder());
    }
  }
  Future<void> _onNavigatorOderDetail (NavigatorOrderDetail event,Emitter<ProfileState> emit) async{
    emit(Loading());
    try{
      await Future.delayed(Duration(seconds: 1));
      // loading data
      emit(OrderDetail());

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
      await Future.delayed(Duration(seconds: 2));
      // loading data
      emit(MyOrder());

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

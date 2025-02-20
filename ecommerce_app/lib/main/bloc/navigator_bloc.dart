import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'navigator_event.dart';
part 'navigator_state.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, MyNavigatorState> {
  NavigatorBloc() : super(const MyNavigatorState()) {
    on<NavigatorEvent>(_onNavigatorEvent);
  }
  void _onNavigatorEvent(NavigatorEvent event, Emitter<MyNavigatorState> emit){
    emit(state.copyWith(selectedIndex: event.selectedIndex));
  }

}

part of 'navigator_bloc.dart';

@immutable
class NavigatorEvent extends Equatable{
  final int selectedIndex;

  const NavigatorEvent(this.selectedIndex);

  @override
  // TODO: implement props
  List<Object?> get props => [selectedIndex];

}

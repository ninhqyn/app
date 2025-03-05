part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}
class NavigatorMyOrder extends ProfileEvent{}
class NavigatorOrderDetail  extends ProfileEvent{
  final Order order;

  NavigatorOrderDetail(this.order);
}
class NavigatorSetting extends ProfileEvent{}
class LoadInfo extends ProfileEvent{}
class NavigatorBack extends ProfileEvent{
  final int index;

  NavigatorBack(this.index);
}
class OrderTabSelect extends ProfileEvent{
  final int  tabIndex;

  OrderTabSelect(this.tabIndex);
}
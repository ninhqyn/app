part of 'profile_bloc.dart';

@immutable
sealed class ProfileState extends Equatable {}

final class ProfileInitial extends ProfileState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class Loading extends ProfileState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class Info extends ProfileState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
final class MyOrder extends ProfileState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class Setting extends ProfileState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class OrderDetail extends ProfileState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
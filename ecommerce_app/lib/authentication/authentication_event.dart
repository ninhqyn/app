part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {}
final class AuthenticationRequested extends AuthenticationEvent {

}

final class AuthenticationLogout extends AuthenticationEvent {}
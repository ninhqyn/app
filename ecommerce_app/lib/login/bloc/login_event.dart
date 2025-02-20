part of 'login_bloc.dart';

@immutable
sealed class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props =>[];
}
final class EmailChanged extends LoginEvent{
  final String email;
  const EmailChanged(this.email);
  @override
  List<Object> get props => [];
}
final class PasswordChanged extends LoginEvent{
  final String password;
  const PasswordChanged(this.password);
  @override
  List<Object> get props => [];
}
final class LoginSubmitted extends LoginEvent{

  const LoginSubmitted();
  @override
  List<Object> get props => [];
}
final class ObscurePassword extends LoginEvent{

  const ObscurePassword();
  @override
  List<Object> get props => [];
}
final class SignUpClick extends LoginEvent{

  const SignUpClick();
  @override
  List<Object> get props => [];
}

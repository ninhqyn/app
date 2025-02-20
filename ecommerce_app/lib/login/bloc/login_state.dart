part of 'login_bloc.dart';

enum LoginStatus{initial,inProgress,success,failure}

class  LoginState  extends Equatable{
  final String email;
  final String password;
  final LoginStatus status;
  final bool isValid;
  final String emailError;
  final String passwordError;
  final bool obscurePassword;
  final bool emailTouched;
  const LoginState(
      {
        this.email = '',
        this.password = '',
        this.status = LoginStatus.initial,
        this.isValid = false,
        this.emailError = '',
        this.passwordError ='',
        this.emailTouched = false,
        this.obscurePassword = true

      });

  // Sửa phương thức copyWith để sử dụng các named parameters
  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    bool? isValid,
    String? emailError,
    String? passwordError,
    bool? obscurePassword,
    bool? emailTouched
  }) {
    return  LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      emailTouched:  emailTouched ?? this.emailTouched
    );
  }

  @override
  List<Object?> get props => [email, password, status,obscurePassword,emailError,passwordError];
}
class SignUpState extends LoginState{
  @override
  List<Object?> get props => [];
}


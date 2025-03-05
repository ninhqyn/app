import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required AuthenticationRepository authenticationRepository}) :
      _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<ObscurePassword>(_onObscurePassword);
    on<SignUpClick>(_onSignUpClick);

  }
  final AuthenticationRepository _authenticationRepository;
  void _onEmailChanged(EmailChanged event,Emitter<LoginState> emit){
    final email = event.email;
    emit(
      state.copyWith(
          email:email,
          emailError: _errorEmail(email),
          emailTouched: email.isNotEmpty,
          isValid: _errorPassword(state.password).isEmpty && _errorEmail(email).isEmpty

      ),
    );
  }
  void _onSignUpClick(SignUpClick event,Emitter<LoginState> emit){
   emit(SignUpState());
  }
  String _errorEmail(String email) {
    if (email.isEmpty) {
      return 'Email không được để trống';
    }

    // Regex cho email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(email)) {
      return 'Email không hợp lệ';
    }

    return '';
  }

  String _errorPassword(String password) {
    if (password.isEmpty) {
      return 'Mật khẩu không được để trống';
    }

    // if (password.length < 6) {
    //   return 'Mật khẩu phải có ít nhất 6 ký tự';
    // }

    return '';
  }
  void _onPasswordChanged(PasswordChanged event,Emitter<LoginState> emit){
    String password = event.password;
    emit(state.copyWith(
        password: password,
        passwordError: _errorPassword(event.password),
        isValid: _errorPassword(password).isEmpty && _errorEmail(state.email).isEmpty
    ));
  }
  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    final emailError = _errorEmail(state.email);
    final passwordError = _errorPassword(state.password);

    if (emailError.isNotEmpty || passwordError.isNotEmpty) {
      print(emailError);
      print(passwordError);
      emit(state.copyWith(
        emailError: emailError,
        passwordError: passwordError,
      ));
      return;
    }

    emit(state.copyWith(status: LoginStatus.inProgress));

    try {
      // You're missing the 'await' keyword here
      final status = await _authenticationRepository.signIn(
          email: state.email,
          password: state.password
      );
      print(status);
      if (status == AuthenticationStatus.authenticated) {
        emit(state.copyWith(status: LoginStatus.success));
      } else if (status == AuthenticationStatus.unauthenticated) {
        emit(state.copyWith(
            status: LoginStatus.failure,
            errorMessage: 'An error occurred'
        ));
      } else {
        emit(state.copyWith(
            status: LoginStatus.failure,
            errorMessage: 'An error occurred'
        ));
      }
    } catch (error) {
      print('Login error: $error');
      emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'An unexpected error occurred'
      ));
    }
  }
  void _onObscurePassword(ObscurePassword event, Emitter<LoginState> emit) {
    final currentValue = state.obscurePassword;
    print('Giá trị hiện tại: $currentValue');

    // Tạo state mới với giá trị đã đảo ngược
    final newState = state.copyWith(
      obscurePassword: !currentValue,
    );

    // Emit state mới
    emit(newState);

    print('Giá trị mới trong newState: ${newState.obscurePassword}');
  }


}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:user_repository/user_repository.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  AuthenticationBloc({
  required authenticationRepository,
    required userRepository})
      :_authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationRequested>(_onRequested);
    on<AuthenticationLogout>(_onLogout);
  }

  Future<void> _onRequested(
      AuthenticationRequested event,
      Emitter<AuthenticationState> emit,
      ) async {
    await Future.delayed(const Duration(seconds: 2));
    print('check auth');
    final status =await _authenticationRepository.checkAuthStatus();

    // Emit states based on the status
    switch (status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        final user = await _tryGetUser();
        return emit(
          user != null
              ? AuthenticationState.authenticated(user)
              : const AuthenticationState.unauthenticated(),
        );
      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());
    }
  }


  Future<User?> _tryGetUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } catch (_) {
      return null;
    }
  }
  Future<void> _onLogout(AuthenticationLogout event,Emitter<AuthenticationState> emit) async{
    await _authenticationRepository.deleteToken();
    emit(const AuthenticationState.unauthenticated());

  }
}

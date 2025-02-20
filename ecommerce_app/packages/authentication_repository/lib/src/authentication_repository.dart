
import 'dart:async';

enum AuthenticationStatus {unknown,authenticated,unauthenticated}

class AuthenticationRepository{
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }
   AuthenticationStatus logIn({required String username,required String password}){
    if(username == '123'){
      return AuthenticationStatus.authenticated;
    }
    return AuthenticationStatus.unauthenticated;

  }
  void logOut(){
     print('log out');
  }
  void dispose(){
    _controller.close();
  }
}
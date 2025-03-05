// AuthenticationRepository.dart
import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:authentication_repository/src/authentication_local_data_source/authentication_local_data_source.dart';
import 'package:authentication_repository/src/models/token_model.dart';

enum AuthenticationStatus {unknown, authenticated, unauthenticated}

class AuthenticationRepository {
  final AuthenticationApiClient authenticationApiClient;
  final AuthenticationLocalDataSource authenticationLocalDataSource;
  AuthenticationRepository(
      this.authenticationApiClient,
      this.authenticationLocalDataSource);

  Future<AuthenticationStatus> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await authenticationApiClient.signIn(email, password);

      if (result['status'] == 'success') {

        final tokenJson = result['data'] as Map<String, dynamic>;
        final tokenModel = TokenModel.fromJson(tokenJson);
        authenticationLocalDataSource.saveAccessToken(tokenModel.accessToken);
        authenticationLocalDataSource.saveRefreshToken(tokenModel.refreshToken);

        return AuthenticationStatus.authenticated;
      } else if (result['statusCode'] == 404) {
        return AuthenticationStatus.unauthenticated;
      } else {
        return AuthenticationStatus.unknown;
      }
    } catch (e) {
      print('Error in repository: $e');
      return AuthenticationStatus.unknown;
    }
  }

  Future<void> deleteToken() async {
    await authenticationLocalDataSource.removeAccessToken();
    await authenticationLocalDataSource.removeRefreshToken();
  }
  Future<TokenModel> getTokenModel() async {
    final accessToken =  await authenticationLocalDataSource.getAccessToken();
    final refreshToken =  await authenticationLocalDataSource.getRefreshToken();
    if(accessToken!=null && refreshToken!=null){
      return TokenModel(accessToken, refreshToken);
    }
   return TokenModel('', '');
  }
  Future<AuthenticationStatus> checkAuthStatus() async {
    final token = await authenticationLocalDataSource.getAccessToken();
    final refreshToken = await authenticationLocalDataSource.getRefreshToken();
    if (token != null && refreshToken!=null) {
      final verifyResult = await authenticationApiClient.verifyToken(token);
      if (verifyResult) {
        // Token còn hiệu lực
        print('token con hieu luc');
        return AuthenticationStatus.authenticated;
      } else {
        print('renew token');
      final refreshResult = await authenticationApiClient.refreshTokens(TokenModel(token, refreshToken));
      if(refreshResult.accessToken =='' && refreshResult.refreshToken ==''){
        return AuthenticationStatus.authenticated;
      }
      await authenticationLocalDataSource.saveAccessToken(refreshResult.accessToken);
      await authenticationLocalDataSource.saveRefreshToken(refreshResult.refreshToken);

      return AuthenticationStatus.authenticated;
        }
    } else {
      return AuthenticationStatus.unauthenticated;
    }
  }


  //
  Future<TokenModel> refreshTokens() async {
    try {
      final currentToken = await getTokenModel();
      if (currentToken.accessToken.isEmpty || currentToken.refreshToken.isEmpty) {
        return TokenModel('', '');
      }
      final refreshedToken = await authenticationApiClient.refreshTokens(currentToken);
      if (refreshedToken.accessToken.isNotEmpty && refreshedToken.refreshToken.isNotEmpty) {
        await authenticationLocalDataSource.saveAccessToken(refreshedToken.accessToken);
        await authenticationLocalDataSource.saveRefreshToken(refreshedToken.refreshToken);
      }

      return refreshedToken;
    } catch (e) {
      print('Error refreshing tokens: $e');
      await deleteToken();
      return TokenModel('', '');
    }
  }

  // Phương thức verify token
  Future<bool> verifyToken() async {
    try {
      // Lấy access token từ local storage
      final accessToken = await authenticationLocalDataSource.getAccessToken();

      // Nếu không có token, trả về false
      if (accessToken == null || accessToken.isEmpty) {
        return false;
      }

      // Gọi API kiểm tra token
      final isValid = await authenticationApiClient.verifyToken(accessToken);

      // Nếu token không hợp lệ, thử refresh
      if (!isValid) {
        final refreshedToken = await refreshTokens();
        return refreshedToken.accessToken.isNotEmpty;
      }

      return true;
    } catch (e) {
      print('Error verifying token: $e');
      return false;
    }
  }


/*
  // Method to sign out
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }*/
}
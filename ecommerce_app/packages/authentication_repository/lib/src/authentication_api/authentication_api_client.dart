// AuthenticationApiClient.dart
import 'dart:convert';
import 'package:authentication_repository/src/models/token_model.dart';
import 'package:http/http.dart' as http;

class AuthenticationApiClient {
  final http.Client _httpClient;
  static const String baseUrl = 'localhost:7205';

  AuthenticationApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<TokenModel> refreshTokens(TokenModel tokenModel) async {
    try {
      final request = Uri.https(
          baseUrl,
          '/api/Auth/refresh-token'
      );

      // In chi tiết token để kiểm tra
      print('Refresh Token Request:');
      print(jsonEncode({
        "accessToken": tokenModel.accessToken,
        "refreshToken": tokenModel.refreshToken
      }));

      final response = await _httpClient.post(
        request,
        body: jsonEncode({
          "accessToken": tokenModel.accessToken,
          "refreshToken": tokenModel.refreshToken
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // In toàn bộ response để phân tích
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        return TokenModel(
          responseBody['accessToken'],
          responseBody['refreshToken'],
        );
      } else {
        return TokenModel('', '');
      }
    } catch (e, stackTrace) {
      // In stacktrace để có thông tin chi tiết hơn
      print('Error refreshing tokens: $e');
      print('Stacktrace: $stackTrace');
      rethrow;
    }
  }

  Future<bool> verifyToken(String accessToken) async {
    try {
      final request = Uri.https(
           baseUrl,
          '/api/Auth/verify-token'
      );

      final response = await _httpClient.post(
        request,
        body: jsonEncode({
          "accessToken": accessToken
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final String responseBody = jsonDecode(response.body);
        return responseBody.toLowerCase() == 'valid';
      } else {
        // Handle non-200 status codes
       // throw Exception('Token verification failed. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Log the error or handle it appropriately
      print('Error verifying token: $e');
      return false;
    }
  }
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      // Using https and query parameters as shown in the API screenshot
      final request = Uri.https(
          baseUrl,
          '/api/Auth',
          {
            'email': email,
            'password': password,
          }
      );

      // Send the POST request - note: no body is needed as parameters are in URL
      final response = await _httpClient.post(
        request,
        headers: {'Accept': 'text/plain'},
      );

      // Print the request for debugging (optional)
      print('Request URL: $request');

      if (response.statusCode == 200) {
        // Success case
        final tokenJson = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'status': 'success',
          'data': tokenJson,
        };
      } else {
        // Error case
        return {
          'status': 'error',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print('Exception in signIn: $e');
      return {
        'status': 'exception',
        'message': e.toString(),
      };
    }
  }
}
import 'package:authentication_repository/authentication_repository.dart';
import 'package:http/http.dart' as http;
class HttpService{
  final http.Client _httpClient;
  final AuthenticationRepository _authenticationRepository;
  HttpService({
    required http.Client httpClient,
    required AuthenticationRepository authenticationRepository
  }) :
        _httpClient = httpClient,
        _authenticationRepository = authenticationRepository;

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    try {
      // Lấy token hiện tại
      var tokenModel = await _authenticationRepository.getTokenModel();

      // Nếu headers không được cung cấp, tạo mới
      headers ??= {};
      headers['Authorization'] = 'Bearer ${tokenModel.accessToken}';

      final response = await _httpClient.get(url, headers: headers);

      // Nếu token hết hạn (401), thử refresh token
      if (response.statusCode == 401) {
        // Refresh token
        tokenModel = await _authenticationRepository.refreshTokens();

        // Cập nhật lại headers với token mới
        headers['Authorization'] = 'Bearer ${tokenModel.accessToken}';

        // Thử lại request
        return await _httpClient.get(url, headers: headers);
      }

      return response;
    } catch (error) {
      throw Exception('HTTP GET error: $error');
    }
  }

  // Tương tự cho phương thức post, put, delete, v.v.
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body}) async {
    try {
      // Logic tương tự như phương thức get
      var tokenModel = await _authenticationRepository.getTokenModel();

      headers ??= {};
      headers['Authorization'] = 'Bearer ${tokenModel.accessToken}';
      headers['Content-Type'] = 'application/json';

      final response = await _httpClient.post(url, headers: headers, body: body);

      if (response.statusCode == 401) {
        tokenModel = await _authenticationRepository.refreshTokens();

        headers['Authorization'] = 'Bearer ${tokenModel.accessToken}';

        return await _httpClient.post(url, headers: headers, body: body);
      }

      return response;
    } catch (error) {
      throw Exception('HTTP POST error: $error');
    }
  }

  Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body}) async {
    try {
      // Logic tương tự như phương thức get
      var tokenModel = await _authenticationRepository.getTokenModel();

      headers ??= {};
      headers['Authorization'] = 'Bearer ${tokenModel.accessToken}';
      headers['Content-Type'] = 'application/json';

      final response = await _httpClient.post(url, headers: headers, body: body);

      if (response.statusCode == 401) {
        tokenModel = await _authenticationRepository.refreshTokens();

        headers['Authorization'] = 'Bearer ${tokenModel.accessToken}';

        return await _httpClient.delete(url, headers: headers, body: body);
      }

      return response;
    } catch (error) {
      throw Exception('HTTP POST error: $error');
    }
  }

  Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body}) async {
    try {
      // Logic tương tự như phương thức get
      var tokenModel = await _authenticationRepository.getTokenModel();

      headers ??= {};
      headers['Authorization'] = 'Bearer ${tokenModel.accessToken}';
      headers['Content-Type'] = 'application/json';

      final response = await _httpClient.put(url, headers: headers, body: body);

      if (response.statusCode == 401) {
        tokenModel = await _authenticationRepository.refreshTokens();

        headers['Authorization'] = 'Bearer ${tokenModel.accessToken}';

        return await _httpClient.post(url, headers: headers, body: body);
      }

      return response;
    } catch (error) {
      throw Exception('HTTP POST error: $error');
    }
  }

}
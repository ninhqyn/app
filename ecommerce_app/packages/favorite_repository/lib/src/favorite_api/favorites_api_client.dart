import '../models/favorite_response.dart';
import 'package:http/http.dart' as http;
class FavoriteApiClient {
  static const _baseUrl = 'localhost:7205';
  final http.Client _httpClient;

  FavoriteApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<FavoriteResponse> addFavorite(int productId, String accessToken) async {
    try {
      final url = Uri.https(_baseUrl, '/api/Favorite/$productId');

      final response = await _httpClient.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      print(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FavoriteResponse(
          success: true,
          message: 'Added favorite successfully',
          statusCode: response.statusCode,
        );
      } else {
        return FavoriteResponse(
          success: false,
          message: 'Failed to add favorite: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return FavoriteResponse(
        success: false,
        message: 'Error adding favorite: $e',
      );
    }
  }
  Future<FavoriteResponse> removeFavorite(int productId, String accessToken) async {
    try {
      final url = Uri.https(_baseUrl, '/api/Favorite/$productId');

      final response = await _httpClient.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FavoriteResponse(
          success: true,
          message: 'Removed favorite successfully',
          statusCode: response.statusCode,
        );
      } else {
        return FavoriteResponse(
          success: false,
          message: 'Failed to remove favorite: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return FavoriteResponse(
        success: false,
        message: 'Error remove favorite: $e',
      );
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
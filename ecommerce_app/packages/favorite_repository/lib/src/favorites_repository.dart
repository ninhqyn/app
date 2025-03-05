import 'favorite_api/favorites_api_client.dart';
import 'models/favorite_response.dart';

class FavoriteRepository {
  final FavoriteApiClient favoriteApiClient;

  FavoriteRepository({required this.favoriteApiClient});

  Future<FavoriteResponse> addFavorite(int productId, String accessToken) async {
    try {
      final result = await favoriteApiClient.addFavorite(productId, accessToken);
      if (!result.success) {
        return FavoriteResponse(
          success: false,
          message: result.message,
          statusCode: result.statusCode,
        );
      }
      return FavoriteResponse(
        success: true,
        message: 'Favorite added successfully in repository',
        statusCode: result.statusCode,
      );
    } catch (e) {
      return FavoriteResponse(
        success: false,
        message: 'Repository error adding favorite: $e',
      );
    }
  }

  Future<bool> removeFavorite(int productId, String accessToken) async {
    try {
      final result = await favoriteApiClient.removeFavorite(productId, accessToken);
      if (!result.success) {
        return false;
      }
      return true;
    } catch (e) {
      throw Exception('Fail to remove Favorite');
    }
  }
}
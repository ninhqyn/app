import 'dart:convert';
import 'dart:io';
import 'package:cart_repository/src/models/models.dart';
import 'package:http/http.dart' as http;

class CartApiClient {
  static const baseUrl = 'localhost:7205';
  final http.Client _httpClient;

  CartApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  Future<bool> addToCart(int variantId, String accessToken) async {
    final request = Uri.https(
        baseUrl,
        '/api/Cart/add',
        {'variantId': variantId.toString()} // Send variantId as query parameter
    );

    final response = await _httpClient.post(
      request,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    print('add to cart');
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
  Future<bool> removeCartItem(int itemId, String accessToken) async {
    final request = Uri.https(
        baseUrl,
        '/api/Cart/remove',
        {'itemId': itemId.toString()} // Send variantId as query parameter
    );

    final response = await _httpClient.delete(
      request,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
  Future<bool> updateQuantity({required int itemId,required int quantity,required String accessToken}) async {
    final request = Uri.https(
        baseUrl,
        '/api/Cart/update-quantity',
        {
          'itemId': itemId.toString(),
          'quantity': quantity.toString(),
        }
    );

    final response = await _httpClient.put(
      request,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    print('Request URL: $request');
    print('Response Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      return true;
    }

    // In trường hợp khác bạn có thể thêm thông tin lỗi
    print('Error: ${response.body}');
    return false;
  }

  Future<int?> getVariantId({
    required int colorId,
    required int sizeId,
    required int productId
  }) async {
    try {
      final request = Uri.https(
          baseUrl,
          '/api/Cart/VariantId',
          {
            'colorId': colorId.toString(),
            'sizeId': sizeId.toString(),
            'productId': productId.toString(),
          }
      );

      final response = await _httpClient.get(
        request,
        headers: {
          'Content-Type': 'application/json',
          // Nếu cần xác thực:
          // 'Authorization': 'Bearer $accessToken',
        },
      );

      print('Request URL: $request');
      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Phân tích JSON và lấy variantId
        final data = jsonDecode(response.body);
        return data['id'] as int; // Giả sử API trả về {"id": 123}
      }

      // In thông tin lỗi trong trường hợp thất bại
      print('Error: ${response.body}');
      return null;
    } catch (e) {
      print('Exception getting variantId: $e');
      return null;
    }
  }

  Future<List<CartResponse>> getAllCartItem(String accessToken) async {
    final request = Uri.https(
        baseUrl,
        '/api/Cart/GetAllCartItem',
    );

    final response = await _httpClient.get(
      request,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(request);
    if (response.statusCode != 200) {
     return const<CartResponse>[];
    }
    final List<dynamic> cartItemsJson = jsonDecode(response.body);
    final cartItems = cartItemsJson.map((json){
      return CartResponse.fromJson(json);
    }).toList();
    return cartItems;
  }
  void dispose() {
    _httpClient.close();
  }
}

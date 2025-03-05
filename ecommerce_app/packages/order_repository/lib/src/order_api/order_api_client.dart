import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class OrderApiClient {
  static const String baseUrl = 'localhost:7205';
  final http.Client _httpClient;

  OrderApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  Future<List<Order>> getAllOrders(String accessToken, int statusId) async {
    final Uri url = Uri.https(
        baseUrl,
      '/api/Order/list',
        {'statusId': statusId.toString()}
    );

    try {
      final response = await _httpClient.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken', // Sending access token in the header
        },
      );
      print(url);
      if (response.statusCode == 200) {
        // If the response is successful, parse the JSON
        List<dynamic> responseData = json.decode(response.body);

        // Convert the JSON list to a list of Order objects
        List<Order> orders = responseData.map((orderJson) => Order.fromJson(orderJson)).toList();

        return orders;
      } else {
        // If the response is not successful, throw an exception
        throw Exception('Failed to load orders. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any errors that occur during the request
      throw Exception('Error fetching orders: $error');
    }
  }


  Future<bool> createOrder(String accessToken, OrderCreateRequest orderRequest) async {
    final Uri url = Uri.https(baseUrl,
      '/api/Order/create'
    );

    try {

      final response = await _httpClient.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(orderRequest.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // If not successful, throw an exception
        throw Exception('Failed to create order. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any errors during the request
      throw Exception('Error creating order: $error');
    }
  }
}

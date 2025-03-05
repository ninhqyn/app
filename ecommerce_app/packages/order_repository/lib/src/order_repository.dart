import 'package:order_repository/order_repository.dart';


class OrderRepository {
  final OrderApiClient orderApiClient;

  // Constructor to initialize OrderApiClient
  OrderRepository({required this.orderApiClient});

  // Function to create an order
  Future<bool> createOrder(String accessToken, OrderCreateRequest orderRequest) async {
    try {
      // Delegate the call to OrderApiClient
      return await orderApiClient.createOrder(accessToken, orderRequest);
    } catch (error) {
      // Handle any errors here (e.g., log, rethrow, etc.)
      throw Exception('Error in repository: $error');
    }
  }

  // Function to get orders by statusId
  Future<List<Order>> getOrders(String accessToken, int statusId) async {
    try {
      // Fetch orders using the OrderApiClient
      List<Order> orders = await orderApiClient.getAllOrders(accessToken, statusId);
      return orders;
    } catch (error) {
      // Handle any errors here (e.g., log, rethrow, etc.)
      throw Exception('Error fetching orders: $error');
    }
  }
}

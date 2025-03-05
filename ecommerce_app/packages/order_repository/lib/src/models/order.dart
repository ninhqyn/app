

import 'order_detail.dart';

class Order {
  int orderId;
  int userId;
  int addressId;
  String orderCode;
  int statusId;
  int paymentMethodId;
  double subTotal;
  double shippingFee;
  double totalAmount;
  String? note;  // Make note nullable
  String paymentStatus;
  DateTime createdAt;
  DateTime updatedAt;
  List<OrderDetail> orderDetails;

  // Constructor
  Order({
    required this.orderId,
    required this.userId,
    required this.addressId,
    required this.orderCode,
    required this.statusId,
    required this.paymentMethodId,
    required this.subTotal,
    required this.shippingFee,
    required this.totalAmount,
    this.note,  // Nullable constructor parameter
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.orderDetails,
  });

  // fromJson method to create an instance from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    var list = json['orderDetails'] as List;
    List<OrderDetail> orderDetailsList = list.map((i) => OrderDetail.fromJson(i)).toList();

    return Order(
      orderId: json['orderId'],
      userId: json['userId'],
      addressId: json['addressId'],
      orderCode: json['orderCode'],
      statusId: json['statusId'],
      paymentMethodId: json['paymentMethodId'],
      subTotal: json['subTotal'].toDouble(),
      shippingFee: json['shippingFee'].toDouble(),
      totalAmount: json['totalAmount'].toDouble(),
      note: json['note'],  // Allow note to be null
      paymentStatus: json['paymentStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      orderDetails: orderDetailsList,
    );
  }
}

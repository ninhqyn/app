class OrderCreateRequest {
  final int orderId;
  final int userId;
  final int addressId;
  final String orderCode;
  final int statusId;
  final int paymentMethodId;
  final double subTotal;
  final double shippingFee;
  final double totalAmount;
  final String? note; // Nullable
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Constructor
  OrderCreateRequest({
    required this.orderId,
    required this.userId,
    required this.addressId,
    required this.orderCode,
    required this.statusId,
    required this.paymentMethodId,
    required this.subTotal,
    required this.shippingFee,
    required this.totalAmount,
    this.note,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert JSON to OrderCreateRequest object
  factory OrderCreateRequest.fromJson(Map<String, dynamic> json) {
    return OrderCreateRequest(
      orderId: json['orderId'],
      userId: json['userId'],
      addressId: json['addressId'],
      orderCode: json['orderCode'],
      statusId: json['statusId'],
      paymentMethodId: json['paymentMethodId'],
      subTotal: json['subTotal'].toDouble(),
      shippingFee: json['shippingFee'].toDouble(),
      totalAmount: json['totalAmount'].toDouble(),
      note: json['note'],
      paymentStatus: json['paymentStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Convert OrderCreateRequest object to JSON
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'addressId': addressId,
      'orderCode': orderCode,
      'statusId': statusId,
      'paymentMethodId': paymentMethodId,
      'subTotal': subTotal,
      'shippingFee': shippingFee,
      'totalAmount': totalAmount,
      'note': note,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class OrderDetail {
  int orderDetailId;
  int orderId;
  int productId;
  int variantId;
  int quantity;
  double price;
  double subTotal;

  // Constructor
  OrderDetail({
    required this.orderDetailId,
    required this.orderId,
    required this.productId,
    required this.variantId,
    required this.quantity,
    required this.price,
    required this.subTotal,
  });

  // fromJson method to create an instance from JSON
  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      orderDetailId: json['orderDetailId'],
      orderId: json['orderId'],
      productId: json['productId'],
      variantId: json['variantId'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      subTotal: json['subTotal'].toDouble(),
    );
  }
}

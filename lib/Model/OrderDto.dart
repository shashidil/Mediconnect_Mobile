class Order {
  final int id;
  final String orderNumber;
  final String orderDate;
  final double totalAmount;
  final String invoiceNumber;
  final String paymentStatus;
  final String orderStatus;
  final String? trackingNumber;

  Order({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.totalAmount,
    required this.invoiceNumber,
    required this.paymentStatus,
    required this.orderStatus,
    this.trackingNumber,
  });

  // Factory method to create an Order object from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderNumber: json['orderNumber'],
      orderDate: json['orderDate'],
      totalAmount: json['totalAmount'],
      invoiceNumber: json['invoiceNumber'],
      paymentStatus: json['paymentStatus'],
      orderStatus: json['orderStatus'],
      trackingNumber: json['trackingNumber'],
    );
  }

  // Method to convert Order object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'orderDate': orderDate,
      'totalAmount': totalAmount,
      'invoiceNumber': invoiceNumber,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'trackingNumber': trackingNumber,
    };
  }
}

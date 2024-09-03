class UpdateOrderRequest {
  final String? status;
  final String? trackingNumber;

  UpdateOrderRequest({
    this.status,
    this.trackingNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'trackingNumber': trackingNumber,
    };
  }
}

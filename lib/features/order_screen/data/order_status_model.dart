class OrderStatusResponse {
  final bool success;
  final String message;
  final String orderStatus;

  OrderStatusResponse({
    required this.success,
    required this.message,
    required this.orderStatus,
  });

  factory OrderStatusResponse.fromJson(Map<String, dynamic> json) {
    return OrderStatusResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      orderStatus: json['result']?['orderStatus'] ?? '',
    );
  }
}

class RefundResponse {
  final bool status;
  final String? message;
  final dynamic data;

  RefundResponse({required this.status, this.message, this.data});

  factory RefundResponse.fromJson(Map<String, dynamic> json) {
    return RefundResponse(
      status: json['status'] ?? false,
      message: json['message'],
      data: json['data'],
    );
  }
}

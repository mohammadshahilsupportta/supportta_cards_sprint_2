/// Response model for payment details API
class PaymentDetailsResponse {
  final bool success;
  final String message;
  final PaymentDetails result;

  PaymentDetailsResponse({
    required this.success,
    required this.message,
    required this.result,
  });

  factory PaymentDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PaymentDetailsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      result: PaymentDetails.fromJson(json['result'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'result': result.toJson()};
  }
}

/// Model for payment details (bank account or UPI)
class PaymentDetails {
  final String id;
  final String client;
  final String clientRef;
  final String defaultAcc;
  final String status;
  final bool isDeleted;
  final DateTime createdAt;

  // Bank account specific fields
  final String? accountHolderName;
  final String? bankName;
  final String? ifsc;
  final int? accountNumber;
  final String? branch;

  // UPI specific fields
  final String? upiID; // Changed from upiId to upiID to match API response

  // Constructor for both bank account and UPI
  PaymentDetails({
    required this.id,
    required this.client,
    required this.clientRef,
    required this.defaultAcc,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    this.accountHolderName,
    this.bankName,
    this.ifsc,
    this.accountNumber,
    this.branch,
    this.upiID, // Changed from upiId to upiID
  });

  /// Determines if this is a UPI payment method
  bool get isUpi => defaultAcc == 'UPI';

  /// Determines if this is a bank account payment method
  bool get isBankAccount => defaultAcc == 'Bank_Account';

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      id: json['_id'] ?? '',
      client: json['client'] ?? '',
      clientRef: json['clientRef'] ?? '',
      defaultAcc: json['defaultAcc'] ?? '',
      status: json['status'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),

      // Bank account fields
      accountHolderName: json['accountHolderName'],
      bankName: json['bankName'],
      ifsc: json['ifsc'],
      accountNumber: json['accountNumber'],
      branch: json['branch'],

      // UPI fields - fixed field name to match API response
      upiID: json['upiID'], // Changed from upiId to upiID
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      '_id': id,
      'client': client,
      'clientRef': clientRef,
      'defaultAcc': defaultAcc,
      'status': status,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
    };

    // Add bank account fields if present
    if (isBankAccount) {
      if (accountHolderName != null)
        data['accountHolderName'] = accountHolderName;
      if (bankName != null) data['bankName'] = bankName;
      if (ifsc != null) data['ifsc'] = ifsc;
      if (accountNumber != null) data['accountNumber'] = accountNumber;
      if (branch != null) data['branch'] = branch;
    }

    // Add UPI fields if present
    if (isUpi && upiID != null) {
      data['upiID'] = upiID; // Changed from upiId to upiID
    }

    return data;
  }
}

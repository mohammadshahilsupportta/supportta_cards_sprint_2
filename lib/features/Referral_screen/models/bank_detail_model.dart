
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


class PaymentDetails {
  final String id;
  final String client;
  final String clientRef;
  final String defaultAcc;
  final String status;
  final bool isDeleted;
  final DateTime createdAt;

  
  final String? accountHolderName;
  final String? bankName;
  final String? ifsc;
  final int? accountNumber;
  final String? branch;

  
  final String? upiID; 

  
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
    this.upiID, 
  });

  
  bool get isUpi => defaultAcc == 'UPI';

  
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

      
      accountHolderName: json['accountHolderName'],
      bankName: json['bankName'],
      ifsc: json['ifsc'],
      accountNumber: json['accountNumber'],
      branch: json['branch'],

      
      upiID: json['upiID'], 
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

    
    if (isBankAccount) {
      if (accountHolderName != null)
        data['accountHolderName'] = accountHolderName;
      if (bankName != null) data['bankName'] = bankName;
      if (ifsc != null) data['ifsc'] = ifsc;
      if (accountNumber != null) data['accountNumber'] = accountNumber;
      if (branch != null) data['branch'] = branch;
    }

    
    if (isUpi && upiID != null) {
      data['upiID'] = upiID; 
    }

    return data;
  }
}

class WalletTransaction {
  final String id;
  final String type; // "Debit" or "Credit"
  final double amount;
  final String source; // "Referral", "Settle_Up", etc.
  final String status;
  final DateTime createdAt;
  final String code;
  
  WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.source,
    required this.status,
    required this.createdAt,
    required this.code,
  });
  
  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    String code;
    
    // For referral transactions, get code from order, otherwise use transaction code
    if (json['source'] == 'Referral' && 
        json['referral'] != null && 
        json['referral']['order'] != null &&
        json['referral']['order'] is Map &&
        json['referral']['order']['code'] != null) {
      code = json['referral']['order']['code'];
    } else {
      code = json['code'];
    }
    
    return WalletTransaction(
      id: json['_id'],
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      source: json['source'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      code: code,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'amount': amount,
      'source': source,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'code': code,
    };
  }
  
  // Helper getters
  bool get isDebit => type == 'Debit';
  bool get isCredit => type == 'Credit';
  bool get isReferral => source == 'Referral';
  bool get isSettleUp => source == 'Settle_Up';
  bool get isCompleted => status == 'Completed';
}

// Response wrapper class
class WalletTransactionResponse {
  final bool success;
  final String message;
  final int currentPage;
  final List<WalletTransaction> results;
  final int latestCount;
  final int totalCount;
  final int totalPages;
  
  WalletTransactionResponse({
    required this.success,
    required this.message,
    required this.currentPage,
    required this.results,
    required this.latestCount,
    required this.totalCount,
    required this.totalPages,
  });
  
  factory WalletTransactionResponse.fromJson(Map<String, dynamic> json) {
    return WalletTransactionResponse(
      success: json['success'],
      message: json['message'],
      currentPage: json['currentPage'],
      results: (json['results'] as List)
          .map((item) => WalletTransaction.fromJson(item))
          .toList(),
      latestCount: json['latestCount'],
      totalCount: json['totalCount'],
      totalPages: json['totalPages'],
    );
  }
}

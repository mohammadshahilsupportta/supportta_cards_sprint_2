import 'package:flutter/material.dart';
import 'package:taproot_admin/exporter/exporter.dart';

class SimpleTransaction {
  final String id;
  final String type; // "Credit" or "Debit"
  final double amount;
  final String source; // "Referral" or "Settle_Up"
  final DateTime date;
  final String code;
  final Map<String, dynamic>? referral; // Keep the raw referral data

  SimpleTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.source,
    required this.date,
    required this.code,
    this.referral,
  });

  // Helper getters
  bool get isCredit => type.toLowerCase() == 'credit';
  bool get isDebit => type.toLowerCase() == 'debit';
  bool get isReferral => source.toLowerCase() == 'referral';
  bool get isSettleUp => source.toLowerCase() == 'settle_up';

  // Factory method to create from the complex API response
  factory SimpleTransaction.fromJson(Map<String, dynamic> json) {
    try {
      // Extract basic transaction details
      final id = json['_id'] ?? '';
      final type = json['type'] ?? '';
      final amount = (json['amount'] ?? 0).toDouble();
      final source = json['source'] ?? '';
      final date =
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now();
      final code = json['code'] ?? '';
      final referral = json['referral'] as Map<String, dynamic>?;

      return SimpleTransaction(
        id: id,
        type: type,
        amount: amount,
        source: source,
        date: date,
        code: code,
        referral: referral,
      );
    } catch (e) {
      print('Error parsing transaction: $e');
      // Return a default transaction on error
      return SimpleTransaction(
        id: '',
        type: 'Unknown',
        amount: 0,
        source: 'Unknown',
        date: DateTime.now(),
        code: '',
      );
    }
  }

  // Get the referred user name if available
  String? get referredUserName {
    if (referral != null &&
        referral!['referredUser'] != null &&
        referral!['referredUser'] is Map<String, dynamic> &&
        referral!['referredUser']['name'] != null) {
      return referral!['referredUser']['name'];
    }
    return null;
  }

  // Get the order code if available
  String? get orderCode {
    if (referral != null && referral!['order'] != null) {
      if (referral!['order'] is Map<String, dynamic> &&
          referral!['order']['code'] != null) {
        return referral!['order']['code'];
      }
    }
    return null;
  }

  // Helper method to get display code with prefix
  String getDisplayCode() {
    if (isReferral) {
      if (orderCode != null) {
        return '$orderCode';
        // return 'ORD: $orderCode';
      } else {
        return code;
        // return 'TXN: $code';
      }
    } else if (isSettleUp) {
      return code;
      // return 'TXN: $code';
    } else {
      return code;
    }
  }

  // Helper method to get description
  String getDescription() {
    if (isReferral && referredUserName != null) {
      return 'Referral: $referredUserName';
    } else if (isSettleUp) {
      return 'Settlement';
    } else {
      return source;
    }
  }

  // Helper method to get amount color
  Color getAmountColor() {
    return isCredit ? Colors.grey : Colors.green;
  }

  // Helper method to get formatted amount
  String getFormattedAmount() {
    return isCredit
        ? '+₹${amount.toStringAsFixed(2)}'
        : '-₹${amount.toStringAsFixed(2)}';
  }
}

// Response wrapper class
class SimpleTransactionResponse {
  final bool success;
  final String message;
  final List<SimpleTransaction> transactions;
  final int totalCount;

  SimpleTransactionResponse({
    required this.success,
    required this.message,
    required this.transactions,
    required this.totalCount,
  });

  factory SimpleTransactionResponse.fromJson(Map<String, dynamic> json) {
    try {
      final results = json['results'] as List<dynamic>? ?? [];
      final transactions =
          results.map((item) => SimpleTransaction.fromJson(item)).toList();

      return SimpleTransactionResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        transactions: transactions,
        totalCount: json['totalCount'] ?? 0,
      );
    } catch (e) {
      logError('Error parsing transaction response: $e');
      return SimpleTransactionResponse(
        success: false,
        message: 'Error: $e',
        transactions: [],
        totalCount: 0,
      );
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:taproot_admin/exporter/exporter.dart';

// class SimpleTransaction {
//   final String id;
//   final String type; // "Credit" or "Debit"
//   final double amount;
//   final String source; // "Referral" or "Settle_Up"
//   final DateTime date;
//   final String code;
//   final Map<String, dynamic>? referral; // Keep the raw referral data

//   SimpleTransaction({
//     required this.id,
//     required this.type,
//     required this.amount,
//     required this.source,
//     required this.date,
//     required this.code,
//     this.referral,
//   });

//   // Helper getters
//   bool get isCredit => type.toLowerCase() == 'credit';
//   bool get isDebit => type.toLowerCase() == 'debit';
//   bool get isReferral => source.toLowerCase() == 'referral';
//   bool get isSettleUp => source.toLowerCase() == 'settle_up';

//   // Factory method to create from the complex API response
//   factory SimpleTransaction.fromJson(Map<String, dynamic> json) {
//     try {
//       // Extract basic transaction details
//       final id = json['_id'] ?? '';
//       final type = json['type'] ?? '';
//       final amount = (json['amount'] ?? 0).toDouble();
//       final source = json['source'] ?? '';
//       final date = json['createdAt'] != null 
//           ? DateTime.parse(json['createdAt']) 
//           : DateTime.now();
//       final code = json['code'] ?? '';
//       final referral = json['referral'] as Map<String, dynamic>?;
      
//       return SimpleTransaction(
//         id: id,
//         type: type,
//         amount: amount,
//         source: source,
//         date: date,
//         code: code,
//         referral: referral,
//       );
//     } catch (e) {
//       print('Error parsing transaction: $e');
//       // Return a default transaction on error
//       return SimpleTransaction(
//         id: '',
//         type: 'Unknown',
//         amount: 0,
//         source: 'Unknown',
//         date: DateTime.now(),
//         code: '',
//       );
//     }
//   }
  
//   // Get the referred user name if available
//   String? get referredUserName {
//     if (referral != null && 
//         referral!['referredUser'] != null && 
//         referral!['referredUser'] is Map<String, dynamic> && 
//         referral!['referredUser']['name'] != null) {
//       return referral!['referredUser']['name'];
//     }
//     return null;
//   }
  
//   // Get the order code if available
//   String? get orderCode {
//     if (referral != null && referral!['order'] != null) {
//       if (referral!['order'] is Map<String, dynamic> && 
//           referral!['order']['code'] != null) {
//         return referral!['order']['code'];
//       }
//     }
//     return null;
//   }
  
//   // Get the referral code if available
//   String? get referralCode {
//     if (referral != null && referral!['code'] != null) {
//       return referral!['code'];
//     }
//     return null;
//   }
  
//   // Helper method to get display code with prefix
//   String getDisplayCode() {
//     if (isReferral) {
//       if (orderCode != null) {
//         return 'ORD: $orderCode';
//       } else if (referralCode != null) {
//         return 'REF: $referralCode';
//       } else {
//         return 'TXN: $code';
//       }
//     } else if (isSettleUp) {
//       return 'TXN: $code';
//     } else {
//       return code;
//     }
//   }
  
//   // Helper method to get description
//   String getDescription() {
//     if (isReferral && referredUserName != null) {
//       return 'Referral: $referredUserName';
//     } else if (isSettleUp) {
//       return 'Settlement';
//     } else {
//       return source;
//     }
//   }
  
//   // Helper method to get amount color
//   Color getAmountColor() {
//     return isCredit ? Colors.green : Colors.grey;
//   }
  
//   // Helper method to get formatted amount
//   String getFormattedAmount() {
//     return isCredit 
//         ? '+₹${amount.toStringAsFixed(2)}'
//         : '-₹${amount.toStringAsFixed(2)}';
//   }
// }

// // Response wrapper class
// class SimpleTransactionResponse {
//   final bool success;
//   final String message;
//   final List<SimpleTransaction> transactions;
//   final int totalCount;

//   SimpleTransactionResponse({
//     required this.success,
//     required this.message,
//     required this.transactions,
//     required this.totalCount,
//   });

//   factory SimpleTransactionResponse.fromJson(Map<String, dynamic> json) {
//     try {
//       final results = json['results'] as List<dynamic>? ?? [];
//       final transactions = results
//           .map((item) => SimpleTransaction.fromJson(item))
//           .toList();
      
//       return SimpleTransactionResponse(
//         success: json['success'] ?? false,
//         message: json['message'] ?? '',
//         transactions: transactions,
//         totalCount: json['totalCount'] ?? 0,
//       );
//     } catch (e) {
//       logError('Error parsing transaction response: $e');
//       return SimpleTransactionResponse(
//         success: false,
//         message: 'Error: $e',
//         transactions: [],
//         totalCount: 0,
//       );
//     }
//   }
// }

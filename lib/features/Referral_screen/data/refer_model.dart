import 'package:taproot_admin/core/logger.dart';

class Wallet {
  final String id;
  final double balance;
  final DateTime createdAt;
  final bool isDeleted;
  final double totalEarned;
  final double totalWithdrawn;
  final UserData userData;
  final String phoneNumber;
  final int referralCount;

  Wallet({
    required this.id,
    required this.balance,
    required this.createdAt,
    required this.isDeleted,
    required this.totalEarned,
    required this.totalWithdrawn,
    required this.userData,
    required this.phoneNumber,
    required this.referralCount,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['_id'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      isDeleted: json['isDeleted'] ?? false,
      totalEarned: (json['totalEarned'] ?? 0).toDouble(),
      totalWithdrawn: (json['totalWithdrawn'] ?? 0).toDouble(),
      userData: UserData.fromJson(json['userData'] ?? {}),
      phoneNumber: json['phoneNumber'] ?? '',
      referralCount: json['referralCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'balance': balance,
      'createdAt': createdAt.toIso8601String(),
      'isDeleted': isDeleted,
      'totalEarned': totalEarned,
      'totalWithdrawn': totalWithdrawn,
      'userData': userData.toJson(),
      'phoneNumber': phoneNumber,
      'referralCount': referralCount,
    };
  }
}

class UserData {
  final String id;
  final String name;
  final String code;

  UserData({required this.id, required this.name, required this.code});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'code': code};
  }
}

class WalletResponse {
  final bool success;
  final String message;
  final int currentPage;
  final List<Wallet> results;
  final int latestCount;
  final int totalCount;
  final int totalPages;

  WalletResponse({
    required this.success,
    required this.message,
    required this.currentPage,
    required this.results,
    required this.latestCount,
    required this.totalCount,
    required this.totalPages,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    try {
      final resultsList = json['results'] as List<dynamic>? ?? [];
      final wallets = resultsList.map((x) => Wallet.fromJson(x)).toList();

      return WalletResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        currentPage: json['currentPage'] ?? 1,
        results: wallets,
        latestCount: json['latestCount'] ?? 0,
        totalCount: json['totalCount'] ?? 0,
        totalPages: json['totalPages'] ?? 1,
      );
    } catch (e) {
      logError('Error parsing WalletResponse: $e');
      return WalletResponse(
        success: false,
        message: 'Error parsing response: $e',
        currentPage: 1,
        results: [],
        latestCount: 0,
        totalCount: 0,
        totalPages: 1,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'currentPage': currentPage,
      'results': results.map((x) => x.toJson()).toList(),
      'latestCount': latestCount,
      'totalCount': totalCount,
      'totalPages': totalPages,
    };
  }
}

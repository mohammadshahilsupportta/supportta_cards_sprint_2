class WalletDetailsResponse {
  final bool success;
  final String message;
  final WalletResult result;

  WalletDetailsResponse({
    required this.success,
    required this.message,
    required this.result,
  });

  factory WalletDetailsResponse.fromJson(Map<String, dynamic> json) {
    return WalletDetailsResponse(
      success: json['success'],
      message: json['message'],
      result: WalletResult.fromJson(json['result']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'result': result.toJson()};
  }
}

class WalletResult {
  final WalletUser user;
  final int referralCount;
  final UserWallet wallet;

  WalletResult({
    required this.user,
    required this.referralCount,
    required this.wallet,
  });

  factory WalletResult.fromJson(Map<String, dynamic> json) {
    return WalletResult(
      user: WalletUser.fromJson(json['user']),
      referralCount: json['referralCount'],
      wallet: UserWallet.fromJson(json['wallet']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'referralCount': referralCount,
      'wallet': wallet.toJson(),
    };
  }
}

class WalletUser {
  final String name;
  final String email;
  final String phoneNumber;

  WalletUser({
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory WalletUser.fromJson(Map<String, dynamic> json) {
    return WalletUser(
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phoneNumber': phoneNumber};
  }
}

class UserWallet {
  final String id;
  final double balance;
  final DateTime createdAt;
  final bool isDeleted;
  final double totalEarned;
  final Client client;
  final String clientRef;
  final String status;
  final double totalWithdrawn;

  UserWallet({
    required this.id,
    required this.balance,
    required this.createdAt,
    required this.isDeleted,
    required this.totalEarned,
    required this.client,
    required this.clientRef,
    required this.status,
    required this.totalWithdrawn,
  });

  factory UserWallet.fromJson(Map<String, dynamic> json) {
    return UserWallet(
      id: json['_id'],
      balance: (json['balance'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      isDeleted: json['isDeleted'],
      totalEarned: (json['totalEarned'] ?? 0).toDouble(),
      client: Client.fromJson(json['client']),
      clientRef: json['clientRef'],
      status: json['status'],
      totalWithdrawn: (json['totalWithdrawn'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'balance': balance,
      'createdAt': createdAt.toIso8601String(),
      'isDeleted': isDeleted,
      'totalEarned': totalEarned,
      'client': client.toJson(),
      'clientRef': clientRef,
      'status': status,
      'totalWithdrawn': totalWithdrawn,
    };
  }
}

class Client {
  final String id;
  final String name;

  Client({required this.id, required this.name});

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(id: json['_id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}

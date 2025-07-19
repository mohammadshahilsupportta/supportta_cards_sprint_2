class Wallet {
  final String id;
  final double balance;
  final DateTime createdAt;
  final bool isDeleted;
  final double totalEarned;
  final UserData userData;
  final String phoneNumber;
  final int referralCount;

  Wallet({
    required this.id,
    required this.balance,
    required this.createdAt,
    required this.isDeleted,
    required this.totalEarned,
    required this.userData,
    required this.phoneNumber,
    required this.referralCount,
  });

  // Factory method to create a Wallet object from JSON
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['_id'],
      balance: json['balance'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      isDeleted: json['isDeleted'],
      totalEarned: json['totalEarned'].toDouble(),
      userData: UserData.fromJson(json['userData']),
      phoneNumber: json['phoneNumber'],
      referralCount: json['referralCount'],
    );
  }

  // Method to convert a Wallet object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'balance': balance,
      'createdAt': createdAt.toIso8601String(),
      'isDeleted': isDeleted,
      'totalEarned': totalEarned,
      'userData': userData.toJson(),
      'phoneNumber': phoneNumber,
      'referralCount': referralCount,
    };
  }
}

class UserData {
  final String id;
  final String name;

  UserData({required this.id, required this.name});

  // Factory method to create a UserData object from JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(id: json['_id'], name: json['name']);
  }

  // Method to convert a UserData object to JSON
  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
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

  // Factory method to create a WalletResponse object from JSON
  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      success: json['success'],
      message: json['message'],
      currentPage: json['currentPage'],
      results: List<Wallet>.from(
        json['results'].map((x) => Wallet.fromJson(x)),
      ),
      latestCount: json['latestCount'],
      totalCount: json['totalCount'],
      totalPages: json['totalPages'],
    );
  }

  // Method to convert a WalletResponse object to JSON
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

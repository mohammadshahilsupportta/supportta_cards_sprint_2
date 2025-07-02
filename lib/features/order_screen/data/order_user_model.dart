// class OrderResponseUser {
//   final bool success;
//   final String message;
//   final OrderResult result;

//   OrderResponseUser({
//     required this.success,
//     required this.message,
//     required this.result,
//   });

//   factory OrderResponseUser.fromJson(Map<String, dynamic> json) {
//     return OrderResponseUser(
//       success: json['success'],
//       message: json['message'],
//       result: OrderResult.fromJson(json['result']),
//     );
//   }
// }

// class OrderResult {
//   final PersonalInfo personalInfo;
//   final String id;
//   final User user;

//   OrderResult({
//     required this.personalInfo,
//     required this.id,
//     required this.user,
//   });

//   factory OrderResult.fromJson(Map<String, dynamic> json) {
//     return OrderResult(
//       personalInfo: PersonalInfo.fromJson(json['personalInfo']),
//       id: json['_id'],
//       user: User.fromJson(json['user']),
//     );
//   }
// }

// class PersonalInfo {
//   final String name;
//   final String email;
//   final String phoneNumber;
//   final String whatsappNumber;

//   PersonalInfo({
//     required this.name,
//     required this.email,
//     required this.phoneNumber,
//     required this.whatsappNumber,
//   });

//   factory PersonalInfo.fromJson(Map<String, dynamic> json) {
//     return PersonalInfo(
//       name: json['name'],
//       email: json['email'],
//       phoneNumber: json['phoneNumber'],
//       whatsappNumber: json['whatsappNumber'],
//     );
//   }
// }

// class User {
//   final String id;
//   final bool isPremium;
//   final String code;

//   User({required this.id, required this.isPremium, required this.code});

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['_id'],
//       isPremium: json['isPremium'],
//       code: json['code'],
//     );
//   }
// }
class OrderResponseUser {
  final bool success;
  final String message;
  final OrderResult result;

  OrderResponseUser({
    required this.success,
    required this.message,
    required this.result,
  });

  factory OrderResponseUser.fromJson(Map<String, dynamic> json) {
    return OrderResponseUser(
      success: json['success'],
      message: json['message'],
      result: OrderResult.fromJson(json['result']),
    );
  }
}

class OrderResult {
  final PersonalInfo personalInfo;
  final String id;
  final OrderUser user; // Changed from User to OrderUser

  OrderResult({
    required this.personalInfo,
    required this.id,
    required this.user,
  });

  factory OrderResult.fromJson(Map<String, dynamic> json) {
    return OrderResult(
      personalInfo: PersonalInfo.fromJson(json['personalInfo']),
      id: json['_id'],
      user: OrderUser.fromJson(json['user']), // Changed from User to OrderUser
    );
  }
}

class PersonalInfo {
  final String name;
  final String email;
  final String phoneNumber;
  final String whatsappNumber;

  PersonalInfo({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.whatsappNumber,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      whatsappNumber: json['whatsappNumber'],
    );
  }
}

class OrderUser {
  // Renamed from User to OrderUser
  final String id;
  final bool isPremium;
  final String code;

  OrderUser({required this.id, required this.isPremium, required this.code});

  factory OrderUser.fromJson(Map<String, dynamic> json) {
    return OrderUser(
      id: json['_id'],
      isPremium: json['isPremium'],
      code: json['code'],
    );
  }
}

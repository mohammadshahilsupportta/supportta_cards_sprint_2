import 'package:taproot_admin/exporter/exporter.dart';

class OrderResponse {
  final int currentPage;
  final List<Order> results;
  final int totalCount;
  final int totalPages;

  OrderResponse({
    required this.currentPage,
    required this.results,
    required this.totalCount,
    required this.totalPages,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    try {
      return OrderResponse(
        currentPage: json['currentPage'] ?? 1,
        results: List<Order>.from(
          (json['results'] ?? []).map((x) => Order.fromJson(x)),
        ),
        totalCount: json['totalCount'] ?? 0,
        totalPages: json['totalPages'] ?? 0,
      );
    } catch (e, stackTrace) {
      logInfo("Error parsing OrderResponse: $e");
      logInfo("JSON data: $json");
      logInfo("Stack trace: $stackTrace");
      rethrow;
    }
  }
}

class Order {
  final String id;
  final String code;
  final String orderStatus;
  final bool isDeleted;
  final User user;
  final Address address;
  final int totalProducts;
  final double totalAmount;
  final String paymentStatus;

  Order({
    required this.id,
    required this.code,
    required this.orderStatus,
    required this.isDeleted,
    required this.user,
    required this.address,
    required this.totalProducts,
    required this.totalAmount,
    required this.paymentStatus,
  });
  Order copyWith({
    String? id,
    String? code,
    String? orderStatus,
    bool? isDeleted,
    User? user,
    Address? address,
    int? totalProducts,
    double? totalAmount,
    String? paymentStatus,
  }) {
    return Order(
      id: id ?? this.id,
      code: code ?? this.code,
      orderStatus: orderStatus ?? this.orderStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      user: user ?? this.user,
      address: address ?? this.address,
      totalProducts: totalProducts ?? this.totalProducts,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }

factory Order.fromJson(Map<String, dynamic> json) {
    try {
      return Order(
        id: json['_id']?.toString() ?? '',
        code: json['code']?.toString() ?? '',
        orderStatus: json['orderStatus']?.toString() ?? '',
        isDeleted: json['isDeleted'] ?? false,
        user: User.fromJson(json['userData'] ?? {'name': ''}),
        address: Address.fromJson(json['address'] ?? {}),
        totalProducts: json['totalProducts'] ?? 0,
        totalAmount:
            json['totalAmount'] is int
                ? (json['totalAmount'] as int).toDouble()
                : (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
        paymentStatus: json['paymentStatus'] ?? '',
      );
    } catch (e, stackTrace) {
      logInfo("Error parsing Order: $e");
      logInfo("JSON data: $json");
      logInfo("Stack trace: $stackTrace");
      rethrow;
    }
  }

  // factory Order.fromJson(Map<String, dynamic> json) {
  //   try {
  //     return Order(
  //       id: json['_id']?.toString() ?? '',
  //       code: json['code']?.toString() ?? '',
  //       orderStatus: json['orderStatus']?.toString() ?? '',
  //       isDeleted: json['isDeleted'] ?? false,
  //       // Create User from userData instead of user
  //       user: User.fromJson(json['userData'] ?? {'name': ''}),
  //       address: Address.fromJson(json['address'] ?? {}),
  //       totalProducts: json['totalProducts'] ?? 0,
  //       totalAmount: json['totalAmount'] ?? 0,
  //       paymentStatus: json['paymentStatus'] ?? '',
  //     );
  //   } catch (e, stackTrace) {
  //     logInfo("Error parsing Order: $e");
  //     logInfo("JSON data: $json");
  //     logInfo("Stack trace: $stackTrace");
  //     rethrow;
  //   }
  // }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'code': code,
    'orderStatus': orderStatus,
    'isDeleted': isDeleted,
    'userData': user.toJson(),
    'address': address.toJson(),
    'totalProducts': totalProducts,
    'totalAmount': totalAmount,
    'paymentStatus': paymentStatus,
  };
}

class User {
  final String name;

  User({required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    // The name is coming from userData.name in the parent object
    return User(
      name: json['name'] ?? '', // Add null safety
    );
  }

  Map<String, dynamic> toJson() => {'name': name};
}

class Address {
  final String mobile;

  Address({required this.mobile});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      mobile:
          json['mobile']?.toString() ?? '', // Add toString() and null safety
    );
  }

  Map<String, dynamic> toJson() => {'mobile': mobile};
}

class NfcDetails {
  final String customerName;

  NfcDetails({required this.customerName});

  factory NfcDetails.fromJson(Map<String, dynamic> json) {
    return NfcDetails(customerName: json['customerName']);
  }

  Map<String, dynamic> toJson() => {'customerName': customerName};
}

class ProductItem {
  final String id;
  final String product;
  final String quantity;
  final double totalPrice;
  final double? salePrice;
  final double? discountPercentage;
  final double? actualPrice;
  final double? discountedPrice;

  ProductItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.totalPrice,
    this.salePrice,
    this.discountPercentage,
    this.actualPrice,
    this.discountedPrice,
  });
  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['_id']?.toString() ?? '',
      product: json['product']?.toString() ?? '',
      quantity: json['quantity']?.toString() ?? '',
      totalPrice:
          json['totalPrice'] is int
              ? (json['totalPrice'] as int).toDouble()
              : (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      salePrice:
          json['salePrice'] is int
              ? (json['salePrice'] as int).toDouble()
              : (json['salePrice'] as num?)?.toDouble(),
      discountPercentage:
          json['discountPercentage'] is int
              ? (json['discountPercentage'] as int).toDouble()
              : (json['discountPercentage'] as num?)?.toDouble(),
      actualPrice:
          json['actualPrice'] is int
              ? (json['actualPrice'] as int).toDouble()
              : (json['actualPrice'] as num?)?.toDouble(),
      discountedPrice:
          json['discountedPrice'] is int
              ? (json['discountedPrice'] as int).toDouble()
              : (json['discountedPrice'] as num?)?.toDouble(),
    );
  }


  // factory ProductItem.fromJson(Map<String, dynamic> json) {
  //   return ProductItem(
  //     id: json['_id'],
  //     product: json['product'],
  //     quantity: json['quantity'],
  //     totalPrice: (json['totalPrice'] as num).toDouble(),
  //     salePrice:
  //         json['salePrice'] != null
  //             ? (json['salePrice'] as num).toDouble()
  //             : null,
  //     discountPercentage:
  //         json['discountPercentage'] != null
  //             ? (json['discountPercentage'] as num).toDouble()
  //             : null,
  //     actualPrice:
  //         json['actualPrice'] != null
  //             ? (json['actualPrice'] as num).toDouble()
  //             : null,
  //     discountedPrice:
  //         json['discountedPrice'] != null
  //             ? (json['discountedPrice'] as num).toDouble()
  //             : null,
  //   );
  // }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'product': product,
    'quantity': quantity,
    'totalPrice': totalPrice,
    if (salePrice != null) 'salePrice': salePrice,
    if (discountPercentage != null) 'discountPercentage': discountPercentage,
    if (actualPrice != null) 'actualPrice': actualPrice,
    if (discountedPrice != null) 'discountedPrice': discountedPrice,
  };
}
class OrderIdResponse {
  final bool success;
  final String message;
  final String result;

  OrderIdResponse({
    required this.success,
    required this.message,
    required this.result,
  });

  factory OrderIdResponse.fromJson(Map<String, dynamic> json) {
    return OrderIdResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      result: json['result'] ?? '',
    );
  }
}

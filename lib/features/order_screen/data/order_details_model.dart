class OrderDetailsResponse {
  final bool success;
  final String message;
  final OrderDetails result;

  OrderDetailsResponse({
    required this.success,
    required this.message,
    required this.result,
  });

  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      result:
          json['result'] != null
              ? OrderDetails.fromJson(json['result'] as Map<String, dynamic>)
              : OrderDetails.empty(),
    );
  }
}

class OrderDetails {
  final String id;
  final String code;
  final User user;
  final List<OrderProduct> products;
  final Address address;
  final NfcDetails nfcDetails;
  final double totalPrice;
  final String orderStatus;
  final String createdBy;
  final String paymentMode;
  final String paymentServiceProvider;
  final String paymentStatus;
  final bool isRefunded;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final int v;
  final String razorpayPaymentLink;
  final String razorpayPaymentLinkId;
  final String paymentMethod;
  final PaymentStatusLogs paymentStatusLogs;
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final PersonalInfo personalInfo;
  final String orderType;

  OrderDetails({
    required this.id,
    required this.code,
    required this.user,
    required this.products,
    required this.address,
    required this.nfcDetails,
    required this.totalPrice,
    required this.orderStatus,
    required this.createdBy,
    required this.paymentMode,
    required this.paymentServiceProvider,
    required this.paymentStatus,
    required this.isRefunded,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.razorpayPaymentLink,
    required this.razorpayPaymentLinkId,
    required this.paymentMethod,
    required this.paymentStatusLogs,
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.personalInfo,
    required this.orderType
  });
  OrderDetails copyWith({
    String? id,
    String? code,
    User? user,
    List<OrderProduct>? products,
    Address? address,
    NfcDetails? nfcDetails,
    double? totalPrice,
    String? orderStatus,
    String? createdBy,
    String? paymentMode,
    String? paymentServiceProvider,
    String? paymentStatus,
    bool? isRefunded,
    bool? isDeleted,
    String? createdAt,
    String? updatedAt,
    int? v,
    String? razorpayPaymentLink,
    String? razorpayPaymentLinkId,
    String? paymentMethod,
    PaymentStatusLogs? paymentStatusLogs,
    String? razorpayOrderId,
    String? razorpayPaymentId,
    PersonalInfo? personalInfo,
    String? orderType,
  }) {
    return OrderDetails(
      id: id ?? this.id,
      code: code ?? this.code,
      user: user ?? this.user,
      products: products ?? this.products,
      address: address ?? this.address,
      nfcDetails: nfcDetails ?? this.nfcDetails,
      totalPrice: totalPrice ?? this.totalPrice,
      orderStatus: orderStatus ?? this.orderStatus,
      createdBy: createdBy ?? this.createdBy,
      paymentMode: paymentMode ?? this.paymentMode,
      paymentServiceProvider:
          paymentServiceProvider ?? this.paymentServiceProvider,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      isRefunded: isRefunded ?? this.isRefunded,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      razorpayPaymentLink: razorpayPaymentLink ?? this.razorpayPaymentLink,
      razorpayPaymentLinkId:
          razorpayPaymentLinkId ?? this.razorpayPaymentLinkId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatusLogs: paymentStatusLogs ?? this.paymentStatusLogs,
      razorpayOrderId: razorpayOrderId ?? this.razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId ?? this.razorpayPaymentId,
      personalInfo: personalInfo ?? this.personalInfo,
      orderType: orderType ?? this.orderType,
    );
  }

  factory OrderDetails.empty() {
    return OrderDetails(
      id: '',
      code: '',
      user: User.empty(),
      products: [],
      address: Address.empty(),
      nfcDetails: NfcDetails.empty(),
      totalPrice: 0,
      orderStatus: '',
      createdBy: '',
      paymentMode: '',
      paymentServiceProvider: '',
      paymentStatus: '',
      isRefunded: false,
      isDeleted: false,
      createdAt: '',
      updatedAt: '',
      v: 0,
      razorpayPaymentLink: '',
      razorpayPaymentLinkId: '',
      paymentMethod: '',
      paymentStatusLogs: PaymentStatusLogs.empty(),
      razorpayOrderId: '',
      razorpayPaymentId: '',
      personalInfo: PersonalInfo.empty(),
      orderType: '',
    );
  }

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      id: json['_id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      user: User.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => OrderProduct.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      address: Address.fromJson(json['address'] as Map<String, dynamic>? ?? {}),
      nfcDetails: NfcDetails.fromJson(
        json['nfcDetails'] as Map<String, dynamic>? ?? {},
      ),
      totalPrice: double.tryParse(json['totalPrice']?.toString() ?? '0') ?? 0.0,
      orderStatus: json['orderStatus']?.toString() ?? '',
      createdBy: json['createdBy']?.toString() ?? '',
      paymentMode: json['paymentMode']?.toString() ?? '',
      paymentServiceProvider: json['paymentServiceProvider']?.toString() ?? '',
      paymentStatus: json['paymentStatus']?.toString() ?? '',
      isRefunded: json['isRefunded'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      v: int.tryParse(json['__v']?.toString() ?? '0') ?? 0,
      razorpayPaymentLink: json['razorpayPaymentLink']?.toString() ?? '',
      razorpayPaymentLinkId: json['razorpayPaymentLinkId']?.toString() ?? '',
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      paymentStatusLogs: PaymentStatusLogs.fromJson(
        json['paymentStatusLogs'] as Map<String, dynamic>? ?? {},
      ),
      razorpayOrderId: json['razorpayOrderId']?.toString() ?? '',
      razorpayPaymentId: json['razorpayPaymentId']?.toString() ?? '',
      personalInfo: PersonalInfo.fromJson(
        json['personalInfo'] as Map<String, dynamic>? ?? {},
      ),
      orderType: json['orderType']?.toString() ?? '',
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.empty() {
    return User(id: '', name: '', email: '');
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}

class OrderProduct {
  final dynamic product;
  final int quantity;
  final double salePrice;
  final double discountPercentage;
  final double totalPrice;
  final String id;

  OrderProduct({
    required this.product,
    required this.quantity,
    required this.salePrice,
    required this.discountPercentage,
    required this.totalPrice,
    required this.id,
  });
  OrderProduct copyWith({
    dynamic product,
    int? quantity,
    double? salePrice,
    double? discountPercentage,
    double? totalPrice,
    String? id,
  }) {
    return OrderProduct(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      salePrice: salePrice ?? this.salePrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      totalPrice: totalPrice ?? this.totalPrice,
      id: id ?? this.id,
    );
  }

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    var productData = json['product'];
    return OrderProduct(
      product:
          productData is String
              ? productData
              : ProductDetails.fromJson(productData as Map<String, dynamic>),

      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      salePrice: double.tryParse(json['salePrice']?.toString() ?? '0') ?? 0.0,
      discountPercentage:
          double.tryParse(json['discountPercentage']?.toString() ?? '0') ?? 0.0,
      totalPrice: double.tryParse(json['totalPrice']?.toString() ?? '0') ?? 0.0,
      id: json['_id']?.toString() ?? '',
    );
  }
}

class ProductDetails {
  final String id;
  final String name;
  final Category category;
  final List<ProductImages> productImages;
  final double actualPrice;
  final double salePrice;
  final double discountPercentage;
  final double discountedPrice;
  final String code;

  ProductDetails({
    required this.id,
    required this.name,
    required this.category,
    required this.productImages,
    required this.actualPrice,
    required this.salePrice,
    required this.discountPercentage,
    required this.discountedPrice,
    required this.code,
  });

  // Add a getter to easily access the first image
  ProductImages? get firstImage =>
      productImages.isNotEmpty ? productImages.first : null;

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: Category.fromJson(
        json['category'] as Map<String, dynamic>? ?? {},
      ),
      productImages:
          (json['productImages'] as List<dynamic>?)
              ?.map((e) => ProductImages.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      actualPrice:
          double.tryParse(json['actualPrice']?.toString() ?? '0') ?? 0.0,
      salePrice: double.tryParse(json['salePrice']?.toString() ?? '0') ?? 0.0,
      discountPercentage:
          double.tryParse(json['discountPercentage']?.toString() ?? '0') ?? 0.0,
      discountedPrice:
          double.tryParse(json['discountedPrice']?.toString() ?? '0') ?? 0.0,
      code: json['code']?.toString() ?? '',
    );
  }
}

// class ProductDetails {
//   final String id;
//   final String name;
//   final Category category;
//   final ProductImages productImages;
//   final double actualPrice;
//   final double salePrice;
//   final double discountPercentage;
//   final double discountedPrice;
//   final String code;

//   ProductDetails({
//     required this.id,
//     required this.name,
//     required this.category,
//     required this.productImages,
//     required this.actualPrice,
//     required this.salePrice,
//     required this.discountPercentage,
//     required this.discountedPrice,
//     required this.code,
//   });

//   factory ProductDetails.fromJson(Map<String, dynamic> json) {
//     return ProductDetails(
//       id: json['_id']?.toString() ?? '',
//       name: json['name']?.toString() ?? '',
//       category: Category.fromJson(
//         json['category'] as Map<String, dynamic>? ?? {},
//       ),
//       productImages: ProductImages.fromJson(
//         json['productImages'] as Map<String, dynamic>? ?? {},
//       ),
//       actualPrice:
//           double.tryParse(json['actualPrice']?.toString() ?? '0') ?? 0.0,
//       salePrice: double.tryParse(json['salePrice']?.toString() ?? '0') ?? 0.0,
//       discountPercentage:
//           double.tryParse(json['discountPercentage']?.toString() ?? '0') ?? 0.0,
//       discountedPrice:
//           double.tryParse(json['discountedPrice']?.toString() ?? '0') ?? 0.0,
//       code: json['code']?.toString() ?? '',
//     );
//   }
// }

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class ProductImages {
  final String name;
  final String key;
  final int size;
  final String mimetype;
  final String id;

  ProductImages({
    required this.name,
    required this.key,
    required this.size,
    required this.mimetype,
    required this.id,
  });

  factory ProductImages.fromJson(Map<String, dynamic> json) {
    return ProductImages(
      name: json['name']?.toString() ?? '',
      key: json['key']?.toString() ?? '',
      size: int.tryParse(json['size']?.toString() ?? '0') ?? 0,
      mimetype: json['mimetype']?.toString() ?? '',
      id: json['_id']?.toString() ?? '',
    );
  }
}

class Address {
  final String name;
  final String mobile;
  final String address1;
  final String address2;
  final String landmark;
  final String pincode;
  final String district;
  final String state;
  final String country;

  Address({
    required this.name,
    required this.mobile,
    required this.address1,
    required this.address2,
    required this.landmark,
    required this.pincode,
    required this.district,
    required this.state,
    required this.country,
  });

  factory Address.empty() {
    return Address(
      name: '',
      mobile: '',
      address1: '',
      address2: '',
      landmark: '',
      pincode: '',
      district: '',
      state: '',
      country: '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile': mobile,
      'address1': address1,
      'address2': address2,
      'landmark': landmark,
      'pincode': pincode,
      'district': district,
      'state': state,
      'country': country,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      name: json['name']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      address1: json['address1']?.toString() ?? '',
      address2: json['address2']?.toString() ?? '',
      landmark: json['landmark']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
    );
  }
}

class NfcDetails {
  final String customerName;
  final String designation;
  final CustomerFile customerLogo;
  final CustomerFile customerPhoto;

  NfcDetails({
    required this.customerName,
    required this.designation,
    required this.customerLogo,
    required this.customerPhoto,
  });

  factory NfcDetails.empty() {
    return NfcDetails(
      customerName: '',
      designation: '',
      customerLogo: CustomerFile.empty(),
      customerPhoto: CustomerFile.empty(),
    );
  }

  factory NfcDetails.fromJson(Map<String, dynamic> json) {
    return NfcDetails(
      customerName: json['customerName']?.toString() ?? '',
      designation: json['designation']?.toString() ?? '',
      customerLogo: CustomerFile.fromJson(
        json['customerLogo'] as Map<String, dynamic>? ?? {},
      ),
      customerPhoto: CustomerFile.fromJson(
        json['customerPhoto'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class CustomerFile {
  final ImageDetails image;
  final String source;

  CustomerFile({required this.image, required this.source});

  factory CustomerFile.empty() {
    return CustomerFile(image: ImageDetails.empty(), source: '');
  }

  factory CustomerFile.fromJson(Map<String, dynamic> json) {
    return CustomerFile(
      image: ImageDetails.fromJson(
        json['image'] as Map<String, dynamic>? ?? {},
      ),
      source: json['source']?.toString() ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
    'image': {
      'key': image.key,
      'name': image.name,
      'mimetype': image.mimetype,
      'size': image.size,
    },
    'source': source,
  };
}

class ImageDetails {
  final String name;
  final String key;
  final int size;
  final String mimetype;

  ImageDetails({
    required this.name,
    required this.key,
    required this.size,
    required this.mimetype,
  });

  factory ImageDetails.empty() {
    return ImageDetails(name: '', key: '', size: 0, mimetype: '');
  }

  factory ImageDetails.fromJson(Map<String, dynamic> json) {
    return ImageDetails(
      name: json['name']?.toString() ?? '',
      key: json['key']?.toString() ?? '',
      size: int.tryParse(json['size']?.toString() ?? '0') ?? 0,
      mimetype: json['mimetype']?.toString() ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
    'key': key,
    'name': name,
    'mimetype': mimetype,
    'size': size,
  };
}

class PaymentStatusLogs {
  final String paymentSuccessAt;

  PaymentStatusLogs({required this.paymentSuccessAt});

  factory PaymentStatusLogs.empty() {
    return PaymentStatusLogs(paymentSuccessAt: '');
  }

  factory PaymentStatusLogs.fromJson(Map<String, dynamic> json) {
    return PaymentStatusLogs(
      paymentSuccessAt: json['paymentSuccessAt']?.toString() ?? '',
    );
  }
}

class PersonalInfo {
  final String whatsappNumber;
  final String phoneNumber;
  final String name;
  final String email;

  PersonalInfo({
    required this.whatsappNumber,
    required this.phoneNumber,
    required this.name,
    required this.email,
  });

  factory PersonalInfo.empty() {
    return PersonalInfo(
      whatsappNumber: '',
      phoneNumber: '',
      name: '',
      email: '',
    );
  }

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      whatsappNumber: json['whatsappNumber']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}

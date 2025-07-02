class ProductResponse {
  final bool success;
  final String message;
  final List<Product> results;
  final List<ProductSearch> productSearch;

  ProductResponse({
    required this.success,
    required this.message,
    required this.results,
    required this.productSearch,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List;
    return ProductResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      results:
          json['results'] != null
              ? List<Product>.from(
                json['results'].map((x) => Product.fromJson(x)),
              )
              : [],
      productSearch: results.map((e) => ProductSearch.fromJson(e)).toList(),
    );
  }
}

class SingleProductResponse {
  final bool success;
  final String message;
  final Product? result;

  SingleProductResponse({
    required this.success,
    required this.message,
    this.result,
  });

  factory SingleProductResponse.fromJson(Map<String, dynamic> json) {
    return SingleProductResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      result: json['result'] != null ? Product.fromJson(json['result']) : null,
    );
  }
}

class Product {
  final String? id;
  final String? name;
  final String? type;
  final Category? category;
  final CoverImage? coverImage;
  final List<ProductImage>? productImages;
  final double? actualPrice;
  final double? salePrice;
  final double? discountPercentage;
  final double? discountedPrice;
  final int? orderCount;
  final String? status;
  final bool? isDeleted;
  final String? createdAt;
  final String? code;
  final String? description;

  Product({
    this.id,
    this.name,
    this.type,
    this.category,
    this.coverImage,
    this.productImages,
    this.actualPrice,
    this.salePrice,
    this.discountPercentage,
    this.discountedPrice,
    this.orderCount,
    this.status,
    this.isDeleted,
    this.createdAt,
    this.code,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      category:
          json['category'] != null
              ? Category.fromJson(json['category'])
              : Category(id: '68156d352847123cbaae61d3', name: ''),
      coverImage:
          json['coverImage'] != null
              ? CoverImage.fromJson(json['coverImage'])
              : CoverImage(name: '', key: '', size: 0, mimetype: ''),
      productImages:
          json['productImages'] != null
              ? (json['productImages'] as List)
                  .map((imageJson) => ProductImage.fromJson(imageJson))
                  .toList()
              : [],
      actualPrice: double.tryParse(json['actualPrice'].toString()) ?? 0.0,
      salePrice: double.tryParse(json['salePrice'].toString()) ?? 0.0,
      discountPercentage:
          double.tryParse(json['discountPercentage'].toString()) ?? 0.0,
      discountedPrice:
          double.tryParse(json['discountedPrice'].toString()) ?? 0.0,
      orderCount: int.tryParse(json['orderCount'].toString()) ?? 0,
      status: json['status'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toAddJson() {
    return {
      'name': name,
      'type': type,
      'category': category?.id,
      'description': description,
      'actualPrice': actualPrice,
      'salePrice': salePrice,
      'discountedPrice': discountedPrice,
      'discountPercentage': discountPercentage,
      'productImages': productImages?.map((e) => e.toJson()).toList(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'type': type,
      'category': category!.toJson(),
      'coverImage': coverImage!.toJson(),
      'productImages': productImages!.map((img) => img.toJson()).toList(),
      'actualPrice': actualPrice,
      'salePrice': salePrice,
      'discountPercentage': discountPercentage,
      'discountedPrice': discountedPrice,
      'orderCount': orderCount,
      'status': status,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'code': code,
      'description': description,
    };
  }
}

class Category {
  final String id;
  final String? name;

  Category({required this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['_id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}

class CoverImage {
  final String name;
  final String key;
  final int size;
  final String mimetype;

  CoverImage({
    required this.name,
    required this.key,
    required this.size,
    required this.mimetype,
  });

  factory CoverImage.fromJson(Map<String, dynamic> json) {
    return CoverImage(
      name: json['name'] ?? '',
      key: json['key'] ?? '',
      size: int.tryParse(json['size'].toString()) ?? 0,
      mimetype: json['mimetype'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'key': key,
    'size': size,
    'mimetype': mimetype,
  };
}

class ProductImage {
  final String? name;
  final String key;
  final int? size;
  final String? mimetype;

  ProductImage({this.name, required this.key, this.size, this.mimetype});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      name: json['name'] ?? '',
      key: json['key'] ?? '',
      size: int.tryParse(json['size'].toString()) ?? 0,
      mimetype: json['mimetype'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'key': key,
    'size': size,
    'mimetype': mimetype,
  };
}

class ProductSearch {
  final String? id;
  final String? name;
  final double? salePrice;
  final Category? category;
  final double? discountedPrice;
  final List<ProductImage>? productImages;
  int quantity;

  ProductSearch({
    this.name,
    this.salePrice,
    this.discountedPrice,
    this.id,
    this.category,
    this.productImages,
    this.quantity = 1,
  });

  factory ProductSearch.fromJson(Map<String, dynamic> json) {
    return ProductSearch(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      salePrice: double.tryParse(json['salePrice'].toString()) ?? 0.0,
      discountedPrice:
          double.tryParse(json['discountedPrice'].toString()) ?? 0.0,
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      productImages:
          json['productImages'] != null
              ? (json['productImages'] as List)
                  .map((imageJson) => ProductImage.fromJson(imageJson))
                  .toList()
              : [],
    );
  }
}

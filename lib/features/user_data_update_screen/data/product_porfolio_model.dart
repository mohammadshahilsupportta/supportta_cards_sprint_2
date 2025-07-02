class PortfolioProductModel {
  final String id;
  final String name;
  final String type;
  final ProductCategory category;
  final List<ProductImage> productImages;
  final String description;
  final int actualPrice;
  final int salePrice;
  final double discountPercentage;
  final int discountedPrice;
  final int orderCount;
  final String status;
  final bool isDeleted;
  final DateTime createdAt;
  final String code;

  PortfolioProductModel({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.productImages,
    required this.description,
    required this.actualPrice,
    required this.salePrice,
    required this.discountPercentage,
    required this.discountedPrice,
    required this.orderCount,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    required this.code,
  });

  factory PortfolioProductModel.fromJson(Map<String, dynamic> json) {
    return PortfolioProductModel(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
      category: ProductCategory.fromJson(json['category']),
      productImages:
          (json['productImages'] as List<dynamic>)
              .map((e) => ProductImage.fromJson(e))
              .toList(),
      description: json['description'],
      actualPrice: json['actualPrice'],
      salePrice: json['salePrice'],
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      discountedPrice: json['discountedPrice'],
      orderCount: json['orderCount'],
      status: json['status'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      code: json['code'],
    );
  }
}

class ProductCategory {
  final String id;
  final String name;

  ProductCategory({required this.id, required this.name});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(id: json['_id'], name: json['name']);
  }
}

class ProductImage {
  final String name;
  final String key;
  final String size;
  final String mimetype;
  final String id;

  ProductImage({
    required this.name,
    required this.key,
    required this.size,
    required this.mimetype,
    required this.id,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      name: json['name'],
      key: json['key'],
      size: json['size'],
      mimetype: json['mimetype'],
      id: json['_id'],
    );
  }
}

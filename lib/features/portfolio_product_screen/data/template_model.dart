class TemplateResponse {
  final bool success;
  final String message;
  final int currentPage;
  final List<Template> results;
  final int latestCount;
  final int totalCount;
  final int totalPages;

  TemplateResponse({
    required this.success,
    required this.message,
    required this.currentPage,
    required this.results,
    required this.latestCount,
    required this.totalCount,
    required this.totalPages,
  });

  factory TemplateResponse.fromJson(Map<String, dynamic> json) {
    return TemplateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      currentPage: json['currentPage'] ?? 1,
      results: (json['results'] as List)
          .map((item) => Template.fromJson(item))
          .toList(),
      latestCount: json['latestCount'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

class SingleTemplateResponse {
  final bool success;
  final String message;
  final Template? result;

  SingleTemplateResponse({
    required this.success,
    required this.message,
    this.result,
  });

  factory SingleTemplateResponse.fromJson(Map<String, dynamic> json) {
    final results = json['results'];
    return SingleTemplateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      result: (results != null && results is List && results.isNotEmpty)
          ? Template.fromJson(results.first)
          : null,
    );
  }
}
class Template {
  final String? id;
  final String? name;
  final Thumbnail? thumbnail;
  final Category? category;
  final String? status;
  final String? visibility;
  final bool? isPremium;
  final bool? isDeleted;
  final String? createdAt;
  final String? code;

  Template({
    this.id,
    this.name,
    this.thumbnail,
    this.category,
    this.status,
    this.visibility,
    this.isPremium,
    this.isDeleted,
    this.createdAt,
    this.code,
  });

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      thumbnail: json['thumbnail'] != null
          ? Thumbnail.fromJson(json['thumbnail'])
          : null,
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
      status: json['status'] ?? '',
      visibility: json['visibility'] ?? '',
      isPremium: json['isPremium'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'thumbnail': thumbnail?.toJson(),
      'category': category?.toJson(),
      'status': status,
      'visibility': visibility,
      'isPremium': isPremium,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'code': code,
    };
  }

  Map<String, dynamic> toEditJson() {
    return {
      if (name != null) 'name': name,
      if (category?.id != null) 'categoryId': category?.id,
      if (status != null) 'status': status,
      if (visibility != null) 'visibility': visibility,
      if (isPremium != null) 'isPremium': isPremium,
      if (thumbnail != null) 'thumbnail': thumbnail?.toJson(),
    };
  }
}

class Thumbnail {
  final String name;
  final String key;
  final String size;
  final String mimetype;

  Thumbnail({
    required this.name,
    required this.key,
    required this.size,
    required this.mimetype,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) {
    return Thumbnail(
      name: json['name'] ?? '',
      key: json['key'] ?? '',
      size: json['size'] ?? '0',
      mimetype: json['mimetype'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'key': key,
      'size': size,
      'mimetype': mimetype,
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


// class TemplateResponse {
//   final bool success;
//   final String message;
//   final int currentPage;
//   final List<Template> results;
//   final int latestCount;
//   final int totalCount;
//   final int totalPages;

//   TemplateResponse({
//     required this.success,
//     required this.message,
//     required this.currentPage,
//     required this.results,
//     required this.latestCount,
//     required this.totalCount,
//     required this.totalPages,
//   });

//   factory TemplateResponse.fromJson(Map<String, dynamic> json) {
//     return TemplateResponse(
//       success: json['success'],
//       message: json['message'],
//       currentPage: json['currentPage'],
//       results: (json['results'] as List)
//           .map((item) => Template.fromJson(item))
//           .toList(),
//       latestCount: json['latestCount'],
//       totalCount: json['totalCount'],
//       totalPages: json['totalPages'],
//     );
//   }
// }

// class Template {
//   final String id;
//   final String name;
//   final Thumbnail thumbnail;
//   final Category category;
//   final String status;
//   final String visibility;
//   final bool isPremium;
//   final bool isDeleted;
//   final DateTime createdAt;
//   final String code;

//   Template({
//     required this.id,
//     required this.name,
//     required this.thumbnail,
//     required this.category,
//     required this.status,
//     required this.visibility,
//     required this.isPremium,
//     required this.isDeleted,
//     required this.createdAt,
//     required this.code,
//   });

//   factory Template.fromJson(Map<String, dynamic> json) {
//     return Template(
//       id: json['_id'],
//       name: json['name'],
//       thumbnail: Thumbnail.fromJson(json['thumbnail']),
//       category: Category.fromJson(json['category']),
//       status: json['status'],
//       visibility: json['visibility'],
//       isPremium: json['isPremium'],
//       isDeleted: json['isDeleted'],
//       createdAt: DateTime.parse(json['createdAt']),
//       code: json['code'],
//     );
//   }
// }

// class Thumbnail {
//   final String name;
//   final String key;
//   final String size;
//   final String mimetype;

//   Thumbnail({
//     required this.name,
//     required this.key,
//     required this.size,
//     required this.mimetype,
//   });

//   factory Thumbnail.fromJson(Map<String, dynamic> json) {
//     return Thumbnail(
//       name: json['name'],
//       key: json['key'],
//       size: json['size'],
//       mimetype: json['mimetype'],
//     );
//   }
// }

// class Category {
//   final String id;
//   final String name;

//   Category({
//     required this.id,
//     required this.name,
//   });

//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       id: json['_id'],
//       name: json['name'],
//     );
//   }
// }

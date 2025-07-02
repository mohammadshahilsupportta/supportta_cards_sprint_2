class LeadsResponse {
  final bool success;
  final String message;
  final int currentPage;
  final List<Lead> results;
  final int totalCount;
  final int totalPages;

  LeadsResponse({
    required this.success,
    required this.message,
    required this.currentPage,
    required this.results,
    required this.totalCount,
    required this.totalPages,
  });

  factory LeadsResponse.fromJson(Map<String, dynamic> json) {
    return LeadsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      currentPage: json['currentPage'] ?? 1,
      results:
          (json['results'] as List?)?.map((e) => Lead.fromJson(e)).toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'currentPage': currentPage,
      'results': results.map((e) => e.toJson()).toList(),
      'totalCount': totalCount,
      'totalPages': totalPages,
    };
  }
}

class Lead {
  final String id;
  final String name;
  final String number;
  final String email;
  final String description;

  Lead({
    required this.id,
    required this.name,
    required this.number,
    required this.email,
    required this.description,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      number: json['number'] ?? '',
      email: json['email'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'number': number,
      'email': email,
      'description': description,
    };
  }
}

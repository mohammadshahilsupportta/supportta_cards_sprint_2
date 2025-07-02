class ExpenseResponse {
  final bool success;
  final String message;
  final int currentPage;
  final List<Expense> results;
  final int totalCount;
  final int totalPages;

  ExpenseResponse({
    required this.success,
    required this.message,
    required this.currentPage,
    required this.results,
    required this.totalCount,
    required this.totalPages,
  });

  factory ExpenseResponse.fromJson(Map<String, dynamic> json) {
    return ExpenseResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      currentPage: json['currentPage'] ?? 1,
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => Expense.fromJson(e as Map<String, dynamic>))
              .toList() ??
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

class Expense {
  final String id;
  final String category;
  final String name;
  final double amount;
  final DateTime date;
  final String description;
  final bool isDeleted;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.category,
    required this.name,
    required this.amount,
    required this.date,
    required this.description,
    required this.isDeleted,
    required this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['_id'] ?? '',
      category: json['category'] ?? '',
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      description: json['description'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'category': category,
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Optional: Add copyWith method for easy object modification
  Expense copyWith({
    String? id,
    String? category,
    String? name,
    double? amount,
    DateTime? date,
    String? description,
    bool? isDeleted,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      category: category ?? this.category,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

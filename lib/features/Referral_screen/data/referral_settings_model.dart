class ReferralSettingsResponse {
  final bool success;
  final String message;
  final List<ReferralSetting> results;

  ReferralSettingsResponse({
    required this.success,
    required this.message,
    required this.results,
  });

  factory ReferralSettingsResponse.fromJson(Map<String, dynamic> json) {
    return ReferralSettingsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      results:
          (json['results'] as List<dynamic>?)
              ?.map((item) => ReferralSetting.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'results': results.map((item) => item.toJson()).toList(),
    };
  }
}

class ReferralSetting {
  final String? id;

  final DiscountType discountType;
  final CommissionType commissionType;
  final double? discountPercentage;
  final double? commissionPercentage;
  final double? discountAmount;
  final double? commissionAmount;
  final String status;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;

  ReferralSetting({
    this.id,
    
    required this.discountType,
    required this.commissionType,
    this.discountPercentage,
    this.commissionPercentage,
    this.discountAmount,
    this.commissionAmount,
    this.status = 'Active',
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory ReferralSetting.fromJson(Map<String, dynamic> json) {
    return ReferralSetting(
      id: json['_id'],
    
      discountType: DiscountType.values.firstWhere(
        (e) => e.name == json['discountType'],
        orElse: () => DiscountType.Percentage,
      ),
      commissionType: CommissionType.values.firstWhere(
        (e) => e.name == json['commissionType'],
        orElse: () => CommissionType.Percentage,
      ),
      discountPercentage: json['discountPercentage']?.toDouble(),
      commissionPercentage: json['commissionPercentage']?.toDouble(),
      discountAmount: json['discountAmount']?.toDouble(),
      commissionAmount: json['commissionAmount']?.toDouble(),
      status: json['status'] ?? 'Active',
      isDeleted: json['isDeleted'] ?? false,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      
      'discountType': discountType.name,
      'commissionType': commissionType.name,
      'status': status,
      'isDeleted': isDeleted,
    };

    // Only include non-null values
    if (id != null) data['_id'] = id;
    if (discountPercentage != null)
      data['discountPercentage'] = discountPercentage;
    if (commissionPercentage != null)
      data['commissionPercentage'] = commissionPercentage;
    if (discountAmount != null) data['discountAmount'] = discountAmount;
    if (commissionAmount != null) data['commissionAmount'] = commissionAmount;
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();
    if (version != null) data['__v'] = version;

    return data;
  }

  // For POST requests (creating new referral settings)
  Map<String, dynamic> toCreateJson() {
    final Map<String, dynamic> data = {
      
      'discountType': discountType.name,
      'commissionType': commissionType.name,
      'status': status,
      'isDeleted': isDeleted,
    };

    // Include relevant amount/percentage based on type
    if (discountType == DiscountType.Percentage && discountPercentage != null) {
      data['discountPercentage'] = discountPercentage;
    } else if (discountType == DiscountType.Flat && discountAmount != null) {
      data['discountAmount'] = discountAmount;
    }

    if (commissionType == CommissionType.Percentage &&
        commissionPercentage != null) {
      data['commissionPercentage'] = commissionPercentage;
    } else if (commissionType == CommissionType.Flat &&
        commissionAmount != null) {
      data['commissionAmount'] = commissionAmount;
    }

    return data;
  }

  // For PATCH requests (updating existing referral settings)
  Map<String, dynamic> toUpdateJson() {
    final Map<String, dynamic> data = {};

    // Only include fields that should be updated
   
    data['discountType'] = discountType.name;
    data['commissionType'] = commissionType.name;
    data['status'] = status;
    data['isDeleted'] = isDeleted;

    // Include relevant amount/percentage based on type
    if (discountType == DiscountType.Percentage && discountPercentage != null) {
      data['discountPercentage'] = discountPercentage;
      // Remove discountAmount if switching from Flat to Percentage
      data['discountAmount'] = null;
    } else if (discountType == DiscountType.Flat && discountAmount != null) {
      data['discountAmount'] = discountAmount;
      // Remove discountPercentage if switching from Percentage to Flat
      data['discountPercentage'] = null;
    }

    if (commissionType == CommissionType.Percentage &&
        commissionPercentage != null) {
      data['commissionPercentage'] = commissionPercentage;
      // Remove commissionAmount if switching from Flat to Percentage
      data['commissionAmount'] = null;
    } else if (commissionType == CommissionType.Flat &&
        commissionAmount != null) {
      data['commissionAmount'] = commissionAmount;
      // Remove commissionPercentage if switching from Percentage to Flat
      data['commissionPercentage'] = null;
    }

    return data;
  }

  // Copy with method for easy updates
  ReferralSetting copyWith({
    String? id,
    String? type,
    DiscountType? discountType,
    CommissionType? commissionType,
    double? discountPercentage,
    double? commissionPercentage,
    double? discountAmount,
    double? commissionAmount,
    String? status,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return ReferralSetting(
      id: id ?? this.id,
      
      discountType: discountType ?? this.discountType,
      commissionType: commissionType ?? this.commissionType,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      commissionPercentage: commissionPercentage ?? this.commissionPercentage,
      discountAmount: discountAmount ?? this.discountAmount,
      commissionAmount: commissionAmount ?? this.commissionAmount,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }

  @override
  String toString() {
    return 'ReferralSetting(id: $id,  discountType: $discountType, commissionType: $commissionType, status: $status)';
  }
}

// Enums for type safety
enum DiscountType { Flat, Percentage }

enum CommissionType { Flat, Percentage }

// Extension methods for enum display
extension DiscountTypeExtension on DiscountType {
  String get displayName {
    switch (this) {
      case DiscountType.Flat:
        return 'Flat';
      case DiscountType.Percentage:
        return 'Percentage';
    }
  }
}

extension CommissionTypeExtension on CommissionType {
  String get displayName {
    switch (this) {
      case CommissionType.Flat:
        return 'Flat';
      case CommissionType.Percentage:
        return 'Percentage';
    }
  }
}

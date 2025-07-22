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

  // Auto-determine discount type based on which value is provided
  DiscountType get discountType {
    if (discountPercentage != null) return DiscountType.Percentage;
    if (discountAmount != null) return DiscountType.Flat;
    return DiscountType.Percentage; // default
  }

  // Auto-determine commission type based on which value is provided
  CommissionType get commissionType {
    if (commissionPercentage != null) return CommissionType.Percentage;
    if (commissionAmount != null) return CommissionType.Flat;
    return CommissionType.Percentage; // default
  }

  // Check if discount type has changed
  bool hasDiscountTypeChanged(ReferralSetting? previous) {
    if (previous == null) return true; // New setting
    return discountType != previous.discountType;
  }

  // Check if commission type has changed
  bool hasCommissionTypeChanged(ReferralSetting? previous) {
    if (previous == null) return true; // New setting
    return commissionType != previous.commissionType;
  }

  factory ReferralSetting.fromJson(Map<String, dynamic> json) {
    return ReferralSetting(
      id: json['_id'],
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

    if (id != null) data['_id'] = id;
    if (discountPercentage != null) data['discountPercentage'] = discountPercentage;
    if (commissionPercentage != null) data['commissionPercentage'] = commissionPercentage;
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

    // Include only the relevant value based on what's provided
    if (discountPercentage != null) {
      data['discountPercentage'] = discountPercentage;
    } else if (discountAmount != null) {
      data['discountAmount'] = discountAmount;
    }

    if (commissionPercentage != null) {
      data['commissionPercentage'] = commissionPercentage;
    } else if (commissionAmount != null) {
      data['commissionAmount'] = commissionAmount;
    }

    return data;
  }

  // For PATCH requests (updating existing referral settings)
  Map<String, dynamic> toUpdateJson(ReferralSetting? previousSetting) {
    final Map<String, dynamic> data = {};

    // Only include type if it has changed
    if (hasDiscountTypeChanged(previousSetting)) {
      data['discountType'] = discountType.name;
    }

    if (hasCommissionTypeChanged(previousSetting)) {
      data['commissionType'] = commissionType.name;
    }

    // Always include status
    data['status'] = status;
    data['isDeleted'] = isDeleted;

    // Handle discount values
    if (discountPercentage != null) {
      data['discountPercentage'] = discountPercentage;
      // If type changed from Flat to Percentage, null out the amount
      if (hasDiscountTypeChanged(previousSetting) && 
          previousSetting?.discountAmount != null) {
        data['discountAmount'] = null;
      }
    } else if (discountAmount != null) {
      data['discountAmount'] = discountAmount;
      // If type changed from Percentage to Flat, null out the percentage
      if (hasDiscountTypeChanged(previousSetting) && 
          previousSetting?.discountPercentage != null) {
        data['discountPercentage'] = null;
      }
    }

    // Handle commission values
    if (commissionPercentage != null) {
      data['commissionPercentage'] = commissionPercentage;
      // If type changed from Flat to Percentage, null out the amount
      if (hasCommissionTypeChanged(previousSetting) && 
          previousSetting?.commissionAmount != null) {
        data['commissionAmount'] = null;
      }
    } else if (commissionAmount != null) {
      data['commissionAmount'] = commissionAmount;
      // If type changed from Percentage to Flat, null out the percentage
      if (hasCommissionTypeChanged(previousSetting) && 
          previousSetting?.commissionPercentage != null) {
        data['commissionPercentage'] = null;
      }
    }

    return data;
  }

  // Copy with method for easy updates
  ReferralSetting copyWith({
    String? id,
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
    return 'ReferralSetting(id: $id, discountType: $discountType, commissionType: $commissionType, status: $status)';
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

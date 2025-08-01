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
  final String? type; // "Account" from API
  final double? discountPercentage;
  final double? commissionPercentage;
  final double? discountAmount;
  final double? commissionAmount;
  final DiscountType discountType; // Parse from API
  final CommissionType commissionType; // Parse from API
  final String status;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;

  ReferralSetting({
    this.id,
    this.type,
    this.discountPercentage,
    this.commissionPercentage,
    this.discountAmount,
    this.commissionAmount,
    required this.discountType,
    required this.commissionType,
    this.status = 'Active',
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

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
    // Parse discount type from API
    DiscountType discountType = DiscountType.Percentage; // default
    if (json['discountType'] != null) {
      discountType = json['discountType'].toString().toLowerCase() == 'flat' 
          ? DiscountType.Flat 
          : DiscountType.Percentage;
    }

    // Parse commission type from API
    CommissionType commissionType = CommissionType.Percentage; // default
    if (json['commissionType'] != null) {
      commissionType = json['commissionType'].toString().toLowerCase() == 'flat' 
          ? CommissionType.Flat 
          : CommissionType.Percentage;
    }

    return ReferralSetting(
      id: json['_id'],
      type: json['type'],
      discountPercentage: json['discountPercentage']?.toDouble(),
      commissionPercentage: json['commissionPercentage']?.toDouble(),
      discountAmount: json['discountAmount']?.toDouble(),
      commissionAmount: json['commissionAmount']?.toDouble(),
      discountType: discountType,
      commissionType: commissionType,
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
    if (type != null) data['type'] = type;
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
      'type': type ?? 'Account',
      'discountType': discountType.name,
      'commissionType': commissionType.name,
      'status': status,
      'isDeleted': isDeleted,
    };

    // Include the relevant value based on type
    if (discountType == DiscountType.Percentage && discountPercentage != null) {
      data['discountPercentage'] = discountPercentage;
    } else if (discountType == DiscountType.Flat && discountAmount != null) {
      data['discountAmount'] = discountAmount;
    }

    if (commissionType == CommissionType.Percentage && commissionPercentage != null) {
      data['commissionPercentage'] = commissionPercentage;
    } else if (commissionType == CommissionType.Flat && commissionAmount != null) {
      data['commissionAmount'] = commissionAmount;
    }

    return data;
  }

  // For PATCH requests (updating existing referral settings)
  Map<String, dynamic> toUpdateJson(ReferralSetting? previousSetting) {
    final Map<String, dynamic> data = {};

    // Always include type fields
    data['discountType'] = discountType.name;
    data['commissionType'] = commissionType.name;
    data['status'] = status;
    data['isDeleted'] = isDeleted;

    // Handle discount values - send the appropriate value and null the other
    if (discountType == DiscountType.Percentage) {
      if (discountPercentage != null) {
        data['discountPercentage'] = discountPercentage;
      }
      // Null out the amount if switching from Flat to Percentage
      if (hasDiscountTypeChanged(previousSetting)) {
        data['discountAmount'] = null;
      }
    } else {
      if (discountAmount != null) {
        data['discountAmount'] = discountAmount;
      }
      // Null out the percentage if switching from Percentage to Flat
      if (hasDiscountTypeChanged(previousSetting)) {
        data['discountPercentage'] = null;
      }
    }

    // Handle commission values - send the appropriate value and null the other
    if (commissionType == CommissionType.Percentage) {
      if (commissionPercentage != null) {
        data['commissionPercentage'] = commissionPercentage;
      }
      // Null out the amount if switching from Flat to Percentage
      if (hasCommissionTypeChanged(previousSetting)) {
        data['commissionAmount'] = null;
      }
    } else {
      if (commissionAmount != null) {
        data['commissionAmount'] = commissionAmount;
      }
      // Null out the percentage if switching from Percentage to Flat
      if (hasCommissionTypeChanged(previousSetting)) {
        data['commissionPercentage'] = null;
      }
    }

    return data;
  }

  // Copy with method for easy updates
  ReferralSetting copyWith({
    String? id,
    String? type,
    double? discountPercentage,
    double? commissionPercentage,
    double? discountAmount,
    double? commissionAmount,
    DiscountType? discountType,
    CommissionType? commissionType,
    String? status,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return ReferralSetting(
      id: id ?? this.id,
      type: type ?? this.type,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      commissionPercentage: commissionPercentage ?? this.commissionPercentage,
      discountAmount: discountAmount ?? this.discountAmount,
      commissionAmount: commissionAmount ?? this.commissionAmount,
      discountType: discountType ?? this.discountType,
      commissionType: commissionType ?? this.commissionType,
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

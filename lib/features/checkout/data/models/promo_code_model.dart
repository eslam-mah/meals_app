import 'package:equatable/equatable.dart';

class PromoCodeModel extends Equatable {
  final String id;
  final String code;
  final String type;
  final int percentage;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final int? usageLimit;
  final DateTime createdAt;

  const PromoCodeModel({
    required this.id,
    required this.code,
    required this.type,
    required this.percentage,
    this.startsAt,
    this.expiresAt,
    this.usageLimit,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id, 
    code, 
    type, 
    percentage, 
    startsAt, 
    expiresAt, 
    usageLimit, 
    createdAt,
  ];

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) {
    // Debug the raw JSON
    print('Creating PromoCodeModel from JSON: $json');
    
    try {
      return PromoCodeModel(
        id: json['id'] as String,
        code: json['code'] as String,
        type: json['type'] as String,
        percentage: json['percentage'] as int,
        startsAt: json['starts_at'] != null ? DateTime.parse(json['starts_at'] as String) : null,
        expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'] as String) : null,
        usageLimit: json['usage_limit'] as int?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
    } catch (e) {
      print('Error parsing PromoCodeModel from JSON: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'type': type,
      'percentage': percentage,
      'starts_at': startsAt?.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'usage_limit': usageLimit,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Check if the promo code is currently valid based on dates
  bool get isValid {
    final now = DateTime.now();
    
    // Check start date
    if (startsAt != null && now.isBefore(startsAt!)) {
      return false;
    }
    
    // Check expiration date
    if (expiresAt != null && now.isAfter(expiresAt!)) {
      return false;
    }
    
    return true;
  }

  /// Calculate the discount amount based on the promo code percentage
  double calculateDiscount(double amount) {
    final discount = amount * (percentage / 100);
    print('PromoCodeModel calculating discount: $percentage% of $amount = $discount');
    return discount;
  }
} 
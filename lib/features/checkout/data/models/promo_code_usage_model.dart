import 'package:equatable/equatable.dart';

class PromoCodeUsageModel extends Equatable {
  final int id;
  final String userId;
  final String promoCodeId;
  final DateTime usedAt;

  const PromoCodeUsageModel({
    required this.id,
    required this.userId,
    required this.promoCodeId,
    required this.usedAt,
  });

  @override
  List<Object?> get props => [id, userId, promoCodeId, usedAt];

  factory PromoCodeUsageModel.fromJson(Map<String, dynamic> json) {
    return PromoCodeUsageModel(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      promoCodeId: json['promo_code_id'] as String,
      usedAt: DateTime.parse(json['used_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'promo_code_id': promoCodeId,
      'used_at': usedAt.toIso8601String(),
    };
  }

  // Create a new promo code usage record
  factory PromoCodeUsageModel.create({
    required String userId,
    required String promoCodeId,
  }) {
    return PromoCodeUsageModel(
      id: 0, // Will be auto-assigned by the database
      userId: userId,
      promoCodeId: promoCodeId,
      usedAt: DateTime.now(),
    );
  }
} 
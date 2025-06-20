import 'package:uuid/uuid.dart';

class FeedbackModel {
  final String id;
  final String? userId;
  final int rating1; // Food quality rating
  final int rating2; // Service speed rating
  final int rating3; // Order ease rating
  final int overallRate; // Overall satisfaction (like/dislike - 0/1)
  final String? comment; // Optional feedback text
  final String? phoneNumber;
  final DateTime createdAt;

  FeedbackModel({
    String? id,
    this.userId,
    required this.rating1,
    required this.rating2,
    required this.rating3,
    required this.overallRate,
    this.comment,
    this.phoneNumber,
    DateTime? createdAt,
  }) : 
    id = id ?? const Uuid().v4(),
    createdAt = createdAt ?? DateTime.now();

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'rating1': rating1,
      'rating2': rating2,
      'rating3': rating3,
      'overall_rate': overallRate,
      'comment': comment,
      'phone_number': phoneNumber,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create model from JSON
  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      userId: json['user_id'],
      rating1: json['rating1'],
      rating2: json['rating2'],
      rating3: json['rating3'],
      overallRate: json['overall_rate'],
      comment: json['comment'],
      phoneNumber: json['phone_number'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Create a copy with some fields updated
  FeedbackModel copyWith({
    String? id,
    String? userId,
    int? rating1,
    int? rating2,
    int? rating3,
    int? overallRate,
    String? comment,
    String? phoneNumber,
    DateTime? createdAt,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      rating1: rating1 ?? this.rating1,
      rating2: rating2 ?? this.rating2,
      rating3: rating3 ?? this.rating3,
      overallRate: overallRate ?? this.overallRate,
      comment: comment ?? this.comment,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 
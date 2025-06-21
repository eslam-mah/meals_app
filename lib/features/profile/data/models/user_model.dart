import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel extends Equatable {
  final String id;
  final DateTime createdAt;
  final String email;
  final String? name;
  final String? phoneNumber;
  final String? city;
  final String? location;
  final String? userType;

  const UserModel({
    required this.id,
    required this.createdAt,
    required this.email,
    this.name,
    this.phoneNumber,
    this.city,
    this.location,
    this.userType,
  });

  @override
  List<Object?> get props => [
        id,
        createdAt,
        email,
        name,
        phoneNumber,
        city,
        location,
        userType,
      ];

  // Create an empty user
  factory UserModel.empty() => UserModel(
        id: '',
        createdAt: DateTime.now(),
        email: '',
      );

  // Create from JSON (from Supabase)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      email: json['email'] as String,
      name: json['name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      city: json['city'] as String?,
      location: json['location'] as String?,
      userType: json['user_type'] as String?,
    );
  }

  // Convert to JSON (for Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
      'city': city,
      'location': location,
      'user_type': userType,
    };
  }

  // Create user from auth user data
  factory UserModel.fromAuthUser(User authUser) {
    return UserModel(
      id: authUser.id,
      createdAt: DateTime.now(),
      email: authUser.email ?? '',
    );
  }

  // Copy with method to create a new instance with some changes
  UserModel copyWith({
    String? id,
    DateTime? createdAt,
    String? email,
    String? name,
    String? phoneNumber,
    String? city,
    String? location,
    String? userType,
  }) {
    return UserModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      city: city ?? this.city,
      location: location ?? this.location,
      userType: userType ?? this.userType,
    );
  }
} 
import 'package:meals_app/features/profile/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// UserForm represents a form for user data entry
/// Used for easily creating or updating UserModel objects
class UserForm {
  final String? name;
  final String? phoneNumber;
  final String? city;
  final String? location;
  final String? userType;
  final bool isProfileCompleted;

  const UserForm({
    this.name,
    this.phoneNumber,
    this.city,
    this.location,
    this.isProfileCompleted = false,
    this.userType = 'user',
  });

  /// Convert this form to a complete UserModel using auth data
  UserModel toUserModel(User authUser) {
    return UserModel(
      id: authUser.id,
      createdAt: DateTime.now(),
      email: authUser.email ?? '',
      name: name,
      phoneNumber: phoneNumber,
      city: city,
      location: location,
      isProfileCompleted: isProfileCompleted,
      userType: userType ?? 'user',
    );
  }

  /// Convert this form to JSON for direct use with Supabase
  Map<String, dynamic> toJson(User authUser) {
    return {
      'id': authUser.id,
      'created_at': DateTime.now().toIso8601String(),
      'email': authUser.email ?? '',
      'name': name,
      'phone_number': phoneNumber,
      'city': city,
      'location': location,
      'is_profile_completed': isProfileCompleted,
      'user_type': userType ?? 'user',
    };
  }

  /// Create an empty form
  factory UserForm.empty() => const UserForm();

  /// Create a form from existing UserModel
  factory UserForm.fromUserModel(UserModel user) {
    return UserForm(
      name: user.name,
      phoneNumber: user.phoneNumber,
      city: user.city,
      location: user.location,
      isProfileCompleted: user.isProfileCompleted,
      userType: user.userType ?? 'user',
    );
  }

  /// Create a copy with some fields changed
  UserForm copyWith({
    String? name,
    String? phoneNumber,
    String? city,
    String? location,
    String? userType,
    bool? isProfileCompleted,
  }) {
    return UserForm(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      city: city ?? this.city,
      location: location ?? this.location,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      userType: userType ?? this.userType,
    );
  }
} 
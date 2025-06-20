import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class AddressModel extends Equatable {
  final String id;
  final String userId;
  final String city;
  final String area;
  final String address;
  final String? location; // Format: "latitude,longitude"
  final bool isPrimary;
  final DateTime createdAt;

  const AddressModel({
    required this.id,
    required this.userId,
    required this.city,
    required this.area,
    required this.address,
    this.location,
    required this.isPrimary,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        city,
        area,
        address,
        location,
        isPrimary,
        createdAt,
      ];

  // Create a model from JSON (from Supabase)
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      city: json['city'] as String,
      area: json['area'] as String,
      address: json['address'] as String,
      location: json['location'] as String?,
      isPrimary: json['is_primary'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Convert to JSON (for Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'city': city,
      'area': area,
      'address': address,
      'location': location,
      'is_primary': isPrimary,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create a new address with auto-generated ID
  factory AddressModel.create({
    required String userId,
    required String city,
    required String area,
    required String address,
    String? location,
    bool isPrimary = false,
  }) {
    return AddressModel(
      id: const Uuid().v4(),
      userId: userId,
      city: city,
      area: area,
      address: address,
      location: location,
      isPrimary: isPrimary,
      createdAt: DateTime.now(),
    );
  }

  // Create a copy with some fields changed
  AddressModel copyWith({
    String? id,
    String? userId,
    String? city,
    String? area,
    String? address,
    String? location,
    bool? isPrimary,
    DateTime? createdAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      city: city ?? this.city,
      area: area ?? this.area,
      address: address ?? this.address,
      location: location ?? this.location,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 
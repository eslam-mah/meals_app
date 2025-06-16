import 'package:equatable/equatable.dart';

/// Represents a food item as stored in the database
class FoodModel extends Equatable {
  final String id;
  final DateTime createdAt;
  final String nameEn;
  final String nameAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final double price;
  final String? mealType;
  final String? photoUrl;
  final List<FoodSize> sizes;
  final List<FoodExtra> extras;
  final List<FoodBeverage> beverages;

  const FoodModel({
    required this.id,
    required this.createdAt,
    required this.nameEn,
    required this.nameAr,
    this.descriptionEn,
    this.descriptionAr,
    required this.price,
    this.mealType,
    this.photoUrl,
    this.sizes = const [],
    this.extras = const [],
    this.beverages = const [],
  });

  @override
  List<Object?> get props => [
        id,
        createdAt,
        nameEn,
        nameAr,
        descriptionEn,
        descriptionAr,
        price,
        mealType,
        photoUrl,
        sizes,
        extras,
        beverages,
      ];

  /// Create an empty food model
  factory FoodModel.empty() => FoodModel(
        id: '',
        createdAt: DateTime.now(),
        nameEn: '',
        nameAr: '',
        price: 0.0,
      );

  /// Create from JSON (from Supabase)
  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String,
      descriptionEn: json['description_en'] as String?,
      descriptionAr: json['description_ar'] as String?,
      price: (json['price'] as num).toDouble(),
      mealType: json['meal_type'] as String?,
      photoUrl: json['food_picture'] as String?,
      sizes: _parseSizes(json['sizes']),
      extras: _parseExtras(json['extras']),
      beverages: _parseBeverages(json['beverages']),
    );
  }

  /// Convert to JSON (for Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'name_en': nameEn,
      'name_ar': nameAr,
      'description_en': descriptionEn,
      'description_ar': descriptionAr,
      'price': price,
      'meal_type': mealType,
      'food_picture': photoUrl,
      'sizes': sizes.map((size) => size.toJson()).toList(),
      'extras': extras.map((extra) => extra.toJson()).toList(),
      'beverages': beverages.map((beverage) => beverage.toJson()).toList(),
    };
  }

  /// Parse sizes from JSON array
  static List<FoodSize> _parseSizes(dynamic sizesJson) {
    if (sizesJson == null) return [];
    
    final List<dynamic> sizesList = sizesJson is List ? sizesJson : [];
    return sizesList
        .map((sizeJson) => FoodSize.fromJson(sizeJson))
        .toList();
  }

  /// Parse extras from JSON array
  static List<FoodExtra> _parseExtras(dynamic extrasJson) {
    if (extrasJson == null) return [];
    
    final List<dynamic> extrasList = extrasJson is List ? extrasJson : [];
    return extrasList
        .map((extraJson) => FoodExtra.fromJson(extraJson))
        .toList();
  }

  /// Parse beverages from JSON array
  static List<FoodBeverage> _parseBeverages(dynamic beveragesJson) {
    if (beveragesJson == null) return [];
    
    final List<dynamic> beveragesList = beveragesJson is List ? beveragesJson : [];
    return beveragesList
        .map((beverageJson) => FoodBeverage.fromJson(beverageJson))
        .toList();
  }
}

/// Represents a size option for a food item
class FoodSize extends Equatable {
  final String nameEn;
  final String nameAr;
  final double price;

  const FoodSize({
    required this.nameEn,
    required this.nameAr,
    required this.price,
  });

  @override
  List<Object> get props => [nameEn, nameAr, price];

  factory FoodSize.fromJson(Map<String, dynamic> json) {
    return FoodSize(
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name_en': nameEn,
      'name_ar': nameAr,
      'price': price,
    };
  }
}

/// Represents an extra option for a food item
class FoodExtra extends Equatable {
  final String nameEn;
  final String nameAr;
  final double price;

  const FoodExtra({
    required this.nameEn,
    required this.nameAr,
    required this.price,
  });

  @override
  List<Object> get props => [nameEn, nameAr, price];

  factory FoodExtra.fromJson(Map<String, dynamic> json) {
    return FoodExtra(
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name_en': nameEn,
      'name_ar': nameAr,
      'price': price,
    };
  }
}

/// Represents a beverage option for a food item
class FoodBeverage extends Equatable {
  final String nameEn;
  final String nameAr;
  final double price;

  const FoodBeverage({
    required this.nameEn,
    required this.nameAr,
    required this.price,
  });

  @override
  List<Object> get props => [nameEn, nameAr, price];

  factory FoodBeverage.fromJson(Map<String, dynamic> json) {
    return FoodBeverage(
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name_en': nameEn,
      'name_ar': nameAr,
      'price': price,
    };
  }
} 
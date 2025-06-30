import 'package:equatable/equatable.dart';
import 'package:meals_app/features/cart/data/models/cart_model.dart';
import 'package:uuid/uuid.dart';

/// Represents an order item stored in the database
class OrderItemModel extends Equatable {
  final String id;
  final String orderId;
  final String menuItemId;
  final int quantity;
  final Map<String, dynamic> customization;
  final double price;
  final DateTime createdAt;
  final Map<String, dynamic>? menuItemDetails;

  const OrderItemModel({
    required this.id,
    required this.orderId,
    required this.menuItemId,
    required this.quantity,
    required this.customization,
    required this.price,
    required this.createdAt,
    this.menuItemDetails,
  });

  @override
  List<Object?> get props => [
        id,
        orderId,
        menuItemId,
        quantity,
        customization,
        price,
        createdAt,
        menuItemDetails,
      ];

  /// Create a copy of this OrderItemModel with the given fields replaced
  OrderItemModel copyWith({
    String? id,
    String? orderId,
    String? menuItemId,
    int? quantity,
    Map<String, dynamic>? customization,
    double? price,
    DateTime? createdAt,
    Map<String, dynamic>? menuItemDetails,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      menuItemId: menuItemId ?? this.menuItemId,
      quantity: quantity ?? this.quantity,
      customization: customization ?? this.customization,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      menuItemDetails: menuItemDetails ?? this.menuItemDetails,
    );
  }

  /// Create from a CartItem with order ID
  factory OrderItemModel.fromCartItem({
    required CartItem cartItem,
    required String orderId,
  }) {
    // Create customization JSON for Supabase
    final Map<String, dynamic> customization = {
      'size': cartItem.selectedSize?.toJson(),
      'extras': cartItem.selectedExtras.map((e) => e.toJson()).toList(),
      'beverage': cartItem.selectedBeverage.map((e) => e.toJson()).toList(),
      'specialInstructions': cartItem.specialInstructions,
    };

    return OrderItemModel(
      id: const Uuid().v4(),
      orderId: orderId,
      menuItemId: cartItem.menuItemId,
      quantity: cartItem.quantity,
      customization: customization,
      price: cartItem.price, // Price per item, without quantity
      createdAt: DateTime.now(),
    );
  }

  /// Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'menu_item_id': menuItemId,
      'quantity': quantity,
      'customization': customization,
      'price': price,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON from Supabase
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      menuItemId: json['menu_item_id'] as String,
      quantity: json['quantity'] as int,
      customization: json['customization'] as Map<String, dynamic>,
      price: (json['price'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
} 
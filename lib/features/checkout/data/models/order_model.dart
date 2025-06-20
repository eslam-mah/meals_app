import 'package:equatable/equatable.dart';
import 'package:meals_app/features/cart/data/models/cart_model.dart';
import 'package:meals_app/features/saved_addresses/data/models/address_model.dart';
import 'package:uuid/uuid.dart';

class OrderModel extends Equatable {
  final String id;
  final String userId;
  final String? addressId;
  final String? branchName;
  final String orderType;
  final String paymentMethod;
  final String status;
  final double totalPrice;
  final String? promoCodeId;
  final double discountAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? specialRequest;

  const OrderModel({
    required this.id,
    required this.userId,
    this.addressId,
    this.branchName,
    required this.orderType,
    required this.paymentMethod,
    required this.status,
    required this.totalPrice,
    this.promoCodeId,
    this.discountAmount = 0.0,
    required this.createdAt,
    required this.updatedAt,
    this.specialRequest,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        addressId,
        branchName,
        orderType,
        paymentMethod,
        status,
        totalPrice,
        promoCodeId,
        discountAmount,
        createdAt,
        updatedAt,
        specialRequest,
      ];

  // Create a new order with auto-generated ID
  factory OrderModel.create({
    required String userId,
    String? addressId,
    String? branchName,
    required String orderType,
    required String paymentMethod,
    required double totalPrice,
    String? promoCodeId,
    double discountAmount = 0.0,
    String status = 'pending',
    String? specialRequest,
  }) {
    final now = DateTime.now();
    return OrderModel(
      id: const Uuid().v4(),
      userId: userId,
      addressId: addressId,
      branchName: branchName,
      orderType: orderType,
      paymentMethod: paymentMethod,
      status: status,
      totalPrice: totalPrice,
      promoCodeId: promoCodeId,
      discountAmount: discountAmount,
      createdAt: now,
      updatedAt: now,
      specialRequest: specialRequest,
    );
  }

  // Create an order from the current cart
  factory OrderModel.fromCart({
    required String userId,
    required Cart cart,
    required String paymentMethod,
    required String orderType,
    String? addressId,
    String? branchName,
    String? promoCodeId,
    double discountAmount = 0.0,
  }) {
    // Calculate total price (cart total + delivery fees if applicable - discount)
    double totalPrice = cart.finalTotal;
    if (orderType == 'delivery') {
      // Add delivery fee (50 EGP)
      totalPrice += 50.0;
    }
    
    // Apply discount
    totalPrice -= discountAmount;
    
    // Ensure total price is not negative
    if (totalPrice < 0) totalPrice = 0;
    
    final now = DateTime.now();
    return OrderModel(
      id: const Uuid().v4(),
      userId: userId,
      addressId: orderType == 'delivery' ? addressId : null,
      branchName: orderType == 'pickup' ? branchName : null,
      orderType: orderType,
      paymentMethod: paymentMethod,
      status: 'pending',
      totalPrice: totalPrice,
      promoCodeId: promoCodeId,
      discountAmount: discountAmount,
      createdAt: now,
      updatedAt: now,
      specialRequest: cart.specialInstructions,
    );
  }

  // Create from JSON (from Supabase)
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      addressId: json['address_id'] as String?,
      branchName: json['branch_name'] as String?,
      orderType: json['order_type'] as String,
      paymentMethod: json['payment_method'] as String,
      status: json['status'] as String,
      totalPrice: (json['total_price'] as num).toDouble(),
      promoCodeId: json['promo_code_id'] as String?,
      discountAmount: json['discount_amount'] != null 
          ? (json['discount_amount'] as num).toDouble() 
          : 0.0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      specialRequest: json['special_request'] as String?,
    );
  }

  // Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'address_id': addressId,
      'branch_name': branchName,
      'order_type': orderType,
      'payment_method': paymentMethod,
      'status': status,
      'total_price': totalPrice,
      'promo_code_id': promoCodeId,
      'discount_amount': discountAmount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'special_request': specialRequest,
    };
  }

  // Create a copy with some fields changed
  OrderModel copyWith({
    String? id,
    String? userId,
    String? addressId,
    String? branchName,
    String? orderType,
    String? paymentMethod,
    String? status,
    double? totalPrice,
    String? promoCodeId,
    double? discountAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? specialRequest,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      addressId: addressId ?? this.addressId,
      branchName: branchName ?? this.branchName,
      orderType: orderType ?? this.orderType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      promoCodeId: promoCodeId ?? this.promoCodeId,
      discountAmount: discountAmount ?? this.discountAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      specialRequest: specialRequest ?? this.specialRequest,
    );
  }
} 
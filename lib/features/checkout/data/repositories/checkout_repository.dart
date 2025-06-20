import 'package:logging/logging.dart';
import 'package:meals_app/features/cart/data/models/cart_model.dart';
import 'package:meals_app/features/cart/data/repositories/cart_repository.dart';
import 'package:meals_app/features/checkout/data/models/order_model.dart';
import 'package:meals_app/features/checkout/data/repositories/promo_code_repository.dart';
import 'package:meals_app/features/checkout/data/repositories/promo_code_usage_repository.dart';
import 'package:meals_app/features/profile/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CheckoutRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final CartRepository _cartRepository = CartRepository();
  final PromoCodeRepository _promoCodeRepository = PromoCodeRepository();
  final PromoCodeUsageRepository _promoCodeUsageRepository = PromoCodeUsageRepository();
  final Logger _log = Logger('CheckoutRepository');
  
  static const String _ordersTable = 'orders';
  static const String _orderItemsTable = 'order_items';
  
  // Create a new order from the cart
  Future<OrderModel?> createOrder({
    required Cart cart,
    required UserModel user,
    required String paymentMethod,
    required String orderType,
    String? addressId,
    String? branchName,
    String? promoCodeId,
    double discountAmount = 0.0,
  }) async {
    try {
      _log.info('Creating new order for user: ${user.id}');
      _log.info('Order type: $orderType');
      _log.info('Payment method: $paymentMethod');
      _log.info('Applied promo code ID: $promoCodeId');
      _log.info('Discount amount: $discountAmount');
      _log.info('Special request: ${cart.specialInstructions}');
      
      // Check if promo code is valid and can be used by this user
      if (promoCodeId != null) {
        // Check if the user has already used this promo code
        final hasUsed = await _promoCodeUsageRepository.hasUserUsedPromoCode(user.id, promoCodeId);
        if (hasUsed) {
          _log.warning('User ${user.id} has already used promo code $promoCodeId. Order creation aborted.');
          return null; // Abort order creation if promo code was already used
        }
      }
      
      // Generate a UUID for the order
      final orderId = const Uuid().v4();
      final now = DateTime.now();
      
      // Calculate total price manually
      double totalPrice = cart.finalTotal;
      if (orderType == 'delivery') {
        totalPrice += 50.0; // Add delivery fee
      }
      totalPrice -= discountAmount; // Subtract discount
      
      // Create the order JSON directly
      final Map<String, dynamic> orderJson = {
        'id': orderId,
        'user_id': user.id,
        'address_id': orderType == 'delivery' ? addressId : null,
        'branch_name': orderType == 'pickup' ? branchName : null,
        'order_type': orderType,
        'payment_method': paymentMethod,
        'status': 'pending',
        'total_price': totalPrice,
        'promo_code_id': promoCodeId,
        'discount_amount': discountAmount,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
        'special_request': cart.specialInstructions,
      };
      
      _log.info('Order JSON: $orderJson');
      
      // Insert order into database using direct query to ensure all fields are included
      final result = await _supabase.from(_ordersTable).insert(orderJson).select();
      _log.info('Order insert result: $result');
      _log.info('Order created with ID: $orderId, total price: $totalPrice, promo code ID: $promoCodeId, discount: $discountAmount');
      
      // Insert order items
      for (final item in cart.items) {
        await _supabase.from(_orderItemsTable).insert({
          'id': const Uuid().v4(),
          'order_id': orderId,
          'menu_item_id': item.menuItemId,
          'quantity': item.quantity,
          'price_snapshot': (item.totalPrice * 100).toInt(),
          'customizations': {
            'size': item.selectedSize?.toJson(),
            'extras': item.selectedExtras.map((e) => e.toJson()).toList(),
            'beverage': item.selectedBeverage?.toJson(),
            'specialInstructions': item.specialInstructions,
          },
        });
      }
      
      _log.info('Order items inserted successfully');
      
      // Record promo code usage if one was applied
      if (promoCodeId != null) {
        await _promoCodeUsageRepository.recordPromoCodeUsage(user.id, promoCodeId);
        await _promoCodeRepository.applyPromoCode(promoCodeId);
        _log.info('Promo code usage recorded for user ${user.id}, promo code $promoCodeId');
      }
      
      // Clear cart after successful order
      await _cartRepository.clearCart(user: user);
      
      // Create and return the order model
      return OrderModel(
        id: orderId,
        userId: user.id,
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
    } catch (e) {
      _log.severe('Error creating order: $e');
      return null;
    }
  }
  
  // Get order by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      _log.info('Fetching order: $orderId');
      
      final response = await _supabase
          .from(_ordersTable)
          .select()
          .eq('id', orderId)
          .single();
      
      return OrderModel.fromJson(response);
    } catch (e) {
      _log.warning('Error fetching order: $e');
      return null;
    }
  }
  
  // Get all orders for a user
  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      _log.info('Fetching orders for user: $userId');
      
      final response = await _supabase
          .from(_ordersTable)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      return response.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      _log.warning('Error fetching user orders: $e');
      return [];
    }
  }
  
  // Cancel an order
  Future<bool> cancelOrder(String orderId) async {
    try {
      _log.info('Cancelling order: $orderId');
      
      // Update order status to 'cancelled'
      await _supabase
          .from(_ordersTable)
          .update({
            'status': 'cancelled',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId);
      
      _log.info('Order cancelled successfully');
      return true;
    } catch (e) {
      _log.severe('Error cancelling order: $e');
      return false;
    }
  }
} 
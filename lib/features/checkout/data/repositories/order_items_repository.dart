import 'package:logging/logging.dart';
import 'package:meals_app/features/cart/data/models/cart_model.dart';
import 'package:meals_app/features/checkout/data/models/order_item_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository for managing order items
class OrderItemsRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Logger _log = Logger('OrderItemsRepository');
  
  static const String _orderItemsTable = 'order_items';
  
  /// Create order items from cart items
  Future<List<OrderItemModel>> createOrderItems({
    required String orderId,
    required List<CartItem> cartItems,
  }) async {
    try {
      _log.info('Creating ${cartItems.length} order items for order: $orderId');
      
      final List<OrderItemModel> orderItems = cartItems.map((cartItem) => 
        OrderItemModel.fromCartItem(
          cartItem: cartItem,
          orderId: orderId,
        )
      ).toList();
      
      final List<Map<String, dynamic>> orderItemsJson = 
          orderItems.map((item) => item.toJson()).toList();
      
      _log.info('Inserting ${orderItemsJson.length} items into order_items table');
      
      await _supabase
          .from(_orderItemsTable)
          .insert(orderItemsJson);
      
      _log.info('Successfully inserted order items');
      return orderItems;
    } catch (e) {
      _log.severe('Error creating order items: $e');
      rethrow;
    }
  }
  
  /// Get order items for an order
  Future<List<OrderItemModel>> getOrderItems(String orderId) async {
    try {
      _log.info('Fetching order items for order: $orderId');
      
      final response = await _supabase
          .from(_orderItemsTable)
          .select()
          .eq('order_id', orderId);
      
      final items = response
          .map((json) => OrderItemModel.fromJson(json))
          .toList();
      
      _log.info('Fetched ${items.length} order items');
      return items;
    } catch (e) {
      _log.warning('Error fetching order items: $e');
      return [];
    }
  }
} 
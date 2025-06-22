import 'package:logging/logging.dart';
import 'package:meals_app/features/checkout/data/models/order_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderHistoryRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Logger _log = Logger('OrderHistoryRepository');
  
  static const String _ordersTable = 'orders';
  static const int _pageSize = 10;
  
  // Get paginated orders for a user with offset-based pagination
  Future<List<OrderModel>> getUserOrdersPaginated(
    String userId, {
    int page = 0,
    int limit = _pageSize,
  }) async {
    try {
      final int offset = page * limit;
      _log.info('Fetching paginated orders for user: $userId, page: $page, limit: $limit, offset: $offset');
      
      final response = await _supabase
          .from(_ordersTable)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);
      
      _log.info('Fetched ${response.length} orders');
      
      return response.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      _log.warning('Error fetching user orders: $e');
      return [];
    }
  }
  
  // Get all orders for a user
  Future<List<OrderModel>> getAllUserOrders(String userId) async {
    try {
      _log.info('Fetching all orders for user: $userId');
      
      final response = await _supabase
          .from(_ordersTable)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      return response.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      _log.warning('Error fetching all user orders: $e');
      return [];
    }
  }
  
  // Get single order by ID
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
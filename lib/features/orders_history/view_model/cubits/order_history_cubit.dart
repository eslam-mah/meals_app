import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/features/checkout/data/models/order_item_model.dart';
import 'package:meals_app/features/orders_history/data/repositories/order_history_repository.dart';
import 'package:meals_app/features/orders_history/view_model/cubits/order_history_state.dart';
import 'package:meals_app/features/profile/data/models/user_model.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  final OrderHistoryRepository _orderHistoryRepository;
  final Logger _log = Logger('OrderHistoryCubit');
  
  OrderHistoryCubit({
    required OrderHistoryRepository orderHistoryRepository,
  }) : _orderHistoryRepository = orderHistoryRepository,
       super(const OrderHistoryState());
  
  // Load initial orders
  Future<void> loadOrders() async {
    // Don't reload if already loaded and has data, unless forced
    if (state.status == OrderHistoryStatus.loaded && state.orders.isNotEmpty) {
      return;
    }
    
    emit(state.copyWith(status: OrderHistoryStatus.loading));
    
    try {
      final userId = await _getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      _log.info('Loading orders for user: $userId');
      final orders = await _orderHistoryRepository.getUserOrdersPaginated(userId);
      
      _log.info('Loaded ${orders.length} orders');
      
      final hasReachedMax = orders.length < 10; // If less than page size, we've reached the end
      
      emit(OrderHistoryState(
        status: OrderHistoryStatus.loaded,
        orders: orders,
        hasReachedMax: hasReachedMax,
        currentPage: 1, // First page loaded
        orderItems: state.orderItems,
      ));
    } catch (e) {
      _log.severe('Failed to load orders: $e');
      emit(state.copyWith(
        status: OrderHistoryStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
  
  // Load more orders (pagination)
  Future<void> loadMoreOrders() async {
    if (state.hasReachedMax || state.status == OrderHistoryStatus.loadingMore) {
      return;
    }
    
    emit(state.copyWith(status: OrderHistoryStatus.loadingMore));
    
    try {
      final userId = await _getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      _log.info('Loading more orders for user: $userId, page: ${state.currentPage}');
      final newOrders = await _orderHistoryRepository.getUserOrdersPaginated(
        userId,
        page: state.currentPage,
      );
      
      _log.info('Loaded ${newOrders.length} additional orders');
      
      // If fewer items than the page size were returned, we've reached the end
      final hasReachedMax = newOrders.length < 10;
      
      emit(state.copyWith(
        status: OrderHistoryStatus.loaded,
        orders: [...state.orders, ...newOrders],
        hasReachedMax: hasReachedMax,
        currentPage: state.currentPage + 1,
      ));
    } catch (e) {
      _log.severe('Failed to load more orders: $e');
      emit(state.copyWith(
        status: OrderHistoryStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
  
  // Load order items for a specific order
  Future<void> loadOrderItems(String orderId) async {
    // Don't reload if already loaded for this order
    if (state.orderItems.containsKey(orderId)) {
      emit(state.copyWith(
        selectedOrderId: orderId,
        status: OrderHistoryStatus.orderItemsLoaded,
      ));
      return;
    }
    
    emit(state.copyWith(
      status: OrderHistoryStatus.loadingOrderItems,
      selectedOrderId: orderId,
    ));
    
    try {
      _log.info('Loading items for order: $orderId');
      final result = await _orderHistoryRepository.getOrderWithItems(orderId);
      
      final List<OrderItemModel> items = result['items'] as List<OrderItemModel>;
      _log.info('Loaded ${items.length} items for order: $orderId');
      
      // Debug each item's menu details
      for (var item in items) {
        _log.info('Item ${item.id} - menuItemId: ${item.menuItemId}');
        _log.info('Item ${item.id} - menuItemDetails: ${item.menuItemDetails}');
        if (item.menuItemDetails != null) {
          final nameKey = Intl.getCurrentLocale() == 'ar' ? 'name_ar' : 'name_en';
          _log.info('Item ${item.id} - name from details: ${item.menuItemDetails![nameKey]}');
        }
      }
      
      final updatedOrderItems = Map<String, List<OrderItemModel>>.from(state.orderItems);
      updatedOrderItems[orderId] = items;
      
      emit(state.copyWith(
        status: OrderHistoryStatus.orderItemsLoaded,
        orderItems: updatedOrderItems,
      ));
    } catch (e) {
      _log.severe('Failed to load order items: $e');
      emit(state.copyWith(
        status: OrderHistoryStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
  
  // Cancel an order
  Future<void> cancelOrder(String orderId) async {
    emit(state.copyWith(
      status: OrderHistoryStatus.cancelingOrder,
      cancelingOrderId: orderId,
    ));
    
    try {
      _log.info('Cancelling order: $orderId');
      final success = await _orderHistoryRepository.cancelOrder(orderId);
      
      if (success) {
        _log.info('Order cancelled successfully');
        
        // Remove the cancelled order from the list
        final updatedOrders = state.orders.map((order) {
          if (order.id == orderId) {
            return order.copyWith(
              status: 'cancelled',
              updatedAt: DateTime.now(),
            );
          }
          return order;
        }).toList();
        
        emit(state.copyWith(
          status: OrderHistoryStatus.orderCanceled,
          orders: updatedOrders,
          cancelingOrderId: null,
        ));
      } else {
        throw Exception('Failed to cancel order');
      }
    } catch (e) {
      _log.severe('Failed to cancel order: $e');
      emit(state.copyWith(
        status: OrderHistoryStatus.error,
        errorMessage: e.toString(),
        cancelingOrderId: null,
      ));
    }
  }
  
  // Get order items for the currently selected order
  List<OrderItemModel> getSelectedOrderItems() {
    if (state.selectedOrderId == null) {
      return [];
    }
    return state.orderItems[state.selectedOrderId!] ?? [];
  }
  
  // Refresh orders (force reload from beginning)
  Future<void> refreshOrders() async {
    emit(OrderHistoryState(
      status: OrderHistoryStatus.loading,
      orderItems: state.orderItems,
      selectedOrderId: state.selectedOrderId,
    ));
    await loadOrders();
  }
  
  // Get current user ID
  Future<String?> _getUserId() async {
    // Try to get from UserCubit first
    final userCubit = UserCubit.instance;
    if (userCubit.hasUser) {
      return userCubit.userId;
    }
    
    // Fall back to Supabase auth
    final user = Supabase.instance.client.auth.currentUser;
    return user?.id;
  }
} 
import 'package:equatable/equatable.dart';
import 'package:meals_app/features/checkout/data/models/order_model.dart';

enum OrderHistoryStatus {
  initial,
  loading,
  loaded,
  error,
  loadingMore,
  cancelingOrder,
  orderCanceled,
}

class OrderHistoryState extends Equatable {
  final OrderHistoryStatus status;
  final List<OrderModel> orders;
  final bool hasReachedMax;
  final int currentPage;
  final String? errorMessage;
  final String? cancelingOrderId;

  const OrderHistoryState({
    this.status = OrderHistoryStatus.initial,
    this.orders = const [],
    this.hasReachedMax = false,
    this.currentPage = 0,
    this.errorMessage,
    this.cancelingOrderId,
  });

  @override
  List<Object?> get props => [
        status,
        orders,
        hasReachedMax,
        currentPage,
        errorMessage,
        cancelingOrderId,
      ];

  OrderHistoryState copyWith({
    OrderHistoryStatus? status,
    List<OrderModel>? orders,
    bool? hasReachedMax,
    int? currentPage,
    String? errorMessage,
    String? cancelingOrderId,
  }) {
    return OrderHistoryState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage,
      cancelingOrderId: cancelingOrderId,
    );
  }

  // Add a new batch of orders to the existing list
  OrderHistoryState addOrders(List<OrderModel> newOrders) {
    return copyWith(
      orders: [...orders, ...newOrders],
      hasReachedMax: newOrders.isEmpty,
      currentPage: currentPage + 1,
    );
  }
  
  // Remove an order from the list (after cancellation)
  OrderHistoryState removeOrder(String orderId) {
    return copyWith(
      orders: orders.where((order) => order.id != orderId).toList(),
    );
  }
  
  // Get a filtered list of orders by status
  List<OrderModel> getFilteredOrders(String status) {
    return orders.where((order) => order.status == status).toList();
  }
  
  // Get active orders (pending status)
  List<OrderModel> get activeOrders {
    return orders.where((order) => order.status == 'pending').toList();
  }
  
  // Get completed orders (delivered status)
  List<OrderModel> get completedOrders {
    return orders.where((order) => order.status == 'delivered').toList();
  }
  
  // Get cancelled orders
  List<OrderModel> get cancelledOrders {
    return orders.where((order) => order.status == 'cancelled').toList();
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/features/orders_history/data/repositories/order_history_repository.dart';
import 'package:meals_app/features/orders_history/view/views/orders_history_view.dart';
import 'package:meals_app/features/orders_history/view_model/cubits/order_history_cubit.dart';

/// Router configuration for the orders history feature
class OrdersHistoryRouter {
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: OrdersHistoryView.ordersHistoryPath,
      builder: (context, state) {
        return _wrapWithProviders(const OrdersHistoryView());
      },
    ),
  ];
  
  /// Wrap the orders history views with the required providers
  static Widget _wrapWithProviders(Widget child) {
    return RepositoryProvider(
      create: (context) => OrderHistoryRepository(),
      child: BlocProvider(
        create: (context) => OrderHistoryCubit(
          orderHistoryRepository: context.read<OrderHistoryRepository>(),
        ),
        child: child,
      ),
    );
  }
}

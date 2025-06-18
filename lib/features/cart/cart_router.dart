import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/features/cart/data/repositories/cart_repository.dart';
import 'package:meals_app/features/cart/view/views/cart_view.dart';
import 'package:meals_app/features/cart/view_model/cubits/cart_cubit.dart';

class CartRouter {
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: CartView.cartPath,
      builder: (context, state) => _wrapWithCartCubit(const CartView()),
    ),
  ];
  
  // Wrap the view with the CartCubit provider
  static Widget _wrapWithCartCubit(Widget child) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CartRepository>(
          create: (context) => CartRepository(),
        ),
      ],
      child: BlocProvider<CartCubit>(
        create: (context) {
          final repository = context.read<CartRepository>();
          final cubit = CartCubit(cartRepository: repository);
          CartCubit.initialize(repository);
          return cubit;
        },
        child: child,
      ),
    );
  }
}

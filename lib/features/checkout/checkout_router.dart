import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/features/cart/data/repositories/cart_repository.dart';
import 'package:meals_app/features/cart/view_model/cubits/cart_cubit.dart';
import 'package:meals_app/features/checkout/data/repositories/checkout_repository.dart';
import 'package:meals_app/features/checkout/data/repositories/promo_code_repository.dart';
import 'package:meals_app/features/checkout/data/repositories/promo_code_usage_repository.dart';
import 'package:meals_app/features/checkout/view/views/checkout_success_view.dart';
import 'package:meals_app/features/checkout/view/views/checkout_view.dart';
import 'package:meals_app/features/checkout/view_model/cubits/checkout_cubit.dart';
import 'package:meals_app/features/checkout/view_model/cubits/promo_code_cubit.dart';
import 'package:meals_app/features/saved_addresses/data/repositories/address_repository.dart';
import 'package:meals_app/features/saved_addresses/view_model/cubits/address_cubit.dart';

/// Router configuration for the checkout feature
class CheckoutRouter {
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: CheckoutView.checkoutPath,
      builder: (context, state) {
        // Get orderType from query parameters or default to 'delivery'
        final orderType = state.uri.queryParameters['orderType'] ?? 'delivery';
        return _wrapWithProviders(CheckoutView(orderType: orderType));
      },
    ),
    GoRoute(
      path: CheckoutSuccessView.successPath,
      builder: (context, state) {
        // Get orderId from query parameters
        final orderId = state.uri.queryParameters['orderId'];
        return _wrapWithProviders(CheckoutSuccessView(orderId: orderId));
      },
    ),
  ];
  
  /// Wrap the checkout views with the required providers
  static Widget _wrapWithProviders(Widget child) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => CheckoutRepository(),
        ),
        RepositoryProvider(
          create: (context) => PromoCodeRepository(),
        ),
        RepositoryProvider(
          create: (context) => PromoCodeUsageRepository(),
        ),
        RepositoryProvider(
          create: (context) => CartRepository(),
        ),
        RepositoryProvider(
          create: (context) => AddressRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CheckoutCubit(
              checkoutRepository: context.read<CheckoutRepository>(),
              promoCodeRepository: context.read<PromoCodeRepository>(),
              promoCodeUsageRepository: context.read<PromoCodeUsageRepository>(),
            ),
          ),
          // Add the PromoCodeCubit for managing promo codes with dynamic percentages
          BlocProvider(
            create: (context) => PromoCodeCubit(
              promoCodeRepository: context.read<PromoCodeRepository>(),
              promoCodeUsageRepository: context.read<PromoCodeUsageRepository>(),
            ),
          ),
          // Add the CartCubit for managing items in checkout
          BlocProvider(
            create: (context) => CartCubit(
              cartRepository: context.read<CartRepository>(),
            ),
          ),
          // Add the address cubit for delivery address selection
          BlocProvider(
            create: (context) => AddressCubit(
              addressRepository: context.read<AddressRepository>(),
            )..loadUserAddresses(),
          ),
        ],
        child: child,
      ),
    );
  }
}


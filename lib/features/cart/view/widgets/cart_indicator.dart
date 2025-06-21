import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/features/cart/view/views/cart_view.dart';
import 'package:meals_app/features/cart/view_model/cubits/cart_cubit.dart';
import 'package:meals_app/features/cart/view_model/cubits/cart_state.dart';
import 'package:meals_app/generated/l10n.dart';

class CartIndicator extends StatefulWidget {
  const CartIndicator({super.key});

  @override
  State<CartIndicator> createState() => _CartIndicatorState();
}

class _CartIndicatorState extends State<CartIndicator> {
  final Logger _log = Logger('CartIndicator');
  
  @override
  void initState() {
    super.initState();
    // Ensure the cart is loaded
    Future.microtask(() {
      if (mounted) {
        context.read<CartCubit>().refreshCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
     final StorageService storageService = StorageService();
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        // Don't show if cart is empty
        if (state.cart.isEmpty || storageService.isAuthenticated() == false) {
          _log.info('Cart is empty, hiding indicator');
          return const SizedBox.shrink();
        }
        
        _log.info('Showing cart indicator with ${state.cart.itemCount} items');
        
        return GestureDetector(
          onTap: () { GoRouter.of(context)
      .push(CartView.cartPath)
      .then((_) {
        // ← when you come back from the cart screen
        context.read<CartCubit>().refreshCart();
      });},
          child: Container(
            margin: EdgeInsets.all(16.r),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: ColorsBox.primaryColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cart info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${state.cart.itemCount} ${state.cart.itemCount == 1 ? l10n.item : l10n.items}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'EGP ${state.cart.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                // View cart button
                Row(
                  children: [
                    Text(
                      l10n.viewCart,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 
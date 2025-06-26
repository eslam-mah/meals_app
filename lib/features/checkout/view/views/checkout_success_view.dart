import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/features/cart/data/repositories/cart_repository.dart';
import 'package:meals_app/features/cart/view_model/cubits/cart_cubit.dart';
import 'package:meals_app/features/home/view/views/main_view.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/generated/l10n.dart';

class CheckoutSuccessView extends StatefulWidget {
  static const String successPath = '/checkout/success';
  final String? orderId;

  const CheckoutSuccessView({super.key, this.orderId});

  @override
  State<CheckoutSuccessView> createState() => _CheckoutSuccessViewState();
}

class _CheckoutSuccessViewState extends State<CheckoutSuccessView> {
  final Logger _log = Logger('CheckoutSuccessView');

  @override
  void initState() {
    super.initState();
    // Clear the cart directly using the repository
    _clearCart();
  }

  Future<void> _clearCart() async {
    _log.info('Clearing cart from checkout success view');
    try {
      // Create a new repository instance
      final cartRepository = CartRepository();

      // Get the current user if available
      final user = UserCubit.instance.state.user;

      // Clear the cart using the repository directly
      await cartRepository.clearCart(user: user);

      // Reinitialize the CartCubit with the fresh repository
      CartCubit.initialize(cartRepository);

      _log.info('Cart cleared successfully from checkout success view');
    } catch (e) {
      _log.warning('Failed to clear cart from checkout success view: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        _navigateToHome(context);
        _clearCart();

      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success icon
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: ColorsBox.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 80.r,
                    color: ColorsBox.primaryColor,
                  ),
                ),

                SizedBox(height: 32.h),

                // Success message
                Text(
                  localization.orderPlacedSuccessfully,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 16.h),

                // Order ID
                if (widget.orderId != null) ...[
                  Text(
                    '${localization.orderID}: ${widget.orderId}',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                ],

                // Thank you message
                Text(
                  localization.thankYouForYourOrder,
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8.h),

                // Order tracking message
                Text(
                  localization.youCanTrackOrderStatus,
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 48.h),

                // Continue shopping button
                CustomButton(
                  title: localization.continueShopping,
                  onTap: () => _navigateToHome(context),
                  color: ColorsBox.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    // Navigate to main view and clear the navigation stack
    GoRouter.of(context).push(MainView.mainPath);
  }
}

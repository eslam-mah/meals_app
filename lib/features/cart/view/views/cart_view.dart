import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/core/services/connectivity_service.dart';
import 'package:meals_app/core/main_widgets/connectivity_dialog.dart';
import 'package:meals_app/features/cart/data/models/cart_model.dart';
import 'package:meals_app/features/cart/view/widgets/cart_item.dart';
import 'package:meals_app/features/cart/view_model/cubits/cart_cubit.dart';
import 'package:meals_app/features/cart/view_model/cubits/cart_state.dart';
import 'package:meals_app/features/home/view/views/main_view.dart';
import 'package:meals_app/generated/l10n.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';

class CartView extends StatefulWidget {
  static const String cartPath = '/cart';

  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final TextEditingController _specialInstructionsController = TextEditingController();
  // final Logger _log = Logger('CartView');
  // bool _isConnected = true;
  // bool _isDialogShowing = false;
  // StreamSubscription<bool>? _connectivitySubscription;
  // final ConnectivityService _connectivityService = ConnectivityService.instance;

  // Local cart for instant feedback
  List<CartItem>? _localCartItems;

  @override
  void initState() {
    super.initState();
    // _initConnectivity();
    _loadCart();
  }

  @override
  void dispose() {
    // _connectivitySubscription?.cancel();
    // _connectivitySubscription = null;
    _specialInstructionsController.dispose();
    super.dispose();
  }

  // /// Initialize connectivity monitoring
  // Future<void> _initConnectivity() async {
  //   if (!mounted) return;
    
  //   _log.info('Initializing connectivity monitoring');
    
  //   // Check initial connectivity status
  //   _isConnected = await _connectivityService.forceCheck();
  //   _log.info('Initial connectivity status: ${_isConnected ? "Connected" : "Disconnected"}');
    
  //   // If initially disconnected, show dialog
  //   if (!_isConnected && mounted && !_isDialogShowing) {
  //     _log.info('Initially disconnected, showing dialog');
  //     _showConnectivityDialog();
  //   }
    
  //   // Listen for connectivity changes
  //   _connectivitySubscription = _connectivityService.onConnectivityChanged.listen(_handleConnectivityChange);
  //   _log.info('Connectivity listener set up');
  // }
  
  // /// Handle changes in connectivity status
  // void _handleConnectivityChange(bool isConnected) {
  //   _log.info('Connectivity changed: ${isConnected ? "Connected" : "Disconnected"}');
    
  //   if (!mounted) {
  //     _log.warning('Widget not mounted during connectivity change');
  //     return;
  //   }
    
  //   // Only show dialog if we transition from connected to disconnected
  //   if (_isConnected && !isConnected && !_isDialogShowing) {
  //     _log.info('Connection lost, showing dialog immediately');
  //     _showConnectivityDialog();
  //   }
    
  //   setState(() {
  //     _isConnected = isConnected;
  //   });
  // }
  
  // /// Show connectivity dialog when connection is lost
  // void _showConnectivityDialog() {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         snackBarAnimationStyle:  AnimationStyle(curve: ElasticInCurve()),
  //             SnackBar(
                
  //               content: Text(S.of(context).noInternetConnection),
  //               backgroundColor: Colors.red,
  //             ),
  //           );
  // }

  void _loadCart() {
    // if (!_isConnected) return;
    context.read<CartCubit>().refreshCart();
  }

  void _syncLocalCartItems(List<CartItem> items) {
    // Initialize or sync local copy
    if (_localCartItems == null || _localCartItems!.length != items.length) {
      _localCartItems = items.map((e) => e.copyWith()).toList();
    } else {
      for (var i = 0; i < items.length; i++) {
        _localCartItems![i] = items[i];
      }
    }
  }

  // Handle navigation when back button is pressed
  void _handlePopInvoked(bool didPop) {
    if (didPop) return;
    context.read<CartCubit>().loadCart();
    GoRouter.of(context).push(MainView.mainPath);
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return BlocConsumer<CartCubit, CartState>(
      listenWhen: (prev, curr) => prev.cart.items != curr.cart.items,
      listener: (context, state) {
        // Always sync local copy after backend changes
        _syncLocalCartItems(state.cart.items);
        setState(() {});
      },
      builder: (context, state) {
        // Always initialize local items if needed (fixes null error)
        _localCartItems ??= state.cart.items.map((e) => e.copyWith()).toList();
        final cartItems = _localCartItems!;

        // Show loading indicator
        if (state.status == CartStatus.loading && (state.cart.isEmpty || cartItems.isEmpty)) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) => _handlePopInvoked(didPop),
            child: Scaffold(
              appBar: _buildAppBar(context, localization, 0),
              body: _buildCartShimmer(),
            ),
          );
        }

        // Show empty cart state
        if (cartItems.isEmpty) {
          return PopScope(
            canPop: false,
            onPopInvoked: _handlePopInvoked,
            child: Scaffold(
              appBar: _buildAppBar(context, localization, 0),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 80.r, color: Colors.grey),
                    SizedBox(height: 16.h),
                    Text(localization.yourCartIsEmpty,
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.h),
                    Text(localization.addItemsToYourCart,
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () => GoRouter.of(context).push(MainView.mainPath),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsBox.primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                      ),
                      child: Text(localization.browseMenu),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Show cart with items
        final Cart localCart = state.cart.copyWith(items: cartItems);

        return PopScope(
          canPop: false,
          onPopInvoked: _handlePopInvoked,
          child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: _buildAppBar(context, localization, localCart.itemCount),
            body: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  children: [
                    ...state.cart.items.map((item) => Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: CartItemWidget(
                        item: item,
                        onIncrement: () =>  _instantIncrement(item, state.cart.items.indexOf(item)) ,
                        onDecrement: () => _instantDecrement(item, state.cart.items.indexOf(item)) ,
                        onRemove: () =>  _instantRemove(item, state.cart.items.indexOf(item)) ,
                      ),
                    )),
                    SizedBox(height: 16.h),
                    _buildDeliveryTypeSelector(context, state),
                    SizedBox(height: 24.h),
                    _buildPriceSummarySection(context, localization, localCart),
                    SizedBox(height: 16.h),
                    _buildAddMoreItemsButton(context, localization),
                    SizedBox(height: 100.h),
                  ],
                ),
              ],
            ),
            bottomSheet: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  )
                ],
              ),
              child: CustomButton(
                title: localization.checkout,
                onTap:  () => _checkout(context),
                color: ColorsBox.primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, S localization, int itemCount) {
    return AppBar(
      title: Text(
        '${localization.myCart}${itemCount > 0 ? ' ($itemCount ${itemCount == 1 ? localization.item : localization.items})' : ''}',
        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, size: 28.r),
        onPressed: () {
          context.read<CartCubit>().loadCart();
          GoRouter.of(context).push(MainView.mainPath);
        },
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    );
  }

  Widget _buildSpecialRequestsSection(BuildContext context, S localization, String? currentInstructions) {
    if (currentInstructions != null && _specialInstructionsController.text.isEmpty) {
      _specialInstructionsController.text = currentInstructions;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${localization.specialRequests} (${localization.optional})',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black)),
        SizedBox(height: 4.h),
        Text(localization.noExtrasAllowed,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TextField(
            controller: _specialInstructionsController,
            maxLines: 3,
            onChanged: (value) {
                context.read<CartCubit>().setSpecialInstructions(value);
              
            },
            decoration: InputDecoration(
              hintText: localization.typeYourSpecialRequestsHere,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(16.r),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSummarySection(BuildContext context, S localization, Cart cart) {
    return Column(
      children: [
        _buildPriceRow(
          label: localization.subTotal,
          amount: '${cart.subtotal.toStringAsFixed(2)} EGP',
          isBold: false,
        ),
        SizedBox(height: 8.h),
        _buildPriceRow(
          label: localization.vat,
          amount: '${cart.vat.toStringAsFixed(2)} EGP',
          isBold: false,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Divider(height: 1.h, color: Colors.grey.shade300),
        ),
        _buildPriceRow(
          label: localization.total,
          amount: '${cart.finalTotal.toStringAsFixed(2)} EGP',
          isBold: true,
          isLarge: true,
        ),
      ],
    );
  }

  Widget _buildPriceRow({
    required String label,
    required String amount,
    required bool isBold,
    bool isLarge = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isLarge ? 20.sp : 16.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isLarge ? 20.sp : 16.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildAddMoreItemsButton(BuildContext context, S localization) {
    return TextButton(
      onPressed: () {
        GoRouter.of(context).push(MainView.mainPath);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: ColorsBox.primaryColor, size: 20.r),
          SizedBox(width: 4.w),
          Text(localization.addMoreItems,
              style: TextStyle(
                color: ColorsBox.primaryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }

  // Cart item actions with instant UI
  void _instantIncrement(CartItem item, int index) {

    
    if (_localCartItems == null) return;
    String currentDeliveryType = context.read<CartCubit>().state.cart.deliveryType;
    setState(() {
      final updated = item.copyWith(
        quantity: item.quantity + 1,
        totalPrice: item.price * (item.quantity + 1),
      );
      _localCartItems![index] = updated;
    });
    context.read<CartCubit>().incrementItemQuantity(item.id);
    // Ensure delivery type is preserved
    Future.delayed(const Duration(milliseconds: 100), () {
      if (context.read<CartCubit>().state.cart.deliveryType != currentDeliveryType) {
        context.read<CartCubit>().setDeliveryType(currentDeliveryType);
      }
    });
  }

  void _instantDecrement(CartItem item, int index) {
  
    
    if (_localCartItems == null) return;
    String currentDeliveryType = context.read<CartCubit>().state.cart.deliveryType;

    if (item.quantity == 1) {
      // Remove the item if it's the last one
      _instantRemove(item, index);
      return;
    }

    setState(() {
      final updated = item.copyWith(
        quantity: item.quantity - 1,
        totalPrice: item.price * (item.quantity - 1),
      );
      _localCartItems![index] = updated;
    });
    context.read<CartCubit>().decrementItemQuantity(item.id);
    // Ensure delivery type is preserved
    Future.delayed(const Duration(milliseconds: 100), () {
      if (context.read<CartCubit>().state.cart.deliveryType != currentDeliveryType) {
        context.read<CartCubit>().setDeliveryType(currentDeliveryType);
      }
    });
  }

  void _instantRemove(CartItem item, int index) {
 
    
    if (_localCartItems == null) return;
    String currentDeliveryType = context.read<CartCubit>().state.cart.deliveryType;
    setState(() {
      _localCartItems!.removeAt(index);
    });
    context.read<CartCubit>().removeItem(item.id);
    // Ensure delivery type is preserved
    Future.delayed(const Duration(milliseconds: 100), () {
      if (context.mounted && _localCartItems!.isNotEmpty && 
          context.read<CartCubit>().state.cart.deliveryType != currentDeliveryType) {
        context.read<CartCubit>().setDeliveryType(currentDeliveryType);
      }
    });
  }

  Widget _buildDeliveryTypeSelector(BuildContext context, CartState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).orderType,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDeliveryTypeOption(
                  context,
                  title: S.of(context).delivery,
                  icon: Icons.delivery_dining,
                  isSelected: state.cart.deliveryType == 'delivery',
                  onTap: () {
                 
                    context.read<CartCubit>().setDeliveryType('delivery');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDeliveryTypeOption(
                  context,
                  title: S.of(context).pickup,
                  icon: Icons.store,
                  isSelected: state.cart.deliveryType == 'pickup',
                  onTap: () {
          
                    context.read<CartCubit>().setDeliveryType('pickup');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTypeOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Provide immediate visual feedback before calling the actual onTap
          if (!isSelected) {
            HapticFeedback.lightImpact();
          }
          onTap();
        },
        borderRadius: BorderRadius.circular(8),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Theme.of(context).primaryColor : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkout(BuildContext context) {

    
    // Get current cart and delivery type
    final cart = context.read<CartCubit>().state.cart;
    // Navigate to checkout screen with delivery type parameter
    GoRouter.of(context).push('/checkout?orderType=${cart.deliveryType}');
  }

  Widget _buildCartShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: List.generate(3, (index) => 
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Container(
                width: double.infinity,
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
}

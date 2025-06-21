import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/config/assets_box.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/core/services/connectivity_service.dart';
import 'package:meals_app/core/main_widgets/connectivity_dialog.dart';
import 'package:meals_app/features/cart/data/models/cart_model.dart';
import 'package:meals_app/features/cart/view_model/cubits/cart_cubit.dart';
import 'package:meals_app/features/checkout/data/models/order_model.dart';
import 'package:meals_app/features/checkout/data/repositories/promo_code_usage_repository.dart';
import 'package:meals_app/features/checkout/view/views/checkout_success_view.dart';
import 'package:meals_app/features/checkout/view/widgets/branch_selector.dart';
import 'package:meals_app/features/checkout/view/widgets/payment_method_selector.dart';
import 'package:meals_app/features/checkout/view_model/cubits/checkout_cubit.dart';
import 'package:meals_app/features/checkout/view_model/cubits/checkout_state.dart';
import 'package:meals_app/features/profile/data/models/user_model.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/features/saved_addresses/data/models/address_model.dart';
import 'package:meals_app/features/saved_addresses/view/widgets/address_selector_bottom_sheet.dart';
import 'package:meals_app/features/saved_addresses/view_model/cubits/address_cubit.dart';
import 'package:meals_app/generated/l10n.dart';
import 'package:meals_app/features/checkout/view/widgets/promo_code_field.dart';
import 'package:meals_app/features/checkout/data/repositories/checkout_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:meals_app/features/checkout/view_model/cubits/promo_code_cubit.dart';

class CheckoutView extends StatefulWidget {
  static const String checkoutPath = '/checkout';
  final String orderType;

  const CheckoutView({super.key, required this.orderType});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final Logger _log = Logger('CheckoutView');
  final TextEditingController _specialRequestController = TextEditingController();
  String? _specialRequest;
  bool _isProcessing = false;
  // bool _isConnected = true;
  // bool _isDialogShowing = false;
  // StreamSubscription<bool>? _connectivitySubscription;
  // final ConnectivityService _connectivityService = ConnectivityService.instance;
  
  @override
  void initState() {
    super.initState();
    // _initConnectivity();
    
    // Ensure we have addresses loaded if delivery is selected
    final cart = context.read<CartCubit>().state.cart;
    if (cart.deliveryType == 'delivery') {
      context.read<AddressCubit>().loadUserAddresses();
    }
    
    // Initialize special request from cart
    _specialRequest = cart.specialInstructions;
    if (_specialRequest != null) {
      _specialRequestController.text = _specialRequest!;
    }
  }
  
  @override
  void dispose() {
    // _connectivitySubscription?.cancel();
    // _connectivitySubscription = null;
    _specialRequestController.dispose();
    super.dispose();
  }

  /// Initialize connectivity monitoring
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
  //   if (!mounted || _isDialogShowing) return;
    
  //   _log.info('Showing connectivity dialog');
  //   _isDialogShowing = true;
    
  //   ConnectivityDialog.show(
  //     context,
  //     onConnected: () {
  //       _log.info('Connection restored callback from dialog');
        
  //       if (mounted) {
  //         setState(() {
  //           _isDialogShowing = false;
  //         });
          
  //         // Reload necessary data when connection is restored
  //         final cart = context.read<CartCubit>().state.cart;
  //         if (cart.deliveryType == 'delivery') {
  //           context.read<AddressCubit>().loadUserAddresses();
  //         }
  //       } else {
  //         _isDialogShowing = false;
  //       }
  //     },
  //   ).catchError((error) {
  //     _log.severe('Error showing dialog: $error');
  //     _isDialogShowing = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    
    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == CheckoutStatus.success && state.order != null) {
          // Navigate to success page
          GoRouter.of(context).go(
            "${CheckoutSuccessView.successPath}?orderId=${state.order!.id}",
          );
        } else if (state.status == CheckoutStatus.error) {
          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? localization.anErrorOccurred),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, checkoutState) {
        // Get cart from CartCubit
        final cartState = context.watch<CartCubit>().state;
        final cart = cartState.cart;
        
        // Get addresses from AddressCubit if delivery
        final addressState = context.watch<AddressCubit>().state;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(
              localization.checkout,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, size: 28.r),
              onPressed: () => context.pop(),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: checkoutState.status == CheckoutStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : _buildCheckoutContent(context, cart, checkoutState, addressState, localization, widget.orderType),
        );
      },
    );
  }

  Widget _buildCheckoutContent(
    BuildContext context,
    Cart cart,
    CheckoutState checkoutState,
    AddressState addressState,
    S localization,
    String deliveryType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order type info
                _buildOrderTypeInfo(deliveryType, localization),
                SizedBox(height: 24.h),
                
                // Order summary section
                _buildOrderSummarySection(cart, localization),
                SizedBox(height: 24.h),

                // Delivery address or Branch selection based on order type
                deliveryType == 'delivery'
                    ? _buildDeliveryAddressSection(
                        context, 
                        checkoutState.selectedAddress, 
                        addressState,
                        localization,
                      )
                    : _buildPickupBranchSection(
                        context,
                        checkoutState,
                        localization,
                      ),
                SizedBox(height: 24.h),

                // Payment method section
                _buildPaymentMethodSection(context, checkoutState.paymentMethod, localization),
                SizedBox(height: 24.h),
                
                // Special request field
                _buildSpecialRequestField(context, localization),
                SizedBox(height: 24.h),
                
                // Promo code section
                const PromoCodeField(),
                SizedBox(height: 24.h),
                
                // Price summary section
                _buildPriceSummarySection(
                  cart, 
                  deliveryType == 'delivery', // Include delivery fee if delivery
                  checkoutState,
                  localization,
                ),
              ],
            ),
          ),
        ),
        
        // Bottom place order button
        _buildPlaceOrderButton(context, cart, checkoutState, localization),
      ],
    );
  }

  Widget _buildOrderTypeInfo(String orderType, S localization) {
    final isDelivery = orderType == 'delivery';
    
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isDelivery ? Icons.delivery_dining : Icons.shopping_bag,
            color: ColorsBox.primaryColor,
            size: 32.r,
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isDelivery ? localization.delivery : localization.pickup,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                isDelivery
                    ? localization.deliveryFeeApplied
                    : localization.pickupFromBranch,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummarySection(Cart cart, S localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.orderSummary,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              ...cart.items.map((item) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  children: [
                    Text(
                      '${item.quantity}x',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorsBox.primaryColor,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '${item.totalPrice.toStringAsFixed(2)} EGP',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )),
              if (cart.specialInstructions != null && cart.specialInstructions!.isNotEmpty) ...[
                Divider(height: 24.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 20.r, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        '${localization.subTotal}: ${cart.specialInstructions}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryAddressSection(
    BuildContext context,
    AddressModel? selectedAddress,
    AddressState addressState,
    S localization,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.deliveryAddress,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        InkWell(
          onTap: () {
            _showAddressSelector(context);
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: selectedAddress != null
                    ? ColorsBox.primaryColor
                    : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: selectedAddress != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: ColorsBox.primaryColor,
                            size: 24.r,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              '${selectedAddress.city} - ${selectedAddress.area}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(Icons.edit, size: 20.r, color: Colors.grey),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.only(left: 32.w),
                        child: Text(
                          selectedAddress.address,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Icon(
                        Icons.add_location_alt_outlined,
                        color: Colors.grey,
                        size: 24.r,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        localization.selectDeliveryAddress,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (addressState.addresses.isEmpty) ...[
          SizedBox(height: 8.h),
          Text(
            localization.noSavedAddresses,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.redAccent,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  void _showAddressSelector(BuildContext context) {
 
    
    final addressCubit = context.read<AddressCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => BlocProvider.value(
        value: addressCubit,
        child: AddressSelectorBottomSheet(
          onAddressSelected: (address) {
            context.read<CheckoutCubit>().setSelectedAddress(address);
          },
        ),
      ),
    );
  }

  Widget _buildPickupBranchSection(
    BuildContext context,
    CheckoutState checkoutState,
    S localization,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.pickupBranch,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        BranchSelector(
          branches: checkoutState.availableBranches,
          selectedBranch: checkoutState.selectedBranch,
          onBranchSelected: (branch) {
          
            context.read<CheckoutCubit>().setSelectedBranch(branch);
          },
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection(
    BuildContext context,
    String selectedMethod,
    S localization,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.paymentMethod,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        PaymentMethodSelector(
          selectedMethod: selectedMethod,
          onMethodSelected: (method) {
        
            context.read<CheckoutCubit>().setPaymentMethod(method);
          },
        ),
      ],
    );
  }

  Widget _buildSpecialRequestField(BuildContext context, S localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${localization.specialRequests} (${localization.optional})',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _specialRequestController,
            maxLines: 3,
            onChanged: (value) {
              setState(() {
                _specialRequest = value.isEmpty ? null : value;
              });
              _log.info('Special request updated: $_specialRequest');
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

  Widget _buildPriceSummarySection(
    Cart cart,
    bool includeDeliveryFee,
    CheckoutState checkoutState,
    S localization,
  ) {
    // Get promo code information from PromoCodeCubit
    final promoCodeState = context.watch<PromoCodeCubit>().state;
    final hasPromoCode = promoCodeState.hasPromoCode;
    final discountPercentage = promoCodeState.discountPercentage;
    final discountAmount = promoCodeState.calculateDiscount(cart.subtotal);
    
    // Calculate delivery fee
    final deliveryFee = includeDeliveryFee ? 50.0 : 0.0;
    
    // Calculate base price (subtotal + VAT)
    final baseTotal = cart.subtotal + cart.vat;
    
    // Calculate final total (with discount)
    final finalTotal = baseTotal + deliveryFee - discountAmount;
    
    _log.info('DISCOUNT CALCULATION:');
    _log.info('- Has promo code: $hasPromoCode');
    _log.info('- Discount percentage: $discountPercentage%');
    _log.info('- Subtotal: ${cart.subtotal}');
    _log.info('- Discount amount: $discountAmount');
    _log.info('- VAT: ${cart.vat}');
    _log.info('- Delivery fee: $deliveryFee');
    _log.info('- Final total: $finalTotal');
    
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
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
          if (includeDeliveryFee) ...[
            SizedBox(height: 8.h),
            _buildPriceRow(
              label: localization.deliveryFee,
              amount: '${deliveryFee.toStringAsFixed(2)} EGP',
              isBold: false,
            ),
          ],
          if (hasPromoCode) ...[
            SizedBox(height: 8.h),
            _buildPriceRow(
              label: '${localization.discount} ($discountPercentage%)',
              amount: '-${discountAmount.toStringAsFixed(2)} EGP',
              isBold: false,
              isDiscount: true,
            ),
          ],
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Divider(height: 1.h, color: Colors.grey.shade300),
          ),
          _buildPriceRow(
            label: localization.total,
            amount: '${finalTotal.toStringAsFixed(2)} EGP',
            isBold: true,
            isLarge: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required String amount,
    required bool isBold,
    bool isLarge = false,
    bool isDiscount = false,
  }) {
    final textColor = isDiscount ? Colors.green : Colors.black;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isLarge ? 18.sp : 16.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: textColor,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isLarge ? 18.sp : 16.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton(
    BuildContext context,
    Cart cart,
    CheckoutState checkoutState,
    S localization,
  ) {
    // Check if order can be placed
    final canPlaceOrder = context.read<CheckoutCubit>().canPlaceOrder(widget.orderType);
    
    // Get user
    final user = context.read<UserCubit>().state.user;
    
    // Get promo code information from PromoCodeCubit
    final promoCodeState = context.watch<PromoCodeCubit>().state;
    final discountAmount = promoCodeState.calculateDiscount(cart.subtotal);
    final promoCodeId = promoCodeState.promoCode?.id;
    
    return Container(
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
        title: localization.placeOrder,
        onTap: () {
          if (canPlaceOrder && user != null) {
            if (widget.orderType == 'delivery' && checkoutState.selectedAddress == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localization.pleaseSelectDeliveryAddress),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
            
            if (widget.orderType == 'pickup' && checkoutState.selectedBranch == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localization.pleaseSelectPickupBranch),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
            
            // Set processing state
            setState(() {
              _isProcessing = true;
            });
            
            // Create order with the dynamic discount calculation
            _createOrderWithDiscount(
              context: context,
              cart: cart,
              user: user,
              orderType: widget.orderType,
              discountAmount: discountAmount,
              promoCodeId: promoCodeId,
            );
          }
        },
        isLoading: _isProcessing || checkoutState.status == CheckoutStatus.loading,
        isEnabled:  canPlaceOrder && user != null && !_isProcessing && checkoutState.status != CheckoutStatus.loading,
        color: ColorsBox.primaryColor,
      ),
    );
  }
  
  // Create order with manually calculated discount
  void _createOrderWithDiscount({
    required BuildContext context,
    required Cart cart,
    required UserModel user,
    required String orderType,
    required double discountAmount,
    String? promoCodeId,
  }) async {
    _log.info('CREATING ORDER WITH DISCOUNT:');
    _log.info('- Discount amount: $discountAmount');
    _log.info('- Promo code ID: $promoCodeId');
    _log.info('- Special request from cart: ${cart.specialInstructions}');
    _log.info('- Special request from field: $_specialRequest');
    
    try {
      // Get checkout repository directly
      final checkoutRepository = RepositoryProvider.of<CheckoutRepository>(context);
      final promoCodeUsageRepository = RepositoryProvider.of<PromoCodeUsageRepository>(context);
      final promoCodeCubit = context.read<PromoCodeCubit>();
      
      // Set loading state
      context.read<CheckoutCubit>().emit(
        context.read<CheckoutCubit>().state.copyWith(status: CheckoutStatus.loading),
      );
      
      // Validate address or branch based on order type
      if (orderType == 'delivery' && context.read<CheckoutCubit>().state.selectedAddress == null) {
        throw Exception('No delivery address selected');
      }

      if (orderType == 'pickup' && context.read<CheckoutCubit>().state.selectedBranch == null) {
        throw Exception('No pickup branch selected');
      }
      
      // If promo code is applied, check if it's already been used by this user
      if (promoCodeId != null) {
        _log.info('Checking if user ${user.id} has already used promo code $promoCodeId');
        final hasUsed = await promoCodeUsageRepository.hasUserUsedPromoCode(user.id, promoCodeId);
        if (hasUsed) {
          throw Exception('You have already used this promo code');
        }
      }
      
      // Create order manually to ensure special request is included
      final orderId = const Uuid().v4();
      final now = DateTime.now();
      
      // Calculate total price manually
      double totalPrice = cart.finalTotal;
      if (orderType == 'delivery') {
        totalPrice += 50.0; // Add delivery fee
      }
      totalPrice -= discountAmount; // Subtract discount
      
      // Use the special request from the field if available, otherwise use from cart
      final specialRequest = _specialRequest ?? cart.specialInstructions;
      
      // Create order JSON directly
      final Map<String, dynamic> orderJson = {
        'id': orderId,
        'user_id': user.id,
        'address_id': orderType == 'delivery' ? context.read<CheckoutCubit>().state.selectedAddress?.id : null,
        'branch_name': orderType == 'pickup' ? context.read<CheckoutCubit>().state.selectedBranch : null,
        'order_type': orderType,
        'payment_method': context.read<CheckoutCubit>().state.paymentMethod,
        'status': 'pending',
        'total_price': totalPrice,
        'promo_code_id': promoCodeId,
        'discount_amount': discountAmount,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
        'special_request': specialRequest,
      };
      
      _log.info('Order JSON: $orderJson');
      
      // Insert directly to database to ensure all fields are included
      await Supabase.instance.client.from('orders').insert(orderJson);
      _log.info('Order created with ID: $orderId, special request: $specialRequest');
      
      // Insert order items
      for (final item in cart.items) {
        await Supabase.instance.client.from('order_items').insert({
          'id': const Uuid().v4(),
          'order_id': orderId,
          'menu_item_id': item.menuItemId,
          'quantity': item.quantity,
          'price_snapshot': (item.totalPrice * 100).toInt(),
          'customizations': {
            'size': item.selectedSize?.toJson(),
            'extras': item.selectedExtras.map((e) => e.toJson()).toList(),
            'beverage': item.selectedBeverage?.toJson(),
            'specialInstructions': item.specialInstructions,
          },
        });
      }
      
      // Record promo code usage if one was applied
      if (promoCodeId != null) {
        _log.info('Recording promo code usage for user ${user.id}, promo code $promoCodeId');
        
        // Use the PromoCodeCubit to record usage
        bool recordSuccess = await promoCodeCubit.recordPromoCodeUsage(user.id, promoCodeId);
        
        // If that fails, try the repository directly
        if (!recordSuccess) {
          _log.warning('PromoCodeCubit recording failed, trying repository directly');
          recordSuccess = await promoCodeUsageRepository.directInsertUsage(user.id, promoCodeId);
        }
        
        if (!recordSuccess) {
          _log.warning('Failed to record promo code usage');
          // Continue with order creation even if recording usage fails
          // We don't want to block the order just because usage tracking failed
        } else {
          _log.info('Successfully recorded promo code usage');
        }
      }
      
      // Clear cart and update state
      context.read<CartCubit>().clearCart();
      
      // Update checkout state with success
      context.read<CheckoutCubit>().emit(
        context.read<CheckoutCubit>().state.copyWith(
          status: CheckoutStatus.success,
          order: OrderModel(
            id: orderId,
            userId: user.id,
            addressId: orderType == 'delivery' ? context.read<CheckoutCubit>().state.selectedAddress?.id : null,
            branchName: orderType == 'pickup' ? context.read<CheckoutCubit>().state.selectedBranch : null,
            orderType: orderType,
            paymentMethod: context.read<CheckoutCubit>().state.paymentMethod,
            status: 'pending',
            totalPrice: totalPrice,
            promoCodeId: promoCodeId,
            discountAmount: discountAmount,
            createdAt: now,
            updatedAt: now,
            specialRequest: specialRequest,
          ),
        ),
      );
      
      // Navigate to success page
      if (mounted) {
        GoRouter.of(context).push('/checkout/success?orderId=${orderId}');
      }
    } catch (e) {
      // Reset processing state
      setState(() {
        _isProcessing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // Update state with error
      context.read<CheckoutCubit>().emit(
        context.read<CheckoutCubit>().state.copyWith(
          status: CheckoutStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
} 
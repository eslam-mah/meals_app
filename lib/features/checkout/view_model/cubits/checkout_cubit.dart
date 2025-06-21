import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/locale.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/features/cart/data/models/cart_model.dart';
import 'package:meals_app/features/checkout/data/models/order_model.dart';
import 'package:meals_app/features/checkout/data/repositories/checkout_repository.dart';
import 'package:meals_app/features/checkout/data/repositories/promo_code_repository.dart';
import 'package:meals_app/features/checkout/data/repositories/promo_code_usage_repository.dart';
import 'package:meals_app/features/checkout/view_model/cubits/checkout_state.dart';
import 'package:meals_app/features/profile/data/models/user_model.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/features/saved_addresses/data/models/address_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CheckoutRepository _checkoutRepository;
  final PromoCodeRepository _promoCodeRepository;
  final PromoCodeUsageRepository _promoCodeUsageRepository;
  final Logger _log = Logger('CheckoutCubit');

  CheckoutCubit({
    required CheckoutRepository checkoutRepository,
    required PromoCodeRepository promoCodeRepository,
    required PromoCodeUsageRepository promoCodeUsageRepository,
  }) : _checkoutRepository = checkoutRepository,
       _promoCodeRepository = promoCodeRepository,
       _promoCodeUsageRepository = promoCodeUsageRepository,
       super(const CheckoutState());

  // Set payment method
  void setPaymentMethod(String method) {
    _log.info('Setting payment method: $method');
    emit(state.copyWith(paymentMethod: method));
  }

  // Set selected branch for pickup
  void setSelectedBranch(String branch) {
    _log.info('Setting selected branch: $branch');
    emit(state.copyWith(selectedBranch: branch));
  }

  // Set selected address for delivery
  void setSelectedAddress(AddressModel address) {
    _log.info('Setting selected address: ${address.id}');
    emit(state.copyWith(selectedAddress: address));
  }

  // Apply promo code
  Future<void> applyPromoCode(String code) async {
    if (code.isEmpty) {
      emit(state.copyWith(
        promoCodeError: Intl.defaultLocale == 'ar' ? 'يرجى إدخال كود خصم' : 'Please enter a promo code',
      ));
      return;
    }

    emit(state.copyWith(
      isApplyingPromoCode: true,
      promoCodeError: null,
    ));

    try {
      // Get current user ID
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      
      _log.info('Applying promo code: $code for user: ${user.id}');
      final promoCode = await _promoCodeRepository.validatePromoCode(code, user.id);

      if (promoCode == null) {
        emit(state.copyWith(
          isApplyingPromoCode: false,
          promoCodeError:Intl.defaultLocale == 'ar' ? 'الكود الخصم غير متوفر' : 'Invalid or expired promo code',
          appliedPromoCode: null,
        ));
        return;
      }
      
      // Check if user has used this code before
      final hasUsed = await _promoCodeUsageRepository.hasUserUsedPromoCode(user.id, promoCode.id);
      if (hasUsed) {
        emit(state.copyWith(
          isApplyingPromoCode: false,
          promoCodeError:Intl.defaultLocale == 'ar' ? 'لقد استخدمت هذا الكود الخصم مسبقاً' : 'You have already used this promo code',
          appliedPromoCode: null,
        ));
        return;
      }

      emit(state.copyWith(
        isApplyingPromoCode: false,
        appliedPromoCode: promoCode,
        promoCodeError: null,
      ));
      
      _log.info('Promo code applied successfully: ${promoCode.code}');
    } catch (e) {
      _log.severe('Error applying promo code: $e');
      emit(state.copyWith(
        isApplyingPromoCode: false,
        promoCodeError:Intl.defaultLocale == 'ar' ? 'خطأ في تطبيق الكود الخصم: ${e.toString()}' : 'Error applying promo code: ${e.toString()}',
        appliedPromoCode: null,
      ));
    }
  }

  // Remove applied promo code
  void removePromoCode() {
    _log.info('Removing promo code');
    emit(state.copyWith(
      appliedPromoCode: null,
      promoCodeError: null,
    ));
  }

  // Create an order
  Future<void> placeOrder({
    required Cart cart, 
    required UserModel user,
    required String orderType,
  }) async {
    emit(state.copyWith(status: CheckoutStatus.loading));

    try {
      _log.info('Placing order for user: ${user.id}');
      _log.info('Order type: $orderType');
      _log.info('Payment method: ${state.paymentMethod}');

      if (orderType == 'delivery' && state.selectedAddress == null) {
        throw Exception('No delivery address selected');
      }

      if (orderType == 'pickup' && state.selectedBranch == null) {
        throw Exception('No pickup branch selected');
      }

      // Debug: Check promo code state
      if (state.appliedPromoCode != null) {
        _log.info('Applied promo code: ${state.appliedPromoCode!.code}');
        _log.info('Applied promo code ID: ${state.appliedPromoCode!.id}');
        _log.info('Applied promo code percentage: ${state.appliedPromoCode!.percentage}%');
        
        // Double-check user hasn't used this code before
        final hasUsed = await _promoCodeUsageRepository.hasUserUsedPromoCode(
          user.id, 
          state.appliedPromoCode!.id
        );
        
        if (hasUsed) {
          throw Exception('You have already used this promo code');
        }
      } else {
        _log.info('No promo code applied');
      }

      // Apply promo code discount if available
      double discountAmount = 0;
      String? promoCodeId;
      
      if (state.appliedPromoCode != null) {
        // Calculate discount on subtotal
        discountAmount = state.calculateDiscount(cart.subtotal);
        promoCodeId = state.appliedPromoCode!.id;
        
        _log.info('Calculated discount: $discountAmount from ${state.appliedPromoCode!.percentage}% of ${cart.subtotal}');
        _log.info('Using promo code ID: $promoCodeId');
      }

      // Create the order
      final order = await _checkoutRepository.createOrder(
        cart: cart,
        user: user,
        paymentMethod: state.paymentMethod,
        orderType: orderType,
        addressId: orderType == 'delivery' ? state.selectedAddress?.id : null,
        branchName: orderType == 'pickup' ? state.selectedBranch : null,
        discountAmount: discountAmount,
        promoCodeId: promoCodeId,
      );

      if (order == null) {
        throw Exception('Failed to create order');
      }

      _log.info('Order created successfully: ${order.id}');
      emit(state.copyWith(
        status: CheckoutStatus.success,
        order: order,
      ));
    } catch (e) {
      _log.severe('Error placing order: $e');
      emit(state.copyWith(
        status: CheckoutStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  // Check if all requirements are met to place an order
  bool canPlaceOrder(String orderType) {
    if (orderType == 'delivery') {
      return state.selectedAddress != null;
    } else {
      return state.selectedBranch != null;
    }
  }

  // Reset checkout state
  void resetCheckout() {
    emit(const CheckoutState());
  }
} 
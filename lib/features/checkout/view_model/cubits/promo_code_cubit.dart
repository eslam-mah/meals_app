import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/features/checkout/data/models/promo_code_model.dart';
import 'package:meals_app/features/checkout/data/repositories/promo_code_repository.dart';
import 'package:meals_app/features/checkout/data/repositories/promo_code_usage_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

// Define PromoCodeState
class PromoCodeState extends Equatable {
  final PromoCodeModel? promoCode;
  final String? errorMessage;
  final bool isLoading;
  
  const PromoCodeState({
    this.promoCode,
    this.errorMessage,
    this.isLoading = false,
  });
  
  @override
  List<Object?> get props => [promoCode, errorMessage, isLoading];
  
  PromoCodeState copyWith({
    PromoCodeModel? promoCode,
    String? errorMessage,
    bool? isLoading,
  }) {
    return PromoCodeState(
      promoCode: promoCode ?? this.promoCode,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
  
  /// Calculate discount amount based on the promo code percentage
  double calculateDiscount(double amount) {
    if (promoCode == null) return 0.0;
    return promoCode!.calculateDiscount(amount);
  }
  
  /// Get the discount percentage
  int get discountPercentage => promoCode?.percentage ?? 0;
  
  /// Check if a promo code is currently applied
  bool get hasPromoCode => promoCode != null;
}

class PromoCodeCubit extends Cubit<PromoCodeState> {
  final PromoCodeRepository _promoCodeRepository;
  final PromoCodeUsageRepository _promoCodeUsageRepository;
  final Logger _log = Logger('PromoCodeCubit');
  
  PromoCodeCubit({
    required PromoCodeRepository promoCodeRepository,
    required PromoCodeUsageRepository promoCodeUsageRepository,
  }) : _promoCodeRepository = promoCodeRepository,
       _promoCodeUsageRepository = promoCodeUsageRepository,
       super(const PromoCodeState());
  
  /// Validate and apply a promo code
  Future<void> applyPromoCode(String code) async {
    if (code.isEmpty) {
      emit(state.copyWith(
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'الرجاء إدخال كود الخصم'
            : 'Please enter a promo code',
        promoCode: null,
      ));
      return;
    }
    
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
    ));
    
    try {
      // Get current user
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception(Intl.getCurrentLocale() == 'ar'
            ? 'المستخدم غير مصادق عليه'
            : 'User not authenticated');
      }
      
      // Validate the promo code
      _log.info('Validating promo code: $code for user: ${user.id}');
      final promoCode = await _promoCodeRepository.validatePromoCode(code, user.id);
      
      if (promoCode == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: Intl.getCurrentLocale() == 'ar'
              ? 'كود الخصم غير صالح أو منتهي الصلاحية'
              : 'Invalid or expired promo code',
          promoCode: null,
        ));
        return;
      }
      
      // Check if the user has already used this promo code
      final hasUsed = await _promoCodeUsageRepository.hasUserUsedPromoCode(user.id, promoCode.id);
      if (hasUsed) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: Intl.getCurrentLocale() == 'ar'
              ? 'لقد استخدمت كود الخصم هذا بالفعل'
              : 'You have already used this promo code',
          promoCode: null,
        ));
        return;
      }
      
      _log.info('Promo code applied: ${promoCode.code} with ${promoCode.percentage}% discount');
      
      // Apply the promo code
      emit(state.copyWith(
        isLoading: false,
        promoCode: promoCode,
        errorMessage: null,
      ));
    } catch (e) {
      _log.severe('Error applying promo code: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'خطأ في تطبيق كود الخصم: $e'
            : 'Error applying promo code: $e',
        promoCode: null,
      ));
    }
  }
  
  /// Remove the currently applied promo code
  void removePromoCode() {
    _log.info('Removing promo code');
    emit(state.copyWith(
      promoCode: null,
      errorMessage: null,
    ));
  }
  
  /// Record promo code usage
  Future<bool> recordPromoCodeUsage(String userId, String promoCodeId) async {
    try {
      _log.info('Recording usage of promo code $promoCodeId by user $userId');
      return await _promoCodeUsageRepository.recordPromoCodeUsage(userId, promoCodeId);
    } catch (e) {
      _log.severe('Error recording promo code usage: $e');
      return false;
    }
  }
} 
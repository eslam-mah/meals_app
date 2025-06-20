import 'package:equatable/equatable.dart';
import 'package:meals_app/features/checkout/data/models/order_model.dart';
import 'package:meals_app/features/checkout/data/models/promo_code_model.dart';
import 'package:meals_app/features/saved_addresses/data/models/address_model.dart';

enum CheckoutStatus {
  initial,
  loading,
  success,
  error,
}

enum PaymentMethod {
  cash,
  card,
}

class CheckoutState extends Equatable {
  final CheckoutStatus status;
  final String? errorMessage;
  final OrderModel? order;
  final String paymentMethod;
  final String? selectedBranch;
  final AddressModel? selectedAddress;
  final List<String> availableBranches;
  final PromoCodeModel? appliedPromoCode;
  final String? promoCodeError;
  final bool isApplyingPromoCode;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.errorMessage,
    this.order,
    this.paymentMethod = 'cash',
    this.selectedBranch,
    this.selectedAddress,
    this.availableBranches = const ['Maadi', 'Nasr City', 'Giza'],
    this.appliedPromoCode,
    this.promoCodeError,
    this.isApplyingPromoCode = false,
  });

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        order,
        paymentMethod,
        selectedBranch,
        selectedAddress,
        availableBranches,
        appliedPromoCode,
        promoCodeError,
        isApplyingPromoCode,
      ];

  CheckoutState copyWith({
    CheckoutStatus? status,
    String? errorMessage,
    OrderModel? order,
    String? paymentMethod,
    String? selectedBranch,
    AddressModel? selectedAddress,
    List<String>? availableBranches,
    PromoCodeModel? appliedPromoCode,
    String? promoCodeError,
    bool? isApplyingPromoCode,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      order: order ?? this.order,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      availableBranches: availableBranches ?? this.availableBranches,
      appliedPromoCode: appliedPromoCode,
      promoCodeError: promoCodeError,
      isApplyingPromoCode: isApplyingPromoCode ?? this.isApplyingPromoCode,
    );
  }

  /// Calculate discount amount based on applied promo code
  double calculateDiscount(double amount) {
    if (appliedPromoCode == null) return 0;
    
    // Debug log the discount calculation
    final percentage = appliedPromoCode!.percentage;
    final discountAmount = amount * (percentage / 100.0);
    
    print('Calculating discount: $percentage% of $amount = $discountAmount');
    
    return discountAmount;
  }
} 
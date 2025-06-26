import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/features/payment/data/paymob_constants.dart';
import 'package:meals_app/features/payment/data/paymob_repository.dart';
import 'package:meals_app/features/payment/view_model/payment_state.dart';
import 'package:meals_app/features/profile/data/models/user_model.dart';
import 'package:meals_app/features/saved_addresses/data/models/address_model.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymobPaymentRepository _paymentRepository;
  final Logger _log = Logger('PaymentCubit');

  PaymentCubit({
    required PaymobPaymentRepository paymentRepository,
  }) : _paymentRepository = paymentRepository,
       super(const PaymentState());

  /// Initialize payment and return the payment URL
  Future<String?> initializePayment({
    required String amount,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String street,
    required String city,
    required String country,
    required String postalCode,
  }) async {
    emit(state.copyWith(status: PaymentStatus.loading));
    
    try {
      _log.info('Initializing payment for amount: $amount');
      
      // Convert amount from decimal (e.g., "150.75") to integer piasters (e.g., "15075")
      // Paymob requires amount in smallest currency unit (piasters for EGP)
      final double amountDouble = double.parse(amount);
      final int amountInPiasters = (amountDouble * 100).round();
      
      _log.info('Payment amount (converted to piasters): $amountInPiasters');
      
      final result = await _paymentRepository.createIntention(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phone,
        state: city,
        apartment: "NA",
        building: "NA",
        street: street,
        country: country,
        floor: "NA",
        amount: amountInPiasters.toString(),
      );
      
      if (result == null) {
        throw Exception('Failed to create payment intention');
      }
      
      _log.info('Payment intention created successfully');
      _log.info('Payment intention ID: ${result['id']}');
      
      // Store transaction ID for verification
      final String transactionId = result['id'].toString();
      
      emit(state.copyWith(
        status: PaymentStatus.intentionCreated,
        paymentIntentionId: transactionId,
        clientSecret: result['client_secret'],
      ));
      
      // Return the payment URL for WebView
      return getPaymentUrl();
      
    } catch (e) {
      _log.severe('Error initializing payment: $e');
      emit(state.copyWith(
        status: PaymentStatus.error,
        errorMessage: e.toString(),
      ));
      return null;
    }
  }

  Future<void> createPaymentIntention({
    required UserModel user,
    required AddressModel address,
    required String amount,
  }) async {
    emit(state.copyWith(status: PaymentStatus.loading));
    
    try {
      _log.info('Creating payment intention for user: ${user.id}');
      _log.info('Payment amount (before conversion): $amount');
      
      // Convert amount from decimal (e.g., "150.75") to integer piasters (e.g., "15075")
      // Paymob requires amount in smallest currency unit (piasters for EGP)
      final double amountDouble = double.parse(amount);
      final int amountInPiasters = (amountDouble * 100).round();
      
      _log.info('Payment amount (converted to piasters): $amountInPiasters');
      
      // Extract address parts from the address string
      // Format the address information as needed for Paymob
      final addressParts = address.address.split(',');
      final street = addressParts.isNotEmpty ? addressParts[0].trim() : address.address;
      final building = addressParts.length > 1 ? addressParts[1].trim() : '';
      final apartment = addressParts.length > 2 ? addressParts[2].trim() : '';
      final floor = addressParts.length > 3 ? addressParts[3].trim() : '';
      
      final result = await _paymentRepository.createIntention(
        firstName: user.name?.split(' ').first ?? 'Customer',
        lastName: '-',
        email: user.email,
        phoneNumber: user.phoneNumber ?? '',
        state: address.city,
        apartment: apartment,
        building: building,
        street: street,
        country: 'Egypt',
        floor: floor,
        amount: amountInPiasters.toString(),
      );
      
      if (result == null) {
        throw Exception('Failed to create payment intention');
      }
      
      _log.info('Payment intention created successfully');
      _log.info('Payment intention ID: ${result['id']}');
      
      emit(state.copyWith(
        status: PaymentStatus.intentionCreated,
        paymentIntentionId: result['id'].toString(),
        clientSecret: result['client_secret'],
      ));
      
    } catch (e) {
      _log.severe('Error creating payment intention: $e');
      emit(state.copyWith(
        status: PaymentStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
  
  Future<bool> launchPaymentPage() async {
    if (state.clientSecret == null) {
      _log.severe('Cannot launch payment page: Client secret is null');
      emit(state.copyWith(
        status: PaymentStatus.error,
        errorMessage: 'Payment information not available',
      ));
      return false;
    }
    
    final url = Uri.parse(
      'https://accept.paymob.com/unifiedcheckout/?publicKey=${PaymobConstants.publicKey}&clientSecret=${state.clientSecret}'
    );
    
    _log.info('Launching payment URL: $url');
    
    try {
      final result = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      
      if (result) {
        emit(state.copyWith(status: PaymentStatus.redirected));
        return true;
      } else {
        throw Exception('Could not launch payment URL');
      }
    } catch (e) {
      _log.severe('Error launching payment URL: $e');
      emit(state.copyWith(
        status: PaymentStatus.error,
        errorMessage: 'Could not open payment page: $e',
      ));
      return false;
    }
  }
  
  /// Get the payment URL for WebView
  String getPaymentUrl() {
    if (state.clientSecret == null) {
      _log.severe('Cannot get payment URL: Client secret is null');
      return '';
    }
    
    return 'https://accept.paymob.com/unifiedcheckout/?publicKey=${PaymobConstants.publicKey}&clientSecret=${state.clientSecret}';
  }
  
  /// Update the payment status based on WebView results
  void updatePaymentStatus(PaymentStatus status, {String? errorMessage}) {
    _log.info('Updating payment status to: $status');
    if (errorMessage != null) {
      _log.info('Error message: $errorMessage');
    }
    
    emit(state.copyWith(
      status: status,
      errorMessage: errorMessage,
    ));
  }
  
  /// Reset the payment state to initial values
  void resetPayment() {
    _log.info('Resetting payment state');
    emit(const PaymentState());
  }
} 
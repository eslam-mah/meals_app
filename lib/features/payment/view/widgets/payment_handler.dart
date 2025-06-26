import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/features/payment/data/paymob_repository.dart';
import 'package:meals_app/features/payment/view/views/payment_webview.dart';
import 'package:meals_app/features/payment/view_model/payment_cubit.dart';
import 'package:meals_app/features/payment/view_model/payment_state.dart';
import 'package:meals_app/features/profile/data/models/user_model.dart';
import 'package:meals_app/features/saved_addresses/data/models/address_model.dart';
import 'package:meals_app/generated/l10n.dart';

class PaymentHandler {
  final BuildContext context;
  final UserModel user;
  final AddressModel address;
  final String amount;
  final String orderId;
  final Function() onPaymentSuccess;
  final Function(String error) onPaymentError;
  final Function()? onPaymentCancelled;
  final Logger _log = Logger('PaymentHandler');
  bool _hasCalledSuccess = false;
  Timer? _safetyTimer;

  PaymentHandler({
    required this.context,
    required this.user,
    required this.address,
    required this.amount,
    required this.orderId,
    required this.onPaymentSuccess,
    required this.onPaymentError,
    this.onPaymentCancelled,
  });

  Future<void> processCardPayment() async {
    final S localization = S.of(context);
    final PaymentCubit paymentCubit = context.read<PaymentCubit>();
    
    try {
      _log.info('Starting card payment process for amount: $amount');
      
      // Reset payment state
      paymentCubit.resetPayment();
      
      // Show loading indicator
      _showLoadingDialog(localization.processingPayment);
      
      // Get user name parts
      List<String> nameParts = (user.name ?? '').split(' ');
      String firstName = nameParts.isNotEmpty ? nameParts.first : 'Customer';
      String lastName = nameParts.length > 1 ? nameParts.last : '-';
      
      // Initialize payment
      final paymentUrl = await paymentCubit.initializePayment(
        amount: amount,
        firstName: firstName,
        lastName: lastName,
        email: user.email,
        phone: user.phoneNumber ?? '',
        street: address.address,
        city: address.city,
        country: 'Egypt',
        postalCode: '00000',
      );
      
      // Close loading dialog
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      if (paymentUrl == null || paymentUrl.isEmpty) {
        _log.severe('Failed to get payment URL');
        onPaymentError(localization.paymentProcessingError);
        return;
      }
      
      _log.info('Payment URL generated: $paymentUrl');
      
      // Set up safety timer to check payment status periodically
      _safetyTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (!context.mounted) {
          timer.cancel();
          return;
        }
        
        // Check payment status
        final status = paymentCubit.state.status;
        _log.info('Safety timer checking payment status: $status');
        
        if (status == PaymentStatus.success) {
          _log.info('Safety timer detected successful payment');
          _triggerSuccessCallback();
          timer.cancel();
        }
      });
      
      // Open payment webview and wait for result
      final result = await _openPaymentWebView(paymentUrl);
      
      // Cancel safety timer
      _safetyTimer?.cancel();
      
      _log.info('WebView closed with result: $result');
      
      // Check payment status after WebView is closed
      if (paymentCubit.state.status == PaymentStatus.success) {
        _log.info('Payment status is success, triggering onPaymentSuccess callback');
        _triggerSuccessCallback();
      } else if (result == true) {
        _log.info('WebView returned success, triggering onPaymentSuccess callback');
        _triggerSuccessCallback();
      }
      
    } catch (e) {
      _log.severe('Error processing payment: $e');
      
      // Cancel safety timer
      _safetyTimer?.cancel();
      
      // Close loading dialog if it's open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      onPaymentError('${localization.paymentProcessingError}: ${e.toString()}');
    }
  }
  
  void _triggerSuccessCallback() {
    if (!_hasCalledSuccess) {
      _hasCalledSuccess = true;
      _log.info('Triggering success callback');
      
      // Force close any remaining dialogs
      while (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      // Call the success callback
      onPaymentSuccess();
      
      // Use microtask to ensure the callback is processed
      Future.microtask(() {
        if (context.mounted) {
          onPaymentSuccess();
        }
      });
    }
  }
  
  Future<bool?> _openPaymentWebView(String paymentUrl) async {
    _log.info('Opening payment webview with URL: $paymentUrl');
    
    // The result will be true for success, false for failure/cancellation
    return await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => PaymentWebView(
          paymentUrl: paymentUrl,
          orderId: orderId,
          onPaymentSuccess: () {
            _log.info('Payment success callback received from webview');
            _triggerSuccessCallback();
          },
          onPaymentError: (error) {
            _log.severe('Payment error callback received from webview: $error');
            onPaymentError(error);
          },
          onPaymentCancelled: () {
            _log.info('Payment cancelled by user');
            
            // Cancel safety timer
            _safetyTimer?.cancel();
            
            if (onPaymentCancelled != null) {
              onPaymentCancelled!();
            } else {
              onPaymentError(S.of(context).paymentCancelled);
            }
          },
        ),
      ),
    );
  }
  
  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message),
            ],
          ),
        );
      },
    );
  }
} 
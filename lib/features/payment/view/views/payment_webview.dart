import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/core/services/notification_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:meals_app/features/cart/data/repositories/cart_repository.dart';
import 'package:meals_app/features/cart/view_model/cubits/cart_cubit.dart';

import 'package:meals_app/generated/l10n.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;
  final Function() onPaymentSuccess;
  final Function(String) onPaymentError;
  final Function() onPaymentCancelled;
  final String orderId;

  const PaymentWebView({
    Key? key,
    required this.paymentUrl,
    required this.onPaymentSuccess,
    required this.onPaymentError,
    required this.onPaymentCancelled,
    required this.orderId,
  }) : super(key: key);

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  final Logger _log = Logger('PaymentWebView');
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasHandledCallback = false;
  late CartCubit _cartCubit;
  
  // Paymob callback URLs
  static const String _callbackUrl1 = 'https://accept.paymobsolutions.com/api/acceptance/post_pay';
  static const String _callbackUrl2 = 'https://accept.paymob.com/api/acceptance/post_pay';

  @override
  void initState() {
    super.initState();
    _initWebViewController();
    _initCartCubit();
  }
  
  void _initCartCubit() {
    // Initialize a fresh CartCubit with a new repository
    final cartRepository = CartRepository();
    _cartCubit = CartCubit(cartRepository: cartRepository);
    CartCubit.initialize(cartRepository);
  }

  void _initWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            _log.info('Page started loading: $url');
            setState(() {
              _isLoading = true;
            });
            
            // Check for success immediately
            if (_isSuccessUrl(url)) {
              _handlePaymentSuccess();
            }
          },
          onPageFinished: (String url) {
            _log.info('Page finished loading: $url');
            setState(() {
              _isLoading = false;
            });
            
            // Check for success again
            if (_isSuccessUrl(url)) {
              _handlePaymentSuccess();
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            _log.info('Navigation request: ${request.url}');
            
            // Check for success URL
            if (_isSuccessUrl(request.url)) {
              _log.info('Success URL detected in navigation request');
              _handlePaymentSuccess();
              return NavigationDecision.prevent;
            }
            
            // Check for failure URL
            if (_isFailureUrl(request.url)) {
              _log.info('Failure URL detected in navigation request');
              _handlePaymentFailure('Payment was not completed successfully');
              return NavigationDecision.prevent;
            }
            
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            _log.severe('Web resource error: ${error.description}');
            if (!mounted) return;
            _handlePaymentFailure('Payment page error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }
  
  bool _isSuccessUrl(String url) {
    return (url.startsWith(_callbackUrl1) || url.startsWith(_callbackUrl2)) && 
           url.contains('success=true');
  }
  
  bool _isFailureUrl(String url) {
    return (url.startsWith(_callbackUrl1) || url.startsWith(_callbackUrl2)) && 
           (url.contains('success=false') || url.contains('error=true'));
  }

  void _handlePaymentSuccess() {
    if (_hasHandledCallback) return;
    _hasHandledCallback = true;
    
    _log.info('Payment successful - handling callback');
    
    // Clear the cart using the initialized CartCubit
    _log.info('Clearing cart after successful payment');
    _cartCubit.clearCart();
      GoRouter.of(context).go('/checkout/success?orderId=${widget.orderId}');
         final S localization = S.of(context);

        Future.delayed(const Duration(minutes: 1)).then((_) async {
          await NotificationService()
              .showOrderConfirmationNotificationWithStrings(
                title: localization.orderReadyNotificationTitle,
                body: localization.orderReadyNotificationBody,
              );
        });



        Future.delayed(const Duration(hours: 2)).then((_) async {
          await NotificationService()
              .showFeedbackRequestNotification(
                title: localization.feedbackRequestNotificationTitle,
                body: localization.feedbackRequestNotificationBody,
              );
        });
    // Call the success callback
    widget.onPaymentSuccess();
    
    // Do NOT navigate to any other page - just as requested
  }

  void _handlePaymentFailure(String errorMessage) {
    if (_hasHandledCallback) return;
    _hasHandledCallback = true;
    
    _log.severe('Payment failed: $errorMessage');
    
    // Notify parent
    widget.onPaymentError(errorMessage);
    
    // Close the payment page
    Navigator.of(context).pop();
       final S localization = S.of(context);

        Future.delayed(const Duration(seconds: 30)).then((_) async {
          await NotificationService()
              .showOrderConfirmationNotificationWithStrings(
                title: localization.paymentFailedNotificationTitle,
                body: localization.paymentFailedNotificationBody,
              );
        });
  }

  @override
  Widget build(BuildContext context) {
    final S localization = S.of(context);
    
    return BlocProvider<CartCubit>.value(
      value: _cartCubit,
      child: PopScope(
        canPop: _hasHandledCallback, // Only allow popping if payment succeeded or failed
        onPopInvoked: (didPop) {
          if (!didPop) {
            // If attempt to pop was blocked, show a message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localization.pleaseWaitForPaymentProcessing),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              localization.payment,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
           
          ),
          body: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_isLoading)
                Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                    strokeWidth: 3.w,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 
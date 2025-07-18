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

  // Paymob callback URLs (replace as needed)
  static const String _callbackUrl1 = 'https://accept.paymobsolutions.com/api/acceptance/post_pay';
  static const String _callbackUrl2 = 'https://accept.paymob.com/api/acceptance/post_pay';

  @override
  void initState() {
    super.initState();
    _initWebViewController();
    _initCartCubit();
  }

  void _initCartCubit() {
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
            if (_isSuccessUrl(url)) {
              _handlePaymentSuccess();
            }
          },
          onPageFinished: (String url) {
            _log.info('Page finished loading: $url');
            setState(() {
              _isLoading = false;
            });
            if (_isSuccessUrl(url)) {
              _handlePaymentSuccess();
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            _log.info('Navigation request: ${request.url}');
            if (_isSuccessUrl(request.url)) {
              _log.info('Success URL detected in navigation request');
              _handlePaymentSuccess();
              return NavigationDecision.prevent;
            }
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

    _cartCubit.clearCart();
    GoRouter.of(context).go('/checkout/success?orderId=${widget.orderId}');

    final S localization = S.of(context);
    Future.delayed(const Duration(minutes: 1)).then((_) async {
      await NotificationService().showOrderConfirmationNotificationWithStrings(
        title: localization.orderReadyNotificationTitle,
        body: localization.orderReadyNotificationBody,
      );
    });
    Future.delayed(const Duration(hours: 2)).then((_) async {
      await NotificationService().showFeedbackRequestNotification(
        title: localization.feedbackRequestNotificationTitle,
        body: localization.feedbackRequestNotificationBody,
      );
    });
    widget.onPaymentSuccess();
  }

  void _handlePaymentFailure(String errorMessage) {
    if (_hasHandledCallback) return;
    _hasHandledCallback = true;
    _log.severe('Payment failed: $errorMessage');
    widget.onPaymentError(errorMessage);
    Navigator.of(context).pop();
    final S localization = S.of(context);
    Future.delayed(const Duration(seconds: 30)).then((_) async {
      await NotificationService().showOrderConfirmationNotificationWithStrings(
        title: localization.paymentFailedNotificationTitle,
        body: localization.paymentFailedNotificationBody,
      );
    });
  }

  Future<void> _showCancelDialog() async {
    final S localization = S.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localization.cancelPayment),
          content: Text(localization.cancelPaymentConfirmation),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(localization.no),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(localization.yes),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      widget.onPaymentCancelled();
      _handlePaymentFailure('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final S localization = S.of(context);

    return BlocProvider<CartCubit>.value(
      value: _cartCubit,
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (!didPop) {
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
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: localization.cancel,
                onPressed: _hasHandledCallback ? null : _showCancelDialog,
              ),
            ],
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

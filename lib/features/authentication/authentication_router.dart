import 'package:go_router/go_router.dart';
import 'package:meals_app/features/authentication/view/views/otp_verification_screen.dart';
import 'package:meals_app/features/authentication/view/views/phone_auth_screen.dart';

class AuthenticationRouter {
  static final List<GoRoute> goRoutes = [
    // All Appointments Page
    GoRoute(
      path: PhoneAuthScreen.routeName,
      builder: (context, state) => const PhoneAuthScreen(),
    ),
    GoRoute(
      path: OtpVerificationScreen.routeName,
      builder: (context, state) {
        final phoneNumber = state.extra as String? ?? '';
        return OtpVerificationScreen(phoneNumber: phoneNumber);
      },
    ),
  ];
}

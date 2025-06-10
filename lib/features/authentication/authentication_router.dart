import 'package:go_router/go_router.dart';
import 'package:meals_app/features/authentication/view/views/forgot_password_screen.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/authentication/view/views/sign_up_screen.dart';

class AuthenticationRouter {
  static final List<GoRoute> goRoutes = [
    // Login Screen (Combined Email + Password)
    GoRoute(
      path: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen(),
    ),
    // Email Auth Screen (for signup)
    GoRoute(
      path: SignUpScreen.routeName,
      builder: (context, state) => const SignUpScreen(),
    ),
    // Password Screen (for password creation)
    
    // Forgot Password Screen
    GoRoute(
      path: ForgotPasswordScreen.routeName,
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return ForgotPasswordScreen(email: email);
      },
    ),
  ];
}

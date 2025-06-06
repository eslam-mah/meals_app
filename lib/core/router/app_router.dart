import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/features/authentication/authentication_router.dart';
import 'package:meals_app/features/cart/cart_router.dart';
import 'package:meals_app/features/feedback/feedback_router.dart';
import 'package:meals_app/features/food_details/food_details_router.dart';
import 'package:meals_app/features/home/main_router.dart';
import 'package:meals_app/features/location/location_router.dart';
import 'package:meals_app/features/profile/profile_router.dart';
import 'package:meals_app/features/onboarding/view/views/onboarding_screen.dart';
import 'package:meals_app/features/settings/settings_router.dart';
import 'package:meals_app/features/saved_addresses/saved_addresses_router.dart';

class AppRouter {
  static Map<String, WidgetBuilder> routes = {
    OnboardingScreen.routeName: (context) => const OnboardingScreen(),
  };

  static String initialRoute = OnboardingScreen.routeName;

  static final GoRouter router = GoRouter(
    initialLocation: OnboardingScreen.routeName,
    routes: [
      // onboarding routes
      GoRoute(
        path: OnboardingScreen.routeName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      // main routes
      ...MainRouter.goRoutes,
      // authentication routes
      ...AuthenticationRouter.goRoutes,
      // location routes
      ...LocationRouter.goRoutes,
      // profile routes
      ...ProfileRouter.goRoutes,
      // settings routesF
      ...SettingsRouter.goRoutes,
      // saved addresses routes
      ...SavedAddressesRouter.goRoutes,
      // cart routes
      ...CartRouter.goRoutes,
      // feedback routes
      ...FeedbackRouter.goRoutes,
      // food details routes
      ...FoodDetailsRouter.goRoutes,
    ],
  );
} 
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/features/authentication/authentication_router.dart';
import 'package:meals_app/features/home/main_router.dart';
import 'package:meals_app/features/location/location_router.dart';
import 'package:meals_app/features/profile/profile_router.dart';
import 'package:meals_app/features/onboarding/view/views/onboarding_screen.dart';
import 'package:meals_app/features/settings/settings_router.dart';

class AppRouter {
  static Map<String, WidgetBuilder> routes = {
    OnboardingScreen.routeName: (context) => const OnboardingScreen(),
  };

  static String initialRoute = OnboardingScreen.routeName;

  static final GoRouter router = GoRouter(
    initialLocation: OnboardingScreen.routeName,
    routes: [
      GoRoute(
        path: OnboardingScreen.routeName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      ...MainRouter.goRoutes,
      ...AuthenticationRouter.goRoutes,
      ...LocationRouter.goRoutes,
      ...ProfileRouter.goRoutes,
      ...SettingsRouter.goRoutes,
    ],
  );
} 
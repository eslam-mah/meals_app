import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/features/authentication/authentication_router.dart';
import 'package:meals_app/features/home/router/main_router.dart';
import 'package:meals_app/features/home/view/views/main_view.dart';
import 'package:meals_app/features/location/location_router.dart';
import 'package:meals_app/features/profile/profile_router.dart';
import 'package:meals_app/features/onboarding/view/views/onboarding_screen.dart';

class AppRouter {
  static Map<String, WidgetBuilder> routes = {
    OnboardingScreen.routeName: (context) => const OnboardingScreen(),
    '/main': (context) => const MainView(),
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
    ],
  );
} 
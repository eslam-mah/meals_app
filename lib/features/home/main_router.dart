import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/features/home/view/views/home_view.dart';
import 'package:meals_app/features/home/view/views/main_view.dart';
import 'package:meals_app/features/home/view/views/menu_view.dart';
import 'package:meals_app/features/home/view/views/profile_view.dart';

class MainRouter {
  
  // GoRouter routes that can be spread into app_router
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: MainView.mainPath,
      builder: (context, state) => const MainView(),
      routes: [
        GoRoute(
          path: HomeView.homePath,
          builder: (context, state) => const HomeView(),
        ),
        GoRoute(
          path: MenuView.menuPath,
          builder: (context, state) => const MenuView(),
        ),
        GoRoute(
          path: ProfileView.profilePath,
          builder: (context, state) => const ProfileView(),
        ),
      ],
    ),
  ];
  
  // Get the main view based on index
  static Widget getViewForIndex(int index) {
    switch (index) {
      case 0:
        return const HomeView();
      case 1:
        return const MenuView();
      case 2:
        return const ProfileView();
      default:
        return const HomeView();
    }
  }
} 
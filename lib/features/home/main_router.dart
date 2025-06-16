import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/features/home/data/repositories/food_repository.dart';
import 'package:meals_app/features/home/view/views/home_view.dart';
import 'package:meals_app/features/home/view/views/main_view.dart';
import 'package:meals_app/features/home/view/views/menu_view.dart';
import 'package:meals_app/features/home/view/views/profile_view.dart';
import 'package:meals_app/features/home/view_model/cubits/food_cubit.dart';

class MainRouter {
  
  // GoRouter routes that can be spread into app_router
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: MainView.mainPath,
      builder: (context, state) => const MainView(),
      routes: [
        GoRoute(
          path: HomeView.homePath,
          builder: (context, state) => _wrapWithFoodCubit(const HomeView()),
        ),
        GoRoute(
          path: MenuView.menuPath,
          builder: (context, state) => _wrapWithFoodCubit(const MenuView()),
        ),
        GoRoute(
          path: ProfileView.profilePath,
          builder: (context, state) => const ProfileView(),
        ),
      ],
    ),
  ];
  
  // Wrap the view with the FoodCubit provider
  static Widget _wrapWithFoodCubit(Widget child) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FoodRepository>(
          create: (context) => FoodRepository(),
        ),
      ],
      child: BlocProvider<FoodCubit>(
        create: (context) {
          final repository = context.read<FoodRepository>();
          final cubit = FoodCubit(foodRepository: repository);
          FoodCubit.initialize(repository);
          return cubit;
        },
        child: child,
      ),
    );
  }
  
  // Get the main view based on index
  static Widget getViewForIndex(int index) {
    switch (index) {
      case 0:
        return _wrapWithFoodCubit(const HomeView());
      case 1:
        return _wrapWithFoodCubit(const MenuView());
      case 2:
        return const ProfileView();
      default:
        return _wrapWithFoodCubit(const HomeView());
    }
  }
} 
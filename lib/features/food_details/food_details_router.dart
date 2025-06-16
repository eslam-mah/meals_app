import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/features/food_details/view/views/food_details_screen.dart';
import 'package:meals_app/features/food_details/view_model/cubits/food_details_cubit.dart';
import 'package:meals_app/features/home/data/repositories/food_repository.dart';

class FoodDetailsRouter {
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: FoodDetailsScreen.routeName,
      builder: (context, state) {
        final foodId = state.extra as String?;
        return _wrapWithFoodDetailsCubit(FoodDetailsScreen(foodId: foodId));
      },
    ),
  ];
  
  // Wrap the view with the FoodDetailsCubit provider
  static Widget _wrapWithFoodDetailsCubit(Widget child) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FoodRepository>(
          create: (context) => FoodRepository(),
        ),
      ],
      child: BlocProvider<FoodDetailsCubit>(
        create: (context) {
          final repository = context.read<FoodRepository>();
          final cubit = FoodDetailsCubit(foodRepository: repository);
          FoodDetailsCubit.initialize(repository);
          return cubit;
        },
        child: child,
      ),
    );
  }
}

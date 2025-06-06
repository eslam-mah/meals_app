import 'package:go_router/go_router.dart';
import 'package:meals_app/features/food_details/view/views/food_details_screen.dart';

class FoodDetailsRouter {
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: FoodDetailsScreen.routeName,
      builder: (context, state) => const FoodDetailsScreen(),
    ),
  ];
}

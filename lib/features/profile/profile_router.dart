import 'package:go_router/go_router.dart';
import 'package:meals_app/features/profile/view/views/add_profile_details_screen.dart';

class ProfileRouter {
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: AddProfileDetailsScreen.routeName,
      builder: (context, state) => const AddProfileDetailsScreen(),
    ),
  ];
} 
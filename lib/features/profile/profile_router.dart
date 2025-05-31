import 'package:go_router/go_router.dart';
import 'package:meals_app/features/profile/view/views/profile_screen.dart';

class ProfileRouter {
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: ProfileScreen.routeName,
      builder: (context, state) => const ProfileScreen(),
    ),
  ];
} 
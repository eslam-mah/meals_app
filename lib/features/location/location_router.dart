import 'package:go_router/go_router.dart';
import 'package:meals_app/features/location/view/views/location_access_screen.dart';

class LocationRouter {
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: LocationAccessScreen.routeName,
      builder: (context, state) => const LocationAccessScreen(),
    ),
  ];
}

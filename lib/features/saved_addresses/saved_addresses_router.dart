import 'package:go_router/go_router.dart';
import 'package:meals_app/features/saved_addresses/view/views/saved_addresses_view.dart';

class SavedAddressesRouter {
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: SavedAddressesView.savedAddressesPath,
      builder: (context, state) => const SavedAddressesView(),
    ),
  ];
}

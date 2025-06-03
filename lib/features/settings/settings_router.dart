import 'package:go_router/go_router.dart';
import 'package:meals_app/features/settings/view/views/settings_view.dart';

class SettingsRouter {
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: SettingsView.settingsPath,
      builder: (context, state) => const SettingsView(),
    ),
  ];
}

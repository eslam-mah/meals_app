import 'package:go_router/go_router.dart';
import 'package:meals_app/features/cart/view/views/cart_view.dart';

class CartRouter {
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: CartView.cartPath,
      builder: (context, state) => const CartView(),
    ),
  ];
}

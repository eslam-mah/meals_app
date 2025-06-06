import 'package:go_router/go_router.dart';
import 'package:meals_app/features/feedback/view/views/feedback_view.dart';

class FeedbackRouter {
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: FeedbackView.feedbackPath,
      builder: (context, state) => const FeedbackView(),
    ),
  ];
}

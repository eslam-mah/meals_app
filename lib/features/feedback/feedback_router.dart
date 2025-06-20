import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/features/feedback/data/repositories/feedback_repository.dart';
import 'package:meals_app/features/feedback/view/views/feedback_view.dart';
import 'package:meals_app/features/feedback/view_model/cubits/feedback_cubit.dart';

class FeedbackRouter {
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: FeedbackView.feedbackPath,
      builder: (context, state) => BlocProvider(
        create: (context) => FeedbackCubit(
          repository: FeedbackRepository(),
        ),
        child: const FeedbackView(),
      ),
    ),
  ];
}

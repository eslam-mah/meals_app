import 'package:meals_app/features/feedback/data/models/feedback_model.dart';

enum FeedbackStatus {
  initial,
  loading,
  success,
  failure,
}

class FeedbackState {
  final FeedbackStatus status;
  final String? error;
  final List<FeedbackModel> feedbackList;
  
  const FeedbackState({
    this.status = FeedbackStatus.initial,
    this.error,
    this.feedbackList = const [],
  });

  FeedbackState copyWith({
    FeedbackStatus? status,
    String? error,
    List<FeedbackModel>? feedbackList,
  }) {
    return FeedbackState(
      status: status ?? this.status,
      error: error, // Setting to null if not provided
      feedbackList: feedbackList ?? this.feedbackList,
    );
  }

  bool get isSubmitting => status == FeedbackStatus.loading;
  bool get isSuccess => status == FeedbackStatus.success;
  bool get isFailure => status == FeedbackStatus.failure;
} 
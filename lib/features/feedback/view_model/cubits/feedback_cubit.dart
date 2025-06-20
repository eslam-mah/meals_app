import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/features/feedback/data/models/feedback_model.dart';
import 'package:meals_app/features/feedback/data/repositories/feedback_repository.dart';
import 'package:meals_app/features/feedback/view_model/cubits/feedback_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final FeedbackRepository _repository;
  final Logger _log = Logger('FeedbackCubit');

  FeedbackCubit({required FeedbackRepository repository})
      : _repository = repository,
        super(const FeedbackState());

  // Submit a new feedback
  Future<bool> submitFeedback({
    required int rating1,
    required int rating2,
    required int rating3,
    required int overallRate,
    String? comment,
    String? phoneNumber,
  }) async {
    emit(state.copyWith(status: FeedbackStatus.loading));
    
    try {
      _log.info('Creating feedback with ratings: $rating1, $rating2, $rating3, overall: $overallRate');
      
      // Get current user ID if authenticated
      String? userId;
      final authUser = Supabase.instance.client.auth.currentUser;
      if (authUser != null) {
        userId = authUser.id;
      }
      
      // Create the feedback model
      final feedback = FeedbackModel(
        userId: userId,
        rating1: rating1,
        rating2: rating2,
        rating3: rating3,
        overallRate: overallRate,
        comment: comment,
        phoneNumber: phoneNumber,
      );
      
      // Submit feedback to repository
      final success = await _repository.submitFeedback(feedback);
      
      if (success) {
        _log.info('Feedback submitted successfully');
        emit(state.copyWith(
          status: FeedbackStatus.success,
          error: null,
        ));
        return true;
      } else {
        _log.warning('Failed to submit feedback');
        emit(state.copyWith(
          status: FeedbackStatus.failure,
          error: 'Failed to submit feedback',
        ));
        return false;
      }
    } catch (e) {
      _log.severe('Error submitting feedback: $e');
      emit(state.copyWith(
        status: FeedbackStatus.failure,
        error: e.toString(),
      ));
      return false;
    }
  }

  // Load feedback for current user
  Future<void> loadUserFeedback() async {
    emit(state.copyWith(status: FeedbackStatus.loading));
    
    try {
      final authUser = Supabase.instance.client.auth.currentUser;
      if (authUser == null) {
        _log.warning('No authenticated user found');
        emit(state.copyWith(
          status: FeedbackStatus.failure,
          error: 'Not authenticated',
        ));
        return;
      }
      
      final feedbackList = await _repository.getUserFeedback(authUser.id);
      
      emit(state.copyWith(
        status: FeedbackStatus.success,
        feedbackList: feedbackList,
        error: null,
      ));
    } catch (e) {
      _log.severe('Error loading user feedback: $e');
      emit(state.copyWith(
        status: FeedbackStatus.failure,
        error: e.toString(),
      ));
    }
  }

  // Reset state to initial
  void reset() {
    emit(const FeedbackState());
  }
} 
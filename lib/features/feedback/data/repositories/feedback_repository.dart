import 'package:logging/logging.dart';
import 'package:meals_app/features/feedback/data/models/feedback_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedbackRepository {
  final Logger _log = Logger('FeedbackRepository');
  final SupabaseClient _supabase = Supabase.instance.client;

  // Submit feedback to the database
  Future<bool> submitFeedback(FeedbackModel feedback) async {
    try {
      _log.info('Submitting feedback: ${feedback.id}');
      
      // Insert the feedback into the feedback table
      await _supabase
          .from('feedback')
          .insert(feedback.toJson());
          
      _log.info('Feedback submitted successfully');
      return true;
    } catch (e) {
      _log.severe('Error submitting feedback: $e');
      return false;
    }
  }

  // Get all feedback for a specific user
  Future<List<FeedbackModel>> getUserFeedback(String userId) async {
    try {
      _log.info('Fetching feedback for user: $userId');
      
      final response = await _supabase
          .from('feedback')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
          
      final List<FeedbackModel> feedbackList = response
          .map<FeedbackModel>((json) => FeedbackModel.fromJson(json))
          .toList();
          
      _log.info('Fetched ${feedbackList.length} feedback items');
      return feedbackList;
    } catch (e) {
      _log.severe('Error fetching user feedback: $e');
      return [];
    }
  }

  // Get all feedback (for admin)
  Future<List<FeedbackModel>> getAllFeedback() async {
    try {
      _log.info('Fetching all feedback');
      
      final response = await _supabase
          .from('feedback')
          .select()
          .order('created_at', ascending: false);
          
      final List<FeedbackModel> feedbackList = response
          .map<FeedbackModel>((json) => FeedbackModel.fromJson(json))
          .toList();
          
      _log.info('Fetched ${feedbackList.length} feedback items');
      return feedbackList;
    } catch (e) {
      _log.severe('Error fetching all feedback: $e');
      return [];
    }
  }
} 
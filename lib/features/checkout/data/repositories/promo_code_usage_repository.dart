import 'package:logging/logging.dart';
import 'package:meals_app/features/checkout/data/models/promo_code_usage_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PromoCodeUsageRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Logger _log = Logger('PromoCodeUsageRepository');
  
  static const String _promoCodeUsagesTable = 'promo_code_usages';
  
  /// Check if a user has already used a specific promo code
  Future<bool> hasUserUsedPromoCode(String userId, String promoCodeId) async {
    try {
      _log.info('Checking if user $userId has used promo code $promoCodeId');
      
      final response = await _supabase
          .from(_promoCodeUsagesTable)
          .select()
          .eq('user_id', userId)
          .eq('promo_code_id', promoCodeId)
          .maybeSingle();
      
      final hasUsed = response != null;
      _log.info('User $userId has ${hasUsed ? "already" : "not"} used promo code $promoCodeId');
      return hasUsed;
    } catch (e) {
      _log.severe('Error checking promo code usage: $e');
      return false; // Default to false on error to prevent unauthorized usage
    }
  }
  
  /// Record a promo code usage by a user
  Future<bool> recordPromoCodeUsage(String userId, String promoCodeId) async {
    try {
      _log.info('Recording usage of promo code $promoCodeId by user $userId');
      
      // Check if already used
      final alreadyUsed = await hasUserUsedPromoCode(userId, promoCodeId);
      if (alreadyUsed) {
        _log.warning('User $userId has already used promo code $promoCodeId');
        return false;
      }
      
      // Create usage record with explicit fields
      final now = DateTime.now().toIso8601String();
      
      // Debug the insert operation
      _log.info('Inserting promo code usage with data:');
      _log.info('- user_id: $userId');
      _log.info('- promo_code_id: $promoCodeId');
      _log.info('- used_at: $now');
      
      // Use explicit insert with full data
      final result = await _supabase.from(_promoCodeUsagesTable).insert({
        'user_id': userId,
        'promo_code_id': promoCodeId,
        'used_at': now,
      }).select();
      
      _log.info('Insert response: $result');
      _log.info('Successfully recorded usage of promo code $promoCodeId by user $userId');
      return true;
    } catch (e) {
      _log.severe('Error recording promo code usage: $e');
      // Print detailed error information
      if (e is PostgrestException) {
        _log.severe('PostgrestException details:');
        _log.severe('- Code: ${e.code}');
        _log.severe('- Message: ${e.message}');
        _log.severe('- Details: ${e.details}');
        _log.severe('- Hint: ${e.hint}');
      }
      return false;
    }
  }
  
  /// Get all usages for a specific promo code
  Future<List<PromoCodeUsageModel>> getUsagesByPromoCode(String promoCodeId) async {
    try {
      _log.info('Getting all usages for promo code $promoCodeId');
      
      final response = await _supabase
          .from(_promoCodeUsagesTable)
          .select()
          .eq('promo_code_id', promoCodeId)
          .order('used_at', ascending: false);
      
      final usages = response
          .map<PromoCodeUsageModel>((json) => PromoCodeUsageModel.fromJson(json))
          .toList();
      
      _log.info('Found ${usages.length} usages for promo code $promoCodeId');
      return usages;
    } catch (e) {
      _log.severe('Error getting promo code usages: $e');
      return [];
    }
  }
  
  /// Get all promo codes used by a specific user
  Future<List<String>> getPromoCodesUsedByUser(String userId) async {
    try {
      _log.info('Getting all promo codes used by user $userId');
      
      final response = await _supabase
          .from(_promoCodeUsagesTable)
          .select('promo_code_id')
          .eq('user_id', userId);
      
      final usedCodes = response
          .map<String>((json) => json['promo_code_id'] as String)
          .toList();
      
      _log.info('User $userId has used ${usedCodes.length} promo codes');
      return usedCodes;
    } catch (e) {
      _log.severe('Error getting promo codes used by user: $e');
      return [];
    }
  }
  
  /// Direct method to manually insert a usage record (for testing)
  Future<bool> directInsertUsage(String userId, String promoCodeId) async {
    try {
      _log.info('DIRECT INSERT: Recording usage of promo code $promoCodeId by user $userId');
      
      // Create usage record with explicit fields
      final now = DateTime.now().toIso8601String();
      
      // Use raw SQL insert to bypass any potential issues
      final result = await _supabase.rpc('insert_promo_code_usage', params: {
        'p_user_id': userId,
        'p_promo_code_id': promoCodeId,
        'p_used_at': now,
      });
      
      _log.info('Direct insert response: $result');
      _log.info('Successfully recorded usage directly');
      return true;
    } catch (e) {
      _log.severe('Error in direct insert: $e');
      if (e is PostgrestException) {
        _log.severe('PostgrestException details:');
        _log.severe('- Code: ${e.code}');
        _log.severe('- Message: ${e.message}');
        _log.severe('- Details: ${e.details}');
        _log.severe('- Hint: ${e.hint}');
      }
      return false;
    }
  }
} 
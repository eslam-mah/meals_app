import 'package:logging/logging.dart';
import 'package:meals_app/features/checkout/data/models/promo_code_model.dart';
import 'package:meals_app/features/checkout/data/repositories/promo_code_usage_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PromoCodeRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final PromoCodeUsageRepository _usageRepository = PromoCodeUsageRepository();
  final Logger _log = Logger('PromoCodeRepository');
  
  static const String _promoCodesTable = 'promo_codes';
  
  /// Validate and retrieve a promo code by its code
  Future<PromoCodeModel?> validatePromoCode(String code, String userId) async {
    try {
      _log.info('Validating promo code: $code for user: $userId');
      
      // Get the promo code from the database
      final response = await _supabase
          .from(_promoCodesTable)
          .select()
          .eq('code', code.toUpperCase())
          .maybeSingle();
      
      // Debug the full response
      _log.info('Database response for promo code: $response');
      
      if (response == null) {
        _log.warning('Promo code not found: $code');
        return null;
      }
      
      // Parse the promo code
      final promoCode = PromoCodeModel.fromJson(response);
      
      // Debug the parsed promo code
      _log.info('Parsed promo code: ID=${promoCode.id}, Code=${promoCode.code}, Type=${promoCode.type}, Percentage=${promoCode.percentage}');
      
      // Check if the promo code is valid
      if (!promoCode.isValid) {
        _log.warning('Promo code is not valid: $code');
        return null;
      }
      
      // Check usage limit if it exists
      if (promoCode.usageLimit != null && promoCode.usageLimit! <= 0) {
        _log.warning('Promo code usage limit reached: $code');
        return null;
      }
      
      // Check if this user has already used this promo code
      final hasUserUsed = await _usageRepository.hasUserUsedPromoCode(userId, promoCode.id);
      if (hasUserUsed) {
        _log.warning('User $userId has already used promo code ${promoCode.code} (ID: ${promoCode.id})');
        return null;
      }
      
      _log.info('Promo code validated successfully: $code (ID: ${promoCode.id})');
      return promoCode;
    } catch (e) {
      _log.severe('Error validating promo code: $e');
      return null;
    }
  }
  
  /// Apply a promo code to an order (decrease usage limit)
  Future<bool> applyPromoCode(String promoCodeId) async {
    try {
      _log.info('Applying promo code: $promoCodeId');
      
      // Get the current promo code
      final response = await _supabase
          .from(_promoCodesTable)
          .select('usage_limit')
          .eq('id', promoCodeId)
          .single();
      
      // Check if the promo code exists and has a usage limit
      if (response == null) {
        _log.warning('Promo code not found: $promoCodeId');
        return false;
      }
      
      final currentUsageLimit = response['usage_limit'] as int?;
      
      // If there's a usage limit, decrease it
      if (currentUsageLimit != null) {
        if (currentUsageLimit <= 0) {
          _log.warning('Promo code usage limit already reached: $promoCodeId');
          return false;
        }
        
        // Update the usage limit
        await _supabase
            .from(_promoCodesTable)
            .update({'usage_limit': currentUsageLimit - 1})
            .eq('id', promoCodeId);
      }
      
      _log.info('Promo code applied successfully: $promoCodeId');
      return true;
    } catch (e) {
      _log.severe('Error applying promo code: $e');
      return false;
    }
  }

  /// Get promo code by ID
  Future<PromoCodeModel?> getPromoCodeById(String promoCodeId) async {
    try {
      _log.info('Getting promo code by ID: $promoCodeId');
      
      final response = await _supabase
          .from(_promoCodesTable)
          .select()
          .eq('id', promoCodeId)
          .maybeSingle();
      
      if (response == null) {
        _log.warning('Promo code not found: $promoCodeId');
        return null;
      }
      
      return PromoCodeModel.fromJson(response);
    } catch (e) {
      _log.severe('Error getting promo code by ID: $e');
      return null;
    }
  }
} 
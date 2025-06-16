import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meals_app/features/home/data/models/food_model.dart';

class FoodRepository {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final Logger _log = Logger('FoodRepository');
  
  // Pagination constants
  static const int _pageSize = 10;
  
  /// Fetch food items with pagination
  Future<List<FoodModel>> getFoodItems({
    required int page,
    String? mealType,
    bool refresh = false,
  }) async {
    try {
      _log.info('Fetching food items: page=$page, mealType=$mealType');
      
      // Calculate pagination range
      final int startRange = page * _pageSize;
      final int endRange = startRange + _pageSize - 1;
      
      // Build query with proper typing
      var query = _supabaseClient
          .from('menu_items')
          .select();
      
      // Apply meal type filter if specified
      if (mealType != null) {
        query = query.eq('meal_type', mealType);
      }
      
      // Apply pagination and ordering
      final response = await query
          .order('created_at', ascending: false)
          .range(startRange, endRange);
      
      _log.info('Fetched ${response.length} food items');
      
      // Convert to models
      final items = response.map((json) => FoodModel.fromJson(json)).toList();
      return items;
    } catch (e) {
      _log.severe('Error fetching food items: $e');
      rethrow;
    }
  }
  
  /// Fetch recommended food items
  Future<List<FoodModel>> getRecommendedItems({
    required int page,
    bool refresh = false,
  }) async {
    return getFoodItems(page: page, mealType: 'recommended');
  }
  
  /// Fetch offer food items
  Future<List<FoodModel>> getOfferItems({
    required int page,
    bool refresh = false,
  }) async {
    return getFoodItems(page: page, mealType: 'offer');
  }
  
  /// Fetch menu food items
  Future<List<FoodModel>> getMenuItems({
    required int page,
    bool refresh = false,
  }) async {
    return getFoodItems(page: page, mealType: 'menu');
  }
  
  /// Get a single food item by ID
  Future<FoodModel> getFoodItemById(String id) async {
    try {
      _log.info('Fetching food item by ID: $id');
      
      final response = await _supabaseClient
          .from('menu_items')
          .select()
          .eq('id', id)
          .single();
      
      _log.info('Fetched food item: ${response['id']}');
      
      return FoodModel.fromJson(response);
    } catch (e) {
      _log.severe('Error fetching food item by ID: $e');
      rethrow;
    }
  }
} 
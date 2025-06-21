import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/features/cart/data/models/cart_model.dart';
import 'package:meals_app/features/home/data/models/food_model.dart';
import 'package:meals_app/features/home/data/repositories/food_repository.dart';
import 'package:meals_app/features/profile/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CartRepository {
  final Logger _log = Logger('CartRepository');
  // final StorageService _storageService = StorageService();
  final FoodRepository _foodRepository = FoodRepository();
  
  // Supabase client
  final SupabaseClient _supabase = Supabase.instance.client;
  
  // Local cache key
  static const String _cartCacheKey = 'user_cart';
  
  /// Get cart from local storage (for guest users or offline mode)
  Future<Cart> getLocalCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartCacheKey);
      if (cartJson != null) {
        try {
          final Map<String, dynamic> jsonMap = json.decode(cartJson);
          return Cart.fromJson(jsonMap);
        } catch (e) {
          _log.warning('Failed to parse cart JSON: $e');
          // If parsing fails, return empty cart and clear invalid data
          await prefs.remove(_cartCacheKey);
          return const Cart();
        }
      }
    } catch (e) {
      _log.warning('Failed to get cart from local storage: $e');
    }
    
    return const Cart();
  }
  
  /// Save cart to local storage
  Future<void> saveLocalCart(Cart cart) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(cart.toJson());
      await prefs.setString(_cartCacheKey, cartJson);
      _log.info('Cart saved to local storage with ${cart.items.length} items');
    } catch (e) {
      _log.warning('Failed to save cart to local storage: $e');
      // Try to clear the cart if saving fails
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_cartCacheKey);
      } catch (_) {}
    }
  }
  
  /// Get cart from Supabase for authenticated users
  Future<Cart> getUserCart(String userId) async {
    try {
      final response = await _supabase
          .from('cart')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      final items = <CartItem>[];
      
      // Load food details for each cart item
      for (final item in response) {
        try {
          final foodId = item['menu_item_id'] as String;
          final foodDetails = await _foodRepository.getFoodItemById(foodId);
          
          items.add(CartItem.fromJson(item, foodDetails: foodDetails));
        } catch (e) {
          _log.warning('Failed to load food details for cart item: $e');
          // Still add the item even without food details
          items.add(CartItem.fromJson(item));
        }
      }
      
      return Cart(items: items);
    } catch (e) {
      _log.warning('Failed to get user cart from Supabase: $e');
      // Fall back to local cart
      return getLocalCart();
    }
  }
  
  /// Add item to cart in Supabase for authenticated users
  Future<bool> addItemToUserCart(String userId, CartItem item) async {
    try {
      // Always generate a new ID for the item to ensure it's unique
      final newItemId = const Uuid().v4();
      
      final itemJson = item.toJson();
      itemJson['id'] = newItemId;
      itemJson['user_id'] = userId;
      
      _log.info('Adding new item to Supabase cart: ${item.name} (menuItemId: ${item.menuItemId})');
      
      await _supabase.from('cart').insert(itemJson);
      return true;
    } catch (e) {
      _log.warning('Failed to add item to user cart in Supabase: $e');
      return false;
    }
  }
  
  /// Update item in cart in Supabase for authenticated users
  Future<bool> updateCartItem(CartItem item) async {
    try {
      await _supabase
          .from('cart')
          .update(item.toJson())
          .eq('id', item.id);
      return true;
    } catch (e) {
      _log.warning('Failed to update cart item in Supabase: $e');
      return false;
    }
  }
  
  /// Remove item from cart in Supabase for authenticated users
  Future<bool> removeCartItem(String itemId) async {
    try {
      await _supabase
          .from('cart')
          .delete()
          .eq('id', itemId);
      return true;
    } catch (e) {
      _log.warning('Failed to remove cart item from Supabase: $e');
      return false;
    }
  }
  
  /// Clear all items from cart in Supabase for authenticated users
  Future<bool> clearUserCart(String userId) async {
    try {
      await _supabase
          .from('cart')
          .delete()
          .eq('user_id', userId);
      return true;
    } catch (e) {
      _log.warning('Failed to clear user cart in Supabase: $e');
      return false;
    }
  }
  
  /// Add item to cart (handles both local and remote storage)
  Future<Cart> addToCart(CartItem item, {UserModel? user}) async {
    try {
      // Get current cart
      Cart cart;
      if (user != null) {
        // For authenticated users, always add as a new item to Supabase
        final success = await addItemToUserCart(user.id, item);
        if (success) {
          // Get updated cart from Supabase
          cart = await getUserCart(user.id);
        } else {
          // Fall back to local cart
          cart = await getLocalCart();
          // For local storage, we can merge similar items
          cart = cart.addItem(item);
          await saveLocalCart(cart);
        }
      } else {
        // For guest users, use local storage only
        cart = await getLocalCart();
        cart = cart.addItem(item);
        await saveLocalCart(cart);
      }
      
      return cart;
    } catch (e) {
      _log.severe('Error adding item to cart: $e');
      throw Exception('Failed to add item to cart: $e');
    }
  }
  
  /// Add a new item to the cart (always as a new entry)
  Future<Cart> addNewItemToCart(CartItem item, {UserModel? user}) async {
    try {
      // Get current cart
      Cart cart;
      if (user != null) {
        // For authenticated users, always add as a new item to Supabase
        final success = await addItemToUserCart(user.id, item);
        if (success) {
          // Get updated cart from Supabase
          cart = await getUserCart(user.id);
        } else {
          // Fall back to local cart
          cart = await getLocalCart();
          // For local storage, add as a new item
          cart = cart.copyWith(items: [...cart.items, item]);
          await saveLocalCart(cart);
        }
      } else {
        // For guest users, use local storage only
        cart = await getLocalCart();
        cart = cart.copyWith(items: [...cart.items, item]);
        await saveLocalCart(cart);
      }
      
      return cart;
    } catch (e) {
      _log.severe('Error adding new item to cart: $e');
      throw Exception('Failed to add new item to cart: $e');
    }
  }
  
  /// Update item in cart (handles both local and remote storage)
  Future<Cart> updateItem(CartItem updatedItem, {UserModel? user}) async {
    try {
      Cart cart;
      if (user != null) {
        // For authenticated users, try to update in Supabase first
        final success = await updateCartItem(updatedItem);
        if (success) {
          // Get updated cart from Supabase
          cart = await getUserCart(user.id);
        } else {
          // Fall back to local cart
          cart = await getLocalCart();
          cart = cart.updateItem(updatedItem);
          await saveLocalCart(cart);
        }
      } else {
        // For guest users, use local storage only
        cart = await getLocalCart();
        cart = cart.updateItem(updatedItem);
        await saveLocalCart(cart);
      }
      
      return cart;
    } catch (e) {
      _log.severe('Error updating item in cart: $e');
      throw Exception('Failed to update item in cart: $e');
    }
  }
  
  /// Remove item from cart (handles both local and remote storage)
  Future<Cart> removeItem(String itemId, {UserModel? user}) async {
    try {
      Cart cart;
      if (user != null) {
        // For authenticated users, try to remove from Supabase first
        final success = await removeCartItem(itemId);
        if (success) {
          // Get updated cart from Supabase
          cart = await getUserCart(user.id);
        } else {
          // Fall back to local cart
          cart = await getLocalCart();
          cart = cart.removeItem(itemId);
          await saveLocalCart(cart);
        }
      } else {
        // For guest users, use local storage only
        cart = await getLocalCart();
        cart = cart.removeItem(itemId);
        await saveLocalCart(cart);
      }
      
      return cart;
    } catch (e) {
      _log.severe('Error removing item from cart: $e');
      throw Exception('Failed to remove item from cart: $e');
    }
  }
  
  /// Clear cart (handles both local and remote storage)
  Future<Cart> clearCart({UserModel? user}) async {
    try {
      if (user != null) {
        // For authenticated users, try to clear in Supabase first
        await clearUserCart(user.id);
      }
      
      // Always clear local cart
      await saveLocalCart(const Cart());
      
      return const Cart();
    } catch (e) {
      _log.severe('Error clearing cart: $e');
      throw Exception('Failed to clear cart: $e');
    }
  }
  
  /// Get current cart (handles both local and remote storage)
  Future<Cart> getCart({UserModel? user}) async {
    try {
      if (user != null) {
        // For authenticated users, try to get from Supabase first
        try {
          return await getUserCart(user.id);
        } catch (e) {
          _log.warning('Failed to get user cart from Supabase, falling back to local: $e');
          return getLocalCart();
        }
      } else {
        // For guest users, use local storage only
        return getLocalCart();
      }
    } catch (e) {
      _log.severe('Error getting cart: $e');
      // Return empty cart on error
      return const Cart();
    }
  }
  
  /// Increment item quantity
  Future<Cart> incrementItemQuantity(String itemId, {UserModel? user}) async {
    try {
      Cart cart = await getCart(user: user);
      final itemIndex = cart.items.indexWhere((item) => item.id == itemId);
      
      if (itemIndex != -1) {
        final item = cart.items[itemIndex];
        final updatedItem = item.incrementQuantity();
        
        return updateItem(updatedItem, user: user);
      }
      
      return cart;
    } catch (e) {
      _log.severe('Error incrementing item quantity: $e');
      throw Exception('Failed to update item quantity: $e');
    }
  }
  
  /// Decrement item quantity
  Future<Cart> decrementItemQuantity(String itemId, {UserModel? user}) async {
    try {
      Cart cart = await getCart(user: user);
      final itemIndex = cart.items.indexWhere((item) => item.id == itemId);
      
      if (itemIndex != -1) {
        final item = cart.items[itemIndex];
        
        if (item.quantity <= 1) {
          // Remove item if quantity would be 0
          return removeItem(itemId, user: user);
        } else {
          final updatedItem = item.decrementQuantity();
          return updateItem(updatedItem, user: user);
        }
      }
      
      return cart;
    } catch (e) {
      _log.severe('Error decrementing item quantity: $e');
      throw Exception('Failed to update item quantity: $e');
    }
  }
  
  /// Set special instructions for the entire order
  Future<Cart> setSpecialInstructions(String? instructions, {UserModel? user}) async {
    try {
      Cart cart = await getCart(user: user);
      cart = cart.setSpecialInstructions(instructions);
      await saveLocalCart(cart);
      return cart;
    } catch (e) {
      _log.severe('Error setting special instructions: $e');
      throw Exception('Failed to update cart: $e');
    }
  }
  
  /// Set delivery type (delivery or pickup)
  Future<Cart> setDeliveryType(String type, {UserModel? user}) async {
    try {
      Cart cart = await getCart(user: user);
      cart = cart.setDeliveryType(type);
      await saveLocalCart(cart);
      return cart;
    } catch (e) {
      _log.severe('Error setting delivery type: $e');
      throw Exception('Failed to update cart: $e');
    }
  }
  
  /// Sync local cart with remote cart (for when user logs in)
  Future<Cart> syncCartOnLogin(UserModel user) async {
    try {
      // Get local cart
      final localCart = await getLocalCart();
      
      // Get remote cart
      final remoteCart = await getUserCart(user.id);
      
      // If local cart is empty, just return remote cart
      if (localCart.isEmpty) {
        return remoteCart;
      }
      
      // If remote cart is empty, upload local cart
      if (remoteCart.isEmpty && localCart.isNotEmpty) {
        for (final item in localCart.items) {
          await addItemToUserCart(user.id, item.copyWith(userId: user.id));
        }
        return getUserCart(user.id);
      }
      
      // Merge carts - add all local items as new items
      for (final localItem in localCart.items) {
        await addItemToUserCart(user.id, localItem.copyWith(userId: user.id));
      }
      
      // Get final cart
      final finalCart = await getUserCart(user.id);
      
      // Clear local cart
      await saveLocalCart(const Cart());
      
      return finalCart;
    } catch (e) {
      _log.warning('Failed to sync cart on login: $e');
      return getLocalCart();
    }
  }
} 
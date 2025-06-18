import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/features/cart/data/models/cart_model.dart';
import 'package:meals_app/features/cart/data/repositories/cart_repository.dart';
import 'package:meals_app/features/cart/view_model/cubits/cart_state.dart';
import 'package:meals_app/features/home/data/models/food_model.dart';
import 'package:meals_app/features/profile/data/models/user_model.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;
  final Logger _log = Logger('CartCubit');
  
  // Static instance for easy global access
  static CartCubit? _instance;
  static CartCubit get instance {
    if (_instance == null) {
      throw StateError('CartCubit instance is not initialized. Call initialize() first.');
    }
    return _instance!;
  }
  
  /// Initialize the static instance
  static void initialize(CartRepository repository) {
    _instance ??= CartCubit._internal(repository);
  }
  
  // Private constructor
  CartCubit._internal(this._cartRepository) : super(const CartState());
  
  // Public constructor for dependency injection (used by BlocProvider)
  CartCubit({required CartRepository cartRepository}) 
    : _cartRepository = cartRepository,
      super(const CartState()) {
    _instance ??= this;
    // Load cart on initialization
    loadCart();
  }

  /// Load the current cart
  Future<void> loadCart() async {
    emit(state.copyWith(status: CartStatus.loading));
    
    try {
      // Get current user if authenticated
      UserModel? user;
      try {
        user = UserCubit.instance.state.user;
      } catch (e) {
        _log.warning('UserCubit not initialized, proceeding with guest cart: $e');
      }
      
      // Get cart
      final cart = await _cartRepository.getCart(user: user);
      
      emit(state.copyWith(
        status: CartStatus.loaded,
        cart: cart,
      ));
      
      // Log the cart state
      _log.info('Cart loaded with ${cart.items.length} items, total: ${cart.totalPrice}');
    } catch (e) {
      _log.warning('Failed to load cart: $e');
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to load cart',
      ));
    }
  }

  /// Add an item to the cart
  Future<void> addToCart({
    required FoodModel food,
    required int quantity,
    FoodSize? selectedSize,
    List<FoodExtra>? selectedExtras,
    FoodBeverage? selectedBeverage,
    String? specialInstructions,
  }) async {
    emit(state.copyWith(status: CartStatus.loading));
    
    try {
      // Get current user if authenticated
      UserModel? user;
      try {
        user = UserCubit.instance.state.user;
      } catch (e) {
        _log.warning('UserCubit not initialized, proceeding with guest cart: $e');
      }
      
      _log.info('Adding to cart: ${food.nameEn} (ID: ${food.id})');
      _log.info('Selected size: ${selectedSize?.nameEn ?? 'None'}');
      _log.info('Selected extras: ${selectedExtras?.map((e) => e.nameEn).join(', ') ?? 'None'}');
      _log.info('Selected beverage: ${selectedBeverage?.nameEn ?? 'None'}');
      
      // Create cart item
      final cartItem = CartItem.fromFoodModel(
        food: food,
        userId: user?.id,
        quantity: quantity,
        selectedSize: selectedSize,
        selectedExtras: selectedExtras,
        selectedBeverage: selectedBeverage,
        specialInstructions: specialInstructions,
      );
      
      // Add to cart
      final updatedCart = await _cartRepository.addToCart(cartItem, user: user);
      
      emit(state.copyWith(
        status: CartStatus.loaded,
        cart: updatedCart,
        lastAddedItem: cartItem,
      ));
      
      _log.info('Item added to cart. New cart size: ${updatedCart.items.length}');
      
      // Debug log all items in the cart
      for (int i = 0; i < updatedCart.items.length; i++) {
        final item = updatedCart.items[i];
        _log.info('Cart item $i: ${item.name} (ID: ${item.id}, menuItemId: ${item.menuItemId})');
      }
    } catch (e) {
      _log.warning('Failed to add item to cart: $e');
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to add item to cart',
      ));
    }
  }

  /// Add an item to the cart as a new entry (always creates a new item)
  Future<void> addItemAsNew({
    required FoodModel food,
    required int quantity,
    FoodSize? selectedSize,
    List<FoodExtra>? selectedExtras,
    FoodBeverage? selectedBeverage,
    String? specialInstructions,
  }) async {
    emit(state.copyWith(status: CartStatus.loading));
    
    try {
      // Get current user if authenticated
      UserModel? user;
      try {
        user = UserCubit.instance.state.user;
      } catch (e) {
        _log.warning('UserCubit not initialized, proceeding with guest cart: $e');
      }
      
      _log.info('Adding NEW item to cart: ${food.nameEn} (ID: ${food.id})');
      _log.info('Selected size: ${selectedSize?.nameEn ?? 'None'}');
      _log.info('Selected extras: ${selectedExtras?.map((e) => e.nameEn).join(', ') ?? 'None'}');
      _log.info('Selected beverage: ${selectedBeverage?.nameEn ?? 'None'}');
      
      // Create cart item
      final cartItem = CartItem.fromFoodModel(
        food: food,
        userId: user?.id,
        quantity: quantity,
        selectedSize: selectedSize,
        selectedExtras: selectedExtras,
        selectedBeverage: selectedBeverage,
        specialInstructions: specialInstructions,
      );
      
      // Add to cart as new item
      final updatedCart = await _cartRepository.addNewItemToCart(cartItem, user: user);
      
      emit(state.copyWith(
        status: CartStatus.loaded,
        cart: updatedCart,
        lastAddedItem: cartItem,
      ));
      
      _log.info('New item added to cart. New cart size: ${updatedCart.items.length}');
      
      // Debug log all items in the cart
      for (int i = 0; i < updatedCart.items.length; i++) {
        final item = updatedCart.items[i];
        _log.info('Cart item $i: ${item.name} (ID: ${item.id}, menuItemId: ${item.menuItemId})');
      }
    } catch (e) {
      _log.warning('Failed to add new item to cart: $e');
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to add item to cart',
      ));
    }
  }

  /// Remove an item from the cart
  Future<void> removeItem(String itemId) async {
    emit(state.copyWith(status: CartStatus.loading));
    
    try {
      // Get current user if authenticated
      UserModel? user;
      try {
        user = UserCubit.instance.state.user;
      } catch (e) {
        _log.warning('UserCubit not initialized, proceeding with guest cart: $e');
      }
      
      _log.info('Removing item from cart: $itemId');
      
      // Find the item in the current cart for logging
      final itemToRemove = state.cart.items.firstWhere(
        (item) => item.id == itemId,
        orElse: () => CartItem(
          id: itemId,
          menuItemId: 'unknown',
          name: 'Unknown Item',
          price: 0,
          quantity: 0,
          totalPrice: 0,
          createdAt: DateTime.now(),
        ),
      );
      
      _log.info('Removing item: ${itemToRemove.name} (menuItemId: ${itemToRemove.menuItemId})');
      
      // Remove from cart
      final updatedCart = await _cartRepository.removeItem(itemId, user: user);
      
      _log.info('Item removed. New cart size: ${updatedCart.items.length}');
      
      emit(state.copyWith(
        status: CartStatus.loaded,
        cart: updatedCart,
      ));
      
      // Force a refresh of the cart from storage to ensure UI is updated
      await Future.delayed(const Duration(milliseconds: 300));
      await loadCart();
    } catch (e) {
      _log.warning('Failed to remove item from cart: $e');
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to remove item from cart',
      ));
    }
  }

  /// Update an item in the cart
  Future<void> updateItem(CartItem updatedItem) async {
    emit(state.copyWith(status: CartStatus.loading));
    
    try {
      // Get current user if authenticated
      UserModel? user;
      try {
        user = UserCubit.instance.state.user;
      } catch (e) {
        _log.warning('UserCubit not initialized, proceeding with guest cart: $e');
      }
      
      // Update cart
      final updatedCart = await _cartRepository.updateItem(updatedItem, user: user);
      
      emit(state.copyWith(
        status: CartStatus.loaded,
        cart: updatedCart,
      ));
    } catch (e) {
      _log.warning('Failed to update cart item: $e');
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to update cart item',
      ));
    }
  }

  /// Increment item quantity (QUIET: no loading)
  Future<void> incrementItemQuantity(String itemId) async {
    // --- MODIFIED: Do not emit loading here, just update in place! ---
    try {
      // Get current user if authenticated
      UserModel? user;
      try {
        user = UserCubit.instance.state.user;
      } catch (e) {
        _log.warning('UserCubit not initialized, proceeding with guest cart: $e');
      }
      
      // Increment quantity
      final updatedCart = await _cartRepository.incrementItemQuantity(itemId, user: user);
      
      emit(state.copyWith(
        status: CartStatus.loaded, // Keep as loaded, no spinner
        cart: updatedCart,
      ));
    } catch (e) {
      _log.warning('Failed to increment item quantity: $e');
      // Optionally: emit error but no loading
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to update cart',
      ));
    }
  }

  /// Decrement item quantity (QUIET: no loading)
  Future<void> decrementItemQuantity(String itemId) async {
    // --- MODIFIED: Do not emit loading here, just update in place! ---
    try {
      // Get current user if authenticated
      UserModel? user;
      try {
        user = UserCubit.instance.state.user;
      } catch (e) {
        _log.warning('UserCubit not initialized, proceeding with guest cart: $e');
      }
      
      // Decrement quantity
      final updatedCart = await _cartRepository.decrementItemQuantity(itemId, user: user);
      
      emit(state.copyWith(
        status: CartStatus.loaded, // Keep as loaded, no spinner
        cart: updatedCart,
      ));
    } catch (e) {
      _log.warning('Failed to decrement item quantity: $e');
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to update cart',
      ));
    }
  }

  /// Clear the cart
  Future<void> clearCart() async {
    emit(state.copyWith(status: CartStatus.loading));
    
    try {
      // Get current user if authenticated
      UserModel? user;
      try {
        user = UserCubit.instance.state.user;
      } catch (e) {
        _log.warning('UserCubit not initialized, proceeding with guest cart: $e');
      }
      
      // Clear cart
      final updatedCart = await _cartRepository.clearCart(user: user);
      
      emit(state.copyWith(
        status: CartStatus.loaded,
        cart: updatedCart,
      ));
      
      _log.info('Cart cleared successfully');
    } catch (e) {
      _log.warning('Failed to clear cart: $e');
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to clear cart',
      ));
    }
  }

  /// Set special instructions for the order
  Future<void> setSpecialInstructions(String? instructions) async {
    emit(state.copyWith(status: CartStatus.loading));
    
    try {
      // Get current user if authenticated
      UserModel? user;
      try {
        user = UserCubit.instance.state.user;
      } catch (e) {
        _log.warning('UserCubit not initialized, proceeding with guest cart: $e');
      }
      
      // Set instructions
      final updatedCart = await _cartRepository.setSpecialInstructions(instructions, user: user);
      
      emit(state.copyWith(
        status: CartStatus.loaded,
        cart: updatedCart,
      ));
    } catch (e) {
      _log.warning('Failed to set special instructions: $e');
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to update cart',
      ));
    }
  }

  /// Set delivery type (delivery or pickup)
  Future<void> setDeliveryType(String type) async {
    emit(state.copyWith(status: CartStatus.loading));
    
    try {
      // Get current user if authenticated
      UserModel? user;
      try {
        user = UserCubit.instance.state.user;
      } catch (e) {
        _log.warning('UserCubit not initialized, proceeding with guest cart: $e');
      }
      
      // Set delivery type
      final updatedCart = await _cartRepository.setDeliveryType(type, user: user);
      
      emit(state.copyWith(
        status: CartStatus.loaded,
        cart: updatedCart,
      ));
    } catch (e) {
      _log.warning('Failed to set delivery type: $e');
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to update cart',
      ));
    }
  }

  /// Sync cart when user logs in
  Future<void> syncCartOnLogin(UserModel user) async {
    emit(state.copyWith(status: CartStatus.loading));
    
    try {
      // Sync cart
      final updatedCart = await _cartRepository.syncCartOnLogin(user);
      
      emit(state.copyWith(
        status: CartStatus.loaded,
        cart: updatedCart,
      ));
    } catch (e) {
      _log.warning('Failed to sync cart on login: $e');
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: 'Failed to sync cart',
      ));
    }
  }

  /// Force refresh the cart from storage
  Future<void> refreshCart() async {
    _log.info('Forcing cart refresh');
    await loadCart();
  }

  /// Check if an item is in the cart
  bool isItemInCart(String menuItemId) {
    return state.cart.items.any((item) => item.menuItemId == menuItemId);
  }

  /// Get the total number of items in the cart
  int get itemCount => state.cart.itemCount;

  /// Check if the cart is empty
  bool get isEmpty => state.cart.isEmpty;

  /// Check if the cart has items
  bool get isNotEmpty => state.cart.isNotEmpty;
}

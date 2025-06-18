import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/features/home/data/models/food_model.dart';
import 'package:uuid/uuid.dart';

/// Represents a cart item
class CartItem extends Equatable {
  final String id;
  final String? userId;
  final String menuItemId;
  final String name;
  final String? photoUrl;
  final double price;
  final int quantity;
  final FoodSize? selectedSize;
  final List<FoodExtra> selectedExtras;
  final FoodBeverage? selectedBeverage;
  final double totalPrice;
  final String? specialInstructions;
  final DateTime createdAt;
  
  static final Logger _log = Logger('CartItem');

  const CartItem({
    required this.id,
    this.userId,
    required this.menuItemId,
    required this.name,
    this.photoUrl,
    required this.price,
    required this.quantity,
    this.selectedSize,
    this.selectedExtras = const [],
    this.selectedBeverage,
    required this.totalPrice,
    this.specialInstructions,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        menuItemId,
        name,
        photoUrl,
        price,
        quantity,
        selectedSize,
        selectedExtras,
        selectedBeverage,
        totalPrice,
        specialInstructions,
        createdAt,
      ];

  /// Create a copy of the cart item with some properties changed
  CartItem copyWith({
    String? id,
    String? userId,
    String? menuItemId,
    String? name,
    String? photoUrl,
    double? price,
    int? quantity,
    FoodSize? selectedSize,
    List<FoodExtra>? selectedExtras,
    FoodBeverage? selectedBeverage,
    double? totalPrice,
    String? specialInstructions,
    DateTime? createdAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      menuItemId: menuItemId ?? this.menuItemId,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedExtras: selectedExtras ?? this.selectedExtras,
      selectedBeverage: selectedBeverage ?? this.selectedBeverage,
      totalPrice: totalPrice ?? this.totalPrice,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Create a cart item from a food model and selected options
  factory CartItem.fromFoodModel({
    required FoodModel food,
    String? userId,
    required int quantity,
    FoodSize? selectedSize,
    List<FoodExtra>? selectedExtras,
    FoodBeverage? selectedBeverage,
    String? specialInstructions,
  }) {
    // Calculate the total price for a single item
    double itemPrice = food.price;
    
    // Add size price if selected
    if (selectedSize != null) {
      itemPrice += selectedSize.price;
    }
    
    // Add extras prices
    if (selectedExtras != null && selectedExtras.isNotEmpty) {
      for (final extra in selectedExtras) {
        itemPrice += extra.price;
      }
    }
    
    // Add beverage price if selected
    if (selectedBeverage != null) {
      itemPrice += selectedBeverage.price;
    }
    
    // Calculate total price (item price * quantity)
    final totalPrice = itemPrice * quantity;
    
    _log.info('Creating cart item for ${food.nameEn} with id ${food.id}');
    
    return CartItem(
      id: const Uuid().v4(),
      userId: userId,
      menuItemId: food.id,
      name: food.nameEn,
      photoUrl: food.photoUrl,
      price: itemPrice,
      quantity: quantity,
      selectedSize: selectedSize,
      selectedExtras: selectedExtras ?? const [],
      selectedBeverage: selectedBeverage,
      totalPrice: totalPrice,
      specialInstructions: specialInstructions,
      createdAt: DateTime.now(),
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    // Create customization JSON for Supabase
    final Map<String, dynamic> customization = {
      'size': selectedSize?.toJson(),
      'extras': selectedExtras.map((e) => e.toJson()).toList(),
      'beverage': selectedBeverage?.toJson(),
      'specialInstructions': specialInstructions,
    };

    // Return the main JSON structure
    return {
      'id': id,
      'user_id': userId,
      'menu_item_id': menuItemId,
      'quantity': quantity,
      'customization': customization,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON from Supabase
  factory CartItem.fromJson(Map<String, dynamic> json, {FoodModel? foodDetails}) {
    try {
      // Parse customization
      final customization = json['customization'] as Map<String, dynamic>? ?? {};
      
      // Parse size
      FoodSize? selectedSize;
      if (customization['size'] != null) {
        selectedSize = FoodSize.fromJson(customization['size']);
      }
      
      // Parse extras
      List<FoodExtra> selectedExtras = [];
      if (customization['extras'] != null && customization['extras'] is List) {
        selectedExtras = (customization['extras'] as List)
            .map((e) => FoodExtra.fromJson(e))
            .toList();
      }
      
      // Parse beverage
      FoodBeverage? selectedBeverage;
      if (customization['beverage'] != null) {
        selectedBeverage = FoodBeverage.fromJson(customization['beverage']);
      }

      // Use food details if provided, otherwise use minimal info
      String name = foodDetails?.nameEn ?? 'Unknown Item';
      String? photoUrl = foodDetails?.photoUrl;
      double price = foodDetails?.price ?? 0.0;
      
      // Calculate total price
      double itemPrice = price;
      if (selectedSize != null) itemPrice += selectedSize.price;
      for (var extra in selectedExtras) {
        itemPrice += extra.price;
      }
      if (selectedBeverage != null) itemPrice += selectedBeverage.price;
      
      final quantity = json['quantity'] as int? ?? 1;
      final totalPrice = itemPrice * quantity;

      return CartItem(
        id: json['id'] as String? ?? const Uuid().v4(),
        userId: json['user_id'] as String?,
        menuItemId: json['menu_item_id'] as String? ?? '',
        name: name,
        photoUrl: photoUrl,
        price: itemPrice,
        quantity: quantity,
        selectedSize: selectedSize,
        selectedExtras: selectedExtras,
        selectedBeverage: selectedBeverage,
        totalPrice: totalPrice,
        specialInstructions: customization['specialInstructions'] as String?,
        createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
      );
    } catch (e) {
      _log.warning('Failed to parse cart item from JSON: $e');
      // If parsing fails, return a minimal valid item
      return CartItem(
        id: const Uuid().v4(),
        menuItemId: json['menu_item_id'] as String? ?? '',
        name: 'Unknown Item',
        price: 0.0,
        quantity: 1,
        totalPrice: 0.0,
        createdAt: DateTime.now(),
      );
    }
  }

  /// Increment quantity
  CartItem incrementQuantity() {
    final newQuantity = quantity + 1;
    final pricePerItem = totalPrice / quantity;
    final newTotalPrice = pricePerItem * newQuantity;
    return copyWith(quantity: newQuantity, totalPrice: newTotalPrice);
  }

  /// Decrement quantity
  CartItem decrementQuantity() {
    if (quantity <= 1) return this;
    final newQuantity = quantity - 1;
    final pricePerItem = totalPrice / quantity;
    final newTotalPrice = pricePerItem * newQuantity;
    return copyWith(quantity: newQuantity, totalPrice: newTotalPrice);
  }
  
  /// Check if this item is the same as another (ignoring quantity and ID)
  bool isSameItemAs(CartItem other) {
    // Check if menu item ID matches
    if (menuItemId != other.menuItemId) {
      return false;
    }
    
    // Check if size matches
    if ((selectedSize == null && other.selectedSize != null) ||
        (selectedSize != null && other.selectedSize == null)) {
      return false;
    }
    
    if (selectedSize != null && other.selectedSize != null &&
        selectedSize!.nameEn != other.selectedSize!.nameEn) {
      return false;
    }
    
    // Check if beverage matches
    if ((selectedBeverage == null && other.selectedBeverage != null) ||
        (selectedBeverage != null && other.selectedBeverage == null)) {
      return false;
    }
    
    if (selectedBeverage != null && other.selectedBeverage != null &&
        selectedBeverage!.nameEn != other.selectedBeverage!.nameEn) {
      return false;
    }
    
    // Check if extras match
    if (selectedExtras.length != other.selectedExtras.length) {
      return false;
    }
    
    for (final extra in selectedExtras) {
      if (!other.selectedExtras.any((e) => e.nameEn == extra.nameEn)) {
        return false;
      }
    }
    
    return true;
  }
}

/// Represents a cart with multiple items
class Cart extends Equatable {
  final List<CartItem> items;
  final String? specialInstructions;
  final String deliveryType;
  
  static final Logger _log = Logger('Cart');

  const Cart({
    this.items = const [],
    this.specialInstructions,
    this.deliveryType = 'delivery',
  });

  @override
  List<Object?> get props => [items, specialInstructions, deliveryType];

  /// Create a copy of the cart with some properties changed
  Cart copyWith({
    List<CartItem>? items,
    String? specialInstructions,
    String? deliveryType,
  }) {
    return Cart(
      items: items ?? this.items,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      deliveryType: deliveryType ?? this.deliveryType,
    );
  }

  /// Get the total price of all items in the cart
  double get totalPrice {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  /// Get the subtotal (before tax)
  double get subtotal {
    return totalPrice;
  }

  /// Get the VAT amount (14%)
  double get vat {
    return subtotal * 0.14;
  }

  /// Get the final total including VAT
  double get finalTotal {
    return subtotal + vat;
  }

  /// Get the total number of items in the cart
  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Check if the cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if the cart has items
  bool get isNotEmpty => items.isNotEmpty;

  /// Add an item to the cart
  Cart addItem(CartItem item) {
    _log.info('Adding item to cart: ${item.name}, ID: ${item.menuItemId}');
    
    // Check if the item already exists with the same options
    final existingItemIndex = items.indexWhere((existingItem) => existingItem.isSameItemAs(item));

    if (existingItemIndex != -1) {
      _log.info('Found existing item at index $existingItemIndex, updating quantity');
      // Update the existing item's quantity
      final existingItem = items[existingItemIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
        totalPrice: existingItem.totalPrice + item.totalPrice,
      );

      final updatedItems = List<CartItem>.from(items);
      updatedItems[existingItemIndex] = updatedItem;

      return copyWith(items: updatedItems);
    } else {
      _log.info('Adding as new item, cart will have ${items.length + 1} items');
      // Add as a new item
      return copyWith(items: [...items, item]);
    }
  }

  /// Remove an item from the cart
  Cart removeItem(String itemId) {
    _log.info('Removing item with ID: $itemId');
    final newItems = items.where((item) => item.id != itemId).toList();
    _log.info('Cart now has ${newItems.length} items (was ${items.length})');
    return copyWith(items: newItems);
  }

  /// Update an item in the cart
  Cart updateItem(CartItem updatedItem) {
    final updatedItems = items.map((item) => 
      item.id == updatedItem.id ? updatedItem : item
    ).toList();
    
    return copyWith(items: updatedItems);
  }

  /// Clear all items from the cart
  Cart clearItems() {
    _log.info('Clearing all items from cart');
    return copyWith(items: []);
  }

  /// Set special instructions for the entire order
  Cart setSpecialInstructions(String? instructions) {
    return copyWith(specialInstructions: instructions);
  }

  /// Set delivery type (delivery or pickup)
  Cart setDeliveryType(String type) {
    return copyWith(deliveryType: type);
  }

  /// Helper method to compare two lists of extras
  bool _areExtrasEqual(List<FoodExtra> list1, List<FoodExtra> list2) {
    if (list1.length != list2.length) return false;
    
    for (int i = 0; i < list1.length; i++) {
      if (!list2.any((e) => e.nameEn == list1[i].nameEn)) {
        return false;
      }
    }
    
    return true;
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'specialInstructions': specialInstructions,
      'deliveryType': deliveryType,
    };
  }

  /// Create from JSON for storage
  factory Cart.fromJson(Map<String, dynamic> json) {
    try {
      final itemsList = json['items'] as List?;
      final items = itemsList != null 
          ? itemsList.map((e) => CartItem.fromJson(e as Map<String, dynamic>)).toList() 
          : <CartItem>[];
      
      return Cart(
        items: items,
        specialInstructions: json['specialInstructions'] as String?,
        deliveryType: json['deliveryType'] as String? ?? 'delivery',
      );
    } catch (e) {
      _log.warning('Failed to parse cart from JSON: $e');
      // If parsing fails, return an empty cart
      return const Cart();
    }
  }
} 
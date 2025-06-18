import 'package:equatable/equatable.dart';
import 'package:meals_app/features/cart/data/models/cart_model.dart';

enum CartStatus {
  initial,
  loading,
  loaded,
  error,
}

class CartState extends Equatable {
  final Cart cart;
  final CartStatus status;
  final String? errorMessage;
  final CartItem? lastAddedItem;

  const CartState({
    this.cart = const Cart(),
    this.status = CartStatus.initial,
    this.errorMessage,
    this.lastAddedItem,
  });

  @override
  List<Object?> get props => [cart, status, errorMessage, lastAddedItem];

  CartState copyWith({
    Cart? cart,
    CartStatus? status,
    String? errorMessage,
    CartItem? lastAddedItem,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      status: status ?? this.status,
      errorMessage: errorMessage,
      lastAddedItem: lastAddedItem ?? this.lastAddedItem,
    );
  }
} 
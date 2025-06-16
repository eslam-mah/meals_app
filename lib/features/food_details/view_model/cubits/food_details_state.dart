import 'package:equatable/equatable.dart';
import 'package:meals_app/features/home/data/models/food_model.dart';

enum FoodDetailsStatus {
  initial,
  loading,
  loaded,
  error,
}

class FoodDetailsState extends Equatable {
  final FoodModel? food;
  final FoodDetailsStatus status;
  final String? errorMessage;
  
  // Selected options
  final FoodSize? selectedSize;
  final List<FoodExtra> selectedExtras;
  final FoodBeverage? selectedBeverage;
  
  // Total price calculation
  final double totalPrice;

  const FoodDetailsState({
    this.food,
    this.status = FoodDetailsStatus.initial,
    this.errorMessage,
    this.selectedSize,
    this.selectedExtras = const [],
    this.selectedBeverage,
    this.totalPrice = 0.0,
  });

  @override
  List<Object?> get props => [
    food,
    status,
    errorMessage,
    selectedSize,
    selectedExtras,
    selectedBeverage,
    totalPrice,
  ];

  FoodDetailsState copyWith({
    FoodModel? food,
    FoodDetailsStatus? status,
    String? errorMessage,
    FoodSize? selectedSize,
    List<FoodExtra>? selectedExtras,
    FoodBeverage? selectedBeverage,
    double? totalPrice,
  }) {
    return FoodDetailsState(
      food: food ?? this.food,
      status: status ?? this.status,
      errorMessage: errorMessage,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedExtras: selectedExtras ?? this.selectedExtras,
      selectedBeverage: selectedBeverage ?? this.selectedBeverage,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
  
  // Calculate the total price based on selected options
  double calculateTotalPrice() {
    if (food == null) return 0.0;
    
    double total = food!.price;
    
    // Add size price if selected
    if (selectedSize != null) {
      total += selectedSize!.price;
    }
    
    // Add extras prices
    for (final extra in selectedExtras) {
      total += extra.price;
    }
    
    // Add beverage price if selected
    if (selectedBeverage != null) {
      total += selectedBeverage!.price;
    }
    
    return total;
  }
} 
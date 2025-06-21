import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/features/food_details/view_model/cubits/food_details_state.dart';
import 'package:meals_app/features/home/data/models/food_model.dart';
import 'package:meals_app/features/home/data/repositories/food_repository.dart';
import 'package:intl/intl.dart';

class FoodDetailsCubit extends Cubit<FoodDetailsState> {
  final FoodRepository _foodRepository;
  final Logger _log = Logger('FoodDetailsCubit');
  
  // Static instance for easy global access
  static FoodDetailsCubit? instance;
  
  /// Initialize the static instance
  static void initialize(FoodRepository repository) {
    instance ??= FoodDetailsCubit._internal(repository);
  }
  
  // Private constructor
  FoodDetailsCubit._internal(this._foodRepository) : super(const FoodDetailsState());
  
  // Public constructor for dependency injection (used by BlocProvider)
  FoodDetailsCubit({required FoodRepository foodRepository}) 
    : _foodRepository = foodRepository,
      super(const FoodDetailsState()) {
    instance ??= this;
  }
  
  /// Load food details by ID
  Future<void> loadFoodDetails(String foodId) async {
    try {
      emit(state.copyWith(status: FoodDetailsStatus.loading));
      
      final food = await _foodRepository.getFoodItemById(foodId);
      
      // Set default selections if available
      FoodSize? defaultSize;
      if (food.sizes.isNotEmpty) {
        defaultSize = food.sizes.first;
      }
      
      // Calculate initial price
      final initialState = state.copyWith(
        food: food,
        status: FoodDetailsStatus.loaded,
        selectedSize: defaultSize,
        selectedExtras: const [],
        selectedBeverage: null,
      );
      
      emit(initialState.copyWith(
        totalPrice: initialState.calculateTotalPrice(),
      ));
    } catch (e) {
      _log.severe('Error loading food details: $e');
      emit(state.copyWith(
        status: FoodDetailsStatus.error,
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'فشل في تحميل تفاصيل الطعام'
            : 'Failed to load food details',
      ));
    }
  }
  
  /// Set the selected size
  void selectSize(FoodSize? size) {
    final updatedState = state.copyWith(selectedSize: size);
    emit(updatedState.copyWith(
      totalPrice: updatedState.calculateTotalPrice(),
    ));
  }
  
  /// Toggle an extra selection
  void toggleExtra(FoodExtra extra) {
    final currentExtras = List<FoodExtra>.from(state.selectedExtras);
    
    if (currentExtras.contains(extra)) {
      currentExtras.remove(extra);
    } else {
      currentExtras.add(extra);
    }
    
    final updatedState = state.copyWith(selectedExtras: currentExtras);
    emit(updatedState.copyWith(
      totalPrice: updatedState.calculateTotalPrice(),
    ));
  }
  
  /// Set the selected beverage
  void selectBeverage(FoodBeverage? beverage) {
    final updatedState = state.copyWith(selectedBeverage: beverage);
    emit(updatedState.copyWith(
      totalPrice: updatedState.calculateTotalPrice(),
    ));
  }
  
  /// Reset selections
  void resetSelections() {
    FoodSize? defaultSize;
    if (state.food?.sizes.isNotEmpty ?? false) {
      defaultSize = state.food!.sizes.first;
    }
    
    final updatedState = state.copyWith(
      selectedSize: defaultSize,
      selectedExtras: const [],
      selectedBeverage: null,
    );
    
    emit(updatedState.copyWith(
      totalPrice: updatedState.calculateTotalPrice(),
    ));
  }
} 
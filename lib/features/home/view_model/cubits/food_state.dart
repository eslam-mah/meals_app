import 'package:equatable/equatable.dart';
import 'package:meals_app/features/home/data/models/food_model.dart';

enum FoodStatus {
  initial,
  loading,
  loaded,
  error,
  loadingMore,
}

class FoodState extends Equatable {
  final List<FoodModel> recommendedItems;
  final List<FoodModel> offerItems;
  final List<FoodModel> menuItems;
  final FoodStatus recommendedStatus;
  final FoodStatus offerStatus;
  final FoodStatus menuStatus;
  final String? errorMessage;
  final bool hasMoreRecommended;
  final bool hasMoreOffers;
  final bool hasMoreMenu;
  final int recommendedPage;
  final int offerPage;
  final int menuPage;

  const FoodState({
    this.recommendedItems = const [],
    this.offerItems = const [],
    this.menuItems = const [],
    this.recommendedStatus = FoodStatus.initial,
    this.offerStatus = FoodStatus.initial,
    this.menuStatus = FoodStatus.initial,
    this.errorMessage,
    this.hasMoreRecommended = true,
    this.hasMoreOffers = true,
    this.hasMoreMenu = true,
    this.recommendedPage = 0,
    this.offerPage = 0,
    this.menuPage = 0,
  });

  @override
  List<Object?> get props => [
        recommendedItems,
        offerItems,
        menuItems,
        recommendedStatus,
        offerStatus,
        menuStatus,
        errorMessage,
        hasMoreRecommended,
        hasMoreOffers,
        hasMoreMenu,
        recommendedPage,
        offerPage,
        menuPage,
      ];

  FoodState copyWith({
    List<FoodModel>? recommendedItems,
    List<FoodModel>? offerItems,
    List<FoodModel>? menuItems,
    FoodStatus? recommendedStatus,
    FoodStatus? offerStatus,
    FoodStatus? menuStatus,
    String? errorMessage,
    bool? hasMoreRecommended,
    bool? hasMoreOffers,
    bool? hasMoreMenu,
    int? recommendedPage,
    int? offerPage,
    int? menuPage,
  }) {
    return FoodState(
      recommendedItems: recommendedItems ?? this.recommendedItems,
      offerItems: offerItems ?? this.offerItems,
      menuItems: menuItems ?? this.menuItems,
      recommendedStatus: recommendedStatus ?? this.recommendedStatus,
      offerStatus: offerStatus ?? this.offerStatus,
      menuStatus: menuStatus ?? this.menuStatus,
      errorMessage: errorMessage,
      hasMoreRecommended: hasMoreRecommended ?? this.hasMoreRecommended,
      hasMoreOffers: hasMoreOffers ?? this.hasMoreOffers,
      hasMoreMenu: hasMoreMenu ?? this.hasMoreMenu,
      recommendedPage: recommendedPage ?? this.recommendedPage,
      offerPage: offerPage ?? this.offerPage,
      menuPage: menuPage ?? this.menuPage,
    );
  }
} 
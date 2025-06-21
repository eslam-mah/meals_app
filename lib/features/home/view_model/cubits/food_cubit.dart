import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/features/home/data/models/food_model.dart';
import 'package:meals_app/features/home/data/repositories/food_repository.dart';
import 'package:meals_app/features/home/view_model/cubits/food_state.dart';
import 'package:intl/intl.dart';

class FoodCubit extends Cubit<FoodState> {
  final FoodRepository _foodRepository;
  final Logger _log = Logger('FoodCubit');
  
  // Static instance for easy global access
  static FoodCubit? _instance;
  static FoodCubit get instance => _instance!;
  
  /// Initialize the static instance
  static void initialize(FoodRepository repository) {
    _instance ??= FoodCubit._internal(repository);
  }
  
  // Private constructor
  FoodCubit._internal(this._foodRepository) : super(const FoodState());
  
  // Public constructor for dependency injection (used by BlocProvider)
  FoodCubit({required FoodRepository foodRepository}) 
    : _foodRepository = foodRepository,
      super(const FoodState()) {
    _instance ??= this;
  }
  
  /// Load initial data for all food categories
  Future<void> loadInitialData() async {
    _log.info('Loading initial food data');
    
    // Load all categories in parallel
    await Future.wait([
      loadRecommendedItems(),
      loadOfferItems(),
      loadMenuItems(),
    ]);
  }
  
  /// Load recommended items
  Future<void> loadRecommendedItems({bool refresh = false}) async {
    try {
      if (refresh) {
        emit(state.copyWith(
          recommendedStatus: FoodStatus.loading,
          recommendedPage: 0,
          hasMoreRecommended: true,
        ));
      } else if (state.recommendedStatus == FoodStatus.loading) {
        // Avoid duplicate loading
        return;
      } else {
        emit(state.copyWith(recommendedStatus: FoodStatus.loading));
      }
      
      final items = await _foodRepository.getRecommendedItems(
        page: refresh ? 0 : state.recommendedPage,
      );
      
      emit(state.copyWith(
        recommendedItems: refresh ? items : [...state.recommendedItems, ...items],
        recommendedStatus: FoodStatus.loaded,
        hasMoreRecommended: items.length >= 10,
        recommendedPage: refresh ? 1 : state.recommendedPage + 1,
      ));
    } catch (e) {
      _log.severe('Error loading recommended items: $e');
      emit(state.copyWith(
        recommendedStatus: FoodStatus.error,
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'فشل في تحميل العناصر الموصى بها'
            : 'Failed to load recommended items',
      ));
    }
  }
  
  /// Load more recommended items
  Future<void> loadMoreRecommendedItems() async {
    if (!state.hasMoreRecommended || 
        state.recommendedStatus == FoodStatus.loadingMore) {
      return;
    }
    
    try {
      emit(state.copyWith(recommendedStatus: FoodStatus.loadingMore));
      
      final items = await _foodRepository.getRecommendedItems(
        page: state.recommendedPage,
      );
      
      emit(state.copyWith(
        recommendedItems: [...state.recommendedItems, ...items],
        recommendedStatus: FoodStatus.loaded,
        hasMoreRecommended: items.length >= 10,
        recommendedPage: state.recommendedPage + 1,
      ));
    } catch (e) {
      _log.severe('Error loading more recommended items: $e');
      emit(state.copyWith(
        recommendedStatus: FoodStatus.error,
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'فشل في تحميل المزيد من العناصر الموصى بها'
            : 'Failed to load more recommended items',
      ));
    }
  }
  
  /// Load offer items
  Future<void> loadOfferItems({bool refresh = false}) async {
    try {
      if (refresh) {
        emit(state.copyWith(
          offerStatus: FoodStatus.loading,
          offerPage: 0,
          hasMoreOffers: true,
        ));
      } else if (state.offerStatus == FoodStatus.loading) {
        // Avoid duplicate loading
        return;
      } else {
        emit(state.copyWith(offerStatus: FoodStatus.loading));
      }
      
      final items = await _foodRepository.getOfferItems(
        page: refresh ? 0 : state.offerPage,
      );
      
      emit(state.copyWith(
        offerItems: refresh ? items : [...state.offerItems, ...items],
        offerStatus: FoodStatus.loaded,
        hasMoreOffers: items.length >= 10,
        offerPage: refresh ? 1 : state.offerPage + 1,
      ));
    } catch (e) {
      _log.severe('Error loading offer items: $e');
      emit(state.copyWith(
        offerStatus: FoodStatus.error,
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'فشل في تحميل عناصر العروض'
            : 'Failed to load offer items',
      ));
    }
  }
  
  /// Load more offer items
  Future<void> loadMoreOfferItems() async {
    if (!state.hasMoreOffers || 
        state.offerStatus == FoodStatus.loadingMore) {
      return;
    }
    
    try {
      emit(state.copyWith(offerStatus: FoodStatus.loadingMore));
      
      final items = await _foodRepository.getOfferItems(
        page: state.offerPage,
      );
      
      emit(state.copyWith(
        offerItems: [...state.offerItems, ...items],
        offerStatus: FoodStatus.loaded,
        hasMoreOffers: items.length >= 10,
        offerPage: state.offerPage + 1,
      ));
    } catch (e) {
      _log.severe('Error loading more offer items: $e');
      emit(state.copyWith(
        offerStatus: FoodStatus.error,
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'فشل في تحميل المزيد من عناصر العروض'
            : 'Failed to load more offer items',
      ));
    }
  }
  
  /// Load menu items
  Future<void> loadMenuItems({bool refresh = false}) async {
    try {
      if (refresh) {
        emit(state.copyWith(
          menuStatus: FoodStatus.loading,
          menuPage: 0,
          hasMoreMenu: true,
        ));
      } else if (state.menuStatus == FoodStatus.loading) {
        // Avoid duplicate loading
        return;
      } else {
        emit(state.copyWith(menuStatus: FoodStatus.loading));
      }
      
      final items = await _foodRepository.getMenuItems(
        page: refresh ? 0 : state.menuPage,
      );
      
      emit(state.copyWith(
        menuItems: refresh ? items : [...state.menuItems, ...items],
        menuStatus: FoodStatus.loaded,
        hasMoreMenu: items.length >= 10,
        menuPage: refresh ? 1 : state.menuPage + 1,
      ));
    } catch (e) {
      _log.severe('Error loading menu items: $e');
      emit(state.copyWith(
        menuStatus: FoodStatus.error,
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'فشل في تحميل عناصر القائمة'
            : 'Failed to load menu items',
      ));
    }
  }
  
  /// Load more menu items
  Future<void> loadMoreMenuItems() async {
    if (!state.hasMoreMenu || 
        state.menuStatus == FoodStatus.loadingMore) {
      return;
    }
    
    try {
      emit(state.copyWith(menuStatus: FoodStatus.loadingMore));
      
      final items = await _foodRepository.getMenuItems(
        page: state.menuPage,
      );
      
      emit(state.copyWith(
        menuItems: [...state.menuItems, ...items],
        menuStatus: FoodStatus.loaded,
        hasMoreMenu: items.length >= 10,
        menuPage: state.menuPage + 1,
      ));
    } catch (e) {
      _log.severe('Error loading more menu items: $e');
      emit(state.copyWith(
        menuStatus: FoodStatus.error,
        errorMessage: Intl.getCurrentLocale() == 'ar'
            ? 'فشل في تحميل المزيد من عناصر القائمة'
            : 'Failed to load more menu items',
      ));
    }
  }
} 
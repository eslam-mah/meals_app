import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/core/config/assets_box.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/utils/media_query_values.dart';
import 'package:meals_app/features/cart/data/models/cart_model.dart';
import 'package:meals_app/features/cart/data/repositories/cart_repository.dart';
import 'package:meals_app/features/cart/view_model/cubits/cart_cubit.dart';
import 'package:meals_app/features/cart/view_model/cubits/cart_state.dart';
import 'package:meals_app/features/food_details/view/widgets/add_to_cart_button.dart';
import 'package:meals_app/features/food_details/view/widgets/beverage_selector.dart';
import 'package:meals_app/features/food_details/view/widgets/extras_selector.dart';
import 'package:meals_app/features/food_details/view/widgets/size_selector.dart';
import 'package:meals_app/features/food_details/view_model/cubits/food_details_cubit.dart';
import 'package:meals_app/features/food_details/view_model/cubits/food_details_state.dart';
import 'package:meals_app/features/home/view/views/main_view.dart';
import 'package:meals_app/features/profile/data/models/user_model.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/generated/l10n.dart';
import 'package:uuid/uuid.dart';

class FoodDetailsScreen extends StatefulWidget {
  static const String routeName = '/food-details';
  final String? foodId;
  
  const FoodDetailsScreen({super.key, this.foodId});

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  bool _isAddingToCart = false;
  final Logger _log = Logger('FoodDetailsScreen');

  @override
  void initState() {
    super.initState();
    _loadFoodDetails();
  }
  
  void _loadFoodDetails() {
    if (widget.foodId != null) {
      // Load food details using the BlocProvider
      Future.microtask(() => 
        context.read<FoodDetailsCubit>().loadFoodDetails(widget.foodId!)
      );
    }
  }

  void _addToCart(BuildContext context, FoodDetailsState state) async {
    if (state.food == null) return;
    
    setState(() {
      _isAddingToCart = true;
    });
    
    _log.info('Adding item to cart: ${state.food!.nameEn}');
    
    try {
      // Get the repository directly
      final cartRepository = RepositoryProvider.of<CartRepository>(context);
      
      // Get current user if authenticated
      UserModel? user;
      try {
        user = UserCubit.instance.state.user;
      } catch (e) {
        _log.warning('UserCubit not initialized, proceeding with guest cart');
      }
      
      // Create cart item with a new UUID
      final cartItem = CartItem.fromFoodModel(
        food: state.food!,
        userId: user?.id,
        quantity: 1,
        selectedSize: state.selectedSize,
        selectedExtras: state.selectedExtras,
        selectedBeverage: state.selectedBeverage,
      );
      
      _log.info('Created cart item with ID: ${cartItem.id}');
      
      // Add as new item directly using the repository
      cartRepository.addNewItemToCart(cartItem, user: user).then((updatedCart) {
        _log.info('Item added successfully. Cart now has ${updatedCart.items.length} items');
        
        // Update the CartCubit state
        context.read<CartCubit>().refreshCart();
        
        setState(() {
          _isAddingToCart = false;
        });
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).addedToCart),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            margin: EdgeInsets.all(10.r),
          ),
        );
        
        // Pop back after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            GoRouter.of(context).push(MainView.mainPath);
          }
        });
      }).catchError((error) {
        _log.severe('Failed to add item to cart: $error');
        
        setState(() {
          _isAddingToCart = false;
        });
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).failedToAddToCart),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      });
    } catch (e) {
      _log.severe('Error in _addToCart: $e');
      
      setState(() {
        _isAddingToCart = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).failedToAddToCart),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    
    return BlocBuilder<FoodDetailsCubit, FoodDetailsState>(
      builder: (context, state) {
        if (state.status == FoodDetailsStatus.loading) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => GoRouter.of(context).pop(),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (state.status == FoodDetailsStatus.error) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => GoRouter.of(context).pop(),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage ?? l10n.tryAgain,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: _loadFoodDetails,
                    child: Text(l10n.tryAgain),
                  ),
                ],
              ),
            ),
          );
        }
        
        final food = state.food;
        if (food == null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => GoRouter.of(context).pop(),
              ),
            ),
            body: Center(
              child: Text(l10n.noInternetConnection),
            ),
          );
        }
        
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => GoRouter.of(context).pop(),
            ),
            actions: [
              // Cart button with indicator
              BlocBuilder<CartCubit, CartState>(
                builder: (context, cartState) {
                  final itemCount = cartState.cart.itemCount;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          if (cartState.cart.isNotEmpty) {
                            GoRouter.of(context).push('/cart');
                          }
                        },
                      ),
                      if (itemCount > 0)
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: Container(
                            padding: EdgeInsets.all(4.r),
                            decoration: BoxDecoration(
                              color: ColorsBox.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16.r,
                              minHeight: 16.r,
                            ),
                            child: Text(
                              itemCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food Image
                  Center(
                    child: SizedBox(
                      height: context.height * 0.25,
                      width: context.width,
                      child: food.photoUrl != null && food.photoUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: food.photoUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorsBox.primaryColor,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              AssetsBox.logo,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Image.asset(
                            AssetsBox.logo,
                            fit: BoxFit.contain,
                          ),
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Food Title
                  Text(
                    food.nameEn,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  // Description
                  Text(
                    food.descriptionEn ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Base Price
                  Text(
                    'EGP ${food.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorsBox.primaryColor,
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Size Section (if available)
                  if (food.sizes.isNotEmpty) ...[
                    Text(
                      l10n.size,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizeSelector(
                      sizes: food.sizes,
                      selectedSize: state.selectedSize,
                      onSizeSelected: (size) => 
                          context.read<FoodDetailsCubit>().selectSize(size),
                    ),
                    SizedBox(height: 24.h),
                  ],
                  
                  // Extras Section (if available)
                  if (food.extras.isNotEmpty) ...[
                    Text(
                      l10n.extras,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    ExtrasSelector(
                      extras: food.extras,
                      selectedExtras: state.selectedExtras,
                      onExtraToggled: (extra) => 
                          context.read<FoodDetailsCubit>().toggleExtra(extra),
                    ),
                    SizedBox(height: 24.h),
                  ],
                  
                  // Beverage Section (if available)
                  if (food.beverages.isNotEmpty) ...[
                    Text(
                      l10n.beverage,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    BeverageSelector(
                      beverages: food.beverages,
                      selectedBeverage: state.selectedBeverage,
                      onBeverageSelected: (beverage) => 
                          context.read<FoodDetailsCubit>().selectBeverage(beverage),
                    ),
                    SizedBox(height: 24.h),
                  ],
                  
                  // Total Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.total,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'EGP ${state.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorsBox.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: AddToCartButton(
              price: state.totalPrice,
              isLoading: _isAddingToCart,
              onPressed: () => _addToCart(context, state),
            ),
          ),
        );
      },
    );
  }
} 
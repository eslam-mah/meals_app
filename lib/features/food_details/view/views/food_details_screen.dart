import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/core/config/assets_box.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/utils/media_query_values.dart';
import 'package:meals_app/features/cart/data/models/cart_model.dart';
import 'package:meals_app/features/cart/data/repositories/cart_repository.dart';
import 'package:meals_app/features/cart/view_model/cubits/cart_cubit.dart';
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
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      Future.microtask(
        () => context.read<FoodDetailsCubit>().loadFoodDetails(widget.foodId!),
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
      final cartRepository = RepositoryProvider.of<CartRepository>(context);

      UserModel? user;
      try {
        user = UserCubit.instance.state.user;
      } catch (e) {
        _log.warning('UserCubit not initialized, proceeding with guest cart');
      }

      final cartItem = CartItem.fromFoodModel(
        food: state.food!,
        userId: user?.id,
        quantity: 1,
        selectedSize: state.selectedSize,
        selectedExtras: state.selectedExtras,
        selectedBeverage: state.selectedBeverage,
      );

      _log.info('Created cart item with ID: ${cartItem.id}');

      cartRepository
          .addNewItemToCart(cartItem, user: user)
          .then((updatedCart) {
            _log.info(
              'Item added successfully. Cart now has ${updatedCart.items.length} items',
            );

            context.read<CartCubit>().refreshCart();

            setState(() {
              _isAddingToCart = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).addedToCart),
                backgroundColor: Colors.green,
                duration: const Duration(milliseconds: 500),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                margin: EdgeInsets.all(10.r),
              ),
            );

            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                GoRouter.of(context).push(MainView.mainPath);
              }
            });
          })
          .catchError((error) {
            _log.severe('Failed to add item to cart: $error');

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

  Future<bool> isAnyAdminInactive() async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('users')
        .select('active')
        .eq('user_type', 'admin');
    final List admins = response;
    for (var admin in admins) {
      if (admin['active'] != true) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return BlocBuilder<FoodDetailsCubit, FoodDetailsState>(
      builder: (context, state) {
        if (state.status == FoodDetailsStatus.loading) {
          return _buildLoadingShimmer();
        }

        if (state.status == FoodDetailsStatus.error) {
          return Scaffold(
            backgroundColor: Colors.white,
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
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => GoRouter.of(context).pop(),
              ),
            ),
            body: Center(child: Text(l10n.noInternetConnection)),
          );
        }

        // Start Cool New Design
        return Scaffold(
          backgroundColor:  Colors.white,
          extendBody: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => GoRouter.of(context).pop(),
            ),
            title: Text(
              Intl.getCurrentLocale() == 'ar' ? food.nameAr : food.nameEn,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          body: Stack(
            children: [
              // Background upper color
              Container(
                height: context.height * 033,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(48.r),
                    bottomRight: Radius.circular(48.r),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero Image
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.07),
                                blurRadius: 30,
                                offset: const Offset(0, 18),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28.r),
                            child: SizedBox(
                              height: context.height * 0.27,
                              width: context.width * 0.7,
                              child: food.photoUrl != null && food.photoUrl!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: food.photoUrl!,
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) => Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          color: Colors.white,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(AssetsBox.logo, fit: BoxFit.cover),
                                    )
                                  : Image.asset(AssetsBox.logo, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Card Details Section
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      padding: EdgeInsets.only(
                          left: 20.w, right: 20.w, top: 24.h, bottom: 32.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32.r),
                          topRight: Radius.circular(32.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 24,
                            offset: const Offset(0, -6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Price Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  Intl.getCurrentLocale() == 'ar'
                                      ? food.nameAr
                                      : food.nameEn,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.bold,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: ColorsBox.primaryColor.withOpacity(0.09),
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                child: Text(
                                  'EGP ${food.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsBox.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          // Description
                          if ((Intl.getCurrentLocale() == 'ar'
                                  ? food.descriptionAr
                                  : food.descriptionEn)
                              ?.isNotEmpty ?? false)
                            Text(
                              Intl.getCurrentLocale() == 'ar'
                                  ? food.descriptionAr ?? ''
                                  : food.descriptionEn ?? '',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w400,
                                  height: 1.4),
                            ),
                          SizedBox(height: 18.h),

                          // Sections: Size, Extras, Beverage
                          if (food.sizes.isNotEmpty) ...[
                            Text(
                              l10n.size,
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            SizedBox(height: 10.h),
                            SizeSelector(
                              sizes: food.sizes,
                              selectedSize: state.selectedSize,
                              onSizeSelected: (size) => context
                                  .read<FoodDetailsCubit>()
                                  .selectSize(size),
                            ),
                            SizedBox(height: 18.h),
                          ],
                          if (food.extras.isNotEmpty) ...[
                            Text(
                              l10n.extras,
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            SizedBox(height: 10.h),
                            ExtrasSelector(
                              extras: food.extras,
                              selectedExtras: state.selectedExtras,
                              onExtraToggled: (extra) => context
                                  .read<FoodDetailsCubit>()
                                  .toggleExtra(extra),
                            ),
                            SizedBox(height: 18.h),
                          ],
                          if (food.beverages.isNotEmpty) ...[
                            Text(
                              l10n.beverage,
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            SizedBox(height: 10.h),
                            BeverageSelector(
                              beverages: food.beverages,
                              selectedBeverages: state.selectedBeverage,
                              onBeverageToggled: (beverage) => context
                                  .read<FoodDetailsCubit>()
                                  .selectBeverage(beverage),
                            ),
                            SizedBox(height: 18.h),
                          ],

                          // Divider
                          Divider(
                            height: 32.h,
                            thickness: 1.5,
                            color: ColorsBox.primaryColor.withOpacity(0.15),
                          ),
                          // Total Price Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.total,
                                style: TextStyle(
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'EGP ${state.totalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsBox.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
                left: 18.w, right: 18.w, bottom: 18.h, top: 8.h),
            child: FutureBuilder<bool>(
              future: isAnyAdminInactive(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: double.infinity,
                    ),
                  );
                }
                if (snapshot.data == true) {
                  return SizedBox();
                }
                return AddToCartButton(
                  price: state.totalPrice,
                  isLoading: _isAddingToCart,
                  onPressed: () => _addToCart(context, state),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image shimmer
              Container(
                width: double.infinity,
                height: 200.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28.r),
                ),
              ),
              SizedBox(height: 24.h),
              // Title shimmer
              Container(width: 200.w, height: 30.h, color: Colors.white),
              SizedBox(height: 16.h),
              // Description shimmer
              Container(
                width: double.infinity,
                height: 60.h,
                color: Colors.white,
              ),
              SizedBox(height: 24.h),
              // Price shimmer
              Container(width: 100.w, height: 24.h, color: Colors.white),
              SizedBox(height: 32.h),
              // Section title shimmer
              Container(width: 120.w, height: 24.h, color: Colors.white),
              SizedBox(height: 16.h),
              // Options shimmer
              Row(
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Container(
                      width: 80.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              // Another section title
              Container(width: 120.w, height: 24.h, color: Colors.white),
              SizedBox(height: 16.h),
              // More options
              Column(
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Container(
                      width: double.infinity,
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.r),
        child: Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}

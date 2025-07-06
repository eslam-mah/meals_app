import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meals_app/core/config/assets_box.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/cart/view_model/cubits/cart_cubit.dart';
import 'package:meals_app/features/food_details/view/views/food_details_screen.dart';
import 'package:meals_app/features/home/data/models/food_model.dart';

class MealGridCard extends StatelessWidget {
  final FoodModel food;
  
  const MealGridCard({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    final StorageService storageService = StorageService();
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (storageService.isAuthenticated()) {
            GoRouter.of(context).push(
              FoodDetailsScreen.routeName,
              extra: food.id,
            ).then((_) {
              // Refresh cart when returning from food details screen
              context.read<CartCubit>().refreshCart();
            });
          } else {
            GoRouter.of(context).push(LoginScreen.routeName);
          }
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food image section
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                    ),
                    child: food.photoUrl != null && food.photoUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: food.photoUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade100,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorsBox.primaryColor,
                                  ),
                                  strokeWidth: 2.w,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade100,
                              child: Center(
                                child: Image.asset(
                                  AssetsBox.logo,
                                  fit: BoxFit.contain,
                                  width: 60.w,
                                  height: 60.h,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade100,
                            child: Center(
                              child: Image.asset(
                                AssetsBox.logo,
                                fit: BoxFit.contain,
                                width: 60.w,
                                height: 60.h,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              
              // Content section
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                          Intl.getCurrentLocale() == 'ar' ? food.nameAr : food.nameEn,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      SizedBox(height: 8.h),
                      
                      // Description (optional, only if there's space)
                      if (food.descriptionEn != null || food.descriptionAr != null)
                        Text(
                          Intl.getCurrentLocale() == 'ar' 
                              ? food.descriptionAr ?? '' 
                              : food.descriptionEn ?? '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      
                      SizedBox(height: 8.h),
                      
                      // Price and add button row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Price
                          Expanded(
                            child: Text(
                              'EGP ${food.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorsBox.primaryColor,
                              ),
                            ),
                          ),
                          
                          // Add button
                          Container(
                            width: 32.w,
                            height: 32.h,
                            decoration: const BoxDecoration(
                              color: ColorsBox.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18.r,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/assets_box.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/cart/view_model/cubits/cart_cubit.dart';
import 'package:meals_app/features/food_details/view/views/food_details_screen.dart';
import 'package:meals_app/features/home/data/models/food_model.dart';

class MealCard extends StatelessWidget {
  final FoodModel food;
  
  const MealCard({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final StorageService storageService = StorageService();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if(storageService.isAuthenticated()){
            GoRouter.of(context).push(
              FoodDetailsScreen.routeName,
              extra: food.id,
            ).then((_) {
        // ← when you come back from the cart screen
        context.read<CartCubit>().refreshCart();
      });;

          } else {
            GoRouter.of(context).push(LoginScreen.routeName);
          }
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.r),
          child: Row(
            children: [
              // Food image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: SizedBox(
                  width: 80.w,
                  height: 90.h,
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
              SizedBox(width: 16.w),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      food.nameEn,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    
                    // Description
                    Text(
                      food.descriptionEn ?? '',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Price and add button
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'EGP ${food.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 13.h),
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: ColorsBox.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24.r,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
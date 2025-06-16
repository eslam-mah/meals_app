import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/assets_box.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/food_details/view/views/food_details_screen.dart';
import 'package:meals_app/features/home/data/models/food_model.dart';

class HotOfferCard extends StatelessWidget {
  final FoodModel food;
  
  const HotOfferCard({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    final StorageService storageService = StorageService();
    return Padding(
      padding: EdgeInsets.only(right: 20.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          
          onTap: () {
            if(storageService.isAuthenticated()){
              GoRouter.of(context).push(
                FoodDetailsScreen.routeName,
                extra: food.id,
              );
            } else {
              GoRouter.of(context).push(LoginScreen.routeName);
            }
          },
          child: Ink(
            width: 300.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Stack(
              children: [
                // Food image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: SizedBox(
                    width: 300.w,
                    height: 180.h,
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
                
                // Overlay with food name and price
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.r),
                        bottomRight: Radius.circular(12.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.nameEn,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'EGP ${food.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
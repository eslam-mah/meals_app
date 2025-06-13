import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/assets_box.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/food_details/view/views/food_details_screen.dart';

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
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
            GoRouter.of(context).push(FoodDetailsScreen.routeName);
           }else{
            GoRouter.of(context).push(LoginScreen.routeName);
           }        },
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.r),
          child: Row(
            children: [
              // Logo image
              Image.asset(
                 AssetsBox.logo,
                width: 80.w,
                height: 90.h,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 16.w),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Test',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    
                    // Description
                    Text(
                      'Test test test test test test test',
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
                    'Test 180.00',
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
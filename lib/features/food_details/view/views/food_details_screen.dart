import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/assets_box.dart';
import 'package:meals_app/core/utils/media_query_values.dart';
import 'package:meals_app/features/food_details/view/widgets/add_to_cart_button.dart';
import 'package:meals_app/features/food_details/view/widgets/beverage_selector.dart';
import 'package:meals_app/features/food_details/view/widgets/extras_selector.dart';
import 'package:meals_app/features/food_details/view/widgets/size_selector.dart';
import 'package:meals_app/generated/l10n.dart';

class FoodDetailsScreen extends StatelessWidget {
  static const String routeName = '/food-details';
  
  const FoodDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food Image
              Center(
                child: Container(
                  height: context.height * 0.25,
                  width: context.width * 0.6,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage( AssetsBox.logo),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // Food Title
              Text(
                l10n.chickenFries,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: 8.h),
              
              // Description
              Text(
                l10n.foodDescription,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
              
              SizedBox(height: 24.h),
              
              // Size Section
              Text(
                l10n.size,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              const SizeSelector(),
              
              SizedBox(height: 24.h),
              
              // Extras Section
              Text(
                l10n.extras,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              const ExtrasSelector(),
              
              SizedBox(height: 24.h),
              
              // Beverage Section
              Text(
                l10n.beverage,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              const BeverageSelector(),
              
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: const AddToCartButton(),
      ),
    );
  }
} 
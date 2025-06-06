import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/features/food_details/view/views/food_details_screen.dart';

class HotOfferCard extends StatelessWidget {
  
  const HotOfferCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          
          onTap: () {
            GoRouter.of(context).push(FoodDetailsScreen.routeName);
          },
          child: Ink(
            width: 300.w,
            decoration: BoxDecoration(
              color:  Colors.white ,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child:Image.asset(
                    'assets/icons/logo.png',
                 
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ),
    );
  }
} 
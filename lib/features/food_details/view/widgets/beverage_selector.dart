import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:meals_app/features/home/data/models/food_model.dart';

class BeverageSelector extends StatelessWidget {
  final List<FoodBeverage> beverages;
  final List<FoodBeverage> selectedBeverages;
  final Function(FoodBeverage) onBeverageToggled;

  const BeverageSelector({
    super.key,
    required this.beverages,
    required this.selectedBeverages,
    required this.onBeverageToggled,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (beverages.length * 70).w,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: beverages.length,
        itemBuilder: (context, index) {
          final beverage = beverages[index];
          final isSelected = selectedBeverages.contains(beverage);
          
          return GestureDetector(
            onTap: () => onBeverageToggled(beverage),
            child: Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.orange : Colors.white,
                          border: Border.all(
                            color: Colors.orange,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        Intl.getCurrentLocale() == 'ar'? beverage.nameAr: beverage.nameEn,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '+ EGP ${beverage.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 
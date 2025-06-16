import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/features/home/data/models/food_model.dart';

class BeverageSelector extends StatelessWidget {
  final List<FoodBeverage> beverages;
  final FoodBeverage? selectedBeverage;
  final Function(FoodBeverage?) onBeverageSelected;

  const BeverageSelector({
    super.key,
    required this.beverages,
    this.selectedBeverage,
    required this.onBeverageSelected,
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
          final isSelected = selectedBeverage == beverage;
          
          return GestureDetector(
            onTap: () {
              if (isSelected) {
                onBeverageSelected(null);
              } else {
                onBeverageSelected(beverage);
              }
            },
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
                        beverage.nameEn,
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
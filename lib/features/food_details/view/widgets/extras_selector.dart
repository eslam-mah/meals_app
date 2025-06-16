import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/features/home/data/models/food_model.dart';

class ExtrasSelector extends StatelessWidget {
  final List<FoodExtra> extras;
  final List<FoodExtra> selectedExtras;
  final Function(FoodExtra) onExtraToggled;

  const ExtrasSelector({
    super.key,
    required this.extras,
    required this.selectedExtras,
    required this.onExtraToggled,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (extras.length * 80).h,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: extras.length,
        itemBuilder: (context, index) {
          final extra = extras[index];
          final isSelected = selectedExtras.contains(extra);
          
          return GestureDetector(
            onTap: () => onExtraToggled(extra),
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
                        extra.nameEn,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '+ EGP ${extra.price.toStringAsFixed(2)}',
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
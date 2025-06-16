import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/features/home/data/models/food_model.dart';
import 'package:meals_app/generated/l10n.dart';

class SizeSelector extends StatelessWidget {
  final List<FoodSize> sizes;
  final FoodSize? selectedSize;
  final Function(FoodSize) onSizeSelected;

  const SizeSelector({
    super.key,
    required this.sizes,
    this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    
    return SizedBox(
      height: (sizes.length * 80).h,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sizes.length,
        itemBuilder: (context, index) {
          final size = sizes[index];
          final isSelected = selectedSize == size;
          
          return GestureDetector(
            onTap: () => onSizeSelected(size),
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
                        _getSizeDisplayName(size.nameEn, l10n),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '+ EGP ${size.price.toStringAsFixed(2)}',
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
  
  String _getSizeDisplayName(String nameEn, S l10n) {
    switch (nameEn.toLowerCase()) {
      case 'regular':
        return l10n.regular;
      case 'medium':
        return l10n.medium;
      case 'large':
        return l10n.large;
      default:
        return nameEn;
    }
  }
} 
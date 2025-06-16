import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/generated/l10n.dart';

class AddToCartButton extends StatelessWidget {
  final double price;
  final VoidCallback onPressed;

  const AddToCartButton({
    super.key,
    required this.price,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12.r),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                SizedBox(width: 8.w),
                Text(
                  l10n.addToCart,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 16.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    'EGP ${price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/config/colors_box.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final double? fontSize;
  final IconData icon;
  final Color? iconColor;
  final double? iconSize;

  const CustomErrorWidget({
    Key? key,
    required this.errorMessage,
    this.padding,
    this.textColor = Colors.red,
    this.fontSize,
    this.icon = Icons.error_outline,
    this.iconColor,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor ?? textColor ?? ColorsBox.primaryColor,
              size: iconSize ?? 28.r,
            ),
            SizedBox(height: 8.h),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize ?? 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
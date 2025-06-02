import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/responsive/responsive_manager.dart';
import 'package:meals_app/core/config/colors_box.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final Color? borderColor;
  final Color? textColor;
  final Key? key;
  final Function() onTap;

  const CustomOutlinedButton({
    required this.title,
    required this.onTap,
    this.width,
    this.height,
    this.borderColor,
    this.textColor,
    this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Default sizes - responsive using ScreenUtil
    final double defaultWidth = RM.data.setWidth(size: 320);
    final double defaultHeight = 56.h;
    
    return Material(
      borderRadius: BorderRadius.circular(8.r),
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Ink(
          width: width ?? defaultWidth,
          height: height ?? defaultHeight,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: borderColor ?? ColorsBox.primaryColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: textColor ?? ColorsBox.primaryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
} 
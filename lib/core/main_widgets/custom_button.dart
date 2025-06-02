import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/responsive/responsive_manager.dart';
import 'package:meals_app/core/config/colors_box.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final Color? color;
  final Key? key;
  final Function() onTap;
  final Icon? icon;

  const CustomButton({
    required this.title,
    required this.onTap,
    this.width,
    this.height,
    this.color,
    this.key,
    this.icon,
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
            color: color ?? ColorsBox.primaryColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  icon!,
                  SizedBox(width: 8.w),
                ],
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
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
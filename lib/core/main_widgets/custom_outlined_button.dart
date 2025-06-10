import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/responsive/responsive_manager.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final Color? borderColor;
  final Color? textColor;
  final Key? key;
  final Function()? onTap;
  final Icon? icon;

  const CustomOutlinedButton({
    required this.title,
    required this.onTap,
    this.width,
    this.height,
    this.borderColor,
    this.textColor,
    this.key,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Default sizes - responsive using ScreenUtil
    final double defaultWidth = RM.data.setWidth(size: 320);
    final double defaultHeight = 56.h;
    
    // Default colors
    final Color finalBorderColor = borderColor ?? Theme.of(context).primaryColor;
    final Color finalTextColor = textColor ?? Theme.of(context).primaryColor;
    
    final bool isEnabled = onTap != null;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Ink(
          width: width ?? defaultWidth,
          height: height ?? defaultHeight,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isEnabled ? finalBorderColor : Colors.grey.shade300,
              width: 1.5,
            ),
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
                    color: isEnabled ? finalTextColor : Colors.grey.shade400,
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
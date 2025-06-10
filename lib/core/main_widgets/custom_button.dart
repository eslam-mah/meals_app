import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/responsive/responsive_manager.dart';
import 'package:meals_app/core/config/colors_box.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final Key? key;
  final Function() onTap;
  final Icon? icon;
  final bool isEnabled;
  final bool isLoading;

  const CustomButton({
    required this.title,
    required this.onTap,
    this.width,
    this.height,
    this.color,
    this.textColor,
    this.key,
    this.icon,
    this.isEnabled = true,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Default sizes - responsive using ScreenUtil
    final double defaultWidth = RM.data.setWidth(size: 320);
    final double defaultHeight = 56.h;
    
    // Button is disabled when loading or explicitly disabled
    final bool isButtonEnabled = isEnabled && !isLoading;
    
    // Colors based on enabled state
    final buttonColor = isButtonEnabled 
        ? (color ?? ColorsBox.primaryColor) 
        : Colors.grey.shade300;
    
    final finalTextColor = textColor ?? (isButtonEnabled 
        ? Colors.white 
        : Colors.black87);
    
    return Material(
      borderRadius: BorderRadius.circular(8.r),
      color: Colors.transparent,
      child: InkWell(
        onTap: isButtonEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(8.r),
        child: Ink(
          width: width ?? defaultWidth,
          height: height ?? defaultHeight,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: CircularProgressIndicator(
                      color: finalTextColor,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        isButtonEnabled
                            ? icon!
                            : Icon(
                                icon!.icon,
                                color: finalTextColor,
                                size: icon!.size,
                              ),
                        SizedBox(width: 8.w),
                      ],
                      Text(
                        title,
                        style: TextStyle(
                          color: finalTextColor,
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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/config/colors_box.dart';

class IndicatorDots extends StatelessWidget {
  final int dotsCount;
  final int currentPosition;
  
  const IndicatorDots({
    super.key,
    required this.dotsCount,
    required this.currentPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        dotsCount,
        (index) => _buildDot(index),
      ),
    );
  }

  Widget _buildDot(int index) {
    final isActive = index == currentPosition;
    final color = isActive ?  ColorsBox.primaryColor : Colors.grey.shade300;
    final width = isActive ? 24.w : 8.w;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 8.h,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
} 
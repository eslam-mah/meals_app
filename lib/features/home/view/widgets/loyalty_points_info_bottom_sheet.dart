import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/generated/l10n.dart';

class LoyaltyPointsInfoBottomSheet extends StatelessWidget {
  final int loyaltyPoints;

  const LoyaltyPointsInfoBottomSheet({Key? key, required this.loyaltyPoints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return Container(
      height: 0.5.sh, // 50% of screen height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localization.loyaltyPoints,
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 24.r),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.yourCurrentLoyaltyPoints,
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                   Text(
                    '$loyaltyPoints',
                    style: TextStyle(fontSize: 50.sp, fontWeight: FontWeight.bold, color: ColorsBox.primaryColor),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    localization.howToEarnPointsTitle,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    localization.howToEarnPointsDescription,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    localization.howToUsePointsTitle,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    localization.howToUsePointsDescription,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
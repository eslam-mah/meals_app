import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/utils/colors_box.dart';

class DeliveryLocation extends StatelessWidget {
  
  const DeliveryLocation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1.h,
          ),
        ),
      ),
      child: Row(
        children: [
          // Location pin icon
          Icon(
            Icons.location_on,
            color: ColorsBox.primaryColor,
            size: 24.r,
          ),
          SizedBox(width: 8.w),
          
          // Location text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery to',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorsBox.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Text(
                    'location',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20.r,
                    color: Colors.black,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
} 
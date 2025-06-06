import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/generated/l10n.dart';

class AddressItem extends StatelessWidget {


  const AddressItem({
    super.key,
  
  });

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1.h,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Address info and delete button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'title',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'details',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Delete button
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red.shade600,
                    size: 24.r,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          
          // Action buttons
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
            child: Row(
              children: [
                // Mark as primary button
                Expanded(
                  child: CustomButton(
                    title: localization.markAsPrimary,
                    onTap: () {},
                    color: ColorsBox.primaryColor,
                    height: 45.h,
                    icon: Icon(Icons.radio_button_checked, color: Colors.white, size: 18.r),
                  ),
                ),
                SizedBox(width: 12.w),
                // Edit button
                SizedBox(
                  width: 100.w,
                  height: 45.h,
                  child: CustomButton(
                    textColor: Colors.black87,
                    title: localization.edit,
                    onTap: () {},
                    color: Colors.grey.shade200,
                    height: 45.h,
                    icon: Icon(Icons.edit, color: Colors.black87, size: 18.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 
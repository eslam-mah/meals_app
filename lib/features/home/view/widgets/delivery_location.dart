import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/generated/l10n.dart';

class DeliveryLocation extends StatelessWidget {
  
  const DeliveryLocation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final userLocation = state.user?.location ?? '';
        
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
                size: 40.r,
              ),
              SizedBox(width: 8.w),
              
              // Location text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.deliveryTo,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: ColorsBox.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Text(
                        userLocation,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 25.r,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/features/settings/view/views/settings_view.dart';
import 'package:meals_app/generated/l10n.dart';

class ProfileHeader extends StatelessWidget {


  const ProfileHeader({
    super.key,
 
  });

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 36.r,
            backgroundColor: ColorsBox.primaryColor.withOpacity(0.2),
            child: Text(
              'initials',
              style: TextStyle(
                color: ColorsBox.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'name',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'phone',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.settings, color: ColorsBox.primaryColor, size: 32.r),
            onPressed: (){
              GoRouter.of(context).push(SettingsView.settingsPath);
            },
            tooltip: localization.profile,
          ),
        ],
      ),
    );
  }
} 
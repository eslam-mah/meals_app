import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileView extends StatelessWidget {
    static const String profilePath = '/profile_Bottom_Navigation_Bar';

  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60.r,
                backgroundColor: Colors.orange.withOpacity(0.2),
                child: Icon(
                  Icons.person,
                  size: 80.r,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Profile Coming Soon',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Your profile is under construction',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
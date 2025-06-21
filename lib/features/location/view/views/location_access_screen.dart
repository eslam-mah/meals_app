import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/features/home/view/views/main_view.dart';
import 'package:meals_app/generated/l10n.dart';

class LocationAccessScreen extends StatelessWidget {
  // static const String routeName = '/location-access';

  const LocationAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer for top alignment
              const Spacer(flex: 1),
              
              // Location image
              Center(
                child: Image.asset(
                  'assets/icons/location_widget.png',
                  width: 400.w,
                  fit: BoxFit.contain,
                ),
              ),
              
              const Spacer(flex: 1),
              
              // Access location button
              CustomButton(
                icon: Icon(Icons.location_on_rounded, color: Colors.white,),
                title: localization.accessLocation,
                color: theme.colorScheme.primary,
                width: double.infinity,
                onTap: () {
                  GoRouter.of(context).go(MainView.mainPath);
                },
              ),
              
              SizedBox(height: 20.h),
              
              // Location access explanation text
              Text(
                localization.locationAccessDescription,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/responsive/responsive_manager.dart';
import 'package:meals_app/core/utils/assets_box.dart';
import 'package:meals_app/features/onboarding/models/onboarding_page_model.dart';
import 'package:meals_app/generated/l10n.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingPageModel pageModel;

  const OnboardingPage({super.key, required this.pageModel});

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // App Logo instead of image
        Expanded(
          flex: 4,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            child: Image.asset(
              getImageString(pageModel.imagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),

        // Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Text(
            getTitleString(localization, pageModel.titleKey),
            style: TextStyle(
              fontSize: RM.data.mapValue(mobile: 22.sp, tablet: 28.sp),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Text(
            getTitleString(localization, pageModel.descriptionKey),
            style: TextStyle(
              fontSize: RM.data.mapValue(mobile: 16.sp, tablet: 18.sp),
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 50.h),
      ],
    );
  }

  String getImageString(String key) {
    switch (key) {
      case '1':
        return AssetsBox.onboarding1;
      case '2':
        return AssetsBox.onboarding2;
      case '3':
        return AssetsBox.onboarding3;

      default:
        return key;
    }
  }

  String getTitleString(S localization, String key) {
    switch (key) {
      case 'onboardingTitle1':
        return localization.onboardingTitle1;
      case 'onboardingDesc1':
        return localization.onboardingDesc1;
      case 'onboardingTitle2':
        return localization.onboardingTitle2;
      case 'onboardingDesc2':
        return localization.onboardingDesc2;
      case 'onboardingTitle3':
        return localization.onboardingTitle3;
      case 'onboardingDesc3':
        return localization.onboardingDesc3;
      default:
        return key;
    }
  }
}

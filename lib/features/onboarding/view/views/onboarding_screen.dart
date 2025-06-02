import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/features/authentication/view/views/phone_auth_screen.dart';
import 'package:meals_app/features/onboarding/models/onboarding_page_model.dart';
import 'package:meals_app/features/onboarding/view/widgets/indicator_dots.dart';
import 'package:meals_app/features/onboarding/view/widgets/onboarding_page.dart';
import 'package:meals_app/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';
  
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final List<OnboardingPageModel> _pages = OnboardingPageModel.getOnboardingPages();
  int _currentPage = 0;
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    
    if (mounted) {
      // Navigate to home screen
      GoRouter.of(context).push(PhoneAuthScreen.routeName);
    }
  }
  
  void _navigateToNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }
  
  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final isLTR = Directionality.of(context) == TextDirection.ltr;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: isLTR ? Alignment.topRight : Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 16.h,
                  right: isLTR ? 16.w : 0,
                  left: isLTR ? 0 : 16.w,
                ),
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    localization.skip,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(pageModel: _pages[index]);
                },
              ),
            ),
            
            // Indicator dots
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: IndicatorDots(
                dotsCount: _pages.length,
                currentPosition: _currentPage,
              ),
            ),
            
            // Next or Get Started button
            Padding(
              padding: EdgeInsets.only(
                bottom: 32.h, 
                left: 24.w, 
                right: 24.w,
              ),
              child: CustomButton(
                title: _currentPage == _pages.length - 1
                    ? localization.getStarted
                    : localization.next,
                onTap: _navigateToNextPage,
                color: ColorsBox.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
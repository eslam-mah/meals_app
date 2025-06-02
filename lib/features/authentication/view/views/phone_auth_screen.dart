import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/features/authentication/view/views/otp_verification_screen.dart';
import 'package:meals_app/features/authentication/view/widgets/phone_input_field.dart';
import 'package:meals_app/features/language/cubit/language_cubit.dart';
import 'package:meals_app/generated/l10n.dart';

class PhoneAuthScreen extends StatefulWidget {
  static const String routeName = '/phone-auth';

  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _showPhoneError = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _continueToVerification() {
    if (_validatePhone()) {
      context.go(OtpVerificationScreen.routeName, extra: _phoneController.text);
    } else {
      setState(() {
        _showPhoneError = true;
      });
    }
  }

  bool _validatePhone() {
    return _phoneController.text.length >= 11;
  }

  void _onPhoneChanged(String value) {
    if (_showPhoneError) {
      setState(() {
        _showPhoneError = false;
      });
    }
  }

  void _toggleLanguage() {
    context.read<LanguageCubit>().toggleLanguage();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final isLTR = Directionality.of(context) == TextDirection.ltr;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              // Logo section
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/logo.png',
                        width: 240.w,
                        fit: BoxFit.contain,
                      ),
                      
                    ],
                  ),
                ),
              ),
              
              // Phone input section
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Column(
                   crossAxisAlignment:  CrossAxisAlignment.start,
                    children: [
                      // Phone number label
                      Text(
                        localization.phoneNumber,
                        style: TextStyle(
                          color: ColorsBox.primaryColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      
                      // Phone input field
                      PhoneInputField(
                        controller: _phoneController,
                        showError: _showPhoneError,
                        onChanged: _onPhoneChanged,
                      ),
                      
                      // Continue button
                      Padding(
                        padding: EdgeInsets.only(top: 32.h),
                        child: Center(
                          child: CustomButton(
                            title: localization.continueButton,
                            onTap: _continueToVerification,
                            color: ColorsBox.primaryColor,
                            width: 400.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Language switch and terms
              Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _toggleLanguage,
                      child: Text(
                        isLTR ? localization.arabic : localization.english,
                        style: TextStyle(
                          color: ColorsBox.primaryColor,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Terms navigation logic would go here
                      },
                      child: Text(
                        localization.termsAndConditions,
                        style: TextStyle(
                          color: ColorsBox.primaryColor,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
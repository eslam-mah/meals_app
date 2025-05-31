import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/core/main_widgets/custom_outlined_button.dart';
import 'package:meals_app/features/authentication/view/widgets/otp_input_field.dart';
import 'package:meals_app/features/location/view/views/location_access_screen.dart';
import 'package:meals_app/generated/l10n.dart';

class OtpVerificationScreen extends StatefulWidget {
  static const String routeName = '/otp-verification';
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );
  
  int _timerSeconds = 60;
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    _startTimer();
  }
  
  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }
  
  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_timerSeconds > 0) {
          setState(() {
            _timerSeconds--;
          });
        } else {
          _timer?.cancel();
        }
      },
    );
  }
  
  void _verifyOtp() {
    // This would contain the verification logic
    String otp = _controllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      context.push(LocationAccessScreen.routeName);
    }
  }
  
  void _resendCode() {
    // This would contain the resend code logic
    setState(() {
      _timerSeconds = 60;
    });
    _startTimer();
    
    // Clear all controllers
    for (var controller in _controllers) {
      controller.clear();
    }
    
    // Set focus to first field
    _focusNodes.first.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Logo section
              Padding(
                padding: EdgeInsets.only(top: 32.h, bottom: 16.h),
                child: Center(
                  child: Image.asset(
                    'assets/icons/logo.png',
                    width: 200.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              
              // Verification title
              Padding(
                padding: EdgeInsets.only(top: 32.h),
                child: Text(
                  localization.verificationCode,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Verification message
              Padding(
                padding: EdgeInsets.only(top: 16.h, bottom: 32.h),
                child: Text(
                  '${localization.verificationCodeSent}\n${widget.phoneNumber}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // OTP input fields
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: OtpInputField(
                  controllers: _controllers,
                  focusNodes: _focusNodes,
                ),
              ),
              
              // Timer
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Text(
                  '$_timerSeconds',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18.sp,
                  ),
                ),
              ),
              
              // Continue button
              Padding(
                padding: EdgeInsets.only(top: 32.h),
                child: SizedBox(
                  child: CustomButton(
                    
                    title: localization.continueButton,
                    onTap: _verifyOtp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              
              // Resend code button
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: CustomOutlinedButton(
                  title: localization.didntReceiveCode,
                  onTap: _timerSeconds == 0 ? _resendCode : () {},
                  borderColor: _timerSeconds == 0 
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade700,
                  textColor: _timerSeconds == 0 
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
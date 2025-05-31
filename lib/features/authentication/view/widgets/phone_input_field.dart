import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/generated/l10n.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool showError;
  final String? errorMessage;
  final ValueChanged<String>? onChanged;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.hintText = '01xxxxxxxxx',
    this.showError = false,
    this.errorMessage,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final errorText = errorMessage ?? localization.phoneNumberRequired;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8.r),
            border: showError 
                ? Border.all(color: Colors.red, width: 1.5) 
                : null,
          ),
          child: Row(
            children: [
              // Country code section
              Container(
                width: 56.w,
                height: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  '+2',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Phone number input
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: 18.sp),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 18.sp,
                      ),
                    ),
                    
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Error message
        if (showError)
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 8.w),
            child: Text(
              errorText,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }
} 
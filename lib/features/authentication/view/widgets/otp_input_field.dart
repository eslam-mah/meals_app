import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class OtpInputField extends StatefulWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  const OtpInputField({
    Key? key,
    required this.controllers,
    required this.focusNodes,
  }) : super(key: key);

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize with any existing values from the controllers
    _controller = TextEditingController(
      text: widget.controllers.map((c) => c.text).join(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get colors from theme
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final backgroundColor = Theme.of(context).inputDecorationTheme.fillColor ?? Colors.grey.shade200;
    
    // Default pin theme
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 60.h,
      textStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );

    // Focused pin theme
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: primaryColor, width: 2),
    );

    // Submitted pin theme
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: backgroundColor,
      ),
    );

    return Center(
      child: Directionality(
        textDirection: TextDirection.ltr, // Always LTR regardless of app locale
        child: Pinput(
          length: 6,
          controller: _controller,
          focusNode: widget.focusNodes[0],
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
          keyboardType: TextInputType.number,
          forceErrorState: false,
          onChanged: (value) {
            // Update all the individual controllers for backward compatibility
            for (int i = 0; i < widget.controllers.length; i++) {
              if (i < value.length) {
                widget.controllers[i].text = value[i];
              } else {
                widget.controllers[i].text = '';
              }
            }
          },
          onCompleted: (value) {
            // When all digits are entered, unfocus
            FocusScope.of(context).unfocus();
          },
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileInputField extends StatefulWidget {
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const ProfileInputField({
    Key? key,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.controller,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  State<ProfileInputField> createState() => _ProfileInputFieldState();
}

class _ProfileInputFieldState extends State<ProfileInputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontSize: 16.sp,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
          fontSize: 16.sp,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: theme.colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        errorStyle: TextStyle(
          color: Colors.red.shade700,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: Colors.red.shade700,
            width: 2,
          ),
        ),
       
      ),
    );
  }
} 
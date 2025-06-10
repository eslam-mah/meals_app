import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_cubit.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_state.dart' as app_auth;
import 'package:meals_app/generated/l10n.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot-password';
  final String email;

  const ForgotPasswordScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _tokenController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;
  bool _resetEmailSent = false;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }
  
  void _sendResetEmail() {
    // Resend the password reset email if needed
    context.read<AuthCubit>().sendPasswordResetEmail(_emailController.text);
  }
  
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _tokenController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }
  
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }
  
  void _resetPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      // Use auth cubit to reset the password with token
      context.read<AuthCubit>().resetPasswordWithManualToken(
        _emailController.text,
        _tokenController.text,
        _passwordController.text
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final theme = Theme.of(context);
    
    return BlocListener<AuthCubit, app_auth.AuthState>(
      listener: (context, state) {
        if (state.status == app_auth.AuthStatus.loading) {
          setState(() {
            _isSubmitting = true;
            _errorMessage = null;
          });
        } else {
          setState(() {
            _isSubmitting = false;
          });
          
          if (state.status == app_auth.AuthStatus.error) {
            setState(() {
              _errorMessage = state.errorMessage;
            });
          } else if (state.status == app_auth.AuthStatus.passwordResetEmailSent) {
            setState(() {
              _resetEmailSent = true;
            });
            
            // Show a snackbar to confirm email was sent
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localization.passwordResetEmailSent),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.status == app_auth.AuthStatus.authenticated) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localization.passwordResetSuccess),
                backgroundColor: Colors.green,
              ),
            );
            
            // Navigate back to login
            context.go(LoginScreen.routeName);
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo section
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h, bottom: 40.h),
                        child: Image.asset(
                          'assets/icons/logo.png',
                          width: 180.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    
                    // Title
                    Text(
                      localization.resetPassword,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    
                    SizedBox(height: 12.h),
                    
                    // Message about token-based reset
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  localization.passwordResetInstructions,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            localization.enterResetTokenInstructions,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          SizedBox(height: 8.h),
                          if (!_resetEmailSent)
                            Center(
                              child: TextButton.icon(
                                onPressed: _sendResetEmail,
                                icon: Icon(Icons.refresh),
                                label: Text(localization.resendResetEmail),
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Email Field
                    Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localization.pleaseEnterYourEmail;
                        }
                        // Simple email validation
                        if (!value.contains('@') || !value.contains('.')) {
                          return localization.pleaseEnterValidEmail;
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        hintText: localization.enterYourEmail,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: ColorsBox.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Token Field
                    Text(
                      localization.resetToken,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    TextFormField(
                      controller: _tokenController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localization.resetTokenRequired;
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        hintText: localization.enterResetToken,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: ColorsBox.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // New Password Field
                    Text(
                      localization.newPassword,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localization.pleaseEnterPassword;
                        }
                        if (value.length < 6) {
                          return localization.passwordMustBeAtLeast6;
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        hintText: localization.enterNewPassword,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: ColorsBox.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Confirm Password Field
                    Text(
                      localization.confirmPassword,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localization.pleaseConfirmPassword;
                        }
                        if (value != _passwordController.text) {
                          return localization.passwordsDoNotMatch;
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        hintText: localization.confirmNewPassword,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: _toggleConfirmPasswordVisibility,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: ColorsBox.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    
                    // Error message
                    if (_errorMessage != null)
                      Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    
                    SizedBox(height: 32.h),
                    
                    // Reset Button
                    CustomButton(
                      title: localization.resetPassword,
                      onTap: _resetPassword,
                      color: ColorsBox.primaryColor,
                      width: double.infinity,
                      isLoading: _isSubmitting,
                    ),
                    
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 
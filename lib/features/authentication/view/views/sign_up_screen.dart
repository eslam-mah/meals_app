import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_cubit.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_state.dart' as app_auth;
import 'package:meals_app/features/language/cubit/language_cubit.dart';
import 'package:meals_app/features/location/view/views/location_access_screen.dart';
import 'package:meals_app/generated/l10n.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/email-auth';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    
    // Validate email
    if (email.isEmpty) {
      setState(() {
        _errorMessage = S.of(context).pleaseEnterYourEmail;
      });
      return;
    }
    
    // Validate password
    if (password.isEmpty) {
      setState(() {
        _errorMessage = S.of(context).pleaseEnterPassword;
      });
      return;
    }
    
    if (password.length < 6) {
      setState(() {
        _errorMessage = S.of(context).passwordMustBeAtLeast6;
      });
      return;
    }
    
    // Validate confirm password
    if (password != confirmPassword) {
      setState(() {
        _errorMessage = S.of(context).passwordsDoNotMatch;
      });
      return;
    }
    
    // Use the auth cubit for direct signup
    context.read<AuthCubit>().signUpWithEmail(email, password);
  }

  void _onInputChanged(String _) {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
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

  void _toggleLanguage() {
    context.read<LanguageCubit>().toggleLanguage();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final isLTR = Directionality.of(context) == TextDirection.ltr;
    
    return BlocListener<AuthCubit, app_auth.AuthState>(
      listener: (context, state) {
        if (state.status == app_auth.AuthStatus.loading) {
          setState(() {
            _isLoading = true;
            _errorMessage = null;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          
          if (state.status == app_auth.AuthStatus.error) {
            setState(() {
              _errorMessage = state.errorMessage;
            });
          } else if (state.status == app_auth.AuthStatus.authenticated) {
            // Navigate to the main app after successful signup
            context.go(LocationAccessScreen.routeName);
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo section
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40.h, bottom: 30.h),
                      child: Image.asset(
                        'assets/icons/logo.png',
                        width: 200.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  
                  // Title
                  Text(
                    localization.signUp,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  SizedBox(height: 30.h),
                  
                  // Email input
                  Text(
                    localization.emailAddress,
                    style: TextStyle(
                      color: ColorsBox.primaryColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: localization.emailExample,
                      prefixIcon: Icon(Icons.email, color: Colors.grey),
                    ),
                    onChanged: _onInputChanged,
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Password input
                  Text(
                    localization.password,
                    style: TextStyle(
                      color: ColorsBox.primaryColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: localization.password,
                      prefixIcon: Icon(Icons.lock, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    onChanged: _onInputChanged,
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Confirm Password input
                  Text(
                    localization.confirmPassword,
                    style: TextStyle(
                      color: ColorsBox.primaryColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: localization.confirmPassword,
                      prefixIcon: Icon(Icons.lock, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: _toggleConfirmPasswordVisibility,
                      ),
                    ),
                    onChanged: _onInputChanged,
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
                      ),
                    ),
                  
                  SizedBox(height: 32.h),
                  
                  // Sign up button
                  CustomButton(
                    title: localization.signUp,
                    onTap: _signUp,
                    color: ColorsBox.primaryColor,
                    width: double.infinity,
                    isLoading: _isLoading,
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Login option
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go(LoginScreen.routeName);
                          },
                          child: Text(
                            localization.signIn,
                            style: TextStyle(
                              color: ColorsBox.primaryColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Language switch
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Center(
                      child: TextButton(
                        onPressed: _toggleLanguage,
                        child: Text(
                          isLTR ? localization.arabic : localization.english,
                          style: TextStyle(
                            color: ColorsBox.primaryColor,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 
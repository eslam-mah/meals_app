import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/assets_box.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/features/authentication/view/views/sign_up_screen.dart';
import 'package:meals_app/features/authentication/view/widgets/custom_text_form_field.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_cubit.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_state.dart'
    as app_auth;
import 'package:meals_app/features/home/view/views/main_view.dart';
import 'package:meals_app/features/language/cubit/language_cubit.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/generated/l10n.dart';
import 'package:meals_app/features/authentication/view/views/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _showSignupOption = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      setState(() {
        _errorMessage = S.of(context).pleaseEnterYourEmail;
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _errorMessage = S.of(context).pleaseEnterPassword;
      });
      return;
    }
    

    // Use the auth cubit to sign in
    context.read<AuthCubit>().signInWithPassword(email, password);
    await context.read<UserCubit>().loadUser();
  }

  void _createAccount() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _errorMessage = S.of(context).pleaseEnterYourEmail;
      });
      return;
    }

    // Navigate to sign up flow
    context.go(SignUpScreen.routeName);
  }

  void _goToSignUp() {
    // Navigate to the email auth screen for signup
    context.go(SignUpScreen.routeName);
  }

  void _forgotPassword() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _errorMessage = S.of(context).pleaseEnterYourEmail;
      });
      return;
    }

    // First send the password reset email
    context.read<AuthCubit>().sendPasswordResetEmail(email);

    // Then navigate to the forgot password screen
    GoRouter.of(context).push(ForgotPasswordScreen.routeName, extra: email);
  }

  void _onInputChanged(String _) {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
        _showSignupOption = false;
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

              // If the error message indicates the user doesn't exist, provide a link to signup
              if (_errorMessage?.contains('User does not exist') == true) {
                _errorMessage =
                    '${state.errorMessage}\n\nDo you want to create an account?';

                // Show a signup button after a short delay
                Future.delayed(Duration(milliseconds: 200), () {
                  if (mounted) {
                    setState(() {
                      _showSignupOption = true;
                    });
                  }
                });
              } else {
                _showSignupOption = false;
              }
            });
          } else if (state.status == app_auth.AuthStatus.authenticated) {
            // Navigate to the main app after successful login
            context.go(MainView.mainPath);
          } else if (state.status ==
              app_auth.AuthStatus.passwordResetEmailSent) {
            // Show a success message about password reset email
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localization.passwordResetEmailSent),
                backgroundColor: Colors.green,
              ),
            );
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
                      padding: EdgeInsets.only(top: 40.h, bottom: 40.h),
                      child: Image.asset(
                        AssetsBox.logo,
                        width: 200.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Title
                  Text(
                    localization.signIn,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Email input
                  CustomTextFormField(
                    controller: _emailController,
                    labelText: localization.emailAddress,
                    hintText: localization.emailExample,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                    onChanged: _onInputChanged,
                  ),

                  SizedBox(height: 24.h),

                  // Password input
                  CustomTextFormField(
                    controller: _passwordController,
                    labelText: localization.password,
                    hintText: localization.password,
                    isPassword: true,
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    onChanged: _onInputChanged,
                  ),

                  // Error message
                  if (_errorMessage != null)
                    Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _errorMessage!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.red,
                            ),
                          ),

                          // Show sign up option if the user doesn't exist
                          if (_showSignupOption)
                            Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: CustomButton(
                                title: 'Create an account',
                                onTap: _createAccount,
                                color: ColorsBox.primaryColor,
                                width: double.infinity,
                              ),
                            ),
                        ],
                      ),
                    ),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _forgotPassword,
                      child: Text(
                        localization.forgotPassword,
                        style: TextStyle(
                          color: ColorsBox.primaryColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Login button
                  CustomButton(
                    title: localization.signIn,
                    onTap: _login,
                    color: ColorsBox.primaryColor,
                    width: double.infinity,
                    isLoading: _isLoading,
                  ),

                  SizedBox(height: 20.h),

                  // Sign up button
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localization.dontHaveAccount,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        TextButton(
                          onPressed: _goToSignUp,
                          child: Text(
                            localization.signUp,
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
                    padding: EdgeInsets.only(top: 32.h, bottom: 24.h),
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

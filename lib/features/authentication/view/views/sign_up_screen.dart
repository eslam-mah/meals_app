import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/assets_box.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/authentication/view/widgets/custom_text_form_field.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_cubit.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_state.dart' as app_auth;
import 'package:meals_app/features/language/cubit/language_cubit.dart';
import 'package:meals_app/features/profile/data/models/user_form.dart';
import 'package:meals_app/features/profile/view/widgets/city_selector.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/features/home/view/views/main_view.dart';
import 'package:meals_app/generated/l10n.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/email-auth';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  String? _selectedCity = 'cairo';
  String? _area;
  String? _detailedAddress;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isFormValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).pleaseEnterYourName;
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).phoneNumberRequired;
    }

    if (value.length < 11) {
      return S.of(context).phoneNumberMustBeAtLeast11Digits;
    }

    return null;
  }

  String? _validateArea(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).pleaseEnterArea;
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).pleaseEnterAddress;
    }
    return null;
  }

  void _signUp()async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final name = _nameController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    final cityValue = _selectedCity ?? 'cairo';
    final location = '$_area, $_detailedAddress';
    
    // Validate password match
    if (password != confirmPassword) {
      setState(() {
        _errorMessage = S.of(context).passwordsDoNotMatch;
      });
      return;
    }
    
    // Create a UserForm with the collected data
    final userForm = UserForm(
      name: name,
      phoneNumber: phoneNumber,
      city: cityValue,
      location: location,
      userType: 'user',
    );
    
    // Use the auth cubit for sign up with profile details
    context.read<AuthCubit>().signUpWithEmailAndProfile(email, password, userForm);
   await context.read<UserCubit>().loadUser();
  }

  void _onInputChanged(String _) {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
    _validateForm();
  }

  void _toggleLanguage() {
    context.read<LanguageCubit>().toggleLanguage();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final isLTR = Directionality.of(context) == TextDirection.ltr;
    final theme = Theme.of(context);
    
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
            // Force a reload of user data with a delay to ensure database operations complete
            Future.delayed(const Duration(milliseconds: 500), () async {
              await context.read<UserCubit>().loadUser();
              if (mounted) {
                // Navigate directly to the main view
                context.go(MainView.mainPath);
              }
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              onChanged: _validateForm,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo section
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                        child: Image.asset(
                          AssetsBox.logo,
                          width: 180.w,
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
                    
                    SizedBox(height: 20.h),
                    
                    // Email input
                    CustomTextFormField(
                      controller: _emailController,
                      labelText: localization.emailAddress,
                      hintText: localization.emailExample,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(Icons.email, color: Colors.grey),
                      onChanged: _onInputChanged,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).pleaseEnterYourEmail;
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Name input
                    CustomTextFormField(
                      controller: _nameController,
                      labelText: localization.fullName,
                      hintText: localization.fullName,
                      keyboardType: TextInputType.name,
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                      onChanged: _onInputChanged,
                      validator: _validateName,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Phone input
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: _validatePhone,
                      onChanged: _onInputChanged,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16.sp,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        labelText: localization.phoneNumber,
                        hintText: "01xxxxxxxxx",
                        prefixIcon: Icon(Icons.phone, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Location input
                    Text(
                      localization.location,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    CitySelector(
                      initialCity: _selectedCity,
                      initialArea: _area,
                      initialAddress: _detailedAddress,
                      onCityChanged: (city) {
                        setState(() {
                          _selectedCity = city;
                        });
                      },
                      onAreaChanged: (area) {
                        setState(() {
                          _area = area;
                          _validateForm();
                        });
                      },
                      onAddressChanged: (address) {
                        setState(() {
                          _detailedAddress = address;
                          _validateForm();
                        });
                      },
                      areaValidator: _validateArea,
                      addressValidator: _validateAddress,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Password input
                    CustomTextFormField(
                      controller: _passwordController,
                      labelText: localization.password,
                      hintText: localization.password,
                      isPassword: true,
                      prefixIcon: Icon(Icons.lock, color: Colors.grey),
                      onChanged: _onInputChanged,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).pleaseEnterPassword;
                        }
                        if (value.length < 6) {
                          return S.of(context).passwordMustBeAtLeast6;
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Confirm Password input
                    CustomTextFormField(
                      controller: _confirmPasswordController,
                      labelText: localization.confirmPassword,
                      hintText: localization.confirmPassword,
                      isPassword: true,
                      prefixIcon: Icon(Icons.lock, color: Colors.grey),
                      onChanged: _onInputChanged,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).pleaseEnterPassword;
                        }
                        if (value != _passwordController.text) {
                          return S.of(context).passwordsDoNotMatch;
                        }
                        return null;
                      },
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
                    
                    SizedBox(height: 24.h),
                    
                    // Sign up button
                    CustomButton(
                      title: localization.signUp,
                      onTap: _signUp,
                      color: ColorsBox.primaryColor,
                      width: double.infinity,
                      isLoading: _isLoading,
                      isEnabled: _isFormValid,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Login option
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            localization.alreadyHaveAccount,
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
                      padding: EdgeInsets.symmetric(vertical: 16.h),
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
      ),
    );
  }
} 
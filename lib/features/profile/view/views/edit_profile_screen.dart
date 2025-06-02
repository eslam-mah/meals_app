import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/features/home/view/views/main_view.dart';
import 'package:meals_app/features/profile/view/widgets/city_selector.dart';
import 'package:meals_app/features/profile/view/widgets/profile_input_field.dart';
import 'package:meals_app/generated/l10n.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/edit_profile';

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedCity;
  String? _area;
  String? _detailedAddress;

  bool _isFormValid = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).pleaseEnterYourEmail;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return S.of(context).pleaseEnterValidEmail;
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).pleaseEnterPassword;
    }

    if (value.length < 8) {
      return S.of(context).passwordMustBeAtLeast8;
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

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo Section
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Center(
                  child: Image.asset(
                    'assets/icons/logo.png',
                    width: 200.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Form Section
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Form(
                  key: _formKey,
                  onChanged: _validateForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Text
                      Text(
                        localization.welcomeToMealsApp,
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Let's sign you up text
                      Text(
                        localization.letsSignYouUp,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Full Name Field
                      Text(
                        localization.enterYourFullName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      ProfileInputField(
                        hintText: localization.fullName,
                        keyboardType: TextInputType.name,
                        controller: _nameController,
                        validator: _validateName,
                      ),

                      SizedBox(height: 24.h),

                      // Email Field
                      Text(
                        localization.emailAddress,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      ProfileInputField(
                        hintText: localization.emailExample,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: _validateEmail,
                      ),

                      SizedBox(height: 24.h),

                      // Password Field
                      Text(
                        localization.password,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      ProfileInputField(
                        hintText: localization.password,
                        isPassword: true,
                        controller: _passwordController,
                        validator: _validatePassword,
                      ),

                      SizedBox(height: 24.h),

                      // Location Field
                      Text(
                        localization.location,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
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
                          });
                        },
                        onAddressChanged: (address) {
                          setState(() {
                            _detailedAddress = address;
                          });
                        },
                        areaValidator: _validateArea,
                        addressValidator: _validateAddress,
                      ),

                      SizedBox(height: 40.h),

                      // Submit Button
                      CustomButton(
                        title: localization.submit,
                        color: theme.colorScheme.primary,
                        width: double.infinity,
                        onTap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Form is valid, proceed with submission
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(localization.formSubmittedSuccessfully),
                              ),
                            );
                            GoRouter.of(context).push(MainView.mainPath);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

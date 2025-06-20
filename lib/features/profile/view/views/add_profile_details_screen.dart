import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_app/core/config/assets_box.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/features/home/view/views/main_view.dart';
import 'package:meals_app/features/profile/data/models/user_form.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/features/profile/view/widgets/city_selector.dart';
import 'package:meals_app/features/profile/view/widgets/profile_input_field.dart';
import 'package:meals_app/generated/l10n.dart';

class AddProfileDetailsScreen extends StatefulWidget {
  static const String routeName = '/add_profile_details';

  const AddProfileDetailsScreen({super.key});

  @override
  State<AddProfileDetailsScreen> createState() =>
      _AddProfileDetailsScreenState();
}

class _AddProfileDetailsScreenState extends State<AddProfileDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedCity = 'cairo'; // Default to cairo
  String? _area;
  String? _detailedAddress;

  bool _isFormValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Make sure user data is loaded
    _initializeUserCubit();
  }

  void _initializeUserCubit() {
    // Ensure UserCubit is initialized and loads user data
    if (context.read<UserCubit>().state.user == null) {
      context.read<UserCubit>().loadUser();
    }
  }

  @override
  void dispose() {
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

  // Save user profile data
  Future<void> _saveProfileData() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Ensure city value is not null
      final cityValue = _selectedCity ?? 'cairo';
      
      // Create a UserForm with the collected data
      final userForm = UserForm(
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        city: cityValue,
        isProfileCompleted: true,
        location: '$_area, $_detailedAddress',
        userType: 'user', // Setting default user type to 'user'
      );

      // Update the user with form data
      await context.read<UserCubit>().updateUserWithForm(userForm);
      await context.read<UserCubit>().loadUser();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).formSubmittedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to main screen
        GoRouter.of(context).go(MainView.mainPath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                    AssetsBox.logo,
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

                      // Phone Number Field
                      Text(
                        localization.phoneNumber,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Custom phone field with input formatters
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: _validatePhone,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 16.sp,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(11),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hintText: "01xxxxxxxxx",
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
                          filled: true,
                          fillColor: Colors.grey.shade200,
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
                        isLoading: _isLoading,
                        isEnabled: _isFormValid,
                        onTap: () {
                          if (_isFormValid) {
                            _saveProfileData();
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

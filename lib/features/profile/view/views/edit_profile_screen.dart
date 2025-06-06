import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/core/main_widgets/custom_outlined_button.dart';
import 'package:meals_app/features/profile/view/widgets/profile_input_field.dart';
import 'package:meals_app/features/authentication/view/widgets/phone_input_field.dart';
import 'package:meals_app/generated/l10n.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/account_info';

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Eslam');
  final _emailController = TextEditingController(text: 'eslamxxxxx517@gmail.com');
  final _phoneController = TextEditingController(text: '01117021765');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          localization.accountInfo,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name Field
                Text(
                  localization.fullName,
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

                PhoneInputField(
                  controller: _phoneController,
                ),

                SizedBox(height: 48.h),

                // Update Button
                CustomButton(
                  title: localization.update,
                  color: theme.colorScheme.primary,
                  width: double.infinity,
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Handle update logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localization.formSubmittedSuccessfully),
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),

                SizedBox(height: 16.h),

                // Delete Account Button
                CustomOutlinedButton(
                  title: localization.deleteMyAccount,
                  borderColor: Colors.red,
                  textColor: Colors.red,
                  width: double.infinity,
                  onTap: () {
                    // Handle delete account logic
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(localization.confirmDeleteAccount),
                        content: Text(localization.deleteAccountWarning),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(localization.cancel),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Handle account deletion
                            },
                            child: Text(
                              localization.delete,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

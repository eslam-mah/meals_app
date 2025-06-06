import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/features/home/view/views/main_view.dart';
import 'package:meals_app/features/profile/view/widgets/city_selector.dart';
import 'package:meals_app/features/profile/view/widgets/profile_input_field.dart';
import 'package:meals_app/generated/l10n.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = '/change_password';

  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
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
          localization.changePassword,
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
                // Current Password Field
                Text(
                  localization.currentPassword,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: 8.h),

                ProfileInputField(
                  hintText: localization.currentPassword,
                  isPassword: true,
                  controller: _currentPasswordController,
                  validator: _validatePassword,
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

                ProfileInputField(
                  hintText: localization.newPassword,
                  isPassword: true,
                  controller: _newPasswordController,
                  validator: _validatePassword,
                ),

                SizedBox(height: 48.h),

                // Update Button
                CustomButton(
                  title: localization.update,
                  color: Colors.grey.shade400,
                  width: double.infinity,
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Handle password update logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localization.passwordUpdatedSuccessfully),
                        ),
                      );
                      Navigator.of(context).pop();
                    }
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

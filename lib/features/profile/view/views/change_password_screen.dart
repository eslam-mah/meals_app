import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_cubit.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_state.dart' as app_auth;
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
  bool _isLoading = false;

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

    if (value.length < 6) {
      return S.of(context).passwordMustBeAtLeast6;
    }

    return null;
  }

  void _updatePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Get current user email
        final authCubit = BlocProvider.of<AuthCubit>(context);
        final userEmail = authCubit.state.user?.email;
        
        if (userEmail == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).pleaseSignInToAccessContent)),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // First try to sign in with current password to verify it's correct
        await authCubit.signInWithPassword(userEmail, _currentPasswordController.text);
        
        // If sign in successful, update password
        await authCubit.resetPassword(userEmail, _newPasswordController.text);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).passwordUpdatedSuccessfully)),
        );
        
        GoRouter.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().contains('Exception:') 
            ? e.toString().split('Exception:')[1].trim() 
            : S.of(context).passwordMustBeAtLeast6)),
        );
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

    return BlocListener<AuthCubit, app_auth.AuthState>(
      listener: (context, state) {
        if (state.status == app_auth.AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? localization.passwordMustBeAtLeast6)),
          );
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            onPressed: () => GoRouter.of(context).pop(),
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
                    color: theme.colorScheme.primary,
                    width: double.infinity,
                    isLoading: _isLoading,
                    onTap: _updatePassword,
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

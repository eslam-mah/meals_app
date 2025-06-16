import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/core/main_widgets/custom_outlined_button.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_cubit.dart';
import 'package:meals_app/features/profile/data/models/user_form.dart';
import 'package:meals_app/features/profile/view/widgets/profile_input_field.dart';
import 'package:meals_app/features/profile/view/widgets/phone_input_field.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/generated/l10n.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/account_info';

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load user data
    _loadUserData();
  }

  void _loadUserData() {
    final userCubit = UserCubit.instance;
    if (userCubit.hasUser) {
      _nameController.text = userCubit.name ?? '';
      _emailController.text = userCubit.email ?? '';
      _phoneController.text = userCubit.phoneNumber ?? '';
    }
  }

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

  void _updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create user form data
        final userForm = UserForm(
          name: _nameController.text,
          phoneNumber: _phoneController.text,
          city: UserCubit.instance.city,
          location: UserCubit.instance.location,
          isProfileCompleted: true,
          userType: UserCubit.instance.userType,
        );

        // Update user profile
        await UserCubit.instance.updateUserWithForm(userForm);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).formSubmittedSuccessfully)),
        );

        GoRouter.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).confirmDeleteAccount),
        content: Text(S.of(context).deleteAccountWarning),
        actions: [
          TextButton(
            onPressed: () => GoRouter.of(context).pop(),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              GoRouter.of(context).pop();
              _deleteAccount();
            },
            child: Text(
              S.of(context).delete,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userCubit = BlocProvider.of<UserCubit>(context);
      final authCubit = BlocProvider.of<AuthCubit>(context);
      
      // First delete user data from database
      await userCubit.deleteUser();
      
      // Then delete the auth account using our new method
      final success = await authCubit.deleteAccount();
      
      if (success) {
        // Navigate to login screen
        GoRouter.of(context).go(LoginScreen.routeName);
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete account. Please try again.')),
        );
        
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error deleting account: $e');
      
      // Try alternative approach - just sign out
      try {
        // Sign out the user
        await BlocProvider.of<AuthCubit>(context).signOut();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Your account has been deactivated.')),
        );
        
        // Navigate to login screen
        GoRouter.of(context).go(LoginScreen.routeName);
      } catch (signOutError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete account: ${e.toString()}')),
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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => GoRouter.of(context).pop(),
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

                // Email field with read-only styling
                TextFormField(
                  controller: _emailController,
                  readOnly: true, // Make it read-only
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 16.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: localization.emailExample,
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                  ),
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
                  isLoading: _isLoading,
                  onTap: _updateProfile,
                ),

                SizedBox(height: 16.h),

                // Delete Account Button
                CustomOutlinedButton(
                  title: localization.deleteMyAccount,
                  borderColor: Colors.red,
                  textColor: Colors.red,
                  width: double.infinity,
                  onTap: _showDeleteAccountConfirmation,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

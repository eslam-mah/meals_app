import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_cubit.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_state.dart' as app_auth;
import 'package:meals_app/features/language/cubit/language_cubit.dart';
import 'package:meals_app/features/language/cubit/language_state.dart';
import 'package:meals_app/features/profile/view/views/change_password_screen.dart';
import 'package:meals_app/features/profile/view/views/edit_profile_screen.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/features/settings/view/widgets/language_dialog.dart';
import 'package:meals_app/features/settings/view/widgets/settings_section_header.dart';
import 'package:meals_app/features/settings/view/widgets/settings_list_item.dart';
import 'package:meals_app/generated/l10n.dart';

class SettingsView extends StatefulWidget {
  static const String settingsPath = '/settings';

  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _isLoggingOut = false;

  Future<void> _logout(BuildContext context) async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      // Sign out using AuthCubit
      await context.read<AuthCubit>().signOut();
      
      // Clear user data
      context.read<UserCubit>().clearUser();
      
      if (mounted) {
        // Navigate to login screen
        GoRouter.of(context).go(LoginScreen.routeName);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.settings, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 28.r),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SettingsSectionHeader(title: localization.accountDetails),
          SettingsListItem(
            title: localization.accountInfo, 
            onTap: () { GoRouter.of(context).push(EditProfileScreen.routeName);},
          ),
          SettingsListItem(
            title: localization.changePassword,
            onTap: () { GoRouter.of(context).push(ChangePasswordScreen.routeName);},
          ),
          SettingsSectionHeader(title: localization.preferences),
          BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, state) {
              return SettingsListItem(
                title: localization.language,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.isArabic ? 'العربية' : 'English',
                      style: TextStyle(fontSize: 16.sp, color: Colors.black),
                    ),
                    Icon(Icons.chevron_right, color: Colors.black, size: 24.r),
                  ],
                ),
                onTap: () => _showLanguageDialog(context),
              );
            }
          ),
          SettingsListItem(title: localization.termsAndConditions, trailing: Icon(Icons.chevron_right, color: Colors.black, size: 24.r), onTap: () {}),
          SettingsListItem(title: localization.privacyPolicy, trailing: Icon(Icons.chevron_right, color: Colors.black, size: 24.r), onTap: () {}),
          SettingsSectionHeader(title: localization.appVersion, trailing: Text('4.6.3', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp))),
          BlocListener<AuthCubit, app_auth.AuthState>(
            listener: (context, state) {
              if (state.status == app_auth.AuthStatus.unauthenticated) {
                GoRouter.of(context).go(LoginScreen.routeName);
              }
            },
            child: SettingsListItem(
              title: localization.logout,
              onTap: _isLoggingOut ? null : () => _logout(context),
              trailing: _isLoggingOut 
                ? SizedBox(
                    width: 20.w, 
                    height: 20.h, 
                    child: CircularProgressIndicator(strokeWidth: 2.w)
                  ) 
                : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LanguageDialog(),
    );
  }
} 
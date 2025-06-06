import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/features/language/cubit/language_cubit.dart';
import 'package:meals_app/features/language/cubit/language_state.dart';
import 'package:meals_app/features/profile/view/views/change_password_screen.dart';
import 'package:meals_app/features/profile/view/views/edit_profile_screen.dart';
import 'package:meals_app/features/settings/view/widgets/language_dialog.dart';
import 'package:meals_app/features/settings/view/widgets/settings_section_header.dart';
import 'package:meals_app/features/settings/view/widgets/settings_list_item.dart';
import 'package:meals_app/generated/l10n.dart';

class SettingsView extends StatelessWidget {
  static const String settingsPath = '/settings';

  const SettingsView({super.key});

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
          SettingsListItem(title: localization.logout, onTap: () {}),
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
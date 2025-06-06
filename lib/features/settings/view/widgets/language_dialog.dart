import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/features/language/cubit/language_cubit.dart';
import 'package:meals_app/features/language/cubit/language_state.dart';
import 'package:meals_app/generated/l10n.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final languageCubit = context.read<LanguageCubit>();

    return Dialog(
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dialog title
            Text(
              localization.language,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24.h),
            
            // Language options
            BlocBuilder<LanguageCubit, LanguageState>(
              builder: (context, state) {
                return Column(
                  children: [
                    // English option
                    _buildLanguageOption(
                      context: context,
                      title: 'English',
                      subtitle: 'English',
                      isSelected: state.isEnglish,
                      flagIcon: FontAwesomeIcons.flagUsa,
                      onTap: () {
                        languageCubit.changeLanguage('en');
                        Navigator.pop(context);
                      },
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Arabic option
                    _buildLanguageOption(
                      context: context,
                      title: 'العربية',
                      subtitle: 'Arabic',
                      isSelected: state.isArabic,
                      flagIcon: FontAwesomeIcons.font,
                      onTap: () {
                        languageCubit.changeLanguage('ar');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            ),
            
            SizedBox(height: 24.h),
            
            // Cancel button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  localization.submit,
                  style: TextStyle(
                    color: ColorsBox.primaryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool isSelected,
    required IconData flagIcon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: isSelected ? ColorsBox.primaryColor.withOpacity(0.1) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12.r),
            border: isSelected
                ? Border.all(color: ColorsBox.primaryColor, width: 2.w)
                : Border.all(color: Colors.grey.shade300, width: 1.w),
          ),
          child: Row(
            children: [
              // Flag icon
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: isSelected ? ColorsBox.primaryColor.withOpacity(0.2) : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FaIcon(
                    flagIcon,
                    color: isSelected ? ColorsBox.primaryColor : Colors.grey.shade700,
                    size: 20.r,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              
              // Language name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    if (title != subtitle)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),
                  ],
                ),
              ),
              
              // Selected checkmark
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: ColorsBox.primaryColor,
                  size: 24.r,
                ),
            ],
          ),
        ),
      ),
    );
  }
} 
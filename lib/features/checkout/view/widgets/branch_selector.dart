import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/generated/l10n.dart';

class BranchSelector extends StatelessWidget {
  final List<String> branches;
  final String? selectedBranch;
  final Function(String) onBranchSelected;

  const BranchSelector({
    required this.branches,
    required this.selectedBranch,
    required this.onBranchSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return Column(
      children: [
        for (String branch in branches)
          _buildBranchItem(
            context,
            branch: branch,
            isSelected: selectedBranch == branch,
            onTap: () => onBranchSelected(branch),
          ),
        if (branches.isEmpty)
          Center(
            child: Text(
              localization.anErrorOccurred,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBranchItem(
    BuildContext context, {
    required String branch,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? ColorsBox.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.store,
              color: isSelected ? ColorsBox.primaryColor : Colors.grey,
              size: 24.r,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                branch,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? ColorsBox.primaryColor : Colors.black,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: ColorsBox.primaryColor,
                size: 24.r,
              ),
          ],
        ),
      ),
    );
  }
} 
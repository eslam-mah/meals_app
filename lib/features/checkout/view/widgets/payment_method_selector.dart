import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/generated/l10n.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final Function(String) onMethodSelected;

  const PaymentMethodSelector({
    required this.selectedMethod,
    required this.onMethodSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    
    final paymentMethods = [
      {
        'id': 'cash',
        'title': localization.cashOnDelivery,
        'icon': Icons.payments_outlined,
      },
      {
        'id': 'card',
        'title': localization.creditCard,
        'icon': Icons.credit_card,
      },
    ];

    return Column(
      children: [
        for (var method in paymentMethods)
          _buildPaymentMethodItem(
            context,
            id: method['id'] as String,
            title: method['title'] as String,
            icon: method['icon'] as IconData,
            isSelected: selectedMethod == method['id'],
            onTap: () => onMethodSelected(method['id'] as String),
          ),
      ],
    );
  }

  Widget _buildPaymentMethodItem(
    BuildContext context, {
    required String id,
    required String title,
    required IconData icon,
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
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: isSelected 
                    ? ColorsBox.primaryColor.withOpacity(0.1) 
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? ColorsBox.primaryColor : Colors.grey,
                size: 24.r,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            isSelected
                ? Icon(
                    Icons.radio_button_checked,
                    color: ColorsBox.primaryColor,
                    size: 24.r,
                  )
                : Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.grey.shade400,
                    size: 24.r,
                  ),
          ],
        ),
      ),
    );
  }
} 
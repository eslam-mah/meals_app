import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/features/checkout/view_model/cubits/checkout_cubit.dart';
import 'package:meals_app/features/checkout/view_model/cubits/checkout_state.dart';
import 'package:meals_app/generated/l10n.dart';

class PromoCodeField extends StatefulWidget {
  const PromoCodeField({Key? key}) : super(key: key);

  @override
  State<PromoCodeField> createState() => _PromoCodeFieldState();
}

class _PromoCodeFieldState extends State<PromoCodeField> {
  final TextEditingController _promoController = TextEditingController();
  final FocusNode _promoFocusNode = FocusNode();

  @override
  void dispose() {
    _promoController.dispose();
    _promoFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listenWhen: (previous, current) => 
        previous.appliedPromoCode != current.appliedPromoCode ||
        previous.promoCodeError != current.promoCodeError,
      listener: (context, state) {
        if (state.appliedPromoCode != null && _promoController.text.isNotEmpty) {
          _promoFocusNode.unfocus();
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).promoCode,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (state.appliedPromoCode != null) ...[
                    _buildAppliedPromoCode(context, state),
                  ] else ...[
                    _buildPromoCodeInput(context, state),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAppliedPromoCode(BuildContext context, CheckoutState state) {
    final promoCode = state.appliedPromoCode!;
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: ColorsBox.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.local_offer,
                color: ColorsBox.primaryColor,
                size: 24.r,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        promoCode.code,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorsBox.primaryColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          "${promoCode.percentage}% OFF",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    promoCode.type,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<CheckoutCubit>().removePromoCode();
                _promoController.clear();
              },
              child: Text(
                S.of(context).remove,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPromoCodeInput(BuildContext context, CheckoutState state) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _promoController,
                focusNode: _promoFocusNode,
                decoration: InputDecoration(
                  hintText: S.of(context).enterPromoCode,
                  prefixIcon: Icon(
                    Icons.local_offer,
                    color: Colors.grey,
                    size: 24.r,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: ColorsBox.primaryColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                enabled: !state.isApplyingPromoCode,
              ),
            ),
            SizedBox(width: 12.w),
            ElevatedButton(
              onPressed: state.isApplyingPromoCode
                  ? null
                  : () {
                      final code = _promoController.text.trim();
                      context.read<CheckoutCubit>().applyPromoCode(code);
                    },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: ColorsBox.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: state.isApplyingPromoCode
                  ? SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.r,
                      ),
                    )
                  : Text(
                      S.of(context).apply,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
        if (state.promoCodeError != null) ...[
          SizedBox(height: 8.h),
          Text(
            state.promoCodeError!,
            style: TextStyle(
              color: Colors.red,
              fontSize: 14.sp,
            ),
          ),
        ],
      ],
    );
  }
} 
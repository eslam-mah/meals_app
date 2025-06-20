import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/features/saved_addresses/data/models/address_model.dart';
import 'package:meals_app/features/saved_addresses/view_model/cubits/address_cubit.dart';
import 'package:meals_app/generated/l10n.dart';

class AddressItem extends StatelessWidget {
  final AddressModel address;
  final VoidCallback? onEdit;

  const AddressItem({
    super.key,
    required this.address,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final addressCubit = context.read<AddressCubit>();
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1.h,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Address info and delete button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Primary indicator
                if (address.isPrimary)
                  Padding(
                    padding: EdgeInsets.only(right: 8.w, top: 2.h),
                    child: Icon(
                      Icons.star,
                      color: ColorsBox.primaryColor,
                      size: 20.r,
                    ),
                  ),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // City and area
                          Text(
                            '${address.city} - ${address.area}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // Primary tag
                          if (address.isPrimary)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: ColorsBox.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                localization.primary,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: ColorsBox.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      // Detailed address
                      Text(
                        address.address,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Delete button
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red.shade600,
                    size: 24.r,
                  ),
                  onPressed: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(localization.deleteAddress),
                        content: Text(localization.areYouSureYouWantToDeleteThisAddress),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(localization.cancel),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              addressCubit.deleteAddress(address.id);
                            },
                            child: Text(
                              localization.delete,
                              style: const TextStyle(color: Colors.red),
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
          
          // Action buttons
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
            child: Row(
              children: [
                // Mark as primary button (only show if not primary)
                Expanded(
                  child: !address.isPrimary
                      ? CustomButton(
                          title: localization.markAsPrimary,
                          onTap: () => addressCubit.setPrimaryAddress(address.id),
                          color: ColorsBox.primaryColor,
                          height: 45.h,
                          icon: Icon(Icons.radio_button_checked, color: Colors.white, size: 18.r),
                        )
                      : CustomButton(
                          title: localization.primaryAddress,
                          onTap: () {}, // Empty function to avoid null issue
                          isEnabled: false,
                          color: Colors.grey.shade300,
                          textColor: Colors.grey.shade700,
                          height: 45.h,
                          icon: Icon(Icons.check_circle, color: Colors.grey.shade700, size: 18.r),
                        ),
                ),
                SizedBox(width: 12.w),
                // Edit button
                SizedBox(
                  width: 100.w,
                  height: 45.h,
                  child: CustomButton(
                    textColor: Colors.black87,
                    title: localization.edit,
                    onTap: onEdit ?? () {}, // Empty function to avoid null issue
                    color: Colors.grey.shade200,
                    height: 45.h,
                    icon: Icon(Icons.edit, color: Colors.black87, size: 18.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 
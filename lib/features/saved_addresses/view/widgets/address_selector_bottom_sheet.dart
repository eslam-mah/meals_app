import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/features/saved_addresses/data/models/address_model.dart';
import 'package:meals_app/features/saved_addresses/view/views/saved_addresses_view.dart';
import 'package:meals_app/features/saved_addresses/view_model/cubits/address_cubit.dart';
import 'package:meals_app/generated/l10n.dart';

class AddressSelectorBottomSheet extends StatelessWidget {
  final Function(AddressModel) onAddressSelected;

  const AddressSelectorBottomSheet({
    required this.onAddressSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader(context, localization),
          
          // Addresses list
          Flexible(
            child: BlocBuilder<AddressCubit, AddressState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (state.addresses.isEmpty) {
                  return _buildEmptyState(context, localization);
                }
                
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
                  shrinkWrap: true,
                  itemCount: state.addresses.length,
                  itemBuilder: (context, index) {
                    final address = state.addresses[index];
                    return _buildAddressItem(context, address);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, S localization) {
    return Column(
      children: [
        // Handle bar
        Container(
          margin: EdgeInsets.symmetric(vertical: 12.h),
          width: 40.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        
        // Title
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Text(
            localization.selectDeliveryAddress,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        // Add address button
        InkWell(
          onTap: () {
            Navigator.pop(context);
            context.push(SavedAddressesView.savedAddressesPath);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.add_location_alt, color: ColorsBox.primaryColor, size: 24.r),
                SizedBox(width: 12.w),
                Text(
                  localization.addNewAddress,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorsBox.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        Divider(height: 16.h, thickness: 1.h, color: Colors.grey.shade200),
      ],
    );
  }
  
  Widget _buildEmptyState(BuildContext context, S localization) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined, size: 64.r, color: Colors.grey),
          SizedBox(height: 16.h),
          Text(
            localization.noAddressesFound,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            localization.addYourFirstAddress,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
  
  Widget _buildAddressItem(BuildContext context, AddressModel address) {
    return InkWell(
      onTap: () {
        onAddressSelected(address);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: address.isPrimary ? ColorsBox.primaryColor : Colors.grey.shade300,
            width: address.isPrimary ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: address.isPrimary ? ColorsBox.primaryColor : Colors.grey,
                  size: 20.r,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    '${address.city} - ${address.area}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (address.isPrimary)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: ColorsBox.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      S.of(context).primary,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ColorsBox.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.only(left: 28.w),
              child: Text(
                address.address,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
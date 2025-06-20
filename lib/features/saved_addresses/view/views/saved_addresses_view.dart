import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/features/saved_addresses/data/models/address_model.dart';
import 'package:meals_app/features/saved_addresses/view/widgets/address_item.dart';
import 'package:meals_app/features/saved_addresses/view/widgets/add_address_bottom_sheet.dart';
import 'package:meals_app/features/saved_addresses/view_model/cubits/address_cubit.dart';
import 'package:meals_app/generated/l10n.dart';

class SavedAddressesView extends StatefulWidget {
  static const String savedAddressesPath = '/saved-addresses';

  const SavedAddressesView({super.key});

  @override
  State<SavedAddressesView> createState() => _SavedAddressesViewState();
}

class _SavedAddressesViewState extends State<SavedAddressesView> {
  @override
  void initState() {
    super.initState();
    // Load addresses when the view is opened
    context.read<AddressCubit>().loadUserAddresses();
  }

  // Open the add address bottom sheet
  void _openAddAddressSheet(BuildContext context) {
    final addressCubit = context.read<AddressCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (context) => BlocProvider.value(
        value: addressCubit,
        child: const AddAddressBottomSheet(),
      ),
    );
  }
  
  // Open the edit address bottom sheet
  void _openEditAddressSheet(BuildContext context, AddressModel address) {
    final addressCubit = context.read<AddressCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (context) => BlocProvider.value(
        value: addressCubit,
        child: AddAddressBottomSheet(addressToEdit: address),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.savedAddressesScreen,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 28.r),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: BlocConsumer<AddressCubit, AddressState>(
        listener: (context, state) {
          // Show errors if any
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
            // Clear error message
            context.read<AddressCubit>().clearError();
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // List of addresses
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.addresses.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_off,
                                  size: 80.r,
                                  color: Colors.grey.shade400,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  localization.noAddressesFound,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  localization.addYourFirstAddress,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(top: 16.h),
                            itemCount: state.addresses.length,
                            itemBuilder: (context, index) {
                              return AddressItem(
                                address: state.addresses[index],
                                onEdit: () => _openEditAddressSheet(
                                  context, 
                                  state.addresses[index],
                                ),
                              );
                            },
                          ),
              ),
              
              // Add new address button
              Padding(
                padding: EdgeInsets.all(16.h),
                child: CustomButton(
                  title: localization.addNewAddress,
                  onTap: () => _openAddAddressSheet(context),
                  icon: Icon(Icons.add_circle_outline, color: Colors.white, size: 20.r),
                  color: ColorsBox.primaryColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 
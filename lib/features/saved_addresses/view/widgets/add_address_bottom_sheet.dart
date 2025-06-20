import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/features/saved_addresses/data/models/address_model.dart';
import 'package:meals_app/features/saved_addresses/view_model/cubits/address_cubit.dart';
import 'package:meals_app/generated/l10n.dart';

class AddAddressBottomSheet extends StatefulWidget {
  final AddressModel? addressToEdit;

  const AddAddressBottomSheet({
    super.key,
    this.addressToEdit,
  });

  @override
  State<AddAddressBottomSheet> createState() => _AddAddressBottomSheetState();
}

class _AddAddressBottomSheetState extends State<AddAddressBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _areaController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isLoading = false;

  // City is taken from the user profile and cannot be changed
  late String _city;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    // Get user city
    _city = UserCubit.instance.city ?? 'cairo';

    // If editing, prefill the form
    if (widget.addressToEdit != null) {
      _areaController.text = widget.addressToEdit!.area;
      _addressController.text = widget.addressToEdit!.address;
    }
  }

  @override
  void dispose() {
    _areaController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Validate form inputs
  String? _validateArea(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).pleaseEnterArea;
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).pleaseEnterAddress;
    }
    return null;
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final addressCubit = context.read<AddressCubit>();
      final position = await addressCubit.getCurrentLocation();
      if (position != null) {
        setState(() {
          _currentPosition = position;
        });
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        final localization = S.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${localization.failedToGetLocation}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Save the address
  Future<void> _saveAddress() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final area = _areaController.text.trim();
      final address = _addressController.text.trim();
      
      final addressCubit = context.read<AddressCubit>();
      bool success;
      
      if (widget.addressToEdit != null) {
        // Update existing address
        success = await addressCubit.updateAddress(
          id: widget.addressToEdit!.id,
          area: area,
          address: address,
        );
      } else if (_currentPosition != null) {
        // Create new address with location
        success = await addressCubit.createAddressFromCurrentLocation(
          area: area,
          address: address,
        );
      } else {
        // Create new address without location
        success = await addressCubit.createAddress(
          area: area,
          address: address,
        );
      }

      if (success && mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        final localization = S.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${localization.failedToSaveAddress}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
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

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.w,
        right: 16.w,
        top: 16.h,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                widget.addressToEdit != null
                    ? localization.editAddress
                    : localization.addAddress,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // City (non-editable)
            Text(
              localization.cityLabel,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_city,
                    color: Colors.grey.shade700,
                    size: 20.r,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    _city.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.lock,
                    color: Colors.grey.shade700,
                    size: 16.r,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Area
            Text(
              localization.areaLabel,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _areaController,
              validator: _validateArea,
              decoration: InputDecoration(
                hintText: localization.enterYourArea,
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Address
            Text(
              localization.detailedAddressLabel,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _addressController,
              validator: _validateAddress,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: localization.detailedAddressHint,
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Use current location button
            // if (widget.addressToEdit == null)
            //   CustomButton(
            //     title: localization.useCurrentLocation,
            //     onTap: _getCurrentLocation,
            //     isLoading: _isLoading && _currentPosition == null,
            //     color: ColorsBox.primaryColor,
            //     height: 50.h,
            //     icon: Icon(Icons.my_location, color: Colors.white, size: 20.r),
            //     width: double.infinity,
            //   ),

            // SizedBox(height: 16.h),

            // Current location indicator
            if (_currentPosition != null)
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.green.shade300, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green.shade700,
                            size: 20.r,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localization.locationCapturedSuccessfully,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                localization.yourExactCoordinatesWereCaptured,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.red.shade600,
                            size: 20.r,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'monospace',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 24.h),

            // Save button
            CustomButton(
              title: widget.addressToEdit != null ? localization.updateAddress : localization.saveAddress,
              onTap: _saveAddress,
              isLoading: _isLoading && _currentPosition != null,
              color: ColorsBox.primaryColor,
              width: double.infinity,
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/core/services/connectivity_service.dart';
import 'package:meals_app/core/main_widgets/connectivity_dialog.dart';
import 'package:meals_app/features/saved_addresses/data/models/address_model.dart';
import 'package:meals_app/features/saved_addresses/view/widgets/address_item.dart';
import 'package:meals_app/features/saved_addresses/view/widgets/add_address_bottom_sheet.dart';
import 'package:meals_app/features/saved_addresses/view_model/cubits/address_cubit.dart';
import 'package:meals_app/generated/l10n.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

class SavedAddressesView extends StatefulWidget {
  static const String savedAddressesPath = '/saved-addresses';

  const SavedAddressesView({super.key});

  @override
  State<SavedAddressesView> createState() => _SavedAddressesViewState();
}

class _SavedAddressesViewState extends State<SavedAddressesView> {
  // final Logger _log = Logger('SavedAddressesView');
  // bool _isConnected = true;
  // bool _isDialogShowing = false;
  // StreamSubscription<bool>? _connectivitySubscription;
  // final ConnectivityService _connectivityService = ConnectivityService.instance;

  @override
  void initState() {
    super.initState();
    // _initConnectivity();
    // Load addresses when the view is opened
    context.read<AddressCubit>().loadUserAddresses();
  }

  // @override
  // void dispose() {
  //   _connectivitySubscription?.cancel();
  //   _connectivitySubscription = null;
  //   super.dispose();
  // }

  // /// Initialize connectivity monitoring
  // Future<void> _initConnectivity() async {
  //   if (!mounted) return;
    
  //   _log.info('Initializing connectivity monitoring');
    
  //   // Check initial connectivity status
  //   _isConnected = await _connectivityService.forceCheck();
  //   _log.info('Initial connectivity status: ${_isConnected ? "Connected" : "Disconnected"}');
    
  //   // If initially disconnected, show dialog
  //   if (!_isConnected && mounted && !_isDialogShowing) {
  //     _log.info('Initially disconnected, showing dialog');
  //     _showConnectivityDialog();
  //   }
    
  //   // Listen for connectivity changes
  //   _connectivitySubscription = _connectivityService.onConnectivityChanged.listen(_handleConnectivityChange);
  //   _log.info('Connectivity listener set up');
  // }
  
  // /// Handle changes in connectivity status
  // void _handleConnectivityChange(bool isConnected) {
  //   _log.info('Connectivity changed: ${isConnected ? "Connected" : "Disconnected"}');
    
  //   if (!mounted) {
  //     _log.warning('Widget not mounted during connectivity change');
  //     return;
  //   }
    
  //   // Only show dialog if we transition from connected to disconnected
  //   if (_isConnected && !isConnected && !_isDialogShowing) {
  //     _log.info('Connection lost, showing dialog immediately');
  //     _showConnectivityDialog();
  //   }
    
  //   setState(() {
  //     _isConnected = isConnected;
  //   });
  // }
  
  // /// Show connectivity dialog when connection is lost
  // void _showConnectivityDialog() {
  //   if (!mounted || _isDialogShowing) return;
    
  //   _log.info('Showing connectivity dialog');
  //   _isDialogShowing = true;
    
  //   ConnectivityDialog.show(
  //     context,
  //     onConnected: () {
  //       _log.info('Connection restored callback from dialog');
        
  //       if (mounted) {
  //         setState(() {
  //           _isDialogShowing = false;
  //         });
          
  //         // Reload addresses when connection is restored
  //         context.read<AddressCubit>().loadUserAddresses();
  //       } else {
  //         _isDialogShowing = false;
  //       }
  //     },
  //   ).catchError((error) {
  //     _log.severe('Error showing dialog: $error');
  //     _isDialogShowing = false;
  //   });
  // }

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
          // Show shimmer while loading and no addresses have been loaded yet
          if (state.isLoading && state.addresses.isEmpty) {
            return _buildAddressesShimmer();
          }
          
          if (state.errorMessage != null && state.addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage!),
                  SizedBox(height: 16.h),
                  CustomButton(
                    title: localization.tryAgain,
                    onTap: () => context.read<AddressCubit>().loadUserAddresses(),
                    color: ColorsBox.primaryColor,
                  ),
                ],
              ),
            );
          }
          
          return Column(
            children: [
              // List of addresses
              Expanded(
                child: state.addresses.isEmpty
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

  Widget _buildAddressesShimmer() {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: List.generate(3, (index) => 
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Container(
                width: double.infinity,
                height: 140.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
} 
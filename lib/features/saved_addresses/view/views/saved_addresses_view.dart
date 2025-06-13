import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/features/saved_addresses/view/widgets/address_item.dart';
import 'package:meals_app/generated/l10n.dart';

class SavedAddressesView extends StatelessWidget {
  static const String savedAddressesPath = '/saved-addresses';

  const SavedAddressesView({super.key});

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
      body: Column(
        children: [
          // List of addresses
          Expanded(
            child: 
                ListView.builder(
                    padding: EdgeInsets.only(top: 16.h),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return AddressItem(
                      
                      );
                    },
                  ),
          ),
          
          // Add new address button
          Padding(
            padding: EdgeInsets.all(16.h),
            child: CustomButton(
              title: localization.addNewAddress,
              onTap: () {
                // Logic to add a new address would go here
              },
              icon: Icon(Icons.add_circle_outline, color: Colors.white, size: 20.r),
              color: ColorsBox.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
} 
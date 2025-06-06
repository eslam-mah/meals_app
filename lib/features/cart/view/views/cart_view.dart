import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/main_widgets/custom_button.dart';
import 'package:meals_app/features/cart/view/widgets/cart_item.dart';
import 'package:meals_app/features/cart/view/widgets/delivery_type_selector.dart';
import 'package:meals_app/features/home/view/views/main_view.dart';
import 'package:meals_app/generated/l10n.dart';

class CartView extends StatelessWidget {
  static const String cartPath = '/cart';

  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          '${localization.myCart} (10 ${localization.items})',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Title - Items
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Text(
              localization.items,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: ColorsBox.primaryColor,
              ),
            ),
          ),

          // Cart Items List
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.r),
              children: [
                // List of cart items
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return const CartItem();
                  },
                ),
                
                // Special Requests Section
                SizedBox(height: 16.h),
                const SpecialRequestsSection(),
                SizedBox(height: 16.h),
                DeliveryTypeSelector(),
                // Summary Section
                SizedBox(height: 24.h),
                const _PriceSummarySection(),
                
                // Add more items button
                SizedBox(height: 16.h),
                const _AddMoreItemsButton(),
                
                SizedBox(height: 100.h), // Bottom padding for checkout button
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, -2),
            )
          ],
        ),
        child: CustomButton(
          title: localization.checkout,
          onTap: () {},
          color: ColorsBox.primaryColor,
        ),
      ),
    );
  }
}

class SpecialRequestsSection extends StatelessWidget {
  const SpecialRequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          '${localization.specialRequests} (${localization.optional})',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 4.h),
        
        // Note about extras
        Text(
          localization.noExtrasAllowed,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 12.h),
        
        // Text Field
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: localization.typeYourSpecialRequestsHere,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(16.r),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _PriceSummarySection extends StatelessWidget {
  const _PriceSummarySection();

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    
    return Column(
      children: [
        // Subtotal Row
        _buildPriceRow(
          label: localization.subTotal,
          amount: '140.35EGP',
          isBold: false,
        ),
        SizedBox(height: 8.h),
        
        // VAT Row
        _buildPriceRow(
          label: localization.vat,
          amount: '19.65 EGP',
          isBold: false,
        ),
        
        // Divider
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Divider(
            height: 1.h,
            color: Colors.grey.shade300,
          ),
        ),
        
        // Total Row
        _buildPriceRow(
          label: localization.total,
          amount: '160.00 EGP',
          isBold: true,
          isLarge: true,
        ),
      ],
    );
  }

  Widget _buildPriceRow({
    required String label,
    required String amount,
    required bool isBold,
    bool isLarge = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isLarge ? 20.sp : 16.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isLarge ? 20.sp : 16.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _AddMoreItemsButton extends StatelessWidget {
  const _AddMoreItemsButton();

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    
    return TextButton(
      onPressed: () {
         GoRouter.of(context).push(MainView.mainPath);
      },
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            color: ColorsBox.primaryColor,
            size: 20.r,
          ),
          SizedBox(width: 4.w),
          Text(
            localization.addMoreItems,
            style: TextStyle(
              color: ColorsBox.primaryColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 
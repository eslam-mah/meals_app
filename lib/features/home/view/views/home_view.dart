import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/features/cart/view/views/cart_view.dart';
import 'package:meals_app/features/home/view/widgets/delivery_location.dart';
import 'package:meals_app/features/home/view/widgets/hot_offer_card.dart';
import 'package:meals_app/features/home/view/widgets/recommended_item.dart';
import 'package:meals_app/generated/l10n.dart';

class HomeView extends StatelessWidget {
    static const String homePath = '/home';

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final S localization = S.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            // User greeting and icons
            _buildHeader(context, localization),
            
            // Main content with Expanded
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery location
                    const DeliveryLocation(),
                    
                   SizedBox(height: 16.h),
                    
                    // Hot offers section
                    _buildSectionTitle(localization.offers),
                    
                    SizedBox(height: 12.h),
                    
                    // Hot offers horizontal list
                    SizedBox(
                      height: 180.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(left: 16.w),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return HotOfferCard();
                        },
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Recommended section
                    _buildSectionTitle(localization.recommended),
                    
                    SizedBox(height: 8.h),
                    
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        localization.recommendedDescription,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Recommended meals list
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child:  RecommendedItem(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, S localization) {
    return Container(
      padding: EdgeInsets.all(16.r),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User greeting
          Text(
            localization.hello('Eslam'),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          
          // Icons
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(50.r),
                  onTap: () {
                    GoRouter.of(context).push(CartView.cartPath);
                  },
                  child: Ink(
                    width: 45.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: ColorsBox.primaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_basket_outlined,
                      color: ColorsBox.primaryColor,
                      size: 25.r,
                    ),
                  ),
                ),
              ),
             
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: ColorsBox.primaryColor,
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/cart/view/views/cart_view.dart';
import 'package:meals_app/features/home/view/widgets/delivery_location.dart';
import 'package:meals_app/features/home/view/widgets/meal_card.dart';
import 'package:meals_app/generated/l10n.dart';

class MenuView extends StatelessWidget {
  static const String menuPath = '/menu';

  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final S localization = S.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, localization),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 12.h,
                  mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    DeliveryLocation(),
                    // Hot offers section
                    _buildSectionTitle(localization.menu),

                    // Hot deals list
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: const MealCard(),
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

Widget _buildHeader(BuildContext context, S localization) {
  final StorageService storageService = StorageService();
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
   if(storageService.isAuthenticated()){
                      GoRouter.of(context).push(CartView.cartPath);
                    }else{
                      GoRouter.of(context).push(LoginScreen.routeName);
                    }                },
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/features/cart/view/views/cart_view.dart';
import 'package:meals_app/features/feedback/view/views/feedback_view.dart';
import 'package:meals_app/features/home/view/widgets/profile_header.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/features/saved_addresses/view/views/saved_addresses_view.dart';
import 'package:meals_app/generated/l10n.dart';

class ProfileView extends StatefulWidget {
  static const String profilePath = '/profile';

  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    _initializeUserCubit();
  }

  void _initializeUserCubit() {
    // Ensure UserCubit is initialized and loads user data
    if (UserCubit.instance.state.user == null) {
      UserCubit.instance.loadUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w, top: 24.h, bottom: 8.h),
              child: Text(
                localization.profile,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ProfileHeader(),
            Divider(height: 1, color: Colors.grey.shade300),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.shopping_bag, color: ColorsBox.primaryColor, size: 28.r),
                    title: Text(localization.myOrders, style: TextStyle(fontSize: 17.sp)),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.home, color: ColorsBox.primaryColor, size: 28.r),
                    title: Text(localization.savedAddresses, style: TextStyle(fontSize: 17.sp)),
                    onTap: () {
                      GoRouter.of(context).push(SavedAddressesView.savedAddressesPath);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.shopping_cart, color: ColorsBox.primaryColor, size: 28.r),
                    title: Text(localization.cart, style: TextStyle(fontSize: 17.sp)),
                    onTap: () {
                      GoRouter.of(context).push(CartView.cartPath);

                    },
                  ),
              
                  ListTile(
                    leading: Icon(Icons.feedback, color: ColorsBox.primaryColor, size: 28.r),
                    title: Text(localization.feedback, style: TextStyle(fontSize: 17.sp)),
                    onTap: () {
                      GoRouter.of(context).push(FeedbackView.feedbackPath);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.phone, color: ColorsBox.primaryColor, size: 28.r),
                    title: Text(localization.callSupport, style: TextStyle(fontSize: 17.sp)),
                    trailing: Text(
                      '19914',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
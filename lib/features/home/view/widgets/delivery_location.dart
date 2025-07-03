import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/generated/l10n.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 1. الدالة التي تجلب حالة المطعم من السيرفر/Supabase
Future<bool> isRestaurantClosed() async {
  final supabase = Supabase.instance.client;
  final response = await supabase
      .from('users')
      .select('active')
      .eq('user_type', 'admin');

  final List admins = response;

  // If any admin is inactive (active == false or null), return true
  for (var admin in admins) {
    if (admin['active'] != true) {
      return true; // There is at least one inactive admin
    }
  }
  return false; // All admins are active
}

// 2. الودجت:
class DeliveryLocation extends StatelessWidget {
  final bool isClosed;
  const DeliveryLocation({super.key, required this.isClosed});

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return FutureBuilder<bool>(
      future: isRestaurantClosed(),
      builder: (context, snapshot) {
        // أثناء التحميل
        if (!snapshot.hasData) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1.h),
                ),
              ),
              height: 64.h, // تقريباً نفس ارتفاع اللوكيشن بار
            ),
          );
        }

        // لو المطعم مغلق (لا يستقبل طلبات)
        if (snapshot.data == true) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.red.shade200, width: 1.h),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.faceSadTear,
                  color: Colors.red,
                  size: 40.r,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    localization.noOrdersNow,
                    style: TextStyle(
                      color: Colors.red.shade900,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // لو المطعم شغّال: يظهر اللوكيشن العادي (مع بلوك)
        return BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            final userLocation = state.user?.location ?? '';
            return Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1.h),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: ColorsBox.primaryColor,
                    size: 40.r,
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization.deliveryTo,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorsBox.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(
                            width: 300.w,
                            child: Text(
                              userLocation,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

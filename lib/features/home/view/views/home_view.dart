import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/core/main_widgets/custom_error_widget.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/cart/view/views/cart_view.dart';
import 'package:meals_app/features/cart/view/widgets/cart_indicator.dart';
import 'package:meals_app/features/home/view/widgets/delivery_location.dart';
import 'package:meals_app/features/home/view/widgets/hot_offer_card.dart';
import 'package:meals_app/features/home/view/widgets/recommended_item.dart';
import 'package:meals_app/features/home/view_model/cubits/food_cubit.dart';
import 'package:meals_app/features/home/view_model/cubits/food_state.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/generated/l10n.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:meals_app/features/home/view/widgets/loyalty_points_info_bottom_sheet.dart';


class HomeView extends StatefulWidget {
  static const String homePath = '/home';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();
  bool? _isRestaurantClosed;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _setupScrollListener();
    _initializeUserCubit();
    _checkRestaurantClosed(); // تحقق في البداية
  }

  void _initializeUserCubit() {
    if (UserCubit.instance.state.user == null) {
      context.read<UserCubit>().loadUser();
    }
  }

  void _loadInitialData() async {
    final foodCubit = context.read<FoodCubit>();
    foodCubit.loadInitialData();
    context.read<UserCubit>().loadUser();
    _checkRestaurantClosed(); // تحقق عند تحميل البيانات
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final foodCubit = context.read<FoodCubit>();
        final state = foodCubit.state;

        if (state.recommendedStatus != FoodStatus.loadingMore &&
            state.hasMoreRecommended) {
          foodCubit.loadMoreRecommendedItems();
          context.read<UserCubit>().loadUser();
        }
      }
    });
  }

  // الدالة التي تجلب حالة اغلاق المطعم وتخزنها في المتغير المحلي
  Future<void> _checkRestaurantClosed() async {
    final isClosed = await context.read<UserCubit>().isRestaurantClosed();
    setState(() {
      _isRestaurantClosed = isClosed;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // تحديث حالة اغلاق المطعم عند الريفريش مع البيانات الأخرى
  Future<void> _handleRefresh() async {
    await _checkRestaurantClosed(); // تحقق مع كل ريفرش
    final foodCubit = context.read<FoodCubit>();
    await Future.wait([
      foodCubit.loadRecommendedItems(refresh: true),
      foodCubit.loadOfferItems(refresh: true),
    ]);
    context.read<UserCubit>().loadUser();
  }

  void _showLoyaltyPointsInfo(BuildContext context) {
    final user = context.read<UserCubit>().state.user;
    final int points = user?.loyaltyPoints ?? 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => LoyaltyPointsInfoBottomSheet(
        loyaltyPoints: points,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final S localization = S.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, localization),
              Expanded(
                child: Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: _handleRefresh,
                      displacement: 32.h,
                      edgeOffset: 10.h,
                      color: ColorsBox.primaryColor,
                      backgroundColor: Colors.white,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DeliveryLocation(
                              isClosed: _isRestaurantClosed ?? false,
                            ),
                            SizedBox(height: 16.h),
                            BlocBuilder<FoodCubit, FoodState>(
                              buildWhen:
                                  (previous, current) =>
                                      previous.offerItems !=
                                          current.offerItems ||
                                      previous.offerStatus !=
                                          current.offerStatus,
                              builder: (context, state) {
                                if (state.offerStatus == FoodStatus.error) {
                                  return CustomErrorWidget(
                                    errorMessage:
                                        Intl.getCurrentLocale() == 'ar'
                                            ? 'خطأ في تحميل العروض'
                                            : 'Error loading offers',
                                    padding: EdgeInsets.symmetric(
                                      vertical: 20.h,
                                    ),
                                  );
                                }

                                if (state.offerItems.isEmpty) {
                                  return SizedBox.shrink();
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionTitle(localization.offers),
                                    SizedBox(height: 12.h),
                                    SizedBox(
                                      height: 180.h,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.only(left: 16.w),
                                        itemCount: state.offerItems.length,
                                        itemBuilder: (context, index) {
                                          return HotOfferCard(
                                            food: state.offerItems[index],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 30.h),
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
                            BlocBuilder<FoodCubit, FoodState>(
                              buildWhen:
                                  (previous, current) =>
                                      previous.recommendedItems !=
                                          current.recommendedItems ||
                                      previous.recommendedStatus !=
                                          current.recommendedStatus,
                              builder: (context, state) {
                                if (state.recommendedStatus ==
                                        FoodStatus.loading &&
                                    state.recommendedItems.isEmpty) {
                                  return Column(
                                    children: [
                                      _buildOfferItemsShimmer(),
                                      SizedBox(height: 16.h),
                                      _buildRecommendedItemsShimmer(),
                                    ],
                                  );
                                }

                                if (state.recommendedStatus ==
                                        FoodStatus.error &&
                                    state.recommendedItems.isEmpty) {
                                  return CustomErrorWidget(
                                    errorMessage:
                                        Intl.getCurrentLocale() == 'ar'
                                            ? 'خطأ في تحميل التوصيات'
                                            : 'Error loading recommendations',
                                    padding: EdgeInsets.symmetric(
                                      vertical: 40.h,
                                    ),
                                  );
                                }

                                if (state.recommendedItems.isEmpty) {
                                  return CustomErrorWidget(
                                    errorMessage:
                                        Intl.getCurrentLocale() == 'ar'
                                            ? 'لا توجد توصيات متاحة'
                                            : 'No recommendations available',
                                    padding: EdgeInsets.symmetric(
                                      vertical: 40.h,
                                    ),
                                    textColor: Colors.grey,
                                    icon: Icons.no_meals_outlined,
                                  );
                                }

                                return Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      itemCount: state.recommendedItems.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 12.h,
                                          ),
                                          child: RecommendedItem(
                                            food: state.recommendedItems[index],
                                          ),
                                        );
                                      },
                                    ),
                                    if (state.recommendedStatus ==
                                        FoodStatus.loadingMore)
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16.h,
                                        ),
                                        child: _buildRecommendedItemShimmer(),
                                      ),
                                    SizedBox(height: 80.h),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: const CartIndicator(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferItemsShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 18.w, right: 16.w),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 100.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 16.w),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  margin: EdgeInsets.only(right: 20.w),
                  width: 300.w,
                  height: 180.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedItemsShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: List.generate(3, (index) => _buildRecommendedItemShimmer()),
      ),
    );
  }

  Widget _buildRecommendedItemShimmer() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: EdgeInsets.only(top: 60.h, bottom: 16.h),
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            PositionedDirectional(
              top: 0,
              start: 16.w,
              child: Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.white,
                ),
              ),
            ),
          ],
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
          BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              final userName = state.user?.name ?? '';
              final StorageService storageService = StorageService();
              final isAuthenticated = storageService.isAuthenticated();
              return SizedBox(
                width: 250.w,
                child: Text(
                  isAuthenticated
                      ? localization.hello(userName)
                      : localization.welcomeToMealsApp,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          ),
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(50.r),
                  onTap: () {
                    _showLoyaltyPointsInfo(context);
                  },
                  child: Ink(
                    width: 90.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.r),
                      color: ColorsBox.primaryColor.withOpacity(0.1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          context
                                  .read<UserCubit>()
                                  .state
                                  .user
                                  ?.loyaltyPoints
                                  .toString() ??
                              '0',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: ColorsBox.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Icon(
                          FontAwesomeIcons.star,
                          color: ColorsBox.primaryColor,
                          size: 20.r,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(50.r),
                  onTap: () {
                    if (storageService.isAuthenticated()) {
                      GoRouter.of(context).push(CartView.cartPath);
                    } else {
                      GoRouter.of(context).push(LoginScreen.routeName);
                    }
                  },
                  child: Ink(
                    width: 45.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: ColorsBox.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
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

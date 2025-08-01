import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/main_widgets/custom_error_widget.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/cart/view/views/cart_view.dart';
import 'package:meals_app/features/cart/view/widgets/cart_indicator.dart';
import 'package:meals_app/features/home/view/widgets/delivery_location.dart';
import 'package:meals_app/features/home/view/widgets/loyalty_points_info_bottom_sheet.dart';
import 'package:meals_app/features/home/view/widgets/meal_card.dart';
import 'package:meals_app/features/home/view_model/cubits/food_cubit.dart';
import 'package:meals_app/features/home/view_model/cubits/food_state.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/generated/l10n.dart';
import 'package:shimmer/shimmer.dart';

class MenuView extends StatefulWidget {
  static const String menuPath = '/menu';

  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final ScrollController _scrollController = ScrollController();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool? _isRestaurantClosed;

  @override
  void initState() {
    super.initState();
    _loadMenuItems();
    _setupScrollListener();
    _initializeUserCubit();
    _checkRestaurantClosed();
  }

  void _initializeUserCubit() {
    if (UserCubit.instance.state.user == null) {
      UserCubit.instance.loadUser();
    }
  }

  void _loadMenuItems() {
    final foodCubit = context.read<FoodCubit>();
    foodCubit.loadMenuItems();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final foodCubit = context.read<FoodCubit>();
        final state = foodCubit.state;

        if (state.menuStatus != FoodStatus.loadingMore && state.hasMoreMenu) {
          foodCubit.loadMoreMenuItems();
        }
      }
    });
  }

  Future<void> _checkRestaurantClosed() async {
    final isClosed = await context.read<UserCubit>().isRestaurantClosed();
    setState(() {
      _isRestaurantClosed = isClosed;
    });
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await _checkRestaurantClosed();
    final foodCubit = context.read<FoodCubit>();
    await foodCubit.loadMenuItems(refresh: true);
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              _buildHeader(context, localization),

              Expanded(
                child: Stack(
                  children: [
                    RefreshIndicator(
                      key: _refreshIndicatorKey,
                      color: ColorsBox.primaryColor,
                      onRefresh: _handleRefresh,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             DeliveryLocation(isClosed: _isRestaurantClosed?? false,),

                            // Menu section title
                            _buildSectionTitle(localization.menu),

                            // Menu items list
                            BlocBuilder<FoodCubit, FoodState>(
                              buildWhen: (previous, current) =>
                                  previous.menuItems != current.menuItems ||
                                  previous.menuStatus != current.menuStatus,
                              builder: (context, state) {
                                if (state.menuStatus == FoodStatus.loading &&
                                    state.menuItems.isEmpty) {
                                  return _buildMenuItemsShimmer();
                                }

                                if (state.menuStatus == FoodStatus.error) {
                                  return Center(
                                    child: CustomErrorWidget(
                                      errorMessage:
                                          localization.errorLoadingMenuItems,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 20.h,
                                      ),
                                    ),
                                  );
                                }

                                if (state.menuItems.isEmpty) {
                                  return SizedBox();
                                }

                                return Column(
                                  children: [
                                    // Menu items list
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      itemCount: state.menuItems.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 12.h),
                                          child: MealCard(
                                            food: state.menuItems[index],
                                          ),
                                        );
                                      },
                                    ),
                                    if (state.menuStatus ==
                                        FoodStatus.loadingMore)
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16.h,
                                        ),
                                        child: _buildMenuItemShimmer(),
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

                    // Cart indicator at the bottom
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

  Widget _buildMenuItemsShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: List.generate(4, (index) => _buildMenuItemShimmer()),
      ),
    );
  }

  Widget _buildMenuItemShimmer() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 100.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              // Image placeholder
              Container(
                width: 100.h,
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    bottomLeft: Radius.circular(16.r),
                  ),
                  color: Colors.white,
                ),
              ),
              // Content placeholder
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150.w,
                        height: 20.h,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 100.w,
                        height: 16.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
          BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              final userName = state.user?.name ?? '';
              final StorageService storageService= StorageService();
              final isAuthenticated = storageService.isAuthenticated();
              return SizedBox(
                width: 220.w,
                child: Text(
                isAuthenticated?  localization.hello(userName): localization.welcomeToMealsApp,
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
}

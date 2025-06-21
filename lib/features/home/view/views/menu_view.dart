import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/main_widgets/custom_error_widget.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/core/services/connectivity_service.dart';
import 'package:meals_app/core/main_widgets/connectivity_dialog.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/cart/view/views/cart_view.dart';
import 'package:meals_app/features/cart/view/widgets/cart_indicator.dart';
import 'package:meals_app/features/home/view/widgets/delivery_location.dart';
import 'package:meals_app/features/home/view/widgets/meal_card.dart';
import 'package:meals_app/features/home/view_model/cubits/food_cubit.dart';
import 'package:meals_app/features/home/view_model/cubits/food_state.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/generated/l10n.dart';
import 'dart:async';
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
  // final Logger _log = Logger('MenuView');
  // bool _isConnected = true;
  // bool _isDialogShowing = false;
  // StreamSubscription<bool>? _connectivitySubscription;
  // final ConnectivityService _connectivityService = ConnectivityService.instance;

  @override
  void initState() {
    super.initState();
    // _initConnectivity();
    _loadMenuItems();
    _setupScrollListener();
    _initializeUserCubit();
  }

  /// Initialize connectivity monitoring
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

  //         // Reload menu items when connection is restored
  //         _loadMenuItems();
  //       } else {
  //         _isDialogShowing = false;
  //       }
  //     },
  //   ).catchError((error) {
  //     _log.severe('Error showing dialog: $error');
  //     _isDialogShowing = false;
  //   });
  // }

  void _initializeUserCubit() {
    // Ensure UserCubit is initialized and loads user data
    if (UserCubit.instance.state.user == null) {
      UserCubit.instance.loadUser();
    }
  }

  void _loadMenuItems() {
    // if (!_isConnected) return;
    final foodCubit = context.read<FoodCubit>();
    foodCubit.loadMenuItems();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Load more menu items when nearing the end
        // if (!_isConnected) return;
        final foodCubit = context.read<FoodCubit>();
        final state = foodCubit.state;

        if (state.menuStatus != FoodStatus.loadingMore && state.hasMoreMenu) {
          foodCubit.loadMoreMenuItems();
        }
      }
    });
  }

  @override
  void dispose() {
    // _connectivitySubscription?.cancel();
    // _connectivitySubscription = null;
    _scrollController.dispose();
    super.dispose();
  }

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
              child: Stack(
                children: [
                  RefreshIndicator(
                    key: _refreshIndicatorKey,
                    color: ColorsBox.primaryColor,
                    onRefresh: () async {
                      // if (!_isConnected) {
                      //   _showConnectivityDialog();
                      //   return;
                      // }
                      final foodCubit = context.read<FoodCubit>();
                      await foodCubit.loadMenuItems(refresh: true);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const DeliveryLocation(),

                          // Menu section title
                          _buildSectionTitle(localization.menu),

                          // Menu items list
                          BlocBuilder<FoodCubit, FoodState>(
                            buildWhen:
                                (previous, current) =>
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

                                  // Loading indicator at the bottom when loading more
                                  if (state.menuStatus ==
                                      FoodStatus.loadingMore)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16.h,
                                      ),
                                      child: _buildMenuItemShimmer(),
                                    ),

                                  // Add some bottom padding to ensure we can scroll
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
        // User greeting with BlocBuilder
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            final userName = state.user?.name ?? '';
            return Text(
              localization.hello(userName),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            );
          },
        ),

        // Icons
        Row(
          children: [
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

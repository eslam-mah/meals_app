import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/core/services/connectivity_service.dart';
import 'package:meals_app/core/main_widgets/connectivity_dialog.dart';
import 'package:meals_app/core/main_widgets/custom_error_widget.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/cart/view/views/cart_view.dart';
import 'package:meals_app/features/cart/view/widgets/cart_indicator.dart';
import 'package:meals_app/features/home/data/models/food_model.dart';
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

class HomeView extends StatefulWidget {
  static const String homePath = '/home';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();
  // final Logger _log = Logger('HomeView');
  bool _isConnected = true;
  // bool _isDialogShowing = false;
  // StreamSubscription<bool>? _connectivitySubscription;
  // final ConnectivityService _connectivityService = ConnectivityService.instance;

  @override
  void initState() {
    super.initState();
    // _initConnectivity();
    _loadInitialData();
    _setupScrollListener();
    _initializeUserCubit();
  }

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

  // void _showConnectivityDialog() {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         snackBarAnimationStyle:  AnimationStyle(curve: ElasticInCurve()),
  //             SnackBar(

  //               content: Text(S.of(context).noInternetConnection),
  //               backgroundColor: Colors.red,
  //             ),
  //           );
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

  //         // Reload data when connection is restored
  //         _loadInitialData();
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

  void _loadInitialData() {
    // if (!_isConnected) return;
    final foodCubit = context.read<FoodCubit>();
    foodCubit.loadInitialData();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Load more recommended items when nearing the end
        // if (!_isConnected) return;
        final foodCubit = context.read<FoodCubit>();
        final state = foodCubit.state;

        if (state.recommendedStatus != FoodStatus.loadingMore &&
            state.hasMoreRecommended) {
          foodCubit.loadMoreRecommendedItems();
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
          children: [
            // User greeting and icons
            _buildHeader(context, localization),

            // Main content with Expanded
            Expanded(
              child: Stack(
                children: [
                  CustomRefreshIndicator(
                    onRefresh: () async {
                      final foodCubit = context.read<FoodCubit>();
                      await Future.wait([
                        foodCubit.loadRecommendedItems(refresh: true),
                        foodCubit.loadOfferItems(refresh: true),
                      ]);
                    },
                    builder: (context, child, controller) {
                      return AnimatedBuilder(
                        animation: controller,
                        builder: (context, _) {
                          return Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              if (controller.isLoading)
                                Positioned(
                                  top: 20.h * controller.value,
                                  child: SizedBox(
                                    height: 30.h,
                                    width: 30.h,
                                    child: CircularProgressIndicator(
                                      value:
                                          controller.isLoading
                                              ? null
                                              : controller.value,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        ColorsBox.primaryColor,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              Transform.translate(
                                offset: Offset(0, 60.h * controller.value),
                                child: child,
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Delivery location
                          const DeliveryLocation(),

                          SizedBox(height: 16.h),

                          // Hot offers section

                          // Hot offers horizontal list
                          BlocBuilder<FoodCubit, FoodState>(
                            buildWhen:
                                (previous, current) =>
                                    previous.offerItems !=
                                        current.offerItems ||
                                    previous.offerStatus !=
                                        current.offerStatus,
                            builder: (context, state) {
                              if (state.offerStatus == FoodStatus.loading) {
                                return _buildOfferItemsShimmer();
                              }
                          
                              if (state.offerStatus == FoodStatus.error) {
                                return CustomErrorWidget(
                                  errorMessage: Intl.getCurrentLocale() == 'ar' 
                                    ? 'خطأ في تحميل العروض'
                                    : 'Error loading offers',
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                );
                              }
                          
                              if (state.offerItems.isEmpty) {
                                return SizedBox.shrink();
                              }
                          
                              return SizedBox(
                                                            height: state.offerItems.isNotEmpty ? 225.h : 0,

                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.only(left: 16.w),
                                  itemCount: state.offerItems.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (state.offerItems.isNotEmpty) ...[
                                          _buildSectionTitle(
                                            localization.offers,
                                          ),
                                                          
                                          SizedBox(height: 12.h),
                                        ],
                                        HotOfferCard(
                                          food: state.offerItems[index],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 30.h),

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
                                return _buildRecommendedItemsShimmer();
                              }

                              if (state.recommendedStatus == FoodStatus.error &&
                                  state.recommendedItems.isEmpty) {
                                return CustomErrorWidget(
                                  errorMessage: Intl.getCurrentLocale() == 'ar' 
                                    ? 'خطأ في تحميل التوصيات'
                                    : 'Error loading recommendations',
                                  padding: EdgeInsets.symmetric(vertical: 40.h),
                                );
                              }

                              if (state.recommendedItems.isEmpty) {
                                return CustomErrorWidget(
                                  errorMessage: Intl.getCurrentLocale() == 'ar'
                                    ? 'لا توجد توصيات متاحة'
                                    : 'No recommendations available',
                                  padding: EdgeInsets.symmetric(vertical: 40.h),
                                  textColor: Colors.grey,
                                  icon: Icons.no_meals_outlined,
                                );
                              }

                              return Column(
                                children: [
                                  // Recommended items list
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
                                        padding: EdgeInsets.only(bottom: 12.h),
                                        child: RecommendedItem(
                                          food: state.recommendedItems[index],
                                        ),
                                      );
                                    },
                                  ),

                                  // Loading indicator at the bottom when loading more
                                  if (state.recommendedStatus ==
                                      FoodStatus.loadingMore)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16.h,
                                      ),
                                      child: _buildRecommendedItemShimmer(),
                                    ),

                                  // Extra space at the bottom for the cart indicator
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

  Widget _buildOfferItemsShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 16.w),
      itemCount: 3, // Show 3 shimmer placeholders
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: EdgeInsets.only(right: 20.w),
            width: 300.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      },
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
            // Card container
            Container(
              margin: EdgeInsets.only(top: 60.h, bottom: 16.h),
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            // Image placeholder
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

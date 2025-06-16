import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/cart/view/views/cart_view.dart';
import 'package:meals_app/features/home/view/widgets/delivery_location.dart';
import 'package:meals_app/features/home/view/widgets/meal_card.dart';
import 'package:meals_app/features/home/view_model/cubits/food_cubit.dart';
import 'package:meals_app/features/home/view_model/cubits/food_state.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/generated/l10n.dart';

class MenuView extends StatefulWidget {
  static const String menuPath = '/menu';

  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final ScrollController _scrollController = ScrollController();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _loadMenuItems();
    _setupScrollListener();
    _initializeUserCubit();
  }

  void _initializeUserCubit() {
    // Ensure UserCubit is initialized and loads user data
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
        // Load more menu items when nearing the end
        final foodCubit = context.read<FoodCubit>();
        final state = foodCubit.state;
        
        if (state.menuStatus != FoodStatus.loadingMore &&
            state.hasMoreMenu) {
          foodCubit.loadMoreMenuItems();
        }
      }
    });
  }

  @override
  void dispose() {
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
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                color: ColorsBox.primaryColor,
                onRefresh: () async {
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
                        buildWhen: (previous, current) => 
                            previous.menuItems != current.menuItems ||
                            previous.menuStatus != current.menuStatus,
                        builder: (context, state) {
                          if (state.menuStatus == FoodStatus.loading &&
                              state.menuItems.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.h),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorsBox.primaryColor,
                                  ),
                                ),
                              ),
                            );
                          }
                          
                          if (state.menuStatus == FoodStatus.error &&
                              state.menuItems.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.h),
                                child: Text(
                                  state.errorMessage ?? 'Error loading menu items',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            );
                          }
                          
                          if (state.menuItems.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.h),
                                child: Text(
                                  'No menu items available',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            );
                          }
                          
                          return Column(
                            children: [
                              // Menu items list
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                              if (state.menuStatus == FoodStatus.loadingMore)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        ColorsBox.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              
                              // Add some bottom padding to ensure we can scroll
                              SizedBox(height: 20.h),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
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
                  if(storageService.isAuthenticated()){
                    GoRouter.of(context).push(CartView.cartPath);
                  }else{
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

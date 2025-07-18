import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/main_widgets/custom_error_widget.dart';
import 'package:meals_app/features/orders_history/view/widgets/order_card.dart';
import 'package:meals_app/features/orders_history/view/widgets/shimmer_order_list.dart';
import 'package:meals_app/features/orders_history/view_model/cubits/order_history_cubit.dart';
import 'package:meals_app/features/orders_history/view_model/cubits/order_history_state.dart';
import 'package:meals_app/generated/l10n.dart';

class OrdersHistoryView extends StatefulWidget {
  static const String ordersHistoryPath = '/orders-history';
  
  const OrdersHistoryView({Key? key}) : super(key: key);

  @override
  State<OrdersHistoryView> createState() => _OrdersHistoryViewState();
}

class _OrdersHistoryViewState extends State<OrdersHistoryView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Load orders when the view is created
    context.read<OrderHistoryCubit>().loadOrders();
    
    // Setup scroll controller for pagination
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    
    // Load more when user scrolls to 80% of the list
    if (currentScroll >= (maxScroll * 0.8)) {
      context.read<OrderHistoryCubit>().loadMoreOrders();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).ordersHistory,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: ColorsBox.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: ColorsBox.primaryColor,
          labelStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 16.sp,
          ),
          tabs: [
            Tab(text: S.of(context).active),
            Tab(text: S.of(context).delivered),
            Tab(text: S.of(context).cancelled),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<OrderHistoryCubit>().refreshOrders(),
        child: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
          builder: (context, state) {
            if (state.status == OrderHistoryStatus.initial || state.status == OrderHistoryStatus.loading) {
              return TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  ShimmerOrderList(),
                  ShimmerOrderList(),
                  ShimmerOrderList(),
                ],
              );
            } else if (state.status == OrderHistoryStatus.error) {
              return CustomErrorWidget(
                errorMessage: state.errorMessage ?? S.of(context).errorLoadingOrders,
              );
            }
            
            return TabBarView(
              controller: _tabController,
              children: [
                // Active orders tab
                _buildOrdersList(
                  context, 
                  state.activeOrders, 
                  state.status == OrderHistoryStatus.loadingMore,
                  state.hasReachedMax,
                ),
                
                // Delivered orders tab
                _buildOrdersList(
                  context, 
                  state.completedOrders, 
                  state.status == OrderHistoryStatus.loadingMore,
                  state.hasReachedMax,
                ),
                
                // Cancelled orders tab
                _buildOrdersList(
                  context, 
                  state.cancelledOrders, 
                  state.status == OrderHistoryStatus.loadingMore,
                  state.hasReachedMax,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildOrdersList(
    BuildContext context, 
    List orders, 
    bool isLoadingMore, 
    bool hasReachedMax,
  ) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 72.sp,
              color: Colors.grey,
            ),
            SizedBox(height: 16.h),
            Text(
              S.of(context).noOrdersFound,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: orders.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at the end while paginating
        if (index >= orders.length) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        return OrderCard(order: orders[index]);
      },
    );
  }
} 
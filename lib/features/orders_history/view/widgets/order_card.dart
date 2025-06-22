import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/utils/media_query_values.dart';
import 'package:meals_app/features/checkout/data/models/order_model.dart';
import 'package:meals_app/features/orders_history/view_model/cubits/order_history_cubit.dart';
import 'package:meals_app/features/orders_history/view_model/cubits/order_history_state.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/generated/l10n.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  
  const OrderCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isActive = order.status == 'pending';
    final bool isDelivered = order.status == 'delivered';
    
    // Format date to be more readable
    final formattedDate = DateFormat.yMMMd().format(order.createdAt);
    final formattedTime = DateFormat.jm().format(order.createdAt);
    
    final isPending = order.status == 'pending';
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header with status indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isActive ? ColorsBox.primaryColor.withOpacity(0.1) : 
                     isDelivered ? Colors.green.withOpacity(0.1) :
                     Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Order ID
                Expanded(
                  child: Text(
                    '${S.of(context).orderID}: #${order.id.substring(0, 8)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                // Order status
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isActive ? ColorsBox.primaryColor : 
                           isDelivered ? Colors.green : 
                           Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    isActive ? S.of(context).pending : 
                    isDelivered ? S.of(context).delivered : 
                    S.of(context).cancelled,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Order details
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and time
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 20.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '$formattedDate - $formattedTime',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                
                // Order type
                Row(
                  children: [
                    Icon(
                      order.orderType == 'delivery' ? Icons.delivery_dining : Icons.store,
                      size: 20.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      order.orderType == 'delivery' ? 
                        S.of(context).delivery : S.of(context).pickup,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                
                // Payment method
                Row(
                  children: [
                    Icon(
                      order.paymentMethod == 'cash' ? Icons.payments : Icons.credit_card,
                      size: 20.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      order.paymentMethod == 'cash' ? 
                        S.of(context).cashPayment : S.of(context).creditCardPayment,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                
                // Total price
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: 20.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '${S.of(context).totalPrice}: ${order.totalPrice.toStringAsFixed(2)} ${S.of(context).currency}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                
                // Location or branch
                if (order.branchName != null || order.addressId != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            order.orderType == 'delivery' ? Icons.location_on : Icons.store,
                            size: 20.sp,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              order.orderType == 'delivery' ?
                                '${S.of(context).deliveryTo}: ${context.read<UserCubit>().state.user?.city ?? "-"}' :
                                '${S.of(context).pickupFrom}: ${order.branchName ?? "-"}',
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.grey[700],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                
                // Cancel button (only for pending orders)
                if (isActive)
                  BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
                    builder: (context, state) {
                      final bool isCanceling = state.status == OrderHistoryStatus.cancelingOrder &&
                                              state.cancelingOrderId == order.id;
                      
                      return Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isCanceling ? 
                              null : 
                              () => context.read<OrderHistoryCubit>().cancelOrder(order.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: isCanceling ?
                              SizedBox(
                                height: 24.h,
                                width: 24.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.w,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ) :
                              Text(
                                S.of(context).cancelOrder,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 
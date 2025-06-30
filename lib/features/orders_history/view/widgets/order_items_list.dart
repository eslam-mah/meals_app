import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/features/checkout/data/models/order_item_model.dart';
import 'package:meals_app/features/orders_history/view_model/cubits/order_history_cubit.dart';
import 'package:meals_app/features/orders_history/view_model/cubits/order_history_state.dart';
import 'package:meals_app/generated/l10n.dart';
import 'package:shimmer/shimmer.dart';

/// Widget for displaying order items list
class OrderItemsList extends StatelessWidget {
  final String orderId;
  final Logger _log = Logger('OrderItemsList');

  OrderItemsList({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load order items when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderHistoryCubit>().loadOrderItems(orderId);
    });

    return BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
      buildWhen:
          (previous, current) =>
              previous.status != current.status ||
              previous.selectedOrderId != current.selectedOrderId ||
              (previous.orderItems[orderId] != current.orderItems[orderId]),
      builder: (context, state) {
        if (state.status == OrderHistoryStatus.loadingOrderItems &&
            state.selectedOrderId == orderId) {
          return _buildLoadingShimmer();
        }

        final items = state.orderItems[orderId] ?? [];
        _log.info('Building order items list for order $orderId: ${items.length} items');

        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Text(
                S.of(context).noItemsFound,
                style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              ),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).orderItems,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              ...items.map((item) => _buildOrderItemCard(item, context)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderItemCard(OrderItemModel item, BuildContext context) {
    // Extract customization data
    final customization = item.customization;
    final sizeData = customization['size'];
    final extras = customization['extras'] as List?;
    final beverages = customization['beverage'] as List?;
    final specialInstructions = customization['specialInstructions'] as String?;
    
    // Extract menu item details
    final menuItemDetails = item.menuItemDetails;
    _log.info('Menu item details for ${item.menuItemId}: $menuItemDetails');
    
    final String itemName = menuItemDetails != null 
        ? menuItemDetails[Intl.getCurrentLocale() == 'ar' ? 'name_ar' : 'name_en'] ?? 'Unknown Item'
        : 'Item #${item.menuItemId}';
    
    _log.info('Item name resolved to: $itemName (current locale: ${Intl.getCurrentLocale()})');
    
    final String? itemDescription = menuItemDetails != null
        ? menuItemDetails[Intl.getCurrentLocale() == 'ar' ? 'description_ar' : 'description_en']
        : null;
    final String? imageUrl = menuItemDetails?['image_url'];

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item image if available
            if (imageUrl != null && imageUrl.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  imageUrl,
                  height: 120.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120.h,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],
            
            // Item name and price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${item.quantity}x $itemName',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorsBox.primaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${S.of(context).price}: ${item.price.toStringAsFixed(2)} ${S.of(context).currency}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            // Item description if available
            if (itemDescription != null && itemDescription.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                itemDescription,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            SizedBox(height: 8.h),

            // Size information
            if (sizeData != null) ...[
              Text(
                '${S.of(context).size}: ${sizeData[Intl.getCurrentLocale() == 'ar' ? 'name_ar' : 'name_en']}',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 4.h),
            ],

            // Extras information
            if (extras != null && extras.isNotEmpty) ...[
              Text(
                '${S.of(context).extras}:',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 4.h),
              ...extras.map(
                (extra) => Padding(
                  padding: EdgeInsets.only(left: 8.w, bottom: 2.h),
                  child: Text(
                    '- ${extra[Intl.getCurrentLocale() == 'ar' ? 'name_ar' : 'name_en']}',
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
            ],

            // Beverages information
            if (beverages != null && beverages.isNotEmpty) ...[
              Text(
                '${S.of(context).beverage}:',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 4.h),
              ...beverages.map(
                (beverage) => Padding(
                  padding: EdgeInsets.only(left: 8.w, bottom: 2.h),
                  child: Text(
                    '- ${beverage[Intl.getCurrentLocale() == 'ar' ? 'name_ar' : 'name_en']}',
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
            ],

            // Special instructions
            if (specialInstructions != null &&
                specialInstructions.isNotEmpty) ...[
              Text(
                '${S.of(context).specialInstructions}:',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 4.h),
              Text(
                specialInstructions,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
            ],

            SizedBox(height: 8.h),

            // Total price for this item
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${S.of(context).total}: ${(item.price * item.quantity).toStringAsFixed(2)} ${S.of(context).currency}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsBox.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(width: 120.w, height: 20.h, color: Colors.white),
          ),
          SizedBox(height: 16.h),
          ...List.generate(3, (index) => _buildItemShimmer()),
        ],
      ),
    );
  }

  Widget _buildItemShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.r),
        height: 120.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

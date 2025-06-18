import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/config/assets_box.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/features/cart/data/models/cart_model.dart';

class CartItemWidget extends StatefulWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  bool _isIncrementEnabled = true;
  bool _isDecrementEnabled = true;

  void _handleIncrement() {
    if (!_isIncrementEnabled) return;
    
    setState(() {
      _isIncrementEnabled = false;
    });
    
    widget.onIncrement();
    
    // Re-enable button after 1.5 seconds
    Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _isIncrementEnabled = true;
        });
      }
    });
  }
  
  void _handleDecrement() {
    if (!_isDecrementEnabled) return;
    
    setState(() {
      _isDecrementEnabled = false;
    });
    
    widget.onDecrement();
    
    // Re-enable button after 1.5 seconds
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isDecrementEnabled = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => widget.onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30.r,
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: widget.item.photoUrl != null && widget.item.photoUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget.item.photoUrl!,
                          width: 80.w,
                          height: 80.h,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                ColorsBox.primaryColor,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            AssetsBox.logo,
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          AssetsBox.logo,
                          width: 80.w,
                          height: 80.h,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(width: 12.w),
                
                // Item details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Item name
                          Expanded(
                            child: Text(
                              widget.item.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          
                          // Remove button
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 20.r,
                              color: Colors.grey,
                            ),
                            onPressed: widget.onRemove,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      
                      // Price
                      Text(
                        'EGP ${widget.item.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      
                      // Show selected options
                      if (widget.item.selectedSize != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          'Size: ${widget.item.selectedSize!.nameEn}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                      
                      if (widget.item.selectedExtras.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          'Extras: ${widget.item.selectedExtras.map((e) => e.nameEn).join(", ")}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      
                      if (widget.item.selectedBeverage != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          'Beverage: ${widget.item.selectedBeverage!.nameEn}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12.h),
            
            // Quantity controls and total price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Quantity controls
                Row(
                  children: [
                    // Decrease button
                    _buildQuantityButton(
                      icon: Icons.remove,
                      onTap: _handleDecrement,
                      isEnabled: _isDecrementEnabled,
                    ),
                    
                    // Quantity
                    Container(
                      width: 40.w,
                      alignment: Alignment.center,
                      child: Text(
                        widget.item.quantity.toString(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    // Increase button
                    _buildQuantityButton(
                      icon: Icons.add,
                      onTap: _handleIncrement,
                      isEnabled: _isIncrementEnabled,
                    ),
                  ],
                ),
                
                // Total price
                Text(
                  'EGP ${widget.item.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.sp,
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

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isEnabled,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: isEnabled ? ColorsBox.primaryColor : Colors.grey,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20.r,
          ),
        ),
      ),
    );
  }
} 
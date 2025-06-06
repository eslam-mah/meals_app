import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/config/colors_box.dart';

class DeliveryTypeSelector extends StatefulWidget {
  const DeliveryTypeSelector({super.key});

  @override
  State<DeliveryTypeSelector> createState() => _DeliveryTypeSelectorState();
}

class _DeliveryTypeSelectorState extends State<DeliveryTypeSelector> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _options = [
    {
      'icon': Icons.delivery_dining,
      'label': 'Delivery',
    },
    {
      'icon': Icons.shopping_bag,
      'label': 'Pick up',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        _options.length,
        (index) => Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: _selectedIndex == index
                    ? Colors.white
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: _selectedIndex == index
                      ? ColorsBox.primaryColor
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _options[index]['icon'],
                    color: _selectedIndex == index
                        ? ColorsBox.primaryColor
                        : Colors.grey,
                    size: 24.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    _options[index]['label'],
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: _selectedIndex == index
                          ? ColorsBox.primaryColor
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 
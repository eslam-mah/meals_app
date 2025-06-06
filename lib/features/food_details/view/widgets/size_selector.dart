import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/generated/l10n.dart';

class SizeSelector extends StatefulWidget {
  const SizeSelector({super.key});

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  int selectedSizeIndex = 0;
  
  final List<Map<String, dynamic>> _sizes = [
    {'name': 'regular', 'price': 90.00},
    {'name': 'medium', 'price': 120.00},
    {'name': 'large', 'price': 150.00},
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    
    return SizedBox(
      height: (_sizes.length * 80).h,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _sizes.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            setState(() {
              selectedSizeIndex = index;
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: selectedSizeIndex == index 
                    ? Colors.orange 
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selectedSizeIndex == index 
                            ? Colors.orange 
                            : Colors.white,
                        border: Border.all(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                      child: selectedSizeIndex == index
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      _sizes[index]['name'] == 'regular' 
                          ? l10n.regular 
                          : _sizes[index]['name'] == 'medium' 
                              ? l10n.medium 
                              : l10n.large,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  '+ EGP ${_sizes[index]['price'].toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
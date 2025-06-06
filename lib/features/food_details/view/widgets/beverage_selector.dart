import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BeverageSelector extends StatefulWidget {
  const BeverageSelector({super.key});

  @override
  State<BeverageSelector> createState() => _BeverageSelectorState();
}

class _BeverageSelectorState extends State<BeverageSelector> {
  int selectedBeverageIndex = -1;
  
  final List<Map<String, dynamic>> _beverages = [
    {'name': 'Coca Cola', 'price': 20.00},
    {'name': 'Sprite', 'price': 20.00},
    {'name': 'Fanta', 'price': 20.00},
    {'name': 'Water', 'price': 10.00},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (_beverages.length * 70).w,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _beverages.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            setState(() {
              selectedBeverageIndex = selectedBeverageIndex == index ? -1 : index;
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: selectedBeverageIndex == index 
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
                        color: selectedBeverageIndex == index 
                            ? Colors.orange 
                            : Colors.white,
                        border: Border.all(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                      child: selectedBeverageIndex == index
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      _beverages[index]['name'],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  '+ EGP ${_beverages[index]['price'].toStringAsFixed(2)}',
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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExtrasSelector extends StatefulWidget {
  const ExtrasSelector({super.key});

  @override
  State<ExtrasSelector> createState() => _ExtrasSelectorState();
}

class _ExtrasSelectorState extends State<ExtrasSelector> {
  final List<Map<String, dynamic>> _extras = [
    {'name': 'Extra Cheese', 'price': 15.00, 'selected': false},
    {'name': 'Extra Sauce', 'price': 10.00, 'selected': false},
    {'name': 'Extra Spicy', 'price': 5.00, 'selected': false},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (_extras.length * 80).h,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _extras.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            setState(() {
              _extras[index]['selected'] = !_extras[index]['selected'];
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: _extras[index]['selected'] 
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
                        color: _extras[index]['selected'] 
                            ? Colors.orange 
                            : Colors.white,
                        border: Border.all(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                      child: _extras[index]['selected']
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      _extras[index]['name'],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  '+ EGP ${_extras[index]['price'].toStringAsFixed(2)}',
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
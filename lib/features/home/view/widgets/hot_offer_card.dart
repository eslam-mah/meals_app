import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/utils/colors_box.dart';

class HotOfferCard extends StatelessWidget {
  
  const HotOfferCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          
          onTap: () {
            // TODO: Add card functionality
          },
          child: Ink(
            width: 300.w,
            decoration: BoxDecoration(
              color:  Colors.white ,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child:Image.asset(
                    'assets/icons/logo.png',
                 
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ),
    );
  }
} 
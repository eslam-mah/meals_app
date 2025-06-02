import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/features/home/main_router.dart';
import 'package:meals_app/generated/l10n.dart';

class MainView extends StatefulWidget {
    static const String mainPath = '/main';

  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    S.of(context);
    
    return Scaffold(
      body: MainRouter.getViewForIndex(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: ColorsBox.primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon:  Icon(Icons.home , size: 26.sp, ),
            label: S.of(context).home,
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.menu , size: 26.sp, ),
            label: S.of(context).menu,
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.person , size: 26.sp, ),
            label: S.of(context).profile,
          ),
        ],
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_cubit.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_state.dart' as app_auth;
import 'package:meals_app/features/home/main_router.dart';
import 'package:meals_app/features/profile/view/views/add_profile_details_screen.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/generated/l10n.dart';

class MainView extends StatefulWidget {
    static const String mainPath = '/main';

  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;
  final StorageService _storageService = StorageService();
  
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    _initializeUserCubit();
  }
  
  void _initializeUserCubit() {
    // Force refresh user data when entering main view
    if (_storageService.isAuthenticated()) {
      context.read<UserCubit>().loadUser();
    }
  }
  
  Future<void> _checkAuthStatus() async {
    // Check if the user is authenticated
    final isAuthenticated = _storageService.isAuthenticated();
    
    if (!isAuthenticated) {
      // If not authenticated, display restricted view with option to login
      _showLoginPrompt();
    } else {
      // If authenticated, check if profile is completed
      final isProfileCompleted = _storageService.hasCompletedProfile();
      
      if (!isProfileCompleted) {
        // Redirect to profile completion screen
        if (mounted) {
          context.read<UserCubit>().loadUser();
          if (!context.read<UserCubit>().isProfileCompleted) {
            GoRouter.of(context).push(AddProfileDetailsScreen.routeName);
          }

        }
      }
    }
  }
  
  void _showLoginPrompt() {
    if (!mounted) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).pleaseSignInToAccessContent),
          action: SnackBarAction(
            label: S.of(context).signIn,
            onPressed: () => GoRouter.of(context).go(LoginScreen.routeName),
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    });
  }
  
  void _navigateToLogin() {
    GoRouter.of(context).go(LoginScreen.routeName);
  }
  
  void _handleNavItemTap(int index) {
    // Check if authentication is required for this index
    if (index == 2 ) 
    //|| (_currentIndex != index && !_storageService.isAuthenticated())
    {
      // Profile view or any action that requires authentication
      if (!_storageService.isAuthenticated()) {
        _navigateToLogin();
        return;
      }
    }
    
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    S.of(context);
    
    return BlocListener<AuthCubit, app_auth.AuthState>(
      listener: (context, state) {
        if (state.status == app_auth.AuthStatus.unauthenticated) {
          _showLoginPrompt();
        }
      },
      child: Scaffold(
        body: MainRouter.getViewForIndex(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _handleNavItemTap,
          selectedItemColor: ColorsBox.primaryColor,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 26.sp),
              label: S.of(context).home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu, size: 26.sp),
              label: S.of(context).menu,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 26.sp),
              label: S.of(context).profile,
            ),
          ],
        ),
      ),
    );
  }
} 

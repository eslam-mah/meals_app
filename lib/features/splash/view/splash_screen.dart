import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/core/config/assets_box.dart';
import 'package:meals_app/core/services/connectivity_service.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/core/widgets/connectivity_dialog.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_cubit.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_state.dart' as app_auth;
import 'package:meals_app/features/home/view/views/main_view.dart';
import 'package:meals_app/features/onboarding/view/views/onboarding_screen.dart';
import 'package:meals_app/features/profile/view/views/add_profile_details_screen.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/generated/l10n.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isConnected = true;
  bool _isLoading = true;
  bool _isNavigating = false; // Flag to prevent multiple navigation attempts
  bool _isDialogShowing = false; // Flag to prevent multiple dialogs
  final StorageService _storageService = StorageService();
  final ConnectivityService _connectivityService = ConnectivityService.instance;
  final Logger _log = Logger('SplashScreen');
  StreamSubscription<bool>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initializeSplash();
  }
  
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    super.dispose();
  }

  Future<void> _initializeSplash() async {
    if (!mounted) return;
    
    _log.info('Initializing splash screen');
    
    // Initialize storage service
    await _storageService.init();
    _log.info('Storage service initialized');
    
    // Start monitoring connectivity 
    _connectivityService.startMonitoring();
    _log.info('Connectivity monitoring started');
    
    // Subscribe to connectivity changes
    _connectivitySubscription = _connectivityService.onConnectivityChanged.listen(_onConnectivityChanged);
    
    // Perform immediate connectivity check
    await _checkConnectivityAndProceed();
  }
  
  Future<void> _checkConnectivityAndProceed() async {
    if (!mounted) return;
    
    _log.info('Checking connectivity status');
    
    // Direct connection check with a small delay to ensure we get accurate status
    await Future.delayed(const Duration(milliseconds: 300));
    _isConnected = await _connectivityService.forceCheck();
    _log.info('Initial connectivity check: ${_isConnected ? "Connected" : "Disconnected"}');
    
    if (!mounted) return;
    
    if (!_isConnected) {
      _log.warning('No internet connection detected, showing dialog');
      setState(() {
        _isLoading = false;
      });
      _showNoConnectionDialog();
      return;
    }

    // If connected, proceed with a short delay to show splash screen
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (!mounted) return;
    
    _navigateToNextScreen();
  }
  
  void _onConnectivityChanged(bool isConnected) {
    if (!mounted) return;
    
    _log.info('Connectivity changed: ${isConnected ? "Connected" : "Disconnected"}');
    
    setState(() {
      _isConnected = isConnected;
    });
    
    if (!isConnected && !_isDialogShowing && !_isNavigating) {
      _log.info('Connection lost, showing dialog');
      setState(() {
        _isLoading = false;
      });
      _showNoConnectionDialog();
    } else if (isConnected && !_isNavigating && _isDialogShowing) {
      _log.info('Connection restored, attempting navigation');
      // Wait a moment to ensure the connection is stable
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && isConnected) {
          _navigateToNextScreen();
        }
      });
    }
  }
  
  void _showNoConnectionDialog() {
    if (!mounted || _isDialogShowing) return;
    
    _log.info('Showing no connection dialog');
    _isDialogShowing = true;
    
    ConnectivityDialog.show(
      context,
      onConnected: () {
        if (mounted && !_isNavigating) {
          _log.info('Connection restored from dialog, proceeding with navigation');
          _isDialogShowing = false;
          
          // Short delay to ensure connection is stable before proceeding
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && !_isNavigating) {
              _navigateToNextScreen();
            }
          });
        }
      },
    ).catchError((error) {
      _log.severe('Error showing dialog: $error');
      _isDialogShowing = false;
    });
  }
  
  Future<void> _navigateToNextScreen() async {
    if (!mounted || _isNavigating || !_isConnected) return;
    
    // Set navigating flag to prevent multiple navigation attempts
    _isNavigating = true;
    
    if (mounted) {
      setState(() {
        _isLoading = true;
        _isDialogShowing = false;
      });
    }

    try {
      _log.info('Determining appropriate navigation route');
      
      // STEP 1: Check if the app is opened for the first time (no onboarding completed)
      final hasCompletedOnboarding = _storageService.hasCompletedOnboarding();
      _log.info('Has completed onboarding: $hasCompletedOnboarding');
      
      if (!mounted) return;
      
      if (!hasCompletedOnboarding) {
        _log.info('First app launch - navigating to onboarding');
        GoRouter.of(context).go(OnboardingScreen.routeName);
        return;
      }
      
      if (!mounted) return;
      
      // STEP 2: Check authentication state directly from Supabase
      final supabaseSession = Supabase.instance.client.auth.currentSession;
      final supabaseUser = Supabase.instance.client.auth.currentUser;
      
      final isDirectlyAuthenticated = 
          supabaseSession != null && 
          !supabaseSession.isExpired && 
          supabaseUser != null;
          
      _log.info('Direct Supabase authentication check: $isDirectlyAuthenticated');
      
      if (!mounted) return;
      
      if (isDirectlyAuthenticated) {
        _log.info('User is authenticated with Supabase: ${supabaseUser!.id}');
        
        if (!mounted) return;
        
        // Update auth state in the AuthCubit if needed
        final authCubit = context.read<AuthCubit>();
        final authState = authCubit.state;
        
        if (authState.status != app_auth.AuthStatus.authenticated) {
          _log.info('AuthCubit state out of sync - resetting state');
          authCubit.resetState();
        }
        
        if (!mounted) return;
        
        // STEP 3: Load user data and check profile completion
        _log.info('Loading user data to check profile completion');
        try {
          await context.read<UserCubit>().loadUser();
          
          if (!mounted) return;
          
          final userState = context.read<UserCubit>().state;
          
          if (userState.user == null) {
            _log.warning('User is authenticated but has no profile data');
            // Try to create user record
            await context.read<UserCubit>().createUserFromAuth();
            
            if (!mounted) return;
            
            // Reload user data
            await context.read<UserCubit>().loadUser();
          }
          
          if (!mounted) return;
          
          // Now check profile completion status
          final user = context.read<UserCubit>().state.user;
          final isProfileCompleted = user?.isProfileCompleted ?? false;
          
          _log.info('User ID: ${user?.id ?? "Unknown"}');
          _log.info('Email: ${user?.email ?? "Unknown"}');
          _log.info('Name: ${user?.name ?? "Not set"}');
          _log.info('Profile completion status: $isProfileCompleted');
          
          // Update storage with authentication and profile status
          await _storageService.setIsAuthenticated(true);
          await _storageService.setHasCompletedProfile(isProfileCompleted);
          
          if (!mounted) return;
          
          if (!isProfileCompleted) {
            _log.info('Profile incomplete - navigating to profile completion screen');
            GoRouter.of(context).go(AddProfileDetailsScreen.routeName);
            return;
          }
          
          if (!mounted) return;
          
          // User is authenticated and profile is completed
          _log.info('User authenticated with completed profile - navigating to main view');
          GoRouter.of(context).go(MainView.mainPath);
        } catch (userError) {
          _log.severe('Error loading user data: $userError');
          
          if (!mounted) return;
          
          // Even if there's an error loading user data, we still know the user is authenticated
          // Navigate to main view
          _log.info('Navigating to main view despite user data error');
          GoRouter.of(context).go(MainView.mainPath);
        }
      } else {
        // User is not authenticated
        _log.info('User is not authenticated - navigating to main view (limited access)');
        await _storageService.setIsAuthenticated(false);
        
        if (!mounted) return;
        
        GoRouter.of(context).go(MainView.mainPath);
      }
    } catch (e) {
      _log.severe('Error in navigation logic: $e');
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isNavigating = false;
        });
      }
      
      // Default fallback is login screen
      if (mounted) {
        _log.info('Navigation error - falling back to login screen');
        GoRouter.of(context).go(LoginScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Image.asset(
              AssetsBox.logo,
              width: 250.w,
              height: 250.h,
              fit: BoxFit.contain,
            ),
            
            SizedBox(height: 50.h),
            
            // Loading indicator
            if (_isLoading)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              ),
          ],
        ),
      ),
    );
  }
} 
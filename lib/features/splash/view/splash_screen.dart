import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/core/config/assets_box.dart';
import 'package:meals_app/core/services/connectivity_service.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/core/main_widgets/connectivity_dialog.dart';
import 'package:meals_app/features/authentication/view/views/login_screen.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_cubit.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_state.dart' as app_auth;
import 'package:meals_app/features/home/view/views/main_view.dart';
import 'package:meals_app/features/onboarding/view/views/onboarding_screen.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Firebase/Notification imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:meals_app/firebase_options.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isConnected = true;
  bool _isLoading = true;
  bool _isNavigating = false;
  bool _isDialogShowing = false;
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

    await _storageService.init();
    _log.info('Storage service initialized');

    _connectivityService.startMonitoring();
    _log.info('Connectivity monitoring started');

    _connectivitySubscription = _connectivityService.onConnectivityChanged
        .listen(_onConnectivityChanged);

    await _checkConnectivityAndProceed();
  }

  Future<void> _checkConnectivityAndProceed() async {
    if (!mounted) return;

    _log.info('Checking connectivity status');
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

  /// --- Notifications & FCM logic ---
  Future<void> _handleNotificationPermissionsAndToken() async {
    final Logger notifLog = Logger('SplashScreen-Notification');
    try {
      // Make sure Firebase is initialized
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Request notification permission
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        final result = await Permission.notification.request();
        if (!result.isGranted) {
          notifLog.warning('Notification permission denied.');
          // Optional: you can show a message or just continue
          return;
        }
        notifLog.info('Notification permission granted after request.');
      } else {
        notifLog.info('Notification permission already granted.');
      }

      // Get FCM token
      final fcmToken = await FirebaseMessaging.instance.getToken();
      notifLog.info('Obtained FCM token: $fcmToken');

      // Upload FCM token to Supabase if not exists
      if (fcmToken != null) {
        final supabase = Supabase.instance.client;
        final userId = supabase.auth.currentUser?.id;

        final existingTokens = await supabase
            .from('notification_tokens')
            .select()
            .eq('token', fcmToken);

        if (existingTokens.isEmpty) {
          await supabase.from('notification_tokens').insert({
            'user_id': userId,
            'token': fcmToken,
            'created_at': DateTime.now().toIso8601String(),
            'platform': Platform.isAndroid ? 'android' : 'ios',
          });
          notifLog.info('New FCM token stored in database');
        } else {
          notifLog.info('FCM token already exists in database, skipping insertion');
        }
      }

      // Listen for token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        final supabase = Supabase.instance.client;
        final userId = supabase.auth.currentUser?.id;
        final existingTokens = await supabase
            .from('notification_tokens')
            .select()
            .eq('token', newToken);

        if (existingTokens.isEmpty) {
          await supabase.from('notification_tokens').insert({
            'user_id': userId,
            'token': newToken,
            'created_at': DateTime.now().toIso8601String(),
            'platform': Platform.isAndroid ? 'android' : 'ios',
          });
          notifLog.info('New refreshed FCM token stored in database');
        } else {
          notifLog.info('Refreshed FCM token already exists in database, skipping insertion');
        }
      });
    } catch (e, stack) {
      notifLog.severe('Notification/FCM setup failed: $e\n$stack');
    }
  }
  /// -------------------------------

  Future<void> _navigateToNextScreen() async {
    if (!mounted || _isNavigating || !_isConnected) return;
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

      // ============= NOTIFICATION/PERMISSION LOGIC HERE =============
      await _handleNotificationPermissionsAndToken();
      // ==============================================================

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

        final authCubit = context.read<AuthCubit>();
        final authState = authCubit.state;

        if (authState.status != app_auth.AuthStatus.authenticated) {
          _log.info('AuthCubit state out of sync - resetting state');
          authCubit.resetState();
        }

        if (!mounted) return;

        _log.info('Loading user data to check profile completion');
        try {
          await context.read<UserCubit>().loadUser();

          if (!mounted) return;
          final userState = context.read<UserCubit>().state;

          if (userState.user == null) {
            _log.warning('User is authenticated but has no profile data');
            await context.read<UserCubit>().createUserFromAuth();

            if (!mounted) return;
            await context.read<UserCubit>().loadUser();
          }

          if (!mounted) return;

          final user = context.read<UserCubit>().state.user;

          _log.info('User ID: ${user?.id ?? "Unknown"}');
          _log.info('Email: ${user?.email ?? "Unknown"}');
          _log.info('Name: ${user?.name ?? "Not set"}');

          await _storageService.setIsAuthenticated(true);

          if (!mounted) return;

          _log.info('User authenticated - navigating to main view');
          GoRouter.of(context).go(MainView.mainPath);
        } catch (userError) {
          _log.severe('Error loading user data: $userError');
          if (!mounted) return;
          _log.info('Navigating to main view despite user data error');
          GoRouter.of(context).go(MainView.mainPath);
        }
      } else {
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
            if (_isLoading)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

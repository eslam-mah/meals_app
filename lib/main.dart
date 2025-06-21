import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:meals_app/core/responsive/responsive_manager.dart';
import 'package:meals_app/core/router/app_router.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/services/connectivity_service.dart';
import 'package:meals_app/core/services/notification_service.dart';
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/core/utils/shared_prefs.dart';
import 'package:meals_app/core/main_widgets/connectivity_dialog.dart';
import 'package:meals_app/features/authentication/data/auth_repository.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_cubit.dart';
import 'package:meals_app/features/language/cubit/language_cubit.dart';
import 'package:meals_app/features/language/cubit/language_state.dart';
import 'package:meals_app/core/config/supabase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'generated/l10n.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/features/profile/data/repositories/user_repository.dart';

/// Application entry point that initializes required services and configurations
/// before launching the app.
/// 
/// This function:
/// 1. Preserves splash screen during initialization
/// 2. Sets up logging
/// 3. Initializes shared preferences and storage
/// 4. Starts connectivity monitoring
/// 5. Initializes Supabase backend connection
/// 6. Initializes user data management
/// 7. Initializes notification service
/// 8. Launches the app UI
void main() async {
  // Keep the splash screen displayed until initialization is complete
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Configure logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      print('Error: ${record.error}');
    }
    if (record.stackTrace != null) {
      print('Stack trace: ${record.stackTrace}');
    }
  });

  final log = Logger('Main');
  log.info('Starting application');

  try {
    // Initialize SharedPreferences
    await SharedPrefs.init();
    log.info('SharedPreferences initialized');

    // Initialize StorageService
    await StorageService().init();
    log.info('StorageService initialized');

    // Start connectivity monitoring
    ConnectivityService.instance.startMonitoring();
    log.info('ConnectivityService started');

    // Test connectivity at startup
    final isConnected = await ConnectivityService.instance.checkConnection();
    log.info('Initial connectivity test: ${isConnected ? "Connected" : "Disconnected"}');

    // Initialize notification service
    await NotificationService().init();
    log.info('Notification service initialized');

    // Initialize Supabase
    await Supabase.initialize(
      url: SupabaseOptions.supabaseUrl,
      anonKey: SupabaseOptions.supabaseKey,
    );
    log.info('Supabase initialized');

    // Initialize UserCubit
    UserCubit.initialize(UserRepository());
    log.info('UserCubit initialized');

    // Keep splash screen a bit longer (optional - for better user experience)
    await Future.delayed(const Duration(milliseconds: 500));
  } catch (e) {
    log.severe('Error during app initialization: $e');
  } finally {
    // Remove the splash screen
    FlutterNativeSplash.remove();
    log.info('Native splash screen removed');
  }

  runApp(const MyApp());
}

/// Root application widget that configures the app's theme, localization,
/// state management providers, and routing.
/// 
/// This class:
/// - Sets up system UI appearance
/// - Configures BLoC providers for state management
/// - Applies theme based on the current language
/// - Sets up localization
/// - Configures routing
class MyApp extends StatelessWidget {
  /// Creates a MyApp widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configure system UI appearance
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(authRepository: AuthRepository()),
        ),
        BlocProvider(create: (context) => LanguageCubit()),
        BlocProvider(
          create:
              (context) =>
                  UserCubit(userRepository: UserRepository())..loadUser(),
        ),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          // Choose font family based on language
          final isArabic = state.locale.languageCode == 'ar';
          final TextTheme textTheme = TextTheme(
            bodyLarge:
                isArabic
                    ? GoogleFonts.cairo(color: Colors.black)
                    : GoogleFonts.poppins(color: Colors.black),
            bodyMedium:
                isArabic
                    ? GoogleFonts.cairo(color: Colors.black)
                    : GoogleFonts.poppins(color: Colors.black),
            bodySmall:
                isArabic
                    ? GoogleFonts.cairo(color: Colors.black)
                    : GoogleFonts.poppins(color: Colors.black),
            titleLarge:
                isArabic
                    ? GoogleFonts.cairo(color: Colors.black)
                    : GoogleFonts.poppins(color: Colors.black),
            titleMedium:
                isArabic
                    ? GoogleFonts.cairo(color: Colors.black)
                    : GoogleFonts.poppins(color: Colors.black),
            titleSmall:
                isArabic
                    ? GoogleFonts.cairo(color: Colors.black)
                    : GoogleFonts.poppins(color: Colors.black),
            labelLarge:
                isArabic
                    ? GoogleFonts.cairo(color: Colors.black)
                    : GoogleFonts.poppins(color: Colors.black),
            labelMedium:
                isArabic
                    ? GoogleFonts.cairo(color: Colors.black)
                    : GoogleFonts.poppins(color: Colors.black),
            labelSmall:
                isArabic
                    ? GoogleFonts.cairo(color: Colors.black)
                    : GoogleFonts.poppins(color: Colors.black),
          );

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Meals App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: ColorsBox.primaryColor,
                primary: ColorsBox.primaryColor,
                onPrimary: Colors.white,
                background: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                scrolledUnderElevation: 0,
                iconTheme: const IconThemeData(color: Colors.black),
                titleTextStyle:
                    isArabic
                        ? GoogleFonts.cairo(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                        : GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: ColorsBox.primaryColor,
                unselectedItemColor: Colors.grey,
              ),
              inputDecorationTheme: InputDecorationTheme(
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),

                hintStyle: TextStyle(color: Colors.grey.shade700),
              ),
              textTheme: textTheme,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsBox.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: ColorsBox.primaryColor,
                ),
              ),
              useMaterial3: true,
            ),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: state.locale,
            routerConfig: AppRouter.router,
            builder: (context, child) {
              return _AppWithResponsive(child: child!);
            },
          );
        },
      ),
    );
  }
}

/// A wrapper widget that provides responsive layout adaptation and
/// connectivity monitoring for the application.
/// 
/// This widget:
/// - Initializes responsive layout management
/// - Monitors network connectivity
/// - Shows connectivity alerts when network is lost
/// - Adapts UI elements to different device sizes
class _AppWithResponsive extends StatefulWidget {
  /// The child widget to display with responsive adaptations.
  final Widget child;

  /// Creates an _AppWithResponsive widget.
  /// 
  /// The [child] parameter is required and represents the main app content.
  const _AppWithResponsive({required this.child});

  @override
  State<_AppWithResponsive> createState() => _AppWithResponsiveState();
}

/// State management for the _AppWithResponsive widget.
class _AppWithResponsiveState extends State<_AppWithResponsive> {
  /// Logger instance for this class.
  final Logger _log = Logger('AppWithResponsive');
  
  /// Subscription to connectivity status updates.
  StreamSubscription<bool>? _connectivitySubscription;
  
  /// Tracks the previous connectivity state to detect changes.
  bool _wasConnected = true;
  
  /// Flag to prevent showing multiple connectivity dialogs.
  bool _isDialogShowing = false;
  
  @override
  void initState() {
    super.initState();
    _log.info('AppWithResponsive initialized');
    
    // Initialize after first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initConnectivity();
    });
  }
  
  /// Initializes connectivity monitoring and sets up the initial connection status.
  /// 
  /// This method:
  /// - Checks the current connection status
  /// - Displays a dialog if initially disconnected
  /// - Sets up a listener for connectivity changes
  Future<void> _initConnectivity() async {
    if (!mounted) return;
    
    _log.info('Initializing connectivity monitoring');
    
    // Force an immediate quick check
    final isConnected = await ConnectivityService.instance.forceCheck();
    _log.info('Initial connectivity status: ${isConnected ? "Connected" : "Disconnected"}');
    _wasConnected = isConnected;
    
    // If initially disconnected, show dialog
    if (!isConnected && mounted && !_isDialogShowing) {
      _log.info('Initially disconnected, showing dialog');
      _showConnectivityDialog();
    }
    
    // Listen for connectivity changes
    _connectivitySubscription = ConnectivityService.instance.onConnectivityChanged.listen(_handleConnectivityChange);
    _log.info('Connectivity listener set up');
  }
  
  /// Handles changes in network connectivity status.
  /// 
  /// Shows a dialog when connectivity is lost (transitioning from connected to disconnected).
  /// 
  /// [isConnected] - The current connection status.
  void _handleConnectivityChange(bool isConnected) {
    _log.info('Connectivity changed: ${isConnected ? "Connected" : "Disconnected"}');
    
    if (!mounted) {
      _log.warning('Widget not mounted during connectivity change');
      return;
    }
    
    // Only show dialog if we transition from connected to disconnected
    if (_wasConnected && !isConnected && !_isDialogShowing) {
      _log.info('Connection lost, showing dialog immediately');
      _showConnectivityDialog();
    }
    
    _wasConnected = isConnected;
  }
  
  /// Displays the connectivity alert dialog when network connection is lost.
  /// 
  /// The dialog remains visible until connectivity is restored or the user
  /// dismisses it. It includes retry functionality to check for connectivity.
  void _showConnectivityDialog() {
    if (!mounted || _isDialogShowing) return;
    
    _log.info('Showing connectivity dialog');
    _isDialogShowing = true;
    
    ConnectivityDialog.show(
      context,
      onConnected: () {
        _log.info('Connection restored callback from dialog');
        if (mounted) {
          setState(() {
            _isDialogShowing = false;
            _wasConnected = true;
          });
        } else {
          _isDialogShowing = false;
          _wasConnected = true;
        }
      },
    ).catchError((error) {
      _log.severe('Error showing dialog: $error');
      _isDialogShowing = false;
    });
  }
  
  @override
  void dispose() {
    _log.info('AppWithResponsive disposing');
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize responsive manager with current context
    RM.data.init(context);

    return ScreenUtilInit(
      // Set design size based on device type
      designSize:
          RM.data.deviceType == DeviceTypeView.tablet
              ? const Size(992, 1450)
              : const Size(430, 932),
      minTextAdapt: true,
      builder: (context, _) {
        return widget.child;
      },
    );
  }
}

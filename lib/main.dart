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
import 'package:meals_app/core/services/storage_service.dart';
import 'package:meals_app/core/utils/shared_prefs.dart';
import 'package:meals_app/core/widgets/connectivity_dialog.dart';
import 'package:meals_app/features/authentication/data/auth_repository.dart';
import 'package:meals_app/features/authentication/view_model/cubits/auth_cubit.dart';
import 'package:meals_app/features/language/cubit/language_cubit.dart';
import 'package:meals_app/features/language/cubit/language_state.dart';
import 'package:meals_app/core/config/supabase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'generated/l10n.dart';
import 'package:meals_app/features/profile/view_model/user_cubit.dart';
import 'package:meals_app/features/profile/data/repositories/user_repository.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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

class _AppWithResponsive extends StatefulWidget {
  final Widget child;

  const _AppWithResponsive({required this.child});

  @override
  State<_AppWithResponsive> createState() => _AppWithResponsiveState();
}

class _AppWithResponsiveState extends State<_AppWithResponsive> {
  final Logger _log = Logger('AppWithResponsive');
  StreamSubscription<bool>? _connectivitySubscription;
  bool _wasConnected = true;
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
    RM.data.init(context);

    return ScreenUtilInit(
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

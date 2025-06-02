import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meals_app/core/responsive/responsive_manager.dart';
import 'package:meals_app/core/router/app_router.dart';
import 'package:meals_app/core/config/colors_box.dart';
import 'package:meals_app/core/utils/shared_prefs.dart';
import 'package:meals_app/features/language/cubit/language_cubit.dart';
import 'package:meals_app/features/language/cubit/language_state.dart';
import 'package:meals_app/firebase_options.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  await SharedPrefs.init();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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

    return BlocProvider(
      create: (context) => LanguageCubit(),
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          // Choose font family based on language
          final isArabic = state.locale.languageCode == 'ar';
          final TextTheme textTheme = TextTheme(
            bodyLarge: isArabic 
                ? GoogleFonts.cairo(color: Colors.black)
                : GoogleFonts.poppins(color: Colors.black),
            bodyMedium: isArabic 
                ? GoogleFonts.cairo(color: Colors.black)
                : GoogleFonts.poppins(color: Colors.black),
            bodySmall: isArabic 
                ? GoogleFonts.cairo(color: Colors.black)
                : GoogleFonts.poppins(color: Colors.black),
            titleLarge: isArabic 
                ? GoogleFonts.cairo(color: Colors.black)
                : GoogleFonts.poppins(color: Colors.black),
            titleMedium: isArabic 
                ? GoogleFonts.cairo(color: Colors.black)
                : GoogleFonts.poppins(color: Colors.black),
            titleSmall: isArabic 
                ? GoogleFonts.cairo(color: Colors.black)
                : GoogleFonts.poppins(color: Colors.black),
            labelLarge: isArabic 
                ? GoogleFonts.cairo(color: Colors.black)
                : GoogleFonts.poppins(color: Colors.black),
            labelMedium: isArabic 
                ? GoogleFonts.cairo(color: Colors.black)
                : GoogleFonts.poppins(color: Colors.black),
            labelSmall: isArabic 
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
                titleTextStyle: isArabic
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

class _AppWithResponsive extends StatelessWidget {
  final Widget child;

  const _AppWithResponsive({required this.child});

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
        return child;
      },
    );
  }
}

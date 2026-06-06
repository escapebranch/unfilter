import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'pro_transitions.dart';

class AppTheme {
  AppTheme._();

  static ThemeData getTheme({required bool isDark, Locale? locale}) {
    final baseTheme = isDark ? _baseDarkTheme : _baseLightTheme;
    final isTamil = locale?.languageCode == 'ta';
    
    // Pro-level typography scaling factor for Tamil
    // Tamil glyphs are taller and wider; we shrink variedly based on context
    final double displayFactor = isTamil ? 0.60 : 1.0;  // 40% shrink for big headers
    final double headlineFactor = isTamil ? 0.70 : 1.0; // 30% shrink for sub-headers
    final double bodyFactor = isTamil ? 0.80 : 1.0;     // 20% shrink for readability
    final double labelFactor = isTamil ? 0.75 : 1.0;    // 25% shrink for buttons/tags

    final textTheme = (isDark ? _darkTextTheme : _lightTextTheme).copyWith(
      displayLarge: (isDark ? _darkTextTheme : _lightTextTheme).displayLarge?.copyWith(
        fontSize: ((isDark ? _darkTextTheme : _lightTextTheme).displayLarge?.fontSize ?? 57) * displayFactor,
        letterSpacing: isTamil ? -0.2 : -1.5,
      ),
      displayMedium: (isDark ? _darkTextTheme : _lightTextTheme).displayMedium?.copyWith(
        fontSize: ((isDark ? _darkTextTheme : _lightTextTheme).displayMedium?.fontSize ?? 45) * displayFactor,
        letterSpacing: isTamil ? -0.1 : -0.5,
      ),
      displaySmall: (isDark ? _darkTextTheme : _lightTextTheme).displaySmall?.copyWith(
        fontSize: ((isDark ? _darkTextTheme : _lightTextTheme).displaySmall?.fontSize ?? 36) * displayFactor,
      ),
      headlineLarge: (isDark ? _darkTextTheme : _lightTextTheme).headlineLarge?.copyWith(
        fontSize: ((isDark ? _darkTextTheme : _lightTextTheme).headlineLarge?.fontSize ?? 32) * headlineFactor,
      ),
      headlineMedium: (isDark ? _darkTextTheme : _lightTextTheme).headlineMedium?.copyWith(
        fontSize: ((isDark ? _darkTextTheme : _lightTextTheme).headlineMedium?.fontSize ?? 28) * headlineFactor,
      ),
      headlineSmall: (isDark ? _darkTextTheme : _lightTextTheme).headlineSmall?.copyWith(
        fontSize: ((isDark ? _darkTextTheme : _lightTextTheme).headlineSmall?.fontSize ?? 24) * headlineFactor,
      ),
      bodyLarge: (isDark ? _darkTextTheme : _lightTextTheme).bodyLarge?.copyWith(
        fontSize: 16 * bodyFactor,
      ),
      bodyMedium: (isDark ? _darkTextTheme : _lightTextTheme).bodyMedium?.copyWith(
        fontSize: 14 * bodyFactor,
      ),
      bodySmall: (isDark ? _darkTextTheme : _lightTextTheme).bodySmall?.copyWith(
        fontSize: 12 * bodyFactor,
      ),
      labelLarge: (isDark ? _darkTextTheme : _lightTextTheme).labelLarge?.copyWith(
        fontSize: 14 * labelFactor,
      ),
      labelMedium: (isDark ? _darkTextTheme : _lightTextTheme).labelMedium?.copyWith(
        fontSize: 12 * labelFactor,
      ),
      labelSmall: (isDark ? _darkTextTheme : _lightTextTheme).labelSmall?.copyWith(
        fontSize: 11 * labelFactor,
      ),
    );

    return baseTheme.copyWith(
      textTheme: textTheme.apply(
        fontFamily: 'UncutSans',
        bodyColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        displayColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
      appBarTheme: baseTheme.appBarTheme.copyWith(
        titleTextStyle: baseTheme.appBarTheme.titleTextStyle?.copyWith(
          fontSize: (baseTheme.appBarTheme.titleTextStyle?.fontSize ?? 20) * (isTamil ? 0.85 : 1.0),
        ),
      ),
    );
  }

  static final ThemeData _baseLightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'UncutSans',
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.lightPrimary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      secondary: AppColors.lightPrimary,
      onSecondary: AppColors.lightOnPrimary,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      error: AppColors.black,
      onError: AppColors.white,
      outline: AppColors.lightBorder,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.lightTextPrimary,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.lightBackground,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
        color: AppColors.lightTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.lightSurface,
      modalBackgroundColor: AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightOnPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.lightTextPrimary,
        side: const BorderSide(color: AppColors.black, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.lightTextPrimary,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.ultraLightGrey,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.black, width: 1.5),
      ),
      labelStyle: const TextStyle(color: AppColors.mediumGrey),
      hintStyle: const TextStyle(color: AppColors.mediumGrey),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightGrey,
      thickness: 1,
    ),
    iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ProPageTransitionsBuilder(),
        TargetPlatform.iOS: ProPageTransitionsBuilder(),
        TargetPlatform.linux: ProPageTransitionsBuilder(),
        TargetPlatform.macOS: ProPageTransitionsBuilder(),
        TargetPlatform.windows: ProPageTransitionsBuilder(),
      },
    ),
  );

  static final ThemeData _baseDarkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'UncutSans',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.darkPrimary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      secondary: AppColors.darkPrimary,
      onSecondary: AppColors.darkOnPrimary,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      error: AppColors.white,
      onError: AppColors.black,
      outline: AppColors.darkBorder,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.darkBackground,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      titleTextStyle: TextStyle(
        color: AppColors.darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.darkSurface,
      modalBackgroundColor: AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkOnPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkTextPrimary,
        side: const BorderSide(color: AppColors.white, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.darkTextPrimary,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkGrey,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.white, width: 1.5),
      ),
      labelStyle: const TextStyle(color: AppColors.mediumGrey),
      hintStyle: const TextStyle(color: AppColors.mediumGrey),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkBorder,
      thickness: 1,
    ),
    iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ProPageTransitionsBuilder(),
        TargetPlatform.iOS: ProPageTransitionsBuilder(),
        TargetPlatform.linux: ProPageTransitionsBuilder(),
        TargetPlatform.macOS: ProPageTransitionsBuilder(),
        TargetPlatform.windows: ProPageTransitionsBuilder(),
      },
    ),
  );

  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontWeight: FontWeight.bold,
      letterSpacing: -1.5,
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    displaySmall: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(
      fontSize: 14,
    ),
    labelLarge: TextStyle(
      fontWeight: FontWeight.w600,
    ),
  );

  static const TextTheme _darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontWeight: FontWeight.bold,
      letterSpacing: -1.5,
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    displaySmall: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14),
    labelLarge: TextStyle(
      fontWeight: FontWeight.w600,
    ),
  );

  // Keep these for backward compatibility or simple cases, but prefer getTheme()
  static final ThemeData lightTheme = getTheme(isDark: false);
  static final ThemeData darkTheme = getTheme(isDark: true);
}

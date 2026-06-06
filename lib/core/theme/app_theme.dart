import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'pro_transitions.dart';

class AppTheme {
  AppTheme._();

  static const String _fontFamily = 'UncutSans';

  static ThemeData getTheme({required bool isDark, Locale? locale}) {
    final isTamil = locale?.languageCode == 'ta';
    
    // Pro-level typography scaling factor for Tamil
    final double displayFactor = isTamil ? 0.60 : 1.0;
    final double headlineFactor = isTamil ? 0.70 : 1.0;
    final double bodyFactor = isTamil ? 0.80 : 1.0;
    final double labelFactor = isTamil ? 0.75 : 1.0;

    final colorScheme = isDark ? _darkColorScheme : _lightColorScheme;
    final baseTextTheme = isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;

    final textTheme = baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontSize: 57 * displayFactor,
        fontWeight: FontWeight.bold,
        letterSpacing: isTamil ? -0.2 : -1.5,
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontSize: 45 * displayFactor,
        fontWeight: FontWeight.bold,
        letterSpacing: isTamil ? -0.1 : -0.5,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontSize: 36 * displayFactor,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        fontSize: 32 * headlineFactor,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontSize: 28 * headlineFactor,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontSize: 24 * headlineFactor,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize: 22 * bodyFactor,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: 16 * bodyFactor,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontSize: 14 * bodyFactor,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: 16 * bodyFactor,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: 14 * bodyFactor,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontSize: 12 * bodyFactor,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: 14 * labelFactor,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontSize: 12 * labelFactor,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontSize: 11 * labelFactor,
        fontWeight: FontWeight.w600,
      ),
    ).apply(
      fontFamily: _fontFamily,
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      primaryColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20 * (isTamil ? 0.85 : 1.0),
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          fontFamily: _fontFamily,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        modalBackgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: colorScheme.onSurface, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkGrey : AppColors.ultraLightGrey,
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
          borderSide: BorderSide(color: isDark ? AppColors.white : AppColors.black, width: 1.5),
        ),
        labelStyle: const TextStyle(fontFamily: _fontFamily, color: AppColors.mediumGrey),
        hintStyle: const TextStyle(fontFamily: _fontFamily, color: AppColors.mediumGrey),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.darkBorder : AppColors.lightGrey,
        thickness: 1,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
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
  }

  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: AppColors.lightPrimary,
    onPrimary: AppColors.lightOnPrimary,
    secondary: AppColors.lightPrimary,
    onSecondary: AppColors.lightOnPrimary,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightTextPrimary,
    error: AppColors.black,
    onError: AppColors.white,
    outline: AppColors.lightBorder,
  );

  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: AppColors.darkPrimary,
    onPrimary: AppColors.darkOnPrimary,
    secondary: AppColors.darkPrimary,
    onSecondary: AppColors.darkOnPrimary,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkTextPrimary,
    error: AppColors.white,
    onError: AppColors.black,
    outline: AppColors.darkBorder,
  );

  // Keep these for backward compatibility or simple cases, but prefer getTheme()
  static final ThemeData lightTheme = getTheme(isDark: false);
  static final ThemeData darkTheme = getTheme(isDark: true);
}

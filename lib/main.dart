import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:unfilter/core/providers/locale_provider.dart';
import 'package:unfilter/l10n/generated/app_localizations.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/theme_transition_wrapper.dart';
import 'core/widgets/app_entry.dart';
import 'core/navigation/navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/shared_preferences_provider.dart';
import 'core/services/logging_service.dart';
import 'core/widgets/crash_recovery_screen.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    LoggingService().init();

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      debugPrint('[GlobalError] Framework error: ${details.exception}\n${details.stack}');
    };

    final prefs = await SharedPreferences.getInstance();

    runApp(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const UnfilterApp(),
      ),
    );
  }, (error, stack) {
    debugPrint('[GlobalError] Critical async error: $error\n$stack');
    _showCrashScreen(error, stack);
  });
}

void _showCrashScreen(Object error, StackTrace stack) {
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale("en"), Locale("ta")],
        home: CrashRecoveryScreen(error: error, stackTrace: stack),
      ),
    ),
  );
}

class UnfilterApp extends ConsumerWidget {
  const UnfilterApp({super.key});

  static final GlobalKey appKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final selectedLocale = ref.watch(localeProvider);

    return MaterialApp(
      key: appKey,
      localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en"),
        Locale("ta")
      ],
      locale: selectedLocale,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(isDark: false, locale: selectedLocale),
      darkTheme: AppTheme.getTheme(isDark: true, locale: selectedLocale),
      themeMode: themeMode,
      themeAnimationDuration: Duration.zero,
      builder: (context, child) {
        ErrorWidget.builder = (details) => CrashRecoveryScreen(
              error: details.exception,
              stackTrace: details.stack,
            );
        return RepaintBoundary(
          key: PremiumNavigation.rootBoundaryKey,
          child: TapPositionProvider(
            child: ThemeTransitionWrapper(child: child!),
          ),
        );
      },
      home: const AppEntry(),
      onGenerateRoute: AppRouteFactory.onGenerateRoute,
      navigatorObservers: [AppNavigatorObserver(ref: ref)],
    );
  }
}

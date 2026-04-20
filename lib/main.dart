import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:unfilter/core/providers/locale_provider.dart';
import 'package:unfilter/l10n/app_localizations.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/theme_transition_wrapper.dart';
import 'core/widgets/app_entry.dart';
import 'core/navigation/navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/shared_preferences_provider.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const UnfilterApp(),
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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      themeAnimationDuration: Duration.zero,
      builder: (context, child) => RepaintBoundary(
        key: PremiumNavigation.rootBoundaryKey,
        child: TapPositionProvider(
          child: ThemeTransitionWrapper(child: child!),
        ),
      ),
      home: const AppEntry(),
      onGenerateRoute: AppRouteFactory.onGenerateRoute,
      navigatorObservers: [AppNavigatorObserver(ref: ref)],
    );
  }
}

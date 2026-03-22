import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../../features/onboarding/presentation/providers/onboarding_provider.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/analytics/presentation/providers/usage_stats_providers.dart';

class AppEntry extends ConsumerWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasCompletedOnboarding = ref.watch(onboardingStateProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();

      _initializeUsageTracking(ref);
    });

    if (hasCompletedOnboarding) {
      return const HomePage();
    } else {
      return const OnboardingPage();
    }
  }

  void _initializeUsageTracking(WidgetRef ref) async {
    try {
      final syncService = ref.read(usageStatsSyncServiceProvider);
      await syncService.initializeTracking();
      await syncService.syncUsageStats();
    } catch (e) {
      debugPrint('[AppEntry] Error initializing usage tracking: $e');
    }
  }
}

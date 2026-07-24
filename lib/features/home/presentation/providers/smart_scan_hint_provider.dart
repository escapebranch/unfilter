import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/shared_preferences_provider.dart';
import '../../../../core/services/logging_service.dart';
import '../../../apps/presentation/providers/apps_provider.dart';

class SmartScanHintNotifier extends Notifier<bool> {
  static const String _keyOpenCount = 'app_open_count';
  static const String _keyDismissedSession = 'smart_scan_hint_dismissed_session';
  static const Set<int> _targetSessions = {2, 4, 8};

  static bool _sessionIncrementedThisProcess = false;

  @visibleForTesting
  static void resetSessionFlag() {
    _sessionIncrementedThisProcess = false;
  }

  @override
  bool build() {
    try {
      final prefs = ref.watch(sharedPreferencesProvider);

      _incrementSessionOnce(prefs);

      final currentOpenCount = prefs.getInt(_keyOpenCount) ?? 1;

      // Show strictly on the 2nd, 4th, and 8th app opens
      if (!_targetSessions.contains(currentOpenCount)) {
        return false;
      }

      // Check if user already dismissed for this or a later session
      final dismissedSession = prefs.getInt(_keyDismissedSession) ?? 0;
      if (dismissedSession >= currentOpenCount) {
        return false;
      }

      final appsAsync = ref.watch(installedAppsProvider);
      return appsAsync.when(
        data: (apps) => apps.isNotEmpty,
        loading: () => false,
        error: (err, stack) => false,
      );
    } catch (e, stack) {
      LoggingService().error(
        'Error evaluating smart scan hint state',
        tag: 'SmartScanHint',
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  void _incrementSessionOnce(dynamic prefs) {
    if (_sessionIncrementedThisProcess) return;
    _sessionIncrementedThisProcess = true;

    try {
      final oldCount = prefs.getInt(_keyOpenCount) ?? 0;
      final newCount = oldCount + 1;
      prefs.setInt(_keyOpenCount, newCount);
      LoggingService().info(
        'App open count incremented to #$newCount',
        tag: 'SmartScanHint',
      );
    } catch (e, stack) {
      LoggingService().error(
        'Failed to update app open count',
        tag: 'SmartScanHint',
        error: e,
        stackTrace: stack,
      );
    }
  }

  Future<void> dismiss() async {
    state = false;
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      final currentOpenCount = prefs.getInt(_keyOpenCount) ?? 1;
      await prefs.setInt(_keyDismissedSession, currentOpenCount);
      LoggingService().info(
        'Smart scan hint dismissed for session #$currentOpenCount',
        tag: 'SmartScanHint',
      );
    } catch (e, stack) {
      LoggingService().error(
        'Failed to save smart scan hint dismissal',
        tag: 'SmartScanHint',
        error: e,
        stackTrace: stack,
      );
    }
  }
}

final smartScanHintProvider = NotifierProvider<SmartScanHintNotifier, bool>(
  SmartScanHintNotifier.new,
);

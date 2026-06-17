import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Scenarios that can trigger an automated in-app review prompt.
enum ReviewTriggerScenario {
  appEntry,
  shareUsageStatistics,
  shareAppDetails,
  smartRevalidate,
}

class ReviewService {
  final SharedPreferences _prefs;
  bool _hasCheckedEntryThisSession = false;

  static const MethodChannel _channel = MethodChannel(
    'com.escapebranch.unfilter/review',
  );

  // Persistence keys
  static const String _keyAutomatedPromptCount =
      'automated_review_prompt_count';
  static const String _keyAppEntryCount = 'app_entry_count';
  static const String _keyReviewTriggerDisabled = 'review_trigger_disabled';

  ReviewService(this._prefs);

  /// Checks if an automated review prompt should be triggered based on the scenario.
  ///
  /// Following the "3-strikes" rule: if the automated prompt has been shown 3 times,
  /// it will never be shown automatically again.
  Future<void> requestReviewTrigger(ReviewTriggerScenario scenario) async {
    if (_prefs.getBool(_keyReviewTriggerDisabled) ?? false) {
      return;
    }

    final promptCount = _prefs.getInt(_keyAutomatedPromptCount) ?? 0;
    if (promptCount >= 3) {
      // User has been "disturbed" 3 times already. Silence forever.
      await _prefs.setBool(_keyReviewTriggerDisabled, true);
      return;
    }

    bool shouldTrigger = false;

    switch (scenario) {
      case ReviewTriggerScenario.appEntry:
        if (_hasCheckedEntryThisSession) return;
        _hasCheckedEntryThisSession = true;

        final entryCount = _prefs.getInt(_keyAppEntryCount) ?? 0;
        final newEntryCount = entryCount + 1;
        await _prefs.setInt(_keyAppEntryCount, newEntryCount);

        // Trigger exactly on 2nd and 10th entry
        if (newEntryCount == 2 || newEntryCount == 10) {
          shouldTrigger = true;
        }
        break;

      case ReviewTriggerScenario.shareUsageStatistics:
      case ReviewTriggerScenario.shareAppDetails:
      case ReviewTriggerScenario.smartRevalidate:
        // Trigger immediately for these high-engagement actions
        shouldTrigger = true;
        break;
    }

    if (shouldTrigger) {
      debugPrint(
        '[ReviewService] Triggering automated review for: ${scenario.name}',
      );
      await _prefs.setInt(_keyAutomatedPromptCount, promptCount + 1);
      await _invokeNativeReview();
    }
  }

  Future<void> _invokeNativeReview() async {
    try {
      await _channel.invokeMethod('launchReview');
      // Note: The native review API does not provide feedback on whether
      // the user actually submitted a review or dismissed the dialog.
      // We do NOT set hasCompletedReview here because we cannot determine
      // if the review was actually completed. The 3-strikes rule handles
      // disabling automated prompts via review_trigger_disabled.
    } on PlatformException catch (e) {
      debugPrint('[ReviewService] Error launching review flow: ${e.message}');
    } catch (e) {
      debugPrint('[ReviewService] Unexpected error: $e');
    }
  }
}

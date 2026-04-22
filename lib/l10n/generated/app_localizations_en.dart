// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get apps => 'Apps';

  @override
  String get appTitle => 'UnFilter';

  @override
  String get homeTitle => 'Home';

  @override
  String get chooseLanguageDialogTitle => 'Choose Language';

  @override
  String get chooseLanguageDialogSubtitle =>
      'Choose how you want to navigate through application';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTamil => 'Tamil';

  @override
  String get confirmButtonLabel => 'Confirm';

  @override
  String get premiumAppBarResyncApp => 'Resync App';

  @override
  String get premiumAppBarShare => 'Share';

  @override
  String get premiumAppBarMenuTooltip => 'Menu';

  @override
  String get commonOpenLabel => 'Open';

  @override
  String get commonViewLabel => 'View';

  @override
  String get commonClearLabel => 'Clear';

  @override
  String get commonPreviewLabel => 'Preview';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyTermsAndConditionsTitle => 'Terms & Conditions';

  @override
  String get privacyHeader => 'Your Data,\nYour Device';

  @override
  String get privacyIntro =>
      'Privacy is part of the product, not an afterthought. UnFilter runs offline so it can stay useful without ever becoming nosy about you.';

  @override
  String get privacySectionLocalProcessingTitle => 'Local Processing';

  @override
  String get privacySectionLocalProcessingContent =>
      'Every scan, every match, every bit of analysis runs right on your phone. We couldn\'t peek at your apps even if we wanted to - we built it that way.';

  @override
  String get privacySectionMinimalPermissionsTitle => 'Minimal Permissions';

  @override
  String get privacySectionMinimalPermissionsContent =>
      'We ask for exactly two things: permission to see what apps you have installed, and storage access for looking through native libraries. That\'s it.';

  @override
  String get privacySectionNoTrackingTitle => 'No Tracking';

  @override
  String get privacySectionNoTrackingContent =>
      'No analytics. No ad SDKs. No crash reporters phoning home. What you do inside the app stays between you and your phone.';

  @override
  String get privacySectionLimitedNetworkingTitle => 'Limited Networking';

  @override
  String get privacySectionLimitedNetworkingContent =>
      'The only time we hit the internet is to check for updates and grab the GitHub star count. That\'s it - nothing about you leaves this app.';

  @override
  String get howItWorksTitle => 'How it works';

  @override
  String get howItWorksHeader => 'App\nClues';

  @override
  String get howItWorksIntro =>
      'No decompiling. No uploads. Just smart local analysis that reads what\'s already there and tells you what an app is made of.';

  @override
  String get howItWorksOpenSourceLabel => 'Open Source';

  @override
  String get howItWorksStep1Title => 'Collect Clues';

  @override
  String get howItWorksStep1Description =>
      'We look at each app\'s package info and native libraries already sitting on your phone. No uploads, no account, no drama.';

  @override
  String get howItWorksStep2Title => 'Match Signals';

  @override
  String get howItWorksStep2Description =>
      'We compare those clues against local framework fingerprints to spot Flutter, React Native, Unity, and the rest of the usual suspects.';

  @override
  String get howItWorksStep3Title => 'Stay Local';

  @override
  String get howItWorksStep3Description =>
      'Every scan happens on-device. The fun stays private and your app data never leaves your phone.';

  @override
  String get deeplinkTesterTitle => 'Deep Link Tester';

  @override
  String get deeplinkInitialStatus => 'Enter a deeplink to test it.';

  @override
  String get deeplinkEnterSchemeError => 'Please enter at least a scheme.';

  @override
  String get deeplinkInvalidError =>
      'Invalid deeplink. Include a valid URI scheme.';

  @override
  String get deeplinkCanHandle => 'Deep link can be handled on this device.';

  @override
  String get deeplinkNoHandler => 'No app can handle this deep link right now.';

  @override
  String get deeplinkLaunchedSuccess => 'Deep link launched successfully.';

  @override
  String get deeplinkLaunchFailedRecognized =>
      'Deep link was recognized but failed to launch.';

  @override
  String get deeplinkLaunchFailed => 'Failed to launch deep link.';

  @override
  String get deeplinkComponentsTitle => 'Deep Link Components';

  @override
  String get deeplinkPasteFullUrlHint =>
      'Paste full URL here (e.g., myapp://host/path)';

  @override
  String get deeplinkAutofillHint => 'Paste full URL above to auto-fill fields';

  @override
  String get deeplinkLabelScheme => 'Scheme';

  @override
  String get deeplinkLabelHost => 'Host';

  @override
  String get deeplinkLabelPath => 'Path';

  @override
  String get deeplinkLabelQuery => 'Query';

  @override
  String get deeplinkLabelFragment => 'Fragment';

  @override
  String get deeplinkHintScheme => 'e.g. mailto, https';

  @override
  String get deeplinkHintHost => 'e.g. example.com';

  @override
  String get deeplinkHintPath => 'e.g. /profile';

  @override
  String get deeplinkHintQuery => 'e.g. id=123';

  @override
  String get deeplinkHintFragment => 'e.g. section1';

  @override
  String get deeplinkTestButton => 'Test Deeplink';

  @override
  String get deeplinkTryExamplesButton => 'Try Examples';

  @override
  String get deeplinkExamplesTitle => 'Deep Link Examples';

  @override
  String get deeplinkExampleComposeEmail => 'Compose Email';

  @override
  String get deeplinkExamplePhoneCall => 'Phone Call';

  @override
  String get deeplinkExampleSendSms => 'Send SMS';

  @override
  String get deeplinkMoreConfigsSoon => 'More configurations coming soon!';

  @override
  String get deeplinkParsedEmpty =>
      'URI breakdown will appear here after testing.';

  @override
  String get deeplinkParsedDetailsTitle => 'Parsed URI Details';

  @override
  String get homeStatsTitle => 'Your Device has';

  @override
  String homeStatsCountText(String count) {
    return '$count Installed Apps';
  }

  @override
  String get permission => 'Permission';

  @override
  String get permissionDescription1 =>
      'UnFilter needs secure access to your usage stats so it can help you ';

  @override
  String get permissionDescription2 =>
      'spot what apps are made of and power the analytics view.\n\n';

  @override
  String get permissionDescription3 => 'Your data never leaves your device.';

  @override
  String get grantAccess => 'Grant Access';

  @override
  String get maybeLater => 'Maybe Later';

  @override
  String get noAppsFound => 'No apps found matching criteria';

  @override
  String get somethingWentWrongScanning =>
      'Something went wrong while scanning.\n';

  @override
  String get taskManagerTitle => 'Task Manager';

  @override
  String get failedToLoadProcesses => 'Failed to load processes';

  @override
  String get retryLabel => 'Retry';

  @override
  String get kernelSystemSection => 'KERNEL / SYSTEM';

  @override
  String get noProcessesMatchSearch => 'No processes match your search';

  @override
  String get noProcessDataAvailable => 'No process data available';

  @override
  String processDataIncompleteError(String error) {
    return 'Process data may be incomplete: $error';
  }

  @override
  String get scanFailedRetry =>
      'Scan failed to retrieve apps. Please try again.';

  @override
  String scanError(String error) {
    return 'Scan error: $error';
  }

  @override
  String get scanInitializing => 'Initializing...';

  @override
  String get scanFailedTitle => 'Scan Failed';

  @override
  String get scanErrorInstruction =>
      'Please screenshot this error report and send it to the developer:';

  @override
  String get errorReportCopied => 'Error report copied to clipboard';

  @override
  String get copyErrorReport => 'Copy Error Report';

  @override
  String get closeLabel => 'Close';

  @override
  String get customizeAndShare => 'Customize & Share';

  @override
  String shareFailedError(String error) {
    return 'Failed to share: $error';
  }

  @override
  String shareTextExposed(String appName) {
    return '$appName just got exposed 🔍';
  }

  @override
  String shareTextBuiltWith(String stack) {
    return 'Built with: $stack';
  }

  @override
  String shareTextVersion(String version) {
    return 'Version: $version';
  }

  @override
  String shareTextSize(String size) {
    return 'Size: $size';
  }

  @override
  String get shareTextMarketing1 => 'See what your apps are really made of.';

  @override
  String get shareTextMarketing2 =>
      'github.com/r4khul/unfilter/releases/latest';

  @override
  String get shareTextMarketing3 => 'Don\'t forget to give a star!';

  @override
  String get shareImage => 'Share Image';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get optionVersion => 'Version';

  @override
  String get optionSdk => 'SDK';

  @override
  String get optionUsage => 'Usage';

  @override
  String get optionInstallDate => 'Install Date';

  @override
  String get optionSize => 'Size';

  @override
  String get optionSource => 'Source';

  @override
  String get optionTech => 'Tech';

  @override
  String get optionComponents => 'Components';

  @override
  String get optionSplits => 'Splits';

  @override
  String get giveAStarOnGithub => 'Give a Star on Github';

  @override
  String get commonLoadingLabel => 'Loading...';

  @override
  String get appNotFound => 'App not found';

  @override
  String get failedToLoadAppDetails => 'Failed to load app details';

  @override
  String get commonErrorLabel => 'Error';

  @override
  String get commonGoBackLabel => 'Go Back';

  @override
  String get contributorsTitle => 'Contributors';

  @override
  String get contributorsHeader => 'Community\nBuilders';

  @override
  String get contributorsIntro =>
      'The people who shaped this project with code, ideas, and energy.';

  @override
  String contributorsCount(int count) {
    return '$count contributor(s)';
  }

  @override
  String get contributeBeFirst => 'Be the first contributor';

  @override
  String get contributeBeFirstExternal => 'Become the 1st external contributor';

  @override
  String contributeNth(int count) {
    return 'You can be the ${count}th contributor';
  }

  @override
  String get contributeNow => 'Contribute Now';

  @override
  String get contributeSubtitle => 'Get your name in the app';

  @override
  String get contributorsEmptyTitle => 'No contributors yet';

  @override
  String get contributorsEmptySubtitle =>
      'Be the first to contribute and get featured here!';

  @override
  String get contributorsErrorTitle => 'Could not load contributors';

  @override
  String get contributorsErrorSubtitle =>
      'Please try again later or visit the GitHub repository.';

  @override
  String get viewOnGithub => 'View on GitHub';

  @override
  String get sponsorsTitle => 'Sponsors';

  @override
  String get sponsorsHeader => 'Community\nBackers';

  @override
  String get sponsorsIntro =>
      'The people helping keep this project open and moving forward.';

  @override
  String sponsorsCount(int count) {
    return '$count public sponsor(s)';
  }

  @override
  String get sponsorsBecome => 'Become a sponsor on GitHub';

  @override
  String get sponsorsEmptyTitle => 'No public sponsors yet';

  @override
  String get sponsorsErrorTitle => 'Could not load sponsors right now';

  @override
  String get sponsorsErrorSubtitle =>
      'Please try again in a bit or open the GitHub Sponsors page.';

  @override
  String get sponsorsOpenGitHub => 'Open GitHub Sponsors';

  @override
  String get commonViewProfile => 'View profile';

  @override
  String get noDataForPeriod => 'No data for period';

  @override
  String get usageOnThisDay => 'Usage on this day';

  @override
  String get dailyAverage => 'Daily Average';

  @override
  String get avgUsageWeek => 'Avg Usage (Week)';

  @override
  String pastRange(String range) {
    return 'Past $range';
  }

  @override
  String get permissionRequiredTitle => 'Permission Required';

  @override
  String topCountFilter(int count) {
    return 'Top $count Apps';
  }

  @override
  String topCount(int count) {
    return 'Top $count';
  }

  @override
  String commonErrorWithDetails(String error) {
    return 'Error: $error';
  }

  @override
  String get usageStatisticsTitle => 'Usage Statistics';

  @override
  String get noDataAvailable => 'No Data Available';

  @override
  String get tryDifferentDateRange => 'Try selecting a different date range';

  @override
  String get searchUsageStatsHint => 'Search usage stats...';

  @override
  String get searchEmptyState => 'No apps match your search';

  @override
  String trackingForPeriod(String periodText) {
    return 'Tracking for $periodText';
  }

  @override
  String daysStoredLocally(int count) {
    return '$count days stored locally';
  }

  @override
  String get historicalDataCleared =>
      'Some historical data was cleared by your device';

  @override
  String get topContributorsSection => 'TOP CONTRIBUTORS';

  @override
  String get searchResultsSection => 'SEARCH RESULTS';

  @override
  String get shareLabel => 'Share';

  @override
  String get shareAnalyticsViralText =>
      'Unfilter exposed my screen addiction 💀\n\nSee what apps are really made of. Real usage stats. No sugar coating.\n\n100% open source. No trackers. No BS.\n\nGet it: github.com/r4khul/unfilter/releases/latest\n\nDon\'t forget to give a star!\n';

  @override
  String get noStorageInfoAvailable => 'No storage info available';

  @override
  String get storageInsightsTitle => 'Storage Insights';

  @override
  String get searchStorageHint => 'Search storage...';

  @override
  String get heaviestAppsSection => 'HEAVIEST APPS';

  @override
  String get criticalUpdateRequired => 'Critical Update Required';

  @override
  String get criticalUpdateMessage =>
      'A critical native update is available. You must update the app to continue using it securely.';

  @override
  String get currentVersionLabel => 'Current Version';

  @override
  String get requiredVersionLabel => 'Required Version';

  @override
  String get downloadUpdateAction => 'Download Update';

  @override
  String get commonUnknownLabel => 'Unknown';

  @override
  String get newUpdateAvailable => 'New Update Available';

  @override
  String newNativeVersionAvailable(String version) {
    return 'A new native version ($version) is available with performance improvements.';
  }

  @override
  String get updateNowAction => 'Update Now';

  @override
  String get drawerMenu => 'Menu';

  @override
  String get drawerSettingsInfo => 'Settings & Info';

  @override
  String get drawerAppearance => 'APPEARANCE';

  @override
  String get drawerInsights => 'INSIGHTS';

  @override
  String get usageStatisticsSubtitle => 'View your digital wellbeing';

  @override
  String get storageInsightsSubtitle => 'Unfiltered space breakdown';

  @override
  String get taskManagerSubtitle => 'Monitor system resources';

  @override
  String get drawerTools => 'TOOLS';

  @override
  String get deeplinkTesterSubtitle => 'Test and inspect URI behavior';

  @override
  String get drawerInformation => 'INFORMATION';

  @override
  String get privacySecurityTitle => 'Privacy & Security';

  @override
  String get privacySecuritySubtitle => 'Offline and secure';

  @override
  String get drawerAbout => 'About';

  @override
  String get checkingVersion => 'Checking version...';

  @override
  String get versionUnknown => 'Version Unknown';

  @override
  String get updateAvailableBadge => ' • Update';

  @override
  String get reportIssue => 'Report Issue';

  @override
  String get drawerCommunity => 'COMMUNITY';

  @override
  String get themeAuto => 'Auto';

  @override
  String get supportProject => 'Support the project';

  @override
  String get madeBy => 'Made by ';

  @override
  String get viewAllContributors => 'View all contributors';
}

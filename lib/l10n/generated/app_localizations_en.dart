// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
}

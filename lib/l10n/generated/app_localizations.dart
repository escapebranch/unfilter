import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ta'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'UnFilter'**
  String get appTitle;

  /// Homepage title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// Title shown in language selection dialog
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguageDialogTitle;

  /// Subtitle shown in language selection dialog
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to navigate through application'**
  String get chooseLanguageDialogSubtitle;

  /// English language name shown in selector
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Tamil language name shown in selector
  ///
  /// In en, this message translates to:
  /// **'Tamil'**
  String get languageTamil;

  /// Generic confirm action label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButtonLabel;

  /// No description provided for @premiumAppBarResyncApp.
  ///
  /// In en, this message translates to:
  /// **'Resync App'**
  String get premiumAppBarResyncApp;

  /// No description provided for @premiumAppBarShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get premiumAppBarShare;

  /// No description provided for @premiumAppBarMenuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get premiumAppBarMenuTooltip;

  /// No description provided for @commonOpenLabel.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get commonOpenLabel;

  /// No description provided for @commonViewLabel.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get commonViewLabel;

  /// No description provided for @commonClearLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClearLabel;

  /// No description provided for @commonPreviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get commonPreviewLabel;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyTermsAndConditionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get privacyTermsAndConditionsTitle;

  /// No description provided for @privacyHeader.
  ///
  /// In en, this message translates to:
  /// **'Your Data,\nYour Device'**
  String get privacyHeader;

  /// No description provided for @privacyIntro.
  ///
  /// In en, this message translates to:
  /// **'Privacy is part of the product, not an afterthought. UnFilter runs offline so it can stay useful without ever becoming nosy about you.'**
  String get privacyIntro;

  /// No description provided for @privacySectionLocalProcessingTitle.
  ///
  /// In en, this message translates to:
  /// **'Local Processing'**
  String get privacySectionLocalProcessingTitle;

  /// No description provided for @privacySectionLocalProcessingContent.
  ///
  /// In en, this message translates to:
  /// **'Every scan, every match, every bit of analysis runs right on your phone. We couldn\'t peek at your apps even if we wanted to - we built it that way.'**
  String get privacySectionLocalProcessingContent;

  /// No description provided for @privacySectionMinimalPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Minimal Permissions'**
  String get privacySectionMinimalPermissionsTitle;

  /// No description provided for @privacySectionMinimalPermissionsContent.
  ///
  /// In en, this message translates to:
  /// **'We ask for exactly two things: permission to see what apps you have installed, and storage access for looking through native libraries. That\'s it.'**
  String get privacySectionMinimalPermissionsContent;

  /// No description provided for @privacySectionNoTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'No Tracking'**
  String get privacySectionNoTrackingTitle;

  /// No description provided for @privacySectionNoTrackingContent.
  ///
  /// In en, this message translates to:
  /// **'No analytics. No ad SDKs. No crash reporters phoning home. What you do inside the app stays between you and your phone.'**
  String get privacySectionNoTrackingContent;

  /// No description provided for @privacySectionLimitedNetworkingTitle.
  ///
  /// In en, this message translates to:
  /// **'Limited Networking'**
  String get privacySectionLimitedNetworkingTitle;

  /// No description provided for @privacySectionLimitedNetworkingContent.
  ///
  /// In en, this message translates to:
  /// **'The only time we hit the internet is to check for updates and grab the GitHub star count. That\'s it - nothing about you leaves this app.'**
  String get privacySectionLimitedNetworkingContent;

  /// No description provided for @howItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorksTitle;

  /// No description provided for @howItWorksHeader.
  ///
  /// In en, this message translates to:
  /// **'App\nClues'**
  String get howItWorksHeader;

  /// No description provided for @howItWorksIntro.
  ///
  /// In en, this message translates to:
  /// **'No decompiling. No uploads. Just smart local analysis that reads what\'s already there and tells you what an app is made of.'**
  String get howItWorksIntro;

  /// No description provided for @howItWorksOpenSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Open Source'**
  String get howItWorksOpenSourceLabel;

  /// No description provided for @howItWorksStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Collect Clues'**
  String get howItWorksStep1Title;

  /// No description provided for @howItWorksStep1Description.
  ///
  /// In en, this message translates to:
  /// **'We look at each app\'s package info and native libraries already sitting on your phone. No uploads, no account, no drama.'**
  String get howItWorksStep1Description;

  /// No description provided for @howItWorksStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Match Signals'**
  String get howItWorksStep2Title;

  /// No description provided for @howItWorksStep2Description.
  ///
  /// In en, this message translates to:
  /// **'We compare those clues against local framework fingerprints to spot Flutter, React Native, Unity, and the rest of the usual suspects.'**
  String get howItWorksStep2Description;

  /// No description provided for @howItWorksStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Stay Local'**
  String get howItWorksStep3Title;

  /// No description provided for @howItWorksStep3Description.
  ///
  /// In en, this message translates to:
  /// **'Every scan happens on-device. The fun stays private and your app data never leaves your phone.'**
  String get howItWorksStep3Description;

  /// No description provided for @deeplinkTesterTitle.
  ///
  /// In en, this message translates to:
  /// **'Deep Link Tester'**
  String get deeplinkTesterTitle;

  /// No description provided for @deeplinkInitialStatus.
  ///
  /// In en, this message translates to:
  /// **'Enter a deeplink to test it.'**
  String get deeplinkInitialStatus;

  /// No description provided for @deeplinkEnterSchemeError.
  ///
  /// In en, this message translates to:
  /// **'Please enter at least a scheme.'**
  String get deeplinkEnterSchemeError;

  /// No description provided for @deeplinkInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Invalid deeplink. Include a valid URI scheme.'**
  String get deeplinkInvalidError;

  /// No description provided for @deeplinkCanHandle.
  ///
  /// In en, this message translates to:
  /// **'Deep link can be handled on this device.'**
  String get deeplinkCanHandle;

  /// No description provided for @deeplinkNoHandler.
  ///
  /// In en, this message translates to:
  /// **'No app can handle this deep link right now.'**
  String get deeplinkNoHandler;

  /// No description provided for @deeplinkLaunchedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Deep link launched successfully.'**
  String get deeplinkLaunchedSuccess;

  /// No description provided for @deeplinkLaunchFailedRecognized.
  ///
  /// In en, this message translates to:
  /// **'Deep link was recognized but failed to launch.'**
  String get deeplinkLaunchFailedRecognized;

  /// No description provided for @deeplinkLaunchFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to launch deep link.'**
  String get deeplinkLaunchFailed;

  /// No description provided for @deeplinkComponentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Deep Link Components'**
  String get deeplinkComponentsTitle;

  /// No description provided for @deeplinkPasteFullUrlHint.
  ///
  /// In en, this message translates to:
  /// **'Paste full URL here (e.g., myapp://host/path)'**
  String get deeplinkPasteFullUrlHint;

  /// No description provided for @deeplinkAutofillHint.
  ///
  /// In en, this message translates to:
  /// **'Paste full URL above to auto-fill fields'**
  String get deeplinkAutofillHint;

  /// No description provided for @deeplinkLabelScheme.
  ///
  /// In en, this message translates to:
  /// **'Scheme'**
  String get deeplinkLabelScheme;

  /// No description provided for @deeplinkLabelHost.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get deeplinkLabelHost;

  /// No description provided for @deeplinkLabelPath.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get deeplinkLabelPath;

  /// No description provided for @deeplinkLabelQuery.
  ///
  /// In en, this message translates to:
  /// **'Query'**
  String get deeplinkLabelQuery;

  /// No description provided for @deeplinkLabelFragment.
  ///
  /// In en, this message translates to:
  /// **'Fragment'**
  String get deeplinkLabelFragment;

  /// No description provided for @deeplinkHintScheme.
  ///
  /// In en, this message translates to:
  /// **'e.g. mailto, https'**
  String get deeplinkHintScheme;

  /// No description provided for @deeplinkHintHost.
  ///
  /// In en, this message translates to:
  /// **'e.g. example.com'**
  String get deeplinkHintHost;

  /// No description provided for @deeplinkHintPath.
  ///
  /// In en, this message translates to:
  /// **'e.g. /profile'**
  String get deeplinkHintPath;

  /// No description provided for @deeplinkHintQuery.
  ///
  /// In en, this message translates to:
  /// **'e.g. id=123'**
  String get deeplinkHintQuery;

  /// No description provided for @deeplinkHintFragment.
  ///
  /// In en, this message translates to:
  /// **'e.g. section1'**
  String get deeplinkHintFragment;

  /// No description provided for @deeplinkTestButton.
  ///
  /// In en, this message translates to:
  /// **'Test Deeplink'**
  String get deeplinkTestButton;

  /// No description provided for @deeplinkTryExamplesButton.
  ///
  /// In en, this message translates to:
  /// **'Try Examples'**
  String get deeplinkTryExamplesButton;

  /// No description provided for @deeplinkExamplesTitle.
  ///
  /// In en, this message translates to:
  /// **'Deep Link Examples'**
  String get deeplinkExamplesTitle;

  /// No description provided for @deeplinkExampleComposeEmail.
  ///
  /// In en, this message translates to:
  /// **'Compose Email'**
  String get deeplinkExampleComposeEmail;

  /// No description provided for @deeplinkExamplePhoneCall.
  ///
  /// In en, this message translates to:
  /// **'Phone Call'**
  String get deeplinkExamplePhoneCall;

  /// No description provided for @deeplinkExampleSendSms.
  ///
  /// In en, this message translates to:
  /// **'Send SMS'**
  String get deeplinkExampleSendSms;

  /// No description provided for @deeplinkMoreConfigsSoon.
  ///
  /// In en, this message translates to:
  /// **'More configurations coming soon!'**
  String get deeplinkMoreConfigsSoon;

  /// No description provided for @deeplinkParsedEmpty.
  ///
  /// In en, this message translates to:
  /// **'URI breakdown will appear here after testing.'**
  String get deeplinkParsedEmpty;

  /// No description provided for @deeplinkParsedDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Parsed URI Details'**
  String get deeplinkParsedDetailsTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

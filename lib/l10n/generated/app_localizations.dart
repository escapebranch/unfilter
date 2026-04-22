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

  /// No description provided for @apps.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get apps;

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

  /// No description provided for @homeStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Device has'**
  String get homeStatsTitle;

  /// No description provided for @homeStatsCountText.
  ///
  /// In en, this message translates to:
  /// **'{count} Installed Apps'**
  String homeStatsCountText(String count);

  /// No description provided for @permission.
  ///
  /// In en, this message translates to:
  /// **'Permission'**
  String get permission;

  /// No description provided for @permissionDescription1.
  ///
  /// In en, this message translates to:
  /// **'UnFilter needs secure access to your usage stats so it can help you '**
  String get permissionDescription1;

  /// No description provided for @permissionDescription2.
  ///
  /// In en, this message translates to:
  /// **'spot what apps are made of and power the analytics view.\n\n'**
  String get permissionDescription2;

  /// No description provided for @permissionDescription3.
  ///
  /// In en, this message translates to:
  /// **'Your data never leaves your device.'**
  String get permissionDescription3;

  /// No description provided for @grantAccess.
  ///
  /// In en, this message translates to:
  /// **'Grant Access'**
  String get grantAccess;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @noAppsFound.
  ///
  /// In en, this message translates to:
  /// **'No apps found matching criteria'**
  String get noAppsFound;

  /// No description provided for @somethingWentWrongScanning.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while scanning.\n'**
  String get somethingWentWrongScanning;

  /// No description provided for @taskManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Manager'**
  String get taskManagerTitle;

  /// No description provided for @failedToLoadProcesses.
  ///
  /// In en, this message translates to:
  /// **'Failed to load processes'**
  String get failedToLoadProcesses;

  /// No description provided for @retryLabel.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryLabel;

  /// No description provided for @kernelSystemSection.
  ///
  /// In en, this message translates to:
  /// **'KERNEL / SYSTEM'**
  String get kernelSystemSection;

  /// No description provided for @noProcessesMatchSearch.
  ///
  /// In en, this message translates to:
  /// **'No processes match your search'**
  String get noProcessesMatchSearch;

  /// No description provided for @noProcessDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No process data available'**
  String get noProcessDataAvailable;

  /// No description provided for @processDataIncompleteError.
  ///
  /// In en, this message translates to:
  /// **'Process data may be incomplete: {error}'**
  String processDataIncompleteError(String error);

  /// No description provided for @scanFailedRetry.
  ///
  /// In en, this message translates to:
  /// **'Scan failed to retrieve apps. Please try again.'**
  String get scanFailedRetry;

  /// No description provided for @scanError.
  ///
  /// In en, this message translates to:
  /// **'Scan error: {error}'**
  String scanError(String error);

  /// No description provided for @scanInitializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get scanInitializing;

  /// No description provided for @scanFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Failed'**
  String get scanFailedTitle;

  /// No description provided for @scanErrorInstruction.
  ///
  /// In en, this message translates to:
  /// **'Please screenshot this error report and send it to the developer:'**
  String get scanErrorInstruction;

  /// No description provided for @errorReportCopied.
  ///
  /// In en, this message translates to:
  /// **'Error report copied to clipboard'**
  String get errorReportCopied;

  /// No description provided for @copyErrorReport.
  ///
  /// In en, this message translates to:
  /// **'Copy Error Report'**
  String get copyErrorReport;

  /// No description provided for @closeLabel.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeLabel;

  /// No description provided for @customizeAndShare.
  ///
  /// In en, this message translates to:
  /// **'Customize & Share'**
  String get customizeAndShare;

  /// No description provided for @shareFailedError.
  ///
  /// In en, this message translates to:
  /// **'Failed to share: {error}'**
  String shareFailedError(String error);

  /// No description provided for @shareTextExposed.
  ///
  /// In en, this message translates to:
  /// **'{appName} just got exposed 🔍'**
  String shareTextExposed(String appName);

  /// No description provided for @shareTextBuiltWith.
  ///
  /// In en, this message translates to:
  /// **'Built with: {stack}'**
  String shareTextBuiltWith(String stack);

  /// No description provided for @shareTextVersion.
  ///
  /// In en, this message translates to:
  /// **'Version: {version}'**
  String shareTextVersion(String version);

  /// No description provided for @shareTextSize.
  ///
  /// In en, this message translates to:
  /// **'Size: {size}'**
  String shareTextSize(String size);

  /// No description provided for @shareTextMarketing1.
  ///
  /// In en, this message translates to:
  /// **'See what your apps are really made of.'**
  String get shareTextMarketing1;

  /// No description provided for @shareTextMarketing2.
  ///
  /// In en, this message translates to:
  /// **'github.com/r4khul/unfilter/releases/latest'**
  String get shareTextMarketing2;

  /// No description provided for @shareTextMarketing3.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget to give a star!'**
  String get shareTextMarketing3;

  /// No description provided for @shareImage.
  ///
  /// In en, this message translates to:
  /// **'Share Image'**
  String get shareImage;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @optionVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get optionVersion;

  /// No description provided for @optionSdk.
  ///
  /// In en, this message translates to:
  /// **'SDK'**
  String get optionSdk;

  /// No description provided for @optionUsage.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get optionUsage;

  /// No description provided for @optionInstallDate.
  ///
  /// In en, this message translates to:
  /// **'Install Date'**
  String get optionInstallDate;

  /// No description provided for @optionSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get optionSize;

  /// No description provided for @optionSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get optionSource;

  /// No description provided for @optionTech.
  ///
  /// In en, this message translates to:
  /// **'Tech'**
  String get optionTech;

  /// No description provided for @optionComponents.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get optionComponents;

  /// No description provided for @optionSplits.
  ///
  /// In en, this message translates to:
  /// **'Splits'**
  String get optionSplits;

  /// No description provided for @giveAStarOnGithub.
  ///
  /// In en, this message translates to:
  /// **'Give a Star on Github'**
  String get giveAStarOnGithub;

  /// No description provided for @commonLoadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoadingLabel;

  /// No description provided for @appNotFound.
  ///
  /// In en, this message translates to:
  /// **'App not found'**
  String get appNotFound;

  /// No description provided for @failedToLoadAppDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load app details'**
  String get failedToLoadAppDetails;

  /// No description provided for @commonErrorLabel.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get commonErrorLabel;

  /// No description provided for @commonGoBackLabel.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get commonGoBackLabel;

  /// No description provided for @contributorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contributors'**
  String get contributorsTitle;

  /// No description provided for @contributorsHeader.
  ///
  /// In en, this message translates to:
  /// **'Community\nBuilders'**
  String get contributorsHeader;

  /// No description provided for @contributorsIntro.
  ///
  /// In en, this message translates to:
  /// **'The people who shaped this project with code, ideas, and energy.'**
  String get contributorsIntro;

  /// No description provided for @contributorsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} contributor(s)'**
  String contributorsCount(int count);

  /// No description provided for @contributeBeFirst.
  ///
  /// In en, this message translates to:
  /// **'Be the first contributor'**
  String get contributeBeFirst;

  /// No description provided for @contributeBeFirstExternal.
  ///
  /// In en, this message translates to:
  /// **'Become the 1st external contributor'**
  String get contributeBeFirstExternal;

  /// No description provided for @contributeNth.
  ///
  /// In en, this message translates to:
  /// **'You can be the {count}th contributor'**
  String contributeNth(int count);

  /// No description provided for @contributeNow.
  ///
  /// In en, this message translates to:
  /// **'Contribute Now'**
  String get contributeNow;

  /// No description provided for @contributeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get your name in the app'**
  String get contributeSubtitle;

  /// No description provided for @contributorsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No contributors yet'**
  String get contributorsEmptyTitle;

  /// No description provided for @contributorsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Be the first to contribute and get featured here!'**
  String get contributorsEmptySubtitle;

  /// No description provided for @contributorsErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load contributors'**
  String get contributorsErrorTitle;

  /// No description provided for @contributorsErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please try again later or visit the GitHub repository.'**
  String get contributorsErrorSubtitle;

  /// No description provided for @viewOnGithub.
  ///
  /// In en, this message translates to:
  /// **'View on GitHub'**
  String get viewOnGithub;

  /// No description provided for @sponsorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sponsors'**
  String get sponsorsTitle;

  /// No description provided for @sponsorsHeader.
  ///
  /// In en, this message translates to:
  /// **'Community\nBackers'**
  String get sponsorsHeader;

  /// No description provided for @sponsorsIntro.
  ///
  /// In en, this message translates to:
  /// **'The people helping keep this project open and moving forward.'**
  String get sponsorsIntro;

  /// No description provided for @sponsorsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} public sponsor(s)'**
  String sponsorsCount(int count);

  /// No description provided for @sponsorsBecome.
  ///
  /// In en, this message translates to:
  /// **'Become a sponsor on GitHub'**
  String get sponsorsBecome;

  /// No description provided for @sponsorsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No public sponsors yet'**
  String get sponsorsEmptyTitle;

  /// No description provided for @sponsorsErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load sponsors right now'**
  String get sponsorsErrorTitle;

  /// No description provided for @sponsorsErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please try again in a bit or open the GitHub Sponsors page.'**
  String get sponsorsErrorSubtitle;

  /// No description provided for @sponsorsOpenGitHub.
  ///
  /// In en, this message translates to:
  /// **'Open GitHub Sponsors'**
  String get sponsorsOpenGitHub;

  /// No description provided for @commonViewProfile.
  ///
  /// In en, this message translates to:
  /// **'View profile'**
  String get commonViewProfile;

  /// No description provided for @noDataForPeriod.
  ///
  /// In en, this message translates to:
  /// **'No data for period'**
  String get noDataForPeriod;

  /// No description provided for @usageOnThisDay.
  ///
  /// In en, this message translates to:
  /// **'Usage on this day'**
  String get usageOnThisDay;

  /// No description provided for @dailyAverage.
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get dailyAverage;

  /// No description provided for @avgUsageWeek.
  ///
  /// In en, this message translates to:
  /// **'Avg Usage (Week)'**
  String get avgUsageWeek;

  /// No description provided for @pastRange.
  ///
  /// In en, this message translates to:
  /// **'Past {range}'**
  String pastRange(String range);

  /// No description provided for @permissionRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequiredTitle;

  /// No description provided for @topCountFilter.
  ///
  /// In en, this message translates to:
  /// **'Top {count} Apps'**
  String topCountFilter(int count);

  /// No description provided for @topCount.
  ///
  /// In en, this message translates to:
  /// **'Top {count}'**
  String topCount(int count);

  /// No description provided for @commonErrorWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String commonErrorWithDetails(String error);

  /// No description provided for @usageStatisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage Statistics'**
  String get usageStatisticsTitle;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Data Available'**
  String get noDataAvailable;

  /// No description provided for @tryDifferentDateRange.
  ///
  /// In en, this message translates to:
  /// **'Try selecting a different date range'**
  String get tryDifferentDateRange;

  /// No description provided for @searchUsageStatsHint.
  ///
  /// In en, this message translates to:
  /// **'Search usage stats...'**
  String get searchUsageStatsHint;

  /// No description provided for @searchEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No apps match your search'**
  String get searchEmptyState;

  /// No description provided for @trackingForPeriod.
  ///
  /// In en, this message translates to:
  /// **'Tracking for {periodText}'**
  String trackingForPeriod(String periodText);

  /// No description provided for @daysStoredLocally.
  ///
  /// In en, this message translates to:
  /// **'{count} days stored locally'**
  String daysStoredLocally(int count);

  /// No description provided for @historicalDataCleared.
  ///
  /// In en, this message translates to:
  /// **'Some historical data was cleared by your device'**
  String get historicalDataCleared;

  /// No description provided for @topContributorsSection.
  ///
  /// In en, this message translates to:
  /// **'TOP CONTRIBUTORS'**
  String get topContributorsSection;

  /// No description provided for @searchResultsSection.
  ///
  /// In en, this message translates to:
  /// **'SEARCH RESULTS'**
  String get searchResultsSection;

  /// No description provided for @shareLabel.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareLabel;

  /// No description provided for @shareAnalyticsViralText.
  ///
  /// In en, this message translates to:
  /// **'Unfilter exposed my screen addiction 💀\n\nSee what apps are really made of. Real usage stats. No sugar coating.\n\n100% open source. No trackers. No BS.\n\nGet it: github.com/r4khul/unfilter/releases/latest\n\nDon\'t forget to give a star!\n'**
  String get shareAnalyticsViralText;

  /// No description provided for @noStorageInfoAvailable.
  ///
  /// In en, this message translates to:
  /// **'No storage info available'**
  String get noStorageInfoAvailable;

  /// No description provided for @storageInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Storage Insights'**
  String get storageInsightsTitle;

  /// No description provided for @searchStorageHint.
  ///
  /// In en, this message translates to:
  /// **'Search storage...'**
  String get searchStorageHint;

  /// No description provided for @heaviestAppsSection.
  ///
  /// In en, this message translates to:
  /// **'HEAVIEST APPS'**
  String get heaviestAppsSection;

  /// No description provided for @criticalUpdateRequired.
  ///
  /// In en, this message translates to:
  /// **'Critical Update Required'**
  String get criticalUpdateRequired;

  /// No description provided for @criticalUpdateMessage.
  ///
  /// In en, this message translates to:
  /// **'A critical native update is available. You must update the app to continue using it securely.'**
  String get criticalUpdateMessage;

  /// No description provided for @currentVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Version'**
  String get currentVersionLabel;

  /// No description provided for @requiredVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Required Version'**
  String get requiredVersionLabel;

  /// No description provided for @downloadUpdateAction.
  ///
  /// In en, this message translates to:
  /// **'Download Update'**
  String get downloadUpdateAction;

  /// No description provided for @commonUnknownLabel.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get commonUnknownLabel;

  /// No description provided for @newUpdateAvailable.
  ///
  /// In en, this message translates to:
  /// **'New Update Available'**
  String get newUpdateAvailable;

  /// No description provided for @newNativeVersionAvailable.
  ///
  /// In en, this message translates to:
  /// **'A new native version ({version}) is available with performance improvements.'**
  String newNativeVersionAvailable(String version);

  /// No description provided for @updateNowAction.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNowAction;

  /// No description provided for @drawerMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get drawerMenu;

  /// No description provided for @drawerSettingsInfo.
  ///
  /// In en, this message translates to:
  /// **'Settings & Info'**
  String get drawerSettingsInfo;

  /// No description provided for @drawerAppearance.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get drawerAppearance;

  /// No description provided for @drawerInsights.
  ///
  /// In en, this message translates to:
  /// **'INSIGHTS'**
  String get drawerInsights;

  /// No description provided for @usageStatisticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View your digital wellbeing'**
  String get usageStatisticsSubtitle;

  /// No description provided for @storageInsightsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unfiltered space breakdown'**
  String get storageInsightsSubtitle;

  /// No description provided for @taskManagerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor system resources'**
  String get taskManagerSubtitle;

  /// No description provided for @drawerTools.
  ///
  /// In en, this message translates to:
  /// **'TOOLS'**
  String get drawerTools;

  /// No description provided for @deeplinkTesterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Test and inspect URI behavior'**
  String get deeplinkTesterSubtitle;

  /// No description provided for @drawerInformation.
  ///
  /// In en, this message translates to:
  /// **'INFORMATION'**
  String get drawerInformation;

  /// No description provided for @privacySecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurityTitle;

  /// No description provided for @privacySecuritySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Offline and secure'**
  String get privacySecuritySubtitle;

  /// No description provided for @drawerAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get drawerAbout;

  /// No description provided for @checkingVersion.
  ///
  /// In en, this message translates to:
  /// **'Checking version...'**
  String get checkingVersion;

  /// No description provided for @versionUnknown.
  ///
  /// In en, this message translates to:
  /// **'Version Unknown'**
  String get versionUnknown;

  /// No description provided for @updateAvailableBadge.
  ///
  /// In en, this message translates to:
  /// **' • Update'**
  String get updateAvailableBadge;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get reportIssue;

  /// No description provided for @drawerCommunity.
  ///
  /// In en, this message translates to:
  /// **'COMMUNITY'**
  String get drawerCommunity;

  /// No description provided for @themeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get themeAuto;

  /// No description provided for @supportProject.
  ///
  /// In en, this message translates to:
  /// **'Support the project'**
  String get supportProject;

  /// No description provided for @madeBy.
  ///
  /// In en, this message translates to:
  /// **'Made by '**
  String get madeBy;

  /// No description provided for @viewAllContributors.
  ///
  /// In en, this message translates to:
  /// **'View all contributors'**
  String get viewAllContributors;
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

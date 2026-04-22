// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get apps => 'செயலிகள்';

  @override
  String get appTitle => 'அன்ஃபில்டர்';

  @override
  String get homeTitle => 'முகப்பு';

  @override
  String get chooseLanguageDialogTitle => 'மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get chooseLanguageDialogSubtitle =>
      'பயன்பாட்டை நீங்கள் எப்படி பயன்படுத்த வேண்டும் என்பதைத் தேர்ந்தெடுக்கவும்';

  @override
  String get languageEnglish => 'ஆங்கிலம்';

  @override
  String get languageTamil => 'தமிழ்';

  @override
  String get confirmButtonLabel => 'உறுதிப்படுத்து';

  @override
  String get premiumAppBarResyncApp => 'மீண்டும் ஒத்திசை';

  @override
  String get premiumAppBarShare => 'பகிர்';

  @override
  String get premiumAppBarMenuTooltip => 'மெனு';

  @override
  String get commonOpenLabel => 'திற';

  @override
  String get commonViewLabel => 'பார்';

  @override
  String get commonClearLabel => 'அழி';

  @override
  String get commonPreviewLabel => 'முன்னோட்டம்';

  @override
  String get privacyPolicyTitle => 'தனியுரிமைக் கொள்கை';

  @override
  String get privacyTermsAndConditionsTitle =>
      'விதிமுறைகள் மற்றும் நிபந்தனைகள்';

  @override
  String get privacyHeader => 'உங்கள் தரவு,\nஉங்கள் சாதனம்';

  @override
  String get privacyIntro =>
      'தனியுரிமை ஒரு பின்னணி யோசனை இல்லை - அது தயாரிப்பின் ஒரு பகுதி. அன்ஃபில்டர் இணையமின்றி இயங்குகிறது; உங்களைப் பற்றி எதையும் உளவு பார்க்காது.';

  @override
  String get privacySectionLocalProcessingTitle => 'உள்ளக செயலாக்கம்';

  @override
  String get privacySectionLocalProcessingContent =>
      'ஒவ்வொரு ஸ்கேன், பொருத்தம், பகுப்பாய்வு எல்லாமும் உங்கள் தொலைபேசியில் மட்டுமே நடக்கும். நாங்கள் உங்கள் பயன்பாடுகளை பார்க்க முடியாதபடி இதை வடிவமைத்தோம்.';

  @override
  String get privacySectionMinimalPermissionsTitle => 'குறைந்த அனுமதிகள்';

  @override
  String get privacySectionMinimalPermissionsContent =>
      'நாங்கள் இரண்டு அனுமதிகள் மட்டுமே கேட்கிறோம்: நிறுவிய பயன்பாடுகளைப் பார்க்கவும், native libraries-ஐ ஆய்வு செய்ய storage அணுகலும். அதுவே அனைத்தும்.';

  @override
  String get privacySectionNoTrackingTitle => 'கண்காணிப்பு இல்லை';

  @override
  String get privacySectionNoTrackingContent =>
      'Analytics இல்லை. Ad SDKs இல்லை. Crash report அனுப்புதல் இல்லை. நீங்கள் app-ல் செய்வது உங்கள் சாதனத்திலேயே இருக்கும்.';

  @override
  String get privacySectionLimitedNetworkingTitle =>
      'வரையறுக்கப்பட்ட இணைய பயன்பாடு';

  @override
  String get privacySectionLimitedNetworkingContent =>
      'நாங்கள் இணையத்தைப் பயன்படுத்துவது update பார்க்கவும் GitHub நட்சத்திர எண்ணிக்கை பெறவும் மட்டும். உங்களைப் பற்றிய எதுவும் app-யை விட்டு வெளியே போகாது.';

  @override
  String get howItWorksTitle => 'இது எப்படி வேலை செய்கிறது';

  @override
  String get howItWorksHeader => 'ஆப்\nகுறிகள்';

  @override
  String get howItWorksIntro =>
      'Decompile இல்லை. Upload இல்லை. உங்கள் சாதனத்தில் உள்ள தகவல்களை உள்ளூராக ஆய்வு செய்து பயன்பாடு எதில் உருவானது என்பதை சொல்கிறது.';

  @override
  String get howItWorksOpenSourceLabel => 'திறந்த மூலக் குறியீடு';

  @override
  String get howItWorksStep1Title => 'குறிகளை சேகரி';

  @override
  String get howItWorksStep1Description =>
      'ஒவ்வொரு app-னுடைய package தகவலும் native libraries-மும் உங்கள் சாதனத்தில் இருந்தபடியே வாசிக்கப்படும். Upload இல்லை, account தேவையில்லை.';

  @override
  String get howItWorksStep2Title => 'சிக்னல்களை பொருத்து';

  @override
  String get howItWorksStep2Description =>
      'இந்த குறிகளை உள்ளக framework fingerprints-ஓடு ஒப்பிட்டு Flutter, React Native, Unity போன்றவை கண்டறியப்படும்.';

  @override
  String get howItWorksStep3Title => 'உள்ளூரில் வைத்திரு';

  @override
  String get howItWorksStep3Description =>
      'ஒவ்வொரு scan-மும் சாதனத்திலேயே நடக்கும். தரவு உங்கள் சாதனத்தை விட்டு வெளியே போகாது.';

  @override
  String get deeplinkTesterTitle => 'டீப் லிங்க் சோதனை';

  @override
  String get deeplinkInitialStatus => 'சோதிக்க ஒரு deeplink உள்ளிடவும்.';

  @override
  String get deeplinkEnterSchemeError => 'குறைந்தது ஒரு scheme ஐ உள்ளிடவும்.';

  @override
  String get deeplinkInvalidError =>
      'செல்லாத deeplink. செல்லுபடியாகும் URI scheme சேர்க்கவும்.';

  @override
  String get deeplinkCanHandle => 'இந்த deeplink-ஐ இந்த சாதனம் கையாள முடியும்.';

  @override
  String get deeplinkNoHandler =>
      'இந்த deeplink-ஐ இப்போது எந்த app-மும் கையாள முடியாது.';

  @override
  String get deeplinkLaunchedSuccess => 'Deep link வெற்றிகரமாக திறக்கப்பட்டது.';

  @override
  String get deeplinkLaunchFailedRecognized =>
      'Deep link அடையாளம் காணப்பட்டது, ஆனால் திறக்க முடியவில்லை.';

  @override
  String get deeplinkLaunchFailed => 'Deep link திறக்க தோல்வியடைந்தது.';

  @override
  String get deeplinkComponentsTitle => 'Deep Link கூறுகள்';

  @override
  String get deeplinkPasteFullUrlHint =>
      'முழு URL ஐ இங்கு ஒட்டவும் (எ.கா., myapp://host/path)';

  @override
  String get deeplinkAutofillHint =>
      'மேலே முழு URL ஒட்டினால் புலங்கள் தானாக நிரம்பும்';

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
  String get deeplinkHintScheme => 'எ.கா. mailto, https';

  @override
  String get deeplinkHintHost => 'எ.கா. example.com';

  @override
  String get deeplinkHintPath => 'எ.கா. /profile';

  @override
  String get deeplinkHintQuery => 'எ.கா. id=123';

  @override
  String get deeplinkHintFragment => 'எ.கா. section1';

  @override
  String get deeplinkTestButton => 'Deeplink சோதிக்க';

  @override
  String get deeplinkTryExamplesButton => 'உதாரணங்களை முயற்சி செய்';

  @override
  String get deeplinkExamplesTitle => 'Deep Link உதாரணங்கள்';

  @override
  String get deeplinkExampleComposeEmail => 'மின்னஞ்சல் எழுத';

  @override
  String get deeplinkExamplePhoneCall => 'தொலைபேசி அழைப்பு';

  @override
  String get deeplinkExampleSendSms => 'SMS அனுப்பு';

  @override
  String get deeplinkMoreConfigsSoon => 'மேலும் அமைப்புகள் விரைவில் வருகிறது!';

  @override
  String get deeplinkParsedEmpty =>
      'சோதித்த பிறகு URI பகுப்பாய்வு இங்கே காட்டப்படும்.';

  @override
  String get deeplinkParsedDetailsTitle => 'Parsed URI விவரங்கள்';

  @override
  String get homeStatsTitle => 'உங்கள் சாதனத்தில்';

  @override
  String homeStatsCountText(String count) {
    return '$count செயலிகள் உள்ளது';
  }

  @override
  String get permission => 'அனுமதி';

  @override
  String get permissionDescription1 =>
      'UnFilter உங்கள் பயன்பாட்டு புள்ளிவிவரங்களை அணுக வேண்டும், இதனால் ';

  @override
  String get permissionDescription2 =>
      'app-கள் எதில் உருவானது என்பதை கண்டறிந்து analytics காட்ட முடியும்.\n\n';

  @override
  String get permissionDescription3 =>
      'உங்கள் தரவு ஒருபோதும் சாதனத்தை விட்டு வெளியே போகாது.';

  @override
  String get grantAccess => 'அணுகல் வழங்கு';

  @override
  String get maybeLater => 'பிறகு பார்க்கலாம்';

  @override
  String get noAppsFound => 'பொருந்தும் செயலிகள் எதுவும் இல்லை';

  @override
  String get somethingWentWrongScanning =>
      'ஸ்கேன் செய்யும்போது பிழை ஏற்பட்டது.\n';

  @override
  String get taskManagerTitle => 'பணி மேலாளர்';

  @override
  String get failedToLoadProcesses => 'செயல்முறைகளை ஏற்ற முடியவில்லை';

  @override
  String get retryLabel => 'மீண்டும் முயற்சி';

  @override
  String get kernelSystemSection => 'KERNEL / SYSTEM';

  @override
  String get noProcessesMatchSearch =>
      'தேடலுக்கு பொருந்தும் செயல்முறைகள் இல்லை';

  @override
  String get noProcessDataAvailable => 'செயல்முறை தரவு எதுவும் இல்லை';

  @override
  String processDataIncompleteError(String error) {
    return 'செயல்முறை தரவு முழுமையற்றதாக இருக்கலாம்: $error';
  }

  @override
  String get scanFailedRetry =>
      'ஸ்கேன் செய்ய முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String scanError(String error) {
    return 'ஸ்கேன் பிழை: $error';
  }

  @override
  String get scanInitializing => 'தொடங்குகிறது...';

  @override
  String get scanFailedTitle => 'ஸ்கேன் தோல்வி';

  @override
  String get scanErrorInstruction =>
      'இந்த பிழை அறிக்கையின் screenshot எடுத்து டெவலப்பருக்கு அனுப்பவும்:';

  @override
  String get errorReportCopied => 'பிழை அறிக்கை clipboard-ல் நகலெடுக்கப்பட்டது';

  @override
  String get copyErrorReport => 'பிழை அறிக்கையை நகலெடு';

  @override
  String get closeLabel => 'மூடு';

  @override
  String get customizeAndShare => 'தனிப்படுத்தி பகிர்';

  @override
  String shareFailedError(String error) {
    return 'பகிர முடியவில்லை: $error';
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
  String get shareImage => 'படத்தை பகிர்';

  @override
  String get themeDark => 'இருண்ட';

  @override
  String get themeLight => 'வெளிர்';

  @override
  String get optionVersion => 'பதிப்பு';

  @override
  String get optionSdk => 'SDK';

  @override
  String get optionUsage => 'பயன்பாடு';

  @override
  String get optionInstallDate => 'நிறுவிய தேதி';

  @override
  String get optionSize => 'அளவு';

  @override
  String get optionSource => 'மூலம்';

  @override
  String get optionTech => 'தொழில்நுட்பம்';

  @override
  String get optionComponents => 'கூறுகள்';

  @override
  String get optionSplits => 'பிரிவுகள்';

  @override
  String get giveAStarOnGithub => 'Github-ல் நட்சத்திரம் கொடு';

  @override
  String get commonLoadingLabel => 'ஏற்றுகிறது...';

  @override
  String get appNotFound => 'செயலி கிடைக்கவில்லை';

  @override
  String get failedToLoadAppDetails => 'செயலி விவரங்களை ஏற்ற முடியவில்லை';

  @override
  String get commonErrorLabel => 'பிழை';

  @override
  String get commonGoBackLabel => 'திரும்பு';

  @override
  String get contributorsTitle => 'பங்களிப்பாளர்கள்';

  @override
  String get contributorsHeader => 'சமூக\nஆர்வலர்கள்';

  @override
  String get contributorsIntro =>
      'குறியீடு, யோசனைகள், ஆர்வத்தால் இந்த திட்டத்தை வடிவமைத்தவர்கள்.';

  @override
  String contributorsCount(int count) {
    return '$count பங்களிப்பாளர்(கள்)';
  }

  @override
  String get contributeBeFirst => 'முதல் பங்களிப்பாளராக இருங்கள்';

  @override
  String get contributeBeFirstExternal => 'முதல் வெளி பங்களிப்பாளராக ஆங்கள்';

  @override
  String contributeNth(int count) {
    return 'நீங்கள் $countவது பங்களிப்பாளராக இருக்கலாம்';
  }

  @override
  String get contributeNow => 'இப்போதே பங்களி';

  @override
  String get contributeSubtitle => 'app-ல் உங்கள் பெயரை இடம்பெறுங்கள்';

  @override
  String get contributorsEmptyTitle => 'இன்னும் பங்களிப்பாளர்கள் இல்லை';

  @override
  String get contributorsEmptySubtitle =>
      'முதலில் பங்களித்து இங்கே இடம்பெறுங்கள்!';

  @override
  String get contributorsErrorTitle => 'பங்களிப்பாளர்களை ஏற்ற முடியவில்லை';

  @override
  String get contributorsErrorSubtitle =>
      'பிறகு முயற்சிக்கவும் அல்லது GitHub repository-ஐ பார்க்கவும்.';

  @override
  String get viewOnGithub => 'GitHub-ல் பார்';

  @override
  String get sponsorsTitle => 'நிதியளிப்பாளர்கள்';

  @override
  String get sponsorsHeader => 'சமூக\nஆதரவாளர்கள்';

  @override
  String get sponsorsIntro =>
      'இந்த திட்டத்தை திறந்தும் முன்னோக்கியும் நகர்த்த உதவுபவர்கள்.';

  @override
  String sponsorsCount(int count) {
    return '$count பொது நிதியளிப்பாளர்(கள்)';
  }

  @override
  String get sponsorsBecome => 'GitHub-ல் நிதியளிப்பாளராக ஆங்கள்';

  @override
  String get sponsorsEmptyTitle => 'இன்னும் பொது நிதியளிப்பாளர்கள் இல்லை';

  @override
  String get sponsorsErrorTitle => 'இப்போது நிதியளிப்பாளர்களை ஏற்ற முடியவில்லை';

  @override
  String get sponsorsErrorSubtitle =>
      'சற்று நேரம் கழித்து முயற்சிக்கவும் அல்லது GitHub Sponsors பக்கத்தை திறக்கவும்.';

  @override
  String get sponsorsOpenGitHub => 'GitHub Sponsors திற';

  @override
  String get commonViewProfile => 'சுயவிவரம் பார்';

  @override
  String get noDataForPeriod => 'இந்த காலகட்டத்தில் தரவு இல்லை';

  @override
  String get usageOnThisDay => 'இந்த நாளில் பயன்பாடு';

  @override
  String get dailyAverage => 'தினசரி சராசரி';

  @override
  String get avgUsageWeek => 'சராசரி பயன்பாடு (வாரம்)';

  @override
  String pastRange(String range) {
    return 'கடந்த $range';
  }

  @override
  String get permissionRequiredTitle => 'அனுமதி தேவை';

  @override
  String topCountFilter(int count) {
    return 'முதல் $count செயலிகள்';
  }

  @override
  String topCount(int count) {
    return 'முதல் $count';
  }

  @override
  String commonErrorWithDetails(String error) {
    return 'பிழை: $error';
  }

  @override
  String get usageStatisticsTitle => 'பயன்பாட்டு புள்ளிவிவரங்கள்';

  @override
  String get noDataAvailable => 'தரவு எதுவும் இல்லை';

  @override
  String get tryDifferentDateRange => 'வேறு தேதி வரம்பை தேர்ந்தெடுக்கவும்';

  @override
  String get searchUsageStatsHint => 'பயன்பாட்டு புள்ளிவிவரங்கள் தேடு...';

  @override
  String get searchEmptyState => 'தேடலுக்கு பொருந்தும் செயலிகள் இல்லை';

  @override
  String trackingForPeriod(String periodText) {
    return '$periodText க்கான கண்காணிப்பு';
  }

  @override
  String daysStoredLocally(int count) {
    return '$count நாட்கள் உள்ளூரில் சேமிக்கப்பட்டது';
  }

  @override
  String get historicalDataCleared =>
      'சில பழைய தரவுகள் உங்கள் சாதனத்தால் அழிக்கப்பட்டன';

  @override
  String get topContributorsSection => 'முதன்மை பங்களிப்பாளர்கள்';

  @override
  String get searchResultsSection => 'தேடல் முடிவுகள்';

  @override
  String get shareLabel => 'பகிர்';

  @override
  String get shareAnalyticsViralText =>
      'Unfilter exposed my screen addiction 💀\n\nSee what apps are really made of. Real usage stats. No sugar coating.\n\n100% open source. No trackers. No BS.\n\nGet it: github.com/r4khul/unfilter/releases/latest\n\nDon\'t forget to give a star!\n';

  @override
  String get noStorageInfoAvailable => 'சேமிப்பக தகவல் இல்லை';

  @override
  String get storageInsightsTitle => 'சேமிப்பக நுண்ணறிவு';

  @override
  String get searchStorageHint => 'சேமிப்பகம் தேடு...';

  @override
  String get heaviestAppsSection => 'அதிக இடம் எடுக்கும் செயலிகள்';

  @override
  String get criticalUpdateRequired => 'அவசர புதுப்பிப்பு தேவை';

  @override
  String get criticalUpdateMessage =>
      'ஒரு முக்கியமான native புதுப்பிப்பு உள்ளது. பாதுகாப்பாக தொடர்ந்து பயன்படுத்த app-ஐ புதுப்பிக்க வேண்டும்.';

  @override
  String get currentVersionLabel => 'தற்போதைய பதிப்பு';

  @override
  String get requiredVersionLabel => 'தேவையான பதிப்பு';

  @override
  String get downloadUpdateAction => 'புதுப்பிப்பை பதிவிறக்கு';

  @override
  String get commonUnknownLabel => 'தெரியவில்லை';

  @override
  String get newUpdateAvailable => 'புதிய புதுப்பிப்பு கிடைக்கிறது';

  @override
  String newNativeVersionAvailable(String version) {
    return 'செயல்திறன் மேம்பாடுகளுடன் புதிய native பதிப்பு ($version) கிடைக்கிறது.';
  }

  @override
  String get updateNowAction => 'இப்போதே புதுப்பி';

  @override
  String get drawerMenu => 'மெனு';

  @override
  String get drawerSettingsInfo => 'அமைப்புகள் & தகவல்';

  @override
  String get drawerAppearance => 'தோற்றம்';

  @override
  String get drawerInsights => 'நுண்ணறிவுகள்';

  @override
  String get usageStatisticsSubtitle => 'உங்கள் டிஜிட்டல் நலப் பயன்பாடு காண்க';

  @override
  String get storageInsightsSubtitle => 'சேமிப்பகத்தின் விவரங்கள்';

  @override
  String get taskManagerSubtitle => 'கணினி வளங்களை கண்காணிக்கவும்';

  @override
  String get drawerTools => 'கருவிகள்';

  @override
  String get deeplinkTesterSubtitle => 'URI நடத்தை சோதிக்கவும்';

  @override
  String get drawerInformation => 'தகவல்';

  @override
  String get privacySecurityTitle => 'தனியுரிமை மற்றும் பாதுகாப்பு';

  @override
  String get privacySecuritySubtitle => 'ஆஃப்லைன் மற்றும் பாதுகாப்பானது';

  @override
  String get drawerAbout => 'பற்றி';

  @override
  String get checkingVersion => 'பதிப்பை சரிபார்க்கிறது...';

  @override
  String get versionUnknown => 'தெரியாத பதிப்பு';

  @override
  String get updateAvailableBadge => ' • புதுப்பிப்பு';

  @override
  String get reportIssue => 'பிழையை தெரிவி';

  @override
  String get drawerCommunity => 'சமூகம்';

  @override
  String get themeAuto => 'தானியங்கி';

  @override
  String get supportProject => 'திட்டத்தை ஆதரிக்கவும்';

  @override
  String get madeBy => 'உருவாக்கியவர் ';

  @override
  String get viewAllContributors => 'அனைத்து பங்களிப்பாளர்களையும் காணுங்கள்';
}

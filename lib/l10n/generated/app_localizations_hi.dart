// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get apps => 'ऐप्स';

  @override
  String get appTitle => 'अनफ़िल्टर';

  @override
  String get homeTitle => 'होम';

  @override
  String get chooseLanguageDialogTitle => 'भाषा चुनें';

  @override
  String get chooseLanguageDialogSubtitle => 'अपनी भाषा चुनें';

  @override
  String get languageEnglish => 'अंग्रेज़ी';

  @override
  String get languageGerman => 'जर्मन';

  @override
  String get languageTamil => 'तमिल';

  @override
  String get languageTurkish => 'तुर्की';

  @override
  String get confirmButtonLabel => 'पुष्टि करें';

  @override
  String get premiumAppBarResyncApp => 'पुनः सिंक करें';

  @override
  String get premiumAppBarShare => 'शेयर करें';

  @override
  String get premiumAppBarMenuTooltip => 'मेनू';

  @override
  String get commonOpenLabel => 'खोलें';

  @override
  String get commonViewLabel => 'देखें';

  @override
  String get commonClearLabel => 'साफ़ करें';

  @override
  String get commonPreviewLabel => 'पूर्वावलोकन';

  @override
  String get privacyPolicyTitle => 'गोपनीयता नीति';

  @override
  String get privacyTermsAndConditionsTitle => 'नियम और शर्तें';

  @override
  String get privacyHeader => 'आपका डेटा,\nआपका डिवाइस';

  @override
  String get privacyIntro =>
      'गोपनीयता उत्पाद का हिस्सा है, बाद का विचार नहीं। UnFilter ऑफलाइन चलता है ताकि आपकी जासूसी किए बिना उपयोगी रह सके।';

  @override
  String get privacySectionLocalProcessingTitle => 'स्थानीय प्रसंस्करण';

  @override
  String get privacySectionLocalProcessingContent =>
      'हर scan, हर मिलान, हर विश्लेषण आपके फ़ोन पर चलता है। हम आपके ऐप्स नहीं देख सकते - हमने इसे ऐसे ही बनाया है।';

  @override
  String get privacySectionMinimalPermissionsTitle => 'न्यूनतम अनुमतियाँ';

  @override
  String get privacySectionMinimalPermissionsContent =>
      'हम केवल दो चीज़ें माँगते हैं: इंस्टॉल किए गए ऐप्स देखने की अनुमति, और native लाइब्रेरी देखने के लिए स्टोरेज एक्सेस।';

  @override
  String get privacySectionNoTrackingTitle => 'कोई ट्रैकिंग नहीं';

  @override
  String get privacySectionNoTrackingContent =>
      'कोई analytics नहीं। कोई ad SDK नहीं। कोई crash reporter नहीं। आप ऐप में जो करते हैं वह आपके और आपके फ़ोन के बीच रहता है।';

  @override
  String get privacySectionLimitedNetworkingTitle => 'सीमित नेटवर्किंग';

  @override
  String get privacySectionLimitedNetworkingContent =>
      'हम केवल अपडेट जाँचने और GitHub star count लेने के लिए इंटरनेट से जुड़ते हैं। बस इतना ही।';

  @override
  String get howItWorksTitle => 'यह कैसे काम करता है';

  @override
  String get howItWorksHeader => 'ऐप\nसुराग';

  @override
  String get howItWorksIntro =>
      'कोई decompiling नहीं। कोई upload नहीं। बस स्मार्ट स्थानीय विश्लेषण।';

  @override
  String get howItWorksOpenSourceLabel => 'Open Source';

  @override
  String get howItWorksStep1Title => 'सुराग इकट्ठा करें';

  @override
  String get howItWorksStep1Description =>
      'हम हर ऐप की package info और native libraries देखते हैं। कोई upload नहीं, कोई account नहीं।';

  @override
  String get howItWorksStep2Title => 'संकेत मिलाएँ';

  @override
  String get howItWorksStep2Description =>
      'हम Flutter, React Native, Unity और अन्य framework fingerprints से तुलना करते हैं।';

  @override
  String get howItWorksStep3Title => 'स्थानीय रहें';

  @override
  String get howItWorksStep3Description =>
      'हर scan डिवाइस पर होता है। आपका ऐप डेटा कभी फ़ोन नहीं छोड़ता।';

  @override
  String get deeplinkTesterTitle => 'Deep Link परीक्षक';

  @override
  String get deeplinkInitialStatus => 'परीक्षण के लिए deeplink दर्ज करें।';

  @override
  String get deeplinkEnterSchemeError => 'कम से कम एक scheme दर्ज करें।';

  @override
  String get deeplinkInvalidError =>
      'अमान्य deeplink। एक वैध URI scheme शामिल करें।';

  @override
  String get deeplinkCanHandle =>
      'इस डिवाइस पर deep link को संभाला जा सकता है।';

  @override
  String get deeplinkNoHandler => 'कोई ऐप इस deep link को अभी नहीं संभाल सकता।';

  @override
  String get deeplinkLaunchedSuccess => 'Deep link सफलतापूर्वक लॉन्च हुआ।';

  @override
  String get deeplinkLaunchFailedRecognized =>
      'Deep link पहचाना गया लेकिन लॉन्च करने में विफल।';

  @override
  String get deeplinkLaunchFailed => 'Deep link लॉन्च करने में विफल।';

  @override
  String get deeplinkComponentsTitle => 'Deep Link घटक';

  @override
  String get deeplinkPasteFullUrlHint =>
      'यहाँ पूरा URL पेस्ट करें (जैसे, myapp://host/path)';

  @override
  String get deeplinkAutofillHint =>
      'फ़ील्ड स्वतः भरने के लिए ऊपर पूरा URL पेस्ट करें';

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
  String get deeplinkHintScheme => 'जैसे mailto, https';

  @override
  String get deeplinkHintHost => 'जैसे example.com';

  @override
  String get deeplinkHintPath => 'जैसे /profile';

  @override
  String get deeplinkHintQuery => 'जैसे id=123';

  @override
  String get deeplinkHintFragment => 'जैसे section1';

  @override
  String get deeplinkTestButton => 'Deeplink परीक्षण करें';

  @override
  String get deeplinkTryExamplesButton => 'उदाहरण आज़माएँ';

  @override
  String get deeplinkExamplesTitle => 'Deep Link उदाहरण';

  @override
  String get deeplinkExampleComposeEmail => 'ईमेल लिखें';

  @override
  String get deeplinkExamplePhoneCall => 'फ़ोन कॉल';

  @override
  String get deeplinkExampleSendSms => 'SMS भेजें';

  @override
  String get deeplinkMoreConfigsSoon => 'जल्द ही अधिक कॉन्फिगरेशन आएंगे!';

  @override
  String get deeplinkParsedEmpty => 'परीक्षण के बाद यहाँ URI विवरण दिखेगा।';

  @override
  String get deeplinkParsedDetailsTitle => 'विश्लेषित URI विवरण';

  @override
  String get homeStatsTitle => 'आपके डिवाइस में हैं';

  @override
  String homeStatsCountText(String count) {
    return '$count इंस्टॉल्ड ऐप्स';
  }

  @override
  String get permission => 'अनुमति';

  @override
  String get permissionDescription1 =>
      'UnFilter को आपके usage stats तक सुरक्षित पहुँच चाहिए ताकि यह आपकी मदद कर सके ';

  @override
  String get permissionDescription2 =>
      'ऐप्स किस चीज़ से बने हैं यह देखने में और analytics view को सक्षम करने में।\n\n';

  @override
  String get permissionDescription3 => 'आपका डेटा कभी डिवाइस नहीं छोड़ता।';

  @override
  String get grantAccess => 'पहुँच दें';

  @override
  String get maybeLater => 'शायद बाद में';

  @override
  String get noAppsFound => 'मानदंड से मेल खाने वाले कोई ऐप नहीं मिले';

  @override
  String get somethingWentWrongScanning => 'स्कैन के दौरान कुछ गलत हुआ।\n';

  @override
  String get taskManagerTitle => 'टास्क मैनेजर';

  @override
  String get failedToLoadProcesses => 'प्रक्रियाएँ लोड करने में विफल';

  @override
  String get retryLabel => 'पुनः प्रयास करें';

  @override
  String get kernelSystemSection => 'KERNEL / SYSTEM';

  @override
  String get noProcessesMatchSearch =>
      'कोई प्रक्रिया आपकी खोज से मेल नहीं खाती';

  @override
  String get noProcessDataAvailable => 'कोई प्रक्रिया डेटा उपलब्ध नहीं';

  @override
  String processDataIncompleteError(String error) {
    return 'प्रक्रिया डेटा अधूरा हो सकता है: $error';
  }

  @override
  String get scanFailedRetry =>
      'Scan ऐप्स प्राप्त करने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String scanError(String error) {
    return 'Scan त्रुटि: $error';
  }

  @override
  String get scanInitializing => 'प्रारंभ हो रहा है...';

  @override
  String get scanFailedTitle => 'Scan विफल';

  @override
  String get scanErrorInstruction =>
      'कृपया इस त्रुटि रिपोर्ट का screenshot लें और डेवलपर को भेजें:';

  @override
  String get errorReportCopied => 'त्रुटि रिपोर्ट clipboard में कॉपी हुई';

  @override
  String get copyErrorReport => 'त्रुटि रिपोर्ट कॉपी करें';

  @override
  String get closeLabel => 'बंद करें';

  @override
  String get customizeAndShare => 'कस्टमाइज़ और शेयर करें';

  @override
  String shareFailedError(String error) {
    return 'शेयर करने में विफल: $error';
  }

  @override
  String shareTextExposed(String appName) {
    return '$appName — UnFilter के ज़रिए ऐप विवरण';
  }

  @override
  String shareTextBuiltWith(String stack) {
    return 'बना है: $stack';
  }

  @override
  String shareTextVersion(String version) {
    return 'संस्करण: $version';
  }

  @override
  String shareTextSize(String size) {
    return 'आकार: $size';
  }

  @override
  String get shareTextMarketing1 => 'देखें आपके ऐप्स वास्तव में किससे बने हैं।';

  @override
  String get shareTextMarketing2 =>
      'github.com/r4khul/unfilter/releases/latest';

  @override
  String get shareTextMarketing3 => 'एक स्टार देना न भूलें!';

  @override
  String get shareImage => 'छवि शेयर करें';

  @override
  String get themeDark => 'डार्क';

  @override
  String get themeLight => 'लाइट';

  @override
  String get optionVersion => 'संस्करण';

  @override
  String get optionSdk => 'SDK';

  @override
  String get optionUsage => 'उपयोग';

  @override
  String get optionInstallDate => 'इंस्टॉल तिथि';

  @override
  String get optionSize => 'आकार';

  @override
  String get optionSource => 'स्रोत';

  @override
  String get optionTech => 'तकनीक';

  @override
  String get optionComponents => 'घटक';

  @override
  String get optionSplits => 'Splits';

  @override
  String get giveAStarOnGithub => 'Github पर स्टार दें';

  @override
  String get commonLoadingLabel => 'लोड हो रहा है...';

  @override
  String get appNotFound => 'ऐप नहीं मिला';

  @override
  String get failedToLoadAppDetails => 'ऐप विवरण लोड करने में विफल';

  @override
  String get commonErrorLabel => 'त्रुटि';

  @override
  String get commonGoBackLabel => 'वापस जाएँ';

  @override
  String get contributorsTitle => 'योगदानकर्ता';

  @override
  String get contributorsHeader => 'समुदाय\nनिर्माता';

  @override
  String get contributorsIntro =>
      'वे लोग जिन्होंने कोड, विचार और ऊर्जा से इस परियोजना को आकार दिया।';

  @override
  String contributorsCount(int count) {
    return '$count योगदानकर्ता';
  }

  @override
  String get contributeBeFirst => 'पहले योगदानकर्ता बनें';

  @override
  String get contributeBeFirstExternal => 'पहले बाहरी योगदानकर्ता बनें';

  @override
  String contributeNth(int count) {
    return 'आप $countवें योगदानकर्ता हो सकते हैं';
  }

  @override
  String get contributeNow => 'अभी योगदान करें';

  @override
  String get contributeSubtitle => 'ऐप में अपना नाम डालें';

  @override
  String get contributorsEmptyTitle => 'अभी तक कोई योगदानकर्ता नहीं';

  @override
  String get contributorsEmptySubtitle => 'पहले योगदान करें और यहाँ फीचर हों!';

  @override
  String get contributorsErrorTitle => 'योगदानकर्ता लोड नहीं हो सके';

  @override
  String get contributorsErrorSubtitle =>
      'बाद में पुनः प्रयास करें या GitHub repository देखें।';

  @override
  String get viewOnGithub => 'GitHub पर देखें';

  @override
  String get sponsorsTitle => 'प्रायोजक';

  @override
  String get sponsorsHeader => 'समुदाय\nसमर्थक';

  @override
  String get sponsorsIntro =>
      'वे लोग जो इस परियोजना को खुला और आगे बढ़ाने में मदद करते हैं।';

  @override
  String sponsorsCount(int count) {
    return '$count सार्वजनिक प्रायोजक';
  }

  @override
  String get sponsorsBecome => 'GitHub पर प्रायोजक बनें';

  @override
  String get sponsorsEmptyTitle => 'अभी तक कोई सार्वजनिक प्रायोजक नहीं';

  @override
  String get sponsorsErrorTitle => 'प्रायोजक अभी लोड नहीं हो सके';

  @override
  String get sponsorsErrorSubtitle =>
      'थोड़ी देर बाद पुनः प्रयास करें या GitHub Sponsors खोलें।';

  @override
  String get sponsorsOpenGitHub => 'GitHub Sponsors खोलें';

  @override
  String get commonViewProfile => 'प्रोफ़ाइल देखें';

  @override
  String get noDataForPeriod => 'इस अवधि के लिए कोई डेटा नहीं';

  @override
  String get usageOnThisDay => 'इस दिन का उपयोग';

  @override
  String get dailyAverage => 'दैनिक औसत';

  @override
  String get avgUsageWeek => 'औसत उपयोग (सप्ताह)';

  @override
  String pastRange(String range) {
    return 'पिछले $range';
  }

  @override
  String get permissionRequiredTitle => 'अनुमति आवश्यक';

  @override
  String topCountFilter(int count) {
    return 'शीर्ष $count ऐप्स';
  }

  @override
  String topCount(int count) {
    return 'शीर्ष $count';
  }

  @override
  String commonErrorWithDetails(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get usageStatisticsTitle => 'उपयोग आँकड़े';

  @override
  String get noDataAvailable => 'कोई डेटा उपलब्ध नहीं';

  @override
  String get tryDifferentDateRange => 'कोई अलग तिथि सीमा चुनें';

  @override
  String get searchUsageStatsHint => 'उपयोग आँकड़े खोजें...';

  @override
  String get searchEmptyState => 'आपकी खोज से कोई ऐप मेल नहीं खाता';

  @override
  String trackingForPeriod(String periodText) {
    return '$periodText के लिए ट्रैक हो रहा है';
  }

  @override
  String daysStoredLocally(int count) {
    return '$count दिन स्थानीय रूप से संग्रहीत';
  }

  @override
  String get historicalDataCleared =>
      'आपके डिवाइस ने कुछ ऐतिहासिक डेटा साफ़ कर दिया';

  @override
  String get topContributorsSection => 'शीर्ष योगदानकर्ता';

  @override
  String get searchResultsSection => 'खोज परिणाम';

  @override
  String get shareLabel => 'शेयर करें';

  @override
  String get shareAnalyticsViralText =>
      'Unfilter ने मेरी स्क्रीन की लत उजागर कर दी\n\nदेखें ऐप्स वास्तव में किससे बने हैं। असली usage stats।\n\n100% open source. कोई tracker नहीं।\n\nपाएँ: github.com/r4khul/unfilter/releases/latest\n\nस्टार देना न भूलें!\n';

  @override
  String get noStorageInfoAvailable => 'कोई स्टोरेज जानकारी उपलब्ध नहीं';

  @override
  String get storageInsightsTitle => 'स्टोरेज अंतर्दृष्टि';

  @override
  String get searchStorageHint => 'स्टोरेज खोजें...';

  @override
  String get heaviestAppsSection => 'सबसे भारी ऐप्स';

  @override
  String get criticalUpdateRequired => 'महत्वपूर्ण अपडेट आवश्यक';

  @override
  String get criticalUpdateMessage =>
      'एक महत्वपूर्ण native अपडेट उपलब्ध है। सुरक्षित उपयोग जारी रखने के लिए ऐप अपडेट करें।';

  @override
  String get currentVersionLabel => 'वर्तमान संस्करण';

  @override
  String get requiredVersionLabel => 'आवश्यक संस्करण';

  @override
  String get downloadUpdateAction => 'अपडेट डाउनलोड करें';

  @override
  String get commonUnknownLabel => 'अज्ञात';

  @override
  String get newUpdateAvailable => 'नया अपडेट उपलब्ध';

  @override
  String newNativeVersionAvailable(String version) {
    return 'प्रदर्शन सुधार के साथ नया native संस्करण ($version) उपलब्ध है।';
  }

  @override
  String get updateNowAction => 'अभी अपडेट करें';

  @override
  String get drawerMenu => 'मेनू';

  @override
  String get drawerSettingsInfo => 'सेटिंग्स और जानकारी';

  @override
  String get drawerAppearance => 'दिखावट';

  @override
  String get drawerInsights => 'अंतर्दृष्टि';

  @override
  String get usageStatisticsSubtitle => 'अपनी डिजिटल सेहत देखें';

  @override
  String get storageInsightsSubtitle => 'बिना फ़िल्टर स्थान विवरण';

  @override
  String get taskManagerSubtitle => 'सिस्टम संसाधन मॉनिटर करें';

  @override
  String get sensorDiagnosticsTitle => 'सेंसर डायग्नोस्टिक्स';

  @override
  String get sensorDiagnosticsSubtitle => 'रियल-टाइम सेंसर स्ट्रीम्स';

  @override
  String get drawerTools => 'उपकरण';

  @override
  String get deeplinkTesterSubtitle => 'URI व्यवहार परीक्षण और निरीक्षण करें';

  @override
  String get drawerInformation => 'जानकारी';

  @override
  String get privacySecurityTitle => 'गोपनीयता और सुरक्षा';

  @override
  String get privacySecuritySubtitle => 'ऑफलाइन और सुरक्षित';

  @override
  String get drawerAbout => 'के बारे में';

  @override
  String get checkingVersion => 'संस्करण जाँचा जा रहा है...';

  @override
  String get versionUnknown => 'संस्करण अज्ञात';

  @override
  String get updateAvailableBadge => ' • अपडेट';

  @override
  String get reportIssue => 'समस्या रिपोर्ट करें';

  @override
  String get rateApp => 'ऐप रेट करें';

  @override
  String get reportBug => 'Bug रिपोर्ट करें';

  @override
  String get reportBugSubtitle => 'कोई गड़बड़ी मिली? GitHub पर बताएँ';

  @override
  String get viewLogs => 'लॉग देखें';

  @override
  String get viewLogsSubtitle => 'सिस्टम और ऐप events देखें';

  @override
  String get exportLogs => 'लॉग एक्सपोर्ट करें';

  @override
  String get exportLogsSubtitle => 'लॉग ZIP आर्काइव के रूप में सहेजें';

  @override
  String get logsTitle => 'ऐप लॉग';

  @override
  String get shareLogs => 'लॉग शेयर करें';

  @override
  String get crashRecoveryTitle => 'ऐप स्टार्टअप विफल';

  @override
  String get crashRecoverySubtitle =>
      'स्टार्टअप के दौरान एक गंभीर त्रुटि आई। आप लॉग देख सकते हैं या रिपोर्ट कर सकते हैं।';

  @override
  String get restartApp => 'ऐप पुनः प्रारंभ करें';

  @override
  String get drawerCommunity => 'समुदाय';

  @override
  String get themeAuto => 'स्वचालित';

  @override
  String get supportProject => 'परियोजना को समर्थन दें';

  @override
  String get madeBy => 'बनाया ';

  @override
  String get viewAllContributors => 'सभी योगदानकर्ता देखें';

  @override
  String get languageSearchHint => 'भाषा खोजें...';

  @override
  String get noLanguagesFound => 'कोई भाषा नहीं मिली';

  @override
  String get selectLanguageSection => 'भाषा चुनें';

  @override
  String get deepInsightsTitle => 'गहरी अंतर्दृष्टि';

  @override
  String get installerLabel => 'Installer';

  @override
  String get kotlinVersionLabel => 'Kotlin संस्करण';

  @override
  String get minSdkLabel => 'Min SDK';

  @override
  String get targetSdkLabel => 'Target SDK';

  @override
  String get signatureSha1Label => 'हस्ताक्षर (SHA-1)';

  @override
  String get splitApksLabel => 'Split APK';

  @override
  String get appSizeLabel => 'ऐप का आकार';

  @override
  String get apkPathLabel => 'APK Path';

  @override
  String get dataDirLabel => 'डेटा निर्देशिका';

  @override
  String get activitiesLabel => 'Activity';

  @override
  String get servicesLabel => 'Service';

  @override
  String get receiversLabel => 'Receiver';

  @override
  String get providersLabel => 'Provider';

  @override
  String techVersionLabel(String tech) {
    return '$tech संस्करण';
  }

  @override
  String splitApksValue(int count) {
    return '$count splits';
  }

  @override
  String aboutFramework(String name) {
    return '$name के बारे में';
  }

  @override
  String get viewOfficialDocs => 'आधिकारिक दस्तावेज़ देखें';

  @override
  String get shareAppDetails => 'ऐप विवरण शेयर करें';

  @override
  String get filteredSizeLabel => 'फ़िल्टर्ड आकार';

  @override
  String get totalConsumedLabel => 'कुल उपयोग';

  @override
  String get appCodeLabel => 'ऐप कोड';

  @override
  String get userDataLabel => 'उपयोगकर्ता डेटा';

  @override
  String get cacheLabel => 'Cache';

  @override
  String get appDetailsTitle => 'ऐप विवरण';

  @override
  String get loadingAppDetails => 'ऐप विवरण लोड हो रहा है...';

  @override
  String get appDataRefreshed => 'ऐप डेटा रिफ्रेश हुआ';

  @override
  String get failedToResync => 'पुनः सिंक करने में विफल';

  @override
  String get installDateLabel => 'इंस्टॉल तिथि';

  @override
  String get detectedPackagesTitle => 'पता लगाए गए पैकेज';

  @override
  String get packageLabel => 'पैकेज';

  @override
  String get uidLabel => 'UID';

  @override
  String get nativeLibrariesLabel => 'Native लाइब्रेरी';

  @override
  String get permissionsLabel => 'अनुमतियाँ';

  @override
  String get updatedLabel => 'अपडेट हुआ';

  @override
  String viewMoreLabel(int count) {
    return '$count और देखें';
  }

  @override
  String get activityLabel => 'Activity';

  @override
  String activityUsageSince(String duration, String date, int days) {
    return '$date को इंस्टॉल के बाद से $duration उपयोग हुआ ($days दिन पहले)';
  }

  @override
  String get activityNoChartData =>
      'चार्ट बनाने के लिए पर्याप्त डेटा नहीं मिला';

  @override
  String get activityNoRecentActivity => 'कोई हालिया Activity नहीं';

  @override
  String get activityNoUsageLastYear => 'पिछले वर्ष कोई उपयोग दर्ज नहीं';

  @override
  String get activityUnableToLoad => 'Activity लोड नहीं हो सकी';

  @override
  String routeNotFound(String name) {
    return 'रूट नहीं मिला: $name';
  }

  @override
  String get searchInstalledApps => 'स्थापित ऐप्स खोजें...';

  @override
  String get searchApps => 'ऐप्स खोजें...';

  @override
  String get scan => 'स्कैन';

  @override
  String get scanOptions => 'स्कैन विकल्प';

  @override
  String get scanOptionsSubtitle =>
      'चुनें कि आप अपने ऐप की जानकारी को कैसे रीफ्रेश करना चाहते हैं।';

  @override
  String get fullSystemScan => 'पूर्ण सिस्टम स्कैन';

  @override
  String get fullSystemScanSubtitle => 'गहन विश्लेषण और ऐप फ़िंगरप्रिंटिंग';

  @override
  String get smartRevalidate => 'स्मार्ट सत्यापन';

  @override
  String get smartRevalidateSubtitle => 'ऐप परिवर्तनों की त्वरित जांच करें';

  @override
  String get checkingUpdates => 'अपडेट की जांच की जा रही है';

  @override
  String get githubCtaTitle => 'विस्तृत जानकारी के लिए';

  @override
  String get githubCtaSubtitle => 'GitHub पर सोर्स कोड देखें';

  @override
  String get reportIssueSubtitle =>
      'चुनें कि आप किसी समस्या की रिपोर्ट या जांच कैसे करना चाहते हैं।';

  @override
  String get smartScanHintTitle => 'नया ऐप?';

  @override
  String get smartScanHintSubtitle => 'अपडेट के लिए स्मार्ट स्कैन करें';

  @override
  String get processSandboxedMessage =>
      'कर्नेल-स्तर की प्रक्रिया निगरानी एंड्रॉइड ओएस सैंडबॉक्सिंग (SELinux) द्वारा सुरक्षित है। नीचे केवल उपयोगकर्ता-स्पेस एप्लिकेशन सुलभ हैं।';
}

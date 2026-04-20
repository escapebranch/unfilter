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
}

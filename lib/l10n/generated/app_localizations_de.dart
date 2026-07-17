// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get apps => 'Apps';

  @override
  String get appTitle => 'UnFilter';

  @override
  String get homeTitle => 'Startseite';

  @override
  String get chooseLanguageDialogTitle => 'Sprache wählen';

  @override
  String get chooseLanguageDialogSubtitle => 'Wählen Sie Ihre Sprache';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get languageTamil => 'Tamilisch';

  @override
  String get languageTurkish => 'Türkisch';

  @override
  String get confirmButtonLabel => 'Bestätigen';

  @override
  String get premiumAppBarResyncApp => 'App neu synchronisieren';

  @override
  String get premiumAppBarShare => 'Teilen';

  @override
  String get premiumAppBarMenuTooltip => 'Menü';

  @override
  String get commonOpenLabel => 'Öffnen';

  @override
  String get commonViewLabel => 'Ansehen';

  @override
  String get commonClearLabel => 'Löschen';

  @override
  String get commonPreviewLabel => 'Vorschau';

  @override
  String get privacyPolicyTitle => 'Datenschutzerklärung';

  @override
  String get privacyTermsAndConditionsTitle =>
      'Allgemeine Geschäftsbedingungen';

  @override
  String get privacyHeader => 'Ihre Daten,\nIhr Gerät';

  @override
  String get privacyIntro =>
      'Datenschutz ist Teil des Produkts, kein nachträglicher Gedanke. UnFilter läuft offline, damit es nützlich bleibt, ohne neugierig zu werden.';

  @override
  String get privacySectionLocalProcessingTitle => 'Lokale Verarbeitung';

  @override
  String get privacySectionLocalProcessingContent =>
      'Jeder Scan, jeder Treffer, jede Analyse läuft direkt auf Ihrem Telefon. Wir könnten nicht in Ihre Apps schauen, selbst wenn wir wollten – wir haben es so gebaut.';

  @override
  String get privacySectionMinimalPermissionsTitle => 'Minimale Berechtigungen';

  @override
  String get privacySectionMinimalPermissionsContent =>
      'Wir verlangen genau zwei Dinge: die Berechtigung zu sehen, welche Apps installiert sind, und Speicherzugriff, um native Bibliotheken zu durchsuchen. Das ist alles.';

  @override
  String get privacySectionNoTrackingTitle => 'Kein Tracking';

  @override
  String get privacySectionNoTrackingContent =>
      'Keine Analysen. Keine Werbe-SDKs. Keine Absturzberichte, die nach Hause telefonieren. Was Sie innerhalb der App tun, bleibt zwischen Ihnen und Ihrem Telefon.';

  @override
  String get privacySectionLimitedNetworkingTitle =>
      'Eingeschränkte Netzwerknutzung';

  @override
  String get privacySectionLimitedNetworkingContent =>
      'Wir greifen nur dann auf das Internet zu, um nach Updates zu suchen und die Anzahl der GitHub-Sterne abzurufen. Das ist alles – nichts über Sie verlässt diese App.';

  @override
  String get howItWorksTitle => 'Wie es funktioniert';

  @override
  String get howItWorksHeader => 'App-Hinweise';

  @override
  String get howItWorksIntro =>
      'Kein Dekompilieren. Keine Uploads. Nur intelligente lokale Analyse, die liest, was bereits vorhanden ist, und Ihnen sagt, wororaus eine App besteht.';

  @override
  String get howItWorksOpenSourceLabel => 'Open Source';

  @override
  String get howItWorksStep1Title => 'Hinweise sammeln';

  @override
  String get howItWorksStep1Description =>
      'Wir werfen einen Blick auf die Paketinformationen und nativen Bibliotheken jeder App, die sich bereits auf Ihrem Telefon befinden. Keine Uploads, kein Konto, kein Drama.';

  @override
  String get howItWorksStep2Title => 'Signale abgleichen';

  @override
  String get howItWorksStep2Description =>
      'Wir vergleichen diese Hinweise mit lokalen Framework-Fingerabdrücken, um Flutter, React Native, Unity und den Rest der üblichen Verdächtigen zu erkennen.';

  @override
  String get howItWorksStep3Title => 'Lokal bleiben';

  @override
  String get howItWorksStep3Description =>
      'Jeder Scan findet auf dem Gerät statt. Der Spaß bleibt privat und Ihre App-Daten verlassen niemals Ihr Telefon.';

  @override
  String get deeplinkTesterTitle => 'Deep-Link-Tester';

  @override
  String get deeplinkInitialStatus =>
      'Geben Sie einen Deep-Link ein, um ihn zu testen.';

  @override
  String get deeplinkEnterSchemeError =>
      'Bitte geben Sie mindestens ein Schema ein.';

  @override
  String get deeplinkInvalidError =>
      'Ungültiger Deep-Link. Geben Sie ein gültiges URI-Schema an.';

  @override
  String get deeplinkCanHandle =>
      'Deep-Link kann auf diesem Gerät verarbeitet werden.';

  @override
  String get deeplinkNoHandler =>
      'Derzeit kann keine App diesen Deep-Link verarbeiten.';

  @override
  String get deeplinkLaunchedSuccess => 'Deep-Link erfolgreich gestartet.';

  @override
  String get deeplinkLaunchFailedRecognized =>
      'Deep-Link wurde erkannt, konnte aber nicht gestartet werden.';

  @override
  String get deeplinkLaunchFailed => 'Deep-Link konnte nicht gestartet werden.';

  @override
  String get deeplinkComponentsTitle => 'Deep-Link-Komponenten';

  @override
  String get deeplinkPasteFullUrlHint =>
      'Ganze URL hier einfügen (z. B. myapp://host/path)';

  @override
  String get deeplinkAutofillHint =>
      'Ganze URL oben einfügen, um Felder automatisch auszufüllen';

  @override
  String get deeplinkLabelScheme => 'Schema';

  @override
  String get deeplinkLabelHost => 'Host';

  @override
  String get deeplinkLabelPath => 'Pfad';

  @override
  String get deeplinkLabelQuery => 'Query';

  @override
  String get deeplinkLabelFragment => 'Fragment';

  @override
  String get deeplinkHintScheme => 'z. B. mailto, https';

  @override
  String get deeplinkHintHost => 'z. B. example.com';

  @override
  String get deeplinkHintPath => 'z. B. /profile';

  @override
  String get deeplinkHintQuery => 'z. B. id=123';

  @override
  String get deeplinkHintFragment => 'z. B. section1';

  @override
  String get deeplinkTestButton => 'Deep-Link testen';

  @override
  String get deeplinkTryExamplesButton => 'Beispiele ausprobieren';

  @override
  String get deeplinkExamplesTitle => 'Deep-Link-Beispiele';

  @override
  String get deeplinkExampleComposeEmail => 'E-Mail verfassen';

  @override
  String get deeplinkExamplePhoneCall => 'Anruf';

  @override
  String get deeplinkExampleSendSms => 'SMS senden';

  @override
  String get deeplinkMoreConfigsSoon =>
      'Weitere Konfigurationen folgen in Kürze!';

  @override
  String get deeplinkParsedEmpty =>
      'Die URI-Aufschlüsselung wird hier nach dem Testen angezeigt.';

  @override
  String get deeplinkParsedDetailsTitle => 'Analysierte URI-Details';

  @override
  String get homeStatsTitle => 'Ihr Gerät hat';

  @override
  String homeStatsCountText(String count) {
    return '$count installierte Apps';
  }

  @override
  String get permission => 'Berechtigung';

  @override
  String get permissionDescription1 =>
      'UnFilter benötigt sicheren Zugriff auf Ihre Nutzungsstatistiken, um Ihnen zu helfen, ';

  @override
  String get permissionDescription2 =>
      'zu erkennen, wororaus Apps bestehen und die Analyseansicht zu aktivieren.\n\n';

  @override
  String get permissionDescription3 =>
      'Ihre Daten verlassen niemals Ihr Gerät.';

  @override
  String get grantAccess => 'Zugriff gewähren';

  @override
  String get maybeLater => 'Vielleicht später';

  @override
  String get noAppsFound =>
      'Keine Apps gefunden, die den Kriterien entsprechen';

  @override
  String get somethingWentWrongScanning =>
      'Beim Scannen ist ein Fehler aufgetreten.\n';

  @override
  String get taskManagerTitle => 'Task-Manager';

  @override
  String get failedToLoadProcesses => 'Prozesse konnten nicht geladen werden';

  @override
  String get retryLabel => 'Wiederholen';

  @override
  String get kernelSystemSection => 'KERNEL / SYSTEM';

  @override
  String get noProcessesMatchSearch => 'Keine Prozesse entsprechen Ihrer Suche';

  @override
  String get noProcessDataAvailable => 'Keine Prozessdaten verfügbar';

  @override
  String processDataIncompleteError(String error) {
    return 'Prozessdaten sind möglicherweise unvollständig: $error';
  }

  @override
  String get scanFailedRetry =>
      'Scan konnte keine Apps abrufen. Bitte versuchen Sie es erneut.';

  @override
  String scanError(String error) {
    return 'Scan-Fehler: $error';
  }

  @override
  String get scanInitializing => 'Initialisierung...';

  @override
  String get scanFailedTitle => 'Scan fehlgeschlagen';

  @override
  String get scanErrorInstruction =>
      'Bitte machen Sie einen Screenshot dieses Fehlerberichts und senden Sie ihn an den Entwickler:';

  @override
  String get errorReportCopied => 'Fehlerbericht in die Zwischenablage kopiert';

  @override
  String get copyErrorReport => 'Fehlerbericht kopieren';

  @override
  String get closeLabel => 'Schließen';

  @override
  String get customizeAndShare => 'Anpassen & Teilen';

  @override
  String shareFailedError(String error) {
    return 'Teilen fehlgeschlagen: $error';
  }

  @override
  String shareTextExposed(String appName) {
    return '$appName — App-Details über UnFilter';
  }

  @override
  String shareTextBuiltWith(String stack) {
    return 'Erstellt mit: $stack';
  }

  @override
  String shareTextVersion(String version) {
    return 'Version: $version';
  }

  @override
  String shareTextSize(String size) {
    return 'Größe: $size';
  }

  @override
  String get shareTextMarketing1 =>
      'Sehen Sie, wororaus Ihre Apps wirklich bestehen.';

  @override
  String get shareTextMarketing2 =>
      'github.com/r4khul/unfilter/releases/latest';

  @override
  String get shareTextMarketing3 =>
      'Vergessen Sie nicht, einen Stern zu vergeben!';

  @override
  String get shareImage => 'Bild teilen';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeLight => 'Hell';

  @override
  String get optionVersion => 'Version';

  @override
  String get optionSdk => 'SDK';

  @override
  String get optionUsage => 'Nutzung';

  @override
  String get optionInstallDate => 'Installationsdatum';

  @override
  String get optionSize => 'Größe';

  @override
  String get optionSource => 'Quelle';

  @override
  String get optionTech => 'Technologie';

  @override
  String get optionComponents => 'Komponenten';

  @override
  String get optionSplits => 'Splits';

  @override
  String get giveAStarOnGithub => 'Auf GitHub einen Stern geben';

  @override
  String get commonLoadingLabel => 'Laden...';

  @override
  String get appNotFound => 'App nicht gefunden';

  @override
  String get failedToLoadAppDetails =>
      'App-Details konnten nicht geladen werden';

  @override
  String get commonErrorLabel => 'Fehler';

  @override
  String get commonGoBackLabel => 'Zurückgehen';

  @override
  String get contributorsTitle => 'Mitwirkende';

  @override
  String get contributorsHeader => 'Community-Entwickler';

  @override
  String get contributorsIntro =>
      'Die Menschen, die dieses Projekt mit Code, Ideen und Energie geprägt haben.';

  @override
  String contributorsCount(int count) {
    return '$count Mitwirkende(r)';
  }

  @override
  String get contributeBeFirst => 'Seien Sie der erste Mitwirkende';

  @override
  String get contributeBeFirstExternal =>
      'Werden Sie der 1. externe Mitwirkende';

  @override
  String contributeNth(int count) {
    return 'Sie können der $count. Mitwirkende sein';
  }

  @override
  String get contributeNow => 'Jetzt mitwirken';

  @override
  String get contributeSubtitle => 'Bringen Sie Ihren Namen in die App';

  @override
  String get contributorsEmptyTitle => 'Noch keine Mitwirkenden';

  @override
  String get contributorsEmptySubtitle =>
      'Seien Sie der Erste, der beiträgt und hier vorgestellt wird!';

  @override
  String get contributorsErrorTitle =>
      'Mitwirkende konnten nicht geladen werden';

  @override
  String get contributorsErrorSubtitle =>
      'Bitte versuchen Sie es später noch einmal oder besuchen Sie das GitHub-Repository.';

  @override
  String get viewOnGithub => 'Auf GitHub ansehen';

  @override
  String get sponsorsTitle => 'Sponsoren';

  @override
  String get sponsorsHeader => 'Community-Unterstützer';

  @override
  String get sponsorsIntro =>
      'Die Menschen, die helfen, dieses Projekt offen zu halten und voranzubringen.';

  @override
  String sponsorsCount(int count) {
    return '$count öffentliche(r) Sponsor(en)';
  }

  @override
  String get sponsorsBecome => 'Sponsor auf GitHub werden';

  @override
  String get sponsorsEmptyTitle => 'Noch keine öffentlichen Sponsoren';

  @override
  String get sponsorsErrorTitle =>
      'Sponsoren konnten derzeit nicht geladen werden';

  @override
  String get sponsorsErrorSubtitle =>
      'Bitte versuchen Sie es gleich noch einmal oder öffnen Sie die GitHub Sponsors-Seite.';

  @override
  String get sponsorsOpenGitHub => 'GitHub Sponsors öffnen';

  @override
  String get commonViewProfile => 'Profil ansehen';

  @override
  String get noDataForPeriod => 'Keine Daten für den Zeitraum';

  @override
  String get usageOnThisDay => 'Nutzung an diesem Tag';

  @override
  String get dailyAverage => 'Täglicher Durchschnitt';

  @override
  String get avgUsageWeek => 'Durchschnittliche Nutzung (Woche)';

  @override
  String pastRange(String range) {
    return 'Letzte $range';
  }

  @override
  String get permissionRequiredTitle => 'Berechtigung erforderlich';

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
    return 'Fehler: $error';
  }

  @override
  String get usageStatisticsTitle => 'Nutzungsstatistiken';

  @override
  String get noDataAvailable => 'Keine Daten verfügbar';

  @override
  String get tryDifferentDateRange => 'Wählen Sie einen anderen Datumsbereich';

  @override
  String get searchUsageStatsHint => 'Nutzungsstatistiken durchsuchen...';

  @override
  String get searchEmptyState => 'Keine Apps entsprechen Ihrer Suche';

  @override
  String trackingForPeriod(String periodText) {
    return 'Verfolgung für $periodText';
  }

  @override
  String daysStoredLocally(int count) {
    return '$count Tage lokal gespeichert';
  }

  @override
  String get historicalDataCleared =>
      'Einige historische Daten wurden von Ihrem Gerät gelöscht';

  @override
  String get topContributorsSection => 'TOP-MITWIRKENDE';

  @override
  String get searchResultsSection => 'SUCHERGEBNISSE';

  @override
  String get shareLabel => 'Teilen';

  @override
  String get shareAnalyticsViralText =>
      'Unfilter hat meine Bildschirmsucht aufgedeckt 💀\n\nSehen Sie, wororaus Apps wirklich bestehen. Echte Nutzungsstatistiken. Kein Schönreden.\n\n100 % Open Source. Keine Tracker. Kein BS.\n\nHolen Sie es sich: github.com/r4khul/unfilter/releases/latest\n\nVergessen Sie nicht, einen Stern zu vergeben!\n';

  @override
  String get noStorageInfoAvailable => 'Keine Speicherinformationen verfügbar';

  @override
  String get storageInsightsTitle => 'Speicher-Einblicke';

  @override
  String get searchStorageHint => 'Speicher durchsuchen...';

  @override
  String get heaviestAppsSection => 'SCHWERSTE APPS';

  @override
  String get criticalUpdateRequired => 'Kritisches Update erforderlich';

  @override
  String get criticalUpdateMessage =>
      'Ein kritisches natives Update ist verfügbar. Sie müssen die App aktualisieren, um sie weiterhin sicher nutzen zu können.';

  @override
  String get currentVersionLabel => 'Aktuelle Version';

  @override
  String get requiredVersionLabel => 'Erforderliche Version';

  @override
  String get downloadUpdateAction => 'Update herunterladen';

  @override
  String get commonUnknownLabel => 'Unbekannt';

  @override
  String get newUpdateAvailable => 'Neues Update verfügbar';

  @override
  String newNativeVersionAvailable(String version) {
    return 'Eine neue native Version ($version) ist mit Leistungsverbesserungen verfügbar.';
  }

  @override
  String get updateNowAction => 'Jetzt aktualisieren';

  @override
  String get drawerMenu => 'Menü';

  @override
  String get drawerSettingsInfo => 'Einstellungen & Info';

  @override
  String get drawerAppearance => 'ERSCHEINUNGSBILD';

  @override
  String get drawerInsights => 'EINBLICKE';

  @override
  String get usageStatisticsSubtitle =>
      'Sehen Sie sich Ihr digitales Wohlbefinden an';

  @override
  String get storageInsightsSubtitle =>
      'Ungefilterte Speicherplatzaufschlüsselung';

  @override
  String get taskManagerSubtitle => 'Systemressourcen überwachen';

  @override
  String get sensorDiagnosticsTitle => 'Sensor-Diagnose';

  @override
  String get sensorDiagnosticsSubtitle => 'Echtzeit-Sensor-Streams';

  @override
  String get drawerTools => 'WERKZEUGE';

  @override
  String get deeplinkTesterSubtitle => 'URI-Verhalten testen und überprüfen';

  @override
  String get drawerInformation => 'INFORMATIONEN';

  @override
  String get privacySecurityTitle => 'Datenschutz & Sicherheit';

  @override
  String get privacySecuritySubtitle => 'Offline und sicher';

  @override
  String get drawerAbout => 'Über';

  @override
  String get checkingVersion => 'Version wird überprüft...';

  @override
  String get versionUnknown => 'Version unbekannt';

  @override
  String get updateAvailableBadge => ' • Update';

  @override
  String get reportIssue => 'Problem melden';

  @override
  String get rateApp => 'App bewerten';

  @override
  String get reportBug => 'Fehler melden';

  @override
  String get reportBugSubtitle =>
      'Einen Fehler gefunden? Lassen Sie es uns auf GitHub wissen';

  @override
  String get viewLogs => 'Logs anzeigen';

  @override
  String get viewLogsSubtitle => 'System- & App-Ereignisse überprüfen';

  @override
  String get exportLogs => 'Logs exportieren';

  @override
  String get exportLogsSubtitle => 'Logs als ZIP-Archiv speichern';

  @override
  String get logsTitle => 'App-Logs';

  @override
  String get shareLogs => 'Logs teilen';

  @override
  String get crashRecoveryTitle => 'App-Start fehlgeschlagen';

  @override
  String get crashRecoverySubtitle =>
      'Beim Start ist ein kritischer Fehler aufgetreten. Sie können die Logs einsehen oder den Fehler melden, um uns bei der Verbesserung zu helfen.';

  @override
  String get restartApp => 'App neu starten';

  @override
  String get drawerCommunity => 'COMMUNITY';

  @override
  String get themeAuto => 'Automatisch';

  @override
  String get supportProject => 'Projekt unterstützen';

  @override
  String get madeBy => 'Erstellt von ';

  @override
  String get viewAllContributors => 'Alle Mitwirkenden anzeigen';

  @override
  String get languageSearchHint => 'Sprache suchen...';

  @override
  String get noLanguagesFound => 'Keine Sprachen gefunden';

  @override
  String get selectLanguageSection => 'SPRACHE WÄHLEN';

  @override
  String get deepInsightsTitle => 'Tiefe Einblicke';

  @override
  String get installerLabel => 'Installer';

  @override
  String get kotlinVersionLabel => 'Kotlin-Version';

  @override
  String get minSdkLabel => 'Min. SDK';

  @override
  String get targetSdkLabel => 'Ziel-SDK';

  @override
  String get signatureSha1Label => 'Signatur (SHA-1)';

  @override
  String get splitApksLabel => 'Geteilte APKs';

  @override
  String get appSizeLabel => 'App-Größe';

  @override
  String get apkPathLabel => 'APK-Pfad';

  @override
  String get dataDirLabel => 'Datenverzeichnis';

  @override
  String get activitiesLabel => 'Aktivitäten';

  @override
  String get servicesLabel => 'Dienste';

  @override
  String get receiversLabel => 'Empfänger';

  @override
  String get providersLabel => 'Anbieter';

  @override
  String techVersionLabel(String tech) {
    return '$tech-Version';
  }

  @override
  String splitApksValue(int count) {
    return '$count Splits';
  }

  @override
  String aboutFramework(String name) {
    return 'Über $name';
  }

  @override
  String get viewOfficialDocs => 'Offizielle Dokumentation ansehen';

  @override
  String get shareAppDetails => 'App-Details teilen';

  @override
  String get filteredSizeLabel => 'GEFILTERTE GRÖSSE';

  @override
  String get totalConsumedLabel => 'GESAMTVERBRAUCH';

  @override
  String get appCodeLabel => 'App-Code';

  @override
  String get userDataLabel => 'Benutzerdaten';

  @override
  String get cacheLabel => 'Cache';

  @override
  String get appDetailsTitle => 'App-Details';

  @override
  String get loadingAppDetails => 'App-Details werden geladen...';

  @override
  String get appDataRefreshed => 'App-Daten aktualisiert';

  @override
  String get failedToResync => 'Neu-Synchronisierung fehlgeschlagen';

  @override
  String get installDateLabel => 'Installationsdatum';

  @override
  String get detectedPackagesTitle => 'Erkannte Pakete';

  @override
  String get packageLabel => 'Paket';

  @override
  String get uidLabel => 'UID';

  @override
  String get nativeLibrariesLabel => 'Native Bibliotheken';

  @override
  String get permissionsLabel => 'Berechtigungen';

  @override
  String get updatedLabel => 'Aktualisiert';

  @override
  String viewMoreLabel(int count) {
    return '$count weitere anzeigen';
  }

  @override
  String get activityLabel => 'Aktivität';

  @override
  String activityUsageSince(String duration, String date, int days) {
    return 'Genutzt für $duration seit Installation am $date (vor $days Tagen)';
  }

  @override
  String get activityNoChartData =>
      'Keine ausreichenden Daten zum Zeichnen des Diagramms gefunden';

  @override
  String get activityNoRecentActivity => 'Keine jüngste Aktivität';

  @override
  String get activityNoUsageLastYear =>
      'Keine Nutzung im letzten Jahr aufgezeichnet';

  @override
  String get activityUnableToLoad => 'Aktivität kann nicht geladen werden';

  @override
  String routeNotFound(String name) {
    return 'Route nicht gefunden: $name';
  }

  @override
  String get searchInstalledApps => 'Installierte Apps durchsuchen...';

  @override
  String get searchApps => 'Apps durchsuchen...';

  @override
  String get scan => 'Scannen';

  @override
  String get scanOptions => 'Scan-Optionen';

  @override
  String get scanOptionsSubtitle =>
      'Wählen Sie, wie Sie Ihre App-Informationen aktualisieren möchten.';

  @override
  String get fullSystemScan => 'Vollständiger System-Scan';

  @override
  String get fullSystemScanSubtitle => 'Tiefenanalyse & App-Fingerprinting';

  @override
  String get smartRevalidate => 'Intelligente Revalidierung';

  @override
  String get smartRevalidateSubtitle => 'Schnell auf App-Änderungen prüfen';

  @override
  String get checkingUpdates => 'Updates werden überprüft';

  @override
  String get githubCtaTitle => 'Für detaillierte Informationen';

  @override
  String get githubCtaSubtitle =>
      'Schauen Sie sich den Quellcode auf GitHub an';

  @override
  String get reportIssueSubtitle =>
      'Wählen Sie aus, wie Sie ein Problem melden oder untersuchen möchten.';

  @override
  String get processSandboxedMessage =>
      'Die Systemüberwachung auf Kernel-Ebene ist durch die Android-OS-Sandbox (SELinux) gesichert. Im Folgenden sind nur User-Space-Anwendungen zugänglich.';
}

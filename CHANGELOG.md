# Changelog

All notable changes to this project will be documented in this file.

## [1.5.1+17] - 2026-07-06

### Added

- **Release Notes Sheet**: New "What's New" bottom sheet displays the latest version's features and bug fixes fetched from `version_config.json`, accessible from the home screen update banner.
- **In-App Update Flow**: Update banner card and release notes sheet now integrate with the Play Core flexible update API — users can trigger a Play Store update directly from within the app, with a loading state and fallback to direct APK download.
- **Update Banner Card**: Home screen card that surfaces update availability (Play Store) or the latest release notes, with version chip, change count subtitle, and haptic tap.
- **Localization — Turkish**: Added full Turkish (`tr`) translation covering all app strings.
- **Localization — Hindi**: Added full Hindi (`hi`) translation covering all app strings.
- **Localization — Indonesian**: Added full Indonesian (`id`) translation covering all app strings.

### Improved

- **Tamil Localization**: Significantly improved and expanded Tamil (`ta`) translations for better accuracy and coverage across technical and UI strings.

## [1.4.1+16] - 2026-06-17

### Added

- **Rate App Deep Link**: Rate App button now directly opens the Play Store review page via `market://` intent, bypassing the in-app review API entirely.
- **Custom Date Range Label**: Usage statistics now shows the actual date range (e.g. "Jun 1 – Jun 15, 2025") instead of a computed duration when a custom range is selected.

### Fixed

- **In-App Review False Positive**: Fixed bug where the review system incorrectly marked the user as having reviewed the app immediately after showing the review dialog, causing the menu to show "Thank you" even though no review was submitted.
- **Review Trigger Operator Precedence**: Fixed a subtle Dart operator precedence bug in the review guard condition (`?? false || hasCompletedReview`) that caused the condition to short-circuit incorrectly.
- **Removed False Thank You State**: Removed `hasCompletedReview` tracking from automated review flows since the native Play Review API provides no feedback on whether the user actually submitted a review.

## [1.4.0+15] - 2026-06-11

### Added

- **Play Core In-App Updates**: Integrated Google Play Core In-App Updates with flexible and immediate update flows, new update banners, and refactored UpdateService.
- **Play In-App Review**: Added native Play In-App Review integration with sophisticated automated triggers and manual review access via AppDrawer.
- **Rate App Experience**: Implemented community-focused Rate App card with 'Thanks' state feedback after user interaction.
- **Localization**: Added Rate App strings for English and Tamil.

### Fixed

- **Version Resolution**: Fixed local version detection for GitHub builds.
- **Review Trigger**: Prevented double-trigger of app entry review prompt.
- **Missing Import**: Added missing import for sharedPreferencesProvider in review service.

## [1.3.0+14] - 2026-06-06

### Added

- **Professional Logging System**: Implemented a core `LoggingService` that automatically strips informal icons/emojis and standardizes log formatting across the entire app.
- **Log Viewer & Management**: Added a dedicated App Logs viewer with a professional fixed header, multi-select capability, and batch copy/export functionality.
- **Global Crash Recovery**: Integrated a principal-grade crash recovery system that intercepts startup and runtime errors, presenting users with a stable diagnostic interface.
- **Dynamic Locale Typography**: Upgraded the typography system to intelligently scale font sizes and letter spacing based on the active locale, with specific pro-level optimizations for the Tamil language.

### Fixed

- **Typography Consistency**: Ensured the 'UncutSans' brand font is applied uniformly across all 15+ Material text styles and specialized UI components (Buttons, Inputs, etc.).
- **Professional Log Formatting**: Removed informal icons (🔍, 🔵, ✅, ❌) from all repository, provider, and native Android diagnostic reports.

## [1.2.0+13] - 2026-05-16

### Added

- **Premium Language Selection**: Implemented a dedicated Language Selection page with search and filtering for a better user experience.
- **Enhanced Localization**: Significantly expanded localization coverage and improved Tamil translations for technical app details and deep insights.

## [1.1.3+12] - 2026-04-23

### Added

- **Localization**: Added core localization infrastructure with initial support for English and Tamil (Creds @Alien501).
- **Google Play Badge**: Added a Google Play Store badge to the README for direct app access.
- **Fastlane Deployment**: Fully configured Fastlane deployment to Google Play Store using GitHub Actions and automated changelog syncing.

### Fixed

- **Version Config Formatting**: Fixed separator in the fixes section of the version configuration payload.

## [1.1.2+11] - 2026-04-20

### Added

- **NIO Storage Scanning**: Reimplemented Android directory traversal with NIO `Files.walkFileTree` on Supported (Oreo+) devices for dramatically faster scanning and stability.
- **Task Manager Permissions**: Integrated `UsagePermissionCard` prominently inside the Task Manager to guide users missing required access.

### Changed

- **UI Memory Optimizations**: Capped maximum cache dimensions for avatar resolution and framework logos using `ResizeImage` to vastly cut background memory usage.
- **Batched Processing Limits**: Capped Dart `Future.wait` batch limits to 2 concurrent tasks matching the native unfilter thread pool, preventing deadlocks when scanning storage for heavy apps.

### Fixed

- **Low-end OOM Crashes**: Handled Out of Memory (OOM) fatal spikes by efficiently clearing image caches on dispose and sizing down GitHub assets—specifically improving stability on 4GB-RAM devices (like MIUI).

## [1.1.1+10] - 2026-04-13

### Added

- **Sponsors Drawer Card**: Added a compact sponsor card in the app drawer that opens the Sponsors page while preserving a focused, precise clickable `r4khul` profile link.
- **Sponsors Page Route**: Added the dedicated Sponsors page, including a support CTA banner, sponsor provider integration, and scrollable layout.

### Changed

- **Sponsor Page Experience**: Simplified the empty sponsor state copy and ensured the page remains scrollable with minimal content.
- **Drawer Navigation**: Integrated the sponsor card into the drawer and routed it cleanly through app navigation.

### Fixed

- **UI Polish**: Removed repetitive GitHub icon clutter and tightened the sponsor card layout for a more modern and minimal appearance.

## [1.1.1+8] - 2026-03-25

### Added

- **Release Metadata Alignment**: Updated release config to ship synchronized app/update/release information for this version.

### Changed

- **Product Positioning**: Refreshed project messaging in `README` and package metadata to reflect Unfilter as an on-device app intelligence tool.

### Fixed

- **Analytics Lint**: Removed unnecessary wildcard underscore usage in analytics page callbacks.
- **Onboarding Cleanup**: Removed unused install-permission state and related unused logic.

## [1.1.0] - 2026-01-29

### Added

- **Advanced Search**: Users can now filter apps by Tech Stack (Flutter, React Native, Kotlin, etc.), App Name, and Package Name.
- **Battery Impact Analysis**: New modal in Task Manager to view detailed battery impact of running processes.
- **Privacy Policy**: Added support for viewing the app's privacy policy directly within the app.
- **Issue Templates**: specific templates for Bug Reports and Feature Requests to streamline contributions.
- **License**: Added MIT License to the project.

### Changed

- **UI/UX Consistency**: Refined all bottom sheets to have sharp, non-rounded corners for a unified design language.
- **System Overlay**: improved system bar integration for a seamless look in both Light and Dark modes.
- **Documentation**: Enhanced README with build badges and clearer gallery layouts.

## [1.0.0+2] - 2026-01-05

### Added

- **OTA Update System**: Rolled out a robust Over-The-Air update mechanism to deliver future updates directly to users.
- **Critical Fix**: Enforced `extractNativeLibs="true"` in Android Manifest to resolve `libflutter.so` loading crashes on POCO and MIUI devices.

## [1.0.0+1] - 2026-01-05

### Initial Release

- Initial public beta release of Unfilter.
- Core functionality: Tech stack detection, storage analysis, and task manager.

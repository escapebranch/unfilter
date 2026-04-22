# Changelog

All notable changes to this project will be documented in this file.

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

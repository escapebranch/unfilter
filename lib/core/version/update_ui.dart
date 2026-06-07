import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unfilter/l10n/generated/app_localizations.dart';
import 'version_provider.dart';
import 'update_service.dart';

class VersionGate extends ConsumerWidget {
  final Widget child;

  const VersionGate({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateInfo = ref.watch(updateInfoProvider);
    final isDismissed = ref.watch(dismissedUpdateProvider);

    return updateInfo.when(
      data: (info) {
        if (info.availability == InAppUpdateAvailability.available && !isDismissed) {
          return Stack(
            children: [
              child,
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: FlexibleUpdateBanner(info: info),
              ),
            ],
          );
        }

        // Also check if an update is already downloaded
        return Consumer(
          builder: (context, ref, _) {
            final events = ref.watch(updateEventsProvider);
            return events.when(
              data: (state) {
                if (state.status == InAppUpdateInstallStatus.downloaded) {
                  return Stack(
                    children: [
                      child,
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: UpdateDownloadedBanner(),
                      ),
                    ],
                  );
                }
                return child;
              },
              loading: () => child,
              error: (e, s) => child,
            );
          },
        );
      },
      loading: () => child,
      error: (e, s) => child,
    );
  }
}

class FlexibleUpdateBanner extends ConsumerWidget {
  final InAppUpdateInfo info;

  const FlexibleUpdateBanner({super.key, required this.info});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final events = ref.watch(updateEventsProvider);

    return events.when(
      data: (state) {
        if (state.status == InAppUpdateInstallStatus.downloading) {
          return _buildDownloadingBanner(context, state);
        }
        if (state.status == InAppUpdateInstallStatus.downloaded) {
          return const UpdateDownloadedBanner();
        }
        return _buildPromptBanner(context, ref, l10n);
      },
      loading: () => _buildPromptBanner(context, ref, l10n),
      error: (e, s) => _buildPromptBanner(context, ref, l10n),
    );
  }

  Widget _buildPromptBanner(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.rocket_launch_rounded,
                  color: Colors.blueAccent,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.newUpdateAvailable,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    ref.read(dismissedUpdateProvider.notifier).dismiss();
                  },
                  child: const Icon(Icons.close, color: Colors.grey, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.newNativeVersionAvailable(info.availableVersionCode.toString()),
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(updateServiceProvider).startFlexibleUpdate();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.updateNowAction),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadingBanner(BuildContext context, InAppUpdateInstallState state) {
    final progress = state.totalBytesToDownload > 0 
        ? state.bytesDownloaded / state.totalBytesToDownload 
        : 0.0;
    
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Downloading update...',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withValues(alpha: 0.05),
                valueColor: const AlwaysStoppedAnimation(Colors.blueAccent),
                minHeight: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateDownloadedBanner extends ConsumerWidget {
  const UpdateDownloadedBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.greenAccent,
                  size: 20,
                ),
                SizedBox(width: 12),
                Text(
                  'Update Ready',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'The update has been downloaded. Restart the app to apply it.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(updateServiceProvider).completeUpdate();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Restart & Update', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:unfilter/l10n/generated/app_localizations.dart';
import 'version_models.dart';
import 'version_provider.dart';
import 'update_service.dart';

class VersionGate extends ConsumerWidget {
  final Widget child;

  const VersionGate({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateState = ref.watch(updateStateProvider);

    return updateState.when(
      data: (state) {
        if (state.status == AppUpdateStatus.forceUpdate) {
          return ForceUpdateScreen(state: state);
        }

        if (state.status == AppUpdateStatus.softUpdate) {
          return Stack(
            children: [
              child,
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SoftUpdateBanner(state: state),
              ),
            ],
          );
        }

        return child;
      },
      loading: () => child,
      error: (e, s) => child,
    );
  }
}

class ForceUpdateScreen extends StatelessWidget {
  final UpdateState state;

  const ForceUpdateScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.system_security_update_rounded,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 32),
              Text(
                l10n.criticalUpdateMessage,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildVersionInfo(
                l10n.currentVersionLabel,
                state.currentVersion.displayString,
                Colors.grey,
              ),
              const SizedBox(height: 16),
              _buildVersionInfo(
                l10n.requiredVersionLabel,
                state.config?.minSupportedNativeVersion.nativeVersion ??
                    l10n.commonUnknownLabel,
                Colors.redAccent,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (state.config?.apkUrl != null) {
                      launchUrl(
                        Uri.parse(state.config!.apkUrl),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    l10n.downloadUpdateAction,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionInfo(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

class SoftUpdateBanner extends StatelessWidget {
  final UpdateState state;

  const SoftUpdateBanner({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
                  },
                  child: const Icon(Icons.close, color: Colors.grey, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.newNativeVersionAvailable(state.config?.latestNativeVersion.nativeVersion ?? 'Unknown'),
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (state.config?.apkUrl != null) {
                    launchUrl(
                      Uri.parse(state.config!.apkUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  }
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
}

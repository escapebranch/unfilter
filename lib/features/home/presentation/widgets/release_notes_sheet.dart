import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/constants/constants.dart';
import '../../../../common/widgets/snackbar_utils.dart';
import '../../../../core/version/release_notes_provider.dart';
import '../../../../core/version/update_service.dart';
import '../../../../core/version/version_provider.dart';
import '../../../apps/presentation/widgets/app_details/premium_modal_header.dart';

enum _UpdateActionState { idle, loading, success }

class ReleaseNotesSheet extends ConsumerStatefulWidget {
  const ReleaseNotesSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (ctx, controller) => const ReleaseNotesSheet(),
      ),
    );
  }

  @override
  ConsumerState<ReleaseNotesSheet> createState() => _ReleaseNotesSheetState();
}

class _ReleaseNotesSheetState extends ConsumerState<ReleaseNotesSheet> {
  _UpdateActionState _actionState = _UpdateActionState.idle;

  Future<void> _handleInAppUpdate(InAppUpdateInfo info) async {
    HapticFeedback.lightImpact();
    setState(() => _actionState = _UpdateActionState.loading);
    try {
      await ref.read(updateServiceProvider).startFlexibleUpdate();
      if (mounted) {
        setState(() => _actionState = _UpdateActionState.success);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _actionState = _UpdateActionState.idle);
        SnackBarUtils.showError(
          context,
          'Update failed to start. Try downloading directly.',
        );
      }
    }
  }

  Future<void> _handleDirectDownload(String url) async {
    HapticFeedback.lightImpact();
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Could not open download link.');
      }
    }
  }

  Future<void> _handleViewReleasePage(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final releaseNotes = ref.watch(releaseNotesProvider);
    final updateInfo = ref.watch(updateInfoProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          PremiumModalHeader(
            title: "What's New",
            icon: Icons.new_releases_outlined,
            onClose: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: releaseNotes.when(
              data: (data) {
                if (data == null) return const _ErrorBody();
                return _SheetBody(
                  data: data,
                  updateInfo: updateInfo,
                  actionState: _actionState,
                  onInAppUpdate: _handleInAppUpdate,
                  onDirectDownload: _handleDirectDownload,
                  onViewReleasePage: _handleViewReleasePage,
                );
              },
              loading: () => const _LoadingBody(),
              error: (_, __) => const _ErrorBody(),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet body — scrollable content + action buttons
// ---------------------------------------------------------------------------

class _SheetBody extends StatelessWidget {
  final ReleaseNotesData data;
  final AsyncValue<InAppUpdateInfo> updateInfo;
  final _UpdateActionState actionState;
  final void Function(InAppUpdateInfo) onInAppUpdate;
  final void Function(String) onDirectDownload;
  final void Function(String) onViewReleasePage;

  const _SheetBody({
    required this.data,
    required this.updateInfo,
    required this.actionState,
    required this.onInAppUpdate,
    required this.onDirectDownload,
    required this.onViewReleasePage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xl + bottomPad,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _VersionMeta(data: data, theme: theme),
          if (data.releaseNotes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            _SummaryBlock(summary: data.releaseNotes, theme: theme),
          ],
          if (data.features.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxl),
            _ChangelogSection(
              label: 'NEW FEATURES',
              icon: Icons.auto_awesome_rounded,
              items: data.features,
              theme: theme,
              isFeature: true,
            ),
          ],
          if (data.fixes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xl),
            _ChangelogSection(
              label: 'BUG FIXES',
              icon: Icons.bug_report_outlined,
              items: data.fixes,
              theme: theme,
              isFeature: false,
            ),
          ],
          const SizedBox(height: AppSpacing.xxl),
          _ActionButtons(
            data: data,
            updateInfo: updateInfo,
            actionState: actionState,
            onInAppUpdate: onInAppUpdate,
            onDirectDownload: onDirectDownload,
            onViewReleasePage: onViewReleasePage,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Version meta row — version string + status pill
// ---------------------------------------------------------------------------

class _VersionMeta extends StatelessWidget {
  final ReleaseNotesData data;
  final ThemeData theme;

  const _VersionMeta({required this.data, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    final versionShort = data.latestVersion.split('+').first;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.isUpdateAvailable
                    ? 'Version $versionShort is available'
                    : "You're on the latest version",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.isUpdateAvailable
                    ? 'Update to get the latest improvements'
                    : 'v$versionShort — all up to date',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: data.isUpdateAvailable
                ? theme.colorScheme.primary.withValues(alpha: AppOpacity.light)
                : Colors.green.withValues(alpha: AppOpacity.light),
            borderRadius: BorderRadius.circular(AppBorderRadius.circular),
            border: Border.all(
              color: data.isUpdateAvailable
                  ? theme.colorScheme.primary.withValues(
                      alpha: AppOpacity.medium,
                    )
                  : Colors.green.withValues(alpha: AppOpacity.medium),
            ),
          ),
          child: Text(
            data.isUpdateAvailable ? 'UPDATE' : 'LATEST',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              fontSize: 10,
              color: data.isUpdateAvailable
                  ? theme.colorScheme.primary
                  : (isDark ? Colors.greenAccent : Colors.green.shade700),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Release notes summary block
// ---------------------------------------------------------------------------

class _SummaryBlock extends StatelessWidget {
  final String summary;
  final ThemeData theme;

  const _SummaryBlock({required this.summary, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.standard),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: AppOpacity.subtle)
            : Colors.black.withValues(alpha: AppOpacity.verySubtle),
        borderRadius: BorderRadius.circular(AppBorderRadius.standard),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(
            alpha: AppOpacity.light,
          ),
        ),
      ),
      child: Text(
        summary,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(
            alpha: AppOpacity.veryHigh,
          ),
          height: 1.6,
          fontFamily: 'monospace',
          fontSize: 12,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Changelog section — label + icon header + items
// ---------------------------------------------------------------------------

class _ChangelogSection extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<String> items;
  final ThemeData theme;
  final bool isFeature;

  const _ChangelogSection({
    required this.label,
    required this.icon,
    required this.items,
    required this.theme,
    required this.isFeature,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = isFeature
        ? theme.colorScheme.primary.withValues(alpha: AppOpacity.high)
        : theme.colorScheme.onSurface.withValues(alpha: AppOpacity.half);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: labelColor),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                fontSize: 11,
                color: labelColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.standard),
        ...items.map(
          (item) =>
              _ChangelogItem(text: item, theme: theme, isFeature: isFeature),
        ),
      ],
    );
  }
}

class _ChangelogItem extends StatelessWidget {
  final String text;
  final ThemeData theme;
  final bool isFeature;

  const _ChangelogItem({
    required this.text,
    required this.theme,
    required this.isFeature,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    final dotColor = isFeature
        ? theme.colorScheme.primary
        : (isDark ? Colors.white54 : Colors.black45);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(
                  alpha: AppOpacity.veryHigh,
                ),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Action buttons — Play Store in-app update OR GitHub download/view
// ---------------------------------------------------------------------------

class _ActionButtons extends StatelessWidget {
  final ReleaseNotesData data;
  final AsyncValue<InAppUpdateInfo> updateInfo;
  final _UpdateActionState actionState;
  final void Function(InAppUpdateInfo) onInAppUpdate;
  final void Function(String) onDirectDownload;
  final void Function(String) onViewReleasePage;

  const _ActionButtons({
    required this.data,
    required this.updateInfo,
    required this.actionState,
    required this.onInAppUpdate,
    required this.onDirectDownload,
    required this.onViewReleasePage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!data.isUpdateAvailable) {
      return _GitHubButton(
        label: 'View on GitHub',
        onTap: () => onViewReleasePage(data.releasePageUrl),
        theme: theme,
      );
    }

    return updateInfo.when(
      data: (info) {
        final canUseInAppUpdate =
            info.availability == InAppUpdateAvailability.available &&
            info.isFlexibleUpdateAllowed;

        if (canUseInAppUpdate) {
          return _InAppUpdateButton(
            actionState: actionState,
            theme: theme,
            onTap: () => onInAppUpdate(info),
          );
        }

        return _DownloadButtons(
          data: data,
          theme: theme,
          onDirectDownload: onDirectDownload,
          onViewReleasePage: onViewReleasePage,
        );
      },
      loading: () => _DownloadButtons(
        data: data,
        theme: theme,
        onDirectDownload: onDirectDownload,
        onViewReleasePage: onViewReleasePage,
      ),
      error: (_, __) => _DownloadButtons(
        data: data,
        theme: theme,
        onDirectDownload: onDirectDownload,
        onViewReleasePage: onViewReleasePage,
      ),
    );
  }
}

class _InAppUpdateButton extends StatelessWidget {
  final _UpdateActionState actionState;
  final ThemeData theme;
  final VoidCallback? onTap;

  const _InAppUpdateButton({
    required this.actionState,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = actionState == _UpdateActionState.loading;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          disabledBackgroundColor: theme.colorScheme.primary.withValues(
            alpha: AppOpacity.half,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.standard),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(
                    theme.colorScheme.onPrimary.withValues(
                      alpha: AppOpacity.veryHigh,
                    ),
                  ),
                ),
              )
            : Text(
                'Update Now',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onPrimary,
                  letterSpacing: 0.2,
                ),
              ),
      ),
    );
  }
}

class _DownloadButtons extends StatelessWidget {
  final ReleaseNotesData data;
  final ThemeData theme;
  final void Function(String) onDirectDownload;
  final void Function(String) onViewReleasePage;

  const _DownloadButtons({
    required this.data,
    required this.theme,
    required this.onDirectDownload,
    required this.onViewReleasePage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () => onDirectDownload(data.apkDirectDownloadUrl),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.standard),
              ),
            ),
            child: Text(
              'Download Update',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onPrimary,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _GitHubButton(
          label: 'View on GitHub',
          onTap: () => onViewReleasePage(data.releasePageUrl),
          theme: theme,
        ),
      ],
    );
  }
}

class _GitHubButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final ThemeData theme;

  const _GitHubButton({
    required this.label,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(
          Icons.open_in_new_rounded,
          size: 16,
          color: theme.colorScheme.onSurface.withValues(
            alpha: AppOpacity.veryHigh,
          ),
        ),
        label: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(
              alpha: AppOpacity.veryHigh,
            ),
            letterSpacing: 0.2,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface,
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(
              alpha: AppOpacity.mediumHigh,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.standard),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading / error states
// ---------------------------------------------------------------------------

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(
                theme.colorScheme.primary.withValues(alpha: AppOpacity.high),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.standard),
          Text(
            'Fetching release notes...',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 40,
              color: theme.colorScheme.onSurfaceVariant.withValues(
                alpha: AppOpacity.medium,
              ),
            ),
            const SizedBox(height: AppSpacing.standard),
            Text(
              'Could not load release notes',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Check your connection and try again.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: AppOpacity.high,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

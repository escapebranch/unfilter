import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/constants/constants.dart';
import '../../../../core/version/release_notes_provider.dart';
import '../../../../core/version/update_service.dart';
import '../../../../core/version/version_provider.dart';
import 'release_notes_sheet.dart';

class UpdateBannerCard extends ConsumerWidget {
  const UpdateBannerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final releaseNotes = ref.watch(releaseNotesProvider);
    final updateInfo = ref.watch(updateInfoProvider);

    return releaseNotes.when(
      data: (data) {
        if (data == null) return const SizedBox.shrink();

        if (data.isUpdateAvailable) {
          final isPlayStoreUpdate = updateInfo.when(
            data: (info) =>
                info.availability == InAppUpdateAvailability.available ||
                info.availability == InAppUpdateAvailability.inProgress,
            loading: () => false,
            error: (_, _) => false,
          );
          if (!isPlayStoreUpdate) return const SizedBox.shrink();
        }

        return _BannerCard(data: data);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _BannerCard extends StatelessWidget {
  final ReleaseNotesData data;

  const _BannerCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        border: Border.all(
          color: data.isUpdateAvailable
              ? theme.colorScheme.primary.withValues(alpha: AppOpacity.medium)
              : theme.colorScheme.outlineVariant.withValues(
                  alpha: AppOpacity.mediumHigh,
                ),
        ),
        boxShadow: [
          BoxShadow(
            color: data.isUpdateAvailable
                ? theme.colorScheme.primary.withValues(
                    alpha: isDark ? 0.12 : 0.06,
                  )
                : Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            ReleaseNotesSheet.show(context);
          },
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                _LeadingIcon(isUpdate: data.isUpdateAvailable, theme: theme),
                const SizedBox(width: AppSpacing.standard),
                Expanded(
                  child: _CardContent(data: data, theme: theme),
                ),
                const SizedBox(width: AppSpacing.sm),
                _TrailingChevron(theme: theme),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  final bool isUpdate;
  final ThemeData theme;

  const _LeadingIcon({required this.isUpdate, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isUpdate
            ? theme.colorScheme.primary.withValues(alpha: AppOpacity.light)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Icon(
        isUpdate
            ? Icons.system_update_alt_rounded
            : Icons.new_releases_outlined,
        size: 22,
        color: isUpdate
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final ReleaseNotesData data;
  final ThemeData theme;

  const _CardContent({required this.data, required this.theme});

  @override
  Widget build(BuildContext context) {
    final versionShort = data.latestVersion.split('+').first;
    final changeCount = data.features.length + data.fixes.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              data.isUpdateAvailable ? 'Update Available' : "What's New",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _VersionChip(
              version: versionShort,
              isUpdate: data.isUpdateAvailable,
              theme: theme,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _buildSubtitle(changeCount),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _buildSubtitle(int changeCount) {
    if (!data.isUpdateAvailable) {
      if (changeCount == 0) return 'See the latest release notes';
      return '$changeCount change${changeCount == 1 ? '' : 's'} in this release';
    }

    final parts = <String>[];
    if (data.features.isNotEmpty) {
      parts.add(
        '${data.features.length} new feature${data.features.length == 1 ? '' : 's'}',
      );
    }
    if (data.fixes.isNotEmpty) {
      parts.add(
        '${data.fixes.length} fix${data.fixes.length == 1 ? '' : 'es'}',
      );
    }

    if (parts.isEmpty) return 'Tap to see what changed';
    return '${parts.join(' · ')} — tap to update';
  }
}

class _VersionChip extends StatelessWidget {
  final String version;
  final bool isUpdate;
  final ThemeData theme;

  const _VersionChip({
    required this.version,
    required this.isUpdate,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isUpdate
            ? theme.colorScheme.primary.withValues(alpha: AppOpacity.light)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: Text(
        'v$version',
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 10,
          letterSpacing: 0.3,
          color: isUpdate
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

class _TrailingChevron extends StatelessWidget {
  final ThemeData theme;

  const _TrailingChevron({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.chevron_right_rounded,
      size: 22,
      color: theme.colorScheme.onSurfaceVariant.withValues(
        alpha: AppOpacity.half,
      ),
    );
  }
}

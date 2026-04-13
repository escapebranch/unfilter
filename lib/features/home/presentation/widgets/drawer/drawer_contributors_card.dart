import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/contributors_provider.dart';

class DrawerContributorsCard extends ConsumerWidget {
  const DrawerContributorsCard({super.key, required this.onViewContributors});

  final VoidCallback onViewContributors;

  static const Set<String> _r4khulVariants = {
    'r4khul',
    'Rakhul',
    'R4KHUL',
    'rakhul',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final contributorsAsync = ref.watch(contributorsProvider);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surface
            : theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onViewContributors,
          highlightColor: theme.colorScheme.primary.withValues(alpha: 0.05),
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                _buildContributorsIcon(theme),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Contributors',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildSubtitle(contributorsAsync, theme),
                    ],
                  ),
                ),
                _buildRightContent(contributorsAsync, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContributorsIcon(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Icon(
        Icons.people_alt_rounded,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildSubtitle(
    AsyncValue<List<dynamic>> contributorsAsync,
    ThemeData theme,
  ) {
    return contributorsAsync.when(
      data: (contributors) {
        final externalCount = _countExternalContributors(contributors);
        final text = externalCount == 0
            ? 'Be the first external contributor'
            : '$externalCount external contributor${externalCount == 1 ? '' : 's'}';

        return Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        );
      },
      loading: () => Text(
        'Loading...',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      error: (_, __) => Text(
        'View all contributors',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildRightContent(
    AsyncValue<List<dynamic>> contributorsAsync,
    ThemeData theme,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildOverlappingAvatars(contributorsAsync, theme),
        const SizedBox(width: 8),
        Icon(
          Icons.chevron_right_rounded,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ],
    );
  }

  Widget _buildOverlappingAvatars(
    AsyncValue<List<dynamic>> contributorsAsync,
    ThemeData theme,
  ) {
    return contributorsAsync.when(
      data: (contributors) {
        // Filter out r4khul variants and get top 2
        final externalContributors = contributors
            .where((c) => !_r4khulVariants.contains(c.login))
            .take(2)
            .toList();

        if (externalContributors.isEmpty) {
          // Show placeholder when only r4khul is the contributor
          return Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Icon(Icons.add, size: 16, color: theme.colorScheme.primary),
          );
        }

        final overlapOffset = -10.0;
        final avatarSize = 32.0;

        return SizedBox(
          height: avatarSize,
          width:
              avatarSize +
              (externalContributors.length > 1
                  ? (avatarSize + overlapOffset) * 0.5
                  : 0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (int i = 0; i < externalContributors.length; i++)
                Positioned(
                  left: i * (avatarSize + overlapOffset) * 0.5,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: avatarSize / 2,
                      backgroundImage: NetworkImage(
                        externalContributors[i].avatarUrl,
                      ),
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: theme.colorScheme.primary.withValues(alpha: 0.5),
        ),
      ),
      error: (_, __) => Icon(
        Icons.people_outline,
        size: 20,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }

  int _countExternalContributors(List<dynamic> contributors) {
    return contributors.where((c) => !_r4khulVariants.contains(c.login)).length;
  }
}

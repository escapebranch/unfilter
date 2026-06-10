import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unfilter/l10n/generated/app_localizations.dart';
import '../../../../../core/version/version_provider.dart';

class DrawerRateAppCard extends ConsumerWidget {
  const DrawerRateAppCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final reviewService = ref.watch(reviewServiceProvider);
    final hasRated = reviewService.hasRatedManually;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : theme.colorScheme.surfaceContainerLowest,
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
          onTap: hasRated
              ? null
              : () {
                  ref.read(reviewServiceProvider).launchReview();
                },
          borderRadius: BorderRadius.circular(16),
          highlightColor: theme.colorScheme.primary.withValues(alpha: 0.05),
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: hasRated
                          ? [const Color(0xFF4CAF50), const Color(0xFF388E3C)]
                          : [const Color(0xFFFFD700), const Color(0xFFFFA000)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (hasRated ? const Color(0xFF388E3C) : const Color(0xFFFFA000))
                            .withValues(alpha: 0.4),
                        blurRadius: 8.0,
                        offset: const Offset(0, 3.0),
                      ),
                    ],
                  ),
                  child: Icon(
                    hasRated ? Icons.check_rounded : Icons.star_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        hasRated ? 'Thanks for the love! 😁' : l10n.rateApp,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasRated ? 'We appreciate your support.' : 'Love the app? Let us know!',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!hasRated)
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

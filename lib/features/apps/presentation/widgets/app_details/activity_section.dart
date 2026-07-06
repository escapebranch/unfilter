library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../l10n/generated/app_localizations.dart';
import '../../../domain/entities/app_usage_point.dart';
import '../../../domain/entities/device_app.dart';
import '../usage_chart.dart';
import 'common_widgets.dart';
import 'constants.dart';

class ActivitySection extends ConsumerWidget {
  final DeviceApp app;

  final AsyncValue<List<AppUsagePoint>> historyAsync;

  const ActivitySection({
    super.key,
    required this.app,
    required this.historyAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final totalDuration = Duration(milliseconds: app.totalTimeInForeground);
    final totalUsageStr = _formatDuration(totalDuration);
    final daysSinceInstall = DateTime.now().difference(app.installDate).inDays;
    final installDateStr = DateFormat('MMM d, y').format(app.installDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, theme, totalUsageStr),
        if (app.totalTimeInForeground > 0)
          Padding(
            padding: const EdgeInsets.only(
              top: AppDetailsSpacing.sm,
              bottom: AppDetailsSpacing.xs,
            ),
            child: Text(
              l10n.activityUsageSince(
                totalUsageStr,
                installDateStr,
                daysSinceInstall,
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(
                  alpha: AppDetailsOpacity.high,
                ),
              ),
            ),
          ),
        const SizedBox(height: AppDetailsSpacing.standard),
        _buildChart(context, theme, isDark),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return "${duration.inHours}h ${duration.inMinutes % 60}m";
    }
    return "${duration.inMinutes}m";
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    String totalUsageStr,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SectionHeader(title: AppLocalizations.of(context).activityLabel),
        if (app.totalTimeInForeground > 0)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDetailsSpacing.md,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(
                alpha: AppDetailsOpacity.light,
              ),
              borderRadius: BorderRadius.circular(AppDetailsBorderRadius.lg),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: AppDetailsSizes.iconSmall,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  totalUsageStr,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildChart(BuildContext context, ThemeData theme, bool isDark) {
    return historyAsync.when(
      data: (history) => _buildDataState(context, history, theme, isDark),
      loading: () => _buildLoadingState(isDark),
      error: (_, _) => _buildErrorState(context, isDark, theme),
    );
  }

  Widget _buildDataState(
    BuildContext context,
    List<AppUsagePoint> history,
    ThemeData theme,
    bool isDark,
  ) {
    final hasGranular =
        history.isNotEmpty && history.any((h) => h.usage.inSeconds > 0);
    final hasTotal = app.totalTimeInForeground > 0;

    final double containerHeight;
    if (hasGranular) {
      containerHeight = AppDetailsHeights.fullChart;
    } else if (hasTotal) {
      containerHeight = AppDetailsHeights.totalUsageOnly;
    } else {
      containerHeight = AppDetailsHeights.emptyState;
    }

    Widget content;
    if (hasGranular) {
      content = UsageChart(history: history, theme: theme, isDark: isDark);
    } else if (hasTotal) {
      content = _buildNoChartDataState(context, theme);
    } else {
      content = _buildEmptyState(context, history, theme);
    }

    return SectionContainer(
      useAltBackground: false,
      child: SizedBox(
        height: containerHeight,
        width: double.infinity,
        child: content,
      ),
    );
  }

  Widget _buildNoChartDataState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.insights_rounded,
            size: AppDetailsSizes.iconLarge,
            color: theme.colorScheme.onSurface.withValues(
              alpha: AppDetailsOpacity.standard,
            ),
          ),
          const SizedBox(height: AppDetailsSpacing.md),
          Text(
            AppLocalizations.of(context).activityNoChartData,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(
                alpha: AppDetailsOpacity.half,
              ),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    List<AppUsagePoint> history,
    ThemeData theme,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart_rounded,
            size: AppDetailsSizes.iconXLarge,
            color: theme.colorScheme.onSurface.withValues(
              alpha: AppDetailsOpacity.mediumLight,
            ),
          ),
          const SizedBox(height: AppDetailsSpacing.md),
          Text(
            history.isEmpty
                ? AppLocalizations.of(context).activityNoRecentActivity
                : AppLocalizations.of(context).activityNoUsageLastYear,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(
                alpha: AppDetailsOpacity.half,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return SectionContainer(
      useAltBackground: false,
      child: SizedBox(
        height: AppDetailsHeights.loading,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, bool isDark, ThemeData theme) {
    return SectionContainer(
      useAltBackground: false,
      child: SizedBox(
        height: AppDetailsHeights.containerSmall,
        child: Center(
          child: Text(
            AppLocalizations.of(context).activityUnableToLoad,
            style: theme.textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}

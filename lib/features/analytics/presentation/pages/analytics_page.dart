import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../apps/domain/entities/device_app.dart';
import '../../../apps/presentation/providers/apps_provider.dart';
import '../providers/usage_stats_providers.dart';
 
import 'package:unfilter/l10n/generated/app_localizations.dart';

import '../../../home/presentation/widgets/premium_app_bar.dart';
import '../../../../core/widgets/top_shadow_gradient.dart';
import '../../../home/presentation/widgets/usage_stats_share_poster.dart';
import '../widgets/analytics_empty_state.dart';
import '../widgets/analytics_pie_chart.dart';
import '../widgets/analytics_search_bar.dart';
import '../widgets/top_count_filter_button.dart';
import '../widgets/usage_app_item.dart';
import '../widgets/usage_permission_card.dart';
import '../widgets/usage_roast_card.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage>
    with WidgetsBindingObserver {
  int _touchedIndex = -1;
  int _showTopCount = 5;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _sharePosterKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(usagePermissionProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appsAsync = ref.watch(installedAppsProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: appsAsync.when(
        data: (apps) => _buildDataState(apps, theme),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(AppLocalizations.of(context).commonErrorWithDetails(err.toString()))),
      ),
    );
  }

  Widget _buildDataState(List<DeviceApp> apps, ThemeData theme) {
    final selectedRange = ref.watch(selectedUsageTimeRangeProvider);
    final persistentStatsAsync = ref.watch(filteredUsageStatsProvider);
    final usageStats = persistentStatsAsync.asData?.value;

    final rangeAwareApps = _buildRangeAwareApps(
      apps,
      selectedRange,
      usageStats,
    );
    var validApps = rangeAwareApps
        .where((a) => a.totalTimeInForeground > 0)
        .toList();

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      validApps = validApps.where((app) {
        return app.appName.toLowerCase().contains(query) ||
            app.packageName.toLowerCase().contains(query);
      }).toList();
    }

    final permissionAsync = ref.watch(usagePermissionProvider);
    final hasPermission = permissionAsync.value ?? false;

    if (persistentStatsAsync.isLoading &&
        usageStats == null &&
        selectedRange != UsageTimeRange.all) {
      return _buildLoadingState(selectedRange);
    }

    if (validApps.isEmpty && _searchQuery.isEmpty) {
      return _buildEmptyState(hasPermission, selectedRange);
    }

    if (validApps.isEmpty && _searchQuery.isNotEmpty) {
      return _buildSearchEmptyState(theme, selectedRange);
    }

    validApps.sort(
      (a, b) => b.totalTimeInForeground.compareTo(a.totalTimeInForeground),
    );

    return persistentStatsAsync.when(
      data: (persistentStats) => _buildAnalyticsContent(
        validApps,
        theme,
        persistentStats,
        selectedRange,
      ),
      loading: () =>
          _buildAnalyticsContent(validApps, theme, usageStats, selectedRange),
      error: (_, _) =>
          _buildAnalyticsContent(validApps, theme, usageStats, selectedRange),
    );
  }

  List<DeviceApp> _buildRangeAwareApps(
    List<DeviceApp> apps,
    UsageTimeRange selectedRange,
    PersistentUsageStats? usageStats,
  ) {
    final aggregatedUsage = usageStats?.aggregatedUsage;

    if (selectedRange == UsageTimeRange.all && aggregatedUsage == null) {
      return apps;
    }

    return apps.map((app) {
      final usage =
          aggregatedUsage?[app.packageName] ??
          (selectedRange == UsageTimeRange.all ? app.totalTimeInForeground : 0);
      return app.copyWith(totalTimeInForeground: usage);
    }).toList();
  }

  Widget _buildLoadingState(UsageTimeRange selectedRange) {
    return Stack(
      children: [
        const Center(child: CircularProgressIndicator()),
        const TopShadowGradient(),
        PremiumAppBar(
          title: AppLocalizations.of(context).usageStatisticsTitle,
          scrollController: _scrollController,
          menuActions: _buildUsageRangeMenuActions(selectedRange),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool hasPermission, UsageTimeRange selectedRange) {
    final l10n = AppLocalizations.of(context);

    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 46.0 + (8.0 * 2) + MediaQuery.of(context).padding.top,
              ),
            ),
            SliverFillRemaining(
              child: selectedRange == UsageTimeRange.custom
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noDataAvailable,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.tryDifferentDateRange,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    )
                  : UsagePermissionCard(hasPermission: hasPermission),
            ),
          ],
        ),
        const TopShadowGradient(),
        PremiumAppBar(
          title: l10n.usageStatisticsTitle,
          scrollController: _scrollController,
          menuActions: _buildUsageRangeMenuActions(selectedRange),
        ),
      ],
    );
  }

  Widget _buildSearchEmptyState(ThemeData theme, UsageTimeRange selectedRange) {
    final l10n = AppLocalizations.of(context);
    String emptyStateMessage = l10n.searchEmptyState;

    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 46.0 + (8.0 * 2) + MediaQuery.of(context).padding.top,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: AnalyticsSearchBar(
                  controller: _searchController,
                  searchQuery: _searchQuery,
                  hintText: l10n.searchUsageStatsHint,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  onClear: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
              ),
            ),
            SliverFillRemaining(
              child: AnalyticsEmptyState(message: emptyStateMessage),
            ),
          ],
        ),
        const TopShadowGradient(),
        PremiumAppBar(
          title: AppLocalizations.of(context).usageStatisticsTitle,
          scrollController: _scrollController,
          menuActions: _buildUsageRangeMenuActions(selectedRange),
        ),
      ],
    );
  }

  Widget _buildAnalyticsContent(
    List<DeviceApp> validApps,
    ThemeData theme,
    PersistentUsageStats? persistentStats,
    UsageTimeRange selectedRange,
  ) {
    final totalUsage = validApps.fold<int>(
      0,
      (sum, app) => sum + app.totalTimeInForeground,
    );
    final topApps = validApps.take(_showTopCount).toList();
    final topUsage = topApps.fold<int>(
      0,
      (sum, app) => sum + app.totalTimeInForeground,
    );
    final otherUsage = totalUsage - topUsage;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildHiddenSharePoster(topApps, totalUsage),

        CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 46.0 + (8.0 * 2) + MediaQuery.of(context).padding.top,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            if (persistentStats != null)
              _buildTrackedPeriodSliver(persistentStats, theme),
            if (persistentStats != null)
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            _buildSearchBarSliver(),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            _buildRoastSliver(totalUsage),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            _buildActionsSliver(theme),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            _buildChartSliver(topApps, otherUsage, totalUsage),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            _buildAppListSliver(topApps, totalUsage, theme),
          ],
        ),
        const TopShadowGradient(),
        PremiumAppBar(
          title: AppLocalizations.of(context).usageStatisticsTitle,
          scrollController: _scrollController,
          menuActions: _buildUsageRangeMenuActions(selectedRange),
        ),
      ],
    );
  }

  List<PremiumAppBarMenuAction> _buildUsageRangeMenuActions(
    UsageTimeRange selectedRange,
  ) {
    return UsageTimeRange.values.map((range) {
      return PremiumAppBarMenuAction(
        icon: _usageRangeIcon(range),
        label: range.label,
        isSelected: selectedRange == range,
        onTap: () async {
          if (range == UsageTimeRange.custom) {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              currentDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    appBarTheme: const AppBarTheme(
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              ref
                  .read(selectedCustomDateRangeProvider.notifier)
                  .setRange(picked);
              ref.read(selectedUsageTimeRangeProvider.notifier).setRange(range);
            }
          } else {
            ref.read(selectedUsageTimeRangeProvider.notifier).setRange(range);
          }
          if (mounted) setState(() => _touchedIndex = -1);
        },
      );
    }).toList();
  }

  IconData _usageRangeIcon(UsageTimeRange range) {
    switch (range) {
      case UsageTimeRange.all:
        return Icons.all_inclusive_rounded;
      case UsageTimeRange.daily:
        return Icons.today_rounded;
      case UsageTimeRange.weekly:
        return Icons.view_week_rounded;
      case UsageTimeRange.monthly:
        return Icons.calendar_month_rounded;
      case UsageTimeRange.custom:
        return Icons.edit_calendar_rounded;
    }
  }

  Widget _buildSearchBarSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AnalyticsSearchBar(
          controller: _searchController,
          searchQuery: _searchQuery,
          hintText: AppLocalizations.of(context).searchUsageStatsHint,
          onChanged: (val) => setState(() => _searchQuery = val),
          onClear: () {
            _searchController.clear();
            setState(() => _searchQuery = '');
          },
        ),
      ),
    );
  }

  Widget _buildTrackedPeriodSliver(
    PersistentUsageStats persistentStats,
    ThemeData theme,
  ) {
    final aggregationService = ref.read(usageAggregationServiceProvider);
    final periodText = aggregationService.formatTrackedPeriod(
      persistentStats.trackedPeriod,
    );
    final l10n = AppLocalizations.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.timeline_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.trackingForPeriod(periodText),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (persistentStats.storedSnapshotCount > 0)
                      Text(
                        l10n.daysStoredLocally(persistentStats.storedSnapshotCount),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (persistentStats.hasDataGap)
                Tooltip(
                  message: l10n.historicalDataCleared,
                  child: Icon(
                    Icons.info_outline,
                    size: 18,
                    color: theme.colorScheme.tertiary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoastSliver(int totalUsage) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: UsageRoastCard(totalUsage: Duration(milliseconds: totalUsage)),
      ),
    );
  }

  Widget _buildActionsSliver(ThemeData theme) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildShareButton(theme),
            TopCountFilterButton(
              currentCount: _showTopCount,
              onCountSelected: (value) {
                if (mounted) setState(() => _showTopCount = value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSliver(
    List<DeviceApp> topApps,
    int otherUsage,
    int totalUsage,
  ) {
    return SliverToBoxAdapter(
      child: AnalyticsPieChart(
        apps: topApps,
        total: totalUsage,
        otherValue: otherUsage,
        touchedIndex: _touchedIndex,
        onSectionTouched: (index) {
          if (mounted) setState(() => _touchedIndex = index);
        },
        getValue: (app) => app.totalTimeInForeground,
        formatTotal: (total) => _formatDuration(Duration(milliseconds: total)),
        centerLabel: 'Total',
      ),
    );
  }

  Widget _buildAppListSliver(
    List<DeviceApp> topApps,
    int totalUsage,
    ThemeData theme,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                _searchQuery.isEmpty ? AppLocalizations.of(context).topContributorsSection : AppLocalizations.of(context).searchResultsSection,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            );
          }
          final appIndex = index - 1;
          final app = topApps[appIndex];
          final percent = app.totalTimeInForeground / totalUsage;
          final isTouched = appIndex == _touchedIndex;

          return UsageAppItem(
            key: ValueKey(app.packageName),
            app: app,
            percent: percent,
            index: appIndex,
            isTouched: isTouched,
            onTapDown: () {
              if (mounted) setState(() => _touchedIndex = appIndex);
            },
            onTapCancel: () {
              if (mounted) setState(() => _touchedIndex = -1);
            },
          );
        }, childCount: topApps.length + 1),
      ),
    );
  }

  Widget _buildHiddenSharePoster(List<DeviceApp> topApps, int totalUsage) {
    return Positioned(
      left: -9999,
      top: -9999,
      child: RepaintBoundary(
        key: _sharePosterKey,
        child: SizedBox(
          width: 400,
          child: _buildSharePosterContent(topApps, totalUsage),
        ),
      ),
    );
  }

  Widget _buildSharePosterContent(List<DeviceApp> topApps, int totalUsage) {
    if (topApps.isEmpty) return const SizedBox.shrink();

    final duration = Duration(milliseconds: totalUsage);
    final roast = UsageRoastCard.getRoastForDuration(duration);
    final posterApps = topApps.take(6).toList();

    return Material(
      type: MaterialType.transparency,
      child: UsageStatsSharePoster(
        topApps: posterApps,
        totalUsage: duration,
        date: DateFormat.yMMMMd().format(DateTime.now()),
        roastContent: roast,
      ),
    );
  }

  Widget _buildShareButton(ThemeData theme) {
    return GestureDetector(
      onTap: _isSharing ? null : _handleShare,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
          ),
        ),
        child: _isSharing
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.primary,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.ios_share_rounded,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).shareLabel,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _handleShare() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);

    final l10n = AppLocalizations.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;

    try {
      for (int i = 0; i < 3; i++) {
        await WidgetsBinding.instance.endOfFrame;
      }
      await Future.delayed(const Duration(milliseconds: 50));
      await WidgetsBinding.instance.endOfFrame;

      final posterContext = _sharePosterKey.currentContext;
      if (posterContext == null || !posterContext.mounted) {
        throw Exception('Share poster widget not found.');
      }

      final boundary =
          posterContext.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('RenderRepaintBoundary not found.');
      }

      bool needsPaint = false;
      assert(() {
        needsPaint = boundary.debugNeedsPaint;
        return true;
      }());

      if (needsPaint) {
        for (int i = 0; i < 5; i++) {
          await WidgetsBinding.instance.endOfFrame;
        }
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to encode image data.');
      }

      final pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/unfilter_viral_stats.png');
      await file.writeAsBytes(pngBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: l10n.shareAnalyticsViralText,
        ),
      );
    } catch (e) {
      debugPrint('Share error: $e');
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(l10n.shareFailedError(e.toString())),
            backgroundColor: errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
    return '${duration.inMinutes}m';
  }
}

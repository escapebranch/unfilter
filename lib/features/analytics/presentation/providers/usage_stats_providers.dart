import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../apps/presentation/providers/apps_provider.dart';
import '../../../../core/providers/shared_preferences_provider.dart';
import '../../data/datasources/usage_stats_local_datasource.dart';
import '../../domain/services/usage_aggregation_service.dart';
import '../../domain/services/usage_stats_sync_service.dart';

enum UsageTimeRange { all, daily, weekly, monthly }

extension UsageTimeRangeX on UsageTimeRange {
  String get label {
    switch (this) {
      case UsageTimeRange.all:
        return 'All';
      case UsageTimeRange.daily:
        return 'Daily';
      case UsageTimeRange.weekly:
        return 'Weekly';
      case UsageTimeRange.monthly:
        return 'Monthly';
    }
  }

  int? get windowDays {
    switch (this) {
      case UsageTimeRange.all:
        return null;
      case UsageTimeRange.daily:
        return 1;
      case UsageTimeRange.weekly:
        return 7;
      case UsageTimeRange.monthly:
        return 30;
    }
  }
}

final usageStatsLocalDataSourceProvider = Provider<UsageStatsLocalDataSource>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return UsageStatsLocalDataSource(prefs);
});

final usageAggregationServiceProvider = Provider<UsageAggregationService>((
  ref,
) {
  return UsageAggregationService();
});

final usageStatsSyncServiceProvider = Provider<UsageStatsSyncService>((ref) {
  final appsRepo = ref.watch(deviceAppsRepositoryProvider);
  final localStorage = ref.watch(usageStatsLocalDataSourceProvider);
  return UsageStatsSyncService(appsRepo, localStorage);
});

class SelectedUsageTimeRangeNotifier extends Notifier<UsageTimeRange> {
  @override
  UsageTimeRange build() => UsageTimeRange.all;

  void setRange(UsageTimeRange range) {
    state = range;
  }
}

final selectedUsageTimeRangeProvider =
    NotifierProvider<SelectedUsageTimeRangeNotifier, UsageTimeRange>(
      SelectedUsageTimeRangeNotifier.new,
    );

final persistentUsageStatsProvider = FutureProvider<PersistentUsageStats>((
  ref,
) async {
  final appsRepo = ref.watch(deviceAppsRepositoryProvider);
  final localStorage = ref.watch(usageStatsLocalDataSourceProvider);
  final aggregationService = ref.watch(usageAggregationServiceProvider);
  final apps = await ref.watch(installedAppsProvider.future);

  final dataRange = await appsRepo.getAvailableDataRange();
  final storedSnapshots = await localStorage.getDailySnapshots();
  final metadata = await localStorage.getMetadata();

  final systemData = <String, int>{};
  for (final app in apps) {
    if (app.totalTimeInForeground > 0) {
      systemData[app.packageName] = app.totalTimeInForeground;
    }
  }

  final systemOldestDate = dataRange.hasData
      ? DateTime.fromMillisecondsSinceEpoch(dataRange.oldestTimestamp)
      : DateTime.now();

  final aggregatedData = aggregationService.aggregateUsageStats(
    systemData: systemData,
    storedSnapshots: storedSnapshots,
    systemDataOldestDate: systemOldestDate,
  );

  final trackedPeriod = aggregationService.getTotalTrackedPeriod(
    trackingStartDate: metadata.trackingStartDate,
    systemDataOldestDate: systemOldestDate,
  );

  final hasDataGap = aggregationService.detectDataGap(
    snapshots: storedSnapshots,
    systemDataOldestDate: systemOldestDate,
  );

  return PersistentUsageStats(
    aggregatedUsage: aggregatedData,
    trackedPeriod: trackedPeriod,
    hasDataGap: hasDataGap,
    systemAvailableDays: dataRange.availableDays,
    storedSnapshotCount: storedSnapshots.length,
  );
});

final filteredUsageStatsProvider = FutureProvider<PersistentUsageStats>((
  ref,
) async {
  final selectedRange = ref.watch(selectedUsageTimeRangeProvider);

  if (selectedRange == UsageTimeRange.all) {
    return ref.watch(persistentUsageStatsProvider.future);
  }

  final appsRepo = ref.watch(deviceAppsRepositoryProvider);
  final localStorage = ref.watch(usageStatsLocalDataSourceProvider);

  final now = DateTime.now();
  final windowDays = selectedRange.windowDays ?? 1;
  final rangeStart = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(Duration(days: windowDays - 1));

  final systemSnapshots = await appsRepo.getDailyUsageSnapshots(
    startDate: rangeStart.millisecondsSinceEpoch,
    endDate: now.millisecondsSinceEpoch,
  );

  final snapshots = systemSnapshots.isNotEmpty
      ? systemSnapshots
      : (await localStorage.getDailySnapshots()).where((snapshot) {
          final snapshotDate = DateTime.fromMillisecondsSinceEpoch(
            snapshot.timestamp,
          );

          return !snapshotDate.isBefore(rangeStart) &&
              !snapshotDate.isAfter(now);
        }).toList();

  final aggregatedData = <String, int>{};

  for (final snapshot in snapshots) {
    for (final entry in snapshot.appUsages.entries) {
      aggregatedData[entry.key] =
          (aggregatedData[entry.key] ?? 0) + entry.value;
    }
  }

  return PersistentUsageStats(
    aggregatedUsage: aggregatedData,
    trackedPeriod: Duration(days: windowDays),
    hasDataGap: false,
    systemAvailableDays: windowDays,
    storedSnapshotCount: snapshots.length,
  );
});

class PersistentUsageStats {
  final Map<String, int> aggregatedUsage;
  final Duration trackedPeriod;
  final bool hasDataGap;
  final int systemAvailableDays;
  final int storedSnapshotCount;

  PersistentUsageStats({
    required this.aggregatedUsage,
    required this.trackedPeriod,
    required this.hasDataGap,
    required this.systemAvailableDays,
    required this.storedSnapshotCount,
  });

  int getTotalUsageForPackage(String packageName) {
    return aggregatedUsage[packageName] ?? 0;
  }

  int get totalUsageMillis {
    return aggregatedUsage.values.fold(0, (sum, value) => sum + value);
  }
}

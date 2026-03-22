import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../apps/presentation/providers/apps_provider.dart';
import '../../../../core/providers/shared_preferences_provider.dart';
import '../../data/datasources/usage_stats_local_datasource.dart';
import '../../domain/services/usage_aggregation_service.dart';
import '../../domain/services/usage_stats_sync_service.dart';

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

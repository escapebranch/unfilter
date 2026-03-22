import 'package:flutter/foundation.dart';
import '../../../apps/data/repositories/device_apps_repository.dart';
import '../../data/datasources/usage_stats_local_datasource.dart';

class UsageStatsSyncService {
  final DeviceAppsRepository _appsRepo;
  final UsageStatsLocalDataSource _localStorage;

  UsageStatsSyncService(this._appsRepo, this._localStorage);

  Future<void> syncUsageStats() async {
    try {
      debugPrint('[UsageSync] Starting sync...');

      final dataRange = await _appsRepo.getAvailableDataRange();

      if (!dataRange.hasData) {
        debugPrint('[UsageSync] No data available from system');
        return;
      }

      final metadata = await _localStorage.getMetadata();

      final lastSync = metadata.lastSyncDate ??
          DateTime.fromMillisecondsSinceEpoch(dataRange.oldestTimestamp);

      final now = DateTime.now();
      final daysSinceLastSync = now.difference(lastSync).inDays;

      if (daysSinceLastSync == 0 && metadata.lastSyncDate != null) {
        debugPrint('[UsageSync] Already synced today, skipping');
        return;
      }

      final newSnapshots = await _appsRepo.getDailyUsageSnapshots(
        startDate: lastSync.millisecondsSinceEpoch,
        endDate: now.millisecondsSinceEpoch,
      );

      if (newSnapshots.isEmpty) {
        debugPrint('[UsageSync] No new snapshots to save');
        return;
      }

      await _localStorage.saveDailySnapshots(newSnapshots);

      await _localStorage.pruneOldData();

      debugPrint('[UsageSync] Sync complete: ${newSnapshots.length} snapshots');
    } catch (e) {
      debugPrint('[UsageSync] Error: $e');
    }
  }

  Future<void> initializeTracking() async {
    try {
      await _localStorage.initializeTracking();
      debugPrint('[UsageSync] Tracking initialized');
    } catch (e) {
      debugPrint('[UsageSync] Error initializing: $e');
    }
  }
}

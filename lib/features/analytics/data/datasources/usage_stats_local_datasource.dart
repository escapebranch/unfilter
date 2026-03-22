import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsageStatsLocalDataSource {
  final SharedPreferences _prefs;

  static const String _snapshotsKey = 'usage_stats_snapshots_v2';
  static const String _trackingStartKey = 'usage_tracking_start_date';
  static const String _lastSyncKey = 'usage_last_sync_date';

  UsageStatsLocalDataSource(this._prefs);

  Future<void> saveDailySnapshots(List<DailyUsageSnapshot> snapshots) async {
    try {
      final existing = await getDailySnapshots();
      final merged = _mergeSnapshots(existing, snapshots);

      final json = jsonEncode(merged.map((s) => s.toJson()).toList());
      await _prefs.setString(_snapshotsKey, json);
      await _prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());

      debugPrint(
        '[UsageStatsLocal] Saved ${merged.length} snapshots (${snapshots.length} new)',
      );
    } catch (e) {
      debugPrint('[UsageStatsLocal] Error saving snapshots: $e');
    }
  }

  Future<List<DailyUsageSnapshot>> getDailySnapshots() async {
    try {
      final json = _prefs.getString(_snapshotsKey);
      if (json == null || json.isEmpty) return [];

      final List<dynamic> decoded = jsonDecode(json);
      final snapshots = decoded
          .map((e) => DailyUsageSnapshot.fromJson(e as Map<String, dynamic>))
          .toList();

      debugPrint('[UsageStatsLocal] Loaded ${snapshots.length} snapshots');
      return snapshots;
    } catch (e) {
      debugPrint('[UsageStatsLocal] Error loading snapshots: $e');
      return [];
    }
  }

  List<DailyUsageSnapshot> _mergeSnapshots(
    List<DailyUsageSnapshot> existing,
    List<DailyUsageSnapshot> newSnapshots,
  ) {
    final Map<String, DailyUsageSnapshot> merged = {};

    for (final snapshot in existing) {
      merged[snapshot.date] = snapshot;
    }

    for (final snapshot in newSnapshots) {
      merged[snapshot.date] = snapshot;
    }

    final sorted = merged.values.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return sorted;
  }

  Future<UsageTrackingMetadata> getMetadata() async {
    try {
      final startDate = _prefs.getString(_trackingStartKey);
      final lastSync = _prefs.getString(_lastSyncKey);

      return UsageTrackingMetadata(
        trackingStartDate:
            startDate != null ? DateTime.parse(startDate) : null,
        lastSyncDate: lastSync != null ? DateTime.parse(lastSync) : null,
      );
    } catch (e) {
      debugPrint('[UsageStatsLocal] Error loading metadata: $e');
      return UsageTrackingMetadata();
    }
  }

  Future<void> initializeTracking() async {
    try {
      final existing = _prefs.getString(_trackingStartKey);
      if (existing == null) {
        await _prefs.setString(
          _trackingStartKey,
          DateTime.now().toIso8601String(),
        );
        debugPrint('[UsageStatsLocal] Initialized tracking');
      }
    } catch (e) {
      debugPrint('[UsageStatsLocal] Error initializing tracking: $e');
    }
  }

  Future<void> pruneOldData() async {
    try {
      final snapshots = await getDailySnapshots();
      final twoYearsAgo = DateTime.now().subtract(const Duration(days: 730));

      final filtered = snapshots.where((s) {
        final snapshotDate = DateTime.fromMillisecondsSinceEpoch(s.timestamp);
        return snapshotDate.isAfter(twoYearsAgo);
      }).toList();

      if (filtered.length < snapshots.length) {
        final json = jsonEncode(filtered.map((s) => s.toJson()).toList());
        await _prefs.setString(_snapshotsKey, json);
        debugPrint(
          '[UsageStatsLocal] Pruned ${snapshots.length - filtered.length} old snapshots',
        );
      }
    } catch (e) {
      debugPrint('[UsageStatsLocal] Error pruning data: $e');
    }
  }

  Future<void> clearAllData() async {
    try {
      await _prefs.remove(_snapshotsKey);
      await _prefs.remove(_trackingStartKey);
      await _prefs.remove(_lastSyncKey);
      debugPrint('[UsageStatsLocal] Cleared all usage stats data');
    } catch (e) {
      debugPrint('[UsageStatsLocal] Error clearing data: $e');
    }
  }
}

class DailyUsageSnapshot {
  final String date;
  final int timestamp;
  final Map<String, int> appUsages;

  DailyUsageSnapshot({
    required this.date,
    required this.timestamp,
    required this.appUsages,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'timestamp': timestamp,
        'appUsages': appUsages,
      };

  factory DailyUsageSnapshot.fromJson(Map<String, dynamic> json) {
    return DailyUsageSnapshot(
      date: json['date'] as String,
      timestamp: json['timestamp'] as int,
      appUsages: Map<String, int>.from(json['appUsages'] as Map),
    );
  }
}

class UsageTrackingMetadata {
  final DateTime? trackingStartDate;
  final DateTime? lastSyncDate;

  UsageTrackingMetadata({
    this.trackingStartDate,
    this.lastSyncDate,
  });
}

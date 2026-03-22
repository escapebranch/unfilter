import 'package:flutter/foundation.dart';
import '../../data/datasources/usage_stats_local_datasource.dart';

class UsageAggregationService {
  Map<String, int> aggregateUsageStats({
    required Map<String, int> systemData,
    required List<DailyUsageSnapshot> storedSnapshots,
    required DateTime systemDataOldestDate,
  }) {
    final Map<String, int> aggregated = {};

    for (final snapshot in storedSnapshots) {
      final snapshotDate =
          DateTime.fromMillisecondsSinceEpoch(snapshot.timestamp);

      if (snapshotDate.isBefore(systemDataOldestDate)) {
        for (final entry in snapshot.appUsages.entries) {
          aggregated[entry.key] = (aggregated[entry.key] ?? 0) + entry.value;
        }
      }
    }

    for (final entry in systemData.entries) {
      aggregated[entry.key] = (aggregated[entry.key] ?? 0) + entry.value;
    }

    debugPrint(
      '[UsageAggregation] Aggregated ${aggregated.length} apps (${systemData.length} from system, ${storedSnapshots.length} snapshots)',
    );

    return aggregated;
  }

  Duration getTotalTrackedPeriod({
    required DateTime? trackingStartDate,
    required DateTime systemDataOldestDate,
  }) {
    if (trackingStartDate == null) {
      return DateTime.now().difference(systemDataOldestDate);
    }

    final earliest = trackingStartDate.isBefore(systemDataOldestDate)
        ? trackingStartDate
        : systemDataOldestDate;

    return DateTime.now().difference(earliest);
  }

  bool detectDataGap({
    required List<DailyUsageSnapshot> snapshots,
    required DateTime systemDataOldestDate,
  }) {
    if (snapshots.isEmpty) return false;

    final latestSnapshot = snapshots.last;
    final latestSnapshotDate =
        DateTime.fromMillisecondsSinceEpoch(latestSnapshot.timestamp);

    final gap = systemDataOldestDate.difference(latestSnapshotDate).inDays;
    return gap > 2;
  }

  String formatTrackedPeriod(Duration period) {
    final days = period.inDays;

    if (days >= 365) {
      final years = (days / 365).floor();
      final remainingMonths = ((days % 365) / 30).floor();
      if (remainingMonths > 0) {
        return '$years year${years > 1 ? 's' : ''}, $remainingMonths month${remainingMonths > 1 ? 's' : ''}';
      }
      return '$years year${years > 1 ? 's' : ''}';
    } else if (days >= 30) {
      final months = (days / 30).floor();
      return '$months month${months > 1 ? 's' : ''}';
    } else if (days >= 7) {
      final weeks = (days / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''}';
    } else {
      return '$days day${days > 1 ? 's' : ''}';
    }
  }
}

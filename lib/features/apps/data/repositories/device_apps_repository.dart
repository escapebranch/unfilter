import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/device_app.dart';
import '../../../scan/domain/entities/scan_progress.dart';
import '../datasources/apps_local_datasource.dart';
import '../../domain/entities/app_usage_point.dart';
import '../../../analytics/data/datasources/usage_stats_local_datasource.dart';

class DeviceAppsRepository {
  static const platform = MethodChannel('com.escapebranch.unfilter/apps');
  static const eventChannel = EventChannel(
    'com.escapebranch.unfilter/scan_progress',
  );

  Completer<List<DeviceApp>>? _scanInProgress;
  bool _lastScanIncludedDetails = false;

  Stream<ScanProgress> get scanProgressStream {
    return eventChannel.receiveBroadcastStream().map((event) {
      if (event is Map) {
        return ScanProgress.fromMap(event);
      }
      return ScanProgress(
        status: "Initializing",
        percent: 0,
        processedCount: 0,
        totalCount: 0,
      );
    });
  }

  final AppsLocalDataSource _localDataSource = AppsLocalDataSource();

  Future<List<DeviceApp>> getInstalledApps({
    bool forceRefresh = false,
    bool includeDetails = true,
  }) async {
    if (!forceRefresh && includeDetails) {
      final cachedApps = await _localDataSource.getCachedApps();
      if (cachedApps.isNotEmpty) {
        return cachedApps;
      }
    }

    if (_scanInProgress != null && _lastScanIncludedDetails == includeDetails) {
      try {
        return await _scanInProgress!.future;
      } catch (e) {
        // Ignore errors from previous scan
      }
    }

    final completer = Completer<List<DeviceApp>>();
    _scanInProgress = completer;
    _lastScanIncludedDetails = includeDetails;

    try {
      final dynamic rawResult = await platform.invokeMethod(
        'getInstalledApps',
        {'includeDetails': includeDetails},
      );

      List<DeviceApp> apps;

      // Check if native side is using chunked transfer (to avoid Binder 1MB limit)
      if (rawResult is Map && rawResult['chunked'] == true) {
        final int totalApps = rawResult['totalApps'] as int;
        final int totalChunks = rawResult['totalChunks'] as int;
        debugPrint(
          "[DeviceAppsRepo] Chunked transfer: $totalApps apps in $totalChunks chunks",
        );

        final allMaps = <Map<String, dynamic>>[];

        for (int i = 0; i < totalChunks; i++) {
          try {
            final List<Object?> chunk = await platform.invokeMethod(
              'getAppChunk',
              {'chunkIndex': i},
            );
            allMaps.addAll(
              chunk.cast<Map<Object?, Object?>>().map(
                (e) => Map<String, dynamic>.from(e),
              ),
            );
            debugPrint(
              "[DeviceAppsRepo] Chunk $i/${totalChunks - 1}: ${chunk.length} apps received",
            );
          } catch (e) {
            debugPrint("[DeviceAppsRepo] Chunk $i failed: $e, continuing...");
            // Continue with remaining chunks even if one fails
          }
        }

        apps = allMaps.map((e) => DeviceApp.fromMap(e)).toList();
      } else {
        // Legacy non-chunked transfer (small device with few apps, or non-detailed scan)
        final List<Object?> result = (rawResult as List<Object?>);
        apps = result
            .cast<Map<Object?, Object?>>()
            .map((e) => DeviceApp.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      }

      if (includeDetails) {
        await _localDataSource.cacheApps(apps);
      }

      completer.complete(apps);
      return apps;
    } on PlatformException catch (e) {
      if (e.code == 'ABORTED') {
        debugPrint("Scan was superseded, will retry once...");
        _scanInProgress = null;
        await Future.delayed(const Duration(milliseconds: 200));
        return getInstalledApps(
          forceRefresh: forceRefresh,
          includeDetails: includeDetails,
        );
      }
      debugPrint("Failed to get apps: '${e.message}'");
      completer.completeError(e);
      rethrow;
    } catch (e) {
      debugPrint("Failed to get apps: '$e'");
      completer.completeError(e);
      rethrow;
    } finally {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_scanInProgress == completer) {
          _scanInProgress = null;
        }
      });
    }
  }

  Future<List<DeviceApp>> getAppsDetails(List<String> packageNames) async {
    final allApps = <DeviceApp>[];
    const int batchSize = 10;

    for (var i = 0; i < packageNames.length; i += batchSize) {
      final end = (i + batchSize < packageNames.length)
          ? i + batchSize
          : packageNames.length;
      final batch = packageNames.sublist(i, end);

      try {
        final List<Object?> result = await platform.invokeMethod(
          'getAppsDetails',
          {'packageNames': batch},
        );

        allApps.addAll(
          result.cast<Map<Object?, Object?>>().map(
            (e) => DeviceApp.fromMap(Map<String, dynamic>.from(e)),
          ),
        );
      } on PlatformException catch (e) {
        debugPrint("Failed to get app details chunk: '${e.message}'");
      }
    }
    return allApps;
  }

  Future<bool> checkUsagePermission() async {
    try {
      final bool result = await platform.invokeMethod('checkUsagePermission');
      return result;
    } on PlatformException catch (e) {
      debugPrint("Failed to check permission: '${e.message}'");
      return false;
    }
  }

  Future<void> requestUsagePermission() async {
    try {
      await platform.invokeMethod('requestUsagePermission');
    } on PlatformException catch (e) {
      debugPrint("Failed to request permission: '${e.message}'");
    }
  }

  Future<bool> checkInstallPermission() async {
    try {
      final bool result = await platform.invokeMethod('checkInstallPermission');
      return result;
    } on PlatformException catch (e) {
      debugPrint("Failed to check install permission: '${e.message}'");
      return false;
    }
  }

  Future<void> requestInstallPermission() async {
    try {
      await platform.invokeMethod('requestInstallPermission');
    } on PlatformException catch (e) {
      debugPrint("Failed to request install permission: '${e.message}'");
    }
  }

  Future<List<AppUsagePoint>> getAppUsageHistory(
    String packageName, {
    int? installTime,
  }) async {
    try {
      final List<Object?> result = await platform
          .invokeMethod('getAppUsageHistory', {
            'packageName': packageName,
            if (installTime != null) 'installTime': installTime,
          });
      return result
          .cast<Map<Object?, Object?>>()
          .map((e) => AppUsagePoint.fromMap(e))
          .toList();
    } on PlatformException catch (e) {
      debugPrint("Failed to get usage history: '${e.message}'");
      return [];
    }
  }

  Future<void> updateCache(List<DeviceApp> apps) async {
    await _localDataSource.cacheApps(apps);
  }

  Future<void> clearCache() async {
    await _localDataSource.clearCache();
    try {
      await platform.invokeMethod('clearScanCache');
    } catch (_) {
      // Ignore error during cache clearing
    }
  }

  Future<UsageDataRange> getAvailableDataRange() async {
    try {
      final Map<dynamic, dynamic> result = await platform.invokeMethod(
        'getAvailableDataRange',
      );

      return UsageDataRange(
        oldestTimestamp: result['oldestTimestamp'] as int? ?? 0,
        newestTimestamp: result['newestTimestamp'] as int? ?? 0,
        availableDays: result['availableDays'] as int? ?? 0,
        hasData: result['hasData'] as bool? ?? false,
      );
    } on PlatformException catch (e) {
      debugPrint("Failed to get available data range: '${e.message}'");
      return UsageDataRange(
        oldestTimestamp: 0,
        newestTimestamp: 0,
        availableDays: 0,
        hasData: false,
      );
    }
  }

  Future<List<DailyUsageSnapshot>> getDailyUsageSnapshots({
    required int startDate,
    required int endDate,
  }) async {
    try {
      final List<dynamic> result = await platform.invokeMethod(
        'getDailyUsageSnapshots',
        {'startDate': startDate, 'endDate': endDate},
      );

      return result.map((snapshot) {
        final map = snapshot as Map<dynamic, dynamic>;
        final appUsages = map['appUsages'] as Map<dynamic, dynamic>;

        return DailyUsageSnapshot(
          date: map['date'] as String,
          timestamp: map['timestamp'] as int,
          appUsages: appUsages.map(
            (key, value) => MapEntry(key as String, value as int),
          ),
        );
      }).toList();
    } on PlatformException catch (e) {
      debugPrint("Failed to get daily usage snapshots: '${e.message}'");
      return [];
    }
  }
}

class UsageDataRange {
  final int oldestTimestamp;
  final int newestTimestamp;
  final int availableDays;
  final bool hasData;

  UsageDataRange({
    required this.oldestTimestamp,
    required this.newestTimestamp,
    required this.availableDays,
    required this.hasData,
  });
}

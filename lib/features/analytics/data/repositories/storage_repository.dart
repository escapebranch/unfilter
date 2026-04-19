import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/storage_breakdown.dart';

class StorageRepository {
  static const _channel = MethodChannel('com.escapebranch.unfilter/apps');

  Future<StorageBreakdown> getStorageBreakdown(
    String packageName, {
    bool detailed = false,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      debugPrint('🔍 StorageRepository.getStorageBreakdown:');
      debugPrint('   📦 Package: $packageName');
      debugPrint(
        '   🎯 Detailed: $detailed ${detailed ? "(DEEP SCAN)" : "(QUICK SCAN)"}',
      );

      final result = await _channel
          .invokeMethod('getStorageBreakdown', {
            'packageName': packageName,
            'detailed': detailed,
          })
          .timeout(timeout);

      debugPrint('✅ Platform returned result for $packageName');

      if (result == null) {
        throw PlatformException(
          code: 'NULL_RESULT',
          message: 'Platform returned null result',
        );
      }

      final breakdown = StorageBreakdown.fromMap(
        result as Map<Object?, Object?>,
      );
      debugPrint(
        '📊 Total: ${breakdown.totalCombined} bytes, Confidence: ${(breakdown.confidenceLevel * 100).toInt()}%',
      );
      debugPrint(
        '   ${breakdown.limitations.isEmpty ? "No limitations" : "Limitations: ${breakdown.limitations.length}"}',
      );

      return breakdown;
    } on TimeoutException {
      debugPrint('⏱️ TIMEOUT for $packageName after $timeout');
      try {
        await cancelAnalysis(packageName);
      } catch (_) {}

      throw PlatformException(
        code: 'TIMEOUT',
        message: 'Storage analysis timed out - app may be too large',
      );
    } on PlatformException {
      rethrow;
    } catch (e) {
      debugPrint('❌ ERROR in getStorageBreakdown: $e');
      throw PlatformException(
        code: 'UNKNOWN_ERROR',
        message: 'Storage analysis failed: $e',
      );
    }
  }

  Future<Map<String, StorageBreakdown>> getStorageBreakdownBatch(
    List<String> packageNames, {
    bool detailed = false,
    void Function(int current, int total)? onProgress,
  }) async {
    final results = <String, StorageBreakdown>{};
    var current = 0;

    // Synchronize concurrency explicitly with Android Native fixed pool (2 threads).
    // If >2, Flutter futures will time out while queuing on the native side.
    const concurrencyLimit = 2;
    for (var i = 0; i < packageNames.length; i += concurrencyLimit) {
      final chunk = packageNames.sublist(
        i,
        i + concurrencyLimit > packageNames.length
            ? packageNames.length
            : i + concurrencyLimit,
      );

      final futures = chunk.map((packageName) async {
        try {
          final breakdown = await getStorageBreakdown(
            packageName,
            detailed: detailed,
          );
          return MapEntry(packageName, breakdown);
        } catch (e) {
          // Error for one app shouldn't stop the whole batch
          return null;
        }
      });

      final chunkResults = await Future.wait(futures);
      for (final result in chunkResults) {
        if (result != null) {
          results[result.key] = result.value;
        }
        current++;
        onProgress?.call(current, packageNames.length);
      }
    }

    return results;
  }

  Future<void> cancelAnalysis(String packageName) async {
    try {
      await _channel.invokeMethod('cancelStorageAnalysis', {
        'packageName': packageName,
      });
    } catch (e) {
      // Ignore repository error
    }
  }

  Future<void> cancelAll() async {
    try {
      await _channel.invokeMethod('cancelStorageAnalysis');
    } catch (e) {
      // Ignore repository error
    }
  }

  Future<void> clearCache() async {
    try {
      await _channel.invokeMethod('clearStorageCache');
    } catch (e) {
      // Ignore repository error
    }
  }
}

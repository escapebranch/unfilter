import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'update_service.dart';

const _kVersionConfigUrl =
    'https://raw.githubusercontent.com/r4khul/unfilter/main/version_config.json';
const _kCacheKey = 'release_notes_cache_v1';
const _kCacheTimestampKey = 'release_notes_cache_ts_v1';
const _kCacheTtl = Duration(hours: 6);

class ReleaseNotesData {
  final String latestVersion;
  final String releasePageUrl;
  final String apkDirectDownloadUrl;
  final String releaseNotes;
  final List<String> features;
  final List<String> fixes;
  final bool forceUpdate;
  final bool isUpdateAvailable;

  const ReleaseNotesData({
    required this.latestVersion,
    required this.releasePageUrl,
    required this.apkDirectDownloadUrl,
    required this.releaseNotes,
    required this.features,
    required this.fixes,
    required this.forceUpdate,
    required this.isUpdateAvailable,
  });

  factory ReleaseNotesData.fromJson(
    Map<String, dynamic> json,
    String currentVersion,
  ) {
    final latestRaw = (json['latest_native_version'] as String? ?? '').split('+').first;
    final currentRaw = currentVersion.split('+').first;

    bool updateAvailable = false;
    try {
      final latest = Version.parse(latestRaw);
      final current = Version.parse(currentRaw);
      updateAvailable = latest > current;
    } catch (_) {
      updateAvailable = latestRaw != currentRaw;
    }

    return ReleaseNotesData(
      latestVersion: json['latest_native_version'] as String? ?? '',
      releasePageUrl: json['release_page_url'] as String? ?? '',
      apkDirectDownloadUrl: json['apk_direct_download_url'] as String? ?? '',
      releaseNotes: json['release_notes'] as String? ?? '',
      features: List<String>.from(json['features'] as List? ?? []),
      fixes: List<String>.from(json['fixes'] as List? ?? []),
      forceUpdate: json['force_update'] as bool? ?? false,
      isUpdateAvailable: updateAvailable,
    );
  }
}

class ReleaseNotesNotifier extends AsyncNotifier<ReleaseNotesData?> {
  @override
  Future<ReleaseNotesData?> build() async {
    return _load();
  }

  Future<ReleaseNotesData?> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    final cachedJson = prefs.getString(_kCacheKey);
    final cachedTs = prefs.getInt(_kCacheTimestampKey);
    final now = DateTime.now().millisecondsSinceEpoch;
    final isCacheValid = cachedJson != null &&
        cachedTs != null &&
        (now - cachedTs) < _kCacheTtl.inMilliseconds;

    if (isCacheValid) {
      try {
        final decoded = json.decode(cachedJson) as Map<String, dynamic>;
        return ReleaseNotesData.fromJson(decoded, currentVersion);
      } catch (e) {
        debugPrint('[ReleaseNotes] DEBUG: Cache decode failed: $e');
      }
    }

    return _fetchRemote(prefs, currentVersion);
  }

  Future<ReleaseNotesData?> _fetchRemote(
    SharedPreferences prefs,
    String currentVersion,
  ) async {
    try {
      final response = await http
          .get(Uri.parse(_kVersionConfigUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        debugPrint(
          '[ReleaseNotes] ERROR: Remote fetch failed with status ${response.statusCode}',
        );
        return null;
      }

      final raw = response.body;
      await prefs.setString(_kCacheKey, raw);
      await prefs.setInt(
        _kCacheTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      final decoded = json.decode(raw) as Map<String, dynamic>;
      return ReleaseNotesData.fromJson(decoded, currentVersion);
    } catch (e) {
      debugPrint('[ReleaseNotes] ERROR: Remote fetch exception: $e');

      final cachedJson = prefs.getString(_kCacheKey);
      if (cachedJson != null) {
        try {
          final decoded = json.decode(cachedJson) as Map<String, dynamic>;
          return ReleaseNotesData.fromJson(decoded, currentVersion);
        } catch (_) {}
      }

      return null;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kCacheKey);
      await prefs.remove(_kCacheTimestampKey);
      final packageInfo = await PackageInfo.fromPlatform();
      return _fetchRemote(prefs, packageInfo.version);
    });
  }
}

final releaseNotesProvider =
    AsyncNotifierProvider<ReleaseNotesNotifier, ReleaseNotesData?>(
  ReleaseNotesNotifier.new,
);

final inAppUpdateInfoProvider = FutureProvider<InAppUpdateInfo>((ref) async {
  final service = UpdateService();
  return service.checkForUpdate();
});

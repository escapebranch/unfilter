import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum InAppUpdateAvailability {
  available,
  inProgress,
  notAvailable,
  unknown,
}

enum InAppUpdateInstallStatus {
  canceled,
  downloaded,
  downloading,
  failed,
  installed,
  installing,
  pending,
  unknown,
}

class InAppUpdateInfo {
  final InAppUpdateAvailability availability;
  final int availableVersionCode;
  final int updatePriority;
  final bool isFlexibleUpdateAllowed;
  final bool isImmediateUpdateAllowed;
  final int bytesDownloaded;
  final int totalBytesToDownload;

  InAppUpdateInfo({
    required this.availability,
    required this.availableVersionCode,
    required this.updatePriority,
    required this.isFlexibleUpdateAllowed,
    required this.isImmediateUpdateAllowed,
    required this.bytesDownloaded,
    required this.totalBytesToDownload,
  });

  factory InAppUpdateInfo.fromMap(Map<dynamic, dynamic> map) {
    return InAppUpdateInfo(
      availability: _parseAvailability(map['availability']),
      availableVersionCode: map['availableVersionCode'] ?? 0,
      updatePriority: map['updatePriority'] ?? 0,
      isFlexibleUpdateAllowed: map['isFlexibleUpdateAllowed'] ?? false,
      isImmediateUpdateAllowed: map['isImmediateUpdateAllowed'] ?? false,
      bytesDownloaded: map['bytesDownloaded'] ?? 0,
      totalBytesToDownload: map['totalBytesToDownload'] ?? 0,
    );
  }

  static InAppUpdateAvailability _parseAvailability(String? value) {
    switch (value) {
      case 'AVAILABLE':
        return InAppUpdateAvailability.available;
      case 'IN_PROGRESS':
        return InAppUpdateAvailability.inProgress;
      case 'NOT_AVAILABLE':
        return InAppUpdateAvailability.notAvailable;
      default:
        return InAppUpdateAvailability.unknown;
    }
  }
}

class InAppUpdateInstallState {
  final InAppUpdateInstallStatus status;
  final int bytesDownloaded;
  final int totalBytesToDownload;
  final int installErrorCode;

  InAppUpdateInstallState({
    required this.status,
    required this.bytesDownloaded,
    required this.totalBytesToDownload,
    required this.installErrorCode,
  });

  factory InAppUpdateInstallState.fromMap(Map<dynamic, dynamic> map) {
    return InAppUpdateInstallState(
      status: _parseStatus(map['status']),
      bytesDownloaded: map['bytesDownloaded'] ?? 0,
      totalBytesToDownload: map['totalBytesToDownload'] ?? 0,
      installErrorCode: map['installErrorCode'] ?? 0,
    );
  }

  static InAppUpdateInstallStatus _parseStatus(String? value) {
    switch (value) {
      case 'CANCELED':
        return InAppUpdateInstallStatus.canceled;
      case 'DOWNLOADED':
        return InAppUpdateInstallStatus.downloaded;
      case 'DOWNLOADING':
        return InAppUpdateInstallStatus.downloading;
      case 'FAILED':
        return InAppUpdateInstallStatus.failed;
      case 'INSTALLED':
        return InAppUpdateInstallStatus.installed;
      case 'INSTALLING':
        return InAppUpdateInstallStatus.installing;
      case 'PENDING':
        return InAppUpdateInstallStatus.pending;
      default:
        return InAppUpdateInstallStatus.unknown;
    }
  }
}

class UpdateService {
  static const MethodChannel _channel = MethodChannel(
    'com.escapebranch.unfilter/update',
  );
  static const EventChannel _eventChannel = EventChannel(
    'com.escapebranch.unfilter/update_events',
  );

  Stream<InAppUpdateInstallState>? _updateEvents;

  Stream<InAppUpdateInstallState> get updateEvents {
    _updateEvents ??= _eventChannel
        .receiveBroadcastStream()
        .map((event) => InAppUpdateInstallState.fromMap(event as Map));
    return _updateEvents!;
  }

  Future<InAppUpdateInfo> checkForUpdate() async {
    try {
      final Map<dynamic, dynamic>? result = await _channel.invokeMethod(
        'checkForUpdate',
      );
      if (result == null) throw Exception('Failed to check for update');
      return InAppUpdateInfo.fromMap(result);
    } on PlatformException catch (e) {
      debugPrint('[UpdateService] Error checking for update: ${e.message}');
      rethrow;
    }
  }

  Future<void> startFlexibleUpdate() async {
    try {
      await _channel.invokeMethod('startUpdate', {'type': 'FLEXIBLE'});
    } on PlatformException catch (e) {
      debugPrint('[UpdateService] Error starting flexible update: ${e.message}');
      rethrow;
    }
  }

  Future<void> completeUpdate() async {
    try {
      await _channel.invokeMethod('completeUpdate');
    } on PlatformException catch (e) {
      debugPrint('[UpdateService] Error completing update: ${e.message}');
      rethrow;
    }
  }
}

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive_io.dart';

class LogEntry {
  final DateTime timestamp;
  final String message;
  final String level;
  final String? tag;

  LogEntry({
    required this.timestamp,
    required this.message,
    this.level = 'INFO',
    this.tag,
  });

  String get formattedTimestamp => DateFormat('HH:mm:ss.SSS').format(timestamp);

  @override
  String toString() {
    final tagStr = tag != null ? '[$tag] ' : '';
    return '[$formattedTimestamp] [$level] $tagStr$message';
  }
}

class LoggingService {
  static final LoggingService _instance = LoggingService._internal();
  factory LoggingService() => _instance;
  LoggingService._internal();

  final List<LogEntry> _logs = [];
  final _logController = StreamController<List<LogEntry>>.broadcast();

  Stream<List<LogEntry>> get logStream => _logController.stream;
  List<LogEntry> get logs => List.unmodifiable(_logs);

  void init() {
    final originalDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) {
        _addLog(message);
      }
      originalDebugPrint(message, wrapWidth: wrapWidth);
    };
  }

  void info(String message, {String? tag}) => _addLog(message, level: 'INFO', tag: tag);
  void debug(String message, {String? tag}) => _addLog(message, level: 'DEBUG', tag: tag);
  void error(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    var fullMessage = message;
    if (error != null) fullMessage += '\nError: $error';
    if (stackTrace != null) fullMessage += '\nStackTrace: $stackTrace';
    _addLog(fullMessage, level: 'ERROR', tag: tag);
  }

  void _addLog(String message, {String? level, String? tag}) {
    String detectedLevel = level ?? 'INFO';
    String cleanMessage = message;

    // If level is not explicitly provided, try to detect it from message prefix
    if (level == null) {
      if (message.toUpperCase().contains('ERROR') || message.toUpperCase().contains('EXCEPTION') || message.contains('❌') || message.contains('⚠️') || message.contains('🛑')) {
        detectedLevel = 'ERROR';
      } else if (message.toUpperCase().contains('DEBUG') || message.contains('🔍') || message.contains('🔵')) {
        detectedLevel = 'DEBUG';
      }
    }

    // Remove common icons and prefixes from the message for professional look
    cleanMessage = cleanMessage
        .replaceAll(RegExp(r'[⚠️🔍🔵✨🚀🛠️📱📦🔑🔐💡🛑✅❌⏱️❄️🌫️➡️⬅️🗑️]'), '')
        .trim();

    final entry = LogEntry(
      timestamp: DateTime.now(),
      message: cleanMessage,
      level: detectedLevel,
      tag: tag,
    );
    
    _logs.add(entry);
    
    // Keep last 2000 logs to prevent memory leaks
    if (_logs.length > 2000) {
      _logs.removeAt(0);
    }
    
    _logController.add(logs);
  }

  Future<File> exportLogs() async {
    final directory = await getTemporaryDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final logFileName = 'unfilter-log-$timestamp.txt';
    final logFile = File('${directory.path}/$logFileName');
    
    final buffer = StringBuffer();
    buffer.writeln('Unfilter App Logs - Exported at ${DateTime.now()}');
    buffer.writeln('--------------------------------------------------');
    for (var log in _logs) {
      buffer.writeln(log.toString());
    }
    await logFile.writeAsString(buffer.toString());

    final zipFile = File('${directory.path}/unfilter-log-$timestamp.zip');
    final encoder = ZipFileEncoder();
    encoder.create(zipFile.path);
    encoder.addFile(logFile);
    encoder.close();

    // Clean up the text file after zipping
    if (await logFile.exists()) {
      await logFile.delete();
    }

    return zipFile;
  }

  void clearLogs() {
    _logs.clear();
    _logController.add(logs);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/logging_service.dart';

final loggingServiceProvider = Provider<LoggingService>((ref) {
  return LoggingService();
});

final logsProvider = StreamProvider<List<LogEntry>>((ref) {
  final service = ref.watch(loggingServiceProvider);
  return service.logStream;
});

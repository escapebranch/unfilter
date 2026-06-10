import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/shared_preferences_provider.dart';
import 'update_service.dart';
import 'review_service.dart';

final updateServiceProvider = Provider<UpdateService>((ref) {
  return UpdateService();
});

final reviewServiceProvider = Provider<ReviewService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ReviewService(prefs);
});

final updateInfoProvider = FutureProvider<InAppUpdateInfo>((ref) async {
  final service = ref.watch(updateServiceProvider);
  return service.checkForUpdate();
});

final updateEventsProvider = StreamProvider<InAppUpdateInstallState>((ref) {
  final service = ref.watch(updateServiceProvider);
  return service.updateEvents;
});

class DismissedUpdateNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void dismiss() => state = true;
}

final dismissedUpdateProvider = NotifierProvider<DismissedUpdateNotifier, bool>(() {
  return DismissedUpdateNotifier();
});

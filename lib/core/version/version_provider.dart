import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'update_service.dart';

final updateServiceProvider = Provider<UpdateService>((ref) {
  return UpdateService();
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

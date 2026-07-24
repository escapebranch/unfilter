import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unfilter/core/providers/shared_preferences_provider.dart';
import 'package:unfilter/features/home/presentation/providers/smart_scan_hint_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('SmartScanHintNotifier triggers strictly on 2nd, 4th, and 8th app opens', () async {
    // Test 1st open (session = 1)
    SmartScanHintNotifier.resetSessionFlag();
    SharedPreferences.setMockInitialValues({'app_open_count': 0});
    final prefs1 = await SharedPreferences.getInstance();
    final container1 = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs1)],
    );
    expect(container1.read(smartScanHintProvider), false);
    expect(prefs1.getInt('app_open_count'), 1);
    container1.dispose();

    // Test 2nd open (session = 2)
    SmartScanHintNotifier.resetSessionFlag();
    SharedPreferences.setMockInitialValues({'app_open_count': 1});
    final prefs2 = await SharedPreferences.getInstance();
    final container2 = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs2)],
    );
    // Dismiss session 2
    await container2.read(smartScanHintProvider.notifier).dismiss();
    expect(prefs2.getInt('smart_scan_hint_dismissed_session'), 2);
    container2.dispose();

    // Test 3rd open (session = 3) -> should not trigger
    SmartScanHintNotifier.resetSessionFlag();
    SharedPreferences.setMockInitialValues({'app_open_count': 2});
    final prefs3 = await SharedPreferences.getInstance();
    final container3 = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs3)],
    );
    expect(container3.read(smartScanHintProvider), false);
    container3.dispose();

    // Test 4th open (session = 4) -> triggers target session 4
    SmartScanHintNotifier.resetSessionFlag();
    SharedPreferences.setMockInitialValues({'app_open_count': 3});
    final prefs4 = await SharedPreferences.getInstance();
    final container4 = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs4)],
    );
    await container4.read(smartScanHintProvider.notifier).dismiss();
    expect(prefs4.getInt('smart_scan_hint_dismissed_session'), 4);
    container4.dispose();

    // Test 8th open (session = 8) -> triggers target session 8
    SmartScanHintNotifier.resetSessionFlag();
    SharedPreferences.setMockInitialValues({'app_open_count': 7});
    final prefs8 = await SharedPreferences.getInstance();
    final container8 = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs8)],
    );
    await container8.read(smartScanHintProvider.notifier).dismiss();
    expect(prefs8.getInt('smart_scan_hint_dismissed_session'), 8);
    container8.dispose();

    // Test 9th open (session = 9) -> should not trigger
    SmartScanHintNotifier.resetSessionFlag();
    SharedPreferences.setMockInitialValues({'app_open_count': 8});
    final prefs9 = await SharedPreferences.getInstance();
    final container9 = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs9)],
    );
    expect(container9.read(smartScanHintProvider), false);
    container9.dispose();
  });
}

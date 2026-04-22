import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unfilter/core/providers/shared_preferences_provider.dart';

const String localePrefKey = "app_locale_code";

final localeProvider = NotifierProvider<LocaleProvider, Locale?>(
  LocaleProvider.new
);

class LocaleProvider extends Notifier<Locale?> {
  @override
  Locale? build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final savedCode = prefs.getString(localePrefKey);

    if(savedCode == null || savedCode.isEmpty) return null;

    return Locale(savedCode);
  }

  Future<void> setLocale(String languageCode) async {
    state = Locale(languageCode);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(localePrefKey, languageCode);
  }

  Future<void> clearLocale() async {
    state = null;
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.remove(localePrefKey);
  }
}
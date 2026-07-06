import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/language.dart';

final languagesProvider = Provider<List<Language>>((ref) {
  return const [
    Language(
      name: 'English',
      nativeName: 'English',
      code: 'en',
      translationProgress: 100,
    ),
    Language(
      name: 'Tamil',
      nativeName: 'தமிழ்',
      code: 'ta',
      translationProgress: 90,
    ),
    Language(
      name: 'Turkish',
      nativeName: 'Türkçe',
      code: 'tr',
      translationProgress: 82,
    ),
    Language(
      name: 'Indonesian',
      nativeName: 'Bahasa Indonesia',
      code: 'id',
      translationProgress: 90,
    ),
    Language(
      name: 'Hindi',
      nativeName: 'हिन्दी',
      code: 'hi',
      translationProgress: 90,
    ),
  ];
});

class LanguageSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final languageSearchQueryProvider =
    NotifierProvider<LanguageSearchQuery, String>(LanguageSearchQuery.new);

final filteredLanguagesProvider = Provider<List<Language>>((ref) {
  final languages = ref.watch(languagesProvider);
  final query = ref.watch(languageSearchQueryProvider).toLowerCase();

  if (query.isEmpty) return languages;

  return languages.where((lang) {
    return lang.name.toLowerCase().contains(query) ||
        lang.nativeName.toLowerCase().contains(query) ||
        lang.code.toLowerCase().contains(query);
  }).toList();
});

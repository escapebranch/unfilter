class Language {
  final String name;
  final String nativeName;
  final String code;
  final int translationProgress;

  const Language({
    required this.name,
    required this.nativeName,
    required this.code,
    this.translationProgress = 100,
  });
}

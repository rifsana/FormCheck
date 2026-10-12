enum LanguageSupportStatus { ready, underReview }

class AppLanguage {
  final String code;
  final String englishName;
  final String nativeName;
  final bool isRtl;
  final LanguageSupportStatus status;

  const AppLanguage({
    required this.code,
    required this.englishName,
    required this.nativeName,
    this.isRtl = false,
    required this.status,
  });

  bool get isReady => status == LanguageSupportStatus.ready;

  static const List<AppLanguage> supportedLanguages = [
    AppLanguage(
      code: 'en',
      englishName: 'English',
      nativeName: 'English',
      status: LanguageSupportStatus.ready,
    ),
    AppLanguage(
      code: 'hi',
      englishName: 'Hindi',
      nativeName: 'हिन्दी',
      status: LanguageSupportStatus.ready,
    ),
    AppLanguage(
      code: 'ml',
      englishName: 'Malayalam',
      nativeName: 'മലയാളം',
      status: LanguageSupportStatus.ready,
    ),
    AppLanguage(
      code: 'ur',
      englishName: 'Urdu',
      nativeName: 'اردو',
      isRtl: true,
      status: LanguageSupportStatus.ready,
    ),
    AppLanguage(
      code: 'ta',
      englishName: 'Tamil',
      nativeName: 'தமிழ்',
      status: LanguageSupportStatus.underReview,
    ),
    AppLanguage(
      code: 'te',
      englishName: 'Telugu',
      nativeName: 'తెలుగు',
      status: LanguageSupportStatus.underReview,
    ),
    AppLanguage(
      code: 'kn',
      englishName: 'Kannada',
      nativeName: 'ಕನ್ನಡ',
      status: LanguageSupportStatus.underReview,
    ),
    AppLanguage(
      code: 'bn',
      englishName: 'Bengali',
      nativeName: 'বাংলা',
      status: LanguageSupportStatus.underReview,
    ),
    AppLanguage(
      code: 'mr',
      englishName: 'Marathi',
      nativeName: 'मराठी',
      status: LanguageSupportStatus.underReview,
    ),
    AppLanguage(
      code: 'gu',
      englishName: 'Gujarati',
      nativeName: 'ગુજરાતી',
      status: LanguageSupportStatus.underReview,
    ),
    AppLanguage(
      code: 'pa',
      englishName: 'Punjabi',
      nativeName: 'ਪੰਜਾਬੀ',
      status: LanguageSupportStatus.underReview,
    ),
    AppLanguage(
      code: 'or',
      englishName: 'Odia',
      nativeName: 'ଓଡ଼ିଆ',
      status: LanguageSupportStatus.underReview,
    ),
    AppLanguage(
      code: 'as',
      englishName: 'Assamese',
      nativeName: 'অসমীয়া',
      status: LanguageSupportStatus.underReview,
    ),
  ];

  static AppLanguage fromCode(String code) {
    return supportedLanguages.firstWhere(
      (lang) => lang.code == code,
      orElse: () => supportedLanguages.first,
    );
  }
}

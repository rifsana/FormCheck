// Pure Dart utility for deterministic parsing of Indian identity document date formats.

class ParsedDateResult {
  final bool isSuccess;
  final DateTime? date;
  final bool isYearOnly;
  final int? year;
  final String? originalText;
  final String? failureReason;

  const ParsedDateResult._({
    required this.isSuccess,
    this.date,
    this.isYearOnly = false,
    this.year,
    this.originalText,
    this.failureReason,
  });

  factory ParsedDateResult.success(DateTime date, String originalText) {
    return ParsedDateResult._(
      isSuccess: true,
      date: date,
      year: date.year,
      originalText: originalText,
    );
  }

  factory ParsedDateResult.yearOnly(int year, String originalText) {
    return ParsedDateResult._(
      isSuccess: false,
      isYearOnly: true,
      year: year,
      originalText: originalText,
      failureReason:
          'Contains only Year of Birth ($year), not a full calendar date.',
    );
  }

  factory ParsedDateResult.failure(String failureReason, String originalText) {
    return ParsedDateResult._(
      isSuccess: false,
      originalText: originalText,
      failureReason: failureReason,
    );
  }

  /// Returns standardized DD/MM/YYYY format if valid date exists.
  String get standardizedString {
    if (date != null) {
      final d = date!.day.toString().padLeft(2, '0');
      final m = date!.month.toString().padLeft(2, '0');
      final y = date!.year.toString().padLeft(4, '0');
      return '$d/$m/$y';
    }
    if (year != null) {
      return '$year';
    }
    return originalText ?? '';
  }
}

class DateParsingUtil {
  static const Map<String, int> _monthNames = {
    'jan': 1,
    'january': 1,
    'feb': 2,
    'february': 2,
    'mar': 3,
    'march': 3,
    'apr': 4,
    'april': 4,
    'may': 5,
    'jun': 6,
    'june': 6,
    'jul': 7,
    'july': 7,
    'aug': 8,
    'august': 8,
    'sep': 9,
    'sept': 9,
    'september': 9,
    'oct': 10,
    'october': 10,
    'nov': 11,
    'november': 11,
    'dec': 12,
    'december': 12,
  };

  /// Parses date strings commonly found on Indian documents (Aadhaar, PAN, Voter ID, Passport).
  static ParsedDateResult parseDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return ParsedDateResult.failure('Date string is empty or missing.', '');
    }

    final text = raw.trim();

    // 1. Check Year-Only formats (e.g. "1995" or "Year of Birth: 1985" or "YOB: 1990")
    final yobMatch = RegExp(
      r'^(?:(?:year\s+of\s+birth|yob|birth\s+year|जन्म\s*वर्ष)[\s\:\-]+)?(19\d{2}|20\d{2})$',
      caseSensitive: false,
    ).firstMatch(text);
    if (yobMatch != null) {
      final yearVal = int.tryParse(yobMatch.group(1)!);
      if (yearVal != null) {
        return ParsedDateResult.yearOnly(yearVal, text);
      }
    }

    // 2. Numeric delimited formats: DD/MM/YYYY, DD-MM-YYYY, DD.MM.YYYY
    final dmyMatch = RegExp(
      r'^(\d{1,2})\s*[\/\-\.]\s*(\d{1,2})\s*[\/\-\.]\s*(\d{4})$',
    ).firstMatch(text);
    if (dmyMatch != null) {
      final day = int.parse(dmyMatch.group(1)!);
      final month = int.parse(dmyMatch.group(2)!);
      final year = int.parse(dmyMatch.group(3)!);

      if (!_isValidCalendarDate(year, month, day)) {
        return ParsedDateResult.failure(
          'Invalid calendar date: day or month out of range ($text).',
          text,
        );
      }
      return ParsedDateResult.success(DateTime(year, month, day), text);
    }

    // 3. ISO / YYYY-MM-DD or YYYY/MM/DD formats
    final ymdMatch = RegExp(
      r'^(\d{4})\s*[\/\-\.]\s*(\d{1,2})\s*[\/\-\.]\s*(\d{1,2})$',
    ).firstMatch(text);
    if (ymdMatch != null) {
      final year = int.parse(ymdMatch.group(1)!);
      final month = int.parse(ymdMatch.group(2)!);
      final day = int.parse(ymdMatch.group(3)!);

      if (!_isValidCalendarDate(year, month, day)) {
        return ParsedDateResult.failure(
          'Invalid calendar date: day or month out of range ($text).',
          text,
        );
      }
      return ParsedDateResult.success(DateTime(year, month, day), text);
    }

    // 4. Textual month format: "15 Aug 1995", "15-August-1995", "15/Aug/1995"
    final textMonthMatch = RegExp(
      r'^(\d{1,2})[\s\-\.\/]+([a-zA-Z]+)[\s\-\.\/,]+(\d{4})$',
    ).firstMatch(text);
    if (textMonthMatch != null) {
      final day = int.parse(textMonthMatch.group(1)!);
      final monthStr = textMonthMatch.group(2)!.toLowerCase();
      final year = int.parse(textMonthMatch.group(3)!);

      final month = _monthNames[monthStr];
      if (month == null) {
        return ParsedDateResult.failure(
          'Unrecognized month name: "${textMonthMatch.group(2)}".',
          text,
        );
      }

      if (!_isValidCalendarDate(year, month, day)) {
        return ParsedDateResult.failure(
          'Invalid calendar date: day out of range ($text).',
          text,
        );
      }
      return ParsedDateResult.success(DateTime(year, month, day), text);
    }

    // 5. Month name first: "August 15, 1995" or "Aug 15 1995"
    final monthFirstMatch = RegExp(
      r'^([a-zA-Z]+)[\s\-\.\/]+(\d{1,2})[\s\-\.\/,]+(\d{4})$',
    ).firstMatch(text);
    if (monthFirstMatch != null) {
      final monthStr = monthFirstMatch.group(1)!.toLowerCase();
      final day = int.parse(monthFirstMatch.group(2)!);
      final year = int.parse(monthFirstMatch.group(3)!);

      final month = _monthNames[monthStr];
      if (month == null) {
        return ParsedDateResult.failure(
          'Unrecognized month name: "${monthFirstMatch.group(1)}".',
          text,
        );
      }

      if (!_isValidCalendarDate(year, month, day)) {
        return ParsedDateResult.failure(
          'Invalid calendar date: day out of range ($text).',
          text,
        );
      }
      return ParsedDateResult.success(DateTime(year, month, day), text);
    }

    return ParsedDateResult.failure(
      'Format could not be parsed as a known Indian date format.',
      text,
    );
  }

  static bool _isValidCalendarDate(int year, int month, int day) {
    if (year < 1900 || year > 2100) return false;
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 31) return false;
    final dt = DateTime(year, month, day);
    return dt.year == year && dt.month == month && dt.day == day;
  }
}

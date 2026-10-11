import '../../comparison/domain/date_parsing_util.dart';
import '../../comparison/domain/document_field.dart';
import 'document_candidate_field.dart';
import 'document_parse_result.dart';
import 'document_text_extractor.dart';

/// Pure Dart heuristic text parser for Indian identity documents.
///
/// Detects candidate applicant names and dates of birth from raw OCR text lines
/// while filtering out institutional headers, relationship labels, and sensitive numbers.
class DocumentTextParser {
  static const List<String> _institutionalHeaders = [
    'government of india',
    'govt of india',
    'govt. of india',
    'income tax department',
    'unique identification authority of india',
    'election commission of india',
    'election commission',
    'bharat sarkar',
    'ministry of road transport',
    'transport department',
    'motor vehicles department',
    'driving licence',
    'driving license',
    'indian union driving licence',
    'permanent account number',
    'pan card',
    'aadhaar',
    'mera aadhaar',
    'republic of india',
    'state election commission',
    'uidai',
  ];

  static const List<String> _relationshipLabels = [
    "father's name",
    'father name',
    "mother's name",
    'mother name',
    "husband's name",
    'husband name',
    's/o',
    'd/o',
    'w/o',
    'c/o',
  ];

  static const List<String> _dobContextLabels = [
    'dob',
    'd.o.b',
    'd.o.b.',
    'date of birth',
    'birth date',
    'birth',
    'janm tithi',
    'janma tithi',
    'janm tareekh',
    'janm tarikh',
    'janmatithi',
    'जन्म तिथि',
    'जन्म-तिथि',
    'जन्मतिथि',
    'जन्म तारीख',
    'जन्म-तारीख',
    'जन्म वर्ष',
    'जन्म-वर्ष',
    'जन्म',
    'तिथि',
    'तारीख',
    'tareekh',
    'tarikh',
    'tithi',
    'year of birth',
    'yob',
    'birth year',
  ];

  static const List<String> _yearOnlyLabels = [
    'year of birth',
    'yob',
    'birth year',
    'जन्म वर्ष',
    'जन्म-वर्ष',
  ];

  static const List<String> _nonDobContextLabels = [
    'valid till',
    'valid upto',
    'valid through',
    'validity',
    'valid from',
    'valid to',
    'issue date',
    'date of issue',
    'doi',
    'issued',
    'issue',
    'issuance',
    'aadhaar no. issued',
    'aadhaar no issued',
    'no. issued',
    'no issued',
    'expiry date',
    'date of expiry',
    'exp date',
    'expiry',
    'registration date',
    'date of reg',
    'reg date',
    'registration',
    'enrolment date',
    'enrollment date',
    'print date',
    'download date',
    'generation date',
    'जारी',
    'जारी करने की तिथि',
    'जारी तिथि',
  ];

  static final RegExp _aadhaarRegex = RegExp(
    r'\b\d{4}\s+\d{4}\s+\d{4}\b|\b\d{12}\b',
  );

  static final RegExp _panRegex = RegExp(r'\b[A-Z]{5}[0-9]{4}[A-Z]\b');

  /// Heuristically parses extracted text lines into candidate identity fields.
  static DocumentParseResult parse(
    List<ExtractedTextLine> lines, {
    DocumentType? expectedDocumentType,
  }) {
    if (lines.isEmpty) {
      return const DocumentParseResult(
        notes: ['No text lines extracted from document.'],
        requiresManualReview: true,
      );
    }

    final notes = <String>[];
    bool sensitiveIdentifierFound = false;

    // Check for sensitive numbers (Aadhaar or PAN) across lines
    for (final l in lines) {
      if (_aadhaarRegex.hasMatch(l.text) || _panRegex.hasMatch(l.text)) {
        sensitiveIdentifierFound = true;
      }
    }
    if (sensitiveIdentifierFound) {
      notes.add(
        'Government identity number recognized on card (omitted from application state).',
      );
    }

    // 1. Process Dates
    final dobResult = _extractDobCandidate(lines, notes);

    // 2. Process Names
    final nameCandidate = _extractNameCandidate(lines, notes);

    return DocumentParseResult(
      candidateName: nameCandidate,
      candidateDob: dobResult.candidate,
      detectedDates: dobResult.allDetectedDates,
      notes: notes,
      sensitiveIdentifierDetected: sensitiveIdentifierFound,
      requiresManualReview: true,
    );
  }

  static _DobExtractionResult _extractDobCandidate(
    List<ExtractedTextLine> lines,
    List<String> notes,
  ) {
    final allDetectedDates = <String>[];
    final rawEntries = <_RawDateEntry>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final text = line.text.trim();

      // 1. Standard dates (numeric, textual month, spaced delimiters)
      final datesOnLine = _findAllDatesInString(text);
      for (final dateStr in datesOnLine) {
        if (!allDetectedDates.contains(dateStr)) {
          allDetectedDates.add(dateStr);
        }
        rawEntries.add(
          _RawDateEntry(
            dateString: dateStr,
            line: line,
            lineIndex: i,
            isYearOnly: false,
            hasExplicitDob: false,
            contextDescription: 'Found on line ${line.lineNumber}: "$text"',
          ),
        );
      }

      // 2. Year of birth pattern: "Year of Birth: 1985"
      final yobMatch = RegExp(
        r'(?:year\s+of\s+birth|yob|birth\s+year|जन्म\s*वर्ष|जन्म-वर्ष)[\s\:\-]+(19\d{2}|20\d{2})\b',
        caseSensitive: false,
      ).firstMatch(text);
      if (yobMatch != null) {
        final yearStr = yobMatch.group(1)!;
        if (!allDetectedDates.contains(yearStr)) {
          allDetectedDates.add(yearStr);
        }
        rawEntries.add(
          _RawDateEntry(
            dateString: yearStr,
            line: line,
            lineIndex: i,
            isYearOnly: true,
            hasExplicitDob: true,
            contextDescription:
                'Found on line ${line.lineNumber} with Year of Birth label: "$text"',
          ),
        );
      } else if (i > 0) {
        // Multi-line year of birth: Line i-1 has "Year of Birth", Line i has "1985"
        final pureYearMatch = RegExp(r'^\s*(19\d{2}|20\d{2})\s*$')
            .firstMatch(text);
        final prevLower = lines[i - 1].text.trim().toLowerCase();
        if (pureYearMatch != null &&
            _yearOnlyLabels.any((l) => prevLower.contains(l))) {
          final yearStr = pureYearMatch.group(1)!;
          if (!allDetectedDates.contains(yearStr)) {
            allDetectedDates.add(yearStr);
          }
          rawEntries.add(
            _RawDateEntry(
              dateString: yearStr,
              line: line,
              lineIndex: i,
              isYearOnly: true,
              hasExplicitDob: true,
              contextDescription:
                  'Found on line ${line.lineNumber} with Year of Birth label on preceding line: "${lines[i - 1].text.trim()}"',
            ),
          );
        }
      }
    }

    final dobCandidates = <_RawDateEntry>[];
    final nonDobEntries = <_RawDateEntry>[];
    final unlabeledEntries = <_RawDateEntry>[];

    for (final entry in rawEntries) {
      if (entry.hasExplicitDob) {
        dobCandidates.add(entry);
        continue;
      }

      final i = entry.lineIndex;
      final lineText = entry.line.text.trim();
      final lineLower = lineText.toLowerCase();
      final blk = entry.line.blockIndex;

      bool lineHasDob = _dobContextLabels.any((l) => lineLower.contains(l));
      bool lineHasNonDob = _nonDobContextLabels.any(
        (l) => lineLower.contains(l),
      );

      // Handle multiple dates/labels on the exact same line:
      // Check which label appears most immediately prior to the date in the text
      if (lineHasDob && lineHasNonDob) {
        final dateIdx = lineText.indexOf(entry.dateString);
        if (dateIdx != -1) {
          final textBefore = lineLower.substring(0, dateIdx);
          int lastDobIdx = -1;
          for (final l in _dobContextLabels) {
            final idx = textBefore.lastIndexOf(l);
            if (idx > lastDobIdx) lastDobIdx = idx;
          }
          int lastNonDobIdx = -1;
          for (final l in _nonDobContextLabels) {
            final idx = textBefore.lastIndexOf(l);
            if (idx > lastNonDobIdx) lastNonDobIdx = idx;
          }

          if (lastDobIdx > lastNonDobIdx && lastDobIdx != -1) {
            lineHasDob = true;
            lineHasNonDob = false;
          } else if (lastNonDobIdx > lastDobIdx && lastNonDobIdx != -1) {
            lineHasNonDob = true;
            lineHasDob = false;
          }
        }
      }

      // 1. Check same block lines (if OCR blockIndex is available)
      if (!lineHasDob && !lineHasNonDob && blk != null) {
        final sameBlockLines = lines.where(
          (l) => l.blockIndex == blk && l.lineNumber != entry.line.lineNumber,
        );
        for (final bl in sameBlockLines) {
          final blLower = bl.text.trim().toLowerCase();
          if (_dobContextLabels.any((l) => blLower.contains(l))) {
            lineHasDob = true;
            break;
          } else if (_nonDobContextLabels.any((l) => blLower.contains(l))) {
            lineHasNonDob = true;
            break;
          }
        }
      }

      // 2. Check preceding lines (window of up to 3 lines backward)
      if (!lineHasDob && !lineHasNonDob) {
        for (int step = 1; step <= 3; step++) {
          final prevIdx = i - step;
          if (prevIdx < 0) break;
          final prevLine = lines[prevIdx];
          final prevDates = _findAllDatesInString(prevLine.text);

          // If preceding line already contains a separate date, it cannot be a label for this date
          if (prevDates.isNotEmpty) break;

          final prevLower = prevLine.text.trim().toLowerCase();
          if (_dobContextLabels.any((l) => prevLower.contains(l))) {
            lineHasDob = true;
            break;
          } else if (_nonDobContextLabels.any((l) => prevLower.contains(l))) {
            lineHasNonDob = true;
            break;
          }
        }
      }

      // 3. Check following lines (window of up to 2 lines forward)
      if (!lineHasDob && !lineHasNonDob) {
        for (int step = 1; step <= 2; step++) {
          final nextIdx = i + step;
          if (nextIdx >= lines.length) break;
          final nextLine = lines[nextIdx];
          final nextDates = _findAllDatesInString(nextLine.text);

          // If following line already contains a separate date, it cannot be a label for this date
          if (nextDates.isNotEmpty) break;

          final nextLower = nextLine.text.trim().toLowerCase();
          if (_dobContextLabels.any((l) => nextLower.contains(l))) {
            lineHasDob = true;
            break;
          } else if (_nonDobContextLabels.any((l) => nextLower.contains(l))) {
            lineHasNonDob = true;
            break;
          }
        }
      }

      if (lineHasNonDob && !lineHasDob) {
        nonDobEntries.add(entry);
      } else if (lineHasDob && !lineHasNonDob) {
        dobCandidates.add(entry);
      } else {
        unlabeledEntries.add(entry);
      }
    }

    // Add notes for excluded dates
    for (final entry in nonDobEntries) {
      notes.add(
        'Ignored date "${entry.dateString}" because of issue/validity context: "${entry.line.text.trim()}".',
      );
    }

    DocumentCandidateField? primaryCandidate;

    // Decision Logic:
    // 1. Prefer explicitly labeled DOB candidates over unlabeled or issue dates
    if (dobCandidates.isNotEmpty) {
      final uniqueDob = dobCandidates.map((e) => e.dateString).toSet().toList();
      if (uniqueDob.length == 1) {
        final chosen = dobCandidates.first;
        // Collect other valid dates as alternates (excluding non-DOB issue/expiry dates)
        final alternates = unlabeledEntries
            .map((e) => e.dateString)
            .where((d) => d != chosen.dateString)
            .toSet()
            .toList();

        primaryCandidate = DocumentCandidateField(
          fieldType: ComparisonFieldType.dateOfBirth,
          detectedValue: chosen.dateString,
          confidence: chosen.line.confidence,
          contextSource: chosen.contextDescription,
          isAmbiguous: false,
          isYearOnly: chosen.isYearOnly,
          alternates: alternates,
        );

        if (chosen.isYearOnly) {
          notes.add(
            'Year of birth (${chosen.dateString}) detected. Passport Seva requires a complete date of birth (DD/MM/YYYY).',
          );
        }
      } else {
        // Multiple conflicting dates labeled as DOB
        primaryCandidate = DocumentCandidateField(
          fieldType: ComparisonFieldType.dateOfBirth,
          detectedValue: null,
          confidence: null,
          contextSource: 'Multiple conflicting dates detected with DOB labels.',
          isAmbiguous: true,
          alternates: uniqueDob,
        );
        notes.add(
          'Multiple conflicting dates found with DOB labels. Please select or enter your date of birth manually.',
        );
      }
    } else {
      // No explicit DOB label found
      final uniqueUnlabeled = unlabeledEntries
          .map((e) => e.dateString)
          .toSet()
          .toList();
      final bool hasIssueOrNonDobInDoc = nonDobEntries.isNotEmpty;

      if (uniqueUnlabeled.isEmpty) {
        primaryCandidate = null;
        if (hasIssueOrNonDobInDoc) {
          notes.add(
            'Only an issue or validity date was detected on document. Please enter your date of birth manually.',
          );
        } else {
          notes.add(
            'No date of birth detected on document. Please enter your date of birth manually.',
          );
        }
      } else if (uniqueUnlabeled.length == 1 && !hasIssueOrNonDobInDoc) {
        // Standalone single date on a document with NO issue/expiry context (e.g. PAN card)
        final single = unlabeledEntries.first;
        final isYearOnly =
            single.isYearOnly ||
            DateParsingUtil.parseDate(single.dateString).isYearOnly;
        primaryCandidate = DocumentCandidateField(
          fieldType: ComparisonFieldType.dateOfBirth,
          detectedValue: single.dateString,
          confidence: single.line.confidence,
          contextSource: 'Standalone date found without explicit label.',
          isAmbiguous: true,
          isYearOnly: isYearOnly,
        );
        notes.add(
          'Date "${single.dateString}" was detected without an explicit DOB label. Manual verification is required.',
        );
        if (isYearOnly) {
          notes.add(
            'Year of birth (${single.dateString}) detected. Passport Seva requires a complete date of birth (DD/MM/YYYY).',
          );
        }
      } else {
        // Multiple unlabeled dates or document had issue dates: DO NOT PREFILL ANY DATE!
        primaryCandidate = DocumentCandidateField(
          fieldType: ComparisonFieldType.dateOfBirth,
          detectedValue: null,
          confidence: null,
          contextSource:
              'Multiple dates found on document without an explicit DOB label.',
          isAmbiguous: true,
          alternates: uniqueUnlabeled,
        );
        notes.add(
          'Dates found on document without clear DOB labels. Please select or enter your birth date manually.',
        );
      }
    }

    return _DobExtractionResult(
      candidate: primaryCandidate,
      allDetectedDates: List.unmodifiable(allDetectedDates),
    );
  }

  static DocumentCandidateField? _extractNameCandidate(
    List<ExtractedTextLine> lines,
    List<String> notes,
  ) {
    final candidateLines = <ExtractedTextLine>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final text = line.text.trim();
      final lower = text.toLowerCase();

      // 1. Skip institutional headers
      if (_institutionalHeaders.any((h) => lower.contains(h))) {
        continue;
      }

      // 2. Skip sensitive identifiers
      if (_aadhaarRegex.hasMatch(text) || _panRegex.hasMatch(text)) {
        continue;
      }

      // 3. Skip pure dates or lines with dates
      if (_findDateInString(text) != null) {
        continue;
      }

      // 4. Skip lines with gender indicators
      if (lower == 'male' ||
          lower == 'female' ||
          lower == 'transgender' ||
          lower == 'purush' ||
          lower == 'mahila' ||
          lower == 'पुरुष' ||
          lower == 'महिला' ||
          lower == 'स्त्री') {
        continue;
      }

      // 5. Skip relationship lines (e.g. Father's Name)
      if (_relationshipLabels.any((r) => lower.contains(r))) {
        notes.add('Ignored relationship line: "$text".');
        continue;
      }

      // 6. Skip address or contact noise
      if (lower.startsWith('to,') ||
          lower.startsWith('address:') ||
          lower.startsWith('enrolment no') ||
          lower.startsWith('help line') ||
          lower.contains('www.') ||
          lower.contains('http')) {
        continue;
      }

      // 7. Check if line explicitly has a Name label: "Name: Rahul Sharma"
      final explicitNameMatch = RegExp(
        r'^(?:name|applicant\s+name|naam)[\s\:\\-]+(.+)$',
        caseSensitive: false,
      ).firstMatch(text);
      if (explicitNameMatch != null) {
        final val = explicitNameMatch.group(1)!.trim();
        if (_isPlausibleName(val)) {
          return DocumentCandidateField(
            fieldType: ComparisonFieldType.fullName,
            detectedValue: val,
            confidence: line.confidence,
            contextSource:
                'Found on line ${line.lineNumber} with Name label: "$text"',
            isAmbiguous: false,
          );
        }
      }

      // Check general plausibility
      if (_isPlausibleName(text)) {
        candidateLines.add(line);
      }
    }

    if (candidateLines.isEmpty) {
      notes.add('No candidate name could be identified.');
      return null;
    }

    if (candidateLines.length == 1) {
      final line = candidateLines.first;
      return DocumentCandidateField(
        fieldType: ComparisonFieldType.fullName,
        detectedValue: line.text.trim(),
        confidence: line.confidence,
        contextSource:
            'Identified plausible name on line ${line.lineNumber}: "${line.text.trim()}".',
        isAmbiguous: false,
      );
    }

    // Multiple candidate lines: pick the first one and provide alternates
    final primary = candidateLines.first;
    final alternates = candidateLines
        .skip(1)
        .map((l) => l.text.trim())
        .toList();

    notes.add(
      'Multiple plausible name lines detected (${candidateLines.length} lines). Manual review required.',
    );

    return DocumentCandidateField(
      fieldType: ComparisonFieldType.fullName,
      detectedValue: primary.text.trim(),
      confidence: primary.confidence,
      contextSource:
          'First plausible name line out of multiple detected lines.',
      isAmbiguous: true,
      alternates: alternates,
    );
  }

  static List<String> _findAllDatesInString(String text) {
    final results = <String>[];

    // 1. Delimited numeric date: DD/MM/YYYY, DD-MM-YYYY, YYYY-MM-DD (with optional spaces around separators)
    final numMatches = RegExp(
      r'\b(\d{1,2}\s*[\/\-\.]\s*\d{1,2}\s*[\/\-\.]\s*\d{4})\b|\b(\d{4}\s*[\/\-\.]\s*\d{1,2}\s*[\/\-\.]\s*\d{1,2})\b',
    ).allMatches(text);
    for (final m in numMatches) {
      final dateStr = m.group(1) ?? m.group(2);
      if (dateStr != null) {
        final parsed = DateParsingUtil.parseDate(dateStr);
        if (parsed.isSuccess && !results.contains(parsed.standardizedString)) {
          results.add(parsed.standardizedString);
        }
      }
    }

    // 2. Textual month date: 15 Aug 1995, 15 August 1995, 15-Aug-1995
    final textMonthMatches = RegExp(
      r'\b(\d{1,2}\s*[\s\-\.\/]+\s*[a-zA-Z]+\s*[\s\-\.\/,]+\s*\d{4})\b',
    ).allMatches(text);
    for (final m in textMonthMatches) {
      final dateStr = m.group(1);
      if (dateStr != null) {
        final parsed = DateParsingUtil.parseDate(dateStr);
        if (parsed.isSuccess && !results.contains(parsed.standardizedString)) {
          results.add(parsed.standardizedString);
        }
      }
    }

    // 3. Month name first: August 15, 1995 or Aug 15 1995
    final monthFirstMatches = RegExp(
      r'\b([a-zA-Z]+\s*[\s\-\.\/]+\s*\d{1,2}\s*[\s\-\.\/,]+\s*\d{4})\b',
    ).allMatches(text);
    for (final m in monthFirstMatches) {
      final dateStr = m.group(1);
      if (dateStr != null) {
        final parsed = DateParsingUtil.parseDate(dateStr);
        if (parsed.isSuccess && !results.contains(parsed.standardizedString)) {
          results.add(parsed.standardizedString);
        }
      }
    }

    return results;
  }

  static String? _findDateInString(String text) {
    final dates = _findAllDatesInString(text);
    if (dates.isNotEmpty) {
      return dates.first;
    }

    // Year of birth pattern
    final yobMatch = RegExp(
      r'(?:year\s+of\s+birth|yob|birth\s+year|जन्म\s*वर्ष|जन्म-वर्ष)[\s\:\-]+(19\d{2}|20\d{2})\b',
      caseSensitive: false,
    ).firstMatch(text);
    if (yobMatch != null) {
      return yobMatch.group(1);
    }

    return null;
  }

  static bool _isPlausibleName(String text) {
    final clean = text.trim();
    if (clean.length < 3 || clean.length > 50) return false;

    // Must consist mostly of alphabetic letters, spaces, and optional dots (for initials)
    if (!RegExp(r'^[a-zA-Z\s\.]+$').hasMatch(clean)) {
      return false;
    }

    final words = clean
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty || words.length > 5) return false;

    // At least one word must have 2 or more letters
    if (!words.any((w) => w.replaceAll('.', '').length >= 2)) {
      return false;
    }

    return true;
  }
}

class _RawDateEntry {
  final String dateString;
  final ExtractedTextLine line;
  final int lineIndex;
  final bool isYearOnly;
  final bool hasExplicitDob;
  final String contextDescription;

  _RawDateEntry({
    required this.dateString,
    required this.line,
    required this.lineIndex,
    required this.isYearOnly,
    required this.hasExplicitDob,
    required this.contextDescription,
  });
}

class _DobExtractionResult {
  final DocumentCandidateField? candidate;
  final List<String> allDetectedDates;

  const _DobExtractionResult({
    this.candidate,
    this.allDetectedDates = const [],
  });
}

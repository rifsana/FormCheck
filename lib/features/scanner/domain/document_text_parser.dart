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
    'date of birth',
    'birth date',
    'janm tithi',
    'janma tithi',
    'year of birth',
    'yob',
    'birth year',
  ];

  static const List<String> _nonDobContextLabels = [
    'valid till',
    'valid upto',
    'valid through',
    'validity',
    'issue date',
    'date of issue',
    'doi',
    'expiry',
    'exp date',
    'date of expiry',
    'registration date',
    'enrolment date',
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
    final dobCandidate = _extractDobCandidate(lines, notes);

    // 2. Process Names
    final nameCandidate = _extractNameCandidate(lines, notes);

    return DocumentParseResult(
      candidateName: nameCandidate,
      candidateDob: dobCandidate.candidate,
      detectedDates: dobCandidate.allDetectedDates,
      notes: notes,
      sensitiveIdentifierDetected: sensitiveIdentifierFound,
      requiresManualReview: true,
    );
  }

  static _DobExtractionResult _extractDobCandidate(
    List<ExtractedTextLine> lines,
    List<String> notes,
  ) {
    final allDates = <String>[];
    DocumentCandidateField? primaryCandidate;
    final alternateDobDates = <String>[];

    // Find all lines containing dates
    for (final line in lines) {
      final text = line.text.trim();
      final lower = text.toLowerCase();

      // Check if line contains non-DOB context (Issue, Expiry, Validity)
      final hasNonDobContext = _nonDobContextLabels.any(
        (l) => lower.contains(l),
      );

      // Check if line contains explicit DOB context
      final hasDobContext = _dobContextLabels.any((l) => lower.contains(l));

      // Extract date string
      final extractedDate = _findDateInString(text);
      if (extractedDate != null) {
        if (!allDates.contains(extractedDate)) {
          allDates.add(extractedDate);
        }

        if (hasNonDobContext && !hasDobContext) {
          notes.add(
            'Ignored date "$extractedDate" because of issue/validity context: "$text".',
          );
          continue;
        }

        if (hasDobContext) {
          final isYearOnly = DateParsingUtil.parseDate(extractedDate)
              .isYearOnly;
          if (primaryCandidate == null) {
            primaryCandidate = DocumentCandidateField(
              fieldType: ComparisonFieldType.dateOfBirth,
              detectedValue: extractedDate,
              confidence: line.confidence,
              contextSource:
                  'Found on line ${line.lineNumber} with DOB label: "$text"',
              isAmbiguous: false,
              isYearOnly: isYearOnly,
            );
          } else {
            alternateDobDates.add(extractedDate);
          }
        } else {
          alternateDobDates.add(extractedDate);
        }
      }
    }

    // If no explicit DOB-labeled date was found, check if there is an unlabeled date
    if (primaryCandidate == null) {
      if (alternateDobDates.length == 1) {
        final singleDate = alternateDobDates.first;
        final isYearOnly = DateParsingUtil.parseDate(singleDate).isYearOnly;
        primaryCandidate = DocumentCandidateField(
          fieldType: ComparisonFieldType.dateOfBirth,
          detectedValue: singleDate,
          confidence: null,
          contextSource: 'Standalone date found without explicit label.',
          isAmbiguous: true,
          isYearOnly: isYearOnly,
        );
        notes.add(
          'Date "$singleDate" was detected without an explicit DOB label. Manual verification is required.',
        );
      } else if (alternateDobDates.length > 1) {
        primaryCandidate = DocumentCandidateField(
          fieldType: ComparisonFieldType.dateOfBirth,
          detectedValue: alternateDobDates.first,
          confidence: null,
          contextSource: 'Multiple unlabeled dates found on document.',
          isAmbiguous: true,
          alternates: alternateDobDates,
        );
        notes.add(
          'Multiple dates found on document without clear DOB labels. Please select the correct birth date.',
        );
      }
    } else if (alternateDobDates.isNotEmpty) {
      primaryCandidate = DocumentCandidateField(
        fieldType: primaryCandidate.fieldType,
        detectedValue: primaryCandidate.detectedValue,
        confidence: primaryCandidate.confidence,
        contextSource: primaryCandidate.contextSource,
        isAmbiguous: false,
        isYearOnly: primaryCandidate.isYearOnly,
        alternates: alternateDobDates,
      );
    }

    return _DobExtractionResult(
      candidate: primaryCandidate,
      allDetectedDates: List.unmodifiable(allDates),
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
          lower == 'mahila') {
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

  static String? _findDateInString(String text) {
    // 1. Delimited numeric date: DD/MM/YYYY or YYYY-MM-DD
    final numMatch = RegExp(
      r'\b(\d{1,2}[\/\-\.]\d{1,2}[\/\-\.]\d{4})\b|\b(\d{4}[\/\-\.]\d{1,2}[\/\-\.]\d{1,2})\b',
    ).firstMatch(text);
    if (numMatch != null) {
      final dateStr = numMatch.group(1) ?? numMatch.group(2);
      if (dateStr != null && DateParsingUtil.parseDate(dateStr).isSuccess) {
        return dateStr;
      }
    }

    // 2. Textual month date: 15 Aug 1995 or 15 August 1995
    final textMonthMatch = RegExp(
      r'\b(\d{1,2}[\s\-\.\/]+[a-zA-Z]+[\s\-\.\/,]+\d{4})\b',
    ).firstMatch(text);
    if (textMonthMatch != null) {
      final dateStr = textMonthMatch.group(1);
      if (dateStr != null && DateParsingUtil.parseDate(dateStr).isSuccess) {
        return dateStr;
      }
    }

    // 3. Year of birth pattern: "Year of Birth: 1995" or "YOB: 1985"
    final yobMatch = RegExp(
      r'\b(?:year\s+of\s+birth|yob|birth\s+year)[\s\:\\-]+(19\d{2}|20\d{2})\b',
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

class _DobExtractionResult {
  final DocumentCandidateField? candidate;
  final List<String> allDetectedDates;

  const _DobExtractionResult({
    this.candidate,
    this.allDetectedDates = const [],
  });
}

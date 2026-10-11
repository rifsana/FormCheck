import 'comparison_result.dart';
import 'date_parsing_util.dart';
import 'document_field.dart';

/// Pure Dart deterministic document comparison engine for FormCheck.
///
/// Designed to compare extracted fields across applicant identity documents
/// without relying on OCR, Flutter widgets, or network services.
class DocumentComparisonEngine {
  static const double minimumReliableConfidence = 0.60;

  /// Compares two document fields and returns a structured [FieldComparisonResult].
  static FieldComparisonResult compareFields(
    DocumentField base,
    DocumentField target,
  ) {
    if (base.fieldType != target.fieldType) {
      return FieldComparisonResult(
        fieldType: base.fieldType,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.manualReviewRequired,
        summary: 'Mismatched field types cannot be directly compared.',
        details:
            'Attempted to compare ${base.fieldType.displayName} against ${target.fieldType.displayName}.',
      );
    }

    switch (base.fieldType) {
      case ComparisonFieldType.fullName:
        return compareFullNames(base, target);
      case ComparisonFieldType.dateOfBirth:
        return compareDatesOfBirth(base, target);
      default:
        return _compareGenericFields(base, target);
    }
  }

  /// Compares full name fields across two documents.
  static FieldComparisonResult compareFullNames(
    DocumentField base,
    DocumentField target,
  ) {
    final baseDoc = base.documentType.displayName;
    final targetDoc = target.documentType.displayName;

    // 1. Missing fields check
    if (base.isMissing && target.isMissing) {
      return FieldComparisonResult(
        fieldType: ComparisonFieldType.fullName,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.missingField,
        summary: 'Name field missing in both documents.',
        details:
            'Neither $baseDoc nor $targetDoc contains an extracted name value.',
        flaggedNotes: const ['Name missing in both sources.'],
      );
    }

    if (base.isMissing) {
      return FieldComparisonResult(
        fieldType: ComparisonFieldType.fullName,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.missingField,
        summary: 'Name missing on $baseDoc.',
        details:
            '$baseDoc has no name value to compare against "${target.trimmedValue}" on $targetDoc.',
        flaggedNotes: ['$baseDoc is missing the name field.'],
      );
    }

    if (target.isMissing) {
      return FieldComparisonResult(
        fieldType: ComparisonFieldType.fullName,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.missingField,
        summary: 'Name missing on $targetDoc.',
        details:
            '$targetDoc has no name value to compare against "${base.trimmedValue}" on $baseDoc.',
        flaggedNotes: ['$targetDoc is missing the name field.'],
      );
    }

    // 2. Optical extraction confidence check
    final notes = <String>[];
    if (base.hasLowConfidence || target.hasLowConfidence) {
      final baseConf = base.confidence != null
          ? '${(base.confidence! * 100).toStringAsFixed(0)}%'
          : 'N/A';
      final targetConf = target.confidence != null
          ? '${(target.confidence! * 100).toStringAsFixed(0)}%'
          : 'N/A';

      return FieldComparisonResult(
        fieldType: ComparisonFieldType.fullName,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.manualReviewRequired,
        summary: 'Low extraction clarity requires manual review.',
        details:
            'Optical scan confidence is low ($baseDoc: $baseConf, $targetDoc: $targetConf). '
            'Please verify spelling directly on your physical cards.',
        flaggedNotes: [
          'Low confidence scan: verify physical spelling manually.',
        ],
      );
    }

    final rawBase = base.trimmedValue;
    final rawTarget = target.trimmedValue;

    // 3. Exact character match (ignoring only leading/trailing whitespace)
    if (rawBase == rawTarget) {
      return FieldComparisonResult(
        fieldType: ComparisonFieldType.fullName,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.exactMatch,
        summary: 'Full names match exactly.',
        details:
            'The name "$rawBase" is identical on both $baseDoc and $targetDoc.',
      );
    }

    // 4. Normalized match (collapse internal spaces, case-insensitive)
    final normBase = _normalizeSpaces(rawBase).toLowerCase();
    final normTarget = _normalizeSpaces(rawTarget).toLowerCase();

    if (normBase == normTarget) {
      final caseDiffers =
          rawBase.toLowerCase() == rawTarget.toLowerCase() &&
          rawBase != rawTarget;
      final spaceDiffers =
          _normalizeSpaces(rawBase) != rawBase ||
          _normalizeSpaces(rawTarget) != rawTarget;

      if (caseDiffers) {
        notes.add('Capitalization difference ("$rawBase" vs "$rawTarget").');
      }
      if (spaceDiffers) {
        notes.add('Spacing difference normalized between entries.');
      }

      return FieldComparisonResult(
        fieldType: ComparisonFieldType.fullName,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.normalizedMatch,
        summary: 'Names match (casing or spacing difference).',
        details:
            'Both documents represent the same name after standardizing capitalization and spacing. '
            'Note: Official Passport Seva applications require names in uppercase matching official records.',
        flaggedNotes: notes,
      );
    }

    // 5. Token analysis for word order, extra middle names, or abbreviations
    final baseTokens = _normalizeSpaces(rawBase)
        .split(' ')
        .where((t) => t.isNotEmpty)
        .toList();
    final targetTokens = _normalizeSpaces(rawTarget)
        .split(' ')
        .where((t) => t.isNotEmpty)
        .toList();

    final baseTokensLower = baseTokens.map((t) => t.toLowerCase()).toList();
    final targetTokensLower = targetTokens.map((t) => t.toLowerCase()).toList();

    // Check token reordering (e.g. "Rahul Sharma" vs "Sharma Rahul")
    if (_areTokenSetsEquivalent(baseTokensLower, targetTokensLower)) {
      notes.add(
        'Word order difference: "$rawBase" on $baseDoc vs "$rawTarget" on $targetDoc.',
      );
      notes.add(
        'Passport Seva requires explicit Given Name and Surname separation. Verify which is the family name.',
      );
      return FieldComparisonResult(
        fieldType: ComparisonFieldType.fullName,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.possibleMismatch,
        summary: 'Word order difference detected.',
        details:
            'The words in your name appear in different order between $baseDoc and $targetDoc. '
            'Passport Seva forms have separate Given Name and Surname boxes; ensure consistency.',
        flaggedNotes: notes,
      );
    }

    // Check subset / extra tokens (e.g. "Rahul Kumar Sharma" vs "Rahul Sharma")
    final missingInTarget = baseTokens
        .where((t) => !targetTokensLower.contains(t.toLowerCase()))
        .toList();
    final missingInBase = targetTokens
        .where((t) => !baseTokensLower.contains(t.toLowerCase()))
        .toList();
    if (missingInTarget.isNotEmpty || missingInBase.isNotEmpty) {
      if (missingInTarget.isNotEmpty) {
        notes.add(
          'Token(s) missing on $targetDoc: ${missingInTarget.join(", ")}.',
        );
      }
      if (missingInBase.isNotEmpty) {
        notes.add('Token(s) missing on $baseDoc: ${missingInBase.join(", ")}.');
      }
    }

    // Check initials (e.g. "R. Sharma" or "R Sharma" vs "Rahul Sharma")
    if (_containsInitials(baseTokens) || _containsInitials(targetTokens)) {
      notes.add(
        'One document uses initials or abbreviations. Passport Seva generally requires expanding initials into full names.',
      );
    }

    notes.add(
      'MEA verification officers at Counter A require strict name consistency across submitted proofs.',
    );

    return FieldComparisonResult(
      fieldType: ComparisonFieldType.fullName,
      baseField: base,
      targetField: target,
      status: FieldMatchStatus.possibleMismatch,
      summary: 'Possible name difference detected.',
      details:
          'Name "$rawBase" on $baseDoc differs from "$rawTarget" on $targetDoc. '
          'Passport Seva requires matching names across all submitted documents. '
          'If you legally changed your name, prepare formal Gazette or marriage proof.',
      flaggedNotes: notes,
    );
  }

  /// Compares date of birth fields across two documents.
  static FieldComparisonResult compareDatesOfBirth(
    DocumentField base,
    DocumentField target,
  ) {
    final baseDoc = base.documentType.displayName;
    final targetDoc = target.documentType.displayName;

    // 1. Missing fields check
    if (base.isMissing && target.isMissing) {
      return FieldComparisonResult(
        fieldType: ComparisonFieldType.dateOfBirth,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.missingField,
        summary: 'Date of birth missing in both documents.',
        details:
            'Neither $baseDoc nor $targetDoc contains an extracted date of birth.',
        flaggedNotes: const ['Date of birth missing in both sources.'],
      );
    }

    if (base.isMissing) {
      return FieldComparisonResult(
        fieldType: ComparisonFieldType.dateOfBirth,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.missingField,
        summary: 'Date of birth missing on $baseDoc.',
        details:
            '$baseDoc has no date of birth to compare against "${target.trimmedValue}" on $targetDoc.',
        flaggedNotes: ['$baseDoc is missing the date of birth field.'],
      );
    }

    if (target.isMissing) {
      return FieldComparisonResult(
        fieldType: ComparisonFieldType.dateOfBirth,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.missingField,
        summary: 'Date of birth missing on $targetDoc.',
        details:
            '$targetDoc has no date of birth to compare against "${base.trimmedValue}" on $baseDoc.',
        flaggedNotes: ['$targetDoc is missing the date of birth field.'],
      );
    }

    // 2. Optical extraction confidence check
    if (base.hasLowConfidence || target.hasLowConfidence) {
      return FieldComparisonResult(
        fieldType: ComparisonFieldType.dateOfBirth,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.manualReviewRequired,
        summary: 'Low extraction clarity on date of birth.',
        details: 'Optical scan confidence is low. Please manually verify the date of birth on both cards.',
        flaggedNotes: const [
          'Low confidence scan: check original documents manually.',
        ],
      );
    }

    final rawBase = base.trimmedValue;
    final rawTarget = target.trimmedValue;

    // 3. Exact string match
    if (rawBase == rawTarget) {
      final parsed = DateParsingUtil.parseDate(rawBase);
      if (parsed.isYearOnly) {
        return FieldComparisonResult(
          fieldType: ComparisonFieldType.dateOfBirth,
          baseField: base,
          targetField: target,
          status: FieldMatchStatus.manualReviewRequired,
          summary: 'Incomplete date: Year of Birth only ($rawBase).',
          details:
              'Both documents only record the year of birth. '
              'Passport Seva requires full date of birth (DD/MM/YYYY) for adult applicants.',
          flaggedNotes: const [
            'Only year of birth is available. Passport Seva requires day, month, and year.',
          ],
        );
      }

      return FieldComparisonResult(
        fieldType: ComparisonFieldType.dateOfBirth,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.exactMatch,
        summary: 'Date of birth matches exactly ($rawBase).',
        details: 'Both documents show identical date of birth: "$rawBase".',
      );
    }

    // 4. Parse dates with Indian format awareness
    final baseParsed = DateParsingUtil.parseDate(rawBase);
    final targetParsed = DateParsingUtil.parseDate(rawTarget);

    // Year-only handling (common on older Aadhaar cards)
    if (baseParsed.isYearOnly || targetParsed.isYearOnly) {
      final notes = <String>[];
      if (baseParsed.isYearOnly) {
        notes.add('$baseDoc contains only Year of Birth (${baseParsed.year}).');
      }
      if (targetParsed.isYearOnly) {
        notes.add(
          '$targetDoc contains only Year of Birth (${targetParsed.year}).',
        );
      }
      notes.add(
        'Passport Seva requires complete Date of Birth (DD/MM/YYYY). Update your Aadhaar or use an alternate birth proof.',
      );

      return FieldComparisonResult(
        fieldType: ComparisonFieldType.dateOfBirth,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.manualReviewRequired,
        summary: 'Partial date detected (Year of Birth only).',
        details:
            'One or both documents only display the year of birth. '
            'Passport Seva requires a document confirming the complete day, month, and year.',
        flaggedNotes: notes,
      );
    }

    // Unparseable format check
    if (!baseParsed.isSuccess || !targetParsed.isSuccess) {
      final notes = <String>[];
      if (!baseParsed.isSuccess) {
        notes.add(
          'Could not parse date on $baseDoc: ${baseParsed.failureReason}',
        );
      }
      if (!targetParsed.isSuccess) {
        notes.add(
          'Could not parse date on $targetDoc: ${targetParsed.failureReason}',
        );
      }

      return FieldComparisonResult(
        fieldType: ComparisonFieldType.dateOfBirth,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.manualReviewRequired,
        summary: 'Date format could not be verified automatically.',
        details:
            'One or both dates could not be verified against standard Indian document formats ($rawBase vs $rawTarget). Please verify manually.',
        flaggedNotes: notes,
      );
    }

    // Calendar comparison
    final dateA = baseParsed.date!;
    final dateB = targetParsed.date!;

    if (dateA == dateB) {
      return FieldComparisonResult(
        fieldType: ComparisonFieldType.dateOfBirth,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.normalizedMatch,
        summary: 'Dates of birth match (${baseParsed.standardizedString}).',
        details:
            'Both documents represent the same date (${baseParsed.standardizedString}), '
            'written in different formats ("$rawBase" on $baseDoc vs "$rawTarget" on $targetDoc).',
        flaggedNotes: [
          'Format variance: "$rawBase" vs "$rawTarget" (both resolve to ${baseParsed.standardizedString}).',
        ],
      );
    }

    // Genuine date mismatch
    final notes = <String>[
      'Discrepancy: ${baseParsed.standardizedString} ($baseDoc) vs ${targetParsed.standardizedString} ($targetDoc).',
      'Passport Seva Counter A strictly verifies date of birth against your primary birth proof.',
    ];

    return FieldComparisonResult(
      fieldType: ComparisonFieldType.dateOfBirth,
      baseField: base,
      targetField: target,
      status: FieldMatchStatus.possibleMismatch,
      summary: 'Date of birth mismatch detected.',
      details:
          'Date on $baseDoc (${baseParsed.standardizedString}) does not match '
          'date on $targetDoc (${targetParsed.standardizedString}). '
          'A date of birth mismatch will result in application rejection unless corrected before your appointment.',
      flaggedNotes: notes,
    );
  }

  /// Compares all matching fields between two lists of document fields.
  static DocumentComparisonReport compareDocuments({
    required DocumentType baseDocType,
    required DocumentType targetDocType,
    required List<DocumentField> baseFields,
    required List<DocumentField> targetFields,
    String? reportId,
  }) {
    final results = <FieldComparisonResult>[];

    // Find all unique field types present across either document
    final fieldTypes = <ComparisonFieldType>{};
    for (final f in baseFields) {
      fieldTypes.add(f.fieldType);
    }
    for (final f in targetFields) {
      fieldTypes.add(f.fieldType);
    }

    for (final type in fieldTypes) {
      final baseField =
          baseFields.cast<DocumentField?>().firstWhere(
            (f) => f?.fieldType == type,
            orElse: () => null,
          ) ??
          DocumentField(
            documentType: baseDocType,
            fieldType: type,
            rawValue: null,
          );

      final targetField =
          targetFields.cast<DocumentField?>().firstWhere(
            (f) => f?.fieldType == type,
            orElse: () => null,
          ) ??
          DocumentField(
            documentType: targetDocType,
            fieldType: type,
            rawValue: null,
          );

      results.add(compareFields(baseField, targetField));
    }

    return DocumentComparisonReport(
      reportId: reportId ?? 'report_${DateTime.now().millisecondsSinceEpoch}',
      baseDocumentType: baseDocType,
      targetDocumentType: targetDocType,
      fieldResults: List.unmodifiable(results),
      generatedAt: DateTime.now(),
    );
  }

  static FieldComparisonResult _compareGenericFields(
    DocumentField base,
    DocumentField target,
  ) {
    if (base.isMissing && target.isMissing) {
      return FieldComparisonResult(
        fieldType: base.fieldType,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.missingField,
        summary: '${base.fieldType.displayName} missing in both documents.',
        details: 'No values found to compare.',
      );
    }

    final rawBase = base.trimmedValue;
    final rawTarget = target.trimmedValue;

    if (rawBase == rawTarget) {
      return FieldComparisonResult(
        fieldType: base.fieldType,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.exactMatch,
        summary: '${base.fieldType.displayName} matches exactly.',
        details: 'Values are identical.',
      );
    }

    if (_normalizeSpaces(rawBase).toLowerCase() ==
        _normalizeSpaces(rawTarget).toLowerCase()) {
      return FieldComparisonResult(
        fieldType: base.fieldType,
        baseField: base,
        targetField: target,
        status: FieldMatchStatus.normalizedMatch,
        summary: '${base.fieldType.displayName} matches after normalization.',
        details: 'Values match excluding case and spacing differences.',
      );
    }

    return FieldComparisonResult(
      fieldType: base.fieldType,
      baseField: base,
      targetField: target,
      status: FieldMatchStatus.possibleMismatch,
      summary: 'Possible difference in ${base.fieldType.displayName}.',
      details: '"$rawBase" vs "$rawTarget".',
    );
  }

  static String _normalizeSpaces(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static bool _areTokenSetsEquivalent(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final sortedA = List<String>.from(a)..sort();
    final sortedB = List<String>.from(b)..sort();
    for (int i = 0; i < sortedA.length; i++) {
      if (sortedA[i] != sortedB[i]) return false;
    }
    return true;
  }

  static bool _containsInitials(List<String> tokens) {
    return tokens.any(
      (t) => t.length == 1 || (t.length == 2 && t.endsWith('.')),
    );
  }
}

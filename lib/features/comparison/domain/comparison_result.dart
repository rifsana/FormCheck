import 'document_field.dart';

/// Categorization of comparison outcome between two document fields.
enum FieldMatchStatus {
  /// Both values are identical character-by-character (excluding surrounding whitespace).
  exactMatch('Exact Match'),

  /// Values represent the same semantic data but differ in formatting,
  /// letter casing, multiple spaces, or calendar format (e.g. "RAHUL SHARMA" vs "Rahul Sharma"
  /// or "15/08/1995" vs "15-08-1995").
  normalizedMatch('Normalized Match'),

  /// A discernible difference exists between non-empty values that may cause
  /// scrutiny or rejection by passport officials (e.g. spelling discrepancy, different birth year).
  possibleMismatch('Possible Mismatch'),

  /// Value cannot be compared reliably due to low scan confidence, unparseable format,
  /// or incomplete information (such as an Aadhaar showing only Year of Birth).
  manualReviewRequired('Manual Review Required'),

  /// One or both documents lack this field.
  missingField('Missing Field');

  final String displayName;
  const FieldMatchStatus(this.displayName);
}

/// The result of comparing a single field between two documents.
class FieldComparisonResult {
  final ComparisonFieldType fieldType;
  final DocumentField baseField;
  final DocumentField targetField;
  final FieldMatchStatus status;
  final String summary;
  final String details;
  final List<String> flaggedNotes;

  const FieldComparisonResult({
    required this.fieldType,
    required this.baseField,
    required this.targetField,
    required this.status,
    required this.summary,
    required this.details,
    this.flaggedNotes = const [],
  });

  /// Indicates if this comparison requires the applicant's attention or resolution.
  bool get requiresApplicantAttention =>
      status == FieldMatchStatus.possibleMismatch ||
      status == FieldMatchStatus.manualReviewRequired ||
      status == FieldMatchStatus.missingField;

  /// True if values are considered matching (either strictly or normalized).
  bool get isMatch =>
      status == FieldMatchStatus.exactMatch ||
      status == FieldMatchStatus.normalizedMatch;
}

/// Summary report comparing multiple fields between two documents.
class DocumentComparisonReport {
  final String reportId;
  final DocumentType baseDocumentType;
  final DocumentType targetDocumentType;
  final List<FieldComparisonResult> fieldResults;
  final DateTime generatedAt;

  const DocumentComparisonReport({
    required this.reportId,
    required this.baseDocumentType,
    required this.targetDocumentType,
    required this.fieldResults,
    required this.generatedAt,
  });

  bool get hasMismatches =>
      fieldResults.any((r) => r.status == FieldMatchStatus.possibleMismatch);

  bool get requiresManualReview => fieldResults.any(
    (r) => r.status == FieldMatchStatus.manualReviewRequired,
  );

  bool get hasMissingFields =>
      fieldResults.any((r) => r.status == FieldMatchStatus.missingField);

  bool get isAllMatching =>
      fieldResults.isNotEmpty && fieldResults.every((r) => r.isMatch);

  int get matchCount => fieldResults.where((r) => r.isMatch).length;

  int get mismatchCount => fieldResults
      .where((r) => r.status == FieldMatchStatus.possibleMismatch)
      .length;
}

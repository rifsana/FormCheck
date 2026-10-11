import 'document_candidate_field.dart';

/// Ephemeral result of heuristic text parsing on an identity document.
///
/// Contains candidate fields for user review and contextual notes.
/// Raw full document text and sensitive identifiers are omitted to protect privacy.
class DocumentParseResult {
  final DocumentCandidateField? candidateName;
  final DocumentCandidateField? candidateDob;

  /// All unique dates discovered across the document (including issue/validity dates).
  final List<String> detectedDates;

  /// Flags explaining detection heuristics, ignored headers, or ambiguous lines.
  final List<String> notes;

  /// Indicates if sensitive identifier patterns (Aadhaar/PAN) were recognized on the card.
  /// The actual numbers are omitted.
  final bool sensitiveIdentifierDetected;

  /// All parsing output requires mandatory applicant review before comparison.
  final bool requiresManualReview;

  const DocumentParseResult({
    this.candidateName,
    this.candidateDob,
    this.detectedDates = const [],
    this.notes = const [],
    this.sensitiveIdentifierDetected = false,
    this.requiresManualReview = true,
  });

  bool get hasNameCandidate => candidateName?.hasValue ?? false;
  bool get hasDobCandidate => candidateDob?.hasValue ?? false;
}

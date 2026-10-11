import '../../comparison/domain/document_field.dart';

/// Represents a candidate field value detected heuristically from raw document text.
///
/// Candidates are preliminary detections intended for mandatory applicant review,
/// not definitive identifications.
class DocumentCandidateField {
  final ComparisonFieldType fieldType;
  final String? detectedValue;

  /// Extraction confidence score. `null` if confidence was not supplied by the engine.
  final double? confidence;

  /// Human-readable explanation of why this candidate was selected (e.g. "Label 'DOB:' on line 4").
  final String? contextSource;

  /// True if multiple competing values were found or if context is uncertain.
  final bool isAmbiguous;

  /// True if the detected date only represents a Year of Birth (e.g. "1985").
  final bool isYearOnly;

  /// Alternative candidate values detected on other lines, presented for manual selection.
  final List<String> alternates;

  const DocumentCandidateField({
    required this.fieldType,
    this.detectedValue,
    this.confidence,
    this.contextSource,
    this.isAmbiguous = false,
    this.isYearOnly = false,
    this.alternates = const [],
  });

  bool get hasValue =>
      detectedValue != null && detectedValue!.trim().isNotEmpty;

  bool get isConfidenceAvailable => confidence != null;

  @override
  String toString() =>
      'DocumentCandidateField(field: ${fieldType.name}, value: "$detectedValue", '
      'ambiguous: $isAmbiguous, yearOnly: $isYearOnly, alternates: $alternates)';
}

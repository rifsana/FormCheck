// Pure Dart domain model representing extracted document fields.

/// The official identity document category from which a field was extracted.
enum DocumentType {
  aadhaar('Aadhaar Card'),
  panCard('PAN Card'),
  voterId('Voter ID (EPIC)'),
  drivingLicense('Driving License'),
  birthCertificate('Birth Certificate'),
  matriculationCertificate('Matriculation / 10th Certificate'),
  passport('Passport'),
  utilityBill('Utility Bill'),
  bankPassbook('Bank Passbook'),
  other('Other Supporting Document');

  final String displayName;
  const DocumentType(this.displayName);
}

/// The specific identity field extracted for comparison.
enum ComparisonFieldType {
  fullName('Full Name'),
  dateOfBirth('Date of Birth'),
  address('Residential Address'),
  gender('Gender'),
  parentName('Parent Name'),
  spouseName('Spouse Name');

  final String displayName;
  const ComparisonFieldType(this.displayName);
}

/// Typed representation of an extracted field from an applicant document.
class DocumentField {
  final DocumentType documentType;
  final ComparisonFieldType fieldType;
  final String? rawValue;

  /// Optical extraction confidence score between 0.0 and 1.0 (if provided).
  final double? confidence;

  /// Optional identifier linking back to the source document artifact or record.
  final String? sourceDocumentId;

  const DocumentField({
    required this.documentType,
    required this.fieldType,
    this.rawValue,
    this.confidence,
    this.sourceDocumentId,
  });

  /// True if the field value is null or contains only whitespace.
  bool get isMissing => rawValue == null || rawValue!.trim().isEmpty;

  /// Returns the trimmed value, or empty string if missing.
  String get trimmedValue => rawValue?.trim() ?? '';

  /// True if confidence score is present and below the acceptable threshold (0.60).
  bool get hasLowConfidence => confidence != null && confidence! < 0.60;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentField &&
          runtimeType == other.runtimeType &&
          documentType == other.documentType &&
          fieldType == other.fieldType &&
          rawValue == other.rawValue &&
          confidence == other.confidence &&
          sourceDocumentId == other.sourceDocumentId;

  @override
  int get hashCode =>
      documentType.hashCode ^
      fieldType.hashCode ^
      rawValue.hashCode ^
      confidence.hashCode ^
      sourceDocumentId.hashCode;

  @override
  String toString() =>
      'DocumentField(type: ${documentType.name}, field: ${fieldType.name}, '
      'value: "$rawValue", confidence: $confidence)';
}

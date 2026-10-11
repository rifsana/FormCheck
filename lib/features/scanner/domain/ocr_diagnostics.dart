/// Lightweight, ephemeral diagnostic metadata for on-device OCR inspection.
///
/// Designed strictly for local debugging without logging or persisting
/// sensitive personal details, full document numbers, or unredacted text.
class OcrLineDiagnostic {
  final int lineNumber;
  final int? blockIndex;
  final String category;
  final String? dateExtracted;
  final String? classification;

  const OcrLineDiagnostic({
    required this.lineNumber,
    this.blockIndex,
    required this.category,
    this.dateExtracted,
    this.classification,
  });

  @override
  String toString() =>
      'Line $lineNumber [Block ${blockIndex ?? '?'}] -> $category ($classification)';
}

class OcrDiagnostics {
  final String buildCommit;
  final String buildTimestamp;
  final int totalBlocks;
  final int totalLines;
  final List<String> allExtractedDates;
  final List<OcrLineDiagnostic> lineDiagnostics;
  final String? primaryDobSelected;
  final List<String> excludedDates;
  final List<String> alternateDates;

  const OcrDiagnostics({
    required this.buildCommit,
    required this.buildTimestamp,
    required this.totalBlocks,
    required this.totalLines,
    required this.allExtractedDates,
    required this.lineDiagnostics,
    this.primaryDobSelected,
    this.excludedDates = const [],
    this.alternateDates = const [],
  });
}

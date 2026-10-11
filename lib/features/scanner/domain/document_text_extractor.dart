// Pure Dart contract for local, on-device OCR text extraction.

/// Represents a single line of text extracted by an OCR engine.
class ExtractedTextLine {
  final String text;

  /// Optical character recognition confidence score between 0.0 and 1.0.
  ///
  /// Set to `null` if the underlying OCR engine does not provide calibrated,
  /// field-level confidence scores. Do not fabricate or estimate confidence.
  final double? confidence;

  final int lineNumber;

  /// Optional OCR block index (1-based) grouping lines belonging to the same text block.
  final int? blockIndex;

  const ExtractedTextLine({
    required this.text,
    this.confidence,
    required this.lineNumber,
    this.blockIndex,
  });

  bool get hasConfidence => confidence != null;

  @override
  String toString() =>
      'ExtractedTextLine(line: $lineNumber, block: $blockIndex, text: "$text", conf: $confidence)';
}

/// Abstract contract for on-device document text extraction.
///
/// Implementations must extract text locally without network transmission,
/// remote cloud APIs, or persistent caching of raw images.
abstract class DocumentTextExtractor {
  Future<List<ExtractedTextLine>> extractLines(String imagePath);
}

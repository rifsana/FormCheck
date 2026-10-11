import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../domain/document_text_extractor.dart';

/// Exception thrown when on-device OCR encounters an unreadable file or native error.
class OcrExtractionException implements Exception {
  final String message;
  final dynamic cause;

  const OcrExtractionException(this.message, [this.cause]);

  @override
  String toString() => 'OcrExtractionException: $message';
}

/// Concrete implementation of [DocumentTextExtractor] using Google ML Kit on-device OCR.
class MlKitTextExtractor implements DocumentTextExtractor {
  final TextRecognizer _recognizer;

  MlKitTextExtractor({TextRecognizer? recognizer})
    : _recognizer =
          recognizer ?? TextRecognizer(script: TextRecognitionScript.latin);

  @override
  Future<List<ExtractedTextLine>> extractLines(String imagePath) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      throw OcrExtractionException(
        'Document image file not found or inaccessible.',
      );
    }

    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _recognizer.processImage(inputImage);

      final lines = <ExtractedTextLine>[];
      int lineIndex = 1;

      for (final block in recognizedText.blocks) {
        for (final line in block.lines) {
          final trimmed = line.text.trim();
          if (trimmed.isNotEmpty) {
            lines.add(
              ExtractedTextLine(
                text: trimmed,
                // ML Kit on-device Latin model does not provide calibrated line confidence
                confidence: null,
                lineNumber: lineIndex++,
              ),
            );
          }
        }
      }

      return List.unmodifiable(lines);
    } catch (e) {
      if (e is OcrExtractionException) rethrow;
      throw OcrExtractionException(
        'Failed to process document image with on-device OCR.',
        e,
      );
    }
  }

  /// Releases native ML Kit resources.
  Future<void> dispose() async {
    await _recognizer.close();
  }
}

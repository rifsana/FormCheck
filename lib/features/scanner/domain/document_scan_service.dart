import 'dart:io';

import 'document_image_picker.dart';
import 'document_parse_result.dart';
import 'document_text_extractor.dart';
import 'document_text_parser.dart';

/// Outcome status of document selection and extraction.
enum ScanStatus { success, cancelled, failure }

/// Result of document selection, local extraction, and heuristic parsing.
class DocumentScanResult {
  final ScanStatus status;
  final DocumentParseResult? parseResult;
  final String? errorMessage;

  const DocumentScanResult._({
    required this.status,
    this.parseResult,
    this.errorMessage,
  });

  factory DocumentScanResult.success(DocumentParseResult parseResult) =>
      DocumentScanResult._(
        status: ScanStatus.success,
        parseResult: parseResult,
      );

  factory DocumentScanResult.cancelled() =>
      const DocumentScanResult._(status: ScanStatus.cancelled);

  factory DocumentScanResult.failure(String message) =>
      DocumentScanResult._(status: ScanStatus.failure, errorMessage: message);

  bool get isSuccess => status == ScanStatus.success;
  bool get isCancelled => status == ScanStatus.cancelled;
  bool get isFailure => status == ScanStatus.failure;
}

/// Coordinator that orchestrates picking an image, performing on-device OCR,
/// deleting the temporary file, and parsing candidates for user review.
class DocumentScanService {
  final DocumentImagePicker picker;
  final DocumentTextExtractor extractor;
  final Future<void> Function(String path) _fileDeleter;

  DocumentScanService({
    required this.picker,
    required this.extractor,
    Future<void> Function(String path)? fileDeleter,
  }) : _fileDeleter = fileDeleter ?? _defaultFileDeleter;

  /// Orchestrates selecting an image, performing on-device OCR,
  /// cleaning up the temporary file, and parsing candidate fields.
  Future<DocumentScanResult> pickAndExtractDocument() async {
    String? imagePath;
    try {
      imagePath = await picker.pickDocumentImage();
      if (imagePath == null) {
        return DocumentScanResult.cancelled();
      }

      final lines = await extractor.extractLines(imagePath);
      if (lines.isEmpty) {
        return DocumentScanResult.failure(
          'No readable text found on the document image. Please ensure the document is clear, well-lit, and in focus.',
        );
      }

      final parseResult = DocumentTextParser.parse(lines);
      return DocumentScanResult.success(parseResult);
    } catch (e) {
      return DocumentScanResult.failure(
        'Could not extract text from document: ${e.toString()}',
      );
    } finally {
      if (imagePath != null) {
        try {
          await _fileDeleter(imagePath);
        } catch (_) {
          // File cleanup errors ignored
        }
      }
    }
  }

  static Future<void> _defaultFileDeleter(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}

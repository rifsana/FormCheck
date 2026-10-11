import 'package:flutter_test/flutter_test.dart';
import 'package:form_check/features/scanner/domain/document_image_picker.dart';
import 'package:form_check/features/scanner/domain/document_scan_service.dart';
import 'package:form_check/features/scanner/domain/document_text_extractor.dart';

class MockImagePicker implements DocumentImagePicker {
  String? returnPath;
  Exception? throwError;
  bool wasCalled = false;

  MockImagePicker({this.returnPath, this.throwError});

  @override
  Future<String?> pickDocumentImage() async {
    wasCalled = true;
    if (throwError != null) throw throwError!;
    return returnPath;
  }
}

class MockTextExtractor implements DocumentTextExtractor {
  List<ExtractedTextLine> returnLines;
  Exception? throwError;
  String? lastProcessedPath;

  MockTextExtractor({this.returnLines = const [], this.throwError});

  @override
  Future<List<ExtractedTextLine>> extractLines(String imagePath) async {
    lastProcessedPath = imagePath;
    if (throwError != null) throw throwError!;
    return returnLines;
  }
}

void main() {
  group('DocumentScanService Tests', () {
    test(
      'Handles user cancellation cleanly without invoking file cleanup',
      () async {
        final picker = MockImagePicker(returnPath: null);
        final extractor = MockTextExtractor();
        final deletedPaths = <String>[];

        final service = DocumentScanService(
          picker: picker,
          extractor: extractor,
          fileDeleter: (p) async => deletedPaths.add(p),
        );

        final result = await service.pickAndExtractDocument();

        expect(picker.wasCalled, isTrue);
        expect(result.isCancelled, isTrue);
        expect(result.parseResult, isNull);
        expect(extractor.lastProcessedPath, isNull);
        expect(deletedPaths, isEmpty);
      },
    );

    test(
      'Extracts lines, parses candidates, and deletes temp file on success',
      () async {
        const testPath = 'cache/test_aadhaar.jpg';
        final picker = MockImagePicker(returnPath: testPath);
        final extractor = MockTextExtractor(
          returnLines: const [
            ExtractedTextLine(lineNumber: 1, text: 'GOVERNMENT OF INDIA'),
            ExtractedTextLine(lineNumber: 2, text: 'Rahul Sharma'),
            ExtractedTextLine(lineNumber: 3, text: 'DOB: 15/08/1995'),
            ExtractedTextLine(lineNumber: 4, text: 'Male'),
          ],
        );
        final deletedPaths = <String>[];

        final service = DocumentScanService(
          picker: picker,
          extractor: extractor,
          fileDeleter: (p) async => deletedPaths.add(p),
        );

        final result = await service.pickAndExtractDocument();

        expect(result.isSuccess, isTrue);
        expect(result.parseResult, isNotNull);
        expect(
          result.parseResult!.candidateName?.detectedValue,
          equals('Rahul Sharma'),
        );
        expect(
          result.parseResult!.candidateDob?.detectedValue,
          equals('15/08/1995'),
        );
        expect(extractor.lastProcessedPath, equals(testPath));

        // Temporary file must be deleted
        expect(deletedPaths, contains(testPath));
      },
    );

    test(
      'Handles empty OCR results (unreadable image) and cleans up temp file',
      () async {
        const testPath = 'cache/blank_image.jpg';
        final picker = MockImagePicker(returnPath: testPath);
        final extractor = MockTextExtractor(returnLines: const []);
        final deletedPaths = <String>[];

        final service = DocumentScanService(
          picker: picker,
          extractor: extractor,
          fileDeleter: (p) async => deletedPaths.add(p),
        );

        final result = await service.pickAndExtractDocument();

        expect(result.isFailure, isTrue);
        expect(result.errorMessage, contains('No readable text found'));
        // File must be deleted even on empty text
        expect(deletedPaths, contains(testPath));
      },
    );

    test(
      'Deletes temporary file in finally block even when extraction throws',
      () async {
        const testPath = 'cache/corrupt_image.jpg';
        final picker = MockImagePicker(returnPath: testPath);
        final extractor = MockTextExtractor(
          throwError: Exception('Native ML Kit decoding error'),
        );
        final deletedPaths = <String>[];

        final service = DocumentScanService(
          picker: picker,
          extractor: extractor,
          fileDeleter: (p) async => deletedPaths.add(p),
        );

        final result = await service.pickAndExtractDocument();

        expect(result.isFailure, isTrue);
        expect(result.errorMessage, contains('Native ML Kit decoding error'));
        // Guaranteed cleanup via finally block
        expect(deletedPaths, contains(testPath));
      },
    );

    test('Handles picker exception safely', () async {
      final picker = MockImagePicker(
        throwError: Exception('Picker permission denied'),
      );
      final extractor = MockTextExtractor();
      final deletedPaths = <String>[];

      final service = DocumentScanService(
        picker: picker,
        extractor: extractor,
        fileDeleter: (p) async => deletedPaths.add(p),
      );

      final result = await service.pickAndExtractDocument();

      expect(result.isFailure, isTrue);
      expect(result.errorMessage, contains('Picker permission denied'));
      expect(deletedPaths, isEmpty);
    });
  });
}

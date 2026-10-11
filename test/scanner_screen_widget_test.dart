import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_check/features/scanner/domain/document_image_picker.dart';
import 'package:form_check/features/scanner/domain/document_scan_service.dart';
import 'package:form_check/features/scanner/domain/document_text_extractor.dart';
import 'package:form_check/features/scanner/presentation/scanner_controller.dart';
import 'package:form_check/features/scanner/presentation/scanner_screen.dart';

class MockTestPicker implements DocumentImagePicker {
  String? resultPath;
  MockTestPicker({this.resultPath});

  @override
  Future<String?> pickDocumentImage() async => resultPath;
}

class MockTestExtractor implements DocumentTextExtractor {
  List<ExtractedTextLine> lines;
  Exception? throwError;

  MockTestExtractor({this.lines = const [], this.throwError});

  @override
  Future<List<ExtractedTextLine>> extractLines(String imagePath) async {
    if (throwError != null) throw throwError!;
    return lines;
  }
}

void main() {
  Widget buildTestableWidget({
    DocumentImagePicker? picker,
    DocumentTextExtractor? extractor,
  }) {
    final effectivePicker = picker ?? MockTestPicker(resultPath: null);
    final effectiveExtractor = extractor ?? MockTestExtractor();

    final service = DocumentScanService(
      picker: effectivePicker,
      extractor: effectiveExtractor,
      fileDeleter: (p) async {},
    );

    return ProviderScope(
      overrides: [documentScanServiceProvider.overrideWithValue(service)],
      child: const MaterialApp(home: ScannerScreen()),
    );
  }

  group('ScannerScreen Widget Tests', () {
    testWidgets('Renders idle state with title, highlights, and CTA button', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Check your documents'), findsOneWidget);
      expect(find.text('Read identity document'), findsOneWidget);
      expect(find.text('Choose document image'), findsOneWidget);
      expect(find.text('Private by design'), findsOneWidget);
      expect(find.text('Immediate cleanup'), findsOneWidget);
    });

    testWidgets('Shows cancelled state when user dismisses image picker', (
      tester,
    ) async {
      // Mock picker returning null (user cancelled)
      final picker = MockTestPicker(resultPath: null);

      await tester.pumpWidget(buildTestableWidget(picker: picker));
      await tester.pumpAndSettle();

      // Tap choose image button
      await tester.tap(find.text('Choose document image'));
      await tester.pumpAndSettle();

      expect(find.text('No document selected'), findsOneWidget);
      expect(find.text('Choose document image'), findsOneWidget);
      expect(find.text('Back to options'), findsOneWidget);
    });

    testWidgets('Shows error state with retry button when extraction fails', (
      tester,
    ) async {
      final picker = MockTestPicker(resultPath: 'path/corrupt.jpg');
      final extractor = MockTestExtractor(
        throwError: Exception('Could not decode image format'),
      );

      await tester.pumpWidget(
        buildTestableWidget(picker: picker, extractor: extractor),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Choose document image'));
      await tester.pumpAndSettle();

      expect(find.text('Could not read document'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets(
      'Renders editable review fields on successful extraction and allows confirmation',
      (tester) async {
        final picker = MockTestPicker(resultPath: 'path/aadhaar.jpg');
        final extractor = MockTestExtractor(
          lines: const [
            ExtractedTextLine(lineNumber: 1, text: 'GOVERNMENT OF INDIA'),
            ExtractedTextLine(lineNumber: 2, text: 'Rahul Sharma'),
            ExtractedTextLine(lineNumber: 3, text: 'DOB: 15/08/1995'),
            ExtractedTextLine(lineNumber: 4, text: 'Male'),
          ],
        );

        await tester.pumpWidget(
          buildTestableWidget(picker: picker, extractor: extractor),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Choose document image'));
        await tester.pumpAndSettle();

        // Review state
        expect(find.text('Please verify extracted details'), findsOneWidget);
        expect(find.text('Rahul Sharma'), findsOneWidget);
        expect(find.text('15/08/1995'), findsOneWidget);

        // Verify user can edit the name field
        final nameField = find.byKey(const Key('scanner_name_field'));
        expect(nameField, findsOneWidget);
        await tester.enterText(nameField, 'Rahul Kumar Sharma');
        await tester.pumpAndSettle();

        // Verify user can edit the DOB field
        final dobField = find.byKey(const Key('scanner_dob_field'));
        expect(dobField, findsOneWidget);
        await tester.enterText(dobField, '16/08/1995');
        await tester.pumpAndSettle();

        // Tap Confirm details button
        final confirmBtn = find.byKey(const Key('scanner_confirm_button'));
        await tester.ensureVisible(confirmBtn);
        await tester.tap(confirmBtn);
        await tester.pumpAndSettle();

        // Confirmed state
        expect(find.text('Document details confirmed'), findsOneWidget);
        expect(find.text('Rahul Kumar Sharma'), findsOneWidget);
        expect(find.text('16/08/1995'), findsOneWidget);
      },
    );
  });
}

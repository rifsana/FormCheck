import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mlkit_text_extractor.dart';
import '../data/system_document_image_picker.dart';
import '../domain/document_image_picker.dart';
import '../domain/document_scan_service.dart';
import '../domain/document_text_extractor.dart';

final documentTextExtractorProvider = Provider<DocumentTextExtractor>((ref) {
  final extractor = MlKitTextExtractor();
  ref.onDispose(() {
    extractor.dispose();
  });
  return extractor;
});

final documentImagePickerProvider = Provider<DocumentImagePicker>((ref) {
  return SystemDocumentImagePicker();
});

final documentScanServiceProvider = Provider<DocumentScanService>((ref) {
  return DocumentScanService(
    picker: ref.watch(documentImagePickerProvider),
    extractor: ref.watch(documentTextExtractorProvider),
  );
});

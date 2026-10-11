import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../comparison/domain/document_field.dart';
import '../data/mlkit_text_extractor.dart';
import '../data/system_document_image_picker.dart';
import '../domain/document_image_picker.dart';
import '../domain/document_scan_service.dart';
import '../domain/document_text_extractor.dart';
import '../domain/ocr_diagnostics.dart';

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

enum ScannerUiStep { idle, extracting, reviewing, cancelled, error }

class ScannerState {
  final ScannerUiStep step;
  final DocumentType selectedDocumentType;
  final String candidateName;
  final String candidateDob;
  final bool isNameAmbiguous;
  final bool isDobAmbiguous;
  final bool isYearOnly;
  final List<String> alternateNames;
  final List<String> alternateDobs;
  final List<String> notes;
  final String? errorMessage;
  final bool isConfirmed;
  final OcrDiagnostics? diagnostics;

  const ScannerState({
    this.step = ScannerUiStep.idle,
    this.selectedDocumentType = DocumentType.aadhaar,
    this.candidateName = '',
    this.candidateDob = '',
    this.isNameAmbiguous = false,
    this.isDobAmbiguous = false,
    this.isYearOnly = false,
    this.alternateNames = const [],
    this.alternateDobs = const [],
    this.notes = const [],
    this.errorMessage,
    this.isConfirmed = false,
    this.diagnostics,
  });

  ScannerState copyWith({
    ScannerUiStep? step,
    DocumentType? selectedDocumentType,
    String? candidateName,
    String? candidateDob,
    bool? isNameAmbiguous,
    bool? isDobAmbiguous,
    bool? isYearOnly,
    List<String>? alternateNames,
    List<String>? alternateDobs,
    List<String>? notes,
    String? errorMessage,
    bool? isConfirmed,
    OcrDiagnostics? diagnostics,
  }) {
    return ScannerState(
      step: step ?? this.step,
      selectedDocumentType: selectedDocumentType ?? this.selectedDocumentType,
      candidateName: candidateName ?? this.candidateName,
      candidateDob: candidateDob ?? this.candidateDob,
      isNameAmbiguous: isNameAmbiguous ?? this.isNameAmbiguous,
      isDobAmbiguous: isDobAmbiguous ?? this.isDobAmbiguous,
      isYearOnly: isYearOnly ?? this.isYearOnly,
      alternateNames: alternateNames ?? this.alternateNames,
      alternateDobs: alternateDobs ?? this.alternateDobs,
      notes: notes ?? this.notes,
      errorMessage: errorMessage ?? this.errorMessage,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      diagnostics: diagnostics ?? this.diagnostics,
    );
  }
}

class ScannerNotifier extends Notifier<ScannerState> {
  @override
  ScannerState build() {
    return const ScannerState();
  }

  Future<void> pickAndScan() async {
    state = state.copyWith(
      step: ScannerUiStep.extracting,
      errorMessage: null,
      isConfirmed: false,
    );

    final scanService = ref.read(documentScanServiceProvider);
    final result = await scanService.pickAndExtractDocument();

    if (result.isCancelled) {
      state = state.copyWith(step: ScannerUiStep.cancelled);
      return;
    }

    if (result.isFailure) {
      state = state.copyWith(
        step: ScannerUiStep.error,
        errorMessage:
            result.errorMessage ??
            'An unexpected error occurred while reading the document.',
      );
      return;
    }

    final parseResult = result.parseResult;
    state = state.copyWith(
      step: ScannerUiStep.reviewing,
      candidateName: parseResult?.candidateName?.detectedValue ?? '',
      candidateDob: parseResult?.candidateDob?.detectedValue ?? '',
      isNameAmbiguous: parseResult?.candidateName?.isAmbiguous ?? false,
      isDobAmbiguous: parseResult?.candidateDob?.isAmbiguous ?? false,
      isYearOnly: parseResult?.candidateDob?.isYearOnly ?? false,
      alternateNames: parseResult?.candidateName?.alternates ?? const [],
      alternateDobs: parseResult?.candidateDob?.alternates ?? const [],
      notes: parseResult?.notes ?? const [],
      diagnostics: parseResult?.diagnostics,
    );
  }

  void updateDocumentType(DocumentType type) {
    state = state.copyWith(selectedDocumentType: type);
  }

  void updateName(String name) {
    state = state.copyWith(candidateName: name);
  }

  void updateDob(String dob) {
    state = state.copyWith(candidateDob: dob);
  }

  void confirmDetails() {
    state = state.copyWith(isConfirmed: true);
  }

  void reset() {
    state = const ScannerState();
  }
}

final scannerControllerProvider =
    NotifierProvider<ScannerNotifier, ScannerState>(ScannerNotifier.new);

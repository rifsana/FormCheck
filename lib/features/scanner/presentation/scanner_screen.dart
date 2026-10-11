import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../domain/ocr_diagnostics.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../comparison/domain/document_field.dart';
import 'scanner_controller.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  late TextEditingController _nameController;
  late TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(scannerControllerProvider);
    _nameController = TextEditingController(text: state.candidateName);
    _dobController = TextEditingController(text: state.candidateDob);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _syncControllers(ScannerState state) {
    if (_nameController.text != state.candidateName) {
      _nameController.text = state.candidateName;
    }
    if (_dobController.text != state.candidateDob) {
      _dobController.text = state.candidateDob;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scannerControllerProvider);
    final notifier = ref.read(scannerControllerProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<ScannerState>(scannerControllerProvider, (prev, next) {
      if (prev?.step != next.step ||
          prev?.candidateName != next.candidateName ||
          prev?.candidateDob != next.candidateDob) {
        _syncControllers(next);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check your documents'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceSubtleDark
                  : AppColors.surfaceSubtleLight,
              borderRadius: BorderRadius.circular(AppRadius.badge),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 13,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                const SizedBox(width: 5),
                Text(
                  'On-device',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: _buildBodyContent(context, state, notifier, isDark),
        ),
      ),
    );
  }

  Widget _buildBodyContent(
    BuildContext context,
    ScannerState state,
    ScannerNotifier notifier,
    bool isDark,
  ) {
    switch (state.step) {
      case ScannerUiStep.extracting:
        return _buildExtractingState(isDark);

      case ScannerUiStep.error:
        return _buildErrorState(state, notifier, isDark);

      case ScannerUiStep.cancelled:
        return _buildCancelledState(notifier, isDark);

      case ScannerUiStep.reviewing:
        if (state.isConfirmed) {
          return _buildConfirmedState(context, state, notifier, isDark);
        }
        return _buildReviewingState(state, notifier, isDark);

      case ScannerUiStep.idle:
        return _buildIdleState(state, notifier, isDark);
    }
  }

  Widget _buildIdleState(
    ScannerState state,
    ScannerNotifier notifier,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Text(
          'Read identity document',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'Choose a photo of your identity document. FormCheck uses local on-device text recognition to detect your name and birth date for review.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 24),

        // Document Type Picker
        _buildDocumentTypeSelector(state, notifier, isDark),
        const SizedBox(height: 20),

        // Privacy & Feature Highlights Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFeatureRow(
                icon: Icons.shield_outlined,
                title: 'Private by design',
                description: 'Images are processed strictly on your phone. No document photos are uploaded or sent to servers.',
                isDark: isDark,
              ),
              const Divider(height: 24),
              _buildFeatureRow(
                icon: Icons.delete_sweep_outlined,
                title: 'Immediate cleanup',
                description: 'Temporary image files are deleted immediately after text extraction.',
                isDark: isDark,
              ),
              const Divider(height: 24),
              _buildFeatureRow(
                icon: Icons.edit_note_outlined,
                title: 'Editable review',
                description: 'Text recognition can make mistakes. You will review and verify all detected information.',
                isDark: isDark,
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Main CTA Button
        ElevatedButton.icon(
          onPressed: () => notifier.pickAndScan(),
          icon: const Icon(Icons.photo_library_outlined),
          label: const Text('Choose document image'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Disclaimer
        Text(
          'Notice: FormCheck is an independent preparation assistant. It does not verify physical document authenticity or guarantee acceptance by Passport Seva officials.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.5,
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          ),
        ),
      ],
    );
  }

  Widget _buildExtractingState(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? AppColors.silverAccent : AppColors.sapphirePrimary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Reading document on your phone...',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Running local OCR. Your photo is never uploaded.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelledState(ScannerNotifier notifier, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                size: 40,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              const SizedBox(height: 12),
              Text(
                'No document selected',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Image selection was cancelled. When you are ready, choose a photo of your document.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () => notifier.pickAndScan(),
          icon: const Icon(Icons.photo_library_outlined),
          label: const Text('Choose document image'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => notifier.reset(),
          child: const Text('Back to options'),
        ),
      ],
    );
  }

  Widget _buildErrorState(
    ScannerState state,
    ScannerNotifier notifier,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.errorBgDark : AppColors.errorBgLight,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: isDark
                  ? AppColors.errorBorderDark
                  : AppColors.errorBorderLight,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 40,
                color: isDark
                    ? AppColors.errorTextDark
                    : AppColors.errorTextLight,
              ),
              const SizedBox(height: 12),
              Text(
                'Could not read document',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.errorTextDark
                      : AppColors.errorTextLight,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                state.errorMessage ?? 'Please make sure the document image is sharp, clear, and well-lit.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.errorTextDark
                      : AppColors.errorTextLight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => notifier.pickAndScan(),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
          ),
          child: const Text('Try again'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => notifier.reset(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildReviewingState(
    ScannerState state,
    ScannerNotifier notifier,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Guidance Box
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.noticeBgDark : AppColors.noticeBgLight,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: isDark
                  ? AppColors.noticeBorderDark
                  : AppColors.noticeBorderLight,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 20,
                color: isDark
                    ? AppColors.noticeTextDark
                    : AppColors.noticeTextLight,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please verify extracted details',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.noticeTextDark
                            : AppColors.noticeTextLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Optical text recognition can make mistakes. Please check the spelling of your name and date of birth carefully against your physical card.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.noticeTextDark
                            : AppColors.noticeTextLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Document Type Confirmation
        _buildDocumentTypeSelector(state, notifier, isDark),
        const SizedBox(height: 20),

        // Editable Full Name Field
        Text(
          'Full Name (as printed on document)',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          key: const Key('scanner_name_field'),
          controller: _nameController,
          onChanged: (val) => notifier.updateName(val),
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.option),
            ),
            helperText:
                'Must match your official physical identity document exactly.',
          ),
        ),

        // Alternates for name if ambiguous
        if (state.isNameAmbiguous && state.alternateNames.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Other name lines detected:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: state.alternateNames.map((alt) {
              return ActionChip(
                label: Text(alt, style: const TextStyle(fontSize: 12)),
                onPressed: () {
                  _nameController.text = alt;
                  notifier.updateName(alt);
                },
              );
            }).toList(),
          ),
        ],

        const SizedBox(height: 20),

        // Editable Date of Birth Field
        Text(
          'Date of Birth',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          key: const Key('scanner_dob_field'),
          controller: _dobController,
          onChanged: (val) => notifier.updateDob(val),
          decoration: InputDecoration(
            hintText: 'DD/MM/YYYY (e.g. 15/08/1995)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.option),
            ),
            helperText: 'Enter day, month, and year (Passport Seva requires complete DOB).',
          ),
        ),

        // Year-only notice
        if (state.isYearOnly) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.noticeBgDark : AppColors.noticeBgLight,
              borderRadius: BorderRadius.circular(AppRadius.badge),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  size: 16,
                  color: isDark
                      ? AppColors.noticeTextDark
                      : AppColors.noticeTextLight,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Year-of-birth only was detected on your document. Enter your full birth date (DD/MM/YYYY).',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark
                          ? AppColors.noticeTextDark
                          : AppColors.noticeTextLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        // Alternates for DOB if ambiguous
        if (state.isDobAmbiguous && state.alternateDobs.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Other dates detected on document:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: state.alternateDobs.map((alt) {
              return ActionChip(
                label: Text(alt, style: const TextStyle(fontSize: 12)),
                onPressed: () {
                  _dobController.text = alt;
                  notifier.updateDob(alt);
                },
              );
            }).toList(),
          ),
        ],

        // Contextual notes
        if (state.notes.isNotEmpty) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceSubtleDark
                  : AppColors.surfaceSubtleLight,
              borderRadius: BorderRadius.circular(AppRadius.badge),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Extraction Notes',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                ...state.notes.map(
                  (n) => Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '• $n',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 28),

        // Confirmation Actions
        ElevatedButton(
          key: const Key('scanner_confirm_button'),
          onPressed: () => notifier.confirmDetails(),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
          ),
          child: const Text('Confirm details'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => notifier.pickAndScan(),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
          ),
          child: const Text('Choose different image'),
        ),

        // Ephemeral in-app debug diagnostics (available in debug builds only)
        if (kDebugMode && state.diagnostics != null) ...[
          const SizedBox(height: 24),
          _buildDebugDiagnosticSection(state.diagnostics!, isDark),
        ],
      ],
    );
  }

  Widget _buildConfirmedState(
    BuildContext context,
    ScannerState state,
    ScannerNotifier notifier,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.successBgDark : AppColors.successBgLight,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: isDark
                  ? AppColors.successBorderDark
                  : AppColors.successBorderLight,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 40,
                color: isDark
                    ? AppColors.successTextDark
                    : AppColors.successTextLight,
              ),
              const SizedBox(height: 12),
              Text(
                'Document details confirmed',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.successTextDark
                      : AppColors.successTextLight,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your verified details are ready.',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.successTextDark
                      : AppColors.successTextLight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Summary Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryRow(
                label: 'Document Type',
                value: state.selectedDocumentType.displayName,
                isDark: isDark,
              ),
              const Divider(height: 20),
              _buildSummaryRow(
                label: 'Name',
                value: state.candidateName.isEmpty
                    ? '(Not specified)'
                    : state.candidateName,
                isDark: isDark,
              ),
              const Divider(height: 20),
              _buildSummaryRow(
                label: 'Date of Birth',
                value: state.candidateDob.isEmpty
                    ? '(Not specified)'
                    : state.candidateDob,
                isDark: isDark,
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        ElevatedButton(
          onPressed: () => notifier.pickAndScan(),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
          ),
          child: const Text('Scan another document'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => context.pop(),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
          ),
          child: const Text('Back to checklist'),
        ),
      ],
    );
  }

  Widget _buildDocumentTypeSelector(
    ScannerState state,
    ScannerNotifier notifier,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Document type',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppRadius.option),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<DocumentType>(
              value: state.selectedDocumentType,
              isExpanded: true,
              onChanged: (val) {
                if (val != null) notifier.updateDocumentType(val);
              },
              items: DocumentType.values.map((type) {
                return DropdownMenuItem<DocumentType>(
                  value: type,
                  child: Text(
                    type.displayName,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: isDark ? AppColors.silverAccent : AppColors.sapphirePrimary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildDebugDiagnosticSection(OcrDiagnostics diag, bool isDark) {
    return Material(
      color: isDark ? const Color(0xFF16181D) : const Color(0xFFF0F2F5),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(
          color: isDark ? const Color(0xFF333842) : const Color(0xFFD0D5DD),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          leading: Icon(
            Icons.bug_report_outlined,
            size: 20,
            color: isDark ? Colors.amber[300] : Colors.amber[800],
          ),
          title: Text(
            'OCR Diagnostics (Debug only)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          subtitle: Text(
            'Build: ${diag.buildCommit}',
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'monospace',
              color: isDark
                  ? AppColors.textMutedDark
                  : AppColors.textMutedLight,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  // Summary Badges
                  Row(
                    children: [
                      _buildDiagBadge('Blocks: ${diag.totalBlocks}', isDark),
                      const SizedBox(width: 8),
                      _buildDiagBadge('Lines: ${diag.totalLines}', isDark),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildDiagRow(
                    'Dates Found by OCR',
                    diag.allExtractedDates.isEmpty
                        ? 'None'
                        : diag.allExtractedDates.join(', '),
                    isDark,
                  ),
                  _buildDiagRow(
                    'Primary DOB Selected',
                    diag.primaryDobSelected ?? '(None — Field left empty)',
                    isDark,
                  ),
                  _buildDiagRow(
                    'Excluded Dates (Issue/Validity)',
                    diag.excludedDates.isEmpty
                        ? 'None'
                        : diag.excludedDates.join(', '),
                    isDark,
                  ),
                  _buildDiagRow(
                    'Alternate Candidates',
                    diag.alternateDates.isEmpty
                        ? 'None'
                        : diag.alternateDates.join(', '),
                    isDark,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Redacted Line-by-Line Structure:',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 180),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F1012)
                          : const Color(0xFFE4E7EC),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: diag.lineDiagnostics.length,
                      itemBuilder: (ctx, idx) {
                        final ld = diag.lineDiagnostics[idx];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            'L${ld.lineNumber} [B${ld.blockIndex ?? '-'}] | ${ld.category}'
                            '${ld.classification != null ? ' -> ${ld.classification}' : ''}',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontFamily: 'monospace',
                              color: isDark
                                  ? const Color(0xFFD0D5DD)
                                  : const Color(0xFF344054),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Privacy note: No personal names, numbers, or unredacted text are logged or displayed.',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontStyle: FontStyle.italic,
                      color: isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagBadge(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF262A33) : const Color(0xFFD8DCE2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: 'monospace',
          color: isDark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
        ),
      ),
    );
  }

  Widget _buildDiagRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textMutedDark
                    : AppColors.textMutedLight,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11.5,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/official_sources.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/passport_rule.dart';
import 'checklist_controller.dart';

class ChecklistScreen extends ConsumerWidget {
  const ChecklistScreen({super.key});

  Future<void> _openSourceUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      try {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open external official link.'),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolution = ref.watch(checklistResolutionProvider);
    final progress = ref.watch(checklistProgressProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!resolution.isSupported) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checklist Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 40,
                  color: isDark
                      ? AppColors.errorTextDark
                      : AppColors.errorTextLight,
                ),
                const SizedBox(height: 14),
                Text(
                  resolution.unsupportedReason ??
                      'Unsupported application category.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14.5),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Back to Profile'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final totalActionable = resolution.requirements
        .where((r) => r.classification != RequirementClassification.guidance)
        .length;
    final collectedCount = resolution.requirements
        .where(
          (r) =>
              r.classification != RequirementClassification.guidance &&
              progress[r.id] == ItemCollectionStatus.collected,
        )
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Checklist'),
        actions: [
          IconButton(
            key: const Key('official_advisor_appbar_action'),
            tooltip: 'Official Document Advisor',
            icon: const Icon(Icons.open_in_browser_rounded, size: 20),
            onPressed: () =>
                _openSourceUrl(context, OfficialSources.docAdvisor.url),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Header (Apple Settings Grouped Inset Style)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDark
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$collectedCount of $totalActionable prepared',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                            letterSpacing: -0.1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: resolution.isNonEcrEligible
                                ? (isDark
                                      ? AppColors.successBgDark
                                      : AppColors.successBgLight)
                                : (isDark
                                      ? AppColors.noticeBgDark
                                      : AppColors.noticeBgLight),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: resolution.isNonEcrEligible
                                  ? (isDark
                                        ? AppColors.successBorderDark
                                        : AppColors.successBorderLight)
                                  : (isDark
                                        ? AppColors.noticeBorderDark
                                        : AppColors.noticeBorderLight),
                            ),
                          ),
                          child: Text(
                            resolution.isNonEcrEligible
                                ? 'Non-ECR'
                                : 'ECR Category',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: resolution.isNonEcrEligible
                                  ? (isDark
                                        ? AppColors.successTextDark
                                        : AppColors.successTextLight)
                                  : (isDark
                                        ? AppColors.noticeTextDark
                                        : AppColors.noticeTextLight),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: totalActionable > 0
                            ? collectedCount / totalActionable
                            : 0,
                        backgroundColor: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark
                              ? AppColors.silverAccent
                              : AppColors.sapphirePrimary,
                        ),
                        minHeight: 5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      resolution.nonEcrStatusDescription,
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

              const SizedBox(height: 12),

              // Restrained, Minimal Progress Disclaimer
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceSubtleDark
                      : AppColors.surfaceSubtleLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 14,
                      color: isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Marking items "Collected" records personal preparation only, not legal verification.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // SECTION 1: Mandatory Requirements
              Text(
                'MANDATORY DOCUMENTS',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: isDark
                      ? AppColors.textMutedDark
                      : AppColors.textMutedLight,
                ),
              ),
              const SizedBox(height: 8),
              ...resolution.mandatoryRequirements.map(
                (req) => _ChecklistRowCard(
                  key: Key('checklist_req_${req.id}'),
                  requirement: req,
                  status: progress[req.id] ?? ItemCollectionStatus.pending,
                  onToggle: () => ref
                      .read(checklistProgressProvider.notifier)
                      .toggleStatus(req.id),
                  onOpenSource: () => _openSourceUrl(context, req.source.url),
                ),
              ),

              // SECTION 2: Conditional Requirements
              if (resolution.conditionalRequirements.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  'CONDITIONAL REQUIREMENTS',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                  ),
                ),
                const SizedBox(height: 8),
                ...resolution.conditionalRequirements.map(
                  (req) => _ChecklistRowCard(
                    key: Key('checklist_req_${req.id}'),
                    requirement: req,
                    status: progress[req.id] ?? ItemCollectionStatus.pending,
                    onToggle: () => ref
                        .read(checklistProgressProvider.notifier)
                        .toggleStatus(req.id),
                    onOpenSource: () => _openSourceUrl(context, req.source.url),
                  ),
                ),
              ],

              // SECTION 3: PSK In-Person Guidance
              const SizedBox(height: 20),
              Text(
                'APPOINTMENT PREPARATION GUIDELINES',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: isDark
                      ? AppColors.textMutedDark
                      : AppColors.textMutedLight,
                ),
              ),
              const SizedBox(height: 8),
              ...resolution.guidanceNotes.map(
                (req) => _GuidanceRowCard(
                  requirement: req,
                  onOpenSource: () => _openSourceUrl(context, req.source.url),
                ),
              ),

              const SizedBox(height: 28),

              // Action button to proceed to Scanner (Phase 4)
              ElevatedButton.icon(
                key: const Key('proceed_to_scanner_button'),
                onPressed: () => context.push('/scanner'),
                icon: const Icon(Icons.document_scanner_outlined, size: 18),
                label: const Text('Check Document Mismatches (OCR)'),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChecklistRowCard extends StatefulWidget {
  final DocumentRequirement requirement;
  final ItemCollectionStatus status;
  final VoidCallback onToggle;
  final VoidCallback onOpenSource;

  const _ChecklistRowCard({
    super.key,
    required this.requirement,
    required this.status,
    required this.onToggle,
    required this.onOpenSource,
  });

  @override
  State<_ChecklistRowCard> createState() => _ChecklistRowCardState();
}

class _ChecklistRowCardState extends State<_ChecklistRowCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isCollected = widget.status == ItemCollectionStatus.collected;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title, Description, and Restrained Status Toggle
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.requirement.title,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.requirement.explanation,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Apple/Notion Style Restrained Status Toggle Pill (Accessible 48dp touch target)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: Key('toggle_status_${widget.requirement.id}'),
                    onTap: widget.onToggle,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 36,
                        minWidth: 84,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isCollected
                            ? (isDark
                                  ? AppColors.successBgDark
                                  : AppColors.successBgLight)
                            : (isDark
                                  ? AppColors.surfaceSubtleDark
                                  : AppColors.surfaceSubtleLight),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isCollected
                              ? (isDark
                                    ? AppColors.successBorderDark
                                    : AppColors.successBorderLight)
                              : (isDark
                                    ? AppColors.borderDark
                                    : AppColors.borderLight),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isCollected
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_off,
                            size: 15,
                            color: isCollected
                                ? (isDark
                                      ? AppColors.successTextDark
                                      : AppColors.successTextLight)
                                : (isDark
                                      ? AppColors.textMutedDark
                                      : AppColors.textMutedLight),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            isCollected ? 'Collected' : 'Pending',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isCollected
                                  ? (isDark
                                        ? AppColors.successTextDark
                                        : AppColors.successTextLight)
                                  : (isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (widget.requirement.applicabilityCondition != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceSubtleDark
                      : AppColors.surfaceSubtleLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.requirement.applicabilityCondition!,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ),
            ),

          Divider(
            height: 1,
            color: isDark
                ? AppColors.borderSubtleDark
                : AppColors.borderSubtleLight,
          ),

          // Evidence Expander Bar (With 48dp touch target and clear key)
          Material(
            color: Colors.transparent,
            child: InkWell(
              key: Key('expand_evidence_${widget.requirement.id}'),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Icon(
                      _expanded
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      size: 18,
                      color: isDark
                          ? AppColors.silverAccent
                          : AppColors.sapphirePrimary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${widget.requirement.acceptedEvidence.length} accepted evidence options',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.silverAccent
                              : AppColors.sapphirePrimary,
                        ),
                      ),
                    ),
                    Text(
                      _expanded ? 'Hide' : 'View options',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Expanded Evidence List (Notion bulleted hierarchy with standard Text widgets)
          if (_expanded) ...[
            Divider(
              height: 1,
              color: isDark
                  ? AppColors.borderSubtleDark
                  : AppColors.borderSubtleLight,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Column(
                children: widget.requirement.acceptedEvidence.map((doc) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.silverAccent
                                : AppColors.sapphirePrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                ),
                              ),
                              Text(
                                doc.conditions != null
                                    ? '${doc.issuingAuthority} — ${doc.conditions}'
                                    : doc.issuingAuthority,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          Divider(
            height: 1,
            color: isDark
                ? AppColors.borderSubtleDark
                : AppColors.borderSubtleLight,
          ),

          // Working Official Source Link Strip (Generous clickable area)
          Material(
            color: Colors.transparent,
            child: InkWell(
              key: Key('source_link_${widget.requirement.id}'),
              onTap: widget.onOpenSource,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Source: ${widget.requirement.source.title} (${widget.requirement.source.verifiedDate})',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.open_in_new,
                      size: 13,
                      color: isDark
                          ? AppColors.silverAccent
                          : AppColors.sapphirePrimary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidanceRowCard extends StatelessWidget {
  final DocumentRequirement requirement;
  final VoidCallback onOpenSource;

  const _GuidanceRowCard({
    required this.requirement,
    required this.onOpenSource,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  requirement.title,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 8),
                ...requirement.acceptedEvidence.map(
                  (guide) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 15,
                          color: isDark
                              ? AppColors.silverAccent
                              : AppColors.sapphirePrimary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                guide.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                ),
                              ),
                              if (guide.conditions != null)
                                Text(
                                  guide.conditions!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                    height: 1.3,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark
                ? AppColors.borderSubtleDark
                : AppColors.borderSubtleLight,
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onOpenSource,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Source: ${requirement.source.title} (${requirement.source.verifiedDate})',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.open_in_new,
                      size: 13,
                      color: isDark
                          ? AppColors.silverAccent
                          : AppColors.sapphirePrimary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

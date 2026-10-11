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
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
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
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  resolution.unsupportedReason ??
                      'Unsupported application category.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 24),
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

    // Calculate collected count
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
        title: const Text('Your Document Checklist'),
        actions: [
          IconButton(
            tooltip: 'Official Document Advisor',
            icon: const Icon(Icons.open_in_browser_rounded),
            onPressed: () =>
                _openSourceUrl(context, OfficialSources.docAdvisor.url),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceVariantDark
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
                          'Prepared $collectedCount of $totalActionable items',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          resolution.isNonEcrEligible
                              ? 'Non-ECR'
                              : 'ECR Category',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: resolution.isNonEcrEligible
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: totalActionable > 0
                          ? collectedCount / totalActionable
                          : 0,
                      backgroundColor: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      resolution.nonEcrStatusDescription,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Mandatory Disclaimer on Progress
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warningContainer.withValues(
                    alpha: isDark ? 0.2 : 0.4,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.onWarningContainer,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Marking items "Collected" records your personal prep progress only; it is not legal verification.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.onWarningContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // SECTION 1: Mandatory Requirements
              const Text(
                '1. Mandatory Documents',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              ...resolution.mandatoryRequirements.map(
                (req) => _RequirementCard(
                  requirement: req,
                  status: progress[req.id] ?? ItemCollectionStatus.pending,
                  onToggle: () => ref
                      .read(checklistProgressProvider.notifier)
                      .toggleStatus(req.id),
                  onOpenSource: () => _openSourceUrl(context, req.source.url),
                ),
              ),

              const SizedBox(height: 24),

              // SECTION 2: Conditional Requirements
              if (resolution.conditionalRequirements.isNotEmpty) ...[
                const Text(
                  '2. Conditional Requirements',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                ...resolution.conditionalRequirements.map(
                  (req) => _RequirementCard(
                    requirement: req,
                    status: progress[req.id] ?? ItemCollectionStatus.pending,
                    onToggle: () => ref
                        .read(checklistProgressProvider.notifier)
                        .toggleStatus(req.id),
                    onOpenSource: () => _openSourceUrl(context, req.source.url),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // SECTION 3: PSK In-Person Guidance
              const Text(
                '3. In-Person PSK Appointment Rules',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              ...resolution.guidanceNotes.map(
                (req) => _GuidanceCard(
                  requirement: req,
                  onOpenSource: () => _openSourceUrl(context, req.source.url),
                ),
              ),

              const SizedBox(height: 28),

              // Action button to proceed to Scanner (Phase 4)
              ElevatedButton.icon(
                key: const Key('proceed_to_scanner_button'),
                onPressed: () => context.push('/scanner'),
                icon: const Icon(Icons.document_scanner_outlined, size: 20),
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

class _RequirementCard extends StatefulWidget {
  final DocumentRequirement requirement;
  final ItemCollectionStatus status;
  final VoidCallback onToggle;
  final VoidCallback onOpenSource;

  const _RequirementCard({
    required this.requirement,
    required this.status,
    required this.onToggle,
    required this.onOpenSource,
  });

  @override
  State<_RequirementCard> createState() => _RequirementCardState();
}

class _RequirementCardState extends State<_RequirementCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isCollected = widget.status == ItemCollectionStatus.collected;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.requirement.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.requirement.explanation,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: widget.onToggle,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isCollected
                          ? AppColors.successContainer
                          : (isDark
                                ? AppColors.surfaceVariantDark
                                : const Color(0xFFF1F5F9)),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isCollected
                            ? AppColors.success
                            : AppColors.borderLight,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isCollected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          size: 16,
                          color: isCollected
                              ? AppColors.onSuccessContainer
                              : AppColors.textMutedLight,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isCollected ? 'Collected' : 'Pending',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isCollected
                                ? AppColors.onSuccessContainer
                                : (isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            if (widget.requirement.applicabilityCondition != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDark
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Condition: ${widget.requirement.applicabilityCondition!}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 10),

            // Accepted Evidence Toggle
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Row(
                children: [
                  Text(
                    '${widget.requirement.acceptedEvidence.length} accepted evidence options',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),

            if (_expanded) ...[
              const SizedBox(height: 8),
              ...widget.requirement.acceptedEvidence.map(
                (doc) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 12.5,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              height: 1.35,
                            ),
                            children: [
                              TextSpan(
                                text: doc.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: ' (${doc.issuingAuthority})',
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textMutedDark
                                      : AppColors.textMutedLight,
                                  fontSize: 11.5,
                                ),
                              ),
                              if (doc.conditions != null)
                                TextSpan(
                                  text: ' — ${doc.conditions}',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 11.5,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const Divider(height: 16),

            // Source Metadata Link
            Row(
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
                IconButton(
                  icon: const Icon(Icons.open_in_new, size: 14),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'View official source',
                  onPressed: widget.onOpenSource,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GuidanceCard extends StatelessWidget {
  final DocumentRequirement requirement;
  final VoidCallback onOpenSource;

  const _GuidanceCard({required this.requirement, required this.onOpenSource});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              requirement.title,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            ...requirement.acceptedEvidence.map(
              (guide) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            guide.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
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
            const Divider(height: 16),
            Row(
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
                IconButton(
                  icon: const Icon(Icons.open_in_new, size: 14),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'View official source',
                  onPressed: onOpenSource,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

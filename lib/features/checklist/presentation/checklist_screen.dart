import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/official_sources.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
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
            SnackBar(content: Text(context.l10n.couldNotOpenLink)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolution = ref.watch(checklistResolutionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = context.l10n;

    if (!resolution.isSupported) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.unsupportedCategoryTitle)),
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
                      l10n.unsupportedCategoryAdvisorNotice,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14.5),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.backButton),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.checklistTitle),
        actions: [
          IconButton(
            key: const Key('official_advisor_appbar_action'),
            tooltip: l10n.officialAdvisorAction,
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
              // Header Summary Card (Category & Non-ECR status)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDark
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppRadius.card),
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
                          l10n.requiredDocumentsHeader,
                          style: TextStyle(
                            fontSize: 15,
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
                            borderRadius: BorderRadius.circular(
                              AppRadius.badge,
                            ),
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
                                ? l10n.nonEcrBadge
                                : l10n.ecrBadge,
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
                    const SizedBox(height: 8),
                    Text(
                      resolution.nonEcrStatusDescription,
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

              const SizedBox(height: 24),

              // SECTION 1: Mandatory Documents
              Text(
                l10n.sectionEveryoneNeeds,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: isDark
                      ? AppColors.textMutedDark
                      : AppColors.textMutedLight,
                ),
              ),
              const SizedBox(height: 10),
              ...resolution.mandatoryRequirements.map(
                (req) => _ChecklistRowCard(
                  key: Key('checklist_req_${req.id}'),
                  requirement: req,
                  onOpenSource: () => _openSourceUrl(context, req.source.url),
                ),
              ),

              // SECTION 2: Conditional Requirements (if applicable)
              if (resolution.conditionalRequirements.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  l10n.sectionAdditionalDocs,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                  ),
                ),
                const SizedBox(height: 10),
                ...resolution.conditionalRequirements.map(
                  (req) => _ChecklistRowCard(
                    key: Key('checklist_req_${req.id}'),
                    requirement: req,
                    onOpenSource: () => _openSourceUrl(context, req.source.url),
                  ),
                ),
              ],

              // SECTION 3: PSK In-Person Guidance
              const SizedBox(height: 20),
              Text(
                l10n.sectionWhatToBring,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: isDark
                      ? AppColors.textMutedDark
                      : AppColors.textMutedLight,
                ),
              ),
              const SizedBox(height: 10),
              ...resolution.guidanceNotes.map(
                (req) => _GuidanceRowCard(
                  requirement: req,
                  onOpenSource: () => _openSourceUrl(context, req.source.url),
                ),
              ),

              const SizedBox(height: 24),

              // Appointment Reminder Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceSubtleDark
                      : AppColors.surfaceSubtleLight,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: isDark
                          ? AppColors.silverAccent
                          : AppColors.sapphirePrimary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.appointmentNotice,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
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
  final VoidCallback onOpenSource;

  const _ChecklistRowCard({
    super.key,
    required this.requirement,
    required this.onOpenSource,
  });

  @override
  State<_ChecklistRowCard> createState() => _ChecklistRowCardState();
}

class _ChecklistRowCardState extends State<_ChecklistRowCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // Header: Document Title and Explanation
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
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
                const SizedBox(height: 4),
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

          const Divider(height: 1),

          // Collapsible Action Bar: Accepted Evidence Expander & Source Link
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    key: Key('expand_evidence_${widget.requirement.id}'),
                    onTap: () => setState(() => _expanded = !_expanded),
                    borderRadius: BorderRadius.circular(AppRadius.option),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _expanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: isDark
                                ? AppColors.silverAccent
                                : AppColors.sapphirePrimary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _expanded
                                ? l10n.hideAcceptedDocs
                                : l10n.whatDocsAccepted(
                                    widget.requirement.acceptedEvidence.length,
                                  ),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.silverAccent
                                  : AppColors.sapphirePrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  key: Key('source_link_${widget.requirement.id}'),
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  tooltip: l10n.sourceLinkTooltip(
                    widget.requirement.source.title,
                  ),
                  onPressed: widget.onOpenSource,
                  visualDensity: VisualDensity.compact,
                  color: isDark
                      ? AppColors.textMutedDark
                      : AppColors.textMutedLight,
                ),
              ],
            ),
          ),

          // Expanded Evidence List
          if (_expanded) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceSubtleDark
                    : AppColors.surfaceSubtleLight,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppRadius.card),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.acceptableOptionsHeader,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...widget.requirement.acceptedEvidence.map(
                    (ev) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.check_circle_outline,
                              size: 14,
                              color: isDark
                                  ? AppColors.successTextDark
                                  : AppColors.successTextLight,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ev.name,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight,
                                  ),
                                ),
                                if (ev.conditions != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    ev.conditions!,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontStyle: FontStyle.italic,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                                Text(
                                  '${l10n.issuingAuthorityPrefix}${ev.issuingAuthority}',
                                  style: TextStyle(
                                    fontSize: 11,
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
                  ),
                ],
              ),
            ),
          ],
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
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: isDark ? AppColors.silverAccent : AppColors.sapphirePrimary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  requirement.title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  requirement.explanation,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new_rounded, size: 16),
            tooltip: l10n.sourceLinkTooltip(requirement.source.title),
            onPressed: onOpenSource,
            visualDensity: VisualDensity.compact,
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/official_sources.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/applicant_profile.dart';
import 'profile_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _currentStep = 0;

  Future<void> _openOfficialAdvisor() async {
    final uri = Uri.parse(OfficialSources.docAdvisor.url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open external official link.'),
          ),
        );
      }
    }
  }

  void _showUnsupportedModal(String reason) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.warning),
            SizedBox(width: 8),
            Text('Unsupported Category'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reason, style: const TextStyle(fontSize: 14, height: 1.4)),
            const SizedBox(height: 14),
            const Text(
              'Please visit the official Passport Seva Document Advisor to see the exact requirements for your specific category.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _openOfficialAdvisor();
            },
            child: const Text('Open Official Advisor'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Change Selection'),
          ),
        ],
      ),
    );
  }

  void _handleContinue() {
    final profile = ref.read(profileProvider);

    if (_currentStep == 0) {
      if (!profile.isSupported) {
        _showUnsupportedModal(profile.unsupportedReason!);
        return;
      }
      setState(() => _currentStep = 1);
    } else if (_currentStep == 1) {
      setState(() => _currentStep = 2);
    } else {
      context.push('/checklist');
    }
  }

  void _handleBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicant Profile'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: isDark
                ? AppColors.surfaceVariantDark
                : AppColors.borderLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceVariantDark
                            : AppColors.primaryContainer.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Step ${_currentStep + 1} of 3',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (_currentStep == 0) ...[
                      const Text(
                        'Confirm Application Scope',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'FormCheck supports first-time adult ordinary passport applicants under the Normal scheme.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _QuestionCard(
                        title: '1. Application Type',
                        children: [
                          _SelectableOption(
                            title: 'Fresh Passport (First-time)',
                            subtitle: 'You have never held an ordinary Indian passport',
                            selected:
                                profile.applicationType ==
                                ApplicationType.fresh,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateApplicationType(ApplicationType.fresh),
                          ),
                          const SizedBox(height: 8),
                          _SelectableOption(
                            title: 'Re-issue of Passport',
                            subtitle: 'Renewal, validity expired, pages exhausted, or lost',
                            selected:
                                profile.applicationType ==
                                ApplicationType.reissue,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateApplicationType(ApplicationType.reissue),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _QuestionCard(
                        title: '2. Application Scheme',
                        children: [
                          _SelectableOption(
                            title: 'Normal Scheme',
                            subtitle: 'Standard processing time (routine appointment)',
                            selected: profile.scheme == PassportScheme.normal,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateScheme(PassportScheme.normal),
                          ),
                          const SizedBox(height: 8),
                          _SelectableOption(
                            title: 'Tatkaal Scheme',
                            subtitle:
                                'Urgent processing with special verification',
                            selected: profile.scheme == PassportScheme.tatkaal,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateScheme(PassportScheme.tatkaal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _QuestionCard(
                        title: '3. Applicant Age',
                        children: [
                          _SelectableOption(
                            title: 'Adult (18 years of age or older)',
                            selected:
                                profile.ageCategory == AgeCategory.adult18Plus,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateAgeCategory(AgeCategory.adult18Plus),
                          ),
                          const SizedBox(height: 8),
                          _SelectableOption(
                            title: 'Minor (Under 18 years of age)',
                            selected:
                                profile.ageCategory == AgeCategory.minorUnder18,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateAgeCategory(AgeCategory.minorUnder18),
                          ),
                        ],
                      ),
                    ] else if (_currentStep == 1) ...[
                      const Text(
                        'Non-ECR Eligibility',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Emigration Check Not Required (Non-ECR) status allows travel abroad without emigration clearance. Select which verified category applies to you:',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _QuestionCard(
                        title: 'Select Your Highest Applicable Qualification / Status',
                        children: [
                          _SelectableOption(
                            title: '10th Standard (Matriculation) or Higher',
                            subtitle: 'Holds 10th pass certificate, 12th, degree, or post-graduation',
                            selected:
                                profile.nonEcrCriterion ==
                                NonEcrCriterion.matriculationOrAbove,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateNonEcrCriterion(
                                  NonEcrCriterion.matriculationOrAbove,
                                ),
                          ),
                          const SizedBox(height: 8),
                          _SelectableOption(
                            title: 'Income Tax Payer',
                            subtitle: 'Filed individual income tax return for the last assessment year',
                            selected:
                                profile.nonEcrCriterion ==
                                NonEcrCriterion.incomeTaxPayer,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateNonEcrCriterion(
                                  NonEcrCriterion.incomeTaxPayer,
                                ),
                          ),
                          const SizedBox(height: 8),
                          _SelectableOption(
                            title: '50 Years of Age or Older',
                            subtitle: 'All individuals aged 50+ qualify for Non-ECR automatically',
                            selected:
                                profile.nonEcrCriterion ==
                                NonEcrCriterion.age50Plus,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateNonEcrCriterion(
                                  NonEcrCriterion.age50Plus,
                                ),
                          ),
                          const SizedBox(height: 8),
                          _SelectableOption(
                            title: 'Gazetted Government Servant / PSU',
                            subtitle: 'Gazetted officers or immediate dependent family members',
                            selected:
                                profile.nonEcrCriterion ==
                                NonEcrCriterion.govtServant,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateNonEcrCriterion(
                                  NonEcrCriterion.govtServant,
                                ),
                          ),
                          const SizedBox(height: 8),
                          _SelectableOption(
                            title: '2-Year NCVT/SCVT Vocational Diploma',
                            subtitle: 'Completed recognized 2-year vocational trade diploma',
                            selected:
                                profile.nonEcrCriterion ==
                                NonEcrCriterion.vocationalDiploma2Year,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateNonEcrCriterion(
                                  NonEcrCriterion.vocationalDiploma2Year,
                                ),
                          ),
                          const SizedBox(height: 8),
                          _SelectableOption(
                            title: 'Spouse of Non-ECR Eligible Person',
                            subtitle: 'Spouse of an income tax payer, matriculate, or govt officer',
                            selected:
                                profile.nonEcrCriterion ==
                                NonEcrCriterion.spouseOfEligiblePerson,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateNonEcrCriterion(
                                  NonEcrCriterion.spouseOfEligiblePerson,
                                ),
                          ),
                          const SizedBox(height: 8),
                          _SelectableOption(
                            title: 'None of the Above (ECR Status)',
                            subtitle: 'Passport will be issued under ECR category; no educational proof required',
                            selected:
                                profile.nonEcrCriterion == NonEcrCriterion.none,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateNonEcrCriterion(NonEcrCriterion.none),
                          ),
                        ],
                      ),
                    ] else ...[
                      const Text(
                        'Additional Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Check for special conditions that alter document requirements.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _QuestionCard(
                        title: 'Name or Identity Changes',
                        children: [
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Have you ever changed your name?',
                            ),
                            subtitle: const Text(
                              'Includes legal name change, spelling correction in official records, or change of surname after marriage',
                            ),
                            value: profile.hasNameChange,
                            onChanged: (v) => ref
                                .read(profileProvider.notifier)
                                .updateHasNameChange(v),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withValues(
                            alpha: isDark ? 0.2 : 0.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'FormCheck does not ask for or collect sensitive numbers like Aadhaar or PAN. '
                                'We only evaluate which categories of proof apply to you.',
                                style: TextStyle(fontSize: 12.5, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Navigation bar at bottom
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ),
              ),
              child: Row(
                children: [
                  OutlinedButton(
                    key: const Key('profile_back_button'),
                    onPressed: _handleBack,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(100, 48),
                    ),
                    child: Text(_currentStep == 0 ? 'Cancel' : 'Back'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      key: const Key('profile_continue_button'),
                      onPressed: _handleContinue,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: Text(
                        _currentStep == 2 ? 'Generate Checklist' : 'Continue',
                      ),
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
}

class _QuestionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _QuestionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _SelectableOption extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _SelectableOption({
    required this.title,
    this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? (isDark
                    ? AppColors.surfaceVariantDark
                    : AppColors.primaryContainer.withValues(alpha: 0.35))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: selected
                  ? AppColors.primary
                  : (isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/official_sources.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
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
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      try {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
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
  }

  void _showUnsupportedModal(String reason) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: const Text('Unsupported Category'),
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
        title: const Text('About you'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: isDark
                ? AppColors.borderDark
                : AppColors.borderLight,
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? AppColors.silverAccent : AppColors.sapphirePrimary,
            ),
            minHeight: 2,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step Indicator
                    Text(
                      'STEP ${_currentStep + 1} OF 3',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                      ),
                    ),
                    const SizedBox(height: 6),

                    if (_currentStep == 0) ...[
                      Text(
                        'Your application',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'FormCheck is designed for first-time adult applicants applying under the normal scheme.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),

                      _SectionGroup(
                        title: 'Application type',
                        children: [
                          _SelectableTile(
                            title: 'Fresh passport (First-time)',
                            subtitle: 'You have never held an ordinary Indian passport before',
                            selected:
                                profile.applicationType ==
                                ApplicationType.fresh,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateApplicationType(ApplicationType.fresh),
                            showDivider: true,
                          ),
                          _SelectableTile(
                            title: 'Re-issue of passport',
                            subtitle: 'Renewing, replacing an expired passport, or pages full',
                            selected:
                                profile.applicationType ==
                                ApplicationType.reissue,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateApplicationType(ApplicationType.reissue),
                            showDivider: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      _SectionGroup(
                        title: 'Processing scheme',
                        children: [
                          _SelectableTile(
                            title: 'Normal scheme',
                            subtitle:
                                'Standard processing and routine appointment',
                            selected: profile.scheme == PassportScheme.normal,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateScheme(PassportScheme.normal),
                            showDivider: true,
                          ),
                          _SelectableTile(
                            title: 'Tatkaal scheme',
                            subtitle: 'Urgent processing requiring emergency verification',
                            selected: profile.scheme == PassportScheme.tatkaal,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateScheme(PassportScheme.tatkaal),
                            showDivider: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      _SectionGroup(
                        title: 'Your age',
                        children: [
                          _SelectableTile(
                            title: 'Adult (18 or older)',
                            selected:
                                profile.ageCategory == AgeCategory.adult18Plus,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateAgeCategory(AgeCategory.adult18Plus),
                            showDivider: true,
                          ),
                          _SelectableTile(
                            title: 'Under 18 (Minor)',
                            selected:
                                profile.ageCategory == AgeCategory.minorUnder18,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateAgeCategory(AgeCategory.minorUnder18),
                            showDivider: false,
                          ),
                        ],
                      ),
                    ] else if (_currentStep == 1) ...[
                      Text(
                        'Emigration status (Non-ECR)',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Non-ECR means you do not need emigration clearance when traveling for employment to 18 notified countries (e.g. Gulf countries, Malaysia). Clearance is not required for tourism or study. If you qualify, select your category below:',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),

                      _SectionGroup(
                        title: 'Select what applies to you',
                        children: [
                          _SelectableTile(
                            title: '10th grade (Matriculation) or higher',
                            subtitle: 'Holds a 10th pass, 12th, degree, or post-graduation certificate',
                            selected:
                                profile.nonEcrCriterion ==
                                NonEcrCriterion.matriculationOrAbove,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateNonEcrCriterion(
                                  NonEcrCriterion.matriculationOrAbove,
                                ),
                            showDivider: true,
                          ),
                          _SelectableTile(
                            title: 'Income tax payer',
                            subtitle: 'Filed an individual income tax return in the past year',
                            selected:
                                profile.nonEcrCriterion ==
                                NonEcrCriterion.incomeTaxPayer,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateNonEcrCriterion(
                                  NonEcrCriterion.incomeTaxPayer,
                                ),
                            showDivider: true,
                          ),
                          _SelectableTile(
                            title: '50 years of age or older',
                            subtitle: 'Anyone aged 50 and above qualifies automatically',
                            selected:
                                profile.nonEcrCriterion ==
                                NonEcrCriterion.age50Plus,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateNonEcrCriterion(
                                  NonEcrCriterion.age50Plus,
                                ),
                            showDivider: true,
                          ),
                          _SelectableTile(
                            title: 'Gazetted government servant / PSU',
                            subtitle: 'Gazetted officers or immediate dependent family members',
                            selected:
                                profile.nonEcrCriterion ==
                                NonEcrCriterion.govtServant,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateNonEcrCriterion(
                                  NonEcrCriterion.govtServant,
                                ),
                            showDivider: true,
                          ),
                          _SelectableTile(
                            title: '2-year vocational diploma',
                            subtitle: 'Completed a recognized 2-year NCVT or SCVT trade diploma',
                            selected:
                                profile.nonEcrCriterion ==
                                NonEcrCriterion.vocationalDiploma2Year,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateNonEcrCriterion(
                                  NonEcrCriterion.vocationalDiploma2Year,
                                ),
                            showDivider: true,
                          ),
                          _SelectableTile(
                            title: 'Spouse of a qualified person',
                            subtitle: 'Your spouse qualifies as a graduate, taxpayer, or govt officer',
                            selected:
                                profile.nonEcrCriterion ==
                                NonEcrCriterion.spouseOfEligiblePerson,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateNonEcrCriterion(
                                  NonEcrCriterion.spouseOfEligiblePerson,
                                ),
                            showDivider: true,
                          ),
                          _SelectableTile(
                            title: 'None of these (ECR status)',
                            subtitle: 'Your passport will be printed with Emigration Check Required; you do not need educational or tax proof',
                            selected:
                                profile.nonEcrCriterion == NonEcrCriterion.none,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateNonEcrCriterion(NonEcrCriterion.none),
                            showDivider: false,
                          ),
                        ],
                      ),
                    ] else ...[
                      Text(
                        'Name & history',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Let us know if your name has changed so we can include the right paperwork.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),

                      _SectionGroup(
                        title: 'Name change',
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: SwitchListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              title: const Text(
                                'Have you ever changed your name?',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                'Includes marriage surname addition, deed poll, or legal name update',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                              value: profile.hasNameChange,
                              onChanged: (v) => ref
                                  .read(profileProvider.notifier)
                                  .updateHasNameChange(v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.surfaceSubtleDark
                              : AppColors.surfaceSubtleLight,
                          borderRadius: BorderRadius.circular(AppRadius.option),
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
                              Icons.shield_outlined,
                              size: 18,
                              color: isDark
                                  ? AppColors.silverAccent
                                  : AppColors.sapphirePrimary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'FormCheck only works out which document rules apply to you. We never ask for or store sensitive numbers like Aadhaar or PAN.',
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
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Navigation Strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
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
                      minimumSize: const Size(90, 48),
                    ),
                    child: Text(_currentStep == 0 ? 'Cancel' : 'Back'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      key: const Key('profile_continue_button'),
                      onPressed: _handleContinue,
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

class _SectionGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: isDark
                  ? AppColors.textMutedDark
                  : AppColors.textMutedLight,
            ),
          ),
        ),
        Material(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
            side: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SelectableTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;
  final bool showDivider;

  const _SelectableTile({
    required this.title,
    this.subtitle,
    required this.selected,
    required this.onTap,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      selected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_off,
                      size: 19,
                      color: selected
                          ? (isDark
                                ? AppColors.silverAccent
                                : AppColors.sapphirePrimary)
                          : (isDark
                                ? AppColors.borderDark
                                : AppColors.textMutedLight),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                            letterSpacing: -0.1,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 48,
            color: isDark
                ? AppColors.borderSubtleDark
                : AppColors.borderSubtleLight,
          ),
      ],
    );
  }
}

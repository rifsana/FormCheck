import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/official_sources.dart';
import '../../../core/localization/app_localizations.dart';
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
            SnackBar(content: Text(context.l10n.couldNotOpenLink)),
          );
        }
      }
    }
  }

  void _showUnsupportedModal(String reason) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: Text(l10n.unsupportedCategoryTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reason, style: const TextStyle(fontSize: 14, height: 1.4)),
            const SizedBox(height: 14),
            Text(
              l10n.unsupportedCategoryAdvisorNotice,
              style: const TextStyle(
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
            child: Text(l10n.openOfficialAdvisor),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.changeSelection),
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.questionnaireTitle),
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
                      l10n.stepOf(_currentStep + 1),
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
                        l10n.step1Title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.step1Subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),

                      _SectionGroup(
                        title: l10n.applicationTypeLabel,
                        children: [
                          _SelectableTile(
                            title: l10n.freshPassportTitle,
                            subtitle: l10n.freshPassportSubtitle,
                            selected:
                                profile.applicationType ==
                                ApplicationType.fresh,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateApplicationType(ApplicationType.fresh),
                            showDivider: true,
                          ),
                          _SelectableTile(
                            title: l10n.reissuePassportTitle,
                            subtitle: l10n.reissuePassportSubtitle,
                            selected:
                                profile.applicationType ==
                                ApplicationType.reissue,
                            badge: 'Official guide',
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateApplicationType(ApplicationType.reissue),
                            showDivider: false,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      _SectionGroup(
                        title: l10n.passportSchemeLabel,
                        children: [
                          _SelectableTile(
                            title: l10n.normalSchemeTitle,
                            subtitle: l10n.normalSchemeSubtitle,
                            selected: profile.scheme == PassportScheme.normal,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateScheme(PassportScheme.normal),
                            showDivider: true,
                          ),
                          _SelectableTile(
                            title: l10n.tatkaalSchemeTitle,
                            subtitle: l10n.tatkaalSchemeSubtitle,
                            selected: profile.scheme == PassportScheme.tatkaal,
                            badge: 'Official guide',
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateScheme(PassportScheme.tatkaal),
                            showDivider: false,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      _SectionGroup(
                        title: l10n.ageCategoryLabel,
                        children: [
                          _SelectableTile(
                            title: l10n.adultAgeTitle,
                            subtitle: l10n.adultAgeSubtitle,
                            selected:
                                profile.ageCategory == AgeCategory.adult18Plus,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateAgeCategory(AgeCategory.adult18Plus),
                            showDivider: true,
                          ),
                          _SelectableTile(
                            title: l10n.minorAgeTitle,
                            subtitle: l10n.minorAgeSubtitle,
                            selected:
                                profile.ageCategory == AgeCategory.minorUnder18,
                            badge: 'Official guide',
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateAgeCategory(AgeCategory.minorUnder18),
                            showDivider: false,
                          ),
                        ],
                      ),
                    ] else if (_currentStep == 1) ...[
                      Text(
                        l10n.step2Title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.step2Subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),

                      _SectionGroup(
                        title: l10n.nonEcrCriteriaLabel,
                        children: [
                          _SelectableTile(
                            title: l10n.critMatriculation,
                            subtitle: l10n.critMatriculationSub,
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
                            title: l10n.critTaxPayer,
                            subtitle: l10n.critTaxPayerSub,
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
                            title: l10n.critAge50,
                            subtitle: l10n.critAge50Sub,
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
                            title: l10n.critGovtServant,
                            subtitle: l10n.critGovtServantSub,
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
                            title: l10n.critDiploma,
                            subtitle: l10n.critDiplomaSub,
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
                            title: l10n.critSpouse,
                            subtitle: l10n.critSpouseSub,
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
                            title: l10n.critNone,
                            subtitle: l10n.critNoneSub,
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
                        l10n.step3Title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.step3Subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),

                      _SectionGroup(
                        title: l10n.nameChangeQuestion,
                        children: [
                          _SelectableTile(
                            title: l10n.noOption,
                            subtitle: 'Never changed legal name',
                            selected: !profile.hasNameChange,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateHasNameChange(false),
                            showDivider: true,
                          ),
                          _SelectableTile(
                            title: l10n.yesOption,
                            subtitle: l10n.nameChangeSub,
                            selected: profile.hasNameChange,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateHasNameChange(true),
                            showDivider: false,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      _SectionGroup(
                        title: l10n.multipleAddressQuestion,
                        children: [
                          _SelectableTile(
                            title: l10n.noOption,
                            subtitle: 'Lived at current address only',
                            selected:
                                !profile.hasResidedMultipleAddressesPastYear,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateHasResidedMultipleAddresses(false),
                            showDivider: true,
                          ),
                          _SelectableTile(
                            title: l10n.yesOption,
                            subtitle: l10n.multipleAddressSub,
                            selected:
                                profile.hasResidedMultipleAddressesPastYear,
                            onTap: () => ref
                                .read(profileProvider.notifier)
                                .updateHasResidedMultipleAddresses(true),
                            showDivider: false,
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Controls
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                  if (_currentStep > 0)
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: _handleBack,
                        child: Text(l10n.backButton),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      key: const Key('profile_continue_button'),
                      onPressed: _handleContinue,
                      child: Text(
                        _currentStep == 2
                            ? l10n.generateChecklistCta
                            : l10n.continueButton,
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
        Text(
          title,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SelectableTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final String? badge;
  final VoidCallback onTap;
  final bool showDivider;

  const _SelectableTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    this.badge,
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
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? (isDark
                                  ? AppColors.silverAccent
                                  : AppColors.sapphirePrimary)
                            : (isDark
                                  ? AppColors.borderDark
                                  : AppColors.borderLight),
                        width: selected ? 5 : 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                ),
                              ),
                            ),
                            if (badge != null) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.noticeBgDark
                                      : AppColors.noticeBgLight,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.badge,
                                  ),
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.noticeBorderDark
                                        : AppColors.noticeBorderLight,
                                  ),
                                ),
                                child: Text(
                                  badge!,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? AppColors.noticeTextDark
                                        : AppColors.noticeTextLight,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
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

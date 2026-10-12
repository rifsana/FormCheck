import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/official_sources.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/language_selector_sheet.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  Future<void> _openOfficialPortal(BuildContext context) async {
    final uri = Uri.parse(OfficialSources.passportSevaPortal.url);
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

  void _showDisclaimerDialog(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: Text(l10n.legalNoticeTitle),
        content: Text(
          l10n.fullDisclaimerBody,
          style: const TextStyle(fontSize: 14, height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.iUnderstand),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: Text(l10n.privacyArchitectureTitle),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.privacyPoints,
                style: const TextStyle(fontSize: 13.5, height: 1.45),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.iUnderstand),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = context.l10n;
    final currentLocale = ref.watch(localeProvider);
    final currentLang = AppLanguage.fromCode(currentLocale.languageCode);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.sapphireContainerDark
                    : AppColors.sapphireContainerLight,
                borderRadius: BorderRadius.circular(AppRadius.badge),
              ),
              child: Icon(
                Icons.description_outlined,
                size: 18,
                color: isDark
                    ? AppColors.silverAccent
                    : AppColors.sapphirePrimary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              l10n.appName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        actions: [
          // Language selector button
          TextButton.icon(
            key: const Key('language_selector_button'),
            onPressed: () => showLanguageSelectorSheet(context),
            icon: const Icon(Icons.language_rounded, size: 16),
            label: Text(
              currentLang.nativeName,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              foregroundColor: isDark
                  ? AppColors.silverAccent
                  : AppColors.sapphirePrimary,
            ),
          ),
          IconButton(
            key: const Key('settings_button'),
            tooltip: l10n.settingsTitle,
            icon: const Icon(Icons.settings_outlined, size: 20),
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Headline
              Text(
                l10n.welcomeHeadline,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 8),

              // Supporting Text
              Text(
                l10n.welcomeSupportingText,
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 28),

              // Grouped Section for 3 Benefits (moderately rounded card)
              Container(
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
                  children: [
                    _BenefitTile(
                      icon: Icons.verified_outlined,
                      title: l10n.benefit1Title,
                      description: l10n.benefit1Desc,
                      showDivider: true,
                    ),
                    _BenefitTile(
                      icon: Icons.info_outline_rounded,
                      title: l10n.benefit2Title,
                      description: l10n.benefit2Desc,
                      showDivider: true,
                    ),
                    InkWell(
                      onTap: () => _showPrivacyDialog(context),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(AppRadius.card),
                      ),
                      child: _BenefitTile(
                        icon: Icons.lock_outline_rounded,
                        title: l10n.benefit3Title,
                        description: l10n.benefit3Desc,
                        showDivider: false,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Concise Notice
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showDisclaimerDialog(context),
                  borderRadius: BorderRadius.circular(AppRadius.option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
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
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textSecondaryLight,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            l10n.welcomeConciseDisclaimer,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                              height: 1.35,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Prominent Action Button (Softly rounded oval pill)
              ElevatedButton.icon(
                key: const Key('check_documents_button'),
                onPressed: () => context.push('/profile'),
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: Text(l10n.welcomeCta),
              ),

              const SizedBox(height: 12),

              // Official Portal Link
              Center(
                child: TextButton.icon(
                  onPressed: () => _openOfficialPortal(context),
                  icon: const Icon(Icons.open_in_browser_rounded, size: 15),
                  label: Text(l10n.officialPortal),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.sapphirePrimary,
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool showDivider;

  const _BenefitTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  icon,
                  size: 18,
                  color: isDark
                      ? AppColors.silverAccent
                      : AppColors.sapphirePrimary,
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
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
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
            ],
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

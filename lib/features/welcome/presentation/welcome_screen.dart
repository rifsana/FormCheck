import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/official_sources.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _openOfficialPortal(BuildContext context) async {
    final uri = Uri.parse(OfficialSources.applicationGuide.url);
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

  void _showDisclaimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: const Text('Legal Notice'),
        content: const Text(
          AppStrings.fullDisclaimerBody,
          style: TextStyle(fontSize: 14, height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('I Understand'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: const Text('Privacy Architecture'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '• Zero Cloud Uploads: Document information is never transmitted to remote servers.\n\n'
                '• Local Processing: All questionnaire inputs and checklist data are processed strictly on your smartphone.\n\n'
                '• No Remote Tracking: FormCheck contains no third-party analytics SDKs, trackers, or background telemetry.\n\n'
                '• No Sensitive Identifiers: FormCheck does not ask for or collect sensitive numbers like Aadhaar or PAN.',
                style: TextStyle(fontSize: 13.5, height: 1.45),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceSubtleDark
                    : AppColors.surfaceSubtleLight,
                borderRadius: BorderRadius.circular(AppRadius.badge),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Icon(
                Icons.assignment_turned_in_outlined,
                color: isDark
                    ? AppColors.silverAccent
                    : AppColors.sapphirePrimary,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              AppStrings.appName,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Legal Notice',
            icon: const Icon(Icons.info_outline_rounded, size: 20),
            onPressed: () => _showDisclaimerDialog(context),
          ),
          IconButton(
            tooltip: 'Privacy Information',
            icon: const Icon(Icons.shield_outlined, size: 20),
            onPressed: () => _showPrivacyDialog(context),
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
                AppStrings.welcomeHeadline,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 8),

              // Supporting Text
              Text(
                AppStrings.welcomeSupportingText,
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
                      title: AppStrings.benefit1Title,
                      description: AppStrings.benefit1Desc,
                      showDivider: true,
                    ),
                    _BenefitTile(
                      icon: Icons.compare_arrows_rounded,
                      title: AppStrings.benefit2Title,
                      description: AppStrings.benefit2Desc,
                      showDivider: true,
                    ),
                    _BenefitTile(
                      icon: Icons.lock_outline_rounded,
                      title: AppStrings.benefit3Title,
                      description: AppStrings.benefit3Desc,
                      showDivider: false,
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
                            AppStrings.welcomeConciseDisclaimer,
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
                label: const Text(AppStrings.welcomeCta),
              ),

              const SizedBox(height: 12),

              // Official Portal Link
              Center(
                child: TextButton.icon(
                  onPressed: () => _openOfficialPortal(context),
                  icon: const Icon(Icons.open_in_browser_rounded, size: 15),
                  label: const Text('Official Passport Seva Portal'),
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

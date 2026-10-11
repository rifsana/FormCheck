import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/official_sources.dart';
import '../../../core/theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _openOfficialPortal(BuildContext context) async {
    final uri = Uri.parse(OfficialSources.applicationGuide.url);
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

  void _showDisclaimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline_rounded, color: AppColors.warning),
            SizedBox(width: 8),
            Text('Legal Notice'),
          ],
        ),
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
        title: const Row(
          children: [
            Icon(Icons.shield_outlined, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Privacy Architecture'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '• Zero Cloud Uploads: Document information is never transmitted to remote servers.\n\n'
                '• Local Processing Architecture: On-device OCR processing executes entirely on your smartphone when scanning documents.\n\n'
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
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(
                  alpha: isDark ? 0.2 : 0.8,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.assignment_turned_in_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              AppStrings.appName,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 19,
                color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Legal Notice',
            icon: const Icon(Icons.info_outline_rounded, size: 22),
            onPressed: () => _showDisclaimerDialog(context),
          ),
          IconButton(
            tooltip: 'Privacy Information',
            icon: const Icon(Icons.shield_outlined, size: 22),
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
              // Scope Pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceVariantDark
                      : AppColors.primaryContainer.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  AppStrings.welcomeScopeCaption,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Headline
              Text(
                AppStrings.welcomeHeadline,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 10),

              // Supporting Text
              Text(
                AppStrings.welcomeSupportingText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 15.5,
                  height: 1.45,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),

              const SizedBox(height: 28),

              // 3 Compact Benefit Rows
              _BenefitRow(
                icon: Icons.verified_outlined,
                title: AppStrings.benefit1Title,
                description: AppStrings.benefit1Desc,
              ),
              const SizedBox(height: 16),
              _BenefitRow(
                icon: Icons.compare_arrows_rounded,
                title: AppStrings.benefit2Title,
                description: AppStrings.benefit2Desc,
              ),
              const SizedBox(height: 16),
              _BenefitRow(
                icon: Icons.lock_outline_rounded,
                title: AppStrings.benefit3Title,
                description: AppStrings.benefit3Desc,
              ),

              const SizedBox(height: 28),

              // Concise Disclaimer Strip
              InkWell(
                onTap: () => _showDisclaimerDialog(context),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warningContainer.withValues(
                      alpha: isDark ? 0.25 : 0.45,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: AppColors.onWarningContainer,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          AppStrings.welcomeConciseDisclaimer,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onWarningContainer,
                            height: 1.35,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: AppColors.onWarningContainer.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Prominent Action Button
              ElevatedButton.icon(
                key: const Key('check_documents_button'),
                onPressed: () => context.push('/profile'),
                icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                label: const Text(AppStrings.welcomeCta),
              ),

              const SizedBox(height: 12),

              // Official Portal Link
              Center(
                child: TextButton.icon(
                  onPressed: () => _openOfficialPortal(context),
                  icon: const Icon(Icons.open_in_browser_rounded, size: 16),
                  label: const Text('Official Passport Seva Portal'),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: isDark
                        ? AppColors.secondaryContainer
                        : AppColors.secondary,
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

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceVariantDark
                : AppColors.primaryContainer.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 19,
            color: isDark ? const Color(0xFF8AB4F8) : AppColors.primary,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
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
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/official_sources.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/disclaimer_banner.dart';
import '../../../core/widgets/official_source_badge.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _openOfficialPortal(BuildContext context) async {
    final uri = Uri.parse(OfficialSources.applicationInstructions.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.shield_outlined, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Privacy Guarantee'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '• 100% On-Device Processing: OCR and text extraction execute locally on your smartphone.\n\n'
                '• No Cloud Uploads: Documents and images are never sent to external servers or cloud services.\n\n'
                '• Zero Document Storage: Original photos are never saved by FormCheck without your permission.\n\n'
                '• No Sensitive Identifiers: FormCheck does not ask for or store Aadhaar numbers or bank passwords.',
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.assignment_turned_in_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              AppStrings.appName,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Privacy Information',
            icon: const Icon(Icons.shield_outlined),
            onPressed: () => _showPrivacyDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF164E8C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Document Preparation Assistant',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Prepare your passport\ndocuments with confidence.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Understand verified requirements, match names & dates, and avoid application delays.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Source verification badge
              const Center(child: OfficialSourceBadge()),

              const SizedBox(height: 16),

              // Prominent Disclaimer Banner
              const DisclaimerBanner(),

              const SizedBox(height: 16),

              // Supported Scope Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withValues(
                            alpha: 0.5,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_pin_outlined,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.supportedScopeTitle,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              AppStrings.supportedScopeDescription,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSecondaryLight,
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

              const SizedBox(height: 16),

              // Key feature highlights
              const Text(
                'How FormCheck Helps You',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 10),

              _FeatureItem(
                icon: Icons.checklist_rtl_rounded,
                title: AppStrings.feature1Title,
                description: AppStrings.feature1Desc,
              ),
              const SizedBox(height: 8),
              _FeatureItem(
                icon: Icons.compare_arrows_rounded,
                title: AppStrings.feature2Title,
                description: AppStrings.feature2Desc,
              ),
              const SizedBox(height: 8),
              _FeatureItem(
                icon: Icons.lock_outline_rounded,
                title: AppStrings.feature3Title,
                description: AppStrings.feature3Desc,
              ),

              const SizedBox(height: 24),

              // Call to Action Buttons
              ElevatedButton.icon(
                key: const Key('start_preparation_button'),
                onPressed: () => context.push('/profile'),
                icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                label: const Text('Start Document Check'),
              ),

              const SizedBox(height: 10),

              OutlinedButton.icon(
                onPressed: () => _openOfficialPortal(context),
                icon: const Icon(Icons.open_in_browser_rounded, size: 18),
                label: const Text('Visit Official Passport Seva Portal'),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
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
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondaryLight,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

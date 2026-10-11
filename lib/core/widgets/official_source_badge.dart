import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/official_sources.dart';
import '../theme/app_colors.dart';

class OfficialSourceBadge extends StatelessWidget {
  final String? customTitle;
  final String url;

  const OfficialSourceBadge({
    super.key,
    this.customTitle,
    this.url =
        'https://www.passportindia.gov.in/psp/docAdvisor/attachmentAdvFreshInp',
  });

  Future<void> _openSource(BuildContext context) async {
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openSource(context),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceSubtleDark
                : AppColors.surfaceSubtleLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified_outlined,
                size: 14,
                color: isDark
                    ? AppColors.silverAccent
                    : AppColors.sapphirePrimary,
              ),
              const SizedBox(width: 6),
              Text(
                customTitle ??
                    'Verified: MEA Passport Seva (${OfficialSources.verifiedDate})',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.open_in_new,
                size: 12,
                color: isDark
                    ? AppColors.textMutedDark
                    : AppColors.textMutedLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

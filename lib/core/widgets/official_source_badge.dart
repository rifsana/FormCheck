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
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open external official link.'),
            ),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error launching official link.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openSource(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.verified_outlined,
              size: 15,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              customTitle ??
                  'Verified: MEA Passport Seva (${OfficialSources.verifiedDate})',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.open_in_new, size: 13, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

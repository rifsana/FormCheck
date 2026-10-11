import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';

class DisclaimerBanner extends StatelessWidget {
  final bool compact;

  const DisclaimerBanner({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.warningContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.5),
          width: 1.2,
        ),
      ),
      padding: EdgeInsets.all(compact ? 12 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.onWarningContainer,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.independentNoticeTitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onWarningContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  compact
                      ? 'FormCheck is an independent tool and not affiliated with the Government of India.'
                      : AppStrings.independentNoticeBody,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onWarningContainer,
                    height: 1.4,
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

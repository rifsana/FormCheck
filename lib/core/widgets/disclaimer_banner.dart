import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/app_colors.dart';

class DisclaimerBanner extends StatelessWidget {
  final bool compact;

  const DisclaimerBanner({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.noticeBgDark : AppColors.noticeBgLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? AppColors.noticeBorderDark
              : AppColors.noticeBorderLight,
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: compact ? 10 : 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: isDark
                ? AppColors.noticeTextDark
                : AppColors.noticeTextLight,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.independentNoticeTitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.noticeTextDark
                        : AppColors.noticeTextLight,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  compact
                      ? 'FormCheck is an independent tool and not affiliated with the Government of India.'
                      : AppStrings.independentNoticeBody,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.noticeTextDark.withValues(alpha: 0.9)
                        : AppColors.noticeTextLight,
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

import 'package:flutter/material.dart';

/// FormCheck Design System:
/// Light Mode: "Porcelain & Sapphire" (Warm porcelain white #F7F7F5 + Deep Sapphire #234A91)
/// Dark Mode: "Obsidian & Silver" (Soft Obsidian #111214 + Restrained Silver-White #E2E8F0 / Muted Sapphire #4A7BD5)
class AppColors {
  // --- LIGHT MODE (Porcelain & Sapphire) ---
  static const Color backgroundLight = Color(0xFFF7F7F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceSubtleLight = Color(0xFFEFEFEA);
  static const Color surfaceContainerLight = Color(0xFFF2F3F0);
  static const Color borderLight = Color(0xFFE1E4E9);
  static const Color borderSubtleLight = Color(0xFFECEEF2);

  static const Color textPrimaryLight = Color(0xFF182235);
  static const Color textSecondaryLight = Color(0xFF586477);
  static const Color textMutedLight = Color(0xFF8692A4);

  // Sapphire Accent (Light)
  static const Color sapphirePrimary = Color(0xFF234A91);
  static const Color sapphireContainerLight = Color(0xFFE8EEF8);
  static const Color sapphireOnContainerLight = Color(0xFF163266);

  // Status Tones (Light - restrained, Notion/Apple style)
  static const Color successTextLight = Color(0xFF186E3C);
  static const Color successBgLight = Color(0xFFEDF7F1);
  static const Color successBorderLight = Color(0xFFC7E8D3);

  static const Color noticeTextLight = Color(0xFF8A5308);
  static const Color noticeBgLight = Color(0xFFFAF4EA);
  static const Color noticeBorderLight = Color(0xFFEADCC6);

  static const Color errorTextLight = Color(0xFFC52828);
  static const Color errorBgLight = Color(0xFFFDF0F0);
  static const Color errorBorderLight = Color(0xFFF7CECE);

  // --- DARK MODE (Obsidian & Silver) ---
  static const Color backgroundDark = Color(0xFF111214);
  static const Color surfaceDark = Color(0xFF191B20);
  static const Color surfaceSubtleDark = Color(0xFF21242B);
  static const Color surfaceContainerDark = Color(0xFF1E2127);
  static const Color borderDark = Color(0xFF303238);
  static const Color borderSubtleDark = Color(0xFF26282E);

  static const Color textPrimaryDark = Color(0xFFF2F3F5);
  static const Color textSecondaryDark = Color(0xFFB1B5BE);
  static const Color textMutedDark = Color(0xFF757A86);

  // Silver / Sapphire Accent (Dark)
  static const Color silverAccent = Color(0xFFE2E8F0);
  static const Color sapphireMutedDark = Color(0xFF4A7BD5);
  static const Color sapphireContainerDark = Color(0xFF182742);
  static const Color sapphireOnContainerDark = Color(0xFFD6E3F8);

  // Status Tones (Dark - restrained, Linear style)
  static const Color successTextDark = Color(0xFF4ADE80);
  static const Color successBgDark = Color(0xFF13251B);
  static const Color successBorderDark = Color(0xFF1F4830);

  static const Color noticeTextDark = Color(0xFFF5B842);
  static const Color noticeBgDark = Color(0xFF262014);
  static const Color noticeBorderDark = Color(0xFF47391F);

  static const Color errorTextDark = Color(0xFFF87171);
  static const Color errorBgDark = Color(0xFF2B1717);
  static const Color errorBorderDark = Color(0xFF532424);

  // Legacy mappings for backwards compatibility
  static const Color primary = sapphirePrimary;
  static const Color primaryContainer = sapphireContainerLight;
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = sapphireOnContainerLight;
  static const Color warning = noticeTextLight;
  static const Color warningContainer = noticeBgLight;
  static const Color onWarningContainer = noticeTextLight;
  static const Color success = successTextLight;
  static const Color successContainer = successBgLight;
  static const Color onSuccessContainer = successTextLight;
  static const Color error = errorTextLight;
  static const Color errorContainer = errorBgLight;
  static const Color onErrorContainer = errorTextLight;
}

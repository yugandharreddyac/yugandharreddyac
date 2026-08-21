import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Official UNIDOCS Black & Orange Branding Palette
  static const Color primary =
      Color(0xFFFF6B00); // Energetic CS Orange (Light Mode)
  static const Color primaryLight = Color(0xFFF97316); // Bright Orange Accent
  static const Color primaryDark =
      Color(0xFFE87C3E); // Softer, less glaring orange for Dark Mode
  static const Color secondary = Color(0xFFC2410C); // Secondary Warm Orange
  static const Color accent = primary; // Primary Orange Accent

  // Surface & Background Colors - Light Theme
  static const Color backgroundLight =
      Color(0xFFF8FAFC); // Soft White/Gray Background
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure White Surface
  static const Color cardLight = Colors.white;
  static const Color borderLight = Color(0xFFE2E8F0); // Clean Neutral Border
  static const Color textPrimaryLight =
      Color(0xFF0F172A); // Deep Charcoal Headings
  static const Color textSecondaryLight =
      Color(0xFF64748B); // Neutral Subtitle Text

  // Surface & Background Colors - Black & Dark Charcoal Theme
  static const Color backgroundDark = Color(0xFF09090B); // Deep Rich Black
  static const Color surfaceDark = Color(0xFF18181B); // Sleek Dark Charcoal
  static const Color cardDark = Color(0xFF18181B); // Sleek Dark Charcoal Card
  static const Color portalCardBlue = Color(0xFF18181B);
  static const Color portalBackgroundDark = Color(0xFF09090B);
  static const Color borderDark = Color(0xFF27272A); // Subtle Dark Border
  static const Color textPrimaryDark = Color(0xFFFAFAFA); // Crisp White
  static const Color textSecondaryDark = Color(0xFFA1A1AA); // Muted Gray

  // Semantic Status Colors
  static const Color success = Color(0xFF10B981); // Emerald Green
  static const Color successDark = Color(0xFF059669);
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color warningDark = Color(0xFFD97706);
  static const Color error = Color(0xFFEF4444); // Crimson Red
  static const Color errorDark = Color(0xFFDC2626);
  static const Color completed = Color(0xFF3B82F6); // Blue

  // Card & Border Aliases
  static const Color darkCardBackground = Color(0xFF18181B);
  static const Color darkCardBorder = Color(0xFF27272A);
  static const Color lightCardBorder = borderLight;

  // Header Gradients
  static const LinearGradient headerGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient darkHeaderGradient = LinearGradient(
    colors: [Color(0xFF09090B), Color(0xFF18181B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Resource Type Specific Colors
  static const Color syllabusColor = Color(0xFFFF6B00);
  static const Color notesColor = Color(0xFFF97316);
  static const Color pastPapersColor = Color(0xFFEA580C);

  // Shimmer Skeleton Colors
  static const Color shimmerBaseLight = Color(0xFFE2E8F0);
  static const Color shimmerHighlightLight = Color(0xFFF1F5F9);
  static const Color shimmerBaseDark = Color(0xFF18181B);
  static const Color shimmerHighlightDark = Color(0xFF27272A);
}

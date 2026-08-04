import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Branding Palette (CSSE Modern Academic Theme)
  static const Color primary = Color(0xFF2563EB); // Royal Blue
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color secondary = Color(0xFF3B82F6); // Secondary Blue Accent
  static const Color accent = Color(0xFF06B6D4); // Cyan Accent
  static const Color accentGradientStart = Color(0xFF2563EB);
  static const Color accentGradientEnd = Color(0xFF06B6D4);

  // Surface & Background Colors - Light Theme
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Colors.white;
  static const Color cardLight = Colors.white;
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);

  // Surface & Background Colors - Dark Theme
  static const Color backgroundDark = Color(0xFF0F172A); // Slate 900
  static const Color surfaceDark = Color(0xFF1E293B); // Slate 800
  static const Color cardDark = Color(0xFF1E293B);
  static const Color borderDark = Color(0xFF334155); // Slate 700
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Card & Border Aliases
  static const Color darkCardBackground = cardDark;
  static const Color darkCardBorder = borderDark;
  static const Color lightCardBorder = borderLight;

  // Header Gradients
  static const LinearGradient headerGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient darkHeaderGradient = LinearGradient(
    colors: [primaryDark, surfaceDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Functional Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Resource Type Specific Colors (Official 3 Categories)
  static const Color syllabusColor = Color(0xFF2563EB);
  static const Color notesColor = Color(0xFF10B981);
  static const Color pastPapersColor = Color(0xFF8B5CF6);

  // Shimmer Skeleton Colors
  static const Color shimmerBaseLight = Color(0xFFE2E8F0);
  static const Color shimmerHighlightLight = Color(0xFFF8FAFC);
  static const Color shimmerBaseDark = Color(0xFF1E293B);
  static const Color shimmerHighlightDark = Color(0xFF334155);
}

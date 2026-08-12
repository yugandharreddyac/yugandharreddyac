import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Official UNIDOCS Branding Palette (Primary Blue, Black, White)
  static const Color primary = Color(0xFF2563EB); // Royal Primary Blue
  static const Color primaryLight = Color(0xFF3B82F6); // Soft Accent Blue
  static const Color accent = primaryLight; // Alias for backward compatibility
  static const Color primaryDark = Color(0xFF1D4ED8); // Deep Navy Blue
  static const Color secondary = Color(0xFF1E40AF); // Secondary Deep Blue

  // Surface & Background Colors - Light Theme (Pure White & Light Grey)
  static const Color backgroundLight = Color(0xFFFFFFFF); // Pure White Background
  static const Color surfaceLight = Color(0xFFF8FAFC); // Off-White Surface
  static const Color cardLight = Colors.white;
  static const Color borderLight = Color(0xFFE2E8F0); // Light Grey Border
  static const Color textPrimaryLight = Color(0xFF0F172A); // Slate Black Headings
  static const Color textSecondaryLight = Color(0xFF475569); // Dark Grey Body Text

  // Surface & Background Colors - University Portal Dark Theme
  static const Color backgroundDark = Color(0xFF0F172A); // Dark Slate Navy #0F172A
  static const Color surfaceDark = Color(0xFF1E293B); // Slate Dark 800 #1E293B
  static const Color cardDark = Color(0xFF1E293B); // Sleek Dark Slate Card #1E293B
  static const Color portalCardBlue = Color(0xFF1E293B); // Sleek Dark Slate Card
  static const Color portalBackgroundDark = Color(0xFF0F172A); // Dark Navy #0F172A
  static const Color borderDark = Color(0xFF334155); // Subtle Slate Border #334155
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Card & Border Aliases
  static const Color darkCardBackground = Color(0xFF1E293B);
  static const Color darkCardBorder = Color(0xFF334155);
  static const Color lightCardBorder = borderLight;

  // Header Gradients (Unified Blue Tonal Gradients)
  static const LinearGradient headerGradient = LinearGradient(
    colors: [primaryDark, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient darkHeaderGradient = LinearGradient(
    colors: [backgroundDark, surfaceDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Functional Status Colors
  static const Color success = Color(0xFF2563EB); // Unified Primary Blue for success status
  static const Color warning = Color(0xFF1E40AF);
  static const Color error = Color(0xFFDC2626);

  // Resource Type Specific Colors (Unified Blue Palette)
  static const Color syllabusColor = Color(0xFF2563EB);
  static const Color notesColor = Color(0xFF1D4ED8);
  static const Color pastPapersColor = Color(0xFF3B82F6);

  // Shimmer Skeleton Colors
  static const Color shimmerBaseLight = Color(0xFFE2E8F0);
  static const Color shimmerHighlightLight = Color(0xFFF8FAFC);
  static const Color shimmerBaseDark = Color(0xFF1E293B);
  static const Color shimmerHighlightDark = Color(0xFF334155);
}

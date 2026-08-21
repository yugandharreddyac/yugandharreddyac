import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class SubjectIconInfo {
  final String emoji;
  final IconData icon;
  final Color accentColor;

  const SubjectIconInfo({
    required this.emoji,
    required this.icon,
    required this.accentColor,
  });
}

class Formatters {
  Formatters._();

  /// Converts bytes into readable size (e.g. 2.4 MB, 500 KB)
  static String formatBytes(int bytes, {int decimals = 1}) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i =
        (bytes > 0) ? (bytes == 0 ? 0 : (bytes.toString().length - 1) ~/ 3) : 0;
    if (i >= suffixes.length) i = suffixes.length - 1;
    double num = bytes / (1 << (10 * i));
    return '${num.toStringAsFixed(num.truncateToDouble() == num ? 0 : decimals)} ${suffixes[i]}';
  }

  static String formatFileSize(int bytes, {int decimals = 1}) =>
      formatBytes(bytes, decimals: decimals);

  /// Formats DateTime into legible string (e.g. Aug 02, 2026)
  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  /// Formats today's full date for dashboard header
  static String formatHeaderDate() {
    return DateFormat('EEEE, MMM dd, yyyy').format(DateTime.now());
  }

  /// Returns distinct color associated with a resource type
  static Color getResourceTypeColor(String type) {
    switch (type) {
      case AppConstants.typeSyllabus:
        return AppColors.syllabusColor;
      case AppConstants.typeNotes:
        return AppColors.notesColor;
      case AppConstants.typePastPapers:
        return AppColors.pastPapersColor;
      default:
        return AppColors.primary;
    }
  }

  /// Returns appropriate IconData for resource category
  static IconData getResourceTypeIcon(String type) {
    switch (type) {
      case AppConstants.typeSyllabus:
        return Icons.article_outlined;
      case AppConstants.typeNotes:
        return Icons.menu_book_outlined;
      case AppConstants.typePastPapers:
        return Icons.history_edu_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  static final List<Color> _subjectPalette = [
    const Color(0xFF4F46E5), // Indigo
    const Color(0xFF14B8A6), // Teal
    const Color(0xFFE11D48), // Rose
    const Color(0xFF64748B), // Slate
    const Color(0xFF8B5CF6), // Purple
    const Color(0xFFD97706), // Amber
    const Color(0xFF2563EB), // Royal Blue
    const Color(0xFF7C3AED), // Deep Purple
    const Color(0xFF0284C7), // Sky Blue
    const Color(0xFFDC2626), // Red
    const Color(0xFF16A34A), // Green
    const Color(0xFFF97316), // Orange
    const Color(0xFF06B6D4), // Cyan
    const Color(0xFFF59E0B), // Yellow/Amber
  ];

  static Color getDeterministicColor(String name) {
    if (name.isEmpty) return _subjectPalette[0];
    int hash = name.hashCode;
    return _subjectPalette[hash.abs() % _subjectPalette.length];
  }

  /// Returns dedicated emoji, Material Icon and deterministically assigned accent color per subject
  static SubjectIconInfo getSubjectIconInfo(String name) {
    final lower = name.toLowerCase();
    final accentColor = getDeterministicColor(name);

    if (lower.contains('c programming') || lower.contains('programming in c')) {
      return SubjectIconInfo(
          emoji: '💻', icon: Icons.code_rounded, accentColor: accentColor);
    } else if (lower.contains('data structures')) {
      return SubjectIconInfo(
          emoji: '🌳',
          icon: Icons.account_tree_rounded,
          accentColor: accentColor);
    } else if (lower.contains('java') || lower.contains('python')) {
      return SubjectIconInfo(
          emoji: '☕', icon: Icons.coffee_rounded, accentColor: accentColor);
    } else if (lower.contains('operating system') || lower.contains('os')) {
      return SubjectIconInfo(
          emoji: '🖥️', icon: Icons.terminal_rounded, accentColor: accentColor);
    } else if (lower.contains('digital logic') ||
        lower.contains('organization') ||
        lower.contains('architecture') ||
        lower.contains('coa')) {
      return SubjectIconInfo(
          emoji: '⚙️', icon: Icons.memory_rounded, accentColor: accentColor);
    } else if (lower.contains('database') ||
        lower.contains('dbms') ||
        lower.contains('data mining')) {
      return SubjectIconInfo(
          emoji: '🗄️', icon: Icons.dataset_rounded, accentColor: accentColor);
    } else if (lower.contains('network') || lower.contains('communication')) {
      return SubjectIconInfo(
          emoji: '🌐', icon: Icons.router_rounded, accentColor: accentColor);
    } else if (lower.contains('artificial intelligence') ||
        lower.contains(' ai ') ||
        lower.contains('machine learning') ||
        lower.contains(' ml ')) {
      return SubjectIconInfo(
          emoji: '🤖',
          icon: Icons.psychology_rounded,
          accentColor: accentColor);
    } else if (lower.contains('cloud computing') || lower.contains('cloud')) {
      return SubjectIconInfo(
          emoji: '☁️',
          icon: Icons.cloud_queue_rounded,
          accentColor: accentColor);
    } else if (lower.contains('cryptography') || lower.contains('security')) {
      return SubjectIconInfo(
          emoji: '🔐', icon: Icons.security_rounded, accentColor: accentColor);
    } else if (lower.contains('software engineering') ||
        lower.contains('oose')) {
      return SubjectIconInfo(
          emoji: '🏗️',
          icon: Icons.engineering_rounded,
          accentColor: accentColor);
    } else if (lower.contains('project')) {
      return SubjectIconInfo(
          emoji: '🚀',
          icon: Icons.rocket_launch_rounded,
          accentColor: accentColor);
    } else if (lower.contains('green chemistry') ||
        lower.contains('chemistry')) {
      return SubjectIconInfo(
          emoji: '🌿', icon: Icons.science_rounded, accentColor: accentColor);
    } else if (lower.contains('english')) {
      return SubjectIconInfo(
          emoji: '📖', icon: Icons.menu_book_rounded, accentColor: accentColor);
    } else if (lower.contains('math')) {
      return SubjectIconInfo(
          emoji: '🔢', icon: Icons.calculate_rounded, accentColor: accentColor);
    } else if (lower.contains('it essentials') ||
        lower.contains('essentials')) {
      return SubjectIconInfo(
          emoji: '💻', icon: Icons.computer_rounded, accentColor: accentColor);
    } else if (lower.contains('physics') || lower.contains('electronic')) {
      return SubjectIconInfo(
          emoji: '⚡', icon: Icons.bolt_rounded, accentColor: accentColor);
    } else if (lower.contains('microprocessor') ||
        lower.contains('microcontroller') ||
        lower.contains('compiler') ||
        lower.contains('automata') ||
        lower.contains('embedded')) {
      return SubjectIconInfo(
          emoji: '⚙️',
          icon: Icons.developer_board_rounded,
          accentColor: accentColor);
    } else if (lower.contains('algorithm')) {
      return SubjectIconInfo(
          emoji: '⚡', icon: Icons.speed_rounded, accentColor: accentColor);
    } else if (lower.contains('economics') || lower.contains('managerial')) {
      return SubjectIconInfo(
          emoji: '📊', icon: Icons.bar_chart_rounded, accentColor: accentColor);
    }

    return SubjectIconInfo(
        emoji: '📚', icon: Icons.book_rounded, accentColor: accentColor);
  }
}

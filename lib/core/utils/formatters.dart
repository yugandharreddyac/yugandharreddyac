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
    var i = (bytes > 0) ? (bytes == 0 ? 0 : (bytes.toString().length - 1) ~/ 3) : 0;
    if (i >= suffixes.length) i = suffixes.length - 1;
    double num = bytes / (1 << (10 * i));
    return '${num.toStringAsFixed(num.truncateToDouble() == num ? 0 : decimals)} ${suffixes[i]}';
  }

  static String formatFileSize(int bytes, {int decimals = 1}) => formatBytes(bytes, decimals: decimals);


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

  /// Returns dedicated emoji, Material Icon and small accent color per CSSE subject
  static SubjectIconInfo getSubjectIconInfo(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('c programming') || lower.contains('programming in c')) {
      return const SubjectIconInfo(emoji: '💻', icon: Icons.code_rounded, accentColor: Color(0xFF4F46E5)); // Indigo
    } else if (lower.contains('data structures')) {
      return const SubjectIconInfo(emoji: '🌳', icon: Icons.account_tree_rounded, accentColor: Color(0xFF14B8A6)); // Teal
    } else if (lower.contains('java') || lower.contains('python')) {
      return const SubjectIconInfo(emoji: '☕', icon: Icons.coffee_rounded, accentColor: Color(0xFFE11D48)); // Rose
    } else if (lower.contains('operating system') || lower.contains('os')) {
      return const SubjectIconInfo(emoji: '🖥️', icon: Icons.terminal_rounded, accentColor: Color(0xFF64748B)); // Slate
    } else if (lower.contains('digital logic') || lower.contains('organization') || lower.contains('architecture') || lower.contains('coa')) {
      return const SubjectIconInfo(emoji: '⚙️', icon: Icons.memory_rounded, accentColor: Color(0xFF8B5CF6)); // Purple
    } else if (lower.contains('database') || lower.contains('dbms') || lower.contains('data mining')) {
      return const SubjectIconInfo(emoji: '🗄️', icon: Icons.dataset_rounded, accentColor: Color(0xFFD97706)); // Amber
    } else if (lower.contains('network') || lower.contains('communication')) {
      return const SubjectIconInfo(emoji: '🌐', icon: Icons.router_rounded, accentColor: Color(0xFF2563EB)); // Royal Blue
    } else if (lower.contains('artificial intelligence') || lower.contains(' ai ') || lower.contains('machine learning') || lower.contains(' ml ')) {
      return const SubjectIconInfo(emoji: '🤖', icon: Icons.psychology_rounded, accentColor: Color(0xFF7C3AED)); // Deep Purple
    } else if (lower.contains('cloud computing') || lower.contains('cloud')) {
      return const SubjectIconInfo(emoji: '☁️', icon: Icons.cloud_queue_rounded, accentColor: Color(0xFF0284C7)); // Sky Blue
    } else if (lower.contains('cryptography') || lower.contains('security')) {
      return const SubjectIconInfo(emoji: '🔐', icon: Icons.security_rounded, accentColor: Color(0xFFDC2626)); // Red
    } else if (lower.contains('software engineering') || lower.contains('oose')) {
      return const SubjectIconInfo(emoji: '🏗️', icon: Icons.engineering_rounded, accentColor: Color(0xFF2563EB)); // Blue
    } else if (lower.contains('project')) {
      return const SubjectIconInfo(emoji: '🚀', icon: Icons.rocket_launch_rounded, accentColor: Color(0xFF4F46E5)); // Indigo
    } else if (lower.contains('green chemistry') || lower.contains('chemistry')) {
      return const SubjectIconInfo(emoji: '🌿', icon: Icons.science_rounded, accentColor: Color(0xFF16A34A)); // Green
    } else if (lower.contains('english')) {
      return const SubjectIconInfo(emoji: '📖', icon: Icons.menu_book_rounded, accentColor: Color(0xFFF97316)); // Orange
    } else if (lower.contains('math')) {
      return const SubjectIconInfo(emoji: '🔢', icon: Icons.calculate_rounded, accentColor: Color(0xFF10B981)); // Emerald
    } else if (lower.contains('it essentials') || lower.contains('essentials')) {
      return const SubjectIconInfo(emoji: '💻', icon: Icons.computer_rounded, accentColor: Color(0xFF06B6D4)); // Cyan
    } else if (lower.contains('physics') || lower.contains('electronic')) {
      return const SubjectIconInfo(emoji: '⚡', icon: Icons.bolt_rounded, accentColor: Color(0xFFF59E0B)); // Amber
    } else if (lower.contains('microprocessor') || lower.contains('microcontroller') || lower.contains('compiler') || lower.contains('automata') || lower.contains('embedded')) {
      return const SubjectIconInfo(emoji: '⚙️', icon: Icons.developer_board_rounded, accentColor: Color(0xFF8B5CF6)); // Purple
    } else if (lower.contains('algorithm')) {
      return const SubjectIconInfo(emoji: '⚡', icon: Icons.speed_rounded, accentColor: Color(0xFF14B8A6)); // Teal
    } else if (lower.contains('economics') || lower.contains('managerial')) {
      return const SubjectIconInfo(emoji: '📊', icon: Icons.bar_chart_rounded, accentColor: Color(0xFFD97706)); // Amber
    }

    return const SubjectIconInfo(emoji: '📚', icon: Icons.book_rounded, accentColor: Color(0xFF2563EB));
  }
}

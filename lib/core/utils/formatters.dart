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

  /// Returns dedicated emoji, Material Icon and accent color per CSSE subject
  static SubjectIconInfo getSubjectIconInfo(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('c programming') || lower.contains('programming in c')) {
      return const SubjectIconInfo(emoji: '💻', icon: Icons.code_rounded, accentColor: Colors.blue);
    } else if (lower.contains('java')) {
      return const SubjectIconInfo(emoji: '☕', icon: Icons.coffee_rounded, accentColor: Colors.deepOrange);
    } else if (lower.contains('artificial intelligence') || lower.contains(' ai ')) {
      return const SubjectIconInfo(emoji: '🤖', icon: Icons.psychology_rounded, accentColor: Colors.purple);
    } else if (lower.contains('cloud computing') || lower.contains('cloud')) {
      return const SubjectIconInfo(emoji: '☁️', icon: Icons.cloud_queue_rounded, accentColor: Colors.lightBlue);
    } else if (lower.contains('data structures')) {
      return const SubjectIconInfo(emoji: '📊', icon: Icons.account_tree_rounded, accentColor: Colors.teal);
    } else if (lower.contains('database') || lower.contains('dbms')) {
      return const SubjectIconInfo(emoji: '🗄️', icon: Icons.dataset_rounded, accentColor: Colors.amber);
    } else if (lower.contains('cryptography') || lower.contains('security')) {
      return const SubjectIconInfo(emoji: '🔐', icon: Icons.security_rounded, accentColor: Colors.redAccent);
    } else if (lower.contains('network') || lower.contains('communication')) {
      return const SubjectIconInfo(emoji: '🌐', icon: Icons.router_rounded, accentColor: Colors.indigo);
    } else if (lower.contains('operating system') || lower.contains('os')) {
      return const SubjectIconInfo(emoji: '⚙️', icon: Icons.terminal_rounded, accentColor: Colors.blueGrey);
    } else if (lower.contains('python')) {
      return const SubjectIconInfo(emoji: '🐍', icon: Icons.code_rounded, accentColor: Colors.green);
    } else if (lower.contains('machine learning') || lower.contains(' ml ')) {
      return const SubjectIconInfo(emoji: '🎯', icon: Icons.smart_toy_rounded, accentColor: Colors.deepPurple);
    } else if (lower.contains('compiler')) {
      return const SubjectIconInfo(emoji: '🧠', icon: Icons.precision_manufacturing_rounded, accentColor: Colors.orange);
    } else if (lower.contains('chemistry')) {
      return const SubjectIconInfo(emoji: '🌱', icon: Icons.science_rounded, accentColor: Color(0xFF059669));
    } else if (lower.contains('physics')) {
      return const SubjectIconInfo(emoji: '⚡', icon: Icons.bolt_rounded, accentColor: Colors.amber);
    } else if (lower.contains('math')) {
      return const SubjectIconInfo(emoji: '📐', icon: Icons.calculate_rounded, accentColor: Colors.indigoAccent);
    } else if (lower.contains('english')) {
      return const SubjectIconInfo(emoji: '📖', icon: Icons.menu_book_rounded, accentColor: Colors.cyan);
    } else if (lower.contains('microprocessor') || lower.contains('microcontroller')) {
      return const SubjectIconInfo(emoji: '📠', icon: Icons.developer_board_rounded, accentColor: Colors.brown);
    } else if (lower.contains('software engineering')) {
      return const SubjectIconInfo(emoji: '🏗️', icon: Icons.engineering_rounded, accentColor: Colors.blue);
    } else if (lower.contains('automata') || lower.contains('formal language')) {
      return const SubjectIconInfo(emoji: '🔣', icon: Icons.auto_graph_rounded, accentColor: Colors.purpleAccent);
    } else if (lower.contains('algorithm')) {
      return const SubjectIconInfo(emoji: '⚡', icon: Icons.speed_rounded, accentColor: Colors.teal);
    }

    return const SubjectIconInfo(emoji: '📚', icon: Icons.book_rounded, accentColor: AppColors.primary);
  }
}

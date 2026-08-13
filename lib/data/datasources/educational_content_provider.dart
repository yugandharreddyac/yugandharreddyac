import 'dart:math';
import 'package:flutter/material.dart';

enum EducationalContentType {
  csQuickByte,
  csPioneer,
  subjectKeyPoint,
  quickTip,
}

class EducationalContentItem {
  final String id;
  final EducationalContentType type;
  final String title;
  final String content;
  final String categoryLabel;
  final IconData icon;
  final Color accentColor;
  final String? actionLabel;
  final String? actionRoute;

  const EducationalContentItem({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.categoryLabel,
    required this.icon,
    required this.accentColor,
    this.actionLabel,
    this.actionRoute,
  });
}

class EducationalContentProvider {
  EducationalContentProvider._();

  static final Random _random = Random();

  static const List<EducationalContentItem> allItems = [
    // ==========================================
    // 1. CS QUICK BYTES
    // ==========================================
    EducationalContentItem(
      id: 'qb_1',
      type: EducationalContentType.csQuickByte,
      title: 'Binary Search Algorithm',
      content: 'Binary search works on a sorted search space, dividing the range in half at each step for O(log n) efficiency.',
      categoryLabel: 'CS QUICK BYTE',
      icon: Icons.psychology_rounded,
      accentColor: Color(0xFF2563EB),
    ),
    EducationalContentItem(
      id: 'qb_2',
      type: EducationalContentType.csQuickByte,
      title: 'Stack Data Structure',
      content: 'A stack follows LIFO (Last In, First Out). The last element pushed is the first element popped.',
      categoryLabel: 'CS QUICK BYTE',
      icon: Icons.layers_rounded,
      accentColor: Color(0xFF10B981),
    ),
    EducationalContentItem(
      id: 'qb_3',
      type: EducationalContentType.csQuickByte,
      title: 'Queue Data Structure',
      content: 'A queue follows FIFO (First In, First Out). Elements are added at the rear and removed from the front.',
      categoryLabel: 'CS QUICK BYTE',
      icon: Icons.swap_horiz_rounded,
      accentColor: Color(0xFF8B5CF6),
    ),
    EducationalContentItem(
      id: 'qb_4',
      type: EducationalContentType.csQuickByte,
      title: 'Hash Tables Lookup',
      content: 'Hash tables provide average-case O(1) lookup, insertion, and deletion under typical load conditions.',
      categoryLabel: 'CS QUICK BYTE',
      icon: Icons.tag_rounded,
      accentColor: Color(0xFFF59E0B),
    ),
    EducationalContentItem(
      id: 'qb_5',
      type: EducationalContentType.csQuickByte,
      title: 'Recursion Principle',
      content: 'Recursion requires a base case to terminate execution and prevent infinite stack overflow calls.',
      categoryLabel: 'CS QUICK BYTE',
      icon: Icons.loop_rounded,
      accentColor: Color(0xFFEC4899),
    ),

    // ==========================================
    // 2. COMPUTER SCIENCE PIONEERS
    // ==========================================
    EducationalContentItem(
      id: 'pioneer_1',
      type: EducationalContentType.csPioneer,
      title: 'Who is Alan Turing?',
      content: 'His work on computation and the Turing machine established the foundational theoretical models of modern computer science.',
      categoryLabel: 'CS PIONEER',
      icon: Icons.stars_rounded,
      accentColor: Color(0xFF3B82F6),
    ),
    EducationalContentItem(
      id: 'pioneer_2',
      type: EducationalContentType.csPioneer,
      title: 'Who is Dennis Ritchie?',
      content: 'He created the C programming language and co-developed the Unix operating system, shaping software foundations.',
      categoryLabel: 'CS PIONEER',
      icon: Icons.auto_awesome_rounded,
      accentColor: Color(0xFF06B6D4),
    ),
    EducationalContentItem(
      id: 'pioneer_3',
      type: EducationalContentType.csPioneer,
      title: 'Who is Donald Knuth?',
      content: 'Author of "The Art of Computer Programming", he made pioneering contributions to algorithm analysis and TeX typesetting.',
      categoryLabel: 'CS PIONEER',
      icon: Icons.workspace_premium_rounded,
      accentColor: Color(0xFF8B5CF6),
    ),
    EducationalContentItem(
      id: 'pioneer_4',
      type: EducationalContentType.csPioneer,
      title: 'Who is Grace Hopper?',
      content: 'A pioneer of computer programming who created the first compiler and popularized machine-independent programming languages.',
      categoryLabel: 'CS PIONEER',
      icon: Icons.school_rounded,
      accentColor: Color(0xFF10B981),
    ),
    EducationalContentItem(
      id: 'pioneer_5',
      type: EducationalContentType.csPioneer,
      title: 'Who is Barbara Liskov?',
      content: 'Developer of the Liskov Substitution Principle (LSP) in Object-Oriented Design and pioneer of data abstraction.',
      categoryLabel: 'CS PIONEER',
      icon: Icons.lightbulb_rounded,
      accentColor: Color(0xFFF59E0B),
    ),
    EducationalContentItem(
      id: 'pioneer_6',
      type: EducationalContentType.csPioneer,
      title: 'Who is Edsger W. Dijkstra?',
      content: 'Formulated the shortest path algorithm (Dijkstra\'s) and established core principles of structured programming.',
      categoryLabel: 'CS PIONEER',
      icon: Icons.alt_route_rounded,
      accentColor: Color(0xFFEC4899),
    ),
    EducationalContentItem(
      id: 'pioneer_7',
      type: EducationalContentType.csPioneer,
      title: 'Who is John von Neumann?',
      content: 'Proposed the Von Neumann architecture (CPU, memory, I/O), which powers almost all modern digital computing hardware.',
      categoryLabel: 'CS PIONEER',
      icon: Icons.memory_rounded,
      accentColor: Color(0xFF2563EB),
    ),
    EducationalContentItem(
      id: 'pioneer_8',
      type: EducationalContentType.csPioneer,
      title: 'Who is Margaret Hamilton?',
      content: 'Led the MIT Software Engineering Division that developed the Apollo on-board flight software, coining "Software Engineering".',
      categoryLabel: 'CS PIONEER',
      icon: Icons.rocket_launch_rounded,
      accentColor: Color(0xFF10B981),
    ),

    // ==========================================
    // 3. SUBJECT KEY POINTS
    // ==========================================
    EducationalContentItem(
      id: 'subj_c',
      type: EducationalContentType.subjectKeyPoint,
      title: 'C Programming',
      content: 'Loops repeat a block of code while a condition is satisfied, using variables and control logic.',
      categoryLabel: 'SUBJECT KEY POINT',
      icon: Icons.code_rounded,
      accentColor: Color(0xFF2563EB),
    ),
    EducationalContentItem(
      id: 'subj_dsa',
      type: EducationalContentType.subjectKeyPoint,
      title: 'Data Structures',
      content: 'A linked list stores elements inside nodes connected sequentially by pointer links.',
      categoryLabel: 'SUBJECT KEY POINT',
      icon: Icons.account_tree_rounded,
      accentColor: Color(0xFF10B981),
    ),
    EducationalContentItem(
      id: 'subj_os',
      type: EducationalContentType.subjectKeyPoint,
      title: 'Operating Systems',
      content: 'Processes are active programs in execution, allocated memory, threads, and system resources.',
      categoryLabel: 'SUBJECT KEY POINT',
      icon: Icons.developer_board_rounded,
      accentColor: Color(0xFF8B5CF6),
    ),
    EducationalContentItem(
      id: 'subj_cn',
      type: EducationalContentType.subjectKeyPoint,
      title: 'Computer Networks',
      content: 'TCP provides reliable, connection-oriented, ordered delivery of data packets between hosts.',
      categoryLabel: 'SUBJECT KEY POINT',
      icon: Icons.router_rounded,
      accentColor: Color(0xFFF59E0B),
    ),
    EducationalContentItem(
      id: 'subj_dbms',
      type: EducationalContentType.subjectKeyPoint,
      title: 'Database Systems',
      content: 'Database normalization reduces data redundancy and prevents update anomalies across relational tables.',
      categoryLabel: 'SUBJECT KEY POINT',
      icon: Icons.storage_rounded,
      accentColor: Color(0xFF06B6D4),
    ),

    // ==========================================
    // 4. QUICK SHORTCUTS & STUDY TIPS
    // ==========================================
    EducationalContentItem(
      id: 'tip_shortcut',
      type: EducationalContentType.quickTip,
      title: 'Command Palette',
      content: '⌨️ Ctrl + Shift + P — Quickly search tools, files, and commands in IDEs.',
      categoryLabel: 'QUICK SHORTCUT',
      icon: Icons.keyboard_rounded,
      accentColor: Color(0xFF64748B),
    ),
    EducationalContentItem(
      id: 'tip_study',
      type: EducationalContentType.quickTip,
      title: 'Effective Learning Habit',
      content: '💡 Read → Practice → Review → Repeat. Consistency builds long-term retention.',
      categoryLabel: 'STUDY TIP',
      icon: Icons.tips_and_updates_rounded,
      accentColor: Color(0xFFF59E0B),
    ),
  ];

  /// Return a random educational content item
  static EducationalContentItem getRandomItem() {
    return allItems[_random.nextInt(allItems.length)];
  }

  /// Get next educational item given current index
  static EducationalContentItem getNextItem(int currentIndex) {
    final nextIndex = (currentIndex + 1) % allItems.length;
    return allItems[nextIndex];
  }
}

import 'package:flutter/material.dart';

/// Resource Types supported in final topic view
enum HierarchyResourceType {
  notes,
  pdf,
  video,
  practice,
  roadmap,
  learnOnline,
  project,
}

extension HierarchyResourceTypeExtension on HierarchyResourceType {
  String get displayName {
    switch (this) {
      case HierarchyResourceType.notes:
        return 'Notes';
      case HierarchyResourceType.pdf:
        return 'PDF Documentation';
      case HierarchyResourceType.video:
        return 'Video Tutorial';
      case HierarchyResourceType.practice:
        return 'Practice Questions';
      case HierarchyResourceType.roadmap:
        return 'Learning Roadmap';
      case HierarchyResourceType.learnOnline:
        return 'Learn Online';
      case HierarchyResourceType.project:
        return 'Hands-on Project';
    }
  }

  IconData get icon {
    switch (this) {
      case HierarchyResourceType.notes:
        return Icons.menu_book_rounded;
      case HierarchyResourceType.pdf:
        return Icons.picture_as_pdf_rounded;
      case HierarchyResourceType.video:
        return Icons.play_circle_fill_rounded;
      case HierarchyResourceType.practice:
        return Icons.psychology_rounded;
      case HierarchyResourceType.roadmap:
        return Icons.map_rounded;
      case HierarchyResourceType.learnOnline:
        return Icons.language_rounded;
      case HierarchyResourceType.project:
        return Icons.rocket_launch_rounded;
    }
  }

  Color get color {
    switch (this) {
      case HierarchyResourceType.notes:
        return const Color(0xFF2563EB); // Royal Blue
      case HierarchyResourceType.pdf:
        return const Color(0xFFDC2626); // Red
      case HierarchyResourceType.video:
        return const Color(0xFFEA580C); // Orange
      case HierarchyResourceType.practice:
        return const Color(0xFF7C3AED); // Purple
      case HierarchyResourceType.roadmap:
        return const Color(0xFF0284C7); // Cyan Blue
      case HierarchyResourceType.learnOnline:
        return const Color(0xFF10B981); // Emerald Green
      case HierarchyResourceType.project:
        return const Color(0xFFD97706); // Amber
    }
  }
}

/// Individual resource item under a topic
class HierarchyResourceModel {
  final String id;
  final String title;
  final String description;
  final HierarchyResourceType type;
  final String url;
  final String? platform;
  final String? fileAsset;

  const HierarchyResourceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.url,
    this.platform,
    this.fileAsset,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'type': type.name,
        'url': url,
        'platform': platform,
        'fileAsset': fileAsset,
      };
}

/// Beginner "Start Here" guided step
class StartHereStepModel {
  final int stepNumber;
  final String title;
  final String description;
  final String? targetCategoryId;
  final String? targetTopicId;

  const StartHereStepModel({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.targetCategoryId,
    this.targetTopicId,
  });
}

/// Level node (e.g. Beginner, Intermediate, Advanced, Projects)
enum LearningLevel {
  beginner,
  intermediate,
  advanced,
  projects,
}

extension LearningLevelExtension on LearningLevel {
  String get displayName {
    switch (this) {
      case LearningLevel.beginner:
        return '🌱 Beginner';
      case LearningLevel.intermediate:
        return '🌿 Intermediate';
      case LearningLevel.advanced:
        return '🌳 Advanced';
      case LearningLevel.projects:
        return '🚀 Projects';
    }
  }

  String get plainTitle {
    switch (this) {
      case LearningLevel.beginner:
        return 'Beginner';
      case LearningLevel.intermediate:
        return 'Intermediate';
      case LearningLevel.advanced:
        return 'Advanced';
      case LearningLevel.projects:
        return 'Projects';
    }
  }

  String get description {
    switch (this) {
      case LearningLevel.beginner:
        return 'Core fundamentals and step-by-step introduction for beginners.';
      case LearningLevel.intermediate:
        return 'In-depth topics, common patterns, and intermediate applications.';
      case LearningLevel.advanced:
        return 'Mastery level concepts, optimization, and complex topics.';
      case LearningLevel.projects:
        return 'Practical mini & major hands-on projects to solidify learning.';
    }
  }
}

/// Topic or Subtopic model
class HierarchicalTopicModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final LearningLevel? level;
  final List<HierarchicalTopicModel> subtopics;
  final List<HierarchyResourceModel> resources;

  const HierarchicalTopicModel({
    required this.id,
    required this.title,
    required this.description,
    this.icon = Icons.topic_rounded,
    this.level,
    this.subtopics = const [],
    this.resources = const [],
  });

  bool get hasSubtopics => subtopics.isNotEmpty;
  bool get hasResources => resources.isNotEmpty;
}

/// Category Model (e.g. Programming Languages, Data Structures, AI, GATE)
class CategoryModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<LearningLevel>? availableLevels;
  final List<HierarchicalTopicModel> topics;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.description,
    this.icon = Icons.category_rounded,
    this.availableLevels,
    this.topics = const [],
  });

  bool get hasLevels => availableLevels != null && availableLevels!.isNotEmpty;
}

/// Top-level Hub Model (Coding, Emerging Tech, Higher Ed, Placement, Projects)
class HubModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final String routeName;
  final List<StartHereStepModel>? startHereSteps;
  final List<CategoryModel> categories;

  const HubModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.routeName,
    this.startHereSteps,
    required this.categories,
  });

  bool get hasStartHere => startHereSteps != null && startHereSteps!.isNotEmpty;
}

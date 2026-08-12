// Guidance Models

enum StudentStatus {
  notStarted,
  foundationBuilding,
  coreDevelopment,
  projectBuilding,
  careerPreparation,
  readyForApplication,
}

extension StudentStatusExt on StudentStatus {
  String get displayName {
    switch (this) {
      case StudentStatus.notStarted:
        return 'Not Started';
      case StudentStatus.foundationBuilding:
        return 'Foundation Building';
      case StudentStatus.coreDevelopment:
        return 'Core Development';
      case StudentStatus.projectBuilding:
        return 'Project Building';
      case StudentStatus.careerPreparation:
        return 'Career Preparation';
      case StudentStatus.readyForApplication:
        return 'Ready For Application';
    }
  }

  String get description {
    switch (this) {
      case StudentStatus.notStarted:
        return 'Your roadmap awaits. Begin by completing your first topic.';
      case StudentStatus.foundationBuilding:
        return 'You are currently building your core foundation.';
      case StudentStatus.coreDevelopment:
        return 'Your roadmap foundation is strong. You are now progressing through core topics.';
      case StudentStatus.projectBuilding:
        return 'Your core knowledge is established. Your next priority is project evidence.';
      case StudentStatus.careerPreparation:
        return 'You are preparing career assets like resume and interview skills.';
      case StudentStatus.readyForApplication:
        return 'You have completed the essential requirements for your career goal. You are ready to apply!';
    }
  }
}

class NextBestActionModel {
  final String title;
  final String reason;
  final String route;
  final Map<String, dynamic>? arguments;

  const NextBestActionModel({
    required this.title,
    required this.reason,
    required this.route,
    this.arguments,
  });
}

class RoadmapStageHealth {
  final String name;
  final int completed;
  final int total;
  final bool isBlocked;

  const RoadmapStageHealth({
    required this.name,
    required this.completed,
    required this.total,
    this.isBlocked = false,
  });

  double get percentage => total == 0 ? 0.0 : completed / total;
  bool get isComplete => total > 0 && completed == total;
}

class RoadmapHealthModel {
  final List<RoadmapStageHealth> stageHealths;
  final String currentStageName;
  final String? nextStageName;
  final String? nextIncompleteTopicTitle;
  final String? blockingTopicTitle;

  const RoadmapHealthModel({
    required this.stageHealths,
    required this.currentStageName,
    this.nextStageName,
    this.nextIncompleteTopicTitle,
    this.blockingTopicTitle,
  });
}

class StudentMilestoneModel {
  final String title;
  final String description;
  final DateTime dateAchieved;

  const StudentMilestoneModel({
    required this.title,
    required this.description,
    required this.dateAchieved,
  });
}

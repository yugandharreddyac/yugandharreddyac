import 'package:flutter/material.dart';

enum StudentYear {
  firstYear,
  secondYear,
  thirdYear,
  fourthYear,
}

extension StudentYearExtension on StudentYear {
  String get label {
    switch (this) {
      case StudentYear.firstYear:
        return '1st Year';
      case StudentYear.secondYear:
        return '2nd Year';
      case StudentYear.thirdYear:
        return '3rd Year';
      case StudentYear.fourthYear:
        return '4th Year';
    }
  }

  String get shortLabel {
    switch (this) {
      case StudentYear.firstYear:
        return 'Year 1';
      case StudentYear.secondYear:
        return 'Year 2';
      case StudentYear.thirdYear:
        return 'Year 3';
      case StudentYear.fourthYear:
        return 'Year 4';
    }
  }
}

enum CareerGoal {
  softwarePlacement,
  gateExam,
  msHigherStudies,
  mbaCat,
  entrepreneurship,
  generalSkillDev,
}

extension CareerGoalExtension on CareerGoal {
  String get title {
    switch (this) {
      case CareerGoal.softwarePlacement:
        return 'Software / IT Placement';
      case CareerGoal.gateExam:
        return 'GATE Examination';
      case CareerGoal.msHigherStudies:
        return 'MS / Higher Studies Abroad';
      case CareerGoal.mbaCat:
        return 'MBA / CAT Preparation';
      case CareerGoal.entrepreneurship:
        return 'Entrepreneurship & Startup';
      case CareerGoal.generalSkillDev:
        return 'General Skill Development';
    }
  }

  String get targetHubId {
    switch (this) {
      case CareerGoal.softwarePlacement:
        return 'placement';
      case CareerGoal.gateExam:
        return 'higher_education';
      case CareerGoal.msHigherStudies:
        return 'higher_education';
      case CareerGoal.mbaCat:
        return 'higher_education';
      case CareerGoal.entrepreneurship:
        return 'entrepreneurship';
      case CareerGoal.generalSkillDev:
        return 'coding';
    }
  }

  IconData get icon {
    switch (this) {
      case CareerGoal.softwarePlacement:
        return Icons.work_rounded;
      case CareerGoal.gateExam:
        return Icons.quiz_rounded;
      case CareerGoal.msHigherStudies:
        return Icons.flight_takeoff_rounded;
      case CareerGoal.mbaCat:
        return Icons.business_center_rounded;
      case CareerGoal.entrepreneurship:
        return Icons.rocket_launch_rounded;
      case CareerGoal.generalSkillDev:
        return Icons.code_rounded;
    }
  }
}

enum ActivityType {
  learn,
  practice,
  build,
  review,
}

extension ActivityTypeExtension on ActivityType {
  String get label {
    switch (this) {
      case ActivityType.learn:
        return 'Concept & Learning Resource';
      case ActivityType.practice:
        return 'Practice Problem / Exercises';
      case ActivityType.build:
        return 'Mini-Project / Application';
      case ActivityType.review:
        return 'Review & Knowledge Check';
    }
  }
}

class UserGoalProfile {
  final StudentYear year;
  final CareerGoal goal;
  final String preferredDomain;
  final int hoursPerWeek;

  const UserGoalProfile({
    required this.year,
    required this.goal,
    this.preferredDomain = 'Full-Stack Development',
    this.hoursPerWeek = 10,
  });

  Map<String, dynamic> toJson() => {
        'yearIndex': year.index,
        'goalIndex': goal.index,
        'preferredDomain': preferredDomain,
        'hoursPerWeek': hoursPerWeek,
      };

  factory UserGoalProfile.fromJson(Map<String, dynamic> json) {
    return UserGoalProfile(
      year: StudentYear.values[json['yearIndex'] ?? 0],
      goal: CareerGoal.values[json['goalIndex'] ?? 0],
      preferredDomain: json['preferredDomain'] ?? 'Full-Stack Development',
      hoursPerWeek: json['hoursPerWeek'] ?? 10,
    );
  }
}

class TopicProgressModel {
  final String topicId;
  final bool learnCompleted;
  final bool practiceCompleted;
  final bool buildCompleted;
  final bool reviewCompleted;

  const TopicProgressModel({
    required this.topicId,
    this.learnCompleted = false,
    this.practiceCompleted = false,
    this.buildCompleted = false,
    this.reviewCompleted = false,
  });

  int get completedCount {
    int count = 0;
    if (learnCompleted) count++;
    if (practiceCompleted) count++;
    if (buildCompleted) count++;
    if (reviewCompleted) count++;
    return count;
  }

  int get totalActivities => 4;

  double get percentage => (completedCount / totalActivities) * 100.0;

  bool get isFullyCompleted => completedCount == totalActivities;

  bool get isInProgress => completedCount > 0 && !isFullyCompleted;

  TopicProgressModel copyWith({
    bool? learnCompleted,
    bool? practiceCompleted,
    bool? buildCompleted,
    bool? reviewCompleted,
  }) {
    return TopicProgressModel(
      topicId: topicId,
      learnCompleted: learnCompleted ?? this.learnCompleted,
      practiceCompleted: practiceCompleted ?? this.practiceCompleted,
      buildCompleted: buildCompleted ?? this.buildCompleted,
      reviewCompleted: reviewCompleted ?? this.reviewCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'topicId': topicId,
        'learnCompleted': learnCompleted,
        'practiceCompleted': practiceCompleted,
        'buildCompleted': buildCompleted,
        'reviewCompleted': reviewCompleted,
      };

  factory TopicProgressModel.fromJson(Map<String, dynamic> json) {
    return TopicProgressModel(
      topicId: json['topicId'] ?? '',
      learnCompleted: json['learnCompleted'] ?? false,
      practiceCompleted: json['practiceCompleted'] ?? false,
      buildCompleted: json['buildCompleted'] ?? false,
      reviewCompleted: json['reviewCompleted'] ?? false,
    );
  }
}

class RoadmapStageModel {
  final String stageTitle;
  final String stageDescription;
  final List<String> topicIds;

  const RoadmapStageModel({
    required this.stageTitle,
    required this.stageDescription,
    required this.topicIds,
  });
}

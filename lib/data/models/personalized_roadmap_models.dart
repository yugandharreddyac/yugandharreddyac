import 'dart:convert';

/// Academic stage of the student
enum AcademicStage {
  firstYear('1st Year', 'Year 1'),
  secondYear('2nd Year', 'Year 2'),
  thirdYear('3rd Year', 'Year 3'),
  fourthYear('4th Year', 'Year 4'),
  graduate('Graduate', 'Grad'),
  workingProfessional('Working Professional', 'Pro'),
  other('Other', 'Other');

  final String displayName;
  final String shortName;
  const AcademicStage(this.displayName, this.shortName);
}

/// Skill level for overall student profile and individual domain ratings
enum SkillLevel {
  completeBeginner('Complete Beginner', 1),
  beginner('Beginner', 2),
  basic('Basic', 3),
  intermediate('Intermediate', 4),
  advanced('Advanced', 5);

  final String displayName;
  final int rank;
  const SkillLevel(this.displayName, this.rank);
}

/// Learning style pedagogy preference
enum LearningStyle {
  theoryFirst('Theory First', 'Learn concept → understand depth → practice exercises → build projects'),
  practiceFirst('Practice First', 'Quick concept → hands-on problems → code practice → mini projects'),
  projectsFirst('Projects First', 'Concept overview → build practical project → explore internals as needed'),
  balanced('Balanced', 'Structured theory → standard problem sets → project application → review');

  final String displayName;
  final String description;
  const LearningStyle(this.displayName, this.description);
}

/// Item priority in the generated personalized roadmap
enum RoadmapItemPriority {
  critical('Critical', 4),
  high('High', 3),
  medium('Medium', 2),
  optional('Optional', 1);

  final String displayName;
  final int weight;
  const RoadmapItemPriority(this.displayName, this.weight);
}

/// Item progress status
enum RoadmapItemStatus {
  locked('Locked'),
  notStarted('Not Started'),
  inProgress('In Progress'),
  completed('Completed');

  final String displayName;
  const RoadmapItemStatus(this.displayName);
}

/// Learning item difficulty
enum RoadmapDifficulty {
  beginner('Beginner'),
  intermediate('Intermediate'),
  advanced('Advanced');

  final String displayName;
  const RoadmapDifficulty(this.displayName);
}

/// Comprehensive Personalized Profile capturing the student's holistic context
class PersonalizedProfile {
  final AcademicStage academicStage;
  final List<String> goals;
  final List<String> careerDirections;
  final String primaryCareerDirection;
  final List<String> interestAreas;
  final SkillLevel overallSkillLevel;
  final Map<String, SkillLevel> skillLevels;
  final List<String> programmingLanguages;
  final String primaryLanguage;
  final String? secondaryLanguage;
  final String projectExperience;
  final String internshipStatus;
  final String openSourceExperience;
  final String codingPracticeLevel;
  final List<String> targetOrganizationTypes;
  final String? targetCompany;
  final int dailyLearningTimeMinutes;
  final String weeklyAvailability;
  final String targetTimeline;
  final LearningStyle learningStyle;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> placementPreparationAreas;
  final List<String> alreadyCompletedSkills;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int profileVersion;

  const PersonalizedProfile({
    required this.academicStage,
    required this.goals,
    required this.careerDirections,
    required this.primaryCareerDirection,
    this.interestAreas = const [],
    this.overallSkillLevel = SkillLevel.beginner,
    this.skillLevels = const {},
    this.programmingLanguages = const [],
    required this.primaryLanguage,
    this.secondaryLanguage,
    this.projectExperience = 'No projects',
    this.internshipStatus = 'No internship yet',
    this.openSourceExperience = 'Never contributed',
    this.codingPracticeLevel = 'Never practiced',
    this.targetOrganizationTypes = const [],
    this.targetCompany,
    this.dailyLearningTimeMinutes = 60,
    this.weeklyAvailability = 'Weekdays + weekends',
    this.targetTimeline = '6 months',
    this.learningStyle = LearningStyle.balanced,
    this.strengths = const [],
    this.weaknesses = const [],
    this.placementPreparationAreas = const [],
    this.alreadyCompletedSkills = const [],
    required this.createdAt,
    required this.updatedAt,
    this.profileVersion = 1,
  });

  PersonalizedProfile copyWith({
    AcademicStage? academicStage,
    List<String>? goals,
    List<String>? careerDirections,
    String? primaryCareerDirection,
    List<String>? interestAreas,
    SkillLevel? overallSkillLevel,
    Map<String, SkillLevel>? skillLevels,
    List<String>? programmingLanguages,
    String? primaryLanguage,
    String? secondaryLanguage,
    String? projectExperience,
    String? internshipStatus,
    String? openSourceExperience,
    String? codingPracticeLevel,
    List<String>? targetOrganizationTypes,
    String? targetCompany,
    int? dailyLearningTimeMinutes,
    String? weeklyAvailability,
    String? targetTimeline,
    LearningStyle? learningStyle,
    List<String>? strengths,
    List<String>? weaknesses,
    List<String>? placementPreparationAreas,
    List<String>? alreadyCompletedSkills,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? profileVersion,
  }) {
    return PersonalizedProfile(
      academicStage: academicStage ?? this.academicStage,
      goals: goals ?? List.from(this.goals),
      careerDirections: careerDirections ?? List.from(this.careerDirections),
      primaryCareerDirection: primaryCareerDirection ?? this.primaryCareerDirection,
      interestAreas: interestAreas ?? List.from(this.interestAreas),
      overallSkillLevel: overallSkillLevel ?? this.overallSkillLevel,
      skillLevels: skillLevels ?? Map.from(this.skillLevels),
      programmingLanguages: programmingLanguages ?? List.from(this.programmingLanguages),
      primaryLanguage: primaryLanguage ?? this.primaryLanguage,
      secondaryLanguage: secondaryLanguage ?? this.secondaryLanguage,
      projectExperience: projectExperience ?? this.projectExperience,
      internshipStatus: internshipStatus ?? this.internshipStatus,
      openSourceExperience: openSourceExperience ?? this.openSourceExperience,
      codingPracticeLevel: codingPracticeLevel ?? this.codingPracticeLevel,
      targetOrganizationTypes: targetOrganizationTypes ?? List.from(this.targetOrganizationTypes),
      targetCompany: targetCompany ?? this.targetCompany,
      dailyLearningTimeMinutes: dailyLearningTimeMinutes ?? this.dailyLearningTimeMinutes,
      weeklyAvailability: weeklyAvailability ?? this.weeklyAvailability,
      targetTimeline: targetTimeline ?? this.targetTimeline,
      learningStyle: learningStyle ?? this.learningStyle,
      strengths: strengths ?? List.from(this.strengths),
      weaknesses: weaknesses ?? List.from(this.weaknesses),
      placementPreparationAreas: placementPreparationAreas ?? List.from(this.placementPreparationAreas),
      alreadyCompletedSkills: alreadyCompletedSkills ?? List.from(this.alreadyCompletedSkills),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profileVersion: profileVersion ?? this.profileVersion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'academicStage': academicStage.name,
      'goals': goals,
      'careerDirections': careerDirections,
      'primaryCareerDirection': primaryCareerDirection,
      'interestAreas': interestAreas,
      'overallSkillLevel': overallSkillLevel.name,
      'skillLevels': skillLevels.map((k, v) => MapEntry(k, v.name)),
      'programmingLanguages': programmingLanguages,
      'primaryLanguage': primaryLanguage,
      'secondaryLanguage': secondaryLanguage,
      'projectExperience': projectExperience,
      'internshipStatus': internshipStatus,
      'openSourceExperience': openSourceExperience,
      'codingPracticeLevel': codingPracticeLevel,
      'targetOrganizationTypes': targetOrganizationTypes,
      'targetCompany': targetCompany,
      'dailyLearningTimeMinutes': dailyLearningTimeMinutes,
      'weeklyAvailability': weeklyAvailability,
      'targetTimeline': targetTimeline,
      'learningStyle': learningStyle.name,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'placementPreparationAreas': placementPreparationAreas,
      'alreadyCompletedSkills': alreadyCompletedSkills,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'profileVersion': profileVersion,
    };
  }

  factory PersonalizedProfile.fromMap(Map<String, dynamic> map) {
    final skillLevelsMap = <String, SkillLevel>{};
    if (map['skillLevels'] is Map) {
      (map['skillLevels'] as Map).forEach((k, v) {
        if (k is String && v is String) {
          skillLevelsMap[k] = SkillLevel.values.firstWhere(
            (e) => e.name == v,
            orElse: () => SkillLevel.beginner,
          );
        }
      });
    }

    return PersonalizedProfile(
      academicStage: AcademicStage.values.firstWhere(
        (e) => e.name == map['academicStage'],
        orElse: () => AcademicStage.firstYear,
      ),
      goals: List<String>.from(map['goals'] ?? []),
      careerDirections: List<String>.from(map['careerDirections'] ?? []),
      primaryCareerDirection: map['primaryCareerDirection'] ?? 'Software Engineer',
      interestAreas: List<String>.from(map['interestAreas'] ?? []),
      overallSkillLevel: SkillLevel.values.firstWhere(
        (e) => e.name == map['overallSkillLevel'],
        orElse: () => SkillLevel.beginner,
      ),
      skillLevels: skillLevelsMap,
      programmingLanguages: List<String>.from(map['programmingLanguages'] ?? []),
      primaryLanguage: map['primaryLanguage'] ?? 'Python',
      secondaryLanguage: map['secondaryLanguage'],
      projectExperience: map['projectExperience'] ?? 'No projects',
      internshipStatus: map['internshipStatus'] ?? 'No internship yet',
      openSourceExperience: map['openSourceExperience'] ?? 'Never contributed',
      codingPracticeLevel: map['codingPracticeLevel'] ?? 'Never practiced',
      targetOrganizationTypes: List<String>.from(map['targetOrganizationTypes'] ?? []),
      targetCompany: map['targetCompany'],
      dailyLearningTimeMinutes: map['dailyLearningTimeMinutes'] ?? 60,
      weeklyAvailability: map['weeklyAvailability'] ?? 'Weekdays + weekends',
      targetTimeline: map['targetTimeline'] ?? '6 months',
      learningStyle: LearningStyle.values.firstWhere(
        (e) => e.name == map['learningStyle'],
        orElse: () => LearningStyle.balanced,
      ),
      strengths: List<String>.from(map['strengths'] ?? []),
      weaknesses: List<String>.from(map['weaknesses'] ?? []),
      placementPreparationAreas: List<String>.from(map['placementPreparationAreas'] ?? []),
      alreadyCompletedSkills: List<String>.from(map['alreadyCompletedSkills'] ?? []),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
      profileVersion: map['profileVersion'] ?? 1,
    );
  }

  String toJson() => jsonEncode(toMap());
  factory PersonalizedProfile.fromJson(String source) =>
      PersonalizedProfile.fromMap(jsonDecode(source) as Map<String, dynamic>);
}

/// Actionable individual learning/practice item in the roadmap
class RoadmapItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final RoadmapDifficulty difficulty;
  final int estimatedMinutes;
  final RoadmapItemPriority priority;
  final List<String> prerequisites; // List of prerequisite RoadmapItem IDs
  final RoadmapItemStatus status;
  final String phaseId;
  final int sequence;
  final String targetSkill;
  final List<String> relatedSkills;
  final String? resourceReference; // e.g. subjectId, topicId, hubId, quizId
  final String? resourceType; // 'subject', 'textbook_topic', 'quiz', 'coding_hub', 'project', 'placement_hub'
  final String? deepRoute; // Named route for 1-tap navigation
  final Map<String, dynamic>? routeArguments;
  final String? projectReference;
  final String? quizReference;
  final String? topicReference;
  final String? recommendationReason;

  const RoadmapItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.difficulty = RoadmapDifficulty.intermediate,
    this.estimatedMinutes = 30,
    this.priority = RoadmapItemPriority.high,
    this.prerequisites = const [],
    this.status = RoadmapItemStatus.notStarted,
    required this.phaseId,
    required this.sequence,
    required this.targetSkill,
    this.relatedSkills = const [],
    this.resourceReference,
    this.resourceType,
    this.deepRoute,
    this.routeArguments,
    this.projectReference,
    this.quizReference,
    this.topicReference,
    this.recommendationReason,
  });

  bool get isCompleted => status == RoadmapItemStatus.completed;
  bool get isInProgress => status == RoadmapItemStatus.inProgress;
  bool get isLocked => status == RoadmapItemStatus.locked;
  bool get isNotStarted => status == RoadmapItemStatus.notStarted;

  RoadmapItem copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    RoadmapDifficulty? difficulty,
    int? estimatedMinutes,
    RoadmapItemPriority? priority,
    List<String>? prerequisites,
    RoadmapItemStatus? status,
    String? phaseId,
    int? sequence,
    String? targetSkill,
    List<String>? relatedSkills,
    String? resourceReference,
    String? resourceType,
    String? deepRoute,
    Map<String, dynamic>? routeArguments,
    String? projectReference,
    String? quizReference,
    String? topicReference,
    String? recommendationReason,
  }) {
    return RoadmapItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      priority: priority ?? this.priority,
      prerequisites: prerequisites ?? List.from(this.prerequisites),
      status: status ?? this.status,
      phaseId: phaseId ?? this.phaseId,
      sequence: sequence ?? this.sequence,
      targetSkill: targetSkill ?? this.targetSkill,
      relatedSkills: relatedSkills ?? List.from(this.relatedSkills),
      resourceReference: resourceReference ?? this.resourceReference,
      resourceType: resourceType ?? this.resourceType,
      deepRoute: deepRoute ?? this.deepRoute,
      routeArguments: routeArguments ?? (this.routeArguments != null ? Map.from(this.routeArguments!) : null),
      projectReference: projectReference ?? this.projectReference,
      quizReference: quizReference ?? this.quizReference,
      topicReference: topicReference ?? this.topicReference,
      recommendationReason: recommendationReason ?? this.recommendationReason,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty.name,
      'estimatedMinutes': estimatedMinutes,
      'priority': priority.name,
      'prerequisites': prerequisites,
      'status': status.name,
      'phaseId': phaseId,
      'sequence': sequence,
      'targetSkill': targetSkill,
      'relatedSkills': relatedSkills,
      'resourceReference': resourceReference,
      'resourceType': resourceType,
      'deepRoute': deepRoute,
      'routeArguments': routeArguments,
      'projectReference': projectReference,
      'quizReference': quizReference,
      'topicReference': topicReference,
      'recommendationReason': recommendationReason,
    };
  }

  factory RoadmapItem.fromMap(Map<String, dynamic> map) {
    return RoadmapItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'Core',
      difficulty: RoadmapDifficulty.values.firstWhere(
        (e) => e.name == map['difficulty'],
        orElse: () => RoadmapDifficulty.intermediate,
      ),
      estimatedMinutes: map['estimatedMinutes'] ?? 30,
      priority: RoadmapItemPriority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => RoadmapItemPriority.high,
      ),
      prerequisites: List<String>.from(map['prerequisites'] ?? []),
      status: RoadmapItemStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => RoadmapItemStatus.notStarted,
      ),
      phaseId: map['phaseId'] ?? '',
      sequence: map['sequence'] ?? 0,
      targetSkill: map['targetSkill'] ?? '',
      relatedSkills: List<String>.from(map['relatedSkills'] ?? []),
      resourceReference: map['resourceReference'],
      resourceType: map['resourceType'],
      deepRoute: map['deepRoute'],
      routeArguments: map['routeArguments'] is Map ? Map<String, dynamic>.from(map['routeArguments']) : null,
      projectReference: map['projectReference'],
      quizReference: map['quizReference'],
      topicReference: map['topicReference'],
      recommendationReason: map['recommendationReason'],
    );
  }
}

/// Structured Roadmap Phase grouping related tasks
class RoadmapPhase {
  final String id;
  final String title;
  final String description;
  final int sequence;
  final String estimatedDuration;
  final List<RoadmapItem> items;

  const RoadmapPhase({
    required this.id,
    required this.title,
    required this.description,
    required this.sequence,
    required this.estimatedDuration,
    required this.items,
  });

  int get totalItemsCount => items.length;
  int get completedItemsCount => items.where((item) => item.isCompleted).length;
  int get inProgressItemsCount => items.where((item) => item.isInProgress).length;

  double get completionPercentage =>
      totalItemsCount > 0 ? (completedItemsCount / totalItemsCount) * 100.0 : 0.0;

  bool get isFullyCompleted => totalItemsCount > 0 && completedItemsCount == totalItemsCount;
  bool get isInProgress => completedItemsCount > 0 && !isFullyCompleted;
  bool get isNotStarted => completedItemsCount == 0 && inProgressItemsCount == 0;

  RoadmapPhase copyWith({
    String? id,
    String? title,
    String? description,
    int? sequence,
    String? estimatedDuration,
    List<RoadmapItem>? items,
  }) {
    return RoadmapPhase(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      sequence: sequence ?? this.sequence,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      items: items ?? List.from(this.items),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'sequence': sequence,
      'estimatedDuration': estimatedDuration,
      'items': items.map((i) => i.toMap()).toList(),
    };
  }

  factory RoadmapPhase.fromMap(Map<String, dynamic> map) {
    return RoadmapPhase(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      sequence: map['sequence'] ?? 0,
      estimatedDuration: map['estimatedDuration'] ?? '',
      items: (map['items'] as List? ?? [])
          .map((i) => RoadmapItem.fromMap(i as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Complete Root Personalized Roadmap entity
class PersonalizedRoadmap {
  final String id;
  final String title;
  final String targetCareer;
  final String mainGoal;
  final String targetTimeline;
  final int dailyMinutes;
  final String weeklyAvailability;
  final List<RoadmapPhase> phases;
  final int profileVersion;
  final String generatorVersion;
  final int roadmapVersion;
  final DateTime generatedAt;
  final DateTime lastUpdatedAt;

  const PersonalizedRoadmap({
    required this.id,
    required this.title,
    required this.targetCareer,
    required this.mainGoal,
    required this.targetTimeline,
    required this.dailyMinutes,
    required this.weeklyAvailability,
    required this.phases,
    this.profileVersion = 1,
    this.generatorVersion = '1.0.0',
    this.roadmapVersion = 1,
    required this.generatedAt,
    required this.lastUpdatedAt,
  });

  List<RoadmapItem> get allItems => phases.expand((p) => p.items).toList();
  int get totalItemsCount => allItems.length;
  int get completedItemsCount => allItems.where((i) => i.isCompleted).length;

  double get overallProgress =>
      totalItemsCount > 0 ? (completedItemsCount / totalItemsCount) * 100.0 : 0.0;

  RoadmapPhase? get currentPhase => phases.firstWhere(
        (p) => !p.isFullyCompleted,
        orElse: () => phases.isNotEmpty ? phases.last : const RoadmapPhase(id: '', title: '', description: '', sequence: 0, estimatedDuration: '', items: []),
      );

  int get currentPhaseIndex =>
      phases.indexWhere((p) => !p.isFullyCompleted).clamp(0, phases.isEmpty ? 0 : phases.length - 1);

  RoadmapItem? get nextRecommendedItem {
    for (final phase in phases) {
      for (final item in phase.items) {
        if (!item.isCompleted && !item.isLocked) {
          return item;
        }
      }
    }
    return null;
  }

  RoadmapItem? findItemById(String itemId) {
    for (final phase in phases) {
      for (final item in phase.items) {
        if (item.id == itemId) return item;
      }
    }
    return null;
  }

  PersonalizedRoadmap copyWith({
    String? id,
    String? title,
    String? targetCareer,
    String? mainGoal,
    String? targetTimeline,
    int? dailyMinutes,
    String? weeklyAvailability,
    List<RoadmapPhase>? phases,
    int? profileVersion,
    String? generatorVersion,
    int? roadmapVersion,
    DateTime? generatedAt,
    DateTime? lastUpdatedAt,
  }) {
    return PersonalizedRoadmap(
      id: id ?? this.id,
      title: title ?? this.title,
      targetCareer: targetCareer ?? this.targetCareer,
      mainGoal: mainGoal ?? this.mainGoal,
      targetTimeline: targetTimeline ?? this.targetTimeline,
      dailyMinutes: dailyMinutes ?? this.dailyMinutes,
      weeklyAvailability: weeklyAvailability ?? this.weeklyAvailability,
      phases: phases ?? List.from(this.phases),
      profileVersion: profileVersion ?? this.profileVersion,
      generatorVersion: generatorVersion ?? this.generatorVersion,
      roadmapVersion: roadmapVersion ?? this.roadmapVersion,
      generatedAt: generatedAt ?? this.generatedAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'targetCareer': targetCareer,
      'mainGoal': mainGoal,
      'targetTimeline': targetTimeline,
      'dailyMinutes': dailyMinutes,
      'weeklyAvailability': weeklyAvailability,
      'phases': phases.map((p) => p.toMap()).toList(),
      'profileVersion': profileVersion,
      'generatorVersion': generatorVersion,
      'roadmapVersion': roadmapVersion,
      'generatedAt': generatedAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }

  factory PersonalizedRoadmap.fromMap(Map<String, dynamic> map) {
    return PersonalizedRoadmap(
      id: map['id'] ?? '',
      title: map['title'] ?? 'My Personalized Roadmap',
      targetCareer: map['targetCareer'] ?? 'Software Engineer',
      mainGoal: map['mainGoal'] ?? 'Placement',
      targetTimeline: map['targetTimeline'] ?? '6 months',
      dailyMinutes: map['dailyMinutes'] ?? 60,
      weeklyAvailability: map['weeklyAvailability'] ?? 'Weekdays + weekends',
      phases: (map['phases'] as List? ?? [])
          .map((p) => RoadmapPhase.fromMap(p as Map<String, dynamic>))
          .toList(),
      profileVersion: map['profileVersion'] ?? 1,
      generatorVersion: map['generatorVersion'] ?? '1.0.0',
      roadmapVersion: map['roadmapVersion'] ?? 1,
      generatedAt: DateTime.tryParse(map['generatedAt'] ?? '') ?? DateTime.now(),
      lastUpdatedAt: DateTime.tryParse(map['lastUpdatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());
  factory PersonalizedRoadmap.fromJson(String source) =>
      PersonalizedRoadmap.fromMap(jsonDecode(source) as Map<String, dynamic>);
}

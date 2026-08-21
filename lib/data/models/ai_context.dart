import 'dart:convert';
import 'ai_attachment.dart';
import 'ai_response.dart';
import 'personalized_roadmap_models.dart';

/// Context derived from student's profile & preferences
class StudentContext {
  final String academicStage;
  final List<String> careerGoals;
  final String primaryCareerDirection;
  final String primaryLanguage;
  final String overallSkillLevel;
  final List<String> weaknesses;
  final int dailyLearningMinutes;
  final String targetTimeline;

  const StudentContext({
    this.academicStage = '',
    this.careerGoals = const [],
    this.primaryCareerDirection = '',
    this.primaryLanguage = '',
    this.overallSkillLevel = '',
    this.weaknesses = const [],
    this.dailyLearningMinutes = 60,
    this.targetTimeline = '',
  });

  factory StudentContext.fromPersonalizedProfile(PersonalizedProfile profile) {
    return StudentContext(
      academicStage: profile.academicStage.displayName,
      careerGoals: profile.careerDirections,
      primaryCareerDirection: profile.primaryCareerDirection,
      primaryLanguage: profile.primaryLanguage,
      overallSkillLevel: profile.overallSkillLevel.displayName,
      weaknesses: profile.weaknesses,
      dailyLearningMinutes: profile.dailyLearningTimeMinutes,
      targetTimeline: profile.targetTimeline,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'academicStage': academicStage,
      'careerGoals': careerGoals,
      'primaryCareerDirection': primaryCareerDirection,
      'primaryLanguage': primaryLanguage,
      'overallSkillLevel': overallSkillLevel,
      'weaknesses': weaknesses,
      'dailyLearningMinutes': dailyLearningMinutes,
      'targetTimeline': targetTimeline,
    };
  }

  factory StudentContext.fromMap(Map<String, dynamic> map) {
    return StudentContext(
      academicStage: map['academicStage']?.toString() ?? '',
      careerGoals: (map['careerGoals'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      primaryCareerDirection: map['primaryCareerDirection']?.toString() ?? '',
      primaryLanguage: map['primaryLanguage']?.toString() ?? '',
      overallSkillLevel: map['overallSkillLevel']?.toString() ?? '',
      weaknesses: (map['weaknesses'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      dailyLearningMinutes:
          (map['dailyLearningMinutes'] as num?)?.toInt() ?? 60,
      targetTimeline: map['targetTimeline']?.toString() ?? '',
    );
  }
}

/// Context derived from student's active Personalized Roadmap
class RoadmapContext {
  final String roadmapTitle;
  final String currentPhaseTitle;
  final int currentPhaseSequence;
  final int totalPhases;
  final int completedTasksCount;
  final int totalTasksCount;
  final double overallProgressPercentage;
  final List<String> nextActionableTasks;
  final List<String> prioritizedWeaknesses;
  final int recommendedDailyMinutes;

  const RoadmapContext({
    this.roadmapTitle = '',
    this.currentPhaseTitle = '',
    this.currentPhaseSequence = 1,
    this.totalPhases = 0,
    this.completedTasksCount = 0,
    this.totalTasksCount = 0,
    this.overallProgressPercentage = 0.0,
    this.nextActionableTasks = const [],
    this.prioritizedWeaknesses = const [],
    this.recommendedDailyMinutes = 60,
  });

  factory RoadmapContext.fromPersonalizedRoadmap(PersonalizedRoadmap roadmap) {
    final activePhases = roadmap.phases;
    final currentPhase = activePhases.firstWhere(
      (p) => !p.isFullyCompleted,
      orElse: () => activePhases.isNotEmpty
          ? activePhases.first
          : const RoadmapPhase(
              id: '',
              title: '',
              description: '',
              sequence: 1,
              estimatedDuration: '',
              items: [],
            ),
    );

    final allItems = roadmap.allItems;
    final completedCount = allItems.where((i) => i.isCompleted).length;
    final actionable = allItems
        .where((i) => !i.isLocked && !i.isCompleted)
        .take(3)
        .map((i) => i.title)
        .toList();

    return RoadmapContext(
      roadmapTitle: roadmap.title,
      currentPhaseTitle: currentPhase.title,
      currentPhaseSequence: currentPhase.sequence,
      totalPhases: activePhases.length,
      completedTasksCount: completedCount,
      totalTasksCount: allItems.length,
      overallProgressPercentage: roadmap.overallProgress,
      nextActionableTasks: actionable,
      recommendedDailyMinutes: roadmap.dailyMinutes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roadmapTitle': roadmapTitle,
      'currentPhaseTitle': currentPhaseTitle,
      'currentPhaseSequence': currentPhaseSequence,
      'totalPhases': totalPhases,
      'completedTasksCount': completedTasksCount,
      'totalTasksCount': totalTasksCount,
      'overallProgressPercentage': overallProgressPercentage,
      'nextActionableTasks': nextActionableTasks,
      'prioritizedWeaknesses': prioritizedWeaknesses,
      'recommendedDailyMinutes': recommendedDailyMinutes,
    };
  }

  factory RoadmapContext.fromMap(Map<String, dynamic> map) {
    return RoadmapContext(
      roadmapTitle: map['roadmapTitle']?.toString() ?? '',
      currentPhaseTitle: map['currentPhaseTitle']?.toString() ?? '',
      currentPhaseSequence: (map['currentPhaseSequence'] as num?)?.toInt() ?? 1,
      totalPhases: (map['totalPhases'] as num?)?.toInt() ?? 0,
      completedTasksCount: (map['completedTasksCount'] as num?)?.toInt() ?? 0,
      totalTasksCount: (map['totalTasksCount'] as num?)?.toInt() ?? 0,
      overallProgressPercentage:
          (map['overallProgressPercentage'] as num?)?.toDouble() ?? 0.0,
      nextActionableTasks: (map['nextActionableTasks'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      prioritizedWeaknesses: (map['prioritizedWeaknesses'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      recommendedDailyMinutes:
          (map['recommendedDailyMinutes'] as num?)?.toInt() ?? 60,
    );
  }
}

/// Learning context representing the active screen or content being viewed
class LearningContext {
  final String? subjectCode;
  final String? subjectTitle;
  final String? chapterTitle;
  final String? topicTitle;
  final String? activeRoute;

  const LearningContext({
    this.subjectCode,
    this.subjectTitle,
    this.chapterTitle,
    this.topicTitle,
    this.activeRoute,
  });

  Map<String, dynamic> toMap() {
    return {
      'subjectCode': subjectCode,
      'subjectTitle': subjectTitle,
      'chapterTitle': chapterTitle,
      'topicTitle': topicTitle,
      'activeRoute': activeRoute,
    };
  }

  factory LearningContext.fromMap(Map<String, dynamic> map) {
    return LearningContext(
      subjectCode: map['subjectCode']?.toString(),
      subjectTitle: map['subjectTitle']?.toString(),
      chapterTitle: map['chapterTitle']?.toString(),
      topicTitle: map['topicTitle']?.toString(),
      activeRoute: map['activeRoute']?.toString(),
    );
  }
}

/// Unified multi-source context model for UniDocs AI
class AiContext {
  final StudentContext? student;
  final RoadmapContext? roadmap;
  final LearningContext? learning;
  final List<AiResourceReference> unidocsResources;
  final List<AiAttachment> attachedDocuments;
  final String? systemInstructions;
  final List<String> precedenceRules;

  const AiContext({
    this.student,
    this.roadmap,
    this.learning,
    this.unidocsResources = const [],
    this.attachedDocuments = const [],
    this.systemInstructions,
    this.precedenceRules = const [
      '1. Explicit user query always guides the primary task.',
      '2. UniDocs verified resources take precedence for CSE curriculum and hub topics.',
      '3. Student personalized profile and roadmap guide recommendations and tone.',
      '4. Uploaded document context guides source-specific questions.',
      '5. General AI knowledge provides conceptual foundations without fabricating references.',
    ],
  });

  bool get hasStudentContext => student != null;
  bool get hasRoadmapContext => roadmap != null;
  bool get hasLearningContext => learning != null;
  bool get hasResources => unidocsResources.isNotEmpty;
  bool get hasDocuments => attachedDocuments.isNotEmpty;

  AiContext copyWith({
    StudentContext? student,
    RoadmapContext? roadmap,
    LearningContext? learning,
    List<AiResourceReference>? unidocsResources,
    List<AiAttachment>? attachedDocuments,
    String? systemInstructions,
    List<String>? precedenceRules,
  }) {
    return AiContext(
      student: student ?? this.student,
      roadmap: roadmap ?? this.roadmap,
      learning: learning ?? this.learning,
      unidocsResources: unidocsResources ?? this.unidocsResources,
      attachedDocuments: attachedDocuments ?? this.attachedDocuments,
      systemInstructions: systemInstructions ?? this.systemInstructions,
      precedenceRules: precedenceRules ?? this.precedenceRules,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'student': student?.toMap(),
      'roadmap': roadmap?.toMap(),
      'learning': learning?.toMap(),
      'unidocsResources': unidocsResources.map((r) => r.toMap()).toList(),
      'attachedDocuments': attachedDocuments.map((d) => d.toMap()).toList(),
      'systemInstructions': systemInstructions,
      'precedenceRules': precedenceRules,
    };
  }

  factory AiContext.fromMap(Map<String, dynamic> map) {
    return AiContext(
      student: map['student'] != null
          ? StudentContext.fromMap(map['student'] as Map<String, dynamic>)
          : null,
      roadmap: map['roadmap'] != null
          ? RoadmapContext.fromMap(map['roadmap'] as Map<String, dynamic>)
          : null,
      learning: map['learning'] != null
          ? LearningContext.fromMap(map['learning'] as Map<String, dynamic>)
          : null,
      unidocsResources: (map['unidocsResources'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((r) => AiResourceReference.fromMap(r))
              .toList() ??
          const [],
      attachedDocuments: (map['attachedDocuments'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((d) => AiAttachment.fromMap(d))
              .toList() ??
          const [],
      systemInstructions: map['systemInstructions']?.toString(),
      precedenceRules: (map['precedenceRules'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [
            '1. Explicit user query always guides the primary task.',
            '2. UniDocs verified resources take precedence for CSE curriculum and hub topics.',
            '3. Student personalized profile and roadmap guide recommendations and tone.',
            '4. Uploaded document context guides source-specific questions.',
            '5. General AI knowledge provides conceptual foundations without fabricating references.',
          ],
    );
  }

  String toJson() => json.encode(toMap());

  factory AiContext.fromJson(String source) =>
      AiContext.fromMap(json.decode(source) as Map<String, dynamic>);
}

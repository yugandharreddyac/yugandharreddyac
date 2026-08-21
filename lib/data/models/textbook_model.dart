import 'resource_model.dart';

class CourseOverviewModel {
  final String subjectId;
  final String subjectName;
  final String description;
  final String whyItMatters;
  final List<String> prerequisites;
  final List<String> learningObjectives;
  final List<String> learningOutcomes;
  final String estimatedStudyTime;
  final String estimatedDifficulty;
  final Map<String, List<String>> syllabusMapping;

  const CourseOverviewModel({
    required this.subjectId,
    required this.subjectName,
    required this.description,
    required this.whyItMatters,
    required this.prerequisites,
    required this.learningObjectives,
    required this.learningOutcomes,
    this.estimatedStudyTime = '45 Hours',
    this.estimatedDifficulty = 'Intermediate',
    this.syllabusMapping = const {},
  });

  factory CourseOverviewModel.fromJson(
      Map<String, dynamic> json, String subjectId) {
    return CourseOverviewModel(
      subjectId: subjectId,
      subjectName: json['subjectName'] ?? '',
      description: json['description'] ?? '',
      whyItMatters: json['whyItMatters'] ?? '',
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
      learningObjectives: List<String>.from(json['learningObjectives'] ?? []),
      learningOutcomes: List<String>.from(json['learningOutcomes'] ?? []),
      estimatedStudyTime: json['estimatedStudyTime'] ?? '45 Hours',
      estimatedDifficulty: json['estimatedDifficulty'] ?? 'Intermediate',
      syllabusMapping: (json['syllabusMapping'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, List<String>.from(v)),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
      'subjectName': subjectName,
      'description': description,
      'whyItMatters': whyItMatters,
      'prerequisites': prerequisites,
      'learningObjectives': learningObjectives,
      'learningOutcomes': learningOutcomes,
      'estimatedStudyTime': estimatedStudyTime,
      'estimatedDifficulty': estimatedDifficulty,
      'syllabusMapping': syllabusMapping,
    };
  }
}

class TextbookChapterModel {
  final String id;
  final String subjectId;
  final int chapterNumber;
  final String title;
  final String description;
  final int order;
  final List<TextbookSectionModel> sections;

  const TextbookChapterModel({
    required this.id,
    required this.subjectId,
    required this.chapterNumber,
    required this.title,
    required this.description,
    required this.order,
    this.sections = const [],
  });

  factory TextbookChapterModel.fromJson(Map<String, dynamic> json) {
    return TextbookChapterModel(
      id: json['id'] ?? '',
      subjectId: json['subjectId'] ?? '',
      chapterNumber: json['chapterNumber'] as int? ?? 1,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      order: json['order'] as int? ?? 1,
      sections: (json['sections'] as List<dynamic>?)
              ?.map((e) =>
                  TextbookSectionModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectId': subjectId,
      'chapterNumber': chapterNumber,
      'title': title,
      'description': description,
      'order': order,
      'sections': sections.map((e) => e.toJson()).toList(),
    };
  }

  TextbookChapterModel copyWith({
    String? id,
    String? subjectId,
    int? chapterNumber,
    String? title,
    String? description,
    int? order,
    List<TextbookSectionModel>? sections,
  }) {
    return TextbookChapterModel(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      sections: sections ?? this.sections,
    );
  }
}

class TextbookSectionModel {
  final String id;
  final String chapterId;
  final String sectionNumber; // e.g. "1.1", "1.2"
  final String title;
  final String description;
  final int order;
  final List<TextbookTopicModel> topics;

  const TextbookSectionModel({
    required this.id,
    required this.chapterId,
    required this.sectionNumber,
    required this.title,
    required this.description,
    required this.order,
    this.topics = const [],
  });

  factory TextbookSectionModel.fromJson(Map<String, dynamic> json) {
    return TextbookSectionModel(
      id: json['id'] ?? '',
      chapterId: json['chapterId'] ?? '',
      sectionNumber: json['sectionNumber'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      order: json['order'] as int? ?? 1,
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) =>
                  TextbookTopicModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterId': chapterId,
      'sectionNumber': sectionNumber,
      'title': title,
      'description': description,
      'order': order,
      'topics': topics.map((e) => e.toJson()).toList(),
    };
  }

  TextbookSectionModel copyWith({
    String? id,
    String? chapterId,
    String? sectionNumber,
    String? title,
    String? description,
    int? order,
    List<TextbookTopicModel>? topics,
  }) {
    return TextbookSectionModel(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      sectionNumber: sectionNumber ?? this.sectionNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      topics: topics ?? this.topics,
    );
  }
}

class TextbookTopicModel {
  final String id;
  final String sectionId;
  final String topicNumber; // e.g. "1.1.1"
  final String title;
  final String definition;
  final String intuition;
  final String workingPrinciple;
  final String? algorithm;
  final String? pseudocode;
  final String? codeImplementation;
  final String? timeComplexity;
  final String? spaceComplexity;
  final List<String> advantages;
  final List<String> disadvantages;
  final List<String> applications;
  final List<String> commonMistakes;
  final List<String> practiceQuestions;
  final List<String> examQuestions;
  final ResourceModel? attachedResource;
  final int order;
  final bool isCompleted;

  const TextbookTopicModel({
    required this.id,
    required this.sectionId,
    required this.topicNumber,
    required this.title,
    required this.definition,
    required this.intuition,
    required this.workingPrinciple,
    this.algorithm,
    this.pseudocode,
    this.codeImplementation,
    this.timeComplexity,
    this.spaceComplexity,
    this.advantages = const [],
    this.disadvantages = const [],
    this.applications = const [],
    this.commonMistakes = const [],
    this.practiceQuestions = const [],
    this.examQuestions = const [],
    this.attachedResource,
    required this.order,
    this.isCompleted = false,
  });

  factory TextbookTopicModel.fromJson(Map<String, dynamic> json) {
    return TextbookTopicModel(
      id: json['id'] ?? '',
      sectionId: json['sectionId'] ?? '',
      topicNumber: json['topicNumber'] ?? '',
      title: json['title'] ?? '',
      definition: json['definition'] ?? '',
      intuition: json['intuition'] ?? '',
      workingPrinciple: json['workingPrinciple'] ?? '',
      algorithm: json['algorithm'],
      pseudocode: json['pseudocode'],
      codeImplementation: json['codeImplementation'],
      timeComplexity: json['timeComplexity'],
      spaceComplexity: json['spaceComplexity'],
      advantages: List<String>.from(json['advantages'] ?? []),
      disadvantages: List<String>.from(json['disadvantages'] ?? []),
      applications: List<String>.from(json['applications'] ?? []),
      commonMistakes: List<String>.from(json['commonMistakes'] ?? []),
      practiceQuestions: List<String>.from(json['practiceQuestions'] ?? []),
      examQuestions: List<String>.from(json['examQuestions'] ?? []),
      attachedResource: json['attachedResource'] != null
          ? ResourceModel.fromFirestore(
              Map<String, dynamic>.from(json['attachedResource']),
              json['attachedResource']['id'] ?? '')
          : null,
      order: json['order'] as int? ?? 1,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sectionId': sectionId,
      'topicNumber': topicNumber,
      'title': title,
      'definition': definition,
      'intuition': intuition,
      'workingPrinciple': workingPrinciple,
      'algorithm': algorithm,
      'pseudocode': pseudocode,
      'codeImplementation': codeImplementation,
      'timeComplexity': timeComplexity,
      'spaceComplexity': spaceComplexity,
      'advantages': advantages,
      'disadvantages': disadvantages,
      'applications': applications,
      'commonMistakes': commonMistakes,
      'practiceQuestions': practiceQuestions,
      'examQuestions': examQuestions,
      'attachedResource': attachedResource?.toFirestore(),
      'order': order,
      'isCompleted': isCompleted,
    };
  }
}

enum ContentSource {
  official,
  generated,
  curatedExternal,
  userUploaded,
}

enum PublishStatus {
  draft,
  inReview,
  published,
}

class ExternalResourceModel {
  final String id;
  final String title;
  final String url;
  final ContentSource sourceType;
  final String
      resourceType; // e.g., 'OfficialDoc', 'Tutorial', 'YouTubeVideo', 'Playlist', 'OnlineCourse', 'Book', 'GitHubRepo'
  final String description;
  final bool isVerified;

  const ExternalResourceModel({
    required this.id,
    required this.title,
    required this.url,
    this.sourceType = ContentSource.curatedExternal,
    this.resourceType = 'Tutorial',
    this.description = '',
    this.isVerified = true,
  });

  factory ExternalResourceModel.fromJson(Map<String, dynamic> json) {
    return ExternalResourceModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      sourceType: ContentSource.values.firstWhere(
        (e) => e.name == json['sourceType'],
        orElse: () => ContentSource.curatedExternal,
      ),
      resourceType: json['resourceType'] ?? 'Tutorial',
      description: json['description'] ?? '',
      isVerified: json['isVerified'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'sourceType': sourceType.name,
      'resourceType': resourceType,
      'description': description,
      'isVerified': isVerified,
    };
  }
}

class AcademicQuestionModel {
  final String id;
  final String chapterId;
  final int chapterNumber;
  final String question;
  final String answer;
  final String
      category; // 'Very Short', 'Short', 'Long', 'Conceptual', 'Programming', 'High Priority'
  final int order;

  const AcademicQuestionModel({
    required this.id,
    required this.chapterId,
    required this.chapterNumber,
    required this.question,
    required this.answer,
    required this.category,
    required this.order,
  });

  factory AcademicQuestionModel.fromJson(Map<String, dynamic> json) {
    return AcademicQuestionModel(
      id: json['id'] ?? '',
      chapterId: json['chapterId'] ?? '',
      chapterNumber: json['chapterNumber'] as int? ?? 1,
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      category: json['category'] ?? 'Short',
      order: json['order'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterId': chapterId,
      'chapterNumber': chapterNumber,
      'question': question,
      'answer': answer,
      'category': category,
      'order': order,
    };
  }
}

class LabExperimentModel {
  final String id;
  final int experimentNumber;
  final String title;
  final String objective;
  final String theory;
  final String procedure;
  final String code;
  final String expectedOutput;
  final List<String> vivaQuestions;
  final int order;

  const LabExperimentModel({
    required this.id,
    required this.experimentNumber,
    required this.title,
    required this.objective,
    required this.theory,
    required this.procedure,
    required this.code,
    required this.expectedOutput,
    this.vivaQuestions = const [],
    required this.order,
  });

  factory LabExperimentModel.fromJson(Map<String, dynamic> json) {
    return LabExperimentModel(
      id: json['id'] ?? '',
      experimentNumber: json['experimentNumber'] as int? ?? 1,
      title: json['title'] ?? '',
      objective: json['objective'] ?? '',
      theory: json['theory'] ?? '',
      procedure: json['procedure'] ?? '',
      code: json['code'] ?? '',
      expectedOutput: json['expectedOutput'] ?? '',
      vivaQuestions: List<String>.from(json['vivaQuestions'] ?? []),
      order: json['order'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'experimentNumber': experimentNumber,
      'title': title,
      'objective': objective,
      'theory': theory,
      'procedure': procedure,
      'code': code,
      'expectedOutput': expectedOutput,
      'vivaQuestions': vivaQuestions,
      'order': order,
    };
  }
}

class QuickRevisionModel {
  final String id;
  final String chapterId;
  final String title;
  final List<String> keyDefinitions;
  final List<String> formulas;
  final List<String> lastMinutePoints;
  final int order;

  const QuickRevisionModel({
    required this.id,
    required this.chapterId,
    required this.title,
    this.keyDefinitions = const [],
    this.formulas = const [],
    this.lastMinutePoints = const [],
    required this.order,
  });

  factory QuickRevisionModel.fromJson(Map<String, dynamic> json) {
    return QuickRevisionModel(
      id: json['id'] ?? '',
      chapterId: json['chapterId'] ?? '',
      title: json['title'] ?? '',
      keyDefinitions: List<String>.from(json['keyDefinitions'] ?? []),
      formulas: List<String>.from(json['formulas'] ?? []),
      lastMinutePoints: List<String>.from(json['lastMinutePoints'] ?? []),
      order: json['order'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterId': chapterId,
      'title': title,
      'keyDefinitions': keyDefinitions,
      'formulas': formulas,
      'lastMinutePoints': lastMinutePoints,
      'order': order,
    };
  }
}

class AcademicProjectModel {
  final String id;
  final String title;
  final String description;
  final List<String> objectives;
  final String architecture;
  final String? sourceCodeUrl;
  final String difficulty;

  const AcademicProjectModel({
    required this.id,
    required this.title,
    required this.description,
    this.objectives = const [],
    required this.architecture,
    this.sourceCodeUrl,
    this.difficulty = 'Intermediate',
  });

  factory AcademicProjectModel.fromJson(Map<String, dynamic> json) {
    return AcademicProjectModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      objectives: List<String>.from(json['objectives'] ?? []),
      architecture: json['architecture'] ?? '',
      sourceCodeUrl: json['sourceCodeUrl'],
      difficulty: json['difficulty'] ?? 'Intermediate',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'objectives': objectives,
      'architecture': architecture,
      'sourceCodeUrl': sourceCodeUrl,
      'difficulty': difficulty,
    };
  }
}

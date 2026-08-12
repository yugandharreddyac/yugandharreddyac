enum ContentSource {
  generated,
  official,
  curatedExternal,
  userUploaded,
}

enum PublishStatus {
  draft,
  inReview,
  published,
}

class LearningPhaseModel {
  final int phaseNumber;
  final String title;
  final String subtitle;
  final String description;
  final List<String> topics;
  final List<String> milestones;
  final String estimatedDuration;

  const LearningPhaseModel({
    required this.phaseNumber,
    required this.title,
    required this.subtitle,
    required this.description,
    this.topics = const [],
    this.milestones = const [],
    this.estimatedDuration = '2 Weeks',
  });

  factory LearningPhaseModel.fromJson(Map<String, dynamic> json) {
    return LearningPhaseModel(
      phaseNumber: json['phaseNumber'] as int? ?? 1,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      topics: List<String>.from(json['topics'] ?? []),
      milestones: List<String>.from(json['milestones'] ?? []),
      estimatedDuration: json['estimatedDuration'] ?? '2 Weeks',
    );
  }

  String get phaseName => title;
  String get duration => estimatedDuration;

  Map<String, dynamic> toJson() => {
        'phaseNumber': phaseNumber,
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'topics': topics,
        'milestones': milestones,
        'estimatedDuration': estimatedDuration,
      };
}

class SkillMatrixModel {
  final String skillName;
  final String category; // 'Core CS', 'Programming Language', 'Tool', 'Framework', 'Database'
  final String level; // 'Beginner', 'Intermediate', 'Advanced', 'Expert'
  final String importance; // 'Mandatory', 'Recommended', 'Optional'
  final String description;

  const SkillMatrixModel({
    required this.skillName,
    required this.category,
    this.level = 'Intermediate',
    this.importance = 'Mandatory',
    this.description = '',
  });

  factory SkillMatrixModel.fromJson(Map<String, dynamic> json) {
    return SkillMatrixModel(
      skillName: json['skillName'] ?? '',
      category: json['category'] ?? 'Core CS',
      level: json['level'] ?? 'Intermediate',
      importance: json['importance'] ?? 'Mandatory',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'skillName': skillName,
        'category': category,
        'level': level,
        'importance': importance,
        'description': description,
      };
}

class ChecklistItemModel {
  final String id;
  final String title;
  final String category; // 'Learned', 'Practiced', 'Built', 'Interview Ready'
  final bool isCompleted;

  const ChecklistItemModel({
    required this.id,
    required this.title,
    required this.category,
    this.isCompleted = false,
  });

  factory ChecklistItemModel.fromJson(Map<String, dynamic> json) {
    return ChecklistItemModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? 'Learned',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'isCompleted': isCompleted,
      };
}

class BeyondAcademicsResourceModel {
  final String id;
  final String title;
  final String provider; // e.g., 'MDN', 'freeCodeCamp', 'GeeksforGeeks', 'roadmap.sh', 'Official Docs'
  final String url;
  final String resourceType; // 'OfficialDoc', 'Tutorial', 'Course', 'YouTube', 'GitHub', 'Roadmap', 'Practice', 'Certification'
  final String description;
  final String relatedTopic;
  final String difficulty;
  final bool isFree;
  final bool isOfficial;
  final String lastVerified;
  final bool isTimeSensitive;
  final String verificationNote;
  final ContentSource sourceType;
  final PublishStatus publishStatus;

  const BeyondAcademicsResourceModel({
    required this.id,
    required this.title,
    required this.provider,
    required this.url,
    required this.resourceType,
    required this.description,
    this.relatedTopic = '',
    this.difficulty = 'All Levels',
    this.isFree = true,
    this.isOfficial = true,
    this.lastVerified = '2026-08-08',
    this.isTimeSensitive = false,
    this.verificationNote = 'Official educational portal verified by UniDocs.',
    this.sourceType = ContentSource.official,
    this.publishStatus = PublishStatus.published,
  });

  factory BeyondAcademicsResourceModel.fromJson(Map<String, dynamic> json) {
    return BeyondAcademicsResourceModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      provider: json['provider'] ?? '',
      url: json['url'] ?? '',
      resourceType: json['resourceType'] ?? 'Tutorial',
      description: json['description'] ?? '',
      relatedTopic: json['relatedTopic'] ?? '',
      difficulty: json['difficulty'] ?? 'All Levels',
      isFree: json['isFree'] as bool? ?? true,
      isOfficial: json['isOfficial'] as bool? ?? true,
      lastVerified: json['lastVerified'] ?? '2026-08-08',
      isTimeSensitive: json['isTimeSensitive'] as bool? ?? false,
      verificationNote: json['verificationNote'] ?? 'Official educational portal verified by UniDocs.',
      sourceType: ContentSource.values.firstWhere(
        (e) => e.toString() == 'ContentSource.${json['sourceType']}',
        orElse: () => ContentSource.official,
      ),
      publishStatus: PublishStatus.values.firstWhere(
        (e) => e.toString() == 'PublishStatus.${json['publishStatus']}',
        orElse: () => PublishStatus.published,
      ),
    );
  }

  String get category => resourceType;
  bool get isVerified => isOfficial;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'provider': provider,
        'url': url,
        'resourceType': resourceType,
        'description': description,
        'relatedTopic': relatedTopic,
        'difficulty': difficulty,
        'isFree': isFree,
        'isOfficial': isOfficial,
        'lastVerified': lastVerified,
        'isTimeSensitive': isTimeSensitive,
        'verificationNote': verificationNote,
        'sourceType': sourceType.name,
        'publishStatus': publishStatus.name,
      };
}

class CodingLanguageModel {
  final String id;
  final String name;
  final String icon;
  final String introduction;
  final String whyLearn;
  final String syntaxFundamentals;
  final String variablesAndDataTypes;
  final String operatorsAndConditions;
  final String loopsAndControlFlow;
  final String functionsAndScope;
  final String collectionsAndArrays;
  final String stringHandling;
  final String objectOrientedProgramming;
  final String errorAndFileHandling;
  final List<String> practiceProblems;
  final List<String> recommendedProjects;
  final List<String> interviewQuestions;
  final String officialDocsUrl;
  final String youtubePlaylistUrl;

  const CodingLanguageModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.introduction,
    required this.whyLearn,
    required this.syntaxFundamentals,
    required this.variablesAndDataTypes,
    required this.operatorsAndConditions,
    required this.loopsAndControlFlow,
    required this.functionsAndScope,
    required this.collectionsAndArrays,
    required this.stringHandling,
    required this.objectOrientedProgramming,
    required this.errorAndFileHandling,
    this.practiceProblems = const [],
    this.recommendedProjects = const [],
    this.interviewQuestions = const [],
    required this.officialDocsUrl,
    required this.youtubePlaylistUrl,
  });

  factory CodingLanguageModel.fromJson(Map<String, dynamic> json) {
    return CodingLanguageModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      introduction: json['introduction'] ?? '',
      whyLearn: json['whyLearn'] ?? '',
      syntaxFundamentals: json['syntaxFundamentals'] ?? '',
      variablesAndDataTypes: json['variablesAndDataTypes'] ?? '',
      operatorsAndConditions: json['operatorsAndConditions'] ?? '',
      loopsAndControlFlow: json['loopsAndControlFlow'] ?? '',
      functionsAndScope: json['functionsAndScope'] ?? '',
      collectionsAndArrays: json['collectionsAndArrays'] ?? '',
      stringHandling: json['stringHandling'] ?? '',
      objectOrientedProgramming: json['objectOrientedProgramming'] ?? '',
      errorAndFileHandling: json['errorAndFileHandling'] ?? '',
      practiceProblems: List<String>.from(json['practiceProblems'] ?? []),
      recommendedProjects: List<String>.from(json['recommendedProjects'] ?? []),
      interviewQuestions: List<String>.from(json['interviewQuestions'] ?? []),
      officialDocsUrl: json['officialDocsUrl'] ?? '',
      youtubePlaylistUrl: json['youtubePlaylistUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'introduction': introduction,
        'whyLearn': whyLearn,
        'syntaxFundamentals': syntaxFundamentals,
        'variablesAndDataTypes': variablesAndDataTypes,
        'operatorsAndConditions': operatorsAndConditions,
        'loopsAndControlFlow': loopsAndControlFlow,
        'functionsAndScope': functionsAndScope,
        'collectionsAndArrays': collectionsAndArrays,
        'stringHandling': stringHandling,
        'objectOrientedProgramming': objectOrientedProgramming,
        'errorAndFileHandling': errorAndFileHandling,
        'practiceProblems': practiceProblems,
        'recommendedProjects': recommendedProjects,
        'interviewQuestions': interviewQuestions,
        'officialDocsUrl': officialDocsUrl,
        'youtubePlaylistUrl': youtubePlaylistUrl,
      };
}

class DsaTopicModel {
  final String id;
  final String topicName;
  final String category; // 'Arrays', 'Strings', 'LinkedList', 'Stack', 'Queue', 'Trees', 'Graphs', 'DP', 'Greedy'
  final String definition;
  final String intuition;
  final String approach;
  final String algorithm;
  final String pseudocode;
  final String codeImplementation;
  final String timeComplexity;
  final String spaceComplexity;
  final String example;
  final List<String> commonMistakes;
  final List<String> practiceProblems;
  final List<String> interviewQuestions;

  const DsaTopicModel({
    required this.id,
    required this.topicName,
    required this.category,
    required this.definition,
    required this.intuition,
    required this.approach,
    required this.algorithm,
    required this.pseudocode,
    required this.codeImplementation,
    required this.timeComplexity,
    required this.spaceComplexity,
    required this.example,
    this.commonMistakes = const [],
    this.practiceProblems = const [],
    this.interviewQuestions = const [],
  });

  factory DsaTopicModel.fromJson(Map<String, dynamic> json) {
    return DsaTopicModel(
      id: json['id'] ?? '',
      topicName: json['topicName'] ?? '',
      category: json['category'] ?? 'Arrays',
      definition: json['definition'] ?? '',
      intuition: json['intuition'] ?? '',
      approach: json['approach'] ?? '',
      algorithm: json['algorithm'] ?? '',
      pseudocode: json['pseudocode'] ?? '',
      codeImplementation: json['codeImplementation'] ?? '',
      timeComplexity: json['timeComplexity'] ?? '',
      spaceComplexity: json['spaceComplexity'] ?? '',
      example: json['example'] ?? '',
      commonMistakes: List<String>.from(json['commonMistakes'] ?? []),
      practiceProblems: List<String>.from(json['practiceProblems'] ?? []),
      interviewQuestions: List<String>.from(json['interviewQuestions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'topicName': topicName,
        'category': category,
        'definition': definition,
        'intuition': intuition,
        'approach': approach,
        'algorithm': algorithm,
        'pseudocode': pseudocode,
        'codeImplementation': codeImplementation,
        'timeComplexity': timeComplexity,
        'spaceComplexity': spaceComplexity,
        'example': example,
        'commonMistakes': commonMistakes,
        'practiceProblems': practiceProblems,
        'interviewQuestions': interviewQuestions,
      };
}

class IndustryProjectModel {
  final String id;
  final String title;
  final String problemStatement;
  final String whyBuild;
  final List<String> prerequisites;
  final List<String> requiredSkills;
  final List<String> techStack;
  final String architecture;
  final List<String> modules;
  final List<String> developmentPhases;
  final String databaseRequirements;
  final String apiRequirements;
  final String folderStructure;
  final List<String> implementationRoadmap;
  final String testingRequirements;
  final String deploymentRequirements;
  final String readmeRequirements;
  final String resumeDescription;
  final List<String> interviewQuestions;
  final List<String> possibleImprovements;
  final String? githubUrl;
  final String difficulty; // 'Beginner', 'Intermediate', 'Advanced', 'Major Project', 'Industry-style'

  const IndustryProjectModel({
    required this.id,
    required this.title,
    required this.problemStatement,
    required this.whyBuild,
    this.prerequisites = const [],
    this.requiredSkills = const [],
    this.techStack = const [],
    required this.architecture,
    this.modules = const [],
    this.developmentPhases = const [],
    required this.databaseRequirements,
    required this.apiRequirements,
    required this.folderStructure,
    this.implementationRoadmap = const [],
    required this.testingRequirements,
    required this.deploymentRequirements,
    required this.readmeRequirements,
    required this.resumeDescription,
    this.interviewQuestions = const [],
    this.possibleImprovements = const [],
    this.githubUrl,
    this.difficulty = 'Intermediate',
  });

  factory IndustryProjectModel.fromJson(Map<String, dynamic> json) {
    return IndustryProjectModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      problemStatement: json['problemStatement'] ?? '',
      whyBuild: json['whyBuild'] ?? '',
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
      requiredSkills: List<String>.from(json['requiredSkills'] ?? []),
      techStack: List<String>.from(json['techStack'] ?? []),
      architecture: json['architecture'] ?? '',
      modules: List<String>.from(json['modules'] ?? []),
      developmentPhases: List<String>.from(json['developmentPhases'] ?? []),
      databaseRequirements: json['databaseRequirements'] ?? '',
      apiRequirements: json['apiRequirements'] ?? '',
      folderStructure: json['folderStructure'] ?? '',
      implementationRoadmap: List<String>.from(json['implementationRoadmap'] ?? []),
      testingRequirements: json['testingRequirements'] ?? '',
      deploymentRequirements: json['deploymentRequirements'] ?? '',
      readmeRequirements: json['readmeRequirements'] ?? '',
      resumeDescription: json['resumeDescription'] ?? '',
      interviewQuestions: List<String>.from(json['interviewQuestions'] ?? []),
      possibleImprovements: List<String>.from(json['possibleImprovements'] ?? []),
      githubUrl: json['githubUrl'],
      difficulty: json['difficulty'] ?? 'Intermediate',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'problemStatement': problemStatement,
        'whyBuild': whyBuild,
        'prerequisites': prerequisites,
        'requiredSkills': requiredSkills,
        'techStack': techStack,
        'architecture': architecture,
        'modules': modules,
        'developmentPhases': developmentPhases,
        'databaseRequirements': databaseRequirements,
        'apiRequirements': apiRequirements,
        'folderStructure': folderStructure,
        'implementationRoadmap': implementationRoadmap,
        'testingRequirements': testingRequirements,
        'deploymentRequirements': deploymentRequirements,
        'readmeRequirements': readmeRequirements,
        'resumeDescription': resumeDescription,
        'interviewQuestions': interviewQuestions,
        'possibleImprovements': possibleImprovements,
        'githubUrl': githubUrl,
        'difficulty': difficulty,
      };
}

class PlacementModuleModel {
  final String id;
  final String title;
  final String moduleCategory; // 'Placement Roadmap', 'DSA Prep', 'Core CS', 'Aptitude', 'Reasoning', 'Verbal', 'Coding Tests', 'Technical Interviews', 'HR Interviews', 'Resume Prep', 'Mock Interviews', 'Company Prep', 'Interview Experiences', 'Placement Checklist'
  final List<String> concepts;
  final List<String> interviewQuestions;
  final List<String> codingQuestions;
  final List<String> frequentlyConfused;
  final List<String> interviewTips;
  final List<String> practiceChecklist;

  const PlacementModuleModel({
    required this.id,
    required this.title,
    required this.moduleCategory,
    this.concepts = const [],
    this.interviewQuestions = const [],
    this.codingQuestions = const [],
    this.frequentlyConfused = const [],
    this.interviewTips = const [],
    this.practiceChecklist = const [],
  });

  factory PlacementModuleModel.fromJson(Map<String, dynamic> json) {
    return PlacementModuleModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      moduleCategory: json['moduleCategory'] ?? 'Placement Roadmap',
      concepts: List<String>.from(json['concepts'] ?? []),
      interviewQuestions: List<String>.from(json['interviewQuestions'] ?? []),
      codingQuestions: List<String>.from(json['codingQuestions'] ?? []),
      frequentlyConfused: List<String>.from(json['frequentlyConfused'] ?? []),
      interviewTips: List<String>.from(json['interviewTips'] ?? []),
      practiceChecklist: List<String>.from(json['practiceChecklist'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'moduleCategory': moduleCategory,
        'concepts': concepts,
        'interviewQuestions': interviewQuestions,
        'codingQuestions': codingQuestions,
        'frequentlyConfused': frequentlyConfused,
        'interviewTips': interviewTips,
        'practiceChecklist': practiceChecklist,
      };
}

class HigherEducationTopicModel {
  final String id;
  final String title;
  final String category; // 'M.Tech', 'MS', 'MBA', 'PhD', 'Research', 'International', 'GATE', 'GRE', 'IELTS/TOEFL', 'Scholarships', 'Research Internships', 'SOP Guidance', 'LOR Guidance', 'Paper Guidance', 'Profile Building'
  final String degreeType;
  final String country;
  final List<String> admissionRequirements;
  final String sopGuidance;
  final String lorGuidance;
  final List<String> entranceExams;
  final List<String> scholarships;
  final List<BeyondAcademicsResourceModel> officialSources;

  const HigherEducationTopicModel({
    required this.id,
    required this.title,
    required this.category,
    this.degreeType = 'M.Tech / MS',
    this.country = 'India & Global',
    this.admissionRequirements = const [],
    required this.sopGuidance,
    required this.lorGuidance,
    this.entranceExams = const [],
    this.scholarships = const [],
    this.officialSources = const [],
  });

  factory HigherEducationTopicModel.fromJson(Map<String, dynamic> json) {
    return HigherEducationTopicModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? 'M.Tech',
      degreeType: json['degreeType'] ?? 'M.Tech / MS',
      country: json['country'] ?? 'India & Global',
      admissionRequirements: List<String>.from(json['admissionRequirements'] ?? []),
      sopGuidance: json['sopGuidance'] ?? '',
      lorGuidance: json['lorGuidance'] ?? '',
      entranceExams: List<String>.from(json['entranceExams'] ?? []),
      scholarships: List<String>.from(json['scholarships'] ?? []),
      officialSources: (json['officialSources'] as List<dynamic>?)
              ?.map((e) => BeyondAcademicsResourceModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'degreeType': degreeType,
        'country': country,
        'admissionRequirements': admissionRequirements,
        'sopGuidance': sopGuidance,
        'lorGuidance': lorGuidance,
        'entranceExams': entranceExams,
        'scholarships': scholarships,
        'officialSources': officialSources.map((e) => e.toJson()).toList(),
      };
}

class EmergingTechDetailModel {
  final String id;
  final String title;
  final String category;
  final String icon;
  final String overview;
  final String whyItMatters;
  final List<String> prerequisites;
  final List<String> coreConcepts;
  final List<String> programmingLanguages;
  final String mathematics;
  final List<String> tools;
  final List<String> frameworks;
  final List<LearningPhaseModel> learningPhases;
  final List<String> handsOnExercises;
  final List<String> projects;
  final List<String> portfolioIdeas;
  final List<String> interviewQuestions;
  final List<String> careerRoles;
  final List<String> industryApplications;
  final List<String> commonMistakes;
  final String futureDirection;
  final List<BeyondAcademicsResourceModel> officialResources;
  final List<BeyondAcademicsResourceModel> githubRepos;
  final List<BeyondAcademicsResourceModel> youtubeResources;
  final List<BeyondAcademicsResourceModel> roadmapResources;

  const EmergingTechDetailModel({
    required this.id,
    required this.title,
    required this.category,
    required this.icon,
    required this.overview,
    required this.whyItMatters,
    this.prerequisites = const [],
    this.coreConcepts = const [],
    this.programmingLanguages = const [],
    this.mathematics = '',
    this.tools = const [],
    this.frameworks = const [],
    this.learningPhases = const [],
    this.handsOnExercises = const [],
    this.projects = const [],
    this.portfolioIdeas = const [],
    this.interviewQuestions = const [],
    this.careerRoles = const [],
    this.industryApplications = const [],
    this.commonMistakes = const [],
    required this.futureDirection,
    this.officialResources = const [],
    this.githubRepos = const [],
    this.youtubeResources = const [],
    this.roadmapResources = const [],
  });

  factory EmergingTechDetailModel.fromJson(Map<String, dynamic> json) {
    return EmergingTechDetailModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? 'Emerging Technology',
      icon: json['icon'] ?? '',
      overview: json['overview'] ?? '',
      whyItMatters: json['whyItMatters'] ?? '',
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
      coreConcepts: List<String>.from(json['coreConcepts'] ?? []),
      programmingLanguages: List<String>.from(json['programmingLanguages'] ?? []),
      mathematics: json['mathematics'] ?? '',
      tools: List<String>.from(json['tools'] ?? []),
      frameworks: List<String>.from(json['frameworks'] ?? []),
      learningPhases: (json['learningPhases'] as List<dynamic>?)
              ?.map((e) => LearningPhaseModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      handsOnExercises: List<String>.from(json['handsOnExercises'] ?? []),
      projects: List<String>.from(json['projects'] ?? []),
      portfolioIdeas: List<String>.from(json['portfolioIdeas'] ?? []),
      interviewQuestions: List<String>.from(json['interviewQuestions'] ?? []),
      careerRoles: List<String>.from(json['careerRoles'] ?? []),
      industryApplications: List<String>.from(json['industryApplications'] ?? []),
      commonMistakes: List<String>.from(json['commonMistakes'] ?? []),
      futureDirection: json['futureDirection'] ?? '',
      officialResources: (json['officialResources'] as List<dynamic>?)
              ?.map((e) => BeyondAcademicsResourceModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      githubRepos: (json['githubRepos'] as List<dynamic>?)
              ?.map((e) => BeyondAcademicsResourceModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      youtubeResources: (json['youtubeResources'] as List<dynamic>?)
              ?.map((e) => BeyondAcademicsResourceModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      roadmapResources: (json['roadmapResources'] as List<dynamic>?)
              ?.map((e) => BeyondAcademicsResourceModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'icon': icon,
        'overview': overview,
        'whyItMatters': whyItMatters,
        'prerequisites': prerequisites,
        'coreConcepts': coreConcepts,
        'programmingLanguages': programmingLanguages,
        'mathematics': mathematics,
        'tools': tools,
        'frameworks': frameworks,
        'learningPhases': learningPhases.map((e) => e.toJson()).toList(),
        'handsOnExercises': handsOnExercises,
        'projects': projects,
        'portfolioIdeas': portfolioIdeas,
        'interviewQuestions': interviewQuestions,
        'careerRoles': careerRoles,
        'industryApplications': industryApplications,
        'commonMistakes': commonMistakes,
        'futureDirection': futureDirection,
        'officialResources': officialResources.map((e) => e.toJson()).toList(),
        'githubRepos': githubRepos.map((e) => e.toJson()).toList(),
        'youtubeResources': youtubeResources.map((e) => e.toJson()).toList(),
        'roadmapResources': roadmapResources.map((e) => e.toJson()).toList(),
      };
}

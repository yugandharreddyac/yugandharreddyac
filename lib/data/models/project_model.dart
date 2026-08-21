import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String
      category; // Mini, Major, AI, Flutter, Web Development, Python, Java, DevOps, Cybersecurity
  final String difficulty; // Beginner, Intermediate, Advanced, Industry Level
  final String estimatedDuration;
  final String problemStatement;
  final String realWorldUseCase;
  final String targetUsers;
  final List<String> prerequisites;
  final List<String> requiredSkills;
  final List<String> technologies;
  final String whyTheseTechnologies;
  final String systemArchitecture;
  final List<String> majorModules;
  final String databaseDesign;
  final String apiRequirements;
  final String folderStructure;
  final List<String> developmentPhases;
  final List<String> implementationRoadmap;
  final String testingStrategy;
  final String securityConsiderations;
  final String deploymentStrategy;
  final String documentationRequirements;
  final String githubRepoStructure;
  final String resumeDescription;
  final List<String> interviewQuestions;
  final List<String> possibleImprovements;
  final List<String> advancedVersionIdeas;
  final String sourceCodeUrl;
  final String githubUrl;
  final String learningOutcome;
  final List<String> keyFeatures;
  final String architectureNotes;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    this.estimatedDuration = '2 Weeks',
    this.problemStatement = '',
    this.realWorldUseCase = '',
    this.targetUsers = '',
    this.prerequisites = const [],
    this.requiredSkills = const [],
    required this.technologies,
    this.whyTheseTechnologies = '',
    this.systemArchitecture = '',
    this.majorModules = const [],
    this.databaseDesign = '',
    this.apiRequirements = '',
    this.folderStructure = '',
    this.developmentPhases = const [],
    this.implementationRoadmap = const [],
    this.testingStrategy = '',
    this.securityConsiderations = '',
    this.deploymentStrategy = '',
    this.documentationRequirements = '',
    this.githubRepoStructure = '',
    this.resumeDescription = '',
    this.interviewQuestions = const [],
    this.possibleImprovements = const [],
    this.advancedVersionIdeas = const [],
    required this.sourceCodeUrl,
    required this.githubUrl,
    required this.learningOutcome,
    this.keyFeatures = const [],
    this.architectureNotes = '',
  });

  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ProjectModel.fromJson({'id': doc.id, ...data});
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'General',
      difficulty: json['difficulty'] ?? 'Beginner',
      estimatedDuration: json['estimatedDuration'] ?? '2 Weeks',
      problemStatement: json['problemStatement'] ?? json['description'] ?? '',
      realWorldUseCase: json['realWorldUseCase'] ?? '',
      targetUsers: json['targetUsers'] ?? '',
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
      requiredSkills: List<String>.from(json['requiredSkills'] ?? []),
      technologies: List<String>.from(json['technologies'] ?? []),
      whyTheseTechnologies: json['whyTheseTechnologies'] ?? '',
      systemArchitecture:
          json['systemArchitecture'] ?? json['architectureNotes'] ?? '',
      majorModules:
          List<String>.from(json['majorModules'] ?? json['keyFeatures'] ?? []),
      databaseDesign: json['databaseDesign'] ?? '',
      apiRequirements: json['apiRequirements'] ?? '',
      folderStructure: json['folderStructure'] ?? '',
      developmentPhases: List<String>.from(json['developmentPhases'] ?? []),
      implementationRoadmap:
          List<String>.from(json['implementationRoadmap'] ?? []),
      testingStrategy: json['testingStrategy'] ?? '',
      securityConsiderations: json['securityConsiderations'] ?? '',
      deploymentStrategy: json['deploymentStrategy'] ?? '',
      documentationRequirements: json['documentationRequirements'] ?? '',
      githubRepoStructure: json['githubRepoStructure'] ?? '',
      resumeDescription: json['resumeDescription'] ?? '',
      interviewQuestions: List<String>.from(json['interviewQuestions'] ?? []),
      possibleImprovements:
          List<String>.from(json['possibleImprovements'] ?? []),
      advancedVersionIdeas:
          List<String>.from(json['advancedVersionIdeas'] ?? []),
      sourceCodeUrl: json['sourceCodeUrl'] ?? '',
      githubUrl: json['githubUrl'] ?? '',
      learningOutcome: json['learningOutcome'] ?? '',
      keyFeatures: List<String>.from(json['keyFeatures'] ?? []),
      architectureNotes: json['architectureNotes'] ?? '',
    );
  }

  List<String> get techStack => technologies;
  String get readmeRequirements => documentationRequirements;
  bool get isSaved => false;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'estimatedDuration': estimatedDuration,
      'problemStatement': problemStatement,
      'realWorldUseCase': realWorldUseCase,
      'targetUsers': targetUsers,
      'prerequisites': prerequisites,
      'requiredSkills': requiredSkills,
      'technologies': technologies,
      'whyTheseTechnologies': whyTheseTechnologies,
      'systemArchitecture': systemArchitecture,
      'majorModules': majorModules,
      'databaseDesign': databaseDesign,
      'apiRequirements': apiRequirements,
      'folderStructure': folderStructure,
      'developmentPhases': developmentPhases,
      'implementationRoadmap': implementationRoadmap,
      'testingStrategy': testingStrategy,
      'securityConsiderations': securityConsiderations,
      'deploymentStrategy': deploymentStrategy,
      'documentationRequirements': documentationRequirements,
      'githubRepoStructure': githubRepoStructure,
      'resumeDescription': resumeDescription,
      'interviewQuestions': interviewQuestions,
      'possibleImprovements': possibleImprovements,
      'advancedVersionIdeas': advancedVersionIdeas,
      'sourceCodeUrl': sourceCodeUrl,
      'githubUrl': githubUrl,
      'learningOutcome': learningOutcome,
      'keyFeatures': keyFeatures,
      'architectureNotes': architectureNotes,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'beyond_academics_model.dart';

class CareerModel {
  final String id;
  final String name;
  final String category;
  final String icon;
  final String introduction;
  final String whyLearn;
  final List<String> careerOpportunities;
  final List<String> requiredSkills;
  final List<String> learningRoadmap;
  final List<LearningPhaseModel> learningPhases;
  final List<SkillMatrixModel> skillMatrix;
  final List<String> portfolioRequirements;
  final List<String> resumeRequirements;
  final List<String> interviewPrepTopics;
  final List<String> entryLevelResponsibilities;
  final List<CareerResourceLink> bestFreeResources;
  final List<CareerResourceLink> books;
  final List<CareerResourceLink> certifications;
  final List<CareerResourceLink> youtubePlaylists;
  final List<CareerProjectInfo> miniProjects;
  final List<CareerProjectInfo> advancedProjects;
  final List<CareerResourceLink> githubRepos;
  final List<CareerSubModule> subModules;
  final String futureScope;

  const CareerModel({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    required this.introduction,
    required this.whyLearn,
    required this.careerOpportunities,
    required this.requiredSkills,
    required this.learningRoadmap,
    this.learningPhases = const [],
    this.skillMatrix = const [],
    this.portfolioRequirements = const [],
    this.resumeRequirements = const [],
    this.interviewPrepTopics = const [],
    this.entryLevelResponsibilities = const [],
    required this.bestFreeResources,
    required this.books,
    required this.certifications,
    required this.youtubePlaylists,
    required this.miniProjects,
    required this.advancedProjects,
    required this.githubRepos,
    this.subModules = const [],
    required this.futureScope,
  });

  factory CareerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return CareerModel.fromJson({'id': doc.id, ...data});
  }

  factory CareerModel.fromJson(Map<String, dynamic> json) {
    return CareerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? 'Technology',
      icon: json['icon'] ?? 'tech_default',
      introduction: json['introduction'] ?? '',
      whyLearn: json['whyLearn'] ?? '',
      careerOpportunities: List<String>.from(json['careerOpportunities'] ?? []),
      requiredSkills: List<String>.from(json['requiredSkills'] ?? []),
      learningRoadmap: List<String>.from(json['learningRoadmap'] ?? []),
      learningPhases: (json['learningPhases'] as List<dynamic>?)
              ?.map((e) => LearningPhaseModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      skillMatrix: (json['skillMatrix'] as List<dynamic>?)
              ?.map((e) => SkillMatrixModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      portfolioRequirements: List<String>.from(json['portfolioRequirements'] ?? []),
      resumeRequirements: List<String>.from(json['resumeRequirements'] ?? []),
      interviewPrepTopics: List<String>.from(json['interviewPrepTopics'] ?? []),
      entryLevelResponsibilities: List<String>.from(json['entryLevelResponsibilities'] ?? []),
      bestFreeResources: (json['bestFreeResources'] as List<dynamic>?)
              ?.map((e) => CareerResourceLink.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      books: (json['books'] as List<dynamic>?)
              ?.map((e) => CareerResourceLink.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => CareerResourceLink.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      youtubePlaylists: (json['youtubePlaylists'] as List<dynamic>?)
              ?.map((e) => CareerResourceLink.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      miniProjects: (json['miniProjects'] as List<dynamic>?)
              ?.map((e) => CareerProjectInfo.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      advancedProjects: (json['advancedProjects'] as List<dynamic>?)
              ?.map((e) => CareerProjectInfo.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      githubRepos: (json['githubRepos'] as List<dynamic>?)
              ?.map((e) => CareerResourceLink.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      subModules: (json['subModules'] as List<dynamic>?)
              ?.map((e) => CareerSubModule.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      futureScope: json['futureScope'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'icon': icon,
      'introduction': introduction,
      'whyLearn': whyLearn,
      'careerOpportunities': careerOpportunities,
      'requiredSkills': requiredSkills,
      'learningRoadmap': learningRoadmap,
      'learningPhases': learningPhases.map((e) => e.toJson()).toList(),
      'skillMatrix': skillMatrix.map((e) => e.toJson()).toList(),
      'portfolioRequirements': portfolioRequirements,
      'resumeRequirements': resumeRequirements,
      'interviewPrepTopics': interviewPrepTopics,
      'entryLevelResponsibilities': entryLevelResponsibilities,
      'bestFreeResources': bestFreeResources.map((e) => e.toJson()).toList(),
      'books': books.map((e) => e.toJson()).toList(),
      'certifications': certifications.map((e) => e.toJson()).toList(),
      'youtubePlaylists': youtubePlaylists.map((e) => e.toJson()).toList(),
      'miniProjects': miniProjects.map((e) => e.toJson()).toList(),
      'advancedProjects': advancedProjects.map((e) => e.toJson()).toList(),
      'githubRepos': githubRepos.map((e) => e.toJson()).toList(),
      'subModules': subModules.map((e) => e.toJson()).toList(),
      'futureScope': futureScope,
    };
  }
}

class CareerResourceLink {
  final String title;
  final String url;
  final String platform;
  final String type; // e.g., 'Video', 'Book', 'Certification', 'Article'

  const CareerResourceLink({
    required this.title,
    required this.url,
    required this.platform,
    this.type = 'Resource',
  });

  factory CareerResourceLink.fromJson(Map<String, dynamic> json) {
    return CareerResourceLink(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      platform: json['platform'] ?? '',
      type: json['type'] ?? 'Resource',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'url': url,
        'platform': platform,
        'type': type,
      };
}

class CareerProjectInfo {
  final String title;
  final String description;
  final String difficulty;
  final String url;

  const CareerProjectInfo({
    required this.title,
    required this.description,
    required this.difficulty,
    this.url = '',
  });

  factory CareerProjectInfo.fromJson(Map<String, dynamic> json) {
    return CareerProjectInfo(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      difficulty: json['difficulty'] ?? 'Beginner',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'difficulty': difficulty,
        'url': url,
      };
}

class CareerSubModule {
  final String title;
  final String description;
  final List<String> topics;
  final List<CareerResourceLink> links;

  const CareerSubModule({
    required this.title,
    required this.description,
    required this.topics,
    required this.links,
  });

  factory CareerSubModule.fromJson(Map<String, dynamic> json) {
    return CareerSubModule(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      topics: List<String>.from(json['topics'] ?? []),
      links: (json['links'] as List<dynamic>?)
              ?.map((e) => CareerResourceLink.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'topics': topics,
        'links': links.map((e) => e.toJson()).toList(),
      };
}


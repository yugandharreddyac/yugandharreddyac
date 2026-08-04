import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String category; // Mini, Major, AI, Flutter, Web Development, Python, Java
  final String difficulty; // Beginner, Intermediate, Advanced
  final List<String> technologies;
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
    required this.technologies,
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
      technologies: List<String>.from(json['technologies'] ?? []),
      sourceCodeUrl: json['sourceCodeUrl'] ?? '',
      githubUrl: json['githubUrl'] ?? '',
      learningOutcome: json['learningOutcome'] ?? '',
      keyFeatures: List<String>.from(json['keyFeatures'] ?? []),
      architectureNotes: json['architectureNotes'] ?? '',
    );
  }

  List<String> get techStack => technologies;
  bool get isSaved => false;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'technologies': technologies,
      'sourceCodeUrl': sourceCodeUrl,
      'githubUrl': githubUrl,
      'learningOutcome': learningOutcome,
      'keyFeatures': keyFeatures,
      'architectureNotes': architectureNotes,
    };
  }
}

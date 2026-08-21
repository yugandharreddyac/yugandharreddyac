import 'package:cloud_firestore/cloud_firestore.dart';

class PlacementModel {
  final String id;
  final String
      category; // Aptitude, Logical Reasoning, Verbal Ability, Technical Interview, HR Interview, Resume Guide, LinkedIn Guide, Company Prep, Roadmaps
  final String title;
  final String description;
  final List<PlacementQuestionAnswer> questionsAndAnswers;
  final List<String> tips;
  final List<String> resourceUrls;
  final String roadmap;

  const PlacementModel({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.questionsAndAnswers,
    required this.tips,
    required this.resourceUrls,
    required this.roadmap,
  });

  factory PlacementModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return PlacementModel.fromJson({'id': doc.id, ...data});
  }

  factory PlacementModel.fromJson(Map<String, dynamic> json) {
    return PlacementModel(
      id: json['id'] ?? '',
      category: json['category'] ?? 'General',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      questionsAndAnswers: (json['questionsAndAnswers'] as List<dynamic>?)
              ?.map((e) => PlacementQuestionAnswer.fromJson(
                  Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      tips: List<String>.from(json['tips'] ?? []),
      resourceUrls: List<String>.from(json['resourceUrls'] ?? []),
      roadmap: json['roadmap'] ?? '',
    );
  }

  String get resourceLink => resourceUrls.isNotEmpty
      ? resourceUrls.first
      : 'https://practice.geeksforgeeks.org/aptitude';
  bool get isSaved => false;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'description': description,
      'questionsAndAnswers':
          questionsAndAnswers.map((e) => e.toJson()).toList(),
      'tips': tips,
      'resourceUrls': resourceUrls,
      'roadmap': roadmap,
    };
  }
}

class PlacementQuestionAnswer {
  final String question;
  final String answer;
  final String category; // Technical, HR, Aptitude, Puzzles
  final List<String> keyPoints;

  const PlacementQuestionAnswer({
    required this.question,
    required this.answer,
    this.category = 'General',
    this.keyPoints = const [],
  });

  factory PlacementQuestionAnswer.fromJson(Map<String, dynamic> json) {
    return PlacementQuestionAnswer(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      category: json['category'] ?? 'General',
      keyPoints: List<String>.from(json['keyPoints'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'question': question,
        'answer': answer,
        'category': category,
        'keyPoints': keyPoints,
      };
}

import 'package:flutter/material.dart';

enum QuizMode {
  practice,
  mockTest,
  topicPractice,
}

enum QuizDifficulty {
  beginner,
  intermediate,
  advanced,
}

class QuizQuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String category; // 'Quantitative Aptitude', 'Logical Reasoning', 'Technical MCQs'
  final String topic; // e.g. 'Percentages', 'Blood Relations', 'Data Structures'
  final QuizDifficulty difficulty;
  final int timeLimitSeconds;

  const QuizQuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.category,
    required this.topic,
    this.difficulty = QuizDifficulty.intermediate,
    this.timeLimitSeconds = 60,
  });

  bool isCorrect(int selectedIndex) => selectedIndex == correctOptionIndex;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
      'category': category,
      'topic': topic,
      'difficulty': difficulty.name,
      'timeLimitSeconds': timeLimitSeconds,
    };
  }

  factory QuizQuestionModel.fromMap(Map<String, dynamic> map, String docId) {
    return QuizQuestionModel(
      id: docId,
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctOptionIndex: map['correctOptionIndex'] ?? 0,
      explanation: map['explanation'] ?? '',
      category: map['category'] ?? 'Technical MCQs',
      topic: map['topic'] ?? 'General',
      difficulty: QuizDifficulty.values.firstWhere(
        (e) => e.name == map['difficulty'],
        orElse: () => QuizDifficulty.intermediate,
      ),
      timeLimitSeconds: map['timeLimitSeconds'] ?? 60,
    );
  }
}

class QuizCategoryInfo {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final List<String> subTopics;

  const QuizCategoryInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.subTopics,
  });
}

class QuizResultModel {
  final String quizTitle;
  final String category;
  final QuizMode mode;
  final int totalQuestions;
  final int correctCount;
  final int incorrectCount;
  final int unansweredCount;
  final int totalTimeTakenSeconds;
  final Map<String, int> topicTotalCount;
  final Map<String, int> topicCorrectCount;
  final List<String> weakTopics;
  final List<String> recommendedNextTopics;

  const QuizResultModel({
    required this.quizTitle,
    required this.category,
    required this.mode,
    required this.totalQuestions,
    required this.correctCount,
    required this.incorrectCount,
    required this.unansweredCount,
    required this.totalTimeTakenSeconds,
    required this.topicTotalCount,
    required this.topicCorrectCount,
    required this.weakTopics,
    required this.recommendedNextTopics,
  });

  int get score => correctCount;
  double get accuracyPercentage =>
      totalQuestions > 0 ? (correctCount / totalQuestions) * 100 : 0.0;
  bool get isPassed => accuracyPercentage >= 60.0;
}

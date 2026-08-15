import '../models/quiz_model.dart';
import '../datasources/quiz_mock_data.dart';

class PlacementQuizRepository {
  List<QuizCategoryInfo> getCategories() {
    return QuizMockData.categories;
  }

  Future<List<QuizQuestionModel>> getQuestions({
    String? category,
    String? topic,
    QuizDifficulty? difficulty,
    int? limit,
  }) async {
    var list = QuizMockData.questions;

    if (category != null && category.isNotEmpty && category != 'All') {
      list = list.where((q) => q.category.toLowerCase() == category.toLowerCase()).toList();
    }

    if (topic != null && topic.isNotEmpty && topic != 'All') {
      list = list.where((q) => q.topic.toLowerCase() == topic.toLowerCase()).toList();
    }

    if (difficulty != null) {
      list = list.where((q) => q.difficulty == difficulty).toList();
    }

    if (limit != null && limit > 0 && list.length > limit) {
      return list.take(limit).toList();
    }

    return list;
  }

  QuizResultModel evaluateQuiz({
    required String quizTitle,
    required String category,
    required QuizMode mode,
    required List<QuizQuestionModel> questions,
    required Map<int, int?> userAnswers, // questionIndex -> selectedOptionIndex
    required int timeTakenSeconds,
  }) {
    int correct = 0;
    int incorrect = 0;
    int unanswered = 0;

    final Map<String, int> topicTotal = {};
    final Map<String, int> topicCorrect = {};

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final selected = userAnswers[i];

      topicTotal[q.topic] = (topicTotal[q.topic] ?? 0) + 1;

      if (selected == null) {
        unanswered++;
      } else if (q.isCorrect(selected)) {
        correct++;
        topicCorrect[q.topic] = (topicCorrect[q.topic] ?? 0) + 1;
      } else {
        incorrect++;
      }
    }

    // Identify weak topics (accuracy < 60%)
    final List<String> weakTopics = [];
    final List<String> recommendedNext = [];

    topicTotal.forEach((topic, total) {
      final cor = topicCorrect[topic] ?? 0;
      final acc = (cor / total) * 100;
      if (acc < 60.0) {
        weakTopics.add(topic);
        recommendedNext.add('Practice $topic → Core Concepts & Problem Sets');
      }
    });

    if (weakTopics.isEmpty && questions.isNotEmpty) {
      recommendedNext.add('Excellent Performance! Advance to High-Difficulty Timed Mock Tests');
    }

    return QuizResultModel(
      quizTitle: quizTitle,
      category: category,
      mode: mode,
      totalQuestions: questions.length,
      correctCount: correct,
      incorrectCount: incorrect,
      unansweredCount: unanswered,
      totalTimeTakenSeconds: timeTakenSeconds,
      topicTotalCount: topicTotal,
      topicCorrectCount: topicCorrect,
      weakTopics: weakTopics,
      recommendedNextTopics: recommendedNext,
    );
  }
}

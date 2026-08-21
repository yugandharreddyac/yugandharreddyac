import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/models/quiz_model.dart';
import 'package:csse_study_hub/data/datasources/quiz_mock_data.dart';
import 'package:csse_study_hub/data/repositories/placement_quiz_repository.dart';
import 'package:csse_study_hub/presentation/providers/quiz_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Placement Quiz Engine — Repository & Datasource Tests', () {
    late PlacementQuizRepository repository;

    setUp(() {
      repository = PlacementQuizRepository();
    });

    test(
        'getCategories returns 3 primary placement tracks with valid subtopics',
        () {
      final categories = repository.getCategories();
      expect(categories.length, equals(3));
      expect(categories.any((c) => c.title == 'Quantitative Aptitude'), isTrue);
      expect(categories.any((c) => c.title == 'Logical Reasoning'), isTrue);
      expect(categories.any((c) => c.title == 'Technical MCQs'), isTrue);

      for (final cat in categories) {
        expect(cat.subTopics.isNotEmpty, isTrue);
      }
    });

    test('getQuestions filters by category correctly', () async {
      final aptQuestions =
          await repository.getQuestions(category: 'Quantitative Aptitude');
      expect(aptQuestions.isNotEmpty, isTrue);
      expect(aptQuestions.every((q) => q.category == 'Quantitative Aptitude'),
          isTrue);

      final techQuestions =
          await repository.getQuestions(category: 'Technical MCQs');
      expect(techQuestions.isNotEmpty, isTrue);
      expect(
          techQuestions.every((q) => q.category == 'Technical MCQs'), isTrue);
    });

    test('getQuestions filters by topic correctly', () async {
      final percentageQuestions =
          await repository.getQuestions(topic: 'Percentages');
      expect(percentageQuestions.isNotEmpty, isTrue);
      expect(
          percentageQuestions.every((q) => q.topic == 'Percentages'), isTrue);
    });

    test('getQuestions respects limit parameter', () async {
      final limited = await repository.getQuestions(limit: 3);
      expect(limited.length, equals(3));
    });

    test(
        'evaluateQuiz computes accurate scores, accuracy, and weak area recommendations',
        () {
      final testQuestions = [
        const QuizQuestionModel(
          id: 'q1',
          question: 'Q1',
          options: ['A', 'B', 'C', 'D'],
          correctOptionIndex: 0,
          explanation: 'Exp 1',
          category: 'Quantitative Aptitude',
          topic: 'Percentages',
        ),
        const QuizQuestionModel(
          id: 'q2',
          question: 'Q2',
          options: ['A', 'B', 'C', 'D'],
          correctOptionIndex: 1,
          explanation: 'Exp 2',
          category: 'Quantitative Aptitude',
          topic: 'Percentages',
        ),
        const QuizQuestionModel(
          id: 'q3',
          question: 'Q3',
          options: ['A', 'B', 'C', 'D'],
          correctOptionIndex: 2,
          explanation: 'Exp 3',
          category: 'Quantitative Aptitude',
          topic: 'Time & Work',
        ),
      ];

      // User answers: q1 correct (0), q2 wrong (2), q3 unanswered (null)
      final userAnswers = {
        0: 0,
        1: 2,
      };

      final result = repository.evaluateQuiz(
        quizTitle: 'Test Aptitude',
        category: 'Quantitative Aptitude',
        mode: QuizMode.mockTest,
        questions: testQuestions,
        userAnswers: userAnswers,
        timeTakenSeconds: 90,
      );

      expect(result.totalQuestions, equals(3));
      expect(result.correctCount, equals(1));
      expect(result.incorrectCount, equals(1));
      expect(result.unansweredCount, equals(1));
      expect(result.score, equals(1));
      expect(result.accuracyPercentage, closeTo(33.33, 0.1));
      expect(result.isPassed, isFalse);
      expect(result.weakTopics, contains('Percentages'));
      expect(result.weakTopics, contains('Time & Work'));
      expect(result.recommendedNextTopics.isNotEmpty, isTrue);
    });
  });

  group('Placement Quiz Engine — Provider State Management Tests', () {
    late QuizProvider provider;
    late PlacementQuizRepository repository;

    setUp(() {
      repository = PlacementQuizRepository();
      provider = QuizProvider(repository: repository);
    });

    test('init populates categories', () {
      provider.init();
      expect(provider.categories.length, equals(3));
    });

    test('startQuiz loads questions and resets session state', () async {
      await provider.startQuiz(
        category: 'Technical MCQs',
        mode: QuizMode.practice,
      );

      expect(provider.isLoading, isFalse);
      expect(provider.currentQuestions.isNotEmpty, isTrue);
      expect(provider.currentQuestionIndex, equals(0));
      expect(provider.currentQuestion, isNotNull);
      expect(provider.userAnswers.isEmpty, isTrue);
      expect(provider.markedForReview.isEmpty, isTrue);
    });

    test(
        'selectOption records answer and toggleMarkForReview modifies review set',
        () async {
      await provider.startQuiz(
        category: 'Technical MCQs',
        mode: QuizMode.practice,
      );

      provider.selectOption(2);
      expect(provider.currentSelectedOption, equals(2));
      expect(provider.userAnswers[0], equals(2));

      expect(provider.isCurrentMarkedForReview, isFalse);
      provider.toggleMarkForReview();
      expect(provider.isCurrentMarkedForReview, isTrue);
      provider.toggleMarkForReview();
      expect(provider.isCurrentMarkedForReview, isFalse);
    });

    test('Navigation methods move through questions appropriately', () async {
      await provider.startQuiz(
        category: 'Technical MCQs',
        mode: QuizMode.practice,
      );

      expect(provider.currentQuestionIndex, equals(0));
      provider.nextQuestion();
      expect(provider.currentQuestionIndex, equals(1));
      provider.previousQuestion();
      expect(provider.currentQuestionIndex, equals(0));

      provider.jumpToQuestion(3);
      expect(provider.currentQuestionIndex, equals(3));
    });

    test('submitQuiz generates valid QuizResultModel and resets timer',
        () async {
      await provider.startQuiz(
        category: 'Technical MCQs',
        mode: QuizMode.mockTest,
      );

      provider.selectOption(provider.currentQuestion!.correctOptionIndex);
      final result = provider.submitQuiz();

      expect(result, isNotNull);
      expect(result.totalQuestions, equals(provider.currentQuestions.length));
      expect(result.correctCount, greaterThanOrEqualTo(1));
      expect(provider.isTimerActive, isFalse);
    });
  });
}

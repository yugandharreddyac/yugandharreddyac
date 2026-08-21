import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/quiz_model.dart';
import '../../data/repositories/placement_quiz_repository.dart';

class QuizProvider extends ChangeNotifier {
  final PlacementQuizRepository _repository;

  QuizProvider({PlacementQuizRepository? repository})
      : _repository = repository ?? PlacementQuizRepository();

  List<QuizCategoryInfo> _categories = [];
  List<QuizQuestionModel> _currentQuestions = [];
  int _currentQuestionIndex = 0;
  final Map<int, int?> _userAnswers = {}; // questionIndex -> selectedOption
  final Set<int> _markedForReview = {};
  QuizMode _currentMode = QuizMode.practice;
  QuizResultModel? _lastResult;
  bool _isLoading = false;
  String _activeCategory = 'All';

  // Timer properties
  Timer? _timer;
  int _remainingSeconds = 0;
  int _elapsedSeconds = 0;
  bool _isTimerActive = false;

  // Getters
  List<QuizCategoryInfo> get categories => _categories;
  List<QuizQuestionModel> get currentQuestions => _currentQuestions;
  int get currentQuestionIndex => _currentQuestionIndex;
  QuizQuestionModel? get currentQuestion => _currentQuestions.isNotEmpty &&
          _currentQuestionIndex < _currentQuestions.length
      ? _currentQuestions[_currentQuestionIndex]
      : null;
  Map<int, int?> get userAnswers => _userAnswers;
  Set<int> get markedForReview => _markedForReview;
  QuizMode get currentMode => _currentMode;
  QuizResultModel? get lastResult => _lastResult;
  bool get isLoading => _isLoading;
  String get activeCategory => _activeCategory;
  int get remainingSeconds => _remainingSeconds;
  int get elapsedSeconds => _elapsedSeconds;
  bool get isTimerActive => _isTimerActive;
  bool get isCurrentMarkedForReview =>
      _markedForReview.contains(_currentQuestionIndex);
  int? get currentSelectedOption => _userAnswers[_currentQuestionIndex];

  void init() {
    _categories = _repository.getCategories();
    notifyListeners();
  }

  Future<void> startQuiz({
    required String category,
    required QuizMode mode,
    String? topic,
    QuizDifficulty? difficulty,
    int? questionCount,
  }) async {
    _isLoading = true;
    _activeCategory = category;
    _currentMode = mode;
    _currentQuestionIndex = 0;
    _userAnswers.clear();
    _markedForReview.clear();
    _lastResult = null;
    _elapsedSeconds = 0;
    _stopTimer();
    notifyListeners();

    try {
      _currentQuestions = await _repository.getQuestions(
        category: category == 'All' ? null : category,
        topic: topic == 'All' ? null : topic,
        difficulty: difficulty,
        limit: questionCount ?? (mode == QuizMode.mockTest ? 15 : 10),
      );

      if (_currentQuestions.isEmpty) {
        _currentQuestions = await _repository.getQuestions(limit: 10);
      }

      if (mode == QuizMode.mockTest) {
        // Standard 60 seconds per question in mock test
        _remainingSeconds = _currentQuestions.length * 60;
        _startTimer();
      }
    } catch (e) {
      debugPrint('Error starting quiz: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectOption(int optionIndex) {
    _userAnswers[_currentQuestionIndex] = optionIndex;
    notifyListeners();
  }

  void toggleMarkForReview() {
    if (_markedForReview.contains(_currentQuestionIndex)) {
      _markedForReview.remove(_currentQuestionIndex);
    } else {
      _markedForReview.add(_currentQuestionIndex);
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _currentQuestions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void jumpToQuestion(int index) {
    if (index >= 0 && index < _currentQuestions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  QuizResultModel submitQuiz() {
    _stopTimer();

    _lastResult = _repository.evaluateQuiz(
      quizTitle: '$_activeCategory Assessment',
      category: _activeCategory,
      mode: _currentMode,
      questions: _currentQuestions,
      userAnswers: _userAnswers,
      timeTakenSeconds: _elapsedSeconds > 0 ? _elapsedSeconds : 1,
    );

    notifyListeners();
    return _lastResult!;
  }

  void resetQuiz() {
    _stopTimer();
    _currentQuestions = [];
    _currentQuestionIndex = 0;
    _userAnswers.clear();
    _markedForReview.clear();
    _lastResult = null;
    notifyListeners();
  }

  void _startTimer() {
    _isTimerActive = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _stopTimer();
        submitQuiz();
      }
    });
  }

  void _stopTimer() {
    _isTimerActive = false;
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

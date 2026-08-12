import 'package:flutter/material.dart';
import '../../data/models/user_goal_model.dart';
import '../../data/repositories/roadmap_repository.dart';

class DailyTaskModel {
  final String topicId;
  final String topicTitle;
  final String actionTitle;
  final ActivityType type;
  final String categoryTitle;
  final int estimatedMinutes;

  const DailyTaskModel({
    required this.topicId,
    required this.topicTitle,
    required this.actionTitle,
    required this.type,
    required this.categoryTitle,
    this.estimatedMinutes = 25,
  });
}

class StudentInsightsModel {
  final double overallPercentage;
  final int completedTopicsCount;
  final int inProgressTopicsCount;
  final int notStartedTopicsCount;
  final double foundationPercentage;
  final double corePercentage;
  final double buildPercentage;
  final double careerPercentage;

  const StudentInsightsModel({
    required this.overallPercentage,
    required this.completedTopicsCount,
    required this.inProgressTopicsCount,
    required this.notStartedTopicsCount,
    required this.foundationPercentage,
    required this.corePercentage,
    required this.buildPercentage,
    required this.careerPercentage,
  });
}

class RoadmapProvider extends ChangeNotifier {
  final RoadmapRepository _repository = RoadmapRepository();

  UserGoalProfile? _profile;
  Map<String, TopicProgressModel> _progressMap = {};
  String? _lastOpenedTopicId;
  List<String> _recentTopicIds = [];
  List<String> _bookmarkedTopicIds = [];
  bool _isLoading = true;

  UserGoalProfile? get profile => _profile;
  bool get hasProfile => _profile != null;
  bool get isLoading => _isLoading;
  Map<String, TopicProgressModel> get progressMap => _progressMap;
  String? get lastOpenedTopicId => _lastOpenedTopicId;
  List<String> get recentTopicIds => List.unmodifiable(_recentTopicIds);
  List<String> get bookmarkedTopicIds => List.unmodifiable(_bookmarkedTopicIds);

  RoadmapProvider() {
    _init();
  }

  Future<void> _init() async {
    _profile = await _repository.loadGoalProfile();
    _progressMap = await _repository.loadTopicProgressMap();
    _lastOpenedTopicId = await _repository.loadLastOpenedTopicId();
    _recentTopicIds = await _repository.loadRecentTopicIds();
    _bookmarkedTopicIds = await _repository.loadBookmarkedTopicIds();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setGoalProfile(UserGoalProfile profile) async {
    _profile = profile;
    await _repository.saveGoalProfile(profile);
    notifyListeners();
  }

  Future<void> recordTopicOpened(String topicId) async {
    _lastOpenedTopicId = topicId;

    // Deduplicate and insert at start
    _recentTopicIds.remove(topicId);
    _recentTopicIds.insert(0, topicId);
    if (_recentTopicIds.length > 10) {
      _recentTopicIds = _recentTopicIds.sublist(0, 10);
    }

    notifyListeners();
    await _repository.saveLastOpenedTopicId(topicId);
    await _repository.saveRecentTopicIds(_recentTopicIds);
  }

  bool isTopicBookmarked(String topicId) {
    return _bookmarkedTopicIds.contains(topicId);
  }

  Future<void> toggleTopicBookmark(String topicId) async {
    if (_bookmarkedTopicIds.contains(topicId)) {
      _bookmarkedTopicIds.remove(topicId);
    } else {
      _bookmarkedTopicIds.insert(0, topicId);
    }
    notifyListeners();
    await _repository.saveBookmarkedTopicIds(_bookmarkedTopicIds);
  }

  TopicProgressModel getProgressForTopic(String topicId) {
    return _progressMap[topicId] ?? TopicProgressModel(topicId: topicId);
  }

  Future<void> toggleActivity({
    required String topicId,
    required ActivityType type,
  }) async {
    final current = getProgressForTopic(topicId);
    TopicProgressModel updated;

    switch (type) {
      case ActivityType.learn:
        updated = current.copyWith(learnCompleted: !current.learnCompleted);
        break;
      case ActivityType.practice:
        updated = current.copyWith(practiceCompleted: !current.practiceCompleted);
        break;
      case ActivityType.build:
        updated = current.copyWith(buildCompleted: !current.buildCompleted);
        break;
      case ActivityType.review:
        updated = current.copyWith(reviewCompleted: !current.reviewCompleted);
        break;
    }

    _progressMap[topicId] = updated;
    notifyListeners();
    await _repository.saveTopicProgress(updated);
  }

  List<RoadmapStageModel> getRoadmapStages() {
    final goal = _profile?.goal ?? CareerGoal.softwarePlacement;

    List<RoadmapStageModel> stages = [];

    // Stage 1: Foundation & Core Programming
    stages.add(const RoadmapStageModel(
      stageTitle: 'FOUNDATION: Programming & Logic',
      stageDescription: 'Build strong syntax, problem-solving skills, and logic with Python, C++, or Java.',
      topicIds: ['basics_intro', 'python_basics', 'python_variables', 'c_pointers', 'cpp_stl'],
    ));

    // Stage 2: Core Computer Science & DSA
    stages.add(const RoadmapStageModel(
      stageTitle: 'CORE: Data Structures & Algorithms',
      stageDescription: 'Master 23 DSA topics from Big-O complexity to Dynamic Programming & Graphs.',
      topicIds: [
        'dsa_complexity',
        'dsa_arrays',
        'dsa_linked_list',
        'dsa_stacks_queues',
        'dsa_trees',
        'dsa_graphs',
        'dsa_dp'
      ],
    ));

    // Stage 3: Development & Domain Focus
    if (goal == CareerGoal.entrepreneurship) {
      stages.add(const RoadmapStageModel(
        stageTitle: 'BUILD: Lean MVP & Customer Discovery',
        stageDescription: 'Uncover customer pain points, build rapid MVPs, and validate business ideas.',
        topicIds: ['problem_discovery', 'mvp_development', 'pitch_decks'],
      ));
    } else if (goal == CareerGoal.gateExam || goal == CareerGoal.msHigherStudies) {
      stages.add(const RoadmapStageModel(
        stageTitle: 'SPECIALIZE: Core CS & Entrance Preparation',
        stageDescription: 'Prepare for GATE CS, GRE General, SOP/LOR drafting, and university selection.',
        topicIds: ['exam_gate', 'exam_gre', 'masters_degree', 'choosing_country', 'govt_scholarships'],
      ));
    } else {
      stages.add(const RoadmapStageModel(
        stageTitle: 'BUILD: Fullstack Web, App & Projects',
        stageDescription: 'Construct production-ready web and mobile apps with React, Flutter & Node.js.',
        topicIds: ['web_html_css', 'web_react', 'web_backend_node', 'flutter_basics', 'todo_list_proj', 'house_price_proj'],
      ));
    }

    // Stage 4: Placement & Career Execution
    if (goal == CareerGoal.entrepreneurship) {
      stages.add(const RoadmapStageModel(
        stageTitle: 'LAUNCH: Business Model & Pitch Deck',
        stageDescription: 'Formulate revenue models, Sequoia pitch decks, and YC incubator applications.',
        topicIds: ['pitch_decks', 'mvp_development'],
      ));
    } else if (goal == CareerGoal.gateExam) {
      stages.add(const RoadmapStageModel(
        stageTitle: 'ACHIEVE: GATE CS Master Mock Practice',
        stageDescription: 'Solve previous year GATE question papers and formula review sheets.',
        topicIds: ['exam_gate'],
      ));
    } else {
      stages.add(const RoadmapStageModel(
        stageTitle: 'CAREER: Placements, Aptitude & HR Preparation',
        stageDescription: 'Conquer Striver A2Z sheet, LeetCode 75, Quant Aptitude, and STAR HR interviews.',
        topicIds: ['placement_dsa', 'quant_aptitude', 'hr_questions', 'resume_building', 'technical_interviews'],
      ));
    }

    return stages;
  }

  double calculateOverallProgress() {
    final stages = getRoadmapStages();
    int totalActivities = 0;
    int completedActivities = 0;

    for (final stage in stages) {
      for (final topicId in stage.topicIds) {
        final progress = getProgressForTopic(topicId);
        totalActivities += progress.totalActivities;
        completedActivities += progress.completedCount;
      }
    }

    if (totalActivities == 0) return 0.0;
    return (completedActivities / totalActivities) * 100.0;
  }



  StudentInsightsModel getStudentInsights() {
    final stages = getRoadmapStages();
    int completedCount = 0;
    int inProgressCount = 0;
    int notStartedCount = 0;

    List<double> stagePercentages = [];

    for (final stage in stages) {
      int stageTotal = 0;
      int stageCompleted = 0;

      for (final topicId in stage.topicIds) {
        final progress = getProgressForTopic(topicId);
        stageTotal += progress.totalActivities;
        stageCompleted += progress.completedCount;

        if (progress.isFullyCompleted) {
          completedCount++;
        } else if (progress.isInProgress) {
          inProgressCount++;
        } else {
          notStartedCount++;
        }
      }

      final p = stageTotal == 0 ? 0.0 : (stageCompleted / stageTotal) * 100.0;
      stagePercentages.add(p);
    }

    final foundationP = stagePercentages.isNotEmpty ? stagePercentages[0] : 0.0;
    final coreP = stagePercentages.length > 1 ? stagePercentages[1] : 0.0;
    final buildP = stagePercentages.length > 2 ? stagePercentages[2] : 0.0;
    final careerP = stagePercentages.length > 3 ? stagePercentages[3] : 0.0;

    return StudentInsightsModel(
      overallPercentage: calculateOverallProgress(),
      completedTopicsCount: completedCount,
      inProgressTopicsCount: inProgressCount,
      notStartedTopicsCount: notStartedCount,
      foundationPercentage: foundationP,
      corePercentage: coreP,
      buildPercentage: buildP,
      careerPercentage: careerP,
    );
  }

  List<DailyTaskModel> getTodaysPlan() {
    final stages = getRoadmapStages();
    List<DailyTaskModel> tasks = [];

    for (final stage in stages) {
      for (final topicId in stage.topicIds) {
        final progress = getProgressForTopic(topicId);
        if (!progress.isFullyCompleted) {
          if (!progress.learnCompleted) {
            tasks.add(DailyTaskModel(
              topicId: topicId,
              topicTitle: _formatTopicTitle(topicId),
              actionTitle: 'Read concept & documentation',
              type: ActivityType.learn,
              categoryTitle: stage.stageTitle,
              estimatedMinutes: 20,
            ));
          }
          if (!progress.practiceCompleted) {
            tasks.add(DailyTaskModel(
              topicId: topicId,
              topicTitle: _formatTopicTitle(topicId),
              actionTitle: 'Solve practice exercises on LeetCode/GFG',
              type: ActivityType.practice,
              categoryTitle: stage.stageTitle,
              estimatedMinutes: 35,
            ));
          }
          if (!progress.buildCompleted) {
            tasks.add(DailyTaskModel(
              topicId: topicId,
              topicTitle: _formatTopicTitle(topicId),
              actionTitle: 'Build mini-project / code exercise',
              type: ActivityType.build,
              categoryTitle: stage.stageTitle,
              estimatedMinutes: 30,
            ));
          }
          if (tasks.length >= 3) return tasks;
        }
      }
    }

    // Default fallback if all roadmap tasks completed
    if (tasks.isEmpty) {
      tasks.add(const DailyTaskModel(
        topicId: 'dsa_arrays',
        topicTitle: 'Arrays & Two-Pointer Pattern',
        actionTitle: 'Solve 2 LeetCode Array problems',
        type: ActivityType.practice,
        categoryTitle: 'Daily Revision',
        estimatedMinutes: 30,
      ));
    }

    return tasks;
  }

  String _formatTopicTitle(String topicId) {
    switch (topicId) {
      case 'basics_intro':
        return 'Introduction to Programming';
      case 'python_basics':
        return 'Python Syntax & Basics';
      case 'python_variables':
        return 'Variables & Data Types';
      case 'c_pointers':
        return 'Pointers & Memory';
      case 'cpp_stl':
        return 'C++ STL Containers';
      case 'dsa_complexity':
        return 'Complexity Analysis & Big-O';
      case 'dsa_arrays':
        return 'Arrays & Two-Pointer';
      case 'dsa_linked_list':
        return 'Linked Lists & Cycles';
      case 'dsa_stacks_queues':
        return 'Stacks, Queues & Deque';
      case 'dsa_trees':
        return 'Trees & BST Traversals';
      case 'dsa_graphs':
        return 'Graph BFS & DFS';
      case 'dsa_dp':
        return 'Dynamic Programming Patterns';
      case 'web_html_css':
        return 'HTML5, CSS3 & Responsive Layouts';
      case 'web_react':
        return 'React Components & State';
      case 'web_backend_node':
        return 'Node.js & Express REST APIs';
      case 'flutter_basics':
        return 'Flutter & Dart State Management';
      case 'todo_list_proj':
        return 'Build a To-Do List Application';
      case 'house_price_proj':
        return 'House Price ML Predictor Model';
      case 'placement_dsa':
        return 'Striver A2Z DSA Interview Sheet';
      case 'quant_aptitude':
        return 'Quantitative Percentages & Ratios';
      case 'hr_questions':
        return 'STAR Framework HR Interview Prep';
      case 'resume_building':
        return 'ATS Single-Page Student Resume';
      case 'technical_interviews':
        return 'Live Coding & System Design Prep';
      case 'exam_gate':
        return 'GATE CS / IT Examination Syllabus';
      case 'exam_gre':
        return 'GRE General Test Preparation';
      case 'masters_degree':
        return 'Postgraduate Degree Selection';
      case 'choosing_country':
        return 'Study Abroad Country Guide';
      case 'govt_scholarships':
        return 'National Scholarship Portal (NSP)';
      case 'problem_discovery':
        return 'Customer Validation & The Mom Test';
      case 'mvp_development':
        return 'Lean MVP & Business Model Canvas';
      case 'pitch_decks':
        return 'Sequoia 10-Slide Investor Deck';
      default:
        return topicId;
    }
  }
}

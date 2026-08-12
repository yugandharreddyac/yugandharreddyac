import 'package:flutter/material.dart';
import '../../data/models/user_goal_model.dart';
import '../../data/models/career_models.dart';
import '../../data/datasources/career_data_mapper.dart';
import '../../data/datasources/non_academic_data.dart';
import '../../data/repositories/roadmap_repository.dart';
import '../../data/models/guidance_models.dart';
import '../../data/datasources/guidance_engine.dart';

class DailyTaskModel {
  final String topicId;
  final String topicTitle;
  final String actionTitle;
  final ActivityType type;
  final String categoryTitle;
  final int estimatedMinutes;
  final String? progressText;
  final String? reason;
  final String? actionRoute;
  final dynamic actionArguments;

  const DailyTaskModel({
    required this.topicId,
    required this.topicTitle,
    required this.actionTitle,
    required this.type,
    required this.categoryTitle,
    this.estimatedMinutes = 15,
    this.progressText,
    this.reason,
    this.actionRoute,
    this.actionArguments,
  });
}

class CareerMilestoneModel {
  final String title;
  final bool isCompleted;

  const CareerMilestoneModel({
    required this.title,
    required this.isCompleted,
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
  ResumeReadinessModel _resumeChecklist = const ResumeReadinessModel();
  bool _isLoading = true;

  UserGoalProfile? get profile => _profile;
  bool get hasProfile => _profile != null;
  bool get isLoading => _isLoading;
  Map<String, TopicProgressModel> get progressMap => _progressMap;
  String? get lastOpenedTopicId => _lastOpenedTopicId;
  List<String> get recentTopicIds => List.unmodifiable(_recentTopicIds);
  List<String> get bookmarkedTopicIds => List.unmodifiable(_bookmarkedTopicIds);
  ResumeReadinessModel get resumeChecklist => _resumeChecklist;

  // Phase 6 Guidance Engine Methods
  StudentStatus get studentStatus => GuidanceEngine.determineStudentStatus(_profile, _progressMap, getRoadmapStages(), _resumeChecklist);
  RoadmapHealthModel? get roadmapHealth => _profile == null ? null : GuidanceEngine.calculateRoadmapHealth(_profile!, _progressMap, getRoadmapStages());
  NextBestActionModel? get nextBestAction => GuidanceEngine.getNextBestAction(_profile, _progressMap, getRoadmapStages(), _lastOpenedTopicId, _resumeChecklist);

  RoadmapProvider() {
    _init();
  }

  Future<void> _init() async {
    _profile = await _repository.loadGoalProfile();
    _progressMap = await _repository.loadTopicProgressMap();
    _lastOpenedTopicId = await _repository.loadLastOpenedTopicId();
    _recentTopicIds = await _repository.loadRecentTopicIds();
    _bookmarkedTopicIds = await _repository.loadBookmarkedTopicIds();
    _resumeChecklist = await _repository.loadResumeChecklist();
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
    Set<String> addedTopics = {};

    // 1. Current incomplete activity on an in-progress topic
    for (final stage in stages) {
      for (final topicId in stage.topicIds) {
        final progress = getProgressForTopic(topicId);
        if (progress.isInProgress && !progress.isFullyCompleted) {
          tasks.add(_createTaskModel(topicId, stage.stageTitle, progress, 'Continue your active session'));
          addedTopics.add(topicId);
          if (tasks.length >= 3) return tasks;
        }
      }
    }

    // 2. Career Gaps (Phase 5)
    final gaps = getCareerGaps();
    for (final gap in gaps) {
      if (!addedTopics.contains(gap.actionArguments?['topicId'] ?? gap.actionRoute)) {
        tasks.add(DailyTaskModel(
          topicId: gap.actionArguments?['topicId'] ?? 'gap_task',
          topicTitle: gap.title,
          actionTitle: gap.actionLabel,
          type: ActivityType.learn, // Default visual type
          categoryTitle: 'Career Action',
          estimatedMinutes: 20,
          reason: gap.description,
          actionRoute: gap.actionRoute,
          actionArguments: gap.actionArguments,
        ));
        addedTopics.add(gap.actionArguments?['topicId'] ?? gap.actionRoute);
        if (tasks.length >= 3) return tasks;
      }
    }

    // 3. Earliest incomplete prerequisite/roadmap topic
    for (final stage in stages) {
      for (final topicId in stage.topicIds) {
        if (addedTopics.contains(topicId)) continue;
        final progress = getProgressForTopic(topicId);
        if (!progress.isInProgress && !progress.isFullyCompleted) {
          tasks.add(_createTaskModel(topicId, stage.stageTitle, progress, 'Start the next roadmap topic'));
          addedTopics.add(topicId);
          if (tasks.length >= 3) return tasks;
        }
      }
    }

    // Default fallback
    if (tasks.isEmpty) {
      tasks.add(const DailyTaskModel(
        topicId: 'dsa_arrays',
        topicTitle: 'Arrays',
        actionTitle: 'Practice Problem Solving',
        type: ActivityType.practice,
        categoryTitle: 'Daily Revision',
        progressText: '0 / 4',
        reason: 'Daily Practice',
      ));
    }

    return tasks;
  }

  DailyTaskModel _createTaskModel(String topicId, String categoryTitle, TopicProgressModel progress, String reason) {
    String actionTitle = '';
    ActivityType type = ActivityType.learn;
    
    if (!progress.learnCompleted) {
      actionTitle = 'Read concept & documentation';
      type = ActivityType.learn;
    } else if (!progress.practiceCompleted) {
      actionTitle = 'Solve practice exercises';
      type = ActivityType.practice;
    } else if (!progress.buildCompleted) {
      actionTitle = 'Build mini-project / code exercise';
      type = ActivityType.build;
    } else if (!progress.reviewCompleted) {
      actionTitle = 'Review and summarize';
      type = ActivityType.review;
    }

    return DailyTaskModel(
      topicId: topicId,
      topicTitle: _formatTopicTitle(topicId),
      actionTitle: actionTitle,
      type: type,
      categoryTitle: categoryTitle,
      progressText: '${progress.completedCount} / ${progress.totalActivities}',
      reason: reason,
    );
  }

  String? getNextRecommendedTopicId(String currentTopicId) {
    final stages = getRoadmapStages();
    bool foundCurrent = false;

    for (final stage in stages) {
      for (final topicId in stage.topicIds) {
        if (foundCurrent) {
          return topicId;
        }
        if (topicId == currentTopicId) {
          foundCurrent = true;
        }
      }
    }
    return null; // Reached the end
  }

  List<CareerMilestoneModel> getCareerMilestones() {
    List<CareerMilestoneModel> milestones = [];
    final stages = getRoadmapStages();
    
    for (final stage in stages) {
      int stageTotal = 0;
      int stageCompleted = 0;
      
      for (final topicId in stage.topicIds) {
        final progress = getProgressForTopic(topicId);
        stageTotal += progress.totalActivities;
        stageCompleted += progress.completedCount;
      }
      
      bool isCompleted = stageTotal > 0 && stageTotal == stageCompleted;
      String title = stage.stageTitle;
      if (title.contains(':')) {
        title = title.split(':').last.trim();
      }
      milestones.add(CareerMilestoneModel(title: title, isCompleted: isCompleted));
    }
    return milestones;
  }

  String _formatTopicTitle(String topicId) {
    final match = NonAcademicData.findTopicById(topicId);
    if (match != null) {
      return match.topic.title;
    }
    return topicId;
  }

  // ==========================================
  // PHASE 5: CAREER READINESS & EXECUTION
  // ==========================================

  Future<void> toggleResumeItem(String key) async {
    bool currentVal = false;
    switch (key) {
      case 'technicalSkillsIdentified':
        currentVal = _resumeChecklist.technicalSkillsIdentified;
        _resumeChecklist = _resumeChecklist.copyWith(technicalSkillsIdentified: !currentVal);
        break;
      case 'oneCompletedProject':
        currentVal = _resumeChecklist.oneCompletedProject;
        _resumeChecklist = _resumeChecklist.copyWith(oneCompletedProject: !currentVal);
        break;
      case 'projectDescriptionsPrepared':
        currentVal = _resumeChecklist.projectDescriptionsPrepared;
        _resumeChecklist = _resumeChecklist.copyWith(projectDescriptionsPrepared: !currentVal);
        break;
      case 'evidenceAvailable':
        currentVal = _resumeChecklist.evidenceAvailable;
        _resumeChecklist = _resumeChecklist.copyWith(evidenceAvailable: !currentVal);
        break;
      case 'educationPrepared':
        currentVal = _resumeChecklist.educationPrepared;
        _resumeChecklist = _resumeChecklist.copyWith(educationPrepared: !currentVal);
        break;
      case 'careerObjectivePrepared':
        currentVal = _resumeChecklist.careerObjectivePrepared;
        _resumeChecklist = _resumeChecklist.copyWith(careerObjectivePrepared: !currentVal);
        break;
      case 'resumeReviewed':
        currentVal = _resumeChecklist.resumeReviewed;
        _resumeChecklist = _resumeChecklist.copyWith(resumeReviewed: !currentVal);
        break;
    }
    notifyListeners();
    await _repository.saveResumeChecklist(_resumeChecklist);
  }

  List<CareerDimensionProgress> getCareerReadiness() {
    if (_profile == null) return [];
    
    final dimensions = CareerDataMapper.getDimensionsForGoal(_profile!.goal);
    List<CareerDimensionProgress> progress = [];

    dimensions.forEach((dimName, topicIds) {
      int total = topicIds.length * 4; // 4 activities per topic
      int completed = 0;
      for (final tid in topicIds) {
        completed += getProgressForTopic(tid).completedCount;
      }
      progress.add(CareerDimensionProgress(dimensionName: dimName, completed: completed, total: total));
    });

    return progress;
  }

  List<SkillEvidenceModel> getSkillMatrix() {
    return CareerDataMapper.getAllSkills(_progressMap);
  }

  List<SkillEvidenceModel> getSkillsForTopic(String topicId) {
    return CareerDataMapper.getSkillsForTopic(topicId, _progressMap);
  }

  List<ProjectPortfolioModel> getProjectPortfolio() {
    return CareerDataMapper.getProjects(_progressMap);
  }

  List<CareerGapModel> getCareerGaps() {
    List<CareerGapModel> gaps = [];
    if (_profile == null) return gaps;

    // 1. Missing Foundation Prerequisite
    final stages = getRoadmapStages();
    if (stages.isNotEmpty) {
      final foundationStage = stages.first;
      for (final tid in foundationStage.topicIds) {
        if (!getProgressForTopic(tid).isFullyCompleted) {
          gaps.add(CareerGapModel(
            title: 'Foundation Incomplete',
            description: 'Complete ${_formatTopicTitle(tid)} to build your foundation.',
            actionRoute: '/topic_detail',
            actionArguments: {'topicId': tid},
            actionLabel: 'LEARN',
            priority: 1,
          ));
          break; // Only show first missing foundation
        }
      }
    }

    // 2. Missing Project Evidence
    final projects = getProjectPortfolio();
    final completedProjects = projects.where((p) => p.state == ProjectState.completed).toList();
    if (completedProjects.isEmpty) {
      final firstNotStarted = projects.firstWhere(
        (p) => p.state == ProjectState.notStarted,
        orElse: () => projects.first,
      );
      gaps.add(CareerGapModel(
        title: 'Portfolio Project',
        description: 'You need project evidence for your career profile.',
        actionRoute: '/topic_detail',
        actionArguments: {'topicId': firstNotStarted.topicId},
        actionLabel: 'BUILD',
        priority: 2,
      ));
    }

    // 3. Resume Readiness
    if (_resumeChecklist.percentage < 100.0) {
      gaps.add(const CareerGapModel(
        title: 'Resume Readiness',
        description: 'Your career profile and resume checklist is incomplete.',
        actionRoute: '/resume-readiness',
        actionLabel: 'PREPARE',
        priority: 3,
      ));
    }

    gaps.sort((a, b) => a.priority.compareTo(b.priority));
    return gaps.take(3).toList();
  }
}

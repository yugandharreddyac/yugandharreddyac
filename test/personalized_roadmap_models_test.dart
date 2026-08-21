import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csse_study_hub/data/models/personalized_roadmap_models.dart';
import 'package:csse_study_hub/data/models/user_goal_model.dart';
import 'package:csse_study_hub/data/repositories/roadmap_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PersonalizedProfile Model Tests', () {
    test('PersonalizedProfile serializes and deserializes to JSON seamlessly',
        () {
      final profile = PersonalizedProfile(
        academicStage: AcademicStage.thirdYear,
        goals: ['Placement', 'Software Development'],
        careerDirections: ['AI Engineer', 'Machine Learning Engineer'],
        primaryCareerDirection: 'AI Engineer',
        interestAreas: ['AI', 'Machine Learning', 'Python'],
        overallSkillLevel: SkillLevel.intermediate,
        skillLevels: {
          'programming': SkillLevel.intermediate,
          'dsa': SkillLevel.basic,
          'ai_ml': SkillLevel.beginner,
        },
        programmingLanguages: ['Python', 'C++', 'SQL'],
        primaryLanguage: 'Python',
        secondaryLanguage: 'C++',
        projectExperience: '2–3 personal projects',
        internshipStatus: 'Looking for internship',
        openSourceExperience: 'Beginner contributor',
        codingPracticeLevel: 'Regularly',
        targetOrganizationTypes: ['Product-based companies', 'Big Tech'],
        targetCompany: 'Google',
        dailyLearningTimeMinutes: 120,
        weeklyAvailability: 'Weekdays + weekends',
        targetTimeline: '6 months',
        learningStyle: LearningStyle.balanced,
        strengths: ['Programming', 'Mathematics'],
        weaknesses: ['DSA', 'System Design'],
        placementPreparationAreas: ['Aptitude', 'DSA', 'OOP', 'DBMS'],
        alreadyCompletedSkills: ['Python Basics', 'Git/GitHub'],
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );

      final jsonStr = profile.toJson();
      final decoded = PersonalizedProfile.fromJson(jsonStr);

      expect(decoded.academicStage, equals(AcademicStage.thirdYear));
      expect(decoded.primaryCareerDirection, equals('AI Engineer'));
      expect(decoded.primaryLanguage, equals('Python'));
      expect(decoded.secondaryLanguage, equals('C++'));
      expect(decoded.dailyLearningTimeMinutes, equals(120));
      expect(
          decoded.skillLevels['programming'], equals(SkillLevel.intermediate));
      expect(decoded.skillLevels['dsa'], equals(SkillLevel.basic));
      expect(decoded.strengths, contains('Programming'));
      expect(decoded.weaknesses, contains('DSA'));
      expect(decoded.placementPreparationAreas, contains('Aptitude'));
      expect(decoded.alreadyCompletedSkills, contains('Python Basics'));
    });

    test(
        'PersonalizedProfile handles missing optional fields gracefully with defaults',
        () {
      const minimalMap = {
        'academicStage': 'secondYear',
        'goals': ['Placement'],
        'careerDirections': ['Software Engineer'],
        'primaryCareerDirection': 'Software Engineer',
        'primaryLanguage': 'Java',
      };

      final profile = PersonalizedProfile.fromMap(minimalMap);
      expect(profile.academicStage, equals(AcademicStage.secondYear));
      expect(profile.primaryLanguage, equals('Java'));
      expect(profile.secondaryLanguage, isNull);
      expect(profile.targetCompany, isNull);
      expect(profile.dailyLearningTimeMinutes, equals(60));
      expect(profile.learningStyle, equals(LearningStyle.balanced));
      expect(profile.overallSkillLevel, equals(SkillLevel.beginner));
    });

    test('PersonalizedProfile copyWith updates specific fields correctly', () {
      final initial = PersonalizedProfile(
        academicStage: AcademicStage.firstYear,
        goals: const ['Skill Development'],
        careerDirections: const ['Full Stack Developer'],
        primaryCareerDirection: 'Full Stack Developer',
        primaryLanguage: 'JavaScript',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updated = initial.copyWith(
        academicStage: AcademicStage.secondYear,
        dailyLearningTimeMinutes: 180,
      );

      expect(updated.academicStage, equals(AcademicStage.secondYear));
      expect(updated.dailyLearningTimeMinutes, equals(180));
      expect(updated.primaryLanguage, equals('JavaScript'));
    });
  });

  group('RoadmapItem and RoadmapPhase Model Tests', () {
    test('RoadmapItem calculates status and getters correctly', () {
      const item1 = RoadmapItem(
        id: 'item_01',
        title: 'Python Fundamentals',
        description: 'Core syntax, loops, functions',
        category: 'Programming',
        difficulty: RoadmapDifficulty.beginner,
        estimatedMinutes: 45,
        priority: RoadmapItemPriority.critical,
        status: RoadmapItemStatus.completed,
        phaseId: 'phase_01',
        sequence: 1,
        targetSkill: 'Python',
        recommendationReason: 'Core foundation language',
      );

      expect(item1.isCompleted, isTrue);
      expect(item1.isInProgress, isFalse);
      expect(item1.isLocked, isFalse);
      expect(item1.isNotStarted, isFalse);

      final map = item1.toMap();
      final fromMap = RoadmapItem.fromMap(map);
      expect(fromMap.id, equals('item_01'));
      expect(fromMap.priority, equals(RoadmapItemPriority.critical));
      expect(fromMap.difficulty, equals(RoadmapDifficulty.beginner));
    });

    test('RoadmapPhase computes progress and completion metrics dynamically',
        () {
      const item1 = RoadmapItem(
        id: 'i1',
        title: 'Task 1',
        description: 'Desc 1',
        category: 'Core',
        phaseId: 'p1',
        sequence: 1,
        targetSkill: 'S1',
        status: RoadmapItemStatus.completed,
      );

      const item2 = RoadmapItem(
        id: 'i2',
        title: 'Task 2',
        description: 'Desc 2',
        category: 'Core',
        phaseId: 'p1',
        sequence: 2,
        targetSkill: 'S2',
        status: RoadmapItemStatus.inProgress,
      );

      const item3 = RoadmapItem(
        id: 'i3',
        title: 'Task 3',
        description: 'Desc 3',
        category: 'Core',
        phaseId: 'p1',
        sequence: 3,
        targetSkill: 'S3',
        status: RoadmapItemStatus.notStarted,
      );

      const phase = RoadmapPhase(
        id: 'p1',
        title: 'Phase 1: Foundation',
        description: 'Master core foundations',
        sequence: 1,
        estimatedDuration: '4 weeks',
        items: [item1, item2, item3],
      );

      expect(phase.totalItemsCount, equals(3));
      expect(phase.completedItemsCount, equals(1));
      expect(phase.inProgressItemsCount, equals(1));
      expect(phase.completionPercentage, closeTo(33.33, 0.1));
      expect(phase.isFullyCompleted, isFalse);
      expect(phase.isInProgress, isTrue);
      expect(phase.isNotStarted, isFalse);

      final phaseJson = phase.toMap();
      final restoredPhase = RoadmapPhase.fromMap(phaseJson);
      expect(restoredPhase.id, equals('p1'));
      expect(restoredPhase.items.length, equals(3));
    });
  });

  group('PersonalizedRoadmap Model & Repository Tests', () {
    late RoadmapRepository repository;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      repository = RoadmapRepository();
    });

    test(
        'PersonalizedRoadmap calculates overall progress and identifies next task',
        () {
      const item1 = RoadmapItem(
        id: 'i1',
        title: 'Python Functions',
        description: 'Learn functions',
        category: 'Core',
        phaseId: 'p1',
        sequence: 1,
        targetSkill: 'Python',
        status: RoadmapItemStatus.completed,
      );

      const item2 = RoadmapItem(
        id: 'i2',
        title: 'DSA: Arrays',
        description: 'Learn arrays',
        category: 'DSA',
        phaseId: 'p1',
        sequence: 2,
        targetSkill: 'DSA',
        status: RoadmapItemStatus.notStarted,
      );

      const phase = RoadmapPhase(
        id: 'p1',
        title: 'Phase 1',
        description: 'Foundations',
        sequence: 1,
        estimatedDuration: '2 weeks',
        items: [item1, item2],
      );

      final roadmap = PersonalizedRoadmap(
        id: 'roadmap_001',
        title: 'Personalized AI Engineer Roadmap',
        targetCareer: 'AI Engineer',
        mainGoal: 'Placement',
        targetTimeline: '6 months',
        dailyMinutes: 120,
        weeklyAvailability: 'Weekdays + weekends',
        phases: const [phase],
        generatedAt: DateTime.now(),
        lastUpdatedAt: DateTime.now(),
      );

      expect(roadmap.totalItemsCount, equals(2));
      expect(roadmap.completedItemsCount, equals(1));
      expect(roadmap.overallProgress, equals(50.0));
      expect(roadmap.nextRecommendedItem?.id, equals('i2'));
      expect(roadmap.findItemById('i1')?.title, equals('Python Functions'));
    });

    test('RoadmapRepository saves, loads, and updates personalized roadmap',
        () async {
      const item1 = RoadmapItem(
        id: 'task_01',
        title: 'Git Version Control',
        description: 'Learn git branching',
        category: 'Tools',
        phaseId: 'phase_01',
        sequence: 1,
        targetSkill: 'Git',
        status: RoadmapItemStatus.notStarted,
      );

      const phase = RoadmapPhase(
        id: 'phase_01',
        title: 'Foundation',
        description: 'Core tools',
        sequence: 1,
        estimatedDuration: '1 week',
        items: [item1],
      );

      final roadmap = PersonalizedRoadmap(
        id: 'rm_101',
        title: 'Software Engineer Path',
        targetCareer: 'Software Engineer',
        mainGoal: 'Internship',
        targetTimeline: '3 months',
        dailyMinutes: 60,
        weeklyAvailability: 'Weekdays',
        phases: const [phase],
        generatedAt: DateTime.now(),
        lastUpdatedAt: DateTime.now(),
      );

      await repository.savePersonalizedRoadmap(roadmap);

      final loaded = await repository.loadPersonalizedRoadmap();
      expect(loaded, isNotNull);
      expect(loaded!.id, equals('rm_101'));
      expect(
          loaded.phases.first.items.first.title, equals('Git Version Control'));
      expect(loaded.phases.first.items.first.status,
          equals(RoadmapItemStatus.notStarted));

      // Update status to completed
      await repository.updateRoadmapItemStatus(
          'task_01', RoadmapItemStatus.completed);
      final updated = await repository.loadPersonalizedRoadmap();
      expect(updated!.phases.first.items.first.status,
          equals(RoadmapItemStatus.completed));
      expect(updated.overallProgress, equals(100.0));
    });

    test(
        'Backward Compatibility: Legacy UserGoalProfile remains completely functional',
        () async {
      const legacyProfile = UserGoalProfile(
        year: StudentYear.thirdYear,
        goal: CareerGoal.softwarePlacement,
        preferredDomain: 'Full-Stack Development',
        hoursPerWeek: 15,
      );

      await repository.saveGoalProfile(legacyProfile);
      final loaded = await repository.loadGoalProfile();

      expect(loaded, isNotNull);
      expect(loaded!.year, equals(StudentYear.thirdYear));
      expect(loaded.goal, equals(CareerGoal.softwarePlacement));
      expect(loaded.hoursPerWeek, equals(15));
    });
  });
}

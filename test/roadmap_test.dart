import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/models/user_goal_model.dart';
import 'package:csse_study_hub/presentation/providers/roadmap_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Personalized Roadmap & Progress Verification Tests', () {
    test('UserGoalProfile JSON serialization & extension getters', () {
      const profile = UserGoalProfile(
        year: StudentYear.secondYear,
        goal: CareerGoal.softwarePlacement,
        preferredDomain: 'Full-Stack Web',
        hoursPerWeek: 12,
      );

      expect(profile.year.label, equals('2nd Year'));
      expect(profile.year.shortLabel, equals('Year 2'));
      expect(profile.goal.title, equals('Software / IT Placement'));

      final json = profile.toJson();
      final restored = UserGoalProfile.fromJson(json);

      expect(restored.year, equals(StudentYear.secondYear));
      expect(restored.goal, equals(CareerGoal.softwarePlacement));
      expect(restored.preferredDomain, equals('Full-Stack Web'));
      expect(restored.hoursPerWeek, equals(12));
    });

    test('TopicProgressModel calculates exact activity counts and percentages', () {
      const progress = TopicProgressModel(
        topicId: 'dsa_arrays',
        learnCompleted: true,
        practiceCompleted: true,
        buildCompleted: false,
        reviewCompleted: false,
      );

      expect(progress.completedCount, equals(2));
      expect(progress.totalActivities, equals(4));
      expect(progress.percentage, equals(50.0));
      expect(progress.isFullyCompleted, isFalse);
      expect(progress.isInProgress, isTrue);

      final fullProgress = progress.copyWith(
        buildCompleted: true,
        reviewCompleted: true,
      );

      expect(fullProgress.completedCount, equals(4));
      expect(fullProgress.percentage, equals(100.0));
      expect(fullProgress.isFullyCompleted, isTrue);
    });

    test('RoadmapProvider builds personalized stages based on year and goal', () async {
      final provider = RoadmapProvider();

      // Test 1: Software Placement Roadmap
      await provider.setGoalProfile(const UserGoalProfile(
        year: StudentYear.firstYear,
        goal: CareerGoal.softwarePlacement,
      ));

      final placementStages = provider.getRoadmapStages();
      expect(placementStages.length, greaterThanOrEqualTo(4));
      expect(placementStages.first.stageTitle, contains('FOUNDATION'));
      expect(placementStages.last.stageTitle, contains('CAREER'));

      // Test 2: Entrepreneurship Roadmap
      await provider.setGoalProfile(const UserGoalProfile(
        year: StudentYear.thirdYear,
        goal: CareerGoal.entrepreneurship,
      ));

      final startupStages = provider.getRoadmapStages();
      expect(startupStages.any((s) => s.stageTitle.contains('Lean MVP')), isTrue);
      expect(startupStages.any((s) => s.stageTitle.contains('Pitch Deck')), isTrue);

      // Test 3: GATE Exam Roadmap
      await provider.setGoalProfile(const UserGoalProfile(
        year: StudentYear.fourthYear,
        goal: CareerGoal.gateExam,
      ));

      final gateStages = provider.getRoadmapStages();
      expect(gateStages.any((s) => s.stageTitle.contains('GATE')), isTrue);
    });

    test('RoadmapProvider toggling activities updates topic progress and overall percentage', () async {
      final provider = RoadmapProvider();

      await provider.setGoalProfile(const UserGoalProfile(
        year: StudentYear.firstYear,
        goal: CareerGoal.softwarePlacement,
      ));

      final initialProgress = provider.calculateOverallProgress();
      expect(initialProgress, equals(0.0));

      await provider.toggleActivity(
        topicId: 'basics_intro',
        type: ActivityType.learn,
      );

      final topicProgress = provider.getProgressForTopic('basics_intro');
      expect(topicProgress.learnCompleted, isTrue);
      expect(topicProgress.completedCount, equals(1));
      expect(topicProgress.percentage, equals(25.0));

      final updatedOverall = provider.calculateOverallProgress();
      expect(updatedOverall, greaterThan(0.0));
    });

    test('RoadmapProvider generates actionable daily plan tasks', () async {
      final provider = RoadmapProvider();

      await provider.setGoalProfile(const UserGoalProfile(
        year: StudentYear.secondYear,
        goal: CareerGoal.softwarePlacement,
      ));

      final tasks = provider.getTodaysPlan();
      expect(tasks.isNotEmpty, isTrue);
      expect(tasks.first.topicTitle.isNotEmpty, isTrue);
      expect(tasks.first.actionTitle.isNotEmpty, isTrue);
      expect(tasks.first.estimatedMinutes, greaterThan(0));
    });
  });
}

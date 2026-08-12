import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/models/user_goal_model.dart';
import 'package:csse_study_hub/data/datasources/non_academic_data.dart';
import 'package:csse_study_hub/presentation/providers/roadmap_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CSSED Phase 1 Acceptance Test — 1st Year Student Journey', () {
    test('18-Step Full Student Journey Acceptance Test', () async {
      // Step 1: Fresh user opens CSSED (New RoadmapProvider instance)
      final provider = RoadmapProvider();
      expect(provider.hasProfile, isFalse);

      // Step 2 & 3: Selects 1st Year & Software / IT Placement
      const selectedProfile = UserGoalProfile(
        year: StudentYear.firstYear,
        goal: CareerGoal.softwarePlacement,
        preferredDomain: 'Full-Stack Web',
        hoursPerWeek: 10,
      );

      // Step 4: Generates roadmap
      await provider.setGoalProfile(selectedProfile);
      expect(provider.hasProfile, isTrue);

      // Step 5: Opens My Roadmap & verifies stages
      final stages = provider.getRoadmapStages();
      expect(stages.length, greaterThanOrEqualTo(4));
      expect(stages[0].stageTitle, contains('FOUNDATION'));

      // Step 6: Identifies FIRST recommended learning action
      final initialTodaysPlan = provider.getTodaysPlan();
      expect(initialTodaysPlan.isNotEmpty, isTrue);
      final firstTask = initialTodaysPlan.first;
      expect(firstTask.topicId, equals('basics_intro'));
      expect(firstTask.type, equals(ActivityType.learn));

      // Step 7: Opens topic 'basics_intro' and verifies topic lookup
      final topicMatch = NonAcademicData.findTopicById(firstTask.topicId);
      expect(topicMatch, isNotNull);
      expect(topicMatch!.topic.title, equals('Introduction to Programming'));

      // Step 8: Verifies topic-specific external resource URL
      final resources = topicMatch.topic.resources;
      expect(resources.isNotEmpty, isTrue);
      expect(resources.first.url, equals('https://docs.python.org/3/tutorial/index.html'));

      // Step 10: Completes Learn (0% -> 25%)
      await provider.toggleActivity(topicId: 'basics_intro', type: ActivityType.learn);
      var progress = provider.getProgressForTopic('basics_intro');
      expect(progress.learnCompleted, isTrue);
      expect(progress.percentage, equals(25.0));

      // Step 11: Completes Practice (25% -> 50%)
      await provider.toggleActivity(topicId: 'basics_intro', type: ActivityType.practice);
      progress = provider.getProgressForTopic('basics_intro');
      expect(progress.practiceCompleted, isTrue);
      expect(progress.percentage, equals(50.0));

      // Step 12: Completes Build (50% -> 75%)
      await provider.toggleActivity(topicId: 'basics_intro', type: ActivityType.build);
      progress = provider.getProgressForTopic('basics_intro');
      expect(progress.buildCompleted, isTrue);
      expect(progress.percentage, equals(75.0));

      // Step 13: Completes Review (75% -> 100%)
      await provider.toggleActivity(topicId: 'basics_intro', type: ActivityType.review);
      progress = provider.getProgressForTopic('basics_intro');
      expect(progress.reviewCompleted, isTrue);
      expect(progress.percentage, equals(100.0));
      expect(progress.isFullyCompleted, isTrue);

      // Step 14: Verify overall progress updated
      final updatedOverall = provider.calculateOverallProgress();
      expect(updatedOverall, greaterThan(0.0));

      // Step 15 & 16: Restart/reload application & verify progress persists
      final reloadedProvider = RoadmapProvider();
      final persistedProgress = reloadedProvider.getProgressForTopic('basics_intro');
      expect(persistedProgress.isFullyCompleted, isTrue);
      expect(persistedProgress.percentage, equals(100.0));

      // Step 17: Verify Today's Plan changes according to completed work
      final updatedTodaysPlan = reloadedProvider.getTodaysPlan();
      expect(updatedTodaysPlan.first.topicId, equals('python_basics'));

      // Step 18: Move to the next roadmap activity ('python_basics')
      final nextTopicMatch = NonAcademicData.findTopicById(updatedTodaysPlan.first.topicId);
      expect(nextTopicMatch, isNotNull);
      expect(nextTopicMatch!.topic.title, equals('Python Basics & Setup'));
    });
  });
}

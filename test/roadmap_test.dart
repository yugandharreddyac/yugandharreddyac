import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/models/user_goal_model.dart';
import 'package:csse_study_hub/presentation/providers/roadmap_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('CSSED Phase 3 Acceptance & Personal Student Intelligence Tests', () {
    test('1. Topic opening history deduplicates, persists, and caps at 10 items', () async {
      final provider = RoadmapProvider();
      await Future.delayed(const Duration(milliseconds: 50));
      expect(provider.recentTopicIds.isEmpty, isTrue);
      expect(provider.lastOpenedTopicId, isNull);

      await provider.recordTopicOpened('basics_intro');
      expect(provider.lastOpenedTopicId, equals('basics_intro'));
      expect(provider.recentTopicIds.first, equals('basics_intro'));

      // Open second topic
      await provider.recordTopicOpened('python_basics');
      expect(provider.lastOpenedTopicId, equals('python_basics'));
      expect(provider.recentTopicIds.first, equals('python_basics'));
      expect(provider.recentTopicIds.length, equals(2));

      // Re-open first topic (deduplicates and brings to front)
      await provider.recordTopicOpened('basics_intro');
      expect(provider.lastOpenedTopicId, equals('basics_intro'));
      expect(provider.recentTopicIds.first, equals('basics_intro'));
      expect(provider.recentTopicIds.length, equals(2));
    });

    test('2. Topic bookmarking toggles, checks status, and persists state', () async {
      final provider = RoadmapProvider();
      await Future.delayed(const Duration(milliseconds: 50));
      expect(provider.isTopicBookmarked('basics_intro'), isFalse);

      await provider.toggleTopicBookmark('basics_intro');
      expect(provider.isTopicBookmarked('basics_intro'), isTrue);
      expect(provider.bookmarkedTopicIds.contains('basics_intro'), isTrue);

      await provider.toggleTopicBookmark('basics_intro');
      expect(provider.isTopicBookmarked('basics_intro'), isFalse);
    });

    test('3. Empirical Student Insights calculation returns accurate stats', () async {
      final provider = RoadmapProvider();
      await Future.delayed(const Duration(milliseconds: 50));
      await provider.setGoalProfile(const UserGoalProfile(
        year: StudentYear.firstYear,
        goal: CareerGoal.softwarePlacement,
      ));

      var insights = provider.getStudentInsights();
      expect(insights.overallPercentage, equals(0.0));
      expect(insights.completedTopicsCount, equals(0));
      expect(insights.inProgressTopicsCount, equals(0));

      // Complete 1 activity (In Progress)
      await provider.toggleActivity(topicId: 'basics_intro', type: ActivityType.learn);
      insights = provider.getStudentInsights();
      expect(insights.inProgressTopicsCount, equals(1));
      expect(insights.foundationPercentage, greaterThan(0.0));

      // Complete all 4 activities (Completed)
      await provider.toggleActivity(topicId: 'basics_intro', type: ActivityType.practice);
      await provider.toggleActivity(topicId: 'basics_intro', type: ActivityType.build);
      await provider.toggleActivity(topicId: 'basics_intro', type: ActivityType.review);

      insights = provider.getStudentInsights();
      expect(insights.completedTopicsCount, equals(1));
      expect(insights.inProgressTopicsCount, equals(0));
    });

    test('4. Full Phase 3 Student Journey Acceptance Test', () async {
      // Step A: New Student goal setup
      final provider = RoadmapProvider();
      await Future.delayed(const Duration(milliseconds: 50));
      await provider.setGoalProfile(const UserGoalProfile(
        year: StudentYear.firstYear,
        goal: CareerGoal.softwarePlacement,
      ));

      // Step B: Open first topic 'basics_intro'
      await provider.recordTopicOpened('basics_intro');
      expect(provider.lastOpenedTopicId, equals('basics_intro'));

      // Step C: Mark LEARN and PRACTICE
      await provider.toggleActivity(topicId: 'basics_intro', type: ActivityType.learn);
      await provider.toggleActivity(topicId: 'basics_intro', type: ActivityType.practice);

      var progress = provider.getProgressForTopic('basics_intro');
      expect(progress.percentage, equals(50.0));
      expect(progress.isInProgress, isTrue);

      // Step D: Bookmark topic
      await provider.toggleTopicBookmark('basics_intro');
      expect(provider.isTopicBookmarked('basics_intro'), isTrue);

      // Step E: Complete BUILD and REVIEW
      await provider.toggleActivity(topicId: 'basics_intro', type: ActivityType.build);
      await provider.toggleActivity(topicId: 'basics_intro', type: ActivityType.review);

      progress = provider.getProgressForTopic('basics_intro');
      expect(progress.isFullyCompleted, isTrue);
      expect(progress.percentage, equals(100.0));

      // Step F: Today's Plan recommends NEXT topic ('python_basics')
      final updatedTodaysPlan = provider.getTodaysPlan();
      expect(updatedTodaysPlan.first.topicId, equals('python_basics'));

      // Step G: Verify restart persistence
      final reloadedProvider = RoadmapProvider();
      await Future.delayed(const Duration(milliseconds: 50));
      expect(reloadedProvider.isTopicBookmarked('basics_intro'), isTrue);
      expect(reloadedProvider.getProgressForTopic('basics_intro').isFullyCompleted, isTrue);
    });
    test('Phase 4: Active Learning Next-Action Engine & Career Milestones', () async {
      final provider = RoadmapProvider();
      await Future.delayed(const Duration(milliseconds: 50));
      await provider.setGoalProfile(
        const UserGoalProfile(
          year: StudentYear.firstYear,
          goal: CareerGoal.softwarePlacement,
        ),
      );

      // Verify initial next topic resolution
      final initialTasks = provider.getTodaysPlan();
      expect(initialTasks.first.reason, contains('to build your foundation'));
      expect(initialTasks.first.progressText, equals('0 / 4'));

      // Start learning (In-progress)
      final topicId = initialTasks.first.topicId;
      await provider.toggleActivity(topicId: topicId, type: ActivityType.learn);
      await provider.toggleActivity(topicId: topicId, type: ActivityType.practice);

      // Verify Active Learning prioritization (Continue session)
      final activeTasks = provider.getTodaysPlan();
      expect(activeTasks.first.topicId, equals(topicId));
      expect(activeTasks.first.reason, contains('Continue learning'));
      expect(activeTasks.first.progressText, equals('2 / 4'));
      expect(activeTasks.first.actionTitle, equals('Build mini-project / code exercise'));

      // Verify Career Milestone Progress math
      final initialMilestones = provider.getCareerMilestones();
      expect(initialMilestones.isNotEmpty, isTrue);
      expect(initialMilestones.where((m) => m.isCompleted).length, equals(0));

      // Complete topic fully
      await provider.toggleActivity(topicId: topicId, type: ActivityType.build);
      await provider.toggleActivity(topicId: topicId, type: ActivityType.review);

      // Verify Completed topic is filtered from active tasks
      final postTasks = provider.getTodaysPlan();
      expect(postTasks.first.topicId, isNot(equals(topicId)));
      expect(postTasks.first.reason, equals('Start the next roadmap topic'));

      // Verify Next-Topic Resolution
      final nextRecommended = provider.getNextRecommendedTopicId(topicId);
      expect(nextRecommended, isNotNull);
      expect(nextRecommended, equals(postTasks.first.topicId));
    });
  });
}

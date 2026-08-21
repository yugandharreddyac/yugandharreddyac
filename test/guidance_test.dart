import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/datasources/guidance_engine.dart';
import 'package:csse_study_hub/data/models/guidance_models.dart';
import 'package:csse_study_hub/data/models/user_goal_model.dart';
import 'package:csse_study_hub/data/models/career_models.dart';

void main() {
  group('Guidance Engine Logic Tests', () {
    const profile = UserGoalProfile(
      year: StudentYear.firstYear,
      goal: CareerGoal.softwarePlacement,
      preferredDomain: 'Software Engineering',
      hoursPerWeek: 10,
    );

    final dummyStages = [
      const RoadmapStageModel(
        stageTitle: 'Foundation',
        stageDescription: 'Test',
        topicIds: ['basics_intro'],
      ),
      const RoadmapStageModel(
        stageTitle: 'Core',
        stageDescription: 'Test',
        topicIds: ['data_structures'],
      ),
    ];

    test('Null profile returns notStarted', () {
      final status = GuidanceEngine.determineStudentStatus(
          null, {}, dummyStages, const ResumeReadinessModel());
      expect(status, StudentStatus.notStarted);
    });

    test('Empty progress returns foundationBuilding or notStarted', () {
      final status = GuidanceEngine.determineStudentStatus(
          profile, {}, dummyStages, const ResumeReadinessModel());
      expect(status, StudentStatus.notStarted); // If 0% on foundation
    });

    test('Roadmap health identifies blocking topic and correct current stage',
        () {
      final health =
          GuidanceEngine.calculateRoadmapHealth(profile, {}, dummyStages);
      expect(health.currentStageName, 'Foundation');
      expect(health.blockingTopicTitle, isNotNull);
      expect(health.stageHealths.isNotEmpty, true);
      expect(health.stageHealths.first.name, 'Foundation');
    });

    test('Next best action prioritizes in-progress last opened topic', () {
      final progressMap = {
        'basics_intro': const TopicProgressModel(
          topicId: 'basics_intro',
          learnCompleted: true,
          practiceCompleted: false,
          buildCompleted: false,
          reviewCompleted: false,
        ),
      };

      final action = GuidanceEngine.getNextBestAction(
        profile,
        progressMap,
        dummyStages,
        'basics_intro',
        const ResumeReadinessModel(),
      );

      expect(action, isNotNull);
      expect(action!.title, contains('Resume'));
      expect(action.reason, contains('recently learning'));
    });

    test('Next best action falls back to next unstarted topic', () {
      final progressMap = <String, TopicProgressModel>{};

      final action = GuidanceEngine.getNextBestAction(
        profile,
        progressMap,
        dummyStages,
        null,
        const ResumeReadinessModel(),
      );

      expect(action, isNotNull);
      expect(action!.title, contains('Start'));
      expect(action.reason, contains('next incomplete topic'));
    });
  });
}

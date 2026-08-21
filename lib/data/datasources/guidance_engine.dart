import '../models/guidance_models.dart';
import '../models/user_goal_model.dart';
import '../models/career_models.dart';
import 'career_data_mapper.dart';
import 'non_academic_data.dart';

class GuidanceEngine {
  GuidanceEngine._();

  static StudentStatus determineStudentStatus(
    UserGoalProfile? profile,
    Map<String, TopicProgressModel> progressMap,
    List<RoadmapStageModel> roadmapStages,
    ResumeReadinessModel resume,
  ) {
    if (profile == null) return StudentStatus.notStarted;

    final health = calculateRoadmapHealth(profile, progressMap, roadmapStages);
    if (health.stageHealths.isEmpty) return StudentStatus.notStarted;

    final foundation = health.stageHealths.firstWhere(
        (s) => s.name == 'Foundation',
        orElse: () => const RoadmapStageHealth(
            name: 'Foundation', completed: 0, total: 0));
    final core = health.stageHealths.firstWhere((s) => s.name == 'Core',
        orElse: () =>
            const RoadmapStageHealth(name: 'Core', completed: 0, total: 0));
    final build = health.stageHealths.firstWhere((s) => s.name == 'Build',
        orElse: () =>
            const RoadmapStageHealth(name: 'Build', completed: 0, total: 0));

    if (foundation.percentage < 0.8) {
      return foundation.percentage == 0
          ? StudentStatus.notStarted
          : StudentStatus.foundationBuilding;
    }
    if (core.percentage < 0.8) {
      return StudentStatus.coreDevelopment;
    }
    if (build.percentage < 0.5) {
      return StudentStatus.projectBuilding;
    }

    if (resume.percentage < 80.0) {
      return StudentStatus.careerPreparation;
    }

    return StudentStatus.readyForApplication;
  }

  static RoadmapHealthModel calculateRoadmapHealth(
    UserGoalProfile profile,
    Map<String, TopicProgressModel> progressMap,
    List<RoadmapStageModel> roadmapStages,
  ) {
    final List<RoadmapStageHealth> stages = [];
    String? blockingTopic;
    String? nextIncompleteTopic;
    String currentStage = 'Foundation';
    String? nextStage;

    bool foundBlocker = false;

    for (int i = 0; i < roadmapStages.length; i++) {
      final stage = roadmapStages[i];
      int total = stage.topicIds.length;
      int completed = 0;
      bool stageBlocked = false;

      for (final topicId in stage.topicIds) {
        final progress = progressMap[topicId];
        final isCompleted = progress?.isFullyCompleted ?? false;

        if (isCompleted) {
          completed++;
        } else if (!foundBlocker) {
          foundBlocker = true;
          stageBlocked = true;
          final match = NonAcademicData.findTopicById(topicId);
          blockingTopic = match?.topic.title ?? topicId;
          nextIncompleteTopic = match?.topic.title ?? topicId;
          currentStage = stage.stageTitle;
          if (i + 1 < roadmapStages.length) {
            nextStage = roadmapStages[i + 1].stageTitle;
          }
        }
      }

      stages.add(RoadmapStageHealth(
        name: stage.stageTitle,
        completed: completed,
        total: total,
        isBlocked: stageBlocked,
      ));
    }

    if (!foundBlocker) {
      currentStage = 'Complete';
    }

    return RoadmapHealthModel(
      stageHealths: stages,
      currentStageName: currentStage,
      nextStageName: nextStage,
      blockingTopicTitle: blockingTopic,
      nextIncompleteTopicTitle: nextIncompleteTopic,
    );
  }

  static NextBestActionModel? getNextBestAction(
    UserGoalProfile? profile,
    Map<String, TopicProgressModel> progressMap,
    List<RoadmapStageModel> roadmapStages,
    String? lastOpenedTopicId,
    ResumeReadinessModel resume,
  ) {
    if (profile == null) return null;

    // 1. Resume in-progress topic
    if (lastOpenedTopicId != null) {
      final progress = progressMap[lastOpenedTopicId];
      if (progress != null && !progress.isFullyCompleted) {
        final match = NonAcademicData.findTopicById(lastOpenedTopicId);
        if (match != null) {
          return NextBestActionModel(
            title: 'Resume ${match.topic.title}',
            reason:
                'You were recently learning this topic and left it incomplete.',
            route: '/topic_detail',
            arguments: {
              'hub': match.hub,
              'category': match.category,
              'topic': match.topic,
              'breadcrumbTrail': [
                match.hub.title,
                match.category.title,
                match.topic.title
              ],
            },
          );
        }
      }
    }

    // 2. Complete blocking/unfinished early roadmap topic
    // 3. Next unstarted roadmap topic
    for (final stage in roadmapStages) {
      for (final topicId in stage.topicIds) {
        final progress = progressMap[topicId];
        if (progress == null || !progress.isFullyCompleted) {
          final match = NonAcademicData.findTopicById(topicId);
          if (match != null) {
            return NextBestActionModel(
              title: 'Start ${match.topic.title}',
              reason:
                  'This is the next incomplete topic in your ${stage.stageTitle} roadmap.',
              route: '/topic_detail',
              arguments: {
                'hub': match.hub,
                'category': match.category,
                'topic': match.topic,
                'breadcrumbTrail': [
                  match.hub.title,
                  match.category.title,
                  match.topic.title
                ],
              },
            );
          }
        }
      }
    }

    // 4. Missing career skill evidence
    final skills = CareerDataMapper.getAllSkills(progressMap);
    final missingSkill = skills.firstWhere(
        (s) =>
            s.level == SkillEvidenceLevel.notStarted ||
            s.level == SkillEvidenceLevel.learning,
        orElse: () => const SkillEvidenceModel(
            skillName: '',
            category: '',
            relatedTopicIds: [],
            level: SkillEvidenceLevel.demonstrated));
    if (missingSkill.skillName.isNotEmpty &&
        missingSkill.relatedTopicIds.isNotEmpty) {
      final topicId = missingSkill.relatedTopicIds.first;
      final match = NonAcademicData.findTopicById(topicId);
      if (match != null) {
        return NextBestActionModel(
          title: 'Improve ${missingSkill.skillName}',
          reason: 'You need more evidence for this career skill.',
          route: '/topic_detail',
          arguments: {
            'hub': match.hub,
            'category': match.category,
            'topic': match.topic,
            'breadcrumbTrail': [
              match.hub.title,
              match.category.title,
              match.topic.title
            ],
          },
        );
      }
    }

    // 5. Resume gaps
    if (resume.percentage < 100.0) {
      return const NextBestActionModel(
        title: 'Complete Resume Readiness',
        reason: 'Your resume checklist is incomplete.',
        route: '/resume-readiness',
      );
    }

    // 6. Exploration
    return const NextBestActionModel(
      title: 'Explore Learning Hubs',
      reason: 'You have completed your primary roadmap goals. Great job!',
      route: '/hubs', // If you have a specific route, or we navigate home/null.
    );
  }
}

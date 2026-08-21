import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:csse_study_hub/data/models/user_goal_model.dart';
import 'package:csse_study_hub/data/models/career_models.dart';
import 'package:csse_study_hub/data/datasources/career_data_mapper.dart';
import 'package:csse_study_hub/presentation/providers/roadmap_provider.dart';
import 'package:csse_study_hub/data/datasources/non_academic_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('CareerDataMapper calculates skill levels correctly', () {
    final Map<String, TopicProgressModel> progressMap = {
      'python_basics': const TopicProgressModel(
        topicId: 'python_basics',
        learnCompleted: true,
        practiceCompleted: true,
        buildCompleted: true,
      ),
      'lists_tuples': const TopicProgressModel(
        topicId: 'lists_tuples',
        learnCompleted: true,
        practiceCompleted: true,
      ),
      'java_intro': const TopicProgressModel(
        topicId: 'java_intro',
        learnCompleted: true,
      ),
    };

    final pythonLevel =
        CareerDataMapper.calculateSkillLevel('Python', progressMap);
    final javaLevel = CareerDataMapper.calculateSkillLevel('Java', progressMap);
    final cppLevel = CareerDataMapper.calculateSkillLevel('C++', progressMap);

    expect(
        pythonLevel, SkillEvidenceLevel.demonstrated); // buildCompleted = true
    expect(
        javaLevel, SkillEvidenceLevel.learning); // only learnCompleted = true
    expect(cppLevel, SkillEvidenceLevel.notStarted);
  });

  test('CareerDataMapper identifies projects properly', () {
    // Get the actual first project topic from NonAcademicData
    final hub = NonAcademicData.getHubById('projects');
    if (hub == null ||
        hub.categories.isEmpty ||
        hub.categories.first.topics.isEmpty) return;

    final topicId = hub.categories.first.topics.first.id;

    final Map<String, TopicProgressModel> progressMap = {
      topicId: TopicProgressModel(
        topicId: topicId,
        learnCompleted: true,
        practiceCompleted: true,
        buildCompleted: true,
        reviewCompleted: true,
      ),
    };

    final projects = CareerDataMapper.getProjects(progressMap);
    expect(projects.isNotEmpty, true);

    final project = projects.firstWhere((p) => p.topicId == topicId);
    expect(project.state, ProjectState.completed);
  });

  test(
      'RoadmapProvider Resume Readiness toggling works and calculates percentages',
      () async {
    final provider = RoadmapProvider();
    // Wait for init
    await Future.delayed(const Duration(milliseconds: 100));

    expect(provider.resumeChecklist.percentage, 0.0);

    await provider.toggleResumeItem('careerObjectivePrepared');
    expect(provider.resumeChecklist.careerObjectivePrepared, true);
    expect(provider.resumeChecklist.completedCount, 1);

    await provider.toggleResumeItem('careerObjectivePrepared');
    expect(provider.resumeChecklist.careerObjectivePrepared, false);
    expect(provider.resumeChecklist.completedCount, 0);
  });

  test('RoadmapProvider getCareerGaps prioritizes foundation over resume',
      () async {
    // We mock SharedPreferences so that RoadmapProvider loads an empty state.
    // If goal profile exists, it evaluates gaps.
    SharedPreferences.setMockInitialValues({
      'cssed_user_goal_profile': jsonEncode({
        'goal': 'softwarePlacement',
        'year': 'thirdYear',
      }),
    });

    final provider = RoadmapProvider();
    await Future.delayed(const Duration(milliseconds: 100));

    final gaps = provider.getCareerGaps();
    // Foundation incomplete should be #1 priority.
    expect(gaps.isNotEmpty, true);
    expect(gaps.first.title, 'Foundation Incomplete');
  });
}

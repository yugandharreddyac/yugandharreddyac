import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/datasources/non_academic_data.dart';
import 'package:csse_study_hub/data/models/hierarchy_node_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Run Baseline Audit for Phase 7', () {
    final hubs = NonAcademicData.allHubs;

    print('====================================================');
    print('PHASE 7 BASELINE EDUCATIONAL CONTENT AUDIT REPORT');
    print('====================================================\n');

    int grandTotalTopics = 0;
    int totalResources = 0;
    int practiceResourcesCount = 0;
    int projectResourcesCount = 0;
    Set<String> uniqueUrls = {};
    int duplicateUrlsCount = 0;
    int invalidUrlsCount = 0;
    List<String> topicsBelow60 = [];
    List<String> topicsBelow80 = [];

    Map<String, List<double>> hubScores = {};

    for (final hub in hubs) {
      hubScores[hub.id] = [];
      print('----------------------------------------------------');
      print('HUB: ${hub.title} (${hub.id})');
      print('Categories: ${hub.categories.length}');
      print('----------------------------------------------------');

      for (final cat in hub.categories) {
        print(
            '  Category: ${cat.title} (${cat.id}) | Topics: ${cat.topics.length}');
        for (final topic in cat.topics) {
          grandTotalTopics++;

          // A. Concept Explanation (20)
          double conceptScore = 0;
          final descLen = topic.description.trim().length;
          if (descLen > 150) {
            conceptScore = 20;
          } else if (descLen > 80) {
            conceptScore = 15;
          } else if (descLen > 40) {
            conceptScore = 10;
          } else if (descLen > 0) {
            conceptScore = 5;
          }

          // B. Learning Progression (15)
          double progressionScore = 0;
          if (topic.level != null && topic.subtopics.isNotEmpty) {
            progressionScore = 15;
          } else if (topic.level != null || topic.subtopics.isNotEmpty) {
            progressionScore = 10;
          } else if (cat.hasLevels) {
            progressionScore = 5;
          }

          // C. Examples / Demonstration (15)
          double exampleScore = 0;
          final hasVideoOrNotes = topic.resources.any((r) =>
              r.type == HierarchyResourceType.notes ||
              r.type == HierarchyResourceType.video ||
              r.type == HierarchyResourceType.pdf);
          if (hasVideoOrNotes && topic.subtopics.isNotEmpty) {
            exampleScore = 15;
          } else if (hasVideoOrNotes) {
            exampleScore = 10;
          } else if (topic.resources.isNotEmpty) {
            exampleScore = 5;
          }

          // D. Practice (15)
          double practiceScore = 0;
          final practiceResCount = topic.resources
                  .where((r) => r.type == HierarchyResourceType.practice)
                  .length +
              topic.subtopics.fold(
                  0,
                  (acc, s) =>
                      acc +
                      s.resources
                          .where(
                              (r) => r.type == HierarchyResourceType.practice)
                          .length);
          if (practiceResCount >= 2) {
            practiceScore = 15;
          } else if (practiceResCount == 1) {
            practiceScore = 10;
          }

          // E. Practical Application (10)
          double applicationScore = 0;
          final descLower = topic.description.toLowerCase();
          if (descLower.contains('build') ||
              descLower.contains('real-world') ||
              descLower.contains('production') ||
              descLower.contains('architecture') ||
              descLower.contains('application') ||
              descLower.contains('system')) {
            applicationScore = 10;
          } else if (descLen > 50) {
            applicationScore = 5;
          }

          // F. Project / Build (10)
          bool projectApplies = hub.id == 'projects' ||
              topic.level == LearningLevel.projects ||
              descLower.contains('project');
          double projectScore = 0;
          final projResCount = topic.resources
                  .where((r) => r.type == HierarchyResourceType.project)
                  .length +
              topic.subtopics.fold(
                  0,
                  (acc, s) =>
                      acc +
                      s.resources
                          .where((r) => r.type == HierarchyResourceType.project)
                          .length);
          if (projResCount >= 1) {
            projectScore = 10;
          } else if (projectApplies) {
            projectScore = 0; // expected project but missing
          } else {
            projectScore = -1; // N/A
          }

          // G. Resources (10)
          double resourceScore = 0;
          final totalResForTopic = topic.resources.length +
              topic.subtopics.fold(0, (acc, s) => acc + s.resources.length);
          if (totalResForTopic >= 3) {
            resourceScore = 10;
          } else if (totalResForTopic >= 1) {
            resourceScore = 5;
          }

          // H. Career / Exam / Startup Relevance (5)
          double careerScore = 0;
          if (hub.id == 'placement' ||
              hub.id == 'higher_education' ||
              hub.id == 'entrepreneurship' ||
              descLower.contains('career') ||
              descLower.contains('interview') ||
              descLower.contains('gate') ||
              descLower.contains('resume') ||
              descLower.contains('startup')) {
            careerScore = 5;
          } else {
            careerScore = 2;
          }

          // Total calculation
          double maxPoints = 90;
          double earnedPoints = conceptScore +
              progressionScore +
              exampleScore +
              practiceScore +
              applicationScore +
              resourceScore +
              careerScore;
          if (projectScore != -1) {
            maxPoints = 100;
            earnedPoints += projectScore;
          }

          double depthPercent = (earnedPoints / maxPoints) * 100;
          hubScores[hub.id]!.add(depthPercent);

          if (depthPercent < 60) {
            topicsBelow60.add(
                '[${hub.id}] ${cat.title} > ${topic.title} (${depthPercent.toStringAsFixed(1)}%)');
          }
          if (depthPercent < 80) {
            topicsBelow80.add(
                '[${hub.id}] ${cat.title} > ${topic.title} (${depthPercent.toStringAsFixed(1)}%)');
          }

          // Resource & URL audit
          for (final res in topic.resources) {
            totalResources++;
            if (res.type == HierarchyResourceType.practice)
              practiceResourcesCount++;
            if (res.type == HierarchyResourceType.project)
              projectResourcesCount++;
            if (!res.url.startsWith('https://') &&
                !res.url.startsWith('http://')) {
              invalidUrlsCount++;
            }
            if (uniqueUrls.contains(res.url)) {
              duplicateUrlsCount++;
            } else {
              uniqueUrls.add(res.url);
            }
          }

          for (final sub in topic.subtopics) {
            for (final res in sub.resources) {
              totalResources++;
              if (res.type == HierarchyResourceType.practice)
                practiceResourcesCount++;
              if (res.type == HierarchyResourceType.project)
                projectResourcesCount++;
              if (!res.url.startsWith('https://') &&
                  !res.url.startsWith('http://')) {
                invalidUrlsCount++;
              }
              if (uniqueUrls.contains(res.url)) {
                duplicateUrlsCount++;
              } else {
                uniqueUrls.add(res.url);
              }
            }
          }
        }
      }
    }

    print('\n====================================================');
    print('HUB SUMMARY BASELINE RESULTS');
    print('====================================================');
    double sumAllDepths = 0;
    int totalTopicCount = 0;

    hubScores.forEach((hubId, scores) {
      final avg =
          scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;
      final gte80 = scores.where((s) => s >= 80).length;
      final range6079 = scores.where((s) => s >= 60 && s < 80).length;
      final lt60 = scores.where((s) => s < 60).length;
      sumAllDepths += scores.reduce((a, b) => a + b);
      totalTopicCount += scores.length;

      print(
          'Hub: $hubId | Topics: ${scores.length} | Avg Depth: ${avg.toStringAsFixed(1)}% | >=80%: $gte80 | 60-79%: $range6079 | <60%: $lt60');
    });

    final grandAvgDepth =
        totalTopicCount == 0 ? 0.0 : sumAllDepths / totalTopicCount;
    print('\nOVERALL BASELINE STATS:');
    print('Total Topics: $grandTotalTopics');
    print('Overall Content Depth Avg: ${grandAvgDepth.toStringAsFixed(1)}%');
    print('Total Resources: $totalResources');
    print('Practice Resources: $practiceResourcesCount');
    print('Project Resources: $projectResourcesCount');
    print('Invalid URLs: $invalidUrlsCount');
    print('Duplicate URLs: $duplicateUrlsCount');
    print('Topics < 60%: ${topicsBelow60.length}');
    print('Topics < 80%: ${topicsBelow80.length}');
    print('====================================================\n');
  });
}

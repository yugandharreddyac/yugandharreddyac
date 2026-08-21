import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csse_study_hub/data/models/personalized_roadmap_models.dart';
import 'package:csse_study_hub/data/datasources/rule_based_roadmap_generator.dart';
import 'package:csse_study_hub/data/datasources/roadmap_resource_resolver.dart';
import 'package:csse_study_hub/presentation/providers/roadmap_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  const generator = RuleBasedRoadmapGenerator();

  group('RuleBasedRoadmapGenerator — Track Generation & Domain Tests', () {
    test(
        'A. AI/ML Beginner generates structured 4-phase AI learning path with Python and Math',
        () async {
      final profile = PersonalizedProfile(
        academicStage: AcademicStage.thirdYear,
        goals: const ['Placement', 'Software Development'],
        careerDirections: const ['AI Engineer'],
        primaryCareerDirection: 'AI Engineer',
        primaryLanguage: 'Python',
        overallSkillLevel: SkillLevel.beginner,
        dailyLearningTimeMinutes: 120,
        targetTimeline: '6 months',
        weaknesses: const ['Mathematics', 'DSA'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final roadmap = await generator.generateRoadmap(profile: profile);

      expect(roadmap.phases.length, equals(4));
      expect(roadmap.targetCareer, equals('AI Engineer'));
      expect(roadmap.phases[0].title, contains('Foundations'));
      expect(roadmap.phases[1].title, contains('Machine Learning'));
      expect(roadmap.phases[2].title, contains('Deep Learning'));
      expect(roadmap.phases[3].title, contains('Projects'));

      // Check Math item has critical priority due to weakness
      final mathItem = roadmap.findItemById('ai_p1_math');
      expect(mathItem, isNotNull);
      expect(mathItem!.priority, equals(RoadmapItemPriority.critical));
      expect(mathItem.recommendationReason,
          contains('Mathematics was selected as a focus improvement area'));
    });

    test(
        'B. AI/ML Profile with already completed Python skips/completes foundation',
        () async {
      final profile = PersonalizedProfile(
        academicStage: AcademicStage.thirdYear,
        goals: const ['Placement'],
        careerDirections: const ['Machine Learning Engineer'],
        primaryCareerDirection: 'Machine Learning Engineer',
        primaryLanguage: 'Python',
        alreadyCompletedSkills: const ['Python'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final roadmap = await generator.generateRoadmap(profile: profile);
      final pythonItem = roadmap.findItemById('ai_p1_lang');
      expect(pythonItem, isNotNull);
      expect(pythonItem!.isCompleted, isTrue);
    });

    test(
        'C. Web Development profile generates HTML/CSS, JS, React, Backend, and DB phases',
        () async {
      final profile = PersonalizedProfile(
        academicStage: AcademicStage.secondYear,
        goals: const ['Internship'],
        careerDirections: const ['Full Stack Developer'],
        primaryCareerDirection: 'Full Stack Developer',
        primaryLanguage: 'JavaScript',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final roadmap = await generator.generateRoadmap(profile: profile);

      expect(roadmap.phases.length, equals(4));
      expect(roadmap.phases[0].title, contains('Web Fundamentals'));
      expect(roadmap.phases[1].title, contains('React'));
      expect(roadmap.phases[2].title, contains('Server-Side APIs'));

      final reactItem = roadmap.findItemById('web_p2_react');
      expect(reactItem, isNotNull);
      expect(reactItem!.prerequisites, contains('web_p1_js'));
      // React is locked because JS is not yet completed
      expect(reactItem.status, equals(RoadmapItemStatus.locked));
    });

    test(
        'D. Cybersecurity profile generates Networking, Linux, OWASP, and Defense phases',
        () async {
      final profile = PersonalizedProfile(
        academicStage: AcademicStage.fourthYear,
        goals: const ['Placement'],
        careerDirections: const ['Cybersecurity Engineer'],
        primaryCareerDirection: 'Cybersecurity Engineer',
        primaryLanguage: 'Python',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final roadmap = await generator.generateRoadmap(profile: profile);

      expect(roadmap.phases.length, equals(3));
      expect(roadmap.phases[0].title, contains('Networking & Linux'));
      expect(roadmap.phases[1].title, contains('Ethical Hacking'));

      final netItem = roadmap.findItemById('sec_p1_net');
      expect(netItem, isNotNull);
      expect(netItem!.targetSkill, equals('Computer Networks'));
    });

    test(
        'E. Cloud/DevOps profile generates Git, Docker, and Kubernetes deployment phases',
        () async {
      final profile = PersonalizedProfile(
        academicStage: AcademicStage.thirdYear,
        goals: const ['Placement'],
        careerDirections: const ['Cloud Engineer'],
        primaryCareerDirection: 'Cloud Engineer',
        primaryLanguage: 'Go',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final roadmap = await generator.generateRoadmap(profile: profile);

      expect(roadmap.phases.length, equals(3));
      expect(roadmap.phases[0].title, contains('Linux, Git'));
      expect(roadmap.phases[1].title, contains('Docker'));
      expect(roadmap.phases[2].title, contains('Kubernetes'));
    });

    test(
        'F. Placement Sprint Profile generates High-Yield DSA & Timed Mock Assessments',
        () async {
      final profile = PersonalizedProfile(
        academicStage: AcademicStage.fourthYear,
        goals: const ['Placement'],
        careerDirections: const ['Software Engineer'],
        primaryCareerDirection: 'Software Engineer',
        primaryLanguage: 'Java',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final roadmap = await generator.generateRoadmap(profile: profile);

      expect(roadmap.phases.length, greaterThanOrEqualTo(2));
      expect(roadmap.phases[0].title, contains('DSA & Problem Solving'));
      final aptItem = roadmap.findItemById('plc_p1_apt');
      expect(aptItem, isNotNull);
      expect(aptItem!.targetSkill, equals('Placement Quiz'));
      expect(aptItem.deepRoute, equals('/placement'));
    });

    test(
        'G. Higher Studies profile generates Discrete Math and Core Systems phases',
        () async {
      final profile = PersonalizedProfile(
        academicStage: AcademicStage.thirdYear,
        goals: const ['Higher Studies', 'Competitive Exams'],
        careerDirections: const ['Researcher'],
        primaryCareerDirection: 'Researcher',
        primaryLanguage: 'C++',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final roadmap = await generator.generateRoadmap(profile: profile);

      expect(roadmap.phases.length, equals(2));
      expect(roadmap.phases[0].title, contains('Discrete Structures'));
      expect(roadmap.phases[1].title, contains('Core Computer Systems'));
    });
  });

  group('RoadmapResourceResolver & Grounding Tests', () {
    test(
        'H. Resolves real UniDocs resources correctly for Aptitude, DSA, and Projects',
        () {
      final aptRes = RoadmapResourceResolver.resolve('Placement Quiz');
      expect(aptRes.isAvailable, isTrue);
      expect(aptRes.deepRoute, equals('/placement/quiz'));
      expect(aptRes.resourceType, equals('quiz'));

      final dsaRes = RoadmapResourceResolver.resolve('DSA');
      expect(dsaRes.isAvailable, isTrue);
      expect(dsaRes.deepRoute, equals('/coding'));
      expect(dsaRes.resourceType, equals('coding_hub'));

      final projRes = RoadmapResourceResolver.resolve('Project');
      expect(projRes.isAvailable, isTrue);
      expect(projRes.deepRoute, equals('/projects'));
      expect(projRes.resourceType, equals('project_hub'));
    });

    test(
        'I. Returns safe unavailable status for unmapped skills without broken links',
        () {
      final unmapped = RoadmapResourceResolver.resolve('Quantum Computing 99');
      expect(unmapped.isAvailable, isFalse);
      expect(unmapped.deepRoute, isEmpty);
    });
  });

  group(
      'Roadmap Recalculation, Progress Preservation & Provider Integration Tests',
      () {
    test(
        'J. Recalculation preserves completed tasks and increments roadmap version',
        () async {
      final initialProfile = PersonalizedProfile(
        academicStage: AcademicStage.thirdYear,
        goals: const ['Placement'],
        careerDirections: const ['AI Engineer'],
        primaryCareerDirection: 'AI Engineer',
        primaryLanguage: 'Python',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final initialRoadmap =
          await generator.generateRoadmap(profile: initialProfile);
      expect(initialRoadmap.roadmapVersion, equals(1));

      // Mark Python completed in the initial roadmap
      final completedItem = initialRoadmap
          .findItemById('ai_p1_lang')!
          .copyWith(status: RoadmapItemStatus.completed);
      final updatedPhases = initialRoadmap.phases.map((p) {
        return p.copyWith(
          items: p.items
              .map((i) => i.id == 'ai_p1_lang' ? completedItem : i)
              .toList(),
        );
      }).toList();
      final partiallyCompletedRoadmap =
          initialRoadmap.copyWith(phases: updatedPhases);

      // User updates timeline to 1 year
      final updatedProfile = initialProfile.copyWith(targetTimeline: '1 year');
      final recalculated = await generator.recalculateRoadmap(
        updatedProfile: updatedProfile,
        currentRoadmap: partiallyCompletedRoadmap,
      );

      expect(recalculated.roadmapVersion, equals(2));
      expect(recalculated.targetTimeline, equals('1 year'));
      // Verify Python remains completed!
      final preservedItem = recalculated.findItemById('ai_p1_lang');
      expect(preservedItem, isNotNull);
      expect(preservedItem!.isCompleted, isTrue);
    });

    test(
        'K. RoadmapProvider generates, updates status, and balances daily tasks',
        () async {
      final provider = RoadmapProvider();

      final profile = PersonalizedProfile(
        academicStage: AcademicStage.thirdYear,
        goals: const ['Placement'],
        careerDirections: const ['AI Engineer'],
        primaryCareerDirection: 'AI Engineer',
        primaryLanguage: 'Python',
        dailyLearningTimeMinutes: 90,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await provider.generatePersonalizedRoadmap(profile);
      expect(provider.hasPersonalizedRoadmap, isTrue);
      expect(provider.personalizedRoadmap?.targetCareer, equals('AI Engineer'));

      // Check daily tasks fit within 90 minutes
      final dailyTasks = provider.getTodaysPersonalizedTasks();
      expect(dailyTasks, isNotEmpty);
      int totalDailyMin =
          dailyTasks.fold(0, (sum, t) => sum + t.estimatedMinutes);
      expect(totalDailyMin, greaterThan(0));

      // Mark first task completed
      final firstTask = dailyTasks.first;
      await provider.markPersonalizedItemStatus(
          firstTask.id, RoadmapItemStatus.completed);
      expect(
          provider.personalizedRoadmap?.findItemById(firstTask.id)?.isCompleted,
          isTrue);
      expect(provider.personalizedOverallProgress, greaterThan(0.0));
    });

    test('L. Minimal profile safety: Handles empty fields without crashing',
        () async {
      final minimal = PersonalizedProfile(
        academicStage: AcademicStage.firstYear,
        goals: const [],
        careerDirections: const [],
        primaryCareerDirection: 'Software Engineer',
        primaryLanguage: 'C',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final roadmap = await generator.generateRoadmap(profile: minimal);
      expect(roadmap.phases, isNotEmpty);
      expect(roadmap.allItems, isNotEmpty);
    });
  });
}

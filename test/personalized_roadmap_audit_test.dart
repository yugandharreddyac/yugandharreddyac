import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:csse_study_hub/data/models/personalized_roadmap_models.dart';
import 'package:csse_study_hub/data/datasources/rule_based_roadmap_generator.dart';
import 'package:csse_study_hub/data/datasources/roadmap_resource_resolver.dart';
import 'package:csse_study_hub/data/datasources/non_academic_data.dart';
import 'package:csse_study_hub/presentation/providers/roadmap_provider.dart';
import 'package:csse_study_hub/presentation/screens/roadmap/my_roadmap_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  const generator = RuleBasedRoadmapGenerator();

  group('Personalized Roadmap Deep Audit — Representative Real Profiles', () {
    test('Audit Profile A: 3rd Year AI/ML, Python intermediate, Math weak, 2h/day, 6m', () async {
      final profileA = PersonalizedProfile(
        academicStage: AcademicStage.thirdYear,
        goals: const ['Placement', 'Skill Upgrade'],
        careerDirections: const ['AI Engineer'],
        primaryCareerDirection: 'AI Engineer',
        primaryLanguage: 'Python',
        overallSkillLevel: SkillLevel.intermediate,
        alreadyCompletedSkills: const ['Python'],
        weaknesses: const ['Mathematics', 'DSA'],
        dailyLearningTimeMinutes: 120,
        targetTimeline: '6 months',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final roadmap = await generator.generateRoadmap(profile: profileA);

      // 1. Check phase count and titles
      expect(roadmap.phases.length, equals(4));
      expect(roadmap.phases[0].id, equals('p1_foundations'));
      expect(roadmap.phases[1].id, equals('p2_ml_core'));
      expect(roadmap.phases[2].id, equals('p3_advanced_ai'));
      expect(roadmap.phases[3].id, equals('p4_projects_career'));

      // 2. Check Python foundations is marked completed (alreadyCompletedSkills)
      final pythonItem = roadmap.findItemById('ai_p1_lang');
      expect(pythonItem, isNotNull);
      expect(pythonItem!.isCompleted, isTrue);

      // 3. Check Mathematics is critical priority due to explicit weakness
      final mathItem = roadmap.findItemById('ai_p1_math');
      expect(mathItem, isNotNull);
      expect(mathItem!.priority, equals(RoadmapItemPriority.critical));
      expect(mathItem.recommendationReason, contains('Mathematics was selected as a focus improvement area'));

      // 4. Check ML Core prerequisites (requires NumPy & Math)
      final mlItem = roadmap.findItemById('ai_p2_ml');
      expect(mlItem, isNotNull);
      expect(mlItem!.prerequisites, contains('ai_p1_math'));
      expect(mlItem.prerequisites, contains('ai_p2_data'));

      // 5. Deep Learning requires ML
      final dlItem = roadmap.findItemById('ai_p3_dl');
      expect(dlItem, isNotNull);
      expect(dlItem!.prerequisites, contains('ai_p2_ml'));

      // 6. Check UniDocs resource resolution
      expect(pythonItem.resourceReference, equals('python'));
      expect(pythonItem.resourceType, equals('hub_topic'));
      expect(NonAcademicData.findTopicById(pythonItem.resourceReference!), isNotNull);

      final dsaItem = roadmap.findItemById('ai_p1_dsa');
      expect(dsaItem!.resourceReference, equals('dsa_arrays'));
      expect(NonAcademicData.findTopicById(dsaItem.resourceReference!), isNotNull);
    });

    test('Audit Profile B: 2nd Year Web Dev, JS beginner, HTML/CSS basic, 1h/day, 1y', () async {
      final profileB = PersonalizedProfile(
        academicStage: AcademicStage.secondYear,
        goals: const ['Internship'],
        careerDirections: const ['Full Stack Developer'],
        primaryCareerDirection: 'Full Stack Developer',
        primaryLanguage: 'JavaScript',
        overallSkillLevel: SkillLevel.beginner,
        dailyLearningTimeMinutes: 60,
        targetTimeline: '1 year',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final roadmap = await generator.generateRoadmap(profile: profileB);

      // 1. Phases sequence
      expect(roadmap.phases.length, equals(4));

      // 2. HTML/CSS is not locked, but JS requires HTML/CSS
      final htmlItem = roadmap.findItemById('web_p1_html');
      final jsItem = roadmap.findItemById('web_p1_js');
      final reactItem = roadmap.findItemById('web_p2_react');

      expect(htmlItem!.status, equals(RoadmapItemStatus.notStarted));
      expect(jsItem!.prerequisites, contains('web_p1_html'));
      expect(jsItem.status, equals(RoadmapItemStatus.locked));

      // 3. React requires JS and is locked
      expect(reactItem!.prerequisites, contains('web_p1_js'));
      expect(reactItem.status, equals(RoadmapItemStatus.locked));

      // 4. Resource groundings verify to real non-academic topics
      expect(htmlItem.resourceReference, equals('web_html_css'));
      expect(NonAcademicData.findTopicById('web_html_css'), isNotNull);

      expect(jsItem.resourceReference, equals('javascript_lang'));
      expect(NonAcademicData.findTopicById('javascript_lang'), isNotNull);

      expect(reactItem.resourceReference, equals('web_react'));
      expect(NonAcademicData.findTopicById('web_react'), isNotNull);
    });

    test('Audit Profile C: 3rd Year Cybersecurity, Linux beginner, Networking beginner, 2h/day', () async {
      final profileC = PersonalizedProfile(
        academicStage: AcademicStage.thirdYear,
        goals: const ['Placement'],
        careerDirections: const ['Cybersecurity Engineer'],
        primaryCareerDirection: 'Cybersecurity Engineer',
        primaryLanguage: 'Python',
        dailyLearningTimeMinutes: 120,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final roadmap = await generator.generateRoadmap(profile: profileC);

      final netItem = roadmap.findItemById('sec_p1_net');
      final linuxItem = roadmap.findItemById('sec_p1_linux');
      final owaspItem = roadmap.findItemById('sec_p2_owasp');
      final socItem = roadmap.findItemById('sec_p3_soc');

      expect(netItem, isNotNull);
      expect(linuxItem, isNotNull);
      expect(owaspItem!.prerequisites, contains('sec_p1_net'));
      expect(socItem!.prerequisites, contains('sec_p2_owasp'));

      expect(netItem!.resourceReference, equals('cyber_intro'));
      expect(NonAcademicData.findTopicById('cyber_intro'), isNotNull);

      expect(owaspItem.resourceReference, equals('cyber_intro'));
      expect(NonAcademicData.findTopicById('cyber_intro'), isNotNull);
    });

    test('Audit Profile D: Final Year Placement, DSA beginner, Aptitude weak, 3h/day, 3m', () async {
      final profileD = PersonalizedProfile(
        academicStage: AcademicStage.fourthYear,
        goals: const ['Placement'],
        careerDirections: const ['Software Engineer'],
        primaryCareerDirection: 'Software Engineer',
        primaryLanguage: 'Java',
        weaknesses: const ['Aptitude', 'DSA'],
        dailyLearningTimeMinutes: 180,
        targetTimeline: '3 months',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final roadmap = await generator.generateRoadmap(profile: profileD);

      // High-yield sprint items
      final dsaItem = roadmap.findItemById('plc_p1_dsa');
      final aptItem = roadmap.findItemById('plc_p1_apt');

      expect(dsaItem!.priority, equals(RoadmapItemPriority.critical));
      expect(aptItem!.priority, equals(RoadmapItemPriority.critical));
      expect(aptItem.resourceReference, equals('quant_aptitude'));
      expect(NonAcademicData.findTopicById('quant_aptitude'), isNotNull);
    });
  });

  group('Personalized Roadmap Topological Integrity & Cycle Detection', () {
    test('No cyclic dependencies exist in any generated track', () async {
      final tracks = [
        'AI Engineer',
        'Full Stack Developer',
        'Cybersecurity Engineer',
        'Cloud Engineer',
        'Software Engineer',
      ];

      for (final track in tracks) {
        final profile = PersonalizedProfile(
          academicStage: AcademicStage.thirdYear,
          goals: const ['Placement'],
          careerDirections: [track],
          primaryCareerDirection: track,
          primaryLanguage: 'Python',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final roadmap = await generator.generateRoadmap(profile: profile);
        final allItems = roadmap.allItems;
        final itemMap = {for (var i in allItems) i.id: i};

        // Check for cycles using DFS
        for (final item in allItems) {
          final visited = <String>{};
          final recursionStack = <String>{};

          bool hasCycle(String currentId) {
            visited.add(currentId);
            recursionStack.add(currentId);

            final current = itemMap[currentId];
            if (current != null) {
              for (final prereq in current.prerequisites) {
                if (!visited.contains(prereq)) {
                  if (hasCycle(prereq)) return true;
                } else if (recursionStack.contains(prereq)) {
                  return true; // Cycle detected
                }
              }
            }

            recursionStack.remove(currentId);
            return false;
          }

          expect(hasCycle(item.id), isFalse, reason: 'Cycle detected in $track at item ${item.id}');
        }
      }
    });

    test('All prerequisites precede dependent items in topological sequence', () async {
      final profile = PersonalizedProfile(
        academicStage: AcademicStage.secondYear,
        goals: const ['Placement'],
        careerDirections: const ['Full Stack Developer'],
        primaryCareerDirection: 'Full Stack Developer',
        primaryLanguage: 'JavaScript',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final roadmap = await generator.generateRoadmap(profile: profile);
      final itemIndex = <String, int>{};
      int index = 0;
      for (final item in roadmap.allItems) {
        itemIndex[item.id] = index++;
      }

      for (final item in roadmap.allItems) {
        for (final prereqId in item.prerequisites) {
          final prereqIdx = itemIndex[prereqId];
          final itemIdx = itemIndex[item.id];
          expect(prereqIdx, isNotNull);
          expect(prereqIdx!, lessThan(itemIdx!),
              reason: 'Prerequisite $prereqId must precede ${item.id}');
        }
      }
    });
  });

  group('Personalized Roadmap Provider & UI Responsiveness Audit', () {
    testWidgets('MyRoadmapScreen renders responsive layout on 320px, 360px, 412px and desktop', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final provider = RoadmapProvider();
      await Future.delayed(const Duration(milliseconds: 50));

      final profile = PersonalizedProfile(
        academicStage: AcademicStage.thirdYear,
        goals: const ['Placement'],
        careerDirections: const ['AI Engineer'],
        primaryCareerDirection: 'AI Engineer',
        primaryLanguage: 'Python',
        dailyLearningTimeMinutes: 60,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await provider.generatePersonalizedRoadmap(profile);

      for (final size in [
        const Size(320, 600), // Small phone (320px)
        const Size(360, 740), // Standard Android (360px)
        const Size(412, 915), // Pixel / Modern phone (412px)
        const Size(800, 1024), // Tablet
        const Size(1200, 800), // Desktop
      ]) {
        tester.binding.setSurfaceSize(size);

        await tester.pumpWidget(
          ChangeNotifierProvider<RoadmapProvider>.value(
            value: provider,
            child: const MaterialApp(
              home: MyRoadmapScreen(),
            ),
          ),
        );

        await tester.pump();

        // Check header title
        expect(find.textContaining('AI Engineer'), findsWidgets);
        expect(find.text("Today's Learning Plan"), findsOneWidget);
        expect(find.text('Roadmap Learning Phases'), findsOneWidget);

        // Verify no RenderFlex overflows
        expect(tester.takeException(), isNull);
      }

      await tester.pumpWidget(const SizedBox());
      tester.binding.setSurfaceSize(null);
    });
  });
}

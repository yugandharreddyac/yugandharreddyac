import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csse_study_hub/data/models/hierarchy_node_model.dart';
import 'package:csse_study_hub/data/models/resource_model.dart';
import 'package:csse_study_hub/data/datasources/search_index_engine.dart';
import 'package:csse_study_hub/data/datasources/local_storage_datasource.dart';
import 'package:csse_study_hub/data/repositories/non_academic_repository.dart';
import 'package:csse_study_hub/presentation/providers/bookmark_provider.dart';
import 'package:csse_study_hub/presentation/providers/recent_provider.dart';

void main() {
  group('Non-Academic Hierarchy Data & Repository Tests', () {
    late NonAcademicRepository repository;

    setUp(() {
      repository = NonAcademicRepository();
    });

    test('All 5 major non-academic hubs exist in dataset', () {
      final hubs = repository.getAllHubs();
      expect(hubs.length, greaterThanOrEqualTo(5));

      final hubIds = hubs.map((h) => h.id).toList();
      expect(hubIds, containsAll([
        'coding',
        'emerging_tech',
        'higher_education',
        'placement',
        'projects',
      ]));
    });

    test('Flow 1 Data Path Verification (Coding -> Python -> Beginner -> Lists -> Learn Online)', () {
      final codingHub = repository.getHubById('coding');
      expect(codingHub, isNotNull);

      final langCat = repository.getCategoryById('coding', 'programming_languages');
      expect(langCat, isNotNull);

      final pythonTopic = repository.getTopicById('coding', 'programming_languages', 'python');
      expect(pythonTopic, isNotNull);

      // Subtopics under Python -> Data Structures
      final dsTopic = pythonTopic!.subtopics.firstWhere((t) => t.id == 'python_ds');
      expect(dsTopic, isNotNull);

      // Subtopics under Data Structures -> Lists
      final listsTopic = dsTopic.subtopics.firstWhere((t) => t.id == 'python_ds_lists');
      expect(listsTopic, isNotNull);

      // Verify Learn Online resource exists under Lists
      final learnOnlineRes = listsTopic.resources.firstWhere(
        (r) => r.type == HierarchyResourceType.learnOnline,
      );
      expect(learnOnlineRes, isNotNull);
      expect(learnOnlineRes.url, isNotEmpty);
      expect(learnOnlineRes.url, startsWith('http'));
    });

    test('Flow 2 Data Path Verification (Emerging Tech -> AI -> ML -> Beginner -> Learn Online)', () {
      final emergingHub = repository.getHubById('emerging_tech');
      expect(emergingHub, isNotNull);

      final aiCat = repository.getCategoryById('emerging_tech', 'ai_ml');
      expect(aiCat, isNotNull);

      final mlTopic = repository.getTopicById('emerging_tech', 'ai_ml', 'machine_learning');
      expect(mlTopic, isNotNull);

      final mlIntro = mlTopic!.subtopics.firstWhere((t) => t.id == 'ml_intro_beginner');
      expect(mlIntro, isNotNull);

      final learnOnlineRes = mlIntro.resources.firstWhere(
        (r) => r.type == HierarchyResourceType.learnOnline,
      );
      expect(learnOnlineRes, isNotNull);
      expect(learnOnlineRes.url, isNotEmpty);
    });

    test('Flow 3 Data Path Verification (Placement -> Tech Prep -> DSA -> Practice)', () {
      final placementHub = repository.getHubById('placement');
      expect(placementHub, isNotNull);

      final techCat = repository.getCategoryById('placement', 'tech_prep');
      expect(techCat, isNotNull);

      final dsaTopic = repository.getTopicById('placement', 'tech_prep', 'placement_dsa');
      expect(dsaTopic, isNotNull);

      final dsaTopTopic = dsaTopic!.subtopics.firstWhere((t) => t.id == 'dsa_top_interview_topic');
      expect(dsaTopTopic, isNotNull);

      final practiceRes = dsaTopTopic.resources.firstWhere(
        (r) => r.type == HierarchyResourceType.practice,
      );
      expect(practiceRes, isNotNull);
      expect(practiceRes.url, isNotEmpty);
    });

    test('Start Here Stepper steps exist for Coding & Emerging Tech hubs', () {
      final codingHub = repository.getHubById('coding');
      expect(codingHub!.hasStartHere, isTrue);
      expect(codingHub.startHereSteps!.length, greaterThanOrEqualTo(5));

      final emergingHub = repository.getHubById('emerging_tech');
      expect(emergingHub!.hasStartHere, isTrue);
    });

    test('Phase 7: SearchIndexEngine indexes all 5 non-academic hubs & search queries work', () {
      final engine = SearchIndexEngine();
      engine.buildIndex([], []);

      expect(engine.isIndexed, isTrue);

      // Search 1: Coding (Python)
      final pythonResult = engine.search('Python');
      expect(pythonResult.matchingItems.any((i) => i.title.contains('Python') || i.keywords.contains('Python')), isTrue);

      // Search 2: Emerging Tech (Machine Learning)
      final mlResult = engine.search('Machine Learning');
      expect(mlResult.matchingItems.any((i) => i.title.contains('Machine Learning') || i.subtitle.contains('Emerging')), isTrue);

      // Search 3: Higher Education (GATE)
      final gateResult = engine.search('GATE');
      expect(gateResult.matchingItems.any((i) => i.title.contains('GATE') || i.keywords.contains('GATE')), isTrue);

      // Search 4: Placement (Array Basics / Aptitude)
      final aptitudeResult = engine.search('Aptitude');
      expect(aptitudeResult.matchingItems.any((i) => i.title.contains('Aptitude') || i.keywords.contains('Aptitude')), isTrue);

      // Search 5: Projects & Practice (To-Do List)
      final todoResult = engine.search('To-Do List');
      expect(todoResult.matchingItems.any((i) => i.title.contains('To-Do') || i.keywords.contains('To-Do List')), isTrue);
    });

    test('Phase 7: BookmarkProvider & RecentProvider support non-academic items without breaking Academic items', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = LocalStorageDataSource(prefs);
      final bookmarkProvider = BookmarkProvider(storage);
      final recentProvider = RecentProvider(storage);

      // 1. Non-academic Bookmark test
      final testRes = ResourceModel(
        id: 'res_python_basics_test',
        title: 'Python Language Basics',
        description: 'Non-academic coding tutorial',
        subjectId: 'coding',
        subjectName: 'Coding Hub › Programming Languages',
        yearId: 'non_academic',
        semesterId: 'non_academic',
        resourceType: 'Learn Online',
        storageUrl: 'https://docs.python.org/3/',
        fileSizeBytes: 0,
        lastUpdated: DateTime.now(),
      );

      await bookmarkProvider.toggleBookmark(testRes);
      expect(bookmarkProvider.isBookmarked('res_python_basics_test'), isTrue);
      await bookmarkProvider.toggleBookmark(testRes); // toggle off
      expect(bookmarkProvider.isBookmarked('res_python_basics_test'), isFalse);

      // 2. Non-academic Recent view test
      await recentProvider.recordResourceOpened(testRes);
      expect(recentProvider.recentResources.any((r) => r.resourceId == 'res_python_basics_test'), isTrue);

      // 3. Academic regression test
      final academicRes = ResourceModel(
        id: 'res_c_pointers_acad',
        title: 'C Programming Pointers PDF',
        description: 'Academic Unit 4 Notes',
        subjectId: 'CS1104',
        subjectName: 'C Programming',
        yearId: 'year_1',
        semesterId: 'sem_1_1',
        resourceType: 'Notes',
        storageUrl: 'https://raw.githubusercontent.com/flutter/pdf_viewer/main/test.pdf',
        fileSizeBytes: 1024567,
        lastUpdated: DateTime.now(),
      );

      await bookmarkProvider.toggleBookmark(academicRes);
      expect(bookmarkProvider.isBookmarked('res_c_pointers_acad'), isTrue);
      await recentProvider.recordResourceOpened(academicRes);
      expect(recentProvider.recentResources.any((r) => r.resourceId == 'res_c_pointers_acad'), isTrue);
    });

    test('Phase 9: Complete Content Quality & Data Consistency Audit Across All Hubs', () {
      final hubs = repository.getAllHubs();
      expect(hubs.length, greaterThanOrEqualTo(5));

      final Set<String> globalIds = {};

      void checkTopic(HierarchicalTopicModel topic) {
        expect(topic.id, isNotEmpty);
        expect(globalIds.contains(topic.id), isFalse, reason: 'Duplicate topic ID found: ${topic.id}');
        globalIds.add(topic.id);

        expect(topic.title, isNotEmpty);
        expect(topic.description, isNotEmpty);

        for (final res in topic.resources) {
          expect(res.id, isNotEmpty);
          expect(globalIds.contains(res.id), isFalse, reason: 'Duplicate resource ID found: ${res.id}');
          globalIds.add(res.id);

          expect(res.title, isNotEmpty);
          expect(res.url, isNotEmpty);
          expect(res.url.startsWith('http://') || res.url.startsWith('https://'), isTrue, reason: 'Invalid URL format: ${res.url}');
        }

        for (final sub in topic.subtopics) {
          checkTopic(sub);
        }
      }

      for (final hub in hubs) {
        expect(hub.id, isNotEmpty);
        expect(globalIds.contains(hub.id), isFalse, reason: 'Duplicate hub ID found: ${hub.id}');
        globalIds.add(hub.id);

        expect(hub.title, isNotEmpty);
        expect(hub.description, isNotEmpty);

        // Verify Start Here Steps
        if (hub.hasStartHere) {
          for (final step in hub.startHereSteps!) {
            expect(step.title, isNotEmpty);
            expect(step.description, isNotEmpty);
            if (step.targetCategoryId != null) {
              expect(
                hub.categories.any((cat) => cat.id == step.targetCategoryId),
                isTrue,
                reason: 'StartHereStep targetCategoryId "${step.targetCategoryId}" does not exist in hub "${hub.id}"',
              );
            }
          }
        }

        // Verify Categories
        for (final cat in hub.categories) {
          expect(cat.id, isNotEmpty);
          expect(globalIds.contains(cat.id), isFalse, reason: 'Duplicate category ID found: ${cat.id}');
          globalIds.add(cat.id);

          expect(cat.title, isNotEmpty);
          expect(cat.description, isNotEmpty);

          for (final topic in cat.topics) {
            checkTopic(topic);
          }
        }
      }

      // Assert total unique IDs tracked across non-academic dataset
      expect(globalIds.length, greaterThan(100));
    });
  });
}

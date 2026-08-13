import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/datasources/non_academic_data.dart';
import 'package:csse_study_hub/data/datasources/search_index_engine.dart';
import 'package:csse_study_hub/data/models/hierarchy_node_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 7G - DSA Hub Tests', () {
    final codingHub = NonAcademicData.codingHub;
    final dsaCategory = codingHub.categories.firstWhere((c) => c.id == 'dsa');

    test('DSA Category exists with required stable topic IDs', () {
      expect(dsaCategory, isNotNull);
      expect(dsaCategory.title, contains('Data Structures'));

      const stableIds = [
        'dsa_complexity',
        'dsa_arrays',
        'dsa_linked_list',
        'dsa_stacks_queues',
        'dsa_trees',
        'dsa_graphs',
        'dsa_dp',
      ];

      final topicIds = dsaCategory.topics.map((t) => t.id).toList();
      for (final id in stableIds) {
        expect(topicIds, contains(id), reason: 'Stable ID $id must be preserved');
      }
    });

    test('All DSA topics have comprehensive descriptions (>150 chars) and resources', () {
      for (final topic in dsaCategory.topics) {
        expect(topic.description.length, greaterThan(150),
            reason: 'Topic ${topic.id} description must be detailed and beginner-friendly');

        expect(topic.resources.length, greaterThanOrEqualTo(4),
            reason: 'Topic ${topic.id} must have at least 4 resources');

        for (final res in topic.resources) {
          expect(res.url.startsWith('https://'), isTrue,
              reason: 'Resource ${res.id} URL must start with https://');
        }
      }
    });

    test('DSA topics contain subtopics for granular progression', () {
      final subtopicCount = dsaCategory.topics
          .fold<int>(0, (sum, topic) => sum + (topic.subtopics?.length ?? 0));
      expect(subtopicCount, greaterThanOrEqualTo(7),
          reason: 'DSA Hub must contain structured subtopics');
    });
  });

  group('Phase 7G - Emerging Technologies Hub Tests', () {
    final emergingTechHub = NonAcademicData.emergingTechHub;

    test('Emerging Tech Hub has required categories & preserved stable IDs', () {
      expect(emergingTechHub.id, equals('emerging_tech'));
      expect(emergingTechHub.categories.length, greaterThanOrEqualTo(6));

      const stableIds = [
        'machine_learning',
        'deep_learning',
        'genai_llms',
        'aws_basics',
        'devops_docker',
        'cyber_intro',
      ];

      final allTopics = emergingTechHub.categories.expand((c) => c.topics).toList();
      final allTopicIds = allTopics.map((t) => t.id).toList();

      for (final id in stableIds) {
        expect(allTopicIds, contains(id), reason: 'Stable ID $id must be preserved in Emerging Tech');
      }
    });

    test('All Emerging Tech topics have resources, valid HTTPS links & practice/projects', () {
      final allTopics = emergingTechHub.categories.expand((c) => c.topics).toList();

      for (final topic in allTopics) {
        expect(topic.description.length, greaterThan(150),
            reason: 'Topic ${topic.id} description must be beginner-first & comprehensive');

        expect(topic.resources.length, greaterThanOrEqualTo(4),
            reason: 'Topic ${topic.id} must have at least 4 resources');

        final hasPractice = topic.resources.any((r) => r.type == HierarchyResourceType.practice);
        final hasProject = topic.resources.any((r) => r.type == HierarchyResourceType.project);

        expect(hasPractice, isTrue, reason: 'Topic ${topic.id} must have practice resources');
        expect(hasProject, isTrue, reason: 'Topic ${topic.id} must have project resources');

        for (final res in topic.resources) {
          expect(res.url.startsWith('https://'), isTrue,
              reason: 'Resource ${res.id} URL must start with https://');
        }
      }
    });
  });

  group('Phase 7G - SearchIndexEngine Integration', () {
    test('SearchIndexEngine indexes all DSA and Emerging Tech items', () {
      final searchEngine = SearchIndexEngine();
      searchEngine.buildIndex([], []);

      expect(searchEngine.isIndexed, isTrue);

      final searchResults = searchEngine.search('Dynamic Programming');
      expect(searchResults, isNotEmpty, reason: 'Search should find Dynamic Programming');

      final aiResults = searchEngine.search('Machine Learning');
      expect(aiResults, isNotEmpty, reason: 'Search should find Machine Learning');

      final dockerResults = searchEngine.search('Docker');
      expect(dockerResults, isNotEmpty, reason: 'Search should find Docker');
    });
  });
}

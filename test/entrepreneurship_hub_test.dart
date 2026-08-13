import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/datasources/non_academic_data.dart';
import 'package:csse_study_hub/data/datasources/search_index_engine.dart';
import 'package:csse_study_hub/data/models/hierarchy_node_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Entrepreneurship Hub Unit & Integration Tests', () {
    final hub = NonAcademicData.entrepreneurshipHub;

    test('Entrepreneurship Hub exists with correct metadata and routes', () {
      expect(hub, isNotNull);
      expect(hub.id, equals('entrepreneurship'));
      expect(hub.title, contains('Entrepreneurship'));
      expect(hub.routeName, equals('/entrepreneurship'));
      expect(hub.categories, isNotEmpty);
      expect(hub.categories.length, equals(7));
      expect(hub.startHereSteps, isNotEmpty);
    });

    test('All 7 Entrepreneurship categories exist with stable IDs', () {
      final categoryIds = hub.categories.map((c) => c.id).toList();
      expect(categoryIds, containsAll([
        'startup_ideation',
        'market_customer',
        'business_models',
        'lean_startup',
        'startup_finance',
        'fundraising_pitch',
        'student_startups',
      ]));
    });

    test('Preserves stable topic IDs and maps all 13 beginner-first topics', () {
      final allTopics = hub.categories.expand((c) => c.topics).toList();
      final topicIds = allTopics.map((t) => t.id).toList();

      // Stable IDs that MUST be preserved for Roadmap/Career providers
      expect(topicIds, contains('problem_discovery'));
      expect(topicIds, contains('mvp_development'));
      expect(topicIds, contains('pitch_decks'));

      // New educational topics
      expect(topicIds, containsAll([
        'entrepreneurship_basics',
        'idea_generation',
        'market_research_basics',
        'value_proposition_design',
        'business_model_canvas',
        'validation_experimentation',
        'startup_finance_basics',
        'growth_marketing',
        'student_entrepreneurship',
        'four_year_startup_roadmap',
      ]));

      expect(allTopics.length, equals(13));
    });

    test('Preserves subtopic IDs including customer_interviews', () {
      final allSubtopics = hub.categories
          .expand((c) => c.topics)
          .expand((t) => t.subtopics)
          .toList();
      final subtopicIds = allSubtopics.map((s) => s.id).toList();

      expect(subtopicIds, contains('customer_interviews'));
      expect(subtopicIds, contains('nine_canvas_blocks'));
      expect(subtopicIds, contains('tam_sam_som_explained'));
      expect(subtopicIds, contains('unit_economics_cac_ltv'));
      expect(subtopicIds, contains('ten_slide_pitch_deck'));
    });

    test('Topic descriptions are comprehensive and >150 characters', () {
      final allTopics = hub.categories.expand((c) => c.topics).toList();

      for (final topic in allTopics) {
        expect(
          topic.description.length,
          greaterThan(150),
          reason: 'Topic ${topic.id} description must be >150 chars for educational clarity.',
        );
      }
    });

    test('All external resources use valid HTTPS schemes with no empty URLs', () {
      final allResources = hub.categories
          .expand((c) => c.topics)
          .expand((t) => [
                ...t.resources,
                ...t.subtopics.expand((s) => s.resources),
              ])
          .toList();

      expect(allResources, isNotEmpty);

      for (final resource in allResources) {
        expect(resource.title, isNotEmpty);
        expect(resource.description, isNotEmpty);
        expect(resource.url, startsWith('https://'));
        expect(resource.platform, isNotEmpty);
      }
    });

    test('Practice and project resources exist across all Entrepreneurship categories', () {
      for (final category in hub.categories) {
        final categoryResources = category.topics.expand((t) => [
              ...t.resources,
              ...t.subtopics.expand((s) => s.resources),
            ]).toList();

        final hasPractice = categoryResources.any((r) => r.type == HierarchyResourceType.practice);
        final hasProject = categoryResources.any((r) => r.type == HierarchyResourceType.project);

        expect(
          hasPractice,
          isTrue,
          reason: 'Category ${category.id} must contain practice resources.',
        );
        expect(
          hasProject,
          isTrue,
          reason: 'Category ${category.id} must contain project/build resources.',
        );
      }
    });

    test('SearchIndexEngine indexes Entrepreneurship Hub topics and matches search terms', () async {
      final engine = SearchIndexEngine();
      engine.buildIndex([], []);

      expect(engine.isIndexed, isTrue);

      final startupResult = engine.search('Startup');
      expect(startupResult.matchingItems.any((i) => i.title.contains('Startup') || i.subtitle.contains('Startup') || i.keywords.any((k) => k.contains('Startup'))), isTrue);

      final mvpResult = engine.search('MVP');
      expect(mvpResult.matchingItems.any((i) => i.title.contains('MVP') || i.subtitle.contains('MVP') || i.keywords.any((k) => k.contains('MVP'))), isTrue);

      final tamResult = engine.search('TAM');
      expect(tamResult.matchingItems.any((i) => i.title.contains('TAM') || i.subtitle.contains('TAM') || i.keywords.any((k) => k.contains('TAM'))), isTrue);

      final pitchResult = engine.search('Pitch');
      expect(pitchResult.matchingItems.any((i) => i.title.contains('Pitch') || i.subtitle.contains('Pitch') || i.keywords.any((k) => k.contains('Pitch'))), isTrue);
    });
  });
}

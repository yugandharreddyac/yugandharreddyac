import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/repositories/emerging_tech_repository.dart';
import 'package:csse_study_hub/presentation/providers/emerging_tech_provider.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/datasources/search_index_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseDataSource firebaseDataSource;
  late EmergingTechRepository emergingTechRepository;
  late EmergingTechProvider emergingTechProvider;

  setUp(() {
    firebaseDataSource = FirebaseDataSource();
    emergingTechRepository =
        EmergingTechRepository(firebaseDataSource: firebaseDataSource);
    emergingTechProvider = EmergingTechProvider(emergingTechRepository);
  });

  group('Emerging Technologies Hub Unit Tests', () {
    test('getEmergingTechs returns structured technologies catalog', () async {
      final techs = await emergingTechRepository.getEmergingTechs();
      expect(techs, isNotEmpty);
      expect(techs.any((t) => t.title.contains('Generative AI')), isTrue);
      expect(techs.any((t) => t.title.contains('Cloud')), isTrue);
    });

    test(
        'EmergingTechProvider filters technologies by category and search query',
        () async {
      await emergingTechProvider.fetchEmergingTechs();
      expect(emergingTechProvider.items, isNotEmpty);

      emergingTechProvider.setSearchQuery('Generative');
      expect(
          emergingTechProvider.filteredItems
              .any((t) => t.title.contains('Generative AI')),
          isTrue);

      emergingTechProvider.setSearchQuery('');
      emergingTechProvider.selectCategory('Artificial Intelligence');
      expect(
          emergingTechProvider.filteredItems
              .every((t) => t.category == 'Artificial Intelligence'),
          isTrue);
    });

    test('SearchIndexEngine indexes Emerging Tech entities', () async {
      final engine = SearchIndexEngine();
      final techs = await emergingTechRepository.getEmergingTechs();

      engine.buildIndex(
        [],
        [],
        emergingTechs: techs,
      );

      expect(engine.isIndexed, isTrue);

      final genAiRes = engine.search('Generative');
      expect(
          genAiRes.matchingItems.any((i) => i.title.contains('Generative AI')),
          isTrue);

      final cloudRes = engine.search('Cloud');
      expect(
          cloudRes.matchingItems.any((i) => i.title.contains('Cloud')), isTrue);
    });
  });
}

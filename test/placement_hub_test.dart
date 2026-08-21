import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/repositories/placement_repository.dart';
import 'package:csse_study_hub/presentation/providers/placement_provider.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/datasources/search_index_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseDataSource firebaseDataSource;
  late PlacementRepository placementRepository;
  late PlacementProvider placementProvider;

  setUp(() {
    firebaseDataSource = FirebaseDataSource();
    placementRepository =
        PlacementRepository(firebaseDataSource: firebaseDataSource);
    placementProvider = PlacementProvider(placementRepository);
  });

  group('Placement Hub Unit Tests', () {
    test('getPlacementResources returns structured placement items', () async {
      final resources = await placementRepository.getPlacementResources();
      expect(resources, isNotEmpty);
      expect(resources.any((r) => r.category == 'Aptitude'), isTrue);
      expect(resources.any((r) => r.category == 'Technical Interview'), isTrue);
    });

    test('PlacementProvider filters placement modules by category', () async {
      await placementProvider.fetchPlacementResources();
      expect(placementProvider.resources, isNotEmpty);

      const cat = 'Aptitude';
      placementProvider.selectCategory(cat);
      expect(
          placementProvider.filteredResources.every((r) => r.category == cat),
          isTrue);
    });

    test('SearchIndexEngine indexes Placement Hub entities', () async {
      final engine = SearchIndexEngine();
      final placements = await placementRepository.getPlacementResources();

      engine.buildIndex(
        [],
        [],
        placements: placements,
      );

      expect(engine.isIndexed, isTrue);

      final aptResult = engine.search('aptitude');
      expect(aptResult.matchingItems.isNotEmpty, isTrue);
    });
  });
}

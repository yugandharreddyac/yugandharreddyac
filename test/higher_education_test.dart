import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/repositories/higher_education_repository.dart';
import 'package:csse_study_hub/presentation/providers/higher_education_provider.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/datasources/search_index_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseDataSource firebaseDataSource;
  late HigherEducationRepository higherEducationRepository;
  late HigherEducationProvider higherEducationProvider;

  setUp(() {
    firebaseDataSource = FirebaseDataSource();
    higherEducationRepository =
        HigherEducationRepository(firebaseDataSource: firebaseDataSource);
    higherEducationProvider =
        HigherEducationProvider(higherEducationRepository);
  });

  group('Higher Education Hub Unit Tests', () {
    test('getHigherEducationResources returns GATE & GRE resources', () async {
      final resources =
          await higherEducationRepository.getHigherEducationResources();
      expect(resources, isNotEmpty);
      expect(resources.any((r) => r.title.contains('GATE')), isTrue);
      expect(resources.any((r) => r.title.contains('GRE')), isTrue);
    });

    test('HigherEducationProvider populates higherEducationItems', () async {
      await higherEducationProvider.fetchHigherEducationResources();
      expect(higherEducationProvider.higherEducationItems, isNotEmpty);
    });

    test('SearchIndexEngine indexes Higher Education entities', () async {
      final engine = SearchIndexEngine();
      final resources =
          await higherEducationRepository.getHigherEducationResources();

      engine.buildIndex(
        [],
        [],
        higherEdItems: resources,
      );

      expect(engine.isIndexed, isTrue);

      final gateResult = engine.search('GATE');
      expect(gateResult.matchingItems.any((i) => i.title.contains('GATE')),
          isTrue);
    });
  });
}

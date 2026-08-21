import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/repositories/coding_repository.dart';
import 'package:csse_study_hub/presentation/providers/coding_provider.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/datasources/search_index_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseDataSource firebaseDataSource;
  late CodingRepository codingRepository;
  late CodingProvider codingProvider;

  setUp(() {
    firebaseDataSource = FirebaseDataSource();
    codingRepository = CodingRepository(firebaseDataSource: firebaseDataSource);
    codingProvider = CodingProvider(codingRepository);
  });

  group('Coding Hub Unit Tests', () {
    test('getCodingLanguages returns structured programming languages',
        () async {
      final langs = await codingRepository.getCodingLanguages();
      expect(langs, isNotEmpty);
      expect(langs.any((l) => l.name.contains('Python')), isTrue);
      expect(langs.any((l) => l.name.contains('C++')), isTrue);
    });

    test('getDsaTopics returns DSA topic explanations', () async {
      final topics = await codingRepository.getDsaTopics();
      expect(topics, isNotEmpty);
      expect(topics.any((t) => t.topicName.contains('Array')), isTrue);
      expect(topics.any((t) => t.topicName.contains('Dynamic Programming')),
          isTrue);
    });

    test('getCodingProjects returns industry project blueprints', () async {
      final projects = await codingRepository.getCodingProjects();
      expect(projects, isNotEmpty);
      expect(projects.first.architecture, isNotEmpty);
      expect(projects.first.folderStructure, isNotEmpty);
    });

    test('CodingProvider fetchCodingResources populates state', () async {
      await codingProvider.fetchCodingResources();
      expect(codingProvider.languages, isNotEmpty);
      expect(codingProvider.dsaTopics, isNotEmpty);
      expect(codingProvider.codingProjects, isNotEmpty);
    });

    test('SearchIndexEngine indexes Coding Hub entities', () async {
      final engine = SearchIndexEngine();
      final langs = await codingRepository.getCodingLanguages();
      final dsa = await codingRepository.getDsaTopics();
      final projs = await codingRepository.getCodingProjects();

      engine.buildIndex(
        [],
        [],
        codingLangs: langs,
        dsaTopics: dsa,
        codingProjects: projs,
      );

      expect(engine.isIndexed, isTrue);
      final pyResult = engine.search('Python');
      expect(pyResult.matchingItems.any((i) => i.title.contains('Python')),
          isTrue);
    });
  });
}

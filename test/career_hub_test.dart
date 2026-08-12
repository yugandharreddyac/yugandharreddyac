import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/repositories/career_repository.dart';
import 'package:csse_study_hub/presentation/providers/career_provider.dart';
import 'package:csse_study_hub/data/datasources/search_index_engine.dart';

void main() {
  group('Career Hub Unit Tests', () {
    final mockFirebaseDataSource = FirebaseDataSource();

    test('getCareerTechnologies returns structured career paths', () async {
      final repo = CareerRepository(firebaseDataSource: mockFirebaseDataSource);
      final careerList = await repo.getCareerTechnologies();

      expect(careerList.isNotEmpty, true);
      expect(careerList.any((c) => c.name.contains('Artificial Intelligence')), true);

      final aiCareer = careerList.firstWhere((c) => c.name.contains('Artificial Intelligence'));
      expect(aiCareer.introduction.isNotEmpty, true);
      expect(aiCareer.whyLearn.isNotEmpty, true);
    });

    test('CareerProvider filters career technologies by category', () async {
      final repo = CareerRepository(firebaseDataSource: mockFirebaseDataSource);
      final provider = CareerProvider(repo);

      await provider.fetchCareerTechnologies();
      expect(provider.technologies.isNotEmpty, true);

      final initialCount = provider.filteredTechnologies.length;
      final category = provider.categories.firstWhere((cat) => cat != 'All', orElse: () => 'All');

      provider.selectCategory(category);
      if (category != 'All') {
        expect(provider.filteredTechnologies.length <= initialCount, true);
      }
    });

    test('SearchIndexEngine indexes Career Hub entities', () async {
      final repo = CareerRepository(firebaseDataSource: mockFirebaseDataSource);
      final careerList = await repo.getCareerTechnologies();
      final engine = SearchIndexEngine();

      engine.buildIndex(
        [],
        [],
        careerTechs: careerList,
      );

      final results = engine.search('Artificial Intelligence');
      expect(results.matchingItems.isNotEmpty, true);
      expect(results.matchingItems.any((r) => r.title.contains('Artificial Intelligence')), true);
    });
  });
}

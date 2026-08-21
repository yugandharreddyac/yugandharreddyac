import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/datasources/local_storage_datasource.dart';
import 'package:csse_study_hub/data/repositories/study_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StudyRepository repository;
  late LocalStorageDataSource localStorage;
  late FirebaseDataSource firebaseDataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    localStorage = LocalStorageDataSource(prefs);
    firebaseDataSource = FirebaseDataSource();
    repository = StudyRepository(
      firebaseDataSource: firebaseDataSource,
      localStorageDataSource: localStorage,
    );
  });

  group('StudyRepository Unit Tests', () {
    test('getYears returns 4 academic years by default', () async {
      final years = await repository.getYears();
      expect(years.length, equals(4));
      expect(years.first.title, equals('1st Year'));
      expect(years.last.title, equals('4th Year'));
    });

    test('getSemesters for year_1 returns 2 semesters', () async {
      final semesters = await repository.getSemesters('year_1');
      expect(semesters.length, equals(2));
      expect(semesters.first.title, equals('1-1 Semester'));
    });

    test('getSubjects for sem_1_1 returns Green Chemistry and C Programming',
        () async {
      final subjects = await repository.getSubjects('sem_1_1');
      expect(subjects.length, equals(5));
      expect(subjects.any((s) => s.name.contains('Green Chemistry')), isTrue);
      expect(
          subjects.any((s) => s.name.contains('Computer Programming')), isTrue);
    });

    test('getSubjects for sem_2_1 returns Java and Operating Systems',
        () async {
      final subjects = await repository.getSubjects('sem_2_1');
      expect(subjects.length, equals(5));
      expect(subjects.any((s) => s.name.contains('Java')), isTrue);
      expect(subjects.any((s) => s.name.contains('Operating Systems')), isTrue);
    });

    test('searchGlobalAll matches partial text for Oper, Cloud, and Algo',
        () async {
      final operResults = await repository.searchGlobalAll('Oper');
      expect(operResults.matchingSubjects.isNotEmpty, isTrue);
      expect(
          operResults.matchingSubjects
              .any((s) => s.name == 'Operating Systems'),
          isTrue);

      final cloudResults = await repository.searchGlobalAll('Cloud');
      expect(cloudResults.matchingSubjects.isNotEmpty, isTrue);
      expect(
          cloudResults.matchingSubjects.any((s) => s.name == 'Cloud Computing'),
          isTrue);

      final algoResults = await repository.searchGlobalAll('Algo');
      expect(algoResults.matchingSubjects.isNotEmpty, isTrue);
      expect(
          algoResults.matchingSubjects
              .any((s) => s.name == 'Design and Analysis of Algorithms'),
          isTrue);
    });

    test(
        'searchGlobalAll finds breadth first search topic and embeds deep navigation metadata',
        () async {
      final results = await repository.searchGlobalAll('breadth first search');
      expect(results.matchingItems.isNotEmpty, isTrue);

      final topicItem = results.matchingItems
          .firstWhere((item) => item.title.contains('Breadth First Search'));
      expect(topicItem.topicModel, isNotNull);
      expect(topicItem.topicModel!.title, equals('Breadth First Search (BFS)'));
      expect(topicItem.subjectName, equals('Artificial Intelligence'));
      expect(topicItem.chapterTitle, contains('Search'));
    });

    test('searchGlobalAll handles empty and whitespace queries gracefully',
        () async {
      final emptyResults = await repository.searchGlobalAll('');
      expect(emptyResults.matchingItems.isEmpty, isTrue);

      final whitespaceResults = await repository.searchGlobalAll('   ');
      expect(whitespaceResults.matchingItems.isEmpty, isTrue);
    });
  });
}

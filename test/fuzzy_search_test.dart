import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/core/utils/fuzzy_matcher.dart';
import 'package:csse_study_hub/data/datasources/search_index_engine.dart';
import 'package:csse_study_hub/data/datasources/mock_data.dart';
import 'package:csse_study_hub/data/models/searchable_item.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FuzzyMatcher Utility Tests', () {
    test('Levenshtein distance calculation is accurate', () {
      expect(FuzzyMatcher.levenshteinDistance('kitten', 'sitting'), equals(3));
      expect(FuzzyMatcher.levenshteinDistance('python', 'pythn'), equals(1));
      expect(FuzzyMatcher.levenshteinDistance('dijkstra', 'diijkstra'), equals(1));
      expect(FuzzyMatcher.levenshteinDistance('database', 'databse'), equals(1));
      expect(FuzzyMatcher.levenshteinDistance('same', 'same'), equals(0));
      expect(FuzzyMatcher.levenshteinDistance('', 'test'), equals(4));
    });

    test('Similarity calculation produces normalized score between 0.0 and 1.0', () {
      expect(FuzzyMatcher.similarity('python', 'python'), equals(1.0));
      expect(FuzzyMatcher.similarity('python', 'pythn'), greaterThan(0.80));
      expect(FuzzyMatcher.similarity('dijkstra', 'diijkstra'), greaterThan(0.85));
      expect(FuzzyMatcher.similarity('abc', 'xyz'), equals(0.0));
    });

    test('isFuzzyMatch identifies typos within threshold', () {
      expect(FuzzyMatcher.isFuzzyMatch('pythn', 'Python Programming'), isTrue);
      expect(FuzzyMatcher.isFuzzyMatch('diijkstra', 'Dijkstra Algorithm'), isTrue);
      expect(FuzzyMatcher.isFuzzyMatch('databse', 'Database Management'), isTrue);
      expect(FuzzyMatcher.isFuzzyMatch('operatng', 'Operating Systems'), isTrue);
      expect(FuzzyMatcher.isFuzzyMatch('xyzqwe', 'Database Systems'), isFalse);
    });

    test('expandAbbreviations returns candidate expansions for known CS terms', () {
      expect(FuzzyMatcher.expandAbbreviations('os'), contains('operating system'));
      expect(FuzzyMatcher.expandAbbreviations('dbms'), contains('database management system'));
      expect(FuzzyMatcher.expandAbbreviations('dld'), contains('digital logic design'));
      expect(FuzzyMatcher.expandAbbreviations('cn'), contains('computer networks'));
      expect(FuzzyMatcher.expandAbbreviations('ai'), contains('artificial intelligence'));
      expect(FuzzyMatcher.expandAbbreviations('ml'), contains('machine learning'));
      expect(FuzzyMatcher.expandAbbreviations('pyq'), contains('previous question papers'));
    });
  });

  group('Phase 1 — Fuzzy Search & Intelligent SearchIndexEngine Tests', () {
    late SearchIndexEngine engine;

    setUp(() {
      engine = SearchIndexEngine();
      engine.buildIndex(MockData.subjects, MockData.resources);
    });

    test('Exact search returns high-confidence results', () {
      final result = engine.search('Python');
      expect(result.isNotEmpty, isTrue);
      expect(result.matchingItems.any((item) => item.title.toLowerCase().contains('python')), isTrue);
    });

    test('Prefix search returns matches correctly', () {
      final result = engine.search('Pyth');
      expect(result.isNotEmpty, isTrue);
      expect(result.matchingItems.any((item) => item.title.toLowerCase().contains('python')), isTrue);
    });

    test('Partial/Substring search matches key concepts', () {
      final result = engine.search('Programming');
      expect(result.isNotEmpty, isTrue);
      expect(result.matchingItems.length, greaterThanOrEqualTo(2));
    });

    test('Typo tolerance matches misspelled words (Fuzzy Fallback)', () {
      // 1. Pythn -> Python
      final pythnResult = engine.search('Pythn');
      expect(pythnResult.isNotEmpty, isTrue);
      expect(pythnResult.matchingItems.any((i) => i.title.toLowerCase().contains('python') || i.keywords.any((k) => k.toLowerCase().contains('python'))), isTrue);

      // 2. Diijkstra -> Dijkstra
      final dijkstraResult = engine.search('Diijkstra');
      expect(dijkstraResult.isNotEmpty, isTrue);
      expect(dijkstraResult.matchingItems.any((i) => i.title.toLowerCase().contains('dijkstra') || i.keywords.any((k) => k.toLowerCase().contains('dijkstra'))), isTrue);

      // 3. Databse -> Database
      final dbResult = engine.search('Databse');
      expect(dbResult.isNotEmpty, isTrue);
      expect(dbResult.matchingItems.any((i) => i.title.toLowerCase().contains('database') || i.keywords.any((k) => k.toLowerCase().contains('database'))), isTrue);
    });

    test('Abbreviation search expands and matches CS acronyms', () {
      final osResult = engine.search('OS');
      expect(osResult.isNotEmpty, isTrue);
      expect(osResult.matchingItems.any((i) => i.subjectName.toLowerCase().contains('operating system') || i.title.toLowerCase().contains('operating system')), isTrue);

      final dbmsResult = engine.search('DBMS');
      expect(dbmsResult.isNotEmpty, isTrue);
      expect(dbmsResult.matchingItems.any((i) => i.subjectName.toLowerCase().contains('database') || i.title.toLowerCase().contains('database')), isTrue);

      final dldResult = engine.search('DLD');
      expect(dldResult.isNotEmpty, isTrue);
      expect(dldResult.matchingItems.any((i) => i.subjectName.toLowerCase().contains('digital logic') || i.title.toLowerCase().contains('digital logic')), isTrue);
    });

    test('Empty query returns empty result without throwing', () {
      final result1 = engine.search('');
      expect(result1.isEmpty, isTrue);

      final result2 = engine.search('   ');
      expect(result2.isEmpty, isTrue);
    });

    test('Non-existent query returns empty result', () {
      final result = engine.search('xyz999completelynonexistentrandomstring');
      expect(result.isEmpty, isTrue);
    });

    test('Case-insensitive search returns identical matches', () {
      final r1 = engine.search('python');
      final r2 = engine.search('PYTHON');
      final r3 = engine.search('pYtHoN');

      expect(r1.matchingItems.length, equals(r2.matchingItems.length));
      expect(r2.matchingItems.length, equals(r3.matchingItems.length));
    });

    test('Ranking prioritizes exact match over fuzzy match', () {
      final item1 = SearchableItem(
        id: '1',
        category: 'Subject',
        title: 'Python Programming',
        subtitle: 'Core',
        subjectName: 'Python Programming',
        subjectCode: 'CS101',
        semester: '1',
        year: '1',
      );

      final item2 = SearchableItem(
        id: '2',
        category: 'Subject',
        title: 'Pointers in C',
        subtitle: 'Core',
        subjectName: 'C Programming',
        subjectCode: 'CS102',
        semester: '1',
        year: '1',
      );

      expect(item1.matchScore('Python'), greaterThan(item2.matchScore('Python')));
    });
  });
}

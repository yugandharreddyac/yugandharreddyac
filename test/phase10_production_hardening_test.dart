import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/datasources/academic_resource_catalog.dart';
import 'package:csse_study_hub/data/datasources/search_index_engine.dart';
import 'package:csse_study_hub/data/datasources/mock_data.dart';
import 'package:csse_study_hub/data/datasources/non_academic_data.dart';
import 'package:csse_study_hub/data/models/hierarchy_node_model.dart';
import 'package:csse_study_hub/data/repositories/pdf_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 10 — Production Hardening & Security Audit Tests', () {
    test('1. Security Scan: Zero Hardcoded Secret Credentials in Source Code',
        () {
      final libDir = Directory('lib');
      expect(libDir.existsSync(), isTrue);

      final files = libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'));
      final secretRegex = RegExp(
          r'(r2_access_key|r2_secret_key|aws_secret_access_key|private_key|api_secret)\s*=\s*["\x27][^"\x27]+["\x27]',
          caseSensitive: false);

      for (final file in files) {
        final content = file.readAsStringSync();
        expect(secretRegex.hasMatch(content), isFalse,
            reason:
                'File ${file.path} contains forbidden hardcoded secret credentials!');
      }
    });

    test(
        '2. Network Security Scan: Zero Insecure http:// URLs in Catalog & Data Models',
        () {
      final catalog = AcademicResourceCatalog.allAcademicResources;
      for (final res in catalog) {
        if (res.storageUrl.isNotEmpty) {
          expect(res.storageUrl.startsWith('https://'), isTrue,
              reason: 'Resource ${res.id} storageUrl must start with https://');
        }
      }
    });

    test('3. PDF Resource Integrity & Non-Empty Metadata Audit', () {
      final catalog = AcademicResourceCatalog.allAcademicResources;
      for (final res in catalog) {
        expect(res.id, isNotEmpty);
        expect(res.title, isNotEmpty);
        expect(res.subjectId, isNotEmpty);
        expect(res.yearId, isNotEmpty);
        expect(res.semesterId, isNotEmpty);
        expect(res.availabilityStatus,
            isIn(['available', 'coming_soon', 'external', 'unavailable']));
        expect(
            res.copyrightTier,
            isIn([
              'created_by_cssed',
              'open_licensed',
              'public_domain',
              'officially_provided',
              'external_copyrighted'
            ]));
      }
    });

    test(
        '4. PdfRepository Validation: Zero Scheme Errors & Zero Duplicate Resource IDs',
        () {
      final catalog = AcademicResourceCatalog.allAcademicResources;
      final pdfRepo = PdfRepository();
      final errors = pdfRepo.validateDocumentUrls(catalog);
      expect(errors, isEmpty,
          reason:
              'PdfRepository URL validation must return 0 scheme errors and 0 duplicate IDs');
    });

    test('5. Search Index Engine Production Load & Boundary Queries', () {
      final searchEngine = SearchIndexEngine();
      final catalog = AcademicResourceCatalog.allAcademicResources;
      searchEngine.buildIndex(MockData.subjects, catalog);

      expect(searchEngine.itemCount, greaterThan(1000));

      final cProgSearch = searchEngine.search('C Programming');
      expect(cProgSearch, isNotEmpty);

      final emptySearch = searchEngine.search('');
      expect(emptySearch, isEmpty);

      final whitespaceSearch = searchEngine.search('   ');
      expect(whitespaceSearch, isEmpty);

      final unicodeSearch = searchEngine.search(r'@#$%^&*()');
      expect(unicodeSearch, isEmpty);
    });

    test(
        '6. Academic Hierarchy Integrity Verification (4 Years, 8 Semesters, 30 Subjects)',
        () {
      expect(MockData.years.length, equals(4));
      expect(MockData.semesters.length, equals(8));
      expect(MockData.subjects.length, greaterThanOrEqualTo(30));

      final sem1Subjects =
          MockData.subjects.where((s) => s.semesterId == 'sem_1_1').toList();
      expect(sem1Subjects, isNotEmpty);

      final sem2Subjects =
          MockData.subjects.where((s) => s.semesterId == 'sem_2_1').toList();
      expect(sem2Subjects, isNotEmpty);

      final sem3Subjects =
          MockData.subjects.where((s) => s.semesterId == 'sem_3_1').toList();
      expect(sem3Subjects, isNotEmpty);
    });

    test(
        '7. Non-Academic Educational Hubs Structural Integrity Verification (72 Topics)',
        () {
      final allHubs = NonAcademicData.allHubs;
      expect(allHubs.length, equals(6));

      final allTopics = <HierarchicalTopicModel>[];
      for (final hub in allHubs) {
        for (final category in hub.categories) {
          allTopics.addAll(category.topics);
        }
      }
      expect(allTopics.length, equals(72));
    });
  });
}

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/core/config/app_config.dart';
import 'package:csse_study_hub/core/utils/r2_storage_helper.dart';
import 'package:csse_study_hub/data/datasources/academic_resource_catalog.dart';
import 'package:csse_study_hub/data/datasources/mock_data.dart';
import 'package:csse_study_hub/data/datasources/non_academic_data.dart';
import 'package:csse_study_hub/data/datasources/search_index_engine.dart';
import 'package:csse_study_hub/data/repositories/pdf_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 12 — Production Content & Release Candidate Validation Tests', () {
    final catalog = AcademicResourceCatalog.allAcademicResources;

    test('1. Production Catalog Metadata Audit & Non-Empty Descriptions', () {
      expect(catalog, isNotEmpty);
      expect(catalog.length, greaterThanOrEqualTo(7));

      for (final res in catalog) {
        expect(res.id, isNotEmpty);
        expect(res.title, isNotEmpty);
        expect(res.subjectId, isNotEmpty);
        expect(res.yearId, isNotEmpty);
        expect(res.semesterId, isNotEmpty);
        expect(res.whatIsThis, isNotNull);
        expect(res.whyUseIt, isNotNull);
      }
    });

    test('2. Production HTTPS URL Scheme Enforcement', () {
      for (final res in catalog) {
        if (res.storageUrl.isNotEmpty) {
          expect(res.storageUrl.startsWith('https://'), isTrue,
              reason: 'Resource ${res.id} must strictly use https:// scheme');
        }
      }
    });

    test('3. Copyright Safety Tier Compliance (external_copyrighted vs hosted)', () {
      for (final res in catalog) {
        expect(res.copyrightTier, isIn(['created_by_cssed', 'open_licensed', 'public_domain', 'officially_provided', 'external_copyrighted']));
        if (res.isExternalCopyrighted) {
          expect(res.isDownloadable, isFalse);
          expect(res.storageUrl.startsWith('https://'), isTrue);
        }
      }
    });

    test('4. Availability Status Classification (available vs coming_soon)', () {
      final availableCount = catalog.where((r) => r.availabilityStatus == 'available').length;
      final comingSoonCount = catalog.where((r) => r.availabilityStatus == 'coming_soon').length;

      expect(availableCount, greaterThan(0));
      expect(comingSoonCount, greaterThan(0));
    });

    test('5. PdfRepository Duplicate Resource ID & Malformed Scheme Audit', () {
      final pdfRepo = PdfRepository();
      final validationErrors = pdfRepo.validateDocumentUrls(catalog);
      expect(validationErrors, isEmpty, reason: 'Catalog must contain 0 scheme errors and 0 duplicate IDs');
    });

    test('6. Global Search Index Engine Integration with Production Resources', () {
      final searchEngine = SearchIndexEngine();
      searchEngine.buildIndex(MockData.subjects, catalog);

      expect(searchEngine.itemCount, greaterThan(1000));

      final cSearch = searchEngine.search('C Programming');
      expect(cSearch, isNotEmpty);

      final pyqSearch = searchEngine.search('PYQs');
      expect(pyqSearch, isNotEmpty);
    });

    test('7. R2StorageHelper & AppConfig Production Settings Verification', () {
      AppConfig.environment = AppEnvironment.prod;
      expect(AppConfig.cdnBaseUrl, equals('https://cdn.csse-study-hub.org/academic'));

      final path = R2StorageHelper.buildR2StoragePath(
        yearId: 'year_1',
        semesterId: 'sem_1_1',
        subjectCode: 'cs1104',
        unitId: 'unit_1',
        documentType: 'notes',
        fileName: 'c_syntax.pdf',
      );
      expect(path, equals('academic/year_1/sem_1_1/cs1104/unit_1/notes/c_syntax.pdf'));
    });

    test('8. Secret Credentials Scan: Zero hardcoded secrets in source files', () {
      final libDir = Directory('lib');
      final files = libDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
      final secretPattern = RegExp(r'(r2_access_key|r2_secret_key|aws_secret_access_key|private_key|api_secret)\s*=\s*["\x27][^"\x27]+["\x27]', caseSensitive: false);

      for (final file in files) {
        final content = file.readAsStringSync();
        expect(secretPattern.hasMatch(content), isFalse, reason: 'File ${file.path} contains forbidden hardcoded secret credentials!');
      }
    });

    test('9. Academic Hierarchy Integrity Verification (4 Years, 8 Semesters, 30 Subjects)', () {
      expect(MockData.years.length, equals(4));
      expect(MockData.semesters.length, equals(8));
      expect(MockData.subjects.length, greaterThanOrEqualTo(30));
    });

    test('10. Non-Academic Educational Hubs Structural Integrity Verification (72 Topics)', () {
      final allHubs = NonAcademicData.allHubs;
      expect(allHubs.length, equals(6));

      int topicCount = 0;
      for (final hub in allHubs) {
        for (final category in hub.categories) {
          topicCount += category.topics.length;
        }
      }
      expect(topicCount, equals(72));
    });
  });
}

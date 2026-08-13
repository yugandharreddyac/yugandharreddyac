import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/core/config/app_config.dart';
import 'package:csse_study_hub/core/utils/r2_storage_helper.dart';
import 'package:csse_study_hub/core/services/cloud_storage_health_checker.dart';
import 'package:csse_study_hub/data/datasources/academic_resource_catalog.dart';
import 'package:csse_study_hub/data/datasources/mock_data.dart';
import 'package:csse_study_hub/data/datasources/non_academic_data.dart';
import 'package:csse_study_hub/data/datasources/search_index_engine.dart';
import 'package:csse_study_hub/data/repositories/pdf_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 13 — Production Release & UI/UX Audit Tests', () {
    final catalog = AcademicResourceCatalog.allAcademicResources;

    test('1. Security Scan: Zero Hardcoded Secrets or Credentials in Source Files', () {
      final libDir = Directory('lib');
      final files = libDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
      final secretPattern = RegExp(r'(r2_access_key|r2_secret_key|aws_secret_access_key|private_key|api_secret)\s*=\s*["\x27][^"\x27]+["\x27]', caseSensitive: false);

      for (final file in files) {
        final content = file.readAsStringSync();
        expect(secretPattern.hasMatch(content), isFalse, reason: 'File ${file.path} contains forbidden hardcoded secret credentials!');
      }
    });

    test('2. Production HTTPS Protocol Enforcement Across Catalog', () {
      for (final res in catalog) {
        if (res.storageUrl.isNotEmpty) {
          expect(res.storageUrl.startsWith('https://'), isTrue,
              reason: 'Resource ${res.id} must strictly enforce https:// scheme');
        }
      }
    });

    test('3. Copyright Safety Tier Rules (external_copyrighted vs hosted)', () {
      for (final res in catalog) {
        expect(res.copyrightTier, isIn(['created_by_cssed', 'open_licensed', 'public_domain', 'officially_provided', 'external_copyrighted']));
        if (res.isExternalCopyrighted) {
          expect(res.isDownloadable, isFalse);
        }
      }
    });

    test('4. Availability Status Integrity & Beginner Explanations', () {
      for (final res in catalog) {
        expect(res.availabilityStatus, isIn(['available', 'coming_soon', 'external', 'unavailable']));
        expect(res.whatIsThis, isNotNull);
        expect(res.whyUseIt, isNotNull);
      }
    });

    test('5. PdfRepository Duplicate Resource ID & Scheme Validation', () {
      final pdfRepo = PdfRepository();
      final errors = pdfRepo.validateDocumentUrls(catalog);
      expect(errors, isEmpty, reason: 'Catalog must have 0 scheme errors and 0 duplicate IDs');
    });

    test('6. Global Search Index Engine High Query Stress & Boundary Tests', () {
      final searchEngine = SearchIndexEngine();
      searchEngine.buildIndex(MockData.subjects, catalog);

      expect(searchEngine.itemCount, greaterThan(1000));

      final cSearch = searchEngine.search('C Programming');
      expect(cSearch, isNotEmpty);

      final pyqSearch = searchEngine.search('PYQs');
      expect(pyqSearch, isNotEmpty);

      final emptySearch = searchEngine.search('');
      expect(emptySearch, isEmpty);

      final unicodeSearch = searchEngine.search(r'@#$%^&*()');
      expect(unicodeSearch, isEmpty);
    });

    test('7. AppConfig & R2StorageHelper Production Environment Settings', () {
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

    test('8. CloudStorageHealthChecker Handles Invalid URLs Gracefully', () async {
      final checker = CloudStorageHealthChecker();
      final result = await checker.checkEndpointHealth('http://insecure-domain.com/file.pdf');
      expect(result.isReachable, isFalse);
      expect(result.statusCode, equals(400));
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

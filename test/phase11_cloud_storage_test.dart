import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/core/config/app_config.dart';
import 'package:csse_study_hub/core/utils/r2_storage_helper.dart';
import 'package:csse_study_hub/core/services/cloud_storage_health_checker.dart';
import 'package:csse_study_hub/data/datasources/academic_resource_catalog.dart';
import 'package:csse_study_hub/data/datasources/mock_data.dart';
import 'package:csse_study_hub/data/repositories/pdf_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 11 — Production Cloud Storage & Integration Tests', () {
    test('1. AppConfig environment switching & cdnBaseUrl getters', () {
      AppConfig.environment = AppEnvironment.prod;
      expect(AppConfig.cdnBaseUrl, equals('https://cdn.csse-study-hub.org/academic'));

      AppConfig.environment = AppEnvironment.staging;
      expect(AppConfig.cdnBaseUrl, equals('https://staging-cdn.csse-study-hub.org/academic'));

      AppConfig.environment = AppEnvironment.dev;
      expect(AppConfig.cdnBaseUrl, equals('https://dev-cdn.csse-study-hub.org/academic'));

      // Restore production default
      AppConfig.environment = AppEnvironment.prod;
    });

    test('2. R2StorageHelper path generator and CDN URL builder', () {
      final path = R2StorageHelper.buildR2StoragePath(
        yearId: 'year_1',
        semesterId: 'sem_1_1',
        subjectCode: 'cs1104',
        unitId: 'unit_1',
        documentType: 'notes',
        fileName: 'c_syntax.pdf',
      );
      expect(path, equals('academic/year_1/sem_1_1/cs1104/unit_1/notes/c_syntax.pdf'));

      final cdnUrl = R2StorageHelper.buildCdnUrl(path, customCdnBaseUrl: 'https://cdn.csse-study-hub.org/academic');
      expect(cdnUrl, equals('https://cdn.csse-study-hub.org/academic/year_1/sem_1_1/cs1104/unit_1/notes/c_syntax.pdf'));
    });

    test('3. CloudStorageHealthChecker handles invalid/empty URLs gracefully', () async {
      final checker = CloudStorageHealthChecker();
      final invalidResult = await checker.checkEndpointHealth('http://insecure-domain.com/file.pdf');
      expect(invalidResult.isReachable, isFalse);
      expect(invalidResult.statusCode, equals(400));
      expect(invalidResult.errorMessage, contains('https:// scheme'));
    });

    test('4. AcademicResourceCatalog production HTTPS validation & zero duplicates', () {
      final catalog = AcademicResourceCatalog.allAcademicResources;
      final pdfRepo = PdfRepository();
      final errors = pdfRepo.validateDocumentUrls(catalog);
      expect(errors, isEmpty, reason: 'Catalog must contain 100% valid HTTPS schemes and 0 duplicate IDs');
    });

    test('5. Copyright Safety Classification & Availability State integrity', () {
      final catalog = AcademicResourceCatalog.allAcademicResources;
      for (final res in catalog) {
        expect(res.copyrightTier, isIn(['created_by_cssed', 'open_licensed', 'public_domain', 'officially_provided', 'external_copyrighted']));
        if (res.isExternalCopyrighted) {
          expect(res.isDownloadable, isFalse);
        }
      }
    });

    test('6. Security Audit: Zero hardcoded secrets/credentials in source files', () {
      final libDir = Directory('lib');
      final files = libDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
      final secretPattern = RegExp(r'(r2_access_key|r2_secret_key|aws_secret_access_key|private_key|api_secret)\s*=\s*["\x27][^"\x27]+["\x27]', caseSensitive: false);

      for (final file in files) {
        final text = file.readAsStringSync();
        expect(secretPattern.hasMatch(text), isFalse, reason: 'File ${file.path} contains forbidden hardcoded secret credentials!');
      }
    });

    test('7. Protected Academic Hierarchy Verification (4 Years, 8 Semesters, 30 Subjects)', () {
      expect(MockData.years.length, equals(4));
      expect(MockData.semesters.length, equals(8));
      expect(MockData.subjects.length, greaterThanOrEqualTo(30));
    });
  });
}

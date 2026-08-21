import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/datasources/academic_resource_catalog.dart';
import 'package:csse_study_hub/data/datasources/search_index_engine.dart';
import 'package:csse_study_hub/data/datasources/mock_data.dart';
import 'package:csse_study_hub/data/repositories/pdf_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 9 — Production Academic Resource Delivery Tests', () {
    final catalog = AcademicResourceCatalog.allAcademicResources;

    test('Verify AcademicResourceCatalog contains valid remote HTTPS resources',
        () {
      expect(catalog, isNotEmpty);
      expect(catalog.length, greaterThanOrEqualTo(7));

      for (final res in catalog) {
        expect(res.storageUrl.startsWith('https://'), isTrue,
            reason: 'Resource ${res.id} must use valid remote HTTPS scheme');
        expect(res.subjectId, isNotEmpty);
        expect(res.yearId, isNotEmpty);
        expect(res.semesterId, isNotEmpty);
      }
    });

    test(
        'Verify AcademicResourceCatalog returns recommended Start Here resource for subjects',
        () {
      final cProgRecommended =
          AcademicResourceCatalog.getRecommendedResource('subj_1_1_4');
      expect(cProgRecommended, isNotNull);
      expect(cProgRecommended!.id, equals('pdf_c_prog_start_here_unit1'));
      expect(cProgRecommended.isFeatured, isTrue);
      expect(cProgRecommended.whatIsThis, contains('Introductory notes'));
      expect(cProgRecommended.whyUseIt, contains('Start here'));
      expect(cProgRecommended.estimatedStudyTime, equals('20 mins'));

      final dsRecommended =
          AcademicResourceCatalog.getRecommendedResource('subj_2_1_1');
      expect(dsRecommended, isNotNull);
      expect(dsRecommended!.id, equals('pdf_ds_start_here_unit2'));
      expect(dsRecommended.isFeatured, isTrue);
    });

    test('Verify Copyright Tier Safety Rules (external_copyrighted vs hosted)',
        () {
      final kernelDocs =
          catalog.firstWhere((r) => r.id == 'pdf_os_official_docs_kernel');
      expect(kernelDocs.isExternalCopyrighted, isTrue);
      expect(kernelDocs.copyrightTier, equals('external_copyrighted'));
      expect(kernelDocs.isDownloadable, isFalse);

      final cNotes =
          catalog.firstWhere((r) => r.id == 'pdf_c_prog_start_here_unit1');
      expect(cNotes.isExternalCopyrighted, isFalse);
      expect(cNotes.copyrightTier, equals('officially_provided'));
      expect(cNotes.isDownloadable, isTrue);
    });

    test('Verify Availability Status Handling (available vs coming_soon)', () {
      final availableRes =
          catalog.firstWhere((r) => r.id == 'pdf_c_prog_start_here_unit1');
      expect(availableRes.availabilityStatus, equals('available'));
      expect(availableRes.isComingSoon, isFalse);

      final comingSoonRes =
          catalog.firstWhere((r) => r.id == 'pdf_c_prog_unit4_coming_soon');
      expect(comingSoonRes.availabilityStatus, equals('coming_soon'));
      expect(comingSoonRes.isComingSoon, isTrue);
    });

    test(
        'Verify PdfRepository URL validation returns zero errors on AcademicResourceCatalog',
        () {
      final pdfRepo = PdfRepository();
      final errors = pdfRepo.validateDocumentUrls(catalog);
      expect(errors, isEmpty,
          reason: 'Catalog URLs must be valid HTTPS and unique');
    });

    test('Verify SearchIndexEngine indexes AcademicResourceCatalog items', () {
      final searchEngine = SearchIndexEngine();
      searchEngine.buildIndex(MockData.subjects, catalog);

      expect(searchEngine.itemCount, greaterThanOrEqualTo(7));

      final cResults = searchEngine.search('C Programming');
      expect(cResults.isNotEmpty, isTrue);

      final galvinResults = searchEngine.search('Galvin');
      expect(galvinResults.isNotEmpty, isTrue);

      final pyqResults = searchEngine.search('PYQs');
      expect(pyqResults.isNotEmpty, isTrue);
    });

    test(
        'Verify Academic Hierarchy Preservation (4 Years, 8 Semesters, 30 Subjects)',
        () {
      expect(MockData.years.length, equals(4));
      expect(MockData.semesters.length, equals(8));
      expect(MockData.subjects.length, greaterThanOrEqualTo(30));

      final year1 = MockData.years.firstWhere((y) => y.id == 'year_1');
      expect(year1.yearNumber, equals(1));

      final sem1 = MockData.semesters.firstWhere((s) => s.id == 'sem_1_1');
      expect(sem1.semesterNumber, equals(1));
    });
  });
}

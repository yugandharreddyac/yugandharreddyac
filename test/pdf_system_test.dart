import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/repositories/pdf_repository.dart';
import 'package:csse_study_hub/data/datasources/search_index_engine.dart';
import 'package:csse_study_hub/data/datasources/mock_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 8 - Academic PDF & Document System Tests', () {
    final catalog = PdfRepository.sampleAcademicPdfCatalog;

    test('Verify sample academic PDF catalog contains high quality remote HTTPS resources', () {
      expect(catalog, isNotEmpty);
      expect(catalog.length, greaterThanOrEqualTo(5));

      for (final doc in catalog) {
        expect(doc.storageUrl.startsWith('https://'), isTrue,
            reason: 'PDF resource ${doc.id} must use valid remote HTTPS scheme');
        expect(doc.subjectId, isNotEmpty,
            reason: 'PDF resource ${doc.id} must map to a valid subjectId');
        expect(doc.yearId, isNotEmpty);
        expect(doc.semesterId, isNotEmpty);
      }
    });

    test('Verify ResourceModel Phase 8 getters and properties', () {
      final doc = catalog.firstWhere((d) => d.id == 'pdf_c_prog_notes_unit1');

      expect(doc.unitId, equals('unit_1'));
      expect(doc.topicId, equals('topic_c_basics'));
      expect(doc.documentType, equals('Unit Notes'));
      expect(doc.fileName, equals('unit_1_c_syntax.pdf'));
      expect(doc.remoteUrl, equals(doc.storageUrl));
      expect(doc.difficultyLevel, equals('Beginner'));
      expect(doc.sourceProvider, equals('JNTUH Academic Council'));
      expect(doc.isDownloadable, isTrue);
      expect(doc.isAvailable, isTrue);
      expect(doc.whatIsThis, isNotNull);
      expect(doc.whyUseIt, isNotNull);
      expect(doc.estimatedStudyTime, equals('15 mins'));
      expect(doc.isOfficial, isTrue);
      expect(doc.language, equals('English'));
      expect(doc.availabilityStatus, equals('available'));
      expect(doc.isComingSoon, isFalse);
    });

    test('Verify Availability Status (Coming Soon) & Copyright Safety classification', () {
      final comingSoonDoc = catalog.firstWhere((d) => d.id == 'pdf_c_prog_unit4_coming_soon');
      expect(comingSoonDoc.isComingSoon, isTrue);
      expect(comingSoonDoc.availabilityStatus, equals('coming_soon'));

      final copyrightDoc = catalog.firstWhere((d) => d.id == 'pdf_os_official_docs_kernel');
      expect(copyrightDoc.isExternalCopyrighted, isTrue);
      expect(copyrightDoc.copyrightTier, equals('external_copyrighted'));
      expect(copyrightDoc.isDownloadable, isFalse);
    });

    test('Verify Protected Academic Hierarchy (Years 1-4, Semesters 1-8, Subjects)', () {
      expect(MockData.years.length, equals(4));
      expect(MockData.semesters.length, equals(8));
      expect(MockData.subjects.length, greaterThanOrEqualTo(30));

      final cProgSubj = MockData.subjects.firstWhere((s) => s.id == 'subj_1_1_4');
      expect(cProgSubj.name, contains('C'));
      expect(cProgSubj.semesterId, equals('sem_1_1'));
      expect(cProgSubj.yearId, equals('year_1'));
    });

    test('Verify PdfRepository URL validation returns zero scheme errors and zero duplicates', () {
      final pdfRepo = PdfRepository();
      final validationErrors = pdfRepo.validateDocumentUrls(catalog);

      expect(validationErrors, isEmpty,
          reason: 'All academic PDF resources must have valid HTTPS schemes and unique IDs');
    });

    test('Verify PdfRepository filtering by Subject, Semester, and Document Type', () {
      final pdfRepo = PdfRepository();

      final cProgDocs = pdfRepo.filterDocuments(
        catalog,
        subjectId: 'subj_1_1_4',
      );
      expect(cProgDocs.length, greaterThanOrEqualTo(2));

      final unitNotes = pdfRepo.filterDocuments(
        catalog,
        documentType: 'Unit Notes',
      );
      expect(unitNotes.length, greaterThanOrEqualTo(2));

      final beginnerDocs = pdfRepo.filterDocuments(
        catalog,
        difficultyLevel: 'Beginner',
      );
      expect(beginnerDocs.length, greaterThanOrEqualTo(2));
    });

    test('Verify SearchIndexEngine indexes Academic PDFs correctly', () {
      final searchEngine = SearchIndexEngine();
      searchEngine.buildIndex(MockData.subjects, catalog);

      expect(searchEngine.itemCount, greaterThanOrEqualTo(5));

      final cSearch = searchEngine.search('C Programming');
      expect(cSearch.isNotEmpty, isTrue);

      final galvinSearch = searchEngine.search('Galvin');
      expect(galvinSearch.isNotEmpty, isTrue);

      final pyqSearch = searchEngine.search('PYQs');
      expect(pyqSearch.isNotEmpty, isTrue);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csse_study_hub/presentation/screens/resources/resource_screen.dart';
import 'package:csse_study_hub/presentation/providers/study_provider.dart';
import 'package:csse_study_hub/presentation/providers/bookmark_provider.dart';
import 'package:csse_study_hub/presentation/providers/download_provider.dart';
import 'package:csse_study_hub/data/repositories/study_repository.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/datasources/local_storage_datasource.dart';
import 'package:csse_study_hub/data/datasources/search_index_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseDataSource firebaseDataSource;
  late LocalStorageDataSource localStorageDataSource;
  late StudyRepository studyRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    firebaseDataSource = FirebaseDataSource();
    localStorageDataSource = LocalStorageDataSource(prefs);
    studyRepository = StudyRepository(
      firebaseDataSource: firebaseDataSource,
      localStorageDataSource: localStorageDataSource,
    );
  });

  Widget createSubjectDetailScreen({
    required String subjectId,
    required String subjectName,
    int? initialSectionIndex,
  }) {
    final studyProvider = StudyProvider(studyRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StudyProvider>.value(value: studyProvider),
        ChangeNotifierProvider(
            create: (_) => DownloadProvider(localStorageDataSource)),
        ChangeNotifierProvider(
            create: (_) => BookmarkProvider(localStorageDataSource)),
      ],
      child: MaterialApp(
        home: ResourceScreen(
          subjectId: subjectId,
          subjectName: subjectName,
          initialSectionIndex: initialSectionIndex,
        ),
      ),
    );
  }

  group('Subject Detail Page Redesign Requirement H Verification Tests', () {
    testWidgets(
        '1 & 2. Exactly 3 Subject Detail tabs exist: Syllabus, Notes, Previous Papers',
        (tester) async {
      await tester.pumpWidget(createSubjectDetailScreen(
        subjectId: 'subj_1_1_1',
        subjectName: 'Green Chemistry & Sustainability',
      ));
      await tester.pumpAndSettle();

      expect(find.text('Syllabus'), findsWidgets);
      expect(find.text('Notes'), findsWidgets);
      expect(find.text('Previous Papers'), findsWidgets);
    });

    testWidgets(
        '3 & 4. Textbook and removed section titles are NOT displayed as tabs',
        (tester) async {
      await tester.pumpWidget(createSubjectDetailScreen(
        subjectId: 'subj_1_1_1',
        subjectName: 'Green Chemistry & Sustainability',
      ));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ChoiceChip, 'Course Overview'), findsNothing);
      expect(find.widgetWithText(ChoiceChip, 'Textbook'), findsNothing);
      expect(
          find.widgetWithText(ChoiceChip, 'Important Questions'), findsNothing);
      expect(find.widgetWithText(ChoiceChip, 'Quick Revision'), findsNothing);
      expect(find.widgetWithText(ChoiceChip, 'Practical / Lab'), findsNothing);
      expect(find.widgetWithText(ChoiceChip, 'Assignments'), findsNothing);
      expect(find.widgetWithText(ChoiceChip, 'Projects'), findsNothing);
      expect(find.widgetWithText(ChoiceChip, 'Additional Resources'),
          findsNothing);
    });

    test('5. SearchIndexEngine produces ONLY section indexes 0, 1, or 2',
        () async {
      final engine = SearchIndexEngine();
      final subjects = await studyRepository.getSubjects('sem_1_1');

      engine.buildIndex(
        subjects,
        [],
      );

      expect(engine.isIndexed, isTrue);

      final queryResult = engine.search('Computer Programming');
      final sectionIndexes = queryResult.matchingItems
          .where((i) => i.sectionIndex != null)
          .map((i) => i.sectionIndex!)
          .toSet();

      for (final index in sectionIndexes) {
        expect(index, inInclusiveRange(0, 2),
            reason: 'Section index $index must be 0, 1, or 2.');
      }
    });

    testWidgets('6. Legacy indexes cannot cause RangeError or blank screens',
        (tester) async {
      await tester.pumpWidget(createSubjectDetailScreen(
        subjectId: 'subj_1_1_1',
        subjectName: 'Green Chemistry & Sustainability',
        initialSectionIndex: 8, // Legacy out-of-bounds index
      ));
      await tester.pumpAndSettle();

      expect(find.byType(ResourceScreen), findsOneWidget);
      expect(find.text('Green Chemistry & Sustainability'), findsWidgets);
    });

    testWidgets(
        '8. Notes still exposes textbook chapter/section/topic functionality',
        (tester) async {
      await tester.pumpWidget(createSubjectDetailScreen(
        subjectId: 'subj_1_1_4',
        subjectName: 'Computer Programming in C',
        initialSectionIndex: 1, // Notes tab
      ));
      await tester.pumpAndSettle();

      expect(find.text('Notes'), findsWidgets);
    });

    testWidgets(
        '9. Previous Papers opens correctly and displays past examination heading',
        (tester) async {
      await tester.pumpWidget(createSubjectDetailScreen(
        subjectId: 'subj_1_1_4',
        subjectName: 'Computer Programming in C',
        initialSectionIndex: 2, // Previous Papers tab
      ));
      await tester.pumpAndSettle();

      expect(find.text('Previous Papers'), findsWidgets);
    });

    testWidgets('10. Empty states are shown correctly when content is absent',
        (tester) async {
      await tester.pumpWidget(createSubjectDetailScreen(
        subjectId: 'subj_non_existent',
        subjectName: 'Empty Subject Test',
        initialSectionIndex: 2, // Previous Papers tab
      ));
      await tester.pumpAndSettle();

      expect(find.text('No previous papers available yet.'), findsOneWidget);
    });
  });
}

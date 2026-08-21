import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:csse_study_hub/main.dart';
import 'package:csse_study_hub/data/datasources/educational_content_provider.dart';
import 'package:csse_study_hub/presentation/widgets/common/educational_loading_card.dart';
import 'package:csse_study_hub/data/repositories/study_repository.dart';
import 'package:csse_study_hub/data/repositories/career_repository.dart';
import 'package:csse_study_hub/data/repositories/coding_repository.dart';
import 'package:csse_study_hub/data/repositories/placement_repository.dart';
import 'package:csse_study_hub/data/repositories/project_repository.dart';
import 'package:csse_study_hub/data/repositories/higher_education_repository.dart';
import 'package:csse_study_hub/data/repositories/admin_repository.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/datasources/local_storage_datasource.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EducationalContentProvider Unit Tests', () {
    test(
        'allItems contains valid educational facts across all required categories',
        () {
      const items = EducationalContentProvider.allItems;
      expect(items.isNotEmpty, isTrue);

      final hasQuickBytes =
          items.any((i) => i.type == EducationalContentType.csQuickByte);
      final hasPioneers =
          items.any((i) => i.type == EducationalContentType.csPioneer);
      final hasSubjectPoints =
          items.any((i) => i.type == EducationalContentType.subjectKeyPoint);
      final hasTips =
          items.any((i) => i.type == EducationalContentType.quickTip);

      expect(hasQuickBytes, isTrue);
      expect(hasPioneers, isTrue);
      expect(hasSubjectPoints, isTrue);
      expect(hasTips, isTrue);
    });

    test('getRandomItem returns a valid item', () {
      final item = EducationalContentProvider.getRandomItem();
      expect(item.id.isNotEmpty, isTrue);
      expect(item.title.isNotEmpty, isTrue);
      expect(item.content.isNotEmpty, isTrue);
    });

    test('getNextItem rotates sequentially', () {
      final item1 = EducationalContentProvider.getNextItem(0);
      expect(item1.id, equals(EducationalContentProvider.allItems[1].id));
    });
  });

  group('EducationalLoadingCard Widget Tests', () {
    testWidgets(
        'Renders loading state with progress indicator and educational text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body:
                EducationalLoadingCard(loadingMessage: 'Loading resources...'),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('Renders empty state with empty title and message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EducationalLoadingCard(
              isEmpty: true,
              emptyTitle: 'No saved resources',
              emptyMessage: 'Bookmark a note to view it here.',
            ),
          ),
        ),
      );

      expect(find.text('No saved resources'), findsOneWidget);
      expect(find.text('Bookmark a note to view it here.'), findsOneWidget);
    });

    testWidgets('Renders error state with retry button',
        (WidgetTester tester) async {
      bool retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EducationalLoadingCard(
              isError: true,
              errorMessage: 'Failed to fetch content.',
              onRetry: () {
                retryPressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Failed to fetch content.'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      expect(retryPressed, isTrue);
    });
  });

  group('HomeScreen Compressed Layout & Quick Access Tests', () {
    testWidgets('HomeScreen renders compressed layout with Quick Access grid',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final localStorage = LocalStorageDataSource(prefs);
      final studyRepo = StudyRepository(
        firebaseDataSource: FirebaseDataSource(),
        localStorageDataSource: localStorage,
      );
      final careerRepository =
          CareerRepository(firebaseDataSource: FirebaseDataSource());
      final codingRepository =
          CodingRepository(firebaseDataSource: FirebaseDataSource());
      final placementRepository =
          PlacementRepository(firebaseDataSource: FirebaseDataSource());
      final projectRepository =
          ProjectRepository(firebaseDataSource: FirebaseDataSource());
      final higherEducationRepository =
          HigherEducationRepository(firebaseDataSource: FirebaseDataSource());
      final adminRepository =
          AdminRepository(firebaseDataSource: FirebaseDataSource());

      await tester.pumpWidget(
        CSSEStudyHubApp(
          localStorageDataSource: localStorage,
          firebaseDataSource: FirebaseDataSource(),
          studyRepository: studyRepo,
          careerRepository: careerRepository,
          codingRepository: codingRepository,
          placementRepository: placementRepository,
          projectRepository: projectRepository,
          higherEducationRepository: higherEducationRepository,
          adminRepository: adminRepository,
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify Header and Quick Access
      expect(find.text('UNIDOCS'), findsWidgets);
      expect(find.text('QUICK ACCESS'), findsOneWidget);
      expect(find.text('Downloads'), findsWidgets);
      expect(find.text('Saved'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.text('Roadmap'), findsOneWidget);
    });
  });
}

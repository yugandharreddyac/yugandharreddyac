import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:csse_study_hub/core/routes/app_routes.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/datasources/local_storage_datasource.dart';
import 'package:csse_study_hub/data/datasources/non_academic_data.dart';
import 'package:csse_study_hub/data/repositories/admin_repository.dart';
import 'package:csse_study_hub/data/repositories/career_repository.dart';
import 'package:csse_study_hub/data/repositories/coding_repository.dart';
import 'package:csse_study_hub/data/repositories/document_repository.dart';
import 'package:csse_study_hub/data/repositories/download_repository.dart';
import 'package:csse_study_hub/data/repositories/higher_education_repository.dart';
import 'package:csse_study_hub/data/repositories/non_academic_repository.dart';
import 'package:csse_study_hub/data/repositories/placement_repository.dart';
import 'package:csse_study_hub/data/repositories/project_repository.dart';
import 'package:csse_study_hub/data/repositories/study_repository.dart';
import 'package:csse_study_hub/presentation/providers/admin_provider.dart';
import 'package:csse_study_hub/presentation/providers/auth_provider.dart';
import 'package:csse_study_hub/presentation/providers/bookmark_provider.dart';
import 'package:csse_study_hub/presentation/providers/career_provider.dart';
import 'package:csse_study_hub/presentation/providers/coding_provider.dart';
import 'package:csse_study_hub/presentation/providers/document_processing_provider.dart';
import 'package:csse_study_hub/presentation/providers/download_provider.dart';
import 'package:csse_study_hub/presentation/providers/hierarchy_provider.dart';
import 'package:csse_study_hub/presentation/providers/higher_education_provider.dart';
import 'package:csse_study_hub/presentation/providers/placement_provider.dart';
import 'package:csse_study_hub/presentation/providers/profile_provider.dart';
import 'package:csse_study_hub/presentation/providers/project_provider.dart';
import 'package:csse_study_hub/presentation/providers/quiz_provider.dart';
import 'package:csse_study_hub/presentation/providers/recent_provider.dart';
import 'package:csse_study_hub/presentation/providers/roadmap_provider.dart';
import 'package:csse_study_hub/presentation/providers/study_provider.dart';
import 'package:csse_study_hub/presentation/providers/theme_provider.dart';
import 'package:csse_study_hub/presentation/providers/unibyte_provider.dart';
import 'package:csse_study_hub/presentation/providers/unidocs_ai_provider.dart';
import 'package:csse_study_hub/presentation/screens/home/home_screen.dart';
import 'package:csse_study_hub/presentation/widgets/navigation/app_navigation_drawer.dart';

Widget _createAuditedApp({
  required LocalStorageDataSource localStorage,
  required FirebaseDataSource firebase,
  Widget? home,
  String? initialRoute,
}) {
  final studyRepo = StudyRepository(
    firebaseDataSource: firebase,
    localStorageDataSource: localStorage,
  );
  final docRepo = InMemoryDocumentRepository();

  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider(localStorage)),
      ChangeNotifierProvider(create: (_) => StudyProvider(studyRepo)),
      ChangeNotifierProvider(create: (_) => BookmarkProvider(localStorage)),
      ChangeNotifierProvider(
        create: (_) => DownloadProvider(
          localStorage,
          downloadRepository: DownloadRepository(
            localStorage: localStorage,
            firebaseDataSource: firebase,
          ),
        ),
      ),
      ChangeNotifierProvider(create: (_) => AuthProvider(firebase)),
      ChangeNotifierProvider(create: (_) => ProfileProvider(firebase)),
      ChangeNotifierProvider(create: (_) => RecentProvider(localStorage)),
      ChangeNotifierProvider(
          create: (_) =>
              CareerProvider(CareerRepository(firebaseDataSource: firebase))),
      ChangeNotifierProvider(
          create: (_) =>
              CodingProvider(CodingRepository(firebaseDataSource: firebase))),
      ChangeNotifierProvider(
          create: (_) => PlacementProvider(
              PlacementRepository(firebaseDataSource: firebase))),
      ChangeNotifierProvider(
          create: (_) =>
              ProjectProvider(ProjectRepository(firebaseDataSource: firebase))),
      ChangeNotifierProvider(
          create: (_) => HigherEducationProvider(
              HigherEducationRepository(firebaseDataSource: firebase))),
      ChangeNotifierProvider(create: (_) => UniByteProvider()),
      ChangeNotifierProvider(
          create: (_) => AdminProvider(
              repository: AdminRepository(firebaseDataSource: firebase))),
      ChangeNotifierProvider(
          create: (_) => HierarchyProvider(NonAcademicRepository())),
      ChangeNotifierProvider(create: (_) => RoadmapProvider()),
      ChangeNotifierProvider(create: (_) => QuizProvider()),
      ChangeNotifierProvider(
          create: (_) => DocumentProcessingProvider(repository: docRepo)),
      ChangeNotifierProvider(
        create: (_) {
          final aiProv = UniDocsAiProvider();
          aiProv.configureDocumentRepository(docRepo);
          return aiProv;
        },
      ),
    ],
    child: MaterialApp(
      initialRoute: initialRoute,
      home: home,
      onGenerateRoute: AppRoutes.generateRoute,
    ),
  );
}

void main() {
  group('Navigation & Home Page QA Audit Tests', () {
    late LocalStorageDataSource localStorage;
    late FirebaseDataSource firebase;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      localStorage = LocalStorageDataSource(prefs);
      firebase = FirebaseDataSource();
    });

    testWidgets('1. HomeScreen renders correctly on mobile viewport (360x780)',
        (tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _createAuditedApp(
          localStorage: localStorage,
          firebase: firebase,
          home: const HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('UNIDOCS'), findsWidgets);
      expect(find.text('Academic Curriculum'), findsOneWidget);
      expect(find.text('1st Year'), findsOneWidget);
      expect(find.text('2nd Year'), findsOneWidget);
      expect(find.text('3rd Year'), findsOneWidget);
      expect(find.text('4th Year'), findsOneWidget);
      expect(find.text('Career & Practical Hubs'), findsOneWidget);
    });

    testWidgets(
        '2. HomeScreen renders correctly on desktop viewport (1200x800)',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _createAuditedApp(
          localStorage: localStorage,
          firebase: firebase,
          home: const HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Academic Curriculum'), findsWidgets);
      expect(find.text('Coding Hub'), findsWidgets);
      expect(find.text('Placement Hub'), findsWidgets);
    });

    testWidgets('3. Mobile Navigation Menu opens AppNavigationDrawer',
        (tester) async {
      tester.view.physicalSize = const Size(380, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _createAuditedApp(
          localStorage: localStorage,
          firebase: firebase,
          home: const HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final menuButton = find.byTooltip('Navigation Menu');
      expect(menuButton, findsOneWidget);
      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      // Drawer is open
      expect(find.byType(AppNavigationDrawer), findsOneWidget);
      expect(find.text('UniDocs AI Assistant'), findsOneWidget);
      expect(find.text('Personalized Roadmap'), findsOneWidget);
      expect(find.text('Academic Curriculum Overview'), findsOneWidget);
    });

    testWidgets('4. All hub routes generate valid screens without exceptions',
        (tester) async {
      final routesToTest = [
        AppRoutes.codingHub,
        AppRoutes.careerHub,
        AppRoutes.placementHub,
        AppRoutes.quizHub,
        AppRoutes.projectHub,
        AppRoutes.higherEducationHub,
        AppRoutes.entrepreneurshipHub,
        AppRoutes.roadmap,
        AppRoutes.ai,
        AppRoutes.bookmarks,
        AppRoutes.downloads,
        AppRoutes.profile,
        AppRoutes.settings,
        AppRoutes.about,
        AppRoutes.contact,
        AppRoutes.privacyPolicy,
        AppRoutes.search,
      ];

      for (final route in routesToTest) {
        final generatedRoute =
            AppRoutes.generateRoute(RouteSettings(name: route));
        expect(generatedRoute, isNotNull);
      }
    });

    testWidgets('5. Route generator handles null and invalid arguments safely',
        (tester) async {
      // pdfViewer with null args falls back to HomeScreen safely
      final pdfNullRoute = AppRoutes.generateRoute(
          const RouteSettings(name: AppRoutes.pdfViewer));
      expect(pdfNullRoute, isNotNull);

      // topicDetail with null args falls back safely
      final topicNullRoute = AppRoutes.generateRoute(
          const RouteSettings(name: AppRoutes.topicDetail));
      expect(topicNullRoute, isNotNull);

      // semesters with null args falls back safely
      final semNullRoute = AppRoutes.generateRoute(
          const RouteSettings(name: AppRoutes.semesters));
      expect(semNullRoute, isNotNull);
    });
  });
}

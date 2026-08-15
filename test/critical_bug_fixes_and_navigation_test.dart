import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:csse_study_hub/core/config/app_config.dart';
import 'package:csse_study_hub/core/routes/app_routes.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/datasources/local_storage_datasource.dart';
import 'package:csse_study_hub/data/datasources/gemini_provider.dart';
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
import 'package:csse_study_hub/data/services/ai_service.dart';
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
import 'package:csse_study_hub/presentation/screens/years/year_screen.dart';
import 'package:csse_study_hub/presentation/screens/semesters/semester_screen.dart';
import 'package:csse_study_hub/presentation/screens/subjects/subject_screen.dart';
import 'package:csse_study_hub/presentation/screens/resources/resource_screen.dart';
import 'package:csse_study_hub/presentation/screens/ai/unidocs_ai_screen.dart';

Widget _createAuditedApp({
  required LocalStorageDataSource localStorage,
  required FirebaseDataSource firebase,
  Widget? home,
  String? initialRoute,
  Size physicalSize = const Size(390, 844),
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
      ChangeNotifierProvider(create: (_) => CareerProvider(CareerRepository(firebaseDataSource: firebase))),
      ChangeNotifierProvider(create: (_) => CodingProvider(CodingRepository(firebaseDataSource: firebase))),
      ChangeNotifierProvider(create: (_) => PlacementProvider(PlacementRepository(firebaseDataSource: firebase))),
      ChangeNotifierProvider(create: (_) => ProjectProvider(ProjectRepository(firebaseDataSource: firebase))),
      ChangeNotifierProvider(create: (_) => HigherEducationProvider(HigherEducationRepository(firebaseDataSource: firebase))),
      ChangeNotifierProvider(create: (_) => UniByteProvider()),
      ChangeNotifierProvider(create: (_) => AdminProvider(repository: AdminRepository(firebaseDataSource: firebase))),
      ChangeNotifierProvider(create: (_) => HierarchyProvider(NonAcademicRepository())),
      ChangeNotifierProvider(create: (_) => RoadmapProvider()),
      ChangeNotifierProvider(create: (_) => QuizProvider()),
      ChangeNotifierProvider(create: (_) => DocumentProcessingProvider(repository: docRepo)),
      ChangeNotifierProvider(
        create: (_) {
          final aiProv = UniDocsAiProvider(
            aiService: AiService(
              provider: GeminiProvider(backendUrl: AppConfig.aiBackendUrl),
            ),
          );
          aiProv.configureDocumentRepository(docRepo);
          return aiProv;
        },
      ),
    ],
    child: MaterialApp(
      initialRoute: initialRoute,
      home: MediaQuery(
        data: MediaQueryData(size: physicalSize),
        child: home ?? const HomeScreen(),
      ),
      onGenerateRoute: AppRoutes.generateRoute,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Critical Bug Fixes & Navigation Verification', () {
    late LocalStorageDataSource localStorage;
    late FirebaseDataSource firebase;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      localStorage = LocalStorageDataSource(prefs);
      firebase = FirebaseDataSource();
    });

    testWidgets('1. AppRoutes.years generates YearScreen and displays all 4 academic years',
        (tester) async {
      final route = AppRoutes.generateRoute(const RouteSettings(name: AppRoutes.years));
      expect(route, isNotNull);

      await tester.pumpWidget(
        _createAuditedApp(
          localStorage: localStorage,
          firebase: firebase,
          home: const YearScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Academic Years'), findsOneWidget);
      expect(find.text('1st Year'), findsOneWidget);
      expect(find.text('2nd Year'), findsOneWidget);
      expect(find.text('3rd Year'), findsOneWidget);
      expect(find.text('4th Year'), findsOneWidget);
    });

    testWidgets('2. End-to-end Academic Curriculum Navigation Hierarchy', (tester) async {
      // Step A: YearScreen
      await tester.pumpWidget(
        _createAuditedApp(
          localStorage: localStorage,
          firebase: firebase,
          home: const YearScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('1st Year'), findsOneWidget);

      // Step B: SemesterScreen
      await tester.pumpWidget(
        _createAuditedApp(
          localStorage: localStorage,
          firebase: firebase,
          home: const SemesterScreen(yearId: 'year_1', yearTitle: '1st Year'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SemesterScreen), findsOneWidget);
      expect(find.textContaining('1-1'), findsOneWidget);
      expect(find.textContaining('1-2'), findsOneWidget);

      // Step C: SubjectScreen
      await tester.pumpWidget(
        _createAuditedApp(
          localStorage: localStorage,
          firebase: firebase,
          home: const SubjectScreen(semesterId: 'sem_1', semesterTitle: 'Semester 1'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SubjectScreen), findsOneWidget);

      // Step D: ResourceScreen
      await tester.pumpWidget(
        _createAuditedApp(
          localStorage: localStorage,
          firebase: firebase,
          home: const ResourceScreen(
            subjectId: 'sub_maths_1',
            subjectName: 'Engineering Mathematics-I',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ResourceScreen), findsOneWidget);
      expect(find.text('Syllabus'), findsOneWidget);
      expect(find.text('Notes'), findsOneWidget);
      expect(find.text('Previous Papers'), findsOneWidget);
    });

    testWidgets('3. Back navigation: Root HomeScreen has NO back button, detail screens have back arrow',
        (tester) async {
      // HomeScreen has NO Back button
      await tester.pumpWidget(
        _createAuditedApp(
          localStorage: localStorage,
          firebase: firebase,
          home: const HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);

      // UniDocsAiScreen has Chat History and New Chat in top actions bar
      await tester.pumpWidget(
        _createAuditedApp(
          localStorage: localStorage,
          firebase: firebase,
          home: const UniDocsAiScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.forum_outlined), findsOneWidget); // Chat history in actions
      expect(find.byIcon(Icons.add_circle_outline_rounded), findsOneWidget); // New chat in actions
    });

    testWidgets('4. AI Backend Configuration is wired to AppConfig.aiBackendUrl', (tester) async {
      expect(AppConfig.aiBackendUrl, contains('https://us-central1-csse-study-hub-prod.cloudfunctions.net/aiGenerate'));
      final provider = GeminiProvider(backendUrl: AppConfig.aiBackendUrl);
      expect(provider.backendUrl, AppConfig.aiBackendUrl);
      expect(provider.providerId, 'gemini_cloud');
      expect(provider.displayName, contains('Gemini'));
    });

    testWidgets('5. Home Screen Viewport Stress Test (320px, 360px, 390px, 412px, 768px, 1200px)',
        (tester) async {
      final viewports = [
        const Size(320, 640),
        const Size(360, 780),
        const Size(390, 844),
        const Size(412, 915),
        const Size(768, 1024),
        const Size(1200, 800),
      ];

      for (final size in viewports) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          _createAuditedApp(
            localStorage: localStorage,
            firebase: firebase,
            home: const HomeScreen(),
            physicalSize: size,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(HomeScreen), findsOneWidget);
        expect(tester.takeException(), isNull, reason: 'Zero overflow on viewport: $size');
      }
    });
  });
}

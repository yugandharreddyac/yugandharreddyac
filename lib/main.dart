import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:csse_study_hub/firebase_options.dart';
import 'package:csse_study_hub/core/config/app_config.dart';
import 'package:csse_study_hub/core/theme/app_theme.dart';
import 'package:csse_study_hub/core/constants/app_constants.dart';
import 'package:csse_study_hub/core/routes/app_routes.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/datasources/local_storage_datasource.dart';
import 'package:csse_study_hub/data/repositories/study_repository.dart';
import 'package:csse_study_hub/data/repositories/career_repository.dart';
import 'package:csse_study_hub/data/repositories/coding_repository.dart';
import 'package:csse_study_hub/data/repositories/placement_repository.dart';
import 'package:csse_study_hub/data/repositories/project_repository.dart';
import 'package:csse_study_hub/data/repositories/higher_education_repository.dart';
import 'package:csse_study_hub/data/repositories/download_repository.dart';
import 'package:csse_study_hub/presentation/providers/theme_provider.dart';
import 'package:csse_study_hub/presentation/providers/study_provider.dart';
import 'package:csse_study_hub/presentation/providers/bookmark_provider.dart';
import 'package:csse_study_hub/presentation/providers/download_provider.dart';
import 'package:csse_study_hub/presentation/providers/auth_provider.dart';
import 'package:csse_study_hub/presentation/providers/profile_provider.dart';
import 'package:csse_study_hub/presentation/providers/recent_provider.dart';
import 'package:csse_study_hub/presentation/providers/career_provider.dart';
import 'package:csse_study_hub/presentation/providers/coding_provider.dart';
import 'package:csse_study_hub/presentation/providers/placement_provider.dart';
import 'package:csse_study_hub/presentation/providers/project_provider.dart';
import 'package:csse_study_hub/presentation/providers/higher_education_provider.dart';
import 'package:csse_study_hub/presentation/providers/unibyte_provider.dart';

import 'package:csse_study_hub/data/repositories/admin_repository.dart';
import 'package:csse_study_hub/presentation/providers/admin_provider.dart';
import 'package:csse_study_hub/data/repositories/non_academic_repository.dart';
import 'package:csse_study_hub/presentation/providers/hierarchy_provider.dart';
import 'package:csse_study_hub/presentation/providers/roadmap_provider.dart';
import 'package:csse_study_hub/presentation/providers/quiz_provider.dart';
import 'package:csse_study_hub/presentation/providers/unidocs_ai_provider.dart';
import 'package:csse_study_hub/presentation/providers/document_processing_provider.dart';
import 'package:csse_study_hub/data/repositories/document_repository.dart';
import 'package:csse_study_hub/data/datasources/gemini_provider.dart';
import 'package:csse_study_hub/data/services/ai_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = true;

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final localStorageDataSource = LocalStorageDataSource(prefs);

  // Initialize Firebase Core (once at root)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Enable Cloud Firestore Offline Persistence
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  } catch (e) {
    debugPrint('Firebase core initialization notice: $e (Falling back to offline repository dataset)');
  }

  // Defer Crashlytics & non-essential telemetry until after first frame paint
  WidgetsBinding.instance.addPostFrameCallback((_) {
    try {
      if (!kIsWeb) {
        FlutterError.onError = (errorDetails) {
          FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        };
      }
    } catch (_) {}
  });

  final firebaseDataSource = FirebaseDataSource();
  final studyRepository = StudyRepository(
    firebaseDataSource: firebaseDataSource,
    localStorageDataSource: localStorageDataSource,
  );
  final careerRepository = CareerRepository(firebaseDataSource: firebaseDataSource);
  final codingRepository = CodingRepository(firebaseDataSource: firebaseDataSource);
  final placementRepository = PlacementRepository(firebaseDataSource: firebaseDataSource);
  final projectRepository = ProjectRepository(firebaseDataSource: firebaseDataSource);
  final higherEducationRepository = HigherEducationRepository(firebaseDataSource: firebaseDataSource);
  final adminRepository = AdminRepository(firebaseDataSource: firebaseDataSource);

  runApp(
    CSSEStudyHubApp(
      localStorageDataSource: localStorageDataSource,
      firebaseDataSource: firebaseDataSource,
      studyRepository: studyRepository,
      careerRepository: careerRepository,
      codingRepository: codingRepository,
      placementRepository: placementRepository,
      projectRepository: projectRepository,
      higherEducationRepository: higherEducationRepository,
      adminRepository: adminRepository,
    ),
  );
}

class CSSEStudyHubApp extends StatelessWidget {
  final LocalStorageDataSource localStorageDataSource;
  final FirebaseDataSource firebaseDataSource;
  final StudyRepository studyRepository;
  final CareerRepository careerRepository;
  final CodingRepository codingRepository;
  final PlacementRepository placementRepository;
  final ProjectRepository projectRepository;
  final HigherEducationRepository higherEducationRepository;
  final AdminRepository adminRepository;

  const CSSEStudyHubApp({
    super.key,
    required this.localStorageDataSource,
    required this.firebaseDataSource,
    required this.studyRepository,
    required this.careerRepository,
    required this.codingRepository,
    required this.placementRepository,
    required this.projectRepository,
    required this.higherEducationRepository,
    required this.adminRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(localStorageDataSource),
        ),
        ChangeNotifierProvider(
          create: (_) => StudyProvider(studyRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => BookmarkProvider(localStorageDataSource),
        ),
        ChangeNotifierProvider(
          create: (_) => DownloadProvider(
            localStorageDataSource,
            downloadRepository: DownloadRepository(
              localStorage: localStorageDataSource,
              firebaseDataSource: firebaseDataSource,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(firebaseDataSource),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(firebaseDataSource),
        ),
        ChangeNotifierProvider(
          create: (_) => RecentProvider(localStorageDataSource),
        ),
        ChangeNotifierProvider(
          create: (_) => CareerProvider(careerRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => CodingProvider(codingRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => PlacementProvider(placementRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ProjectProvider(projectRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => HigherEducationProvider(higherEducationRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => UniByteProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdminProvider(repository: adminRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => HierarchyProvider(NonAcademicRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => RoadmapProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => QuizProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DocumentProcessingProvider(repository: InMemoryDocumentRepository()),
        ),
        ChangeNotifierProxyProvider<DocumentProcessingProvider, UniDocsAiProvider>(
          create: (ctx) {
            final aiService = AiService(
              provider: GeminiProvider(
                backendUrl: AppConfig.aiBackendUrl,
              ),
            );
            return UniDocsAiProvider(aiService: aiService);
          },
          update: (ctx, docProc, aiProv) {
            final prov = aiProv ??
                UniDocsAiProvider(
                  aiService: AiService(
                    provider: GeminiProvider(
                      backendUrl: AppConfig.aiBackendUrl,
                    ),
                  ),
                );
            prov.configureDocumentRepository(docProc.repository);
            return prov;
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}

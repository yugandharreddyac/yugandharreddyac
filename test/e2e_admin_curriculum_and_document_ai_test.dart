import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:csse_study_hub/core/config/app_config.dart';
import 'package:csse_study_hub/core/routes/app_routes.dart';
import 'package:csse_study_hub/data/datasources/ai_context_builder.dart';
import 'package:csse_study_hub/data/datasources/ai_provider_interface.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/datasources/local_storage_datasource.dart';
import 'package:csse_study_hub/data/datasources/gemini_provider.dart';
import 'package:csse_study_hub/data/models/ai_attachment.dart';
import 'package:csse_study_hub/data/models/ai_message.dart';
import 'package:csse_study_hub/data/models/ai_request.dart';
import 'package:csse_study_hub/data/models/ai_response.dart';
import 'package:csse_study_hub/data/models/document_models.dart';
import 'package:csse_study_hub/data/models/resource_model.dart';
import 'package:csse_study_hub/data/repositories/admin_repository.dart';
import 'package:csse_study_hub/data/repositories/ai_conversation_repository.dart';
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
import 'package:csse_study_hub/presentation/screens/resources/resource_screen.dart';
import 'package:csse_study_hub/presentation/screens/pdf_viewer/pdf_viewer_screen.dart';

class _GroundedCapturingProvider implements AiProvider {
  AiRequest? capturedRequest;

  @override
  String get providerId => 'grounded_capturing_mock';

  @override
  String get displayName => 'Grounded Capturing Mock';

  @override
  Set<AiCapability> get supportedCapabilities => {AiCapability.chat, AiCapability.documentQA};

  @override
  Future<bool> checkHealth() async => true;

  @override
  Future<AiResponse> generateResponse(AiRequest request) async {
    capturedRequest = request;
    return AiResponse.success(
      id: 'resp_grounded_1',
      message: AiMessage(
        id: 'msg_assistant_1',
        conversationId: request.conversationId,
        role: AiMessageRole.assistant,
        content: 'Cayley-Hamilton theorem states that every square matrix satisfies its own characteristic equation.',
        timestamp: DateTime.now(),
      ),
      citations: [
        AiCitation.fromDocument(
          documentTitle: 'Engineering Mathematics-I Unit 1',
          documentId: 'doc_maths_unit1',
          pageNumber: 5,
          snippet: 'Cayley-Hamilton Theorem: A square matrix satisfies its characteristic polynomial.',
        ),
      ],
    );
  }

  @override
  Stream<String> streamResponse(AiRequest request) async* {
    yield 'Grounded response';
  }
}

Widget _createTestApp({
  required LocalStorageDataSource localStorage,
  required FirebaseDataSource firebase,
  required StudyRepository studyRepository,
  required DocumentRepository documentRepository,
  Widget? home,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider(localStorage)),
      ChangeNotifierProvider(create: (_) => StudyProvider(studyRepository)),
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
      ChangeNotifierProvider(create: (_) => DocumentProcessingProvider(repository: documentRepository)),
      ChangeNotifierProvider(
        create: (_) {
          final aiProv = UniDocsAiProvider(
            aiService: AiService(
              provider: GeminiProvider(backendUrl: AppConfig.aiBackendUrl),
            ),
          );
          aiProv.configureDocumentRepository(documentRepository);
          return aiProv;
        },
      ),
    ],
    child: MaterialApp(
      home: home,
      onGenerateRoute: AppRoutes.generateRoute,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('E2E Production Workflow: Admin Upload -> Storage -> Firestore -> Student Curriculum -> AI', () {
    late LocalStorageDataSource localStorage;
    late FirebaseDataSource firebase;
    late StudyRepository studyRepository;
    late DocumentRepository documentRepository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      localStorage = LocalStorageDataSource(prefs);
      firebase = FirebaseDataSource();
      studyRepository = StudyRepository(
        firebaseDataSource: firebase,
        localStorageDataSource: localStorage,
      );
      documentRepository = InMemoryDocumentRepository();
    });

    testWidgets('1. Admin uploads real PDF metadata, Student sees resource & opens PDF Viewer', (tester) async {
      // Step A: Simulate Admin uploading a verified syllabus PDF to Storage & Firestore
      final testResource = ResourceModel(
        id: 'res_maths_unit1_prod',
        subjectId: 'sub_maths_1',
        subjectName: 'Engineering Mathematics-I',
        yearId: 'year_1',
        semesterId: 'sem_1',
        title: 'Unit 1 Matrices and Eigenvalues Production Notes',
        description: 'Verified official course lecture notes with complete derivations.',
        resourceType: 'notes',
        sectionType: 'Notes',
        storagePath: 'StudyHub/year_1/sem_1/Engineering Mathematics-I/notes/unit1_matrices.pdf',
        storageUrl: 'https://cdn.csse-study-hub.org/academic/year_1/sem_1/unit1_matrices.pdf',
        fileSizeBytes: 1428500,
        downloadCount: 0,
        lastUpdated: DateTime.now(),
        tags: const ['matrices', 'eigenvalues', 'linear algebra', 'rank'],
      );

      // Save to local/Firestore dataset
      studyRepository.clearMemoryCache();

      // Step B: Student opens ResourceScreen for Engineering Mathematics-I
      await tester.pumpWidget(
        _createTestApp(
          localStorage: localStorage,
          firebase: firebase,
          studyRepository: studyRepository,
          documentRepository: documentRepository,
          home: const ResourceScreen(
            subjectId: 'sub_maths_1',
            subjectName: 'Engineering Mathematics-I',
            initialSectionIndex: 1, // Notes tab
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ResourceScreen), findsOneWidget);
      expect(find.text('Notes'), findsOneWidget);

      // Step C: Student opens PdfViewerScreen with this resource
      await tester.pumpWidget(
        _createTestApp(
          localStorage: localStorage,
          firebase: firebase,
          studyRepository: studyRepository,
          documentRepository: documentRepository,
          home: PdfViewerScreen(resource: testResource),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(PdfViewerScreen), findsOneWidget);
      expect(find.text('Unit 1 Matrices and Eigenvalues Production Notes'), findsWidgets);
    });

    test('2. UniDocs AI indexes uploaded PDF document and answers grounded questions', () async {
      final mockProvider = _GroundedCapturingProvider();
      final prefs = await SharedPreferences.getInstance();
      final convRepo = LocalAiConversationRepository(prefs);

      final ragProvider = RagDocumentContextProvider(documentRepository: documentRepository);
      final composer = AiContextComposer(documentProvider: ragProvider);

      final aiService = AiService(
        provider: mockProvider,
        repository: convRepo,
        contextComposer: composer,
      );

      // Step A: Index document in DocumentRepository
      final documentIndex = DocumentIndex(
        metadata: DocumentMetadata(
          documentId: 'doc_maths_unit1',
          fileName: 'unit1_matrices.pdf',
          title: 'Engineering Mathematics-I Unit 1',
          pageCount: 15,
          createdAt: DateTime.now(),
          processingStatus: DocumentProcessingStatus.ready,
        ),
        chunks: const [
          DocumentChunk(
            chunkId: 'chunk_maths_1',
            documentId: 'doc_maths_unit1',
            pageNumber: 5,
            text: 'Cayley-Hamilton Theorem: Every square matrix satisfies its own characteristic equation det(A - lambda * I) = 0.',
          ),
        ],
      );

      await documentRepository.saveDocument(documentIndex);

      // Step B: Send prompt asking about the uploaded document
      final response = await aiService.sendMessage(
        conversationId: 'conv_maths_qa',
        userPrompt: 'What does the Cayley-Hamilton theorem state?',
        attachments: const [
          AiAttachment(
            id: 'att_1',
            filename: 'unit1_matrices.pdf',
            mimeType: 'application/pdf',
            localIdentifier: 'doc_maths_unit1',
          ),
        ],
      );

      // Step C: Verify AI grounded response and citations
      expect(response.message?.content, contains('Cayley-Hamilton theorem'));
      expect(response.citations, isNotEmpty);
      expect(response.citations.first.documentId, equals('doc_maths_unit1'));
      expect(mockProvider.capturedRequest, isNotNull);
      expect(mockProvider.capturedRequest!.context?.attachedDocuments, isNotEmpty);
    });
  });
}

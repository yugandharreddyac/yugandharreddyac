import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csse_study_hub/data/datasources/ai_context_builder.dart';
import 'package:csse_study_hub/data/datasources/ai_provider_interface.dart';
import 'package:csse_study_hub/data/models/ai_attachment.dart';
import 'package:csse_study_hub/data/models/ai_message.dart';
import 'package:csse_study_hub/data/models/ai_request.dart';
import 'package:csse_study_hub/data/models/ai_response.dart';
import 'package:csse_study_hub/data/models/document_models.dart';
import 'package:csse_study_hub/data/repositories/ai_conversation_repository.dart';
import 'package:csse_study_hub/data/repositories/document_repository.dart';
import 'package:csse_study_hub/data/services/ai_service.dart';

class _CapturingAiProvider implements AiProvider {
  AiRequest? lastRequest;

  @override
  String get providerId => 'capturing_mock';

  @override
  String get displayName => 'Capturing Mock';

  @override
  Set<AiCapability> get supportedCapabilities =>
      {AiCapability.chat, AiCapability.documentQA};

  @override
  Future<bool> checkHealth() async => true;

  @override
  Future<AiResponse> generateResponse(AiRequest request) async {
    lastRequest = request;
    return AiResponse.success(
      id: 'resp_1',
      message: AiMessage(
        id: 'msg_assistant_1',
        conversationId: request.conversationId,
        role: AiMessageRole.assistant,
        content:
            'According to the provided document, deadlock prevention invalidates circular wait.',
        timestamp: DateTime.now(),
        metadata: {
          'citations': [
            {
              'sourceTitle': 'OS Unit 3 Notes',
              'sourceReference': 'Page 22',
              'snippet': 'Deadlock prevention invalidates circular wait.',
            }
          ]
        },
      ),
      citations: [
        AiCitation.fromDocument(
          documentTitle: 'OS Unit 3 Notes',
          documentId: 'doc_test_1',
          pageNumber: 22,
          snippet: 'Deadlock prevention invalidates circular wait.',
        ),
      ],
    );
  }

  @override
  Stream<String> streamResponse(AiRequest request) async* {
    yield 'Grounded response';
  }
}

void main() {
  group('Document AI & RAG End-to-End Integration Tests', () {
    late InMemoryDocumentRepository docRepo;
    late _CapturingAiProvider mockProvider;
    late AiService aiService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final convRepo = LocalAiConversationRepository(prefs);

      docRepo = InMemoryDocumentRepository();
      mockProvider = _CapturingAiProvider();

      final ragProvider =
          RagDocumentContextProvider(documentRepository: docRepo);
      final composer = AiContextComposer(documentProvider: ragProvider);

      aiService = AiService(
        provider: mockProvider,
        repository: convRepo,
        contextComposer: composer,
      );

      // Seed an indexed document in DocumentRepository
      final index = DocumentIndex(
        metadata: DocumentMetadata(
          documentId: 'doc_os_unit3',
          fileName: 'os_unit_3_concurrency.pdf',
          title: 'OS Unit 3 Concurrency & Deadlocks',
          pageCount: 35,
          createdAt: DateTime.now(),
          processingStatus: DocumentProcessingStatus.ready,
        ),
        chunks: const [
          DocumentChunk(
            chunkId: 'c_os_1',
            documentId: 'doc_os_unit3',
            pageNumber: 10,
            text:
                'Semaphores and mutex locks are fundamental synchronization primitives.',
          ),
          DocumentChunk(
            chunkId: 'c_os_2',
            documentId: 'doc_os_unit3',
            pageNumber: 22,
            text:
                'Deadlock prevention invalidates one of the four Coffman conditions, such as circular wait.',
          ),
        ],
      );

      await docRepo.saveDocument(index);
    });

    test(
        'AiService queries RAG context and passes page-grounded instructions to AI Provider',
        () async {
      final attachment = const AiAttachment(
        id: 'doc_os_unit3',
        filename: 'os_unit_3_concurrency.pdf',
        mimeType: 'application/pdf',
        status: AiAttachmentStatus.processed,
      );

      final response = await aiService.sendMessage(
        conversationId: 'conv_rag_test',
        userPrompt: 'How does deadlock prevention work?',
        attachments: [attachment],
        capability: AiCapability.documentQA,
      );

      expect(response.isSuccessful, isTrue);
      expect(mockProvider.lastRequest, isNotNull);

      // Verify system instructions contain the retrieved chunk and page reference
      final instructions =
          mockProvider.lastRequest!.context.systemInstructions ?? '';
      expect(instructions,
          contains('DOCUMENT CONTEXT: "OS Unit 3 Concurrency & Deadlocks"'));
      expect(instructions, contains('[Page 22]'));
      expect(
          instructions,
          contains(
              'Deadlock prevention invalidates one of the four Coffman conditions'));
      expect(
          instructions, contains('Do not fabricate missing document content'));

      // Verify response citations
      expect(response.citations.isNotEmpty, isTrue);
      expect(response.citations.first.isDocumentCitation, isTrue);
      expect(response.citations.first.pageNumber, equals(22));
    });

    test('Multiple documents in attachments are searched and combined cleanly',
        () async {
      final doc2 = DocumentIndex(
        metadata: DocumentMetadata(
          documentId: 'doc_algo_1',
          fileName: 'dsa_algorithms.pdf',
          title: 'DSA Quick Guide',
          createdAt: DateTime.now(),
          processingStatus: DocumentProcessingStatus.ready,
        ),
        chunks: const [
          DocumentChunk(
            chunkId: 'c_algo_1',
            documentId: 'doc_algo_1',
            pageNumber: 5,
            text:
                'Dijkstra algorithm computes the shortest path in weighted graphs.',
          ),
        ],
      );
      await docRepo.saveDocument(doc2);

      final attachments = [
        const AiAttachment(
          id: 'doc_os_unit3',
          filename: 'os_unit_3_concurrency.pdf',
          mimeType: 'application/pdf',
        ),
        const AiAttachment(
          id: 'doc_algo_1',
          filename: 'dsa_algorithms.pdf',
          mimeType: 'application/pdf',
        ),
      ];

      await aiService.sendMessage(
        conversationId: 'conv_multi_test',
        userPrompt: 'Tell me about Dijkstra shortest path',
        attachments: attachments,
      );

      final instructions =
          mockProvider.lastRequest!.context.systemInstructions ?? '';
      expect(instructions, contains('DOCUMENT CONTEXT: "DSA Quick Guide"'));
      expect(instructions, contains('[Page 5]'));
      expect(instructions,
          contains('Dijkstra algorithm computes the shortest path'));
    });
  });
}

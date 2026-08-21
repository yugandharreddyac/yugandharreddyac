import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/datasources/ai_context_builder.dart';
import 'package:csse_study_hub/data/models/ai_attachment.dart';
import 'package:csse_study_hub/data/models/document_models.dart';
import 'package:csse_study_hub/data/repositories/document_repository.dart';

void main() {
  group('RagDocumentContextProvider Tests', () {
    late InMemoryDocumentRepository repo;
    late RagDocumentContextProvider ragProvider;

    setUp(() async {
      repo = InMemoryDocumentRepository();
      ragProvider = RagDocumentContextProvider(documentRepository: repo);

      final index = DocumentIndex(
        metadata: DocumentMetadata(
          documentId: 'doc_rag_1',
          fileName: 'dbms_unit3.pdf',
          title: 'Database Normalization',
          pageCount: 20,
          createdAt: DateTime.now(),
          processingStatus: DocumentProcessingStatus.ready,
        ),
        chunks: const [
          DocumentChunk(
            chunkId: 'c1',
            documentId: 'doc_rag_1',
            pageNumber: 15,
            text:
                'First Normal Form (1NF) requires all attribute values to be atomic.',
          ),
          DocumentChunk(
            chunkId: 'c2',
            documentId: 'doc_rag_1',
            pageNumber: 18,
            text:
                'Third Normal Form (3NF) eliminates transitive dependencies for non-prime attributes.',
          ),
          DocumentChunk(
            chunkId: 'c3',
            documentId: 'doc_rag_1',
            pageNumber: 20,
            text:
                'BCNF is a stricter version of 3NF where for every dependency X -> Y, X must be a super key.',
          ),
        ],
      );

      await repo.saveDocument(index);
    });

    test('buildFromAttachments returns unmodifiable list', () {
      final attachments = [
        const AiAttachment(
          id: 'doc_rag_1',
          filename: 'dbms_unit3.pdf',
          mimeType: 'application/pdf',
          status: AiAttachmentStatus.processed,
        ),
      ];

      final result = ragProvider.buildFromAttachments(attachments);
      expect(result.length, equals(1));
      expect(result.first.filename, equals('dbms_unit3.pdf'));
    });

    test(
        'buildGroundedContext returns formatted excerpt with page numbers and anti-hallucination rules',
        () async {
      final attachments = [
        const AiAttachment(
          id: 'doc_rag_1',
          filename: 'dbms_unit3.pdf',
          mimeType: 'application/pdf',
          status: AiAttachmentStatus.processed,
        ),
      ];

      final contextText = await ragProvider.buildGroundedContext(
        userQuery: 'What is Third Normal Form 3NF?',
        attachments: attachments,
      );

      expect(contextText, isNotNull);
      expect(
          contextText, contains('DOCUMENT CONTEXT: "Database Normalization"'));
      expect(contextText, contains('[Page 18]'));
      expect(contextText, contains('transitive dependencies'));
      expect(
          contextText, contains('INSTRUCTIONS FOR DOCUMENT-GROUNDED ANSWERS'));
      expect(
          contextText, contains('Do not fabricate missing document content'));
    });

    test('buildGroundedContext returns null when no matching documents exist',
        () async {
      final attachments = [
        const AiAttachment(
          id: 'non_existent_doc',
          filename: 'missing.pdf',
          mimeType: 'application/pdf',
        ),
      ];

      final contextText = await ragProvider.buildGroundedContext(
        userQuery: 'Any query',
        attachments: attachments,
      );

      expect(contextText, isNull);
    });

    test('AiContextComposer incorporates RAG context into system instructions',
        () {
      final composer = AiContextComposer(
        documentProvider: ragProvider,
      );

      const customRagPrompt =
          '\n--- DOCUMENT CONTEXT: "Test" ---\n[Page 5] Test chunk\n';

      final context = composer.compose(
        userQuery: 'Explain test',
        documentContextText: customRagPrompt,
      );

      expect(context.systemInstructions, contains('DOCUMENT CONTEXT: "Test"'));
      expect(context.systemInstructions, contains('[Page 5] Test chunk'));
      expect(context.systemInstructions, contains('UniDocs AI'));
    });
  });
}

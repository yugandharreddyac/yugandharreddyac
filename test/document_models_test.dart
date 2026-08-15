import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/models/document_models.dart';
import 'package:csse_study_hub/data/models/ai_response.dart';

void main() {
  group('Document Models Tests', () {
    test('DocumentMetadata serialization and status helpers', () {
      final now = DateTime(2026, 8, 15, 12, 0);
      final meta = DocumentMetadata(
        documentId: 'doc_123',
        fileName: 'os_concepts.pdf',
        fileSizeBytes: 2048000,
        pageCount: 42,
        title: 'Operating System Concepts',
        sourceType: DocumentSourceType.localUserFile,
        createdAt: now,
        processingStatus: DocumentProcessingStatus.ready,
      );

      expect(meta.isReady, isTrue);
      expect(meta.isFailed, isFalse);
      expect(meta.isUnsupported, isFalse);
      expect(meta.isInProgress, isFalse);

      final map = meta.toMap();
      final fromMap = DocumentMetadata.fromMap(map);

      expect(fromMap.documentId, equals('doc_123'));
      expect(fromMap.fileName, equals('os_concepts.pdf'));
      expect(fromMap.fileSizeBytes, equals(2048000));
      expect(fromMap.pageCount, equals(42));
      expect(fromMap.title, equals('Operating System Concepts'));
      expect(fromMap.sourceType, equals(DocumentSourceType.localUserFile));
      expect(fromMap.processingStatus, equals(DocumentProcessingStatus.ready));

      final jsonStr = meta.toJson();
      final fromJson = DocumentMetadata.fromJson(jsonStr);
      expect(fromJson.documentId, equals(meta.documentId));
    });

    test('DocumentProcessingStatus labels and terminal states', () {
      expect(DocumentProcessingStatus.idle.displayLabel, equals('Idle'));
      expect(DocumentProcessingStatus.validating.isInProgress, isTrue);
      expect(DocumentProcessingStatus.extracting.isInProgress, isTrue);
      expect(DocumentProcessingStatus.chunking.isInProgress, isTrue);
      expect(DocumentProcessingStatus.indexing.isInProgress, isTrue);
      expect(DocumentProcessingStatus.ready.isTerminal, isTrue);
      expect(DocumentProcessingStatus.failed.isTerminal, isTrue);
      expect(DocumentProcessingStatus.unsupported.isTerminal, isTrue);
    });

    test('DocumentPage serialization and word metrics', () {
      const page = DocumentPage(
        pageNumber: 3,
        extractedText: 'A deadlock is a situation where a set of processes are blocked.',
      );

      expect(page.pageNumber, equals(3));
      expect(page.isNotEmpty, isTrue);
      expect(page.characterCount, greaterThan(20));

      final map = page.toMap();
      final reconstructed = DocumentPage.fromMap(map);
      expect(reconstructed.pageNumber, equals(3));
      expect(reconstructed.extractedText, equals(page.extractedText));
    });

    test('DocumentChunk serialization and getters', () {
      const chunk = DocumentChunk(
        chunkId: 'doc_1_p2_c0',
        documentId: 'doc_1',
        pageNumber: 2,
        text: 'Semaphores are integer variables used for process synchronization.',
        startOffset: 0,
        endOffset: 66,
        tokenEstimate: 12,
        metadata: {'author': 'Galvin'},
      );

      expect(chunk.chunkId, equals('doc_1_p2_c0'));
      expect(chunk.isEmpty, isFalse);

      final map = chunk.toMap();
      final fromMap = DocumentChunk.fromMap(map);
      expect(fromMap.chunkId, equals('doc_1_p2_c0'));
      expect(fromMap.documentId, equals('doc_1'));
      expect(fromMap.pageNumber, equals(2));
      expect(fromMap.metadata['author'], equals('Galvin'));
    });

    test('DocumentIndex unification and copyWith', () {
      final meta = DocumentMetadata(
        documentId: 'doc_idx_1',
        fileName: 'dbms.pdf',
        createdAt: DateTime.now(),
        processingStatus: DocumentProcessingStatus.ready,
      );

      const page = DocumentPage(pageNumber: 1, extractedText: 'Relational model');
      const chunk = DocumentChunk(
        chunkId: 'c1',
        documentId: 'doc_idx_1',
        pageNumber: 1,
        text: 'Relational model chunk',
      );

      final index = DocumentIndex(
        metadata: meta,
        pages: [page],
        chunks: [chunk],
      );

      expect(index.documentId, equals('doc_idx_1'));
      expect(index.isReady, isTrue);
      expect(index.chunkCount, equals(1));
      expect(index.pageCount, equals(0)); // metadata pageCount

      final jsonStr = index.toJson();
      final fromJson = DocumentIndex.fromJson(jsonStr);
      expect(fromJson.documentId, equals('doc_idx_1'));
      expect(fromJson.chunks.length, equals(1));
    });

    test('Extended AiCitation model support for document pages', () {
      final docCitation = AiCitation.fromDocument(
        documentTitle: 'Operating Systems Notes',
        documentId: 'doc_os_1',
        pageNumber: 42,
        snippet: 'Deadlock prevention requires invalidating one of the 4 conditions.',
      );

      expect(docCitation.isDocumentCitation, isTrue);
      expect(docCitation.hasPageNumber, isTrue);
      expect(docCitation.pageNumber, equals(42));
      expect(docCitation.sourceReference, equals('Page 42'));
      expect(docCitation.sourceTitle, equals('Operating Systems Notes'));

      final map = docCitation.toMap();
      final fromMap = AiCitation.fromMap(map);
      expect(fromMap.pageNumber, equals(42));
      expect(fromMap.documentId, equals('doc_os_1'));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/models/document_models.dart';
import 'package:csse_study_hub/data/repositories/document_repository.dart';

void main() {
  group('InMemoryDocumentRepository Tests', () {
    late InMemoryDocumentRepository repo;

    setUp(() {
      repo = InMemoryDocumentRepository();
    });

    test('Initial repository is empty', () {
      expect(repo.documentCount, equals(0));
      expect(repo.documentIds, isEmpty);
    });

    test('Save and retrieve document index', () async {
      final meta = DocumentMetadata(
        documentId: 'doc_1',
        fileName: 'algorithms.pdf',
        createdAt: DateTime.now(),
        processingStatus: DocumentProcessingStatus.ready,
      );

      const chunk = DocumentChunk(
        chunkId: 'c_1',
        documentId: 'doc_1',
        pageNumber: 1,
        text: 'Divide and conquer algorithms solve subproblems recursively.',
      );

      final index = DocumentIndex(
        metadata: meta,
        pages: const [DocumentPage(pageNumber: 1, extractedText: 'Divide and conquer')],
        chunks: const [chunk],
      );

      await repo.saveDocument(index);

      expect(repo.documentCount, equals(1));
      expect(repo.documentIds, contains('doc_1'));

      final retrieved = await repo.getDocument('doc_1');
      expect(retrieved, isNotNull);
      expect(retrieved!.metadata.fileName, equals('algorithms.pdf'));
      expect(retrieved.chunks.length, equals(1));
    });

    test('Update chunks for existing document', () async {
      final meta = DocumentMetadata(
        documentId: 'doc_upd',
        fileName: 'ds.pdf',
        createdAt: DateTime.now(),
      );
      await repo.saveDocument(DocumentIndex(metadata: meta));

      const newChunk = DocumentChunk(
        chunkId: 'nc_1',
        documentId: 'doc_upd',
        pageNumber: 5,
        text: 'Binary Search Trees provide logarithmic search time.',
      );

      await repo.saveChunks('doc_upd', [newChunk]);

      final chunks = await repo.getChunks('doc_upd');
      expect(chunks.length, equals(1));
      expect(chunks.first.text, contains('Binary Search Trees'));
    });

    test('Delete and clear operations isolate documents', () async {
      final doc1 = DocumentIndex(
        metadata: DocumentMetadata(documentId: 'd1', fileName: 'f1.pdf', createdAt: DateTime.now()),
      );
      final doc2 = DocumentIndex(
        metadata: DocumentMetadata(documentId: 'd2', fileName: 'f2.pdf', createdAt: DateTime.now()),
      );

      await repo.saveDocument(doc1);
      await repo.saveDocument(doc2);
      expect(repo.documentCount, equals(2));

      await repo.deleteDocument('d1');
      expect(repo.documentCount, equals(1));
      expect(await repo.getDocument('d1'), isNull);
      expect(await repo.getDocument('d2'), isNotNull);

      await repo.clearAllDocuments();
      expect(repo.documentCount, equals(0));
    });

    test('Search chunks executes keyword retrieval', () async {
      final doc = DocumentIndex(
        metadata: DocumentMetadata(
          documentId: 'doc_search',
          fileName: 'os_deadlocks.pdf',
          title: 'Operating Systems Deadlocks',
          createdAt: DateTime.now(),
        ),
        chunks: const [
          DocumentChunk(
            chunkId: 'c1',
            documentId: 'doc_search',
            pageNumber: 10,
            text: 'Mutual exclusion is one of the four necessary deadlock conditions.',
          ),
          DocumentChunk(
            chunkId: 'c2',
            documentId: 'doc_search',
            pageNumber: 15,
            text: 'Virtual memory uses paging to swap inactive pages to disk.',
          ),
        ],
      );

      await repo.saveDocument(doc);

      final results = await repo.searchChunks('doc_search', 'mutual exclusion deadlock');
      expect(results, isNotEmpty);
      expect(results.first.chunk.chunkId, equals('c1'));
      expect(results.first.pageNumber, equals(10));
      expect(results.first.matchedTerms, contains('deadlock'));
    });
  });
}

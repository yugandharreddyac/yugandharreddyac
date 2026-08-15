import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/datasources/keyword_document_retriever.dart';
import 'package:csse_study_hub/data/models/document_models.dart';

void main() {
  group('KeywordDocumentRetriever Tests', () {
    const retriever = KeywordDocumentRetriever();

    final chunks = const [
      DocumentChunk(
        chunkId: 'chunk_1',
        documentId: 'doc_os',
        pageNumber: 1,
        text: 'Operating Systems Overview: Processes, Threads, CPU Scheduling, and Memory Management.',
      ),
      DocumentChunk(
        chunkId: 'chunk_2',
        documentId: 'doc_os',
        pageNumber: 12,
        text: 'Deadlock prevention methods include eliminating mutual exclusion, hold and wait, no preemption, and circular wait.',
      ),
      DocumentChunk(
        chunkId: 'chunk_3',
        documentId: 'doc_os',
        pageNumber: 14,
        text: 'Bankers algorithm is a deadlock avoidance algorithm that tests for safety before resource allocation.',
      ),
      DocumentChunk(
        chunkId: 'chunk_4',
        documentId: 'doc_os',
        pageNumber: 25,
        text: 'Virtual memory management uses page tables, translation lookaside buffers (TLB), and demand paging.',
      ),
    ];

    test('Empty query returns empty results', () async {
      final results = await retriever.search('', chunks);
      expect(results, isEmpty);
    });

    test('Empty chunks collection returns empty results', () async {
      final results = await retriever.search('deadlock', []);
      expect(results, isEmpty);
    });

    test('Single keyword returns matching chunks ranked by term match', () async {
      final results = await retriever.search('deadlock', chunks);

      expect(results, isNotEmpty);
      expect(results.length, equals(2)); // chunk_2 and chunk_3
      final chunkIds = results.map((r) => r.chunk.chunkId).toList();
      expect(chunkIds, containsAll(['chunk_2', 'chunk_3']));
    });

    test('Exact multi-word phrase receives bonus boost and ranks highest', () async {
      final results = await retriever.search(
        'deadlock prevention methods',
        chunks,
        documentTitle: 'Operating Systems Unit 3',
      );

      expect(results, isNotEmpty);
      expect(results.first.chunk.chunkId, equals('chunk_2'));
      expect(results.first.pageNumber, equals(12));
      expect(results.first.relevanceScore, greaterThan(5.0)); // Exact phrase bonus
    });

    test('Result limit is strictly respected', () async {
      final manyChunks = List.generate(
        20,
        (i) => DocumentChunk(
          chunkId: 'c_$i',
          documentId: 'doc_test',
          pageNumber: i + 1,
          text: 'Computer science data structure algorithm search topic $i',
        ),
      );

      final results = await retriever.search('algorithm', manyChunks, limit: 5);
      expect(results.length, equals(5));
    });

    test('Stop words are ignored to avoid false positives', () async {
      final results = await retriever.search('what is the in and on', chunks);
      expect(results, isEmpty);
    });

    test('Page number is accurately exposed on search results', () async {
      final results = await retriever.search('Bankers algorithm', chunks);
      expect(results, isNotEmpty);
      expect(results.first.pageNumber, equals(14));
    });
  });
}

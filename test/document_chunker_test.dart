import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/datasources/document_chunker.dart';
import 'package:csse_study_hub/data/models/document_models.dart';

void main() {
  group('DocumentChunker Tests', () {
    const chunker = DocumentChunker(
      targetChunkWords: 50,
      overlapWords: 10,
      minChunkWords: 5,
    );

    test('Empty pages list returns empty chunk list', () {
      final chunks = chunker.chunkDocument(documentId: 'doc_empty', pages: []);
      expect(chunks, isEmpty);
    });

    test('Empty page content is skipped', () {
      final pages = [
        const DocumentPage(pageNumber: 1, extractedText: '   '),
        const DocumentPage(pageNumber: 2, extractedText: ''),
      ];
      final chunks =
          chunker.chunkDocument(documentId: 'doc_blank', pages: pages);
      expect(chunks, isEmpty);
    });

    test('Short page within target words yields a single chunk', () {
      final pages = [
        const DocumentPage(
          pageNumber: 1,
          extractedText:
              'Process synchronization is the task of coordinating process execution.',
        ),
      ];

      final chunks =
          chunker.chunkDocument(documentId: 'doc_sync', pages: pages);
      expect(chunks.length, equals(1));
      expect(chunks.first.pageNumber, equals(1));
      expect(chunks.first.chunkId, equals('doc_sync_p1_c0'));
      expect(chunks.first.text, contains('coordinating process execution'));
    });

    test('Multi-page document preserves page numbers across all chunks', () {
      final page1Words = List.generate(80, (i) => 'word$i').join(' ');
      final page2Words = List.generate(80, (i) => 'term$i').join(' ');

      final pages = [
        DocumentPage(pageNumber: 1, extractedText: page1Words),
        DocumentPage(pageNumber: 2, extractedText: page2Words),
      ];

      final chunks =
          chunker.chunkDocument(documentId: 'doc_multi', pages: pages);

      expect(chunks.length, greaterThanOrEqualTo(2));
      final p1Chunks = chunks.where((c) => c.pageNumber == 1);
      final p2Chunks = chunks.where((c) => c.pageNumber == 2);

      expect(p1Chunks, isNotEmpty);
      expect(p2Chunks, isNotEmpty);

      for (final c in p1Chunks) {
        expect(c.text, contains('word'));
      }
      for (final c in p2Chunks) {
        expect(c.text, contains('term'));
      }
    });

    test(
        'Sliding window overlap creates overlapping words between consecutive chunks',
        () {
      final words = List.generate(100, (i) => 'Item$i').join(' ');
      final pages = [DocumentPage(pageNumber: 1, extractedText: words)];

      final chunks =
          chunker.chunkDocument(documentId: 'doc_overlap', pages: pages);

      expect(chunks.length, greaterThanOrEqualTo(2));
      // First chunk should have Item0..Item49
      // Second chunk should start with Item40..Item49 (overlap of 10 words)
      expect(chunks[0].text, contains('Item40'));
      expect(chunks[1].text, contains('Item40'));
    });

    test(
        'Deterministic chunking produces identical output given identical input',
        () {
      final text =
          'Deterministic algorithm guarantees identical state across multiple runs with exact hashes.';
      final pages = [DocumentPage(pageNumber: 1, extractedText: text)];

      final run1 = chunker.chunkDocument(documentId: 'doc_det', pages: pages);
      final run2 = chunker.chunkDocument(documentId: 'doc_det', pages: pages);

      expect(run1.length, equals(run2.length));
      expect(run1.first.text, equals(run2.first.text));
      expect(run1.first.chunkId, equals(run2.first.chunkId));
      expect(run1.first.tokenEstimate, equals(run2.first.tokenEstimate));
    });
  });
}

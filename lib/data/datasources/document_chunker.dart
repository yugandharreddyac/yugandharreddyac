import '../models/document_models.dart';

/// Configurable, page-aware text chunker that preserves document structure
class DocumentChunker {
  final int targetChunkWords;
  final int overlapWords;
  final int minChunkWords;

  const DocumentChunker({
    this.targetChunkWords = 200,
    this.overlapWords = 30,
    this.minChunkWords = 15,
  }) : assert(overlapWords < targetChunkWords,
            'Overlap must be strictly smaller than target chunk size');

  /// Splits document pages into bounded, page-aware chunks
  List<DocumentChunk> chunkDocument({
    required String documentId,
    required List<DocumentPage> pages,
  }) {
    if (pages.isEmpty) return [];

    final chunks = <DocumentChunk>[];

    for (final page in pages) {
      if (page.isEmpty) continue;

      final pageChunks = _chunkSinglePage(
        documentId: documentId,
        page: page,
        startingGlobalIndex: chunks.length,
      );

      chunks.addAll(pageChunks);
    }

    return chunks;
  }

  List<DocumentChunk> _chunkSinglePage({
    required String documentId,
    required DocumentPage page,
    required int startingGlobalIndex,
  }) {
    final text = page.extractedText.trim();
    if (text.isEmpty) return [];

    // Split text into paragraphs first to respect paragraph boundaries
    final paragraphs = text.split(RegExp(r'\n\s*\n'));
    final words = <String>[];

    for (final p in paragraphs) {
      final pWords =
          p.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
      if (pWords.isNotEmpty) {
        words.addAll(pWords);
        // Add paragraph break token if needed, or simply let word sequence flow
      }
    }

    if (words.isEmpty) return [];

    // If total words on page is smaller than target + min threshold, keep as single chunk
    if (words.length <= targetChunkWords + minChunkWords) {
      final chunkText = words.join(' ');
      final tokenEst = (words.length * 1.33).round();
      return [
        DocumentChunk(
          chunkId: '${documentId}_p${page.pageNumber}_c0',
          documentId: documentId,
          pageNumber: page.pageNumber,
          text: chunkText,
          startOffset: 0,
          endOffset: chunkText.length,
          tokenEstimate: tokenEst,
          metadata: {
            'pageNumber': page.pageNumber,
            'chunkIndexOnPage': 0,
            'wordCount': words.length,
          },
        )
      ];
    }

    // Sliding window chunking with overlap
    final pageChunks = <DocumentChunk>[];
    int cursor = 0;
    int chunkIndex = 0;

    while (cursor < words.length) {
      final end = (cursor + targetChunkWords).clamp(0, words.length);
      final chunkWords = words.sublist(cursor, end);

      if (chunkWords.length < minChunkWords && pageChunks.isNotEmpty) {
        // Append remaining words to the previous chunk if too short
        final last = pageChunks.removeLast();
        final combinedText = '${last.text} ${chunkWords.join(' ')}';
        final combinedTokens =
            (last.tokenEstimate + chunkWords.length * 1.33).round();
        pageChunks.add(
          last.copyWith(
            text: combinedText,
            endOffset: combinedText.length,
            tokenEstimate: combinedTokens,
          ),
        );
        break;
      }

      final chunkText = chunkWords.join(' ');
      final tokenEst = (chunkWords.length * 1.33).round();

      pageChunks.add(
        DocumentChunk(
          chunkId: '${documentId}_p${page.pageNumber}_c$chunkIndex',
          documentId: documentId,
          pageNumber: page.pageNumber,
          text: chunkText,
          startOffset: cursor,
          endOffset: cursor + chunkText.length,
          tokenEstimate: tokenEst,
          metadata: {
            'pageNumber': page.pageNumber,
            'chunkIndexOnPage': chunkIndex,
            'wordCount': chunkWords.length,
          },
        ),
      );

      if (end >= words.length) break;

      // Advance cursor taking overlap into account
      cursor += (targetChunkWords - overlapWords);
      chunkIndex++;
    }

    return pageChunks;
  }
}

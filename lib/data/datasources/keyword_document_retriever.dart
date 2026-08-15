import '../models/document_models.dart';

/// Contract for document search and chunk retrieval
abstract class DocumentRetriever {
  /// Searches a collection of chunks for the most relevant matches to the query
  Future<List<DocumentSearchResult>> search(
    String query,
    List<DocumentChunk> chunks, {
    int limit = 8,
    String? documentTitle,
  });
}

/// Deterministic keyword and phrase-matching document retrieval engine
class KeywordDocumentRetriever implements DocumentRetriever {
  static const Set<String> _stopWords = {
    'a', 'an', 'the', 'and', 'or', 'but', 'is', 'are', 'was', 'were',
    'in', 'on', 'at', 'by', 'for', 'with', 'about', 'against', 'between',
    'into', 'through', 'during', 'before', 'after', 'above', 'below', 'to',
    'from', 'up', 'down', 'of', 'off', 'over', 'under', 'again', 'further',
    'then', 'once', 'here', 'there', 'when', 'where', 'why', 'how', 'all',
    'any', 'both', 'each', 'few', 'more', 'most', 'other', 'some', 'such',
    'no', 'nor', 'not', 'only', 'own', 'same', 'so', 'than', 'too', 'very',
    'can', 'will', 'just', 'should', 'now', 'what', 'which', 'who', 'whom',
    'this', 'that', 'these', 'those', 'am', 'been', 'being', 'have', 'has',
    'had', 'do', 'does', 'did', 'explain', 'give', 'tell', 'me', 'please',
  };

  const KeywordDocumentRetriever();

  @override
  Future<List<DocumentSearchResult>> search(
    String query,
    List<DocumentChunk> chunks, {
    int limit = 8,
    String? documentTitle,
  }) async {
    if (query.trim().isEmpty || chunks.isEmpty) return [];

    final normalizedQuery = query.toLowerCase().trim();
    final queryTokens = _tokenizeAndFilter(normalizedQuery);
    if (queryTokens.isEmpty) return [];

    final results = <DocumentSearchResult>[];

    for (final chunk in chunks) {
      if (chunk.isEmpty) continue;

      final chunkTextLower = chunk.text.toLowerCase();
      final chunkTokens = _tokenize(chunkTextLower);
      final tokenSet = chunkTokens.toSet();

      double score = 0.0;
      final matchedTerms = <String>[];

      // 1. Term frequency scoring
      for (final qToken in queryTokens) {
        if (tokenSet.contains(qToken)) {
          matchedTerms.add(qToken);
          // Frequency in chunk
          final freq = chunkTokens.where((t) => t == qToken).length;
          score += (1.0 + (freq * 0.5));
        } else if (chunkTextLower.contains(qToken)) {
          // Substring match
          matchedTerms.add(qToken);
          score += 0.5;
        }
      }

      if (matchedTerms.isEmpty) continue;

      // 2. Exact phrase boost
      if (normalizedQuery.length > 5 && chunkTextLower.contains(normalizedQuery)) {
        score += 5.0; // Significant bonus for full question/phrase presence
      } else {
        // Multi-term bigram boost
        for (int i = 0; i < queryTokens.length - 1; i++) {
          final bigram = '${queryTokens[i]} ${queryTokens[i + 1]}';
          if (chunkTextLower.contains(bigram)) {
            score += 2.0;
          }
        }
      }

      // 3. Early page / title relevance boost
      if (chunk.pageNumber == 1) {
        score += 0.2; // Slight boost for intro/overview page
      }

      if (documentTitle != null && documentTitle.isNotEmpty) {
        final titleTokens = _tokenizeAndFilter(documentTitle.toLowerCase());
        final titleMatches = titleTokens.where((t) => queryTokens.contains(t)).length;
        if (titleMatches > 0) {
          score += (titleMatches * 0.3);
        }
      }

      // 4. Density bonus (matched unique terms / total query terms)
      final termCoverage = matchedTerms.toSet().length / queryTokens.length;
      score *= (0.5 + termCoverage);

      results.add(
        DocumentSearchResult(
          chunk: chunk,
          relevanceScore: score,
          matchedTerms: matchedTerms.toSet().toList(),
          pageNumber: chunk.pageNumber,
        ),
      );
    }

    // Sort descending by relevance
    results.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

    // Deduplicate overlapping or redundant chunks from same page with lower score
    final deduped = <DocumentSearchResult>[];
    final seenChunkTexts = <String>{};

    for (final r in results) {
      final condensed = r.chunk.text.substring(0, r.chunk.text.length.clamp(0, 80));
      if (!seenChunkTexts.contains(condensed)) {
        seenChunkTexts.add(condensed);
        deduped.add(r);
      }
      if (deduped.length >= limit) break;
    }

    return deduped;
  }

  List<String> _tokenizeAndFilter(String text) {
    return _tokenize(text).where((t) => !_stopWords.contains(t) && t.length > 1).toList();
  }

  List<String> _tokenize(String text) {
    return text
        .replaceAll(RegExp(r'[^a-zA-Z0-9\s_-]'), ' ')
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
  }
}

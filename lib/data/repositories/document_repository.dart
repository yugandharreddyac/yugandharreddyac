import '../datasources/keyword_document_retriever.dart';
import '../models/document_models.dart';

/// Repository contract for storing and querying processed documents and chunks
abstract class DocumentRepository {
  /// Saves a complete document index (metadata + pages + chunks)
  Future<void> saveDocument(DocumentIndex index);

  /// Retrieves document index by ID
  Future<DocumentIndex?> getDocument(String documentId);

  /// Deletes a document and all associated chunks from storage
  Future<void> deleteDocument(String documentId);

  /// Saves or updates chunks for an existing document
  Future<void> saveChunks(String documentId, List<DocumentChunk> chunks);

  /// Retrieves all chunks for a document
  Future<List<DocumentChunk>> getChunks(String documentId);

  /// Searches chunks belonging to a document using the configured retrieval engine
  Future<List<DocumentSearchResult>> searchChunks(
    String documentId,
    String query, {
    int limit = 8,
  });

  /// Clears chunks and pages for a specific document
  Future<void> clearDocument(String documentId);

  /// Clears all stored documents
  Future<void> clearAllDocuments();

  /// Returns list of all active document IDs
  List<String> get documentIds;

  /// Returns count of active stored documents
  int get documentCount;
}

/// In-memory implementation of DocumentRepository safe for mobile & web sessions
class InMemoryDocumentRepository implements DocumentRepository {
  static const int _maxCachedDocuments = 10;
  final Map<String, DocumentIndex> _store = {};
  final DocumentRetriever _retriever;

  InMemoryDocumentRepository({DocumentRetriever? retriever})
      : _retriever = retriever ?? const KeywordDocumentRetriever();

  @override
  List<String> get documentIds => List.unmodifiable(_store.keys);

  @override
  int get documentCount => _store.length;

  @override
  Future<void> saveDocument(DocumentIndex index) async {
    // Evict oldest if exceeding session cache limit
    if (_store.length >= _maxCachedDocuments && !_store.containsKey(index.documentId)) {
      final oldestKey = _store.keys.first;
      _store.remove(oldestKey);
    }
    _store[index.documentId] = index;
  }

  @override
  Future<DocumentIndex?> getDocument(String documentId) async {
    return _store[documentId];
  }

  @override
  Future<void> deleteDocument(String documentId) async {
    _store.remove(documentId);
  }

  @override
  Future<void> saveChunks(String documentId, List<DocumentChunk> chunks) async {
    final existing = _store[documentId];
    if (existing != null) {
      _store[documentId] = existing.copyWith(chunks: chunks);
    }
  }

  @override
  Future<List<DocumentChunk>> getChunks(String documentId) async {
    final doc = _store[documentId];
    return doc?.chunks ?? [];
  }

  @override
  Future<List<DocumentSearchResult>> searchChunks(
    String documentId,
    String query, {
    int limit = 8,
  }) async {
    final doc = _store[documentId];
    if (doc == null || doc.chunks.isEmpty) return [];

    return _retriever.search(
      query,
      doc.chunks,
      limit: limit,
      documentTitle: doc.metadata.title,
    );
  }

  @override
  Future<void> clearDocument(String documentId) async {
    _store.remove(documentId);
  }

  @override
  Future<void> clearAllDocuments() async {
    _store.clear();
  }
}

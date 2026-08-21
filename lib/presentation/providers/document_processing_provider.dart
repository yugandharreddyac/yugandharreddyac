import 'package:flutter/foundation.dart';
import '../../data/datasources/document_chunker.dart';
import '../../data/datasources/document_extractor.dart';
import '../../data/models/ai_attachment.dart';
import '../../data/models/document_models.dart';
import '../../data/repositories/document_repository.dart';

/// Presentation state manager for document ingestion, processing lifecycle, and RAG indexation
class DocumentProcessingProvider extends ChangeNotifier {
  final DocumentExtractor _extractor;
  final DocumentChunker _chunker;
  final DocumentRepository _repository;

  final Map<String, DocumentMetadata> _activeDocuments = {};
  final Set<String> _processingIds = {};

  DocumentProcessingProvider({
    DocumentExtractor? extractor,
    DocumentChunker? chunker,
    DocumentRepository? repository,
  })  : _extractor = extractor ?? const PdfDocumentExtractor(),
        _chunker = chunker ?? const DocumentChunker(),
        _repository = repository ?? InMemoryDocumentRepository();

  DocumentRepository get repository => _repository;
  Map<String, DocumentMetadata> get activeDocuments =>
      Map.unmodifiable(_activeDocuments);
  bool get hasActiveDocuments => _activeDocuments.isNotEmpty;
  bool isProcessing(String id) => _processingIds.contains(id);

  DocumentMetadata? getDocument(String id) => _activeDocuments[id];

  /// Ingests, validates, extracts text, chunks, and indexes a local PDF file
  Future<AiAttachment?> processFile(
    String filePath,
    String fileName, {
    DocumentSourceType sourceType = DocumentSourceType.localUserFile,
  }) async {
    final tempId =
        'doc_${DateTime.now().millisecondsSinceEpoch}_${fileName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}';
    _processingIds.add(tempId);

    // Step 1: Validating
    var meta = DocumentMetadata(
      documentId: tempId,
      fileName: fileName,
      sourceType: sourceType,
      createdAt: DateTime.now(),
      processingStatus: DocumentProcessingStatus.validating,
    );
    _activeDocuments[tempId] = meta;
    notifyListeners();

    try {
      // Step 2: Metadata & Signature validation
      meta = await _extractor.extractMetadata(filePath, fileName,
          sourceType: sourceType);
      _activeDocuments.remove(tempId);
      final docId = meta.documentId;
      _processingIds.remove(tempId);
      _processingIds.add(docId);
      _activeDocuments[docId] = meta;
      notifyListeners();

      if (meta.isFailed || meta.isUnsupported) {
        _processingIds.remove(docId);
        notifyListeners();
        return AiAttachment(
          id: docId,
          filename: fileName,
          mimeType: meta.mimeType,
          sizeBytes: meta.fileSizeBytes,
          sourceType: sourceType == DocumentSourceType.unidocsResource
              ? AiAttachmentSourceType.unidocsResource
              : AiAttachmentSourceType.localFile,
          localIdentifier: filePath,
          status: meta.isUnsupported
              ? AiAttachmentStatus.unsupported
              : AiAttachmentStatus.failed,
          metadata: {
            'error': meta.processingError,
          },
        );
      }

      // Step 3: Text Extraction
      _activeDocuments[docId] =
          meta.copyWith(processingStatus: DocumentProcessingStatus.extracting);
      notifyListeners();

      final pages = await _extractor.extractPages(filePath, meta);
      final totalExtractedChars =
          pages.fold<int>(0, (sum, p) => sum + p.characterCount);

      if (pages.isEmpty || totalExtractedChars < 10) {
        const errorMsg =
            'No readable digital text could be extracted. The PDF may be scanned or image-only.';
        _activeDocuments[docId] = meta.copyWith(
          processingStatus: DocumentProcessingStatus.unsupported,
          processingError: errorMsg,
        );
        _processingIds.remove(docId);
        notifyListeners();

        return AiAttachment(
          id: docId,
          filename: fileName,
          mimeType: meta.mimeType,
          sizeBytes: meta.fileSizeBytes,
          sourceType: sourceType == DocumentSourceType.unidocsResource
              ? AiAttachmentSourceType.unidocsResource
              : AiAttachmentSourceType.localFile,
          localIdentifier: filePath,
          status: AiAttachmentStatus.unsupported,
          metadata: {'error': errorMsg},
        );
      }

      // Step 4: Chunking
      _activeDocuments[docId] = meta.copyWith(
        pageCount: pages.length,
        processingStatus: DocumentProcessingStatus.chunking,
      );
      notifyListeners();

      final chunks = _chunker.chunkDocument(documentId: docId, pages: pages);

      // Step 5: Indexing in Repository
      _activeDocuments[docId] =
          meta.copyWith(processingStatus: DocumentProcessingStatus.indexing);
      notifyListeners();

      final docIndex = DocumentIndex(
        metadata: meta.copyWith(
          pageCount: pages.length,
          processingStatus: DocumentProcessingStatus.ready,
        ),
        pages: pages,
        chunks: chunks,
      );

      await _repository.saveDocument(docIndex);

      _activeDocuments[docId] = docIndex.metadata;
      _processingIds.remove(docId);
      notifyListeners();

      // Step 6: Return Ready AiAttachment
      final snippet = chunks.isNotEmpty
          ? chunks.first.text
              .substring(0, chunks.first.text.length.clamp(0, 150))
          : '';

      return AiAttachment(
        id: docId,
        filename: fileName,
        mimeType: meta.mimeType,
        sizeBytes: meta.fileSizeBytes,
        sourceType: sourceType == DocumentSourceType.unidocsResource
            ? AiAttachmentSourceType.unidocsResource
            : AiAttachmentSourceType.localFile,
        localIdentifier: filePath,
        status: AiAttachmentStatus.processed,
        extractedTextSnippet: snippet,
        metadata: {
          'pageCount': pages.length,
          'chunkCount': chunks.length,
          'title': meta.title,
          'documentId': docId,
        },
      );
    } catch (e) {
      final failedMeta = meta.copyWith(
        processingStatus: DocumentProcessingStatus.failed,
        processingError: 'Failed to process document: ${e.toString()}',
      );
      _activeDocuments[meta.documentId] = failedMeta;
      _processingIds.remove(meta.documentId);
      _processingIds.remove(tempId);
      notifyListeners();

      return AiAttachment(
        id: meta.documentId,
        filename: fileName,
        mimeType: 'application/pdf',
        status: AiAttachmentStatus.failed,
        metadata: {'error': failedMeta.processingError},
      );
    }
  }

  /// Removes an active document from session state and repository
  Future<void> removeDocument(String documentId) async {
    _activeDocuments.remove(documentId);
    _processingIds.remove(documentId);
    await _repository.deleteDocument(documentId);
    notifyListeners();
  }

  /// Clears all active documents
  Future<void> clearAll() async {
    _activeDocuments.clear();
    _processingIds.clear();
    await _repository.clearAllDocuments();
    notifyListeners();
  }

  /// Searches chunks inside an indexed document
  Future<List<DocumentSearchResult>> searchDocument(
    String documentId,
    String query, {
    int limit = 8,
  }) async {
    return _repository.searchChunks(documentId, query, limit: limit);
  }
}

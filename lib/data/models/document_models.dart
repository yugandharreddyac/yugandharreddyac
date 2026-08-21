import 'dart:convert';

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// Origin of the document — distinguishes user uploads from UniDocs resources
enum DocumentSourceType {
  localUserFile('local_user_file'),
  unidocsResource('unidocs_resource');

  final String value;
  const DocumentSourceType(this.value);

  static DocumentSourceType fromString(String? s) {
    if (s == null) return DocumentSourceType.localUserFile;
    return DocumentSourceType.values.firstWhere(
      (e) => e.value == s,
      orElse: () => DocumentSourceType.localUserFile,
    );
  }
}

/// Lifecycle status of a document being processed through the intelligence pipeline
enum DocumentProcessingStatus {
  idle('idle'),
  validating('validating'),
  extracting('extracting'),
  chunking('chunking'),
  indexing('indexing'),
  ready('ready'),
  failed('failed'),
  unsupported('unsupported');

  final String value;
  const DocumentProcessingStatus(this.value);

  static DocumentProcessingStatus fromString(String? s) {
    if (s == null) return DocumentProcessingStatus.idle;
    return DocumentProcessingStatus.values.firstWhere(
      (e) => e.value == s,
      orElse: () => DocumentProcessingStatus.idle,
    );
  }

  /// Human-readable status label for display
  String get displayLabel {
    switch (this) {
      case idle:
        return 'Idle';
      case validating:
        return 'Validating PDF...';
      case extracting:
        return 'Extracting text...';
      case chunking:
        return 'Preparing document...';
      case indexing:
        return 'Building index...';
      case ready:
        return 'Ready';
      case failed:
        return 'Processing failed';
      case unsupported:
        return 'Unsupported format';
    }
  }

  bool get isTerminal => this == ready || this == failed || this == unsupported;
  bool get isInProgress =>
      this == validating ||
      this == extracting ||
      this == chunking ||
      this == indexing;
}

// ---------------------------------------------------------------------------
// DocumentMetadata
// ---------------------------------------------------------------------------

/// Lightweight metadata record for a processed document
class DocumentMetadata {
  final String documentId;
  final String fileName;
  final String mimeType;
  final int fileSizeBytes;
  final int pageCount;
  final String title;
  final DocumentSourceType sourceType;
  final DateTime createdAt;
  final DocumentProcessingStatus processingStatus;
  final String? processingError;

  const DocumentMetadata({
    required this.documentId,
    required this.fileName,
    this.mimeType = 'application/pdf',
    this.fileSizeBytes = 0,
    this.pageCount = 0,
    String? title,
    this.sourceType = DocumentSourceType.localUserFile,
    required this.createdAt,
    this.processingStatus = DocumentProcessingStatus.idle,
    this.processingError,
  }) : title = title ?? fileName;

  bool get isReady => processingStatus == DocumentProcessingStatus.ready;
  bool get isFailed => processingStatus == DocumentProcessingStatus.failed;
  bool get isUnsupported =>
      processingStatus == DocumentProcessingStatus.unsupported;
  bool get isInProgress => processingStatus.isInProgress;

  DocumentMetadata copyWith({
    String? documentId,
    String? fileName,
    String? mimeType,
    int? fileSizeBytes,
    int? pageCount,
    String? title,
    DocumentSourceType? sourceType,
    DateTime? createdAt,
    DocumentProcessingStatus? processingStatus,
    String? processingError,
  }) {
    return DocumentMetadata(
      documentId: documentId ?? this.documentId,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      pageCount: pageCount ?? this.pageCount,
      title: title ?? this.title,
      sourceType: sourceType ?? this.sourceType,
      createdAt: createdAt ?? this.createdAt,
      processingStatus: processingStatus ?? this.processingStatus,
      processingError: processingError ?? this.processingError,
    );
  }

  Map<String, dynamic> toMap() => {
        'documentId': documentId,
        'fileName': fileName,
        'mimeType': mimeType,
        'fileSizeBytes': fileSizeBytes,
        'pageCount': pageCount,
        'title': title,
        'sourceType': sourceType.value,
        'createdAt': createdAt.toIso8601String(),
        'processingStatus': processingStatus.value,
        'processingError': processingError,
      };

  factory DocumentMetadata.fromMap(Map<String, dynamic> map) {
    return DocumentMetadata(
      documentId: map['documentId']?.toString() ?? '',
      fileName: map['fileName']?.toString() ?? '',
      mimeType: map['mimeType']?.toString() ?? 'application/pdf',
      fileSizeBytes: (map['fileSizeBytes'] as num?)?.toInt() ?? 0,
      pageCount: (map['pageCount'] as num?)?.toInt() ?? 0,
      title: map['title']?.toString(),
      sourceType: DocumentSourceType.fromString(map['sourceType']?.toString()),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      processingStatus: DocumentProcessingStatus.fromString(
          map['processingStatus']?.toString()),
      processingError: map['processingError']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentMetadata.fromJson(String source) =>
      DocumentMetadata.fromMap(json.decode(source) as Map<String, dynamic>);
}

// ---------------------------------------------------------------------------
// DocumentPage
// ---------------------------------------------------------------------------

/// Represents a single extracted page from a document
class DocumentPage {
  final int pageNumber;
  final String extractedText;
  final int characterCount;

  const DocumentPage({
    required this.pageNumber,
    required this.extractedText,
  }) : characterCount = extractedText.length;

  bool get isEmpty => extractedText.trim().isEmpty;
  bool get isNotEmpty => !isEmpty;

  DocumentPage copyWith({
    int? pageNumber,
    String? extractedText,
  }) {
    return DocumentPage(
      pageNumber: pageNumber ?? this.pageNumber,
      extractedText: extractedText ?? this.extractedText,
    );
  }

  Map<String, dynamic> toMap() => {
        'pageNumber': pageNumber,
        'extractedText': extractedText,
        'characterCount': characterCount,
      };

  factory DocumentPage.fromMap(Map<String, dynamic> map) {
    return DocumentPage(
      pageNumber: (map['pageNumber'] as num?)?.toInt() ?? 1,
      extractedText: map['extractedText']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentPage.fromJson(String source) =>
      DocumentPage.fromMap(json.decode(source) as Map<String, dynamic>);
}

// ---------------------------------------------------------------------------
// DocumentChunk
// ---------------------------------------------------------------------------

/// A bounded, page-aware text segment ready for retrieval
class DocumentChunk {
  final String chunkId;
  final String documentId;
  final int pageNumber;
  final String text;
  final int startOffset;
  final int endOffset;
  final int tokenEstimate;
  final Map<String, dynamic> metadata;

  const DocumentChunk({
    required this.chunkId,
    required this.documentId,
    required this.pageNumber,
    required this.text,
    this.startOffset = 0,
    this.endOffset = 0,
    this.tokenEstimate = 0,
    this.metadata = const {},
  });

  bool get isEmpty => text.trim().isEmpty;

  DocumentChunk copyWith({
    String? chunkId,
    String? documentId,
    int? pageNumber,
    String? text,
    int? startOffset,
    int? endOffset,
    int? tokenEstimate,
    Map<String, dynamic>? metadata,
  }) {
    return DocumentChunk(
      chunkId: chunkId ?? this.chunkId,
      documentId: documentId ?? this.documentId,
      pageNumber: pageNumber ?? this.pageNumber,
      text: text ?? this.text,
      startOffset: startOffset ?? this.startOffset,
      endOffset: endOffset ?? this.endOffset,
      tokenEstimate: tokenEstimate ?? this.tokenEstimate,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() => {
        'chunkId': chunkId,
        'documentId': documentId,
        'pageNumber': pageNumber,
        'text': text,
        'startOffset': startOffset,
        'endOffset': endOffset,
        'tokenEstimate': tokenEstimate,
        'metadata': metadata,
      };

  factory DocumentChunk.fromMap(Map<String, dynamic> map) {
    return DocumentChunk(
      chunkId: map['chunkId']?.toString() ?? '',
      documentId: map['documentId']?.toString() ?? '',
      pageNumber: (map['pageNumber'] as num?)?.toInt() ?? 1,
      text: map['text']?.toString() ?? '',
      startOffset: (map['startOffset'] as num?)?.toInt() ?? 0,
      endOffset: (map['endOffset'] as num?)?.toInt() ?? 0,
      tokenEstimate: (map['tokenEstimate'] as num?)?.toInt() ?? 0,
      metadata: (map['metadata'] as Map<String, dynamic>?) ?? const {},
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentChunk.fromJson(String source) =>
      DocumentChunk.fromMap(json.decode(source) as Map<String, dynamic>);
}

// ---------------------------------------------------------------------------
// DocumentIndex
// ---------------------------------------------------------------------------

/// Complete in-memory representation of a fully-processed document
class DocumentIndex {
  final DocumentMetadata metadata;
  final List<DocumentPage> pages;
  final List<DocumentChunk> chunks;

  const DocumentIndex({
    required this.metadata,
    this.pages = const [],
    this.chunks = const [],
  });

  String get documentId => metadata.documentId;
  bool get isReady => metadata.isReady;
  int get chunkCount => chunks.length;
  int get pageCount => metadata.pageCount;

  DocumentIndex copyWith({
    DocumentMetadata? metadata,
    List<DocumentPage>? pages,
    List<DocumentChunk>? chunks,
  }) {
    return DocumentIndex(
      metadata: metadata ?? this.metadata,
      pages: pages ?? this.pages,
      chunks: chunks ?? this.chunks,
    );
  }

  Map<String, dynamic> toMap() => {
        'metadata': metadata.toMap(),
        'pages': pages.map((p) => p.toMap()).toList(),
        'chunks': chunks.map((c) => c.toMap()).toList(),
      };

  factory DocumentIndex.fromMap(Map<String, dynamic> map) {
    return DocumentIndex(
      metadata: DocumentMetadata.fromMap(
          (map['metadata'] as Map<String, dynamic>?) ?? {}),
      pages: (map['pages'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((p) => DocumentPage.fromMap(p))
              .toList() ??
          const [],
      chunks: (map['chunks'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((c) => DocumentChunk.fromMap(c))
              .toList() ??
          const [],
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentIndex.fromJson(String source) =>
      DocumentIndex.fromMap(json.decode(source) as Map<String, dynamic>);
}

// ---------------------------------------------------------------------------
// DocumentSearchResult
// ---------------------------------------------------------------------------

/// A retrieval result linking a ranked chunk to its relevance metadata
class DocumentSearchResult {
  final DocumentChunk chunk;
  final double relevanceScore;
  final List<String> matchedTerms;
  final int pageNumber;

  const DocumentSearchResult({
    required this.chunk,
    required this.relevanceScore,
    this.matchedTerms = const [],
    required this.pageNumber,
  });

  String get documentId => chunk.documentId;
  String get text => chunk.text;
  String get chunkId => chunk.chunkId;

  DocumentSearchResult copyWith({
    DocumentChunk? chunk,
    double? relevanceScore,
    List<String>? matchedTerms,
    int? pageNumber,
  }) {
    return DocumentSearchResult(
      chunk: chunk ?? this.chunk,
      relevanceScore: relevanceScore ?? this.relevanceScore,
      matchedTerms: matchedTerms ?? this.matchedTerms,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }

  Map<String, dynamic> toMap() => {
        'chunk': chunk.toMap(),
        'relevanceScore': relevanceScore,
        'matchedTerms': matchedTerms,
        'pageNumber': pageNumber,
      };

  factory DocumentSearchResult.fromMap(Map<String, dynamic> map) {
    return DocumentSearchResult(
      chunk:
          DocumentChunk.fromMap((map['chunk'] as Map<String, dynamic>?) ?? {}),
      relevanceScore: (map['relevanceScore'] as num?)?.toDouble() ?? 0.0,
      matchedTerms: (map['matchedTerms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      pageNumber: (map['pageNumber'] as num?)?.toInt() ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentSearchResult.fromJson(String source) =>
      DocumentSearchResult.fromMap(json.decode(source) as Map<String, dynamic>);
}

import 'dart:convert';

/// Source origin of the attached document or file reference
enum AiAttachmentSourceType {
  localFile('local_file'),
  unidocsResource('unidocs_resource'),
  webLink('web_link'),
  capturedText('captured_text');

  final String value;
  const AiAttachmentSourceType(this.value);

  static AiAttachmentSourceType fromString(String? type) {
    if (type == null) return AiAttachmentSourceType.localFile;
    return AiAttachmentSourceType.values.firstWhere(
      (t) => t.value.toLowerCase() == type.toLowerCase().trim(),
      orElse: () => AiAttachmentSourceType.localFile,
    );
  }
}

/// Processing status of the attachment for future document comprehension
enum AiAttachmentStatus {
  pending('pending'),
  processed('processed'),
  failed('failed'),
  unsupported('unsupported');

  final String value;
  const AiAttachmentStatus(this.value);

  static AiAttachmentStatus fromString(String? status) {
    if (status == null) return AiAttachmentStatus.pending;
    return AiAttachmentStatus.values.firstWhere(
      (s) => s.value.toLowerCase() == status.toLowerCase().trim(),
      orElse: () => AiAttachmentStatus.pending,
    );
  }
}

/// Metadata representation of a file or reference attachment in UniDocs AI
class AiAttachment {
  final String id;
  final String filename;
  final String mimeType;
  final int sizeBytes;
  final AiAttachmentSourceType sourceType;
  final String? localIdentifier;
  final AiAttachmentStatus status;
  final String? extractedTextSnippet;
  final Map<String, dynamic> metadata;

  const AiAttachment({
    required this.id,
    required this.filename,
    required this.mimeType,
    this.sizeBytes = 0,
    this.sourceType = AiAttachmentSourceType.localFile,
    this.localIdentifier,
    this.status = AiAttachmentStatus.pending,
    this.extractedTextSnippet,
    this.metadata = const {},
  });

  bool get isProcessed => status == AiAttachmentStatus.processed;
  String get fileName => filename;
  int get fileSizeBytes => sizeBytes;
  String? get localPath => localIdentifier;
  String? get extractedTextPreview => extractedTextSnippet;
  bool get isPdf =>
      mimeType.toLowerCase().contains('pdf') ||
      filename.toLowerCase().endsWith('.pdf');

  AiAttachment copyWith({
    String? id,
    String? filename,
    String? mimeType,
    int? sizeBytes,
    AiAttachmentSourceType? sourceType,
    String? localIdentifier,
    AiAttachmentStatus? status,
    String? extractedTextSnippet,
    Map<String, dynamic>? metadata,
  }) {
    return AiAttachment(
      id: id ?? this.id,
      filename: filename ?? this.filename,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      sourceType: sourceType ?? this.sourceType,
      localIdentifier: localIdentifier ?? this.localIdentifier,
      status: status ?? this.status,
      extractedTextSnippet: extractedTextSnippet ?? this.extractedTextSnippet,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filename': filename,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      'sourceType': sourceType.value,
      'localIdentifier': localIdentifier,
      'status': status.value,
      'extractedTextSnippet': extractedTextSnippet,
      'metadata': metadata,
    };
  }

  factory AiAttachment.fromMap(Map<String, dynamic> map) {
    return AiAttachment(
      id: map['id']?.toString() ?? '',
      filename: map['filename']?.toString() ?? '',
      mimeType: map['mimeType']?.toString() ?? 'application/octet-stream',
      sizeBytes: (map['sizeBytes'] as num?)?.toInt() ?? 0,
      sourceType:
          AiAttachmentSourceType.fromString(map['sourceType']?.toString()),
      localIdentifier: map['localIdentifier']?.toString(),
      status: AiAttachmentStatus.fromString(map['status']?.toString()),
      extractedTextSnippet: map['extractedTextSnippet']?.toString(),
      metadata: (map['metadata'] as Map<String, dynamic>?) ?? const {},
    );
  }

  String toJson() => json.encode(toMap());

  factory AiAttachment.fromJson(String source) =>
      AiAttachment.fromMap(json.decode(source) as Map<String, dynamic>);
}

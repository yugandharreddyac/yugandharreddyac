import 'dart:convert';
import 'ai_attachment.dart';
import 'ai_response.dart';

/// Role of the message participant in an AI interaction
enum AiMessageRole {
  user('user'),
  assistant('assistant'),
  system('system'),
  tool('tool');

  final String value;
  const AiMessageRole(this.value);

  static AiMessageRole fromString(String? role) {
    if (role == null) return AiMessageRole.user;
    return AiMessageRole.values.firstWhere(
      (r) => r.value.toLowerCase() == role.toLowerCase().trim(),
      orElse: () => AiMessageRole.user,
    );
  }
}

/// A structured message within a UniDocs AI conversation
class AiMessage {
  final String id;
  final String conversationId;
  final AiMessageRole role;
  final String content;
  final DateTime timestamp;
  final List<AiAttachment> attachments;
  final List<AiResourceReference> resourceReferences;
  final List<String> suggestedFollowUps;
  final bool isError;
  final Map<String, dynamic> metadata;

  const AiMessage({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    required this.timestamp,
    this.attachments = const [],
    this.resourceReferences = const [],
    this.suggestedFollowUps = const [],
    this.isError = false,
    this.metadata = const {},
  });

  bool get isUser => role == AiMessageRole.user;
  bool get isAssistant => role == AiMessageRole.assistant;
  bool get isSystem => role == AiMessageRole.system;
  bool get isTool => role == AiMessageRole.tool;

  AiMessage copyWith({
    String? id,
    String? conversationId,
    AiMessageRole? role,
    String? content,
    DateTime? timestamp,
    List<AiAttachment>? attachments,
    List<AiResourceReference>? resourceReferences,
    List<String>? suggestedFollowUps,
    bool? isError,
    Map<String, dynamic>? metadata,
  }) {
    return AiMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      attachments: attachments ?? this.attachments,
      resourceReferences: resourceReferences ?? this.resourceReferences,
      suggestedFollowUps: suggestedFollowUps ?? this.suggestedFollowUps,
      isError: isError ?? this.isError,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversationId': conversationId,
      'role': role.value,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'attachments': attachments.map((a) => a.toMap()).toList(),
      'resourceReferences': resourceReferences.map((r) => r.toMap()).toList(),
      'suggestedFollowUps': suggestedFollowUps,
      'isError': isError,
      'metadata': metadata,
    };
  }

  factory AiMessage.fromMap(Map<String, dynamic> map) {
    return AiMessage(
      id: map['id']?.toString() ?? '',
      conversationId: map['conversationId']?.toString() ?? '',
      role: AiMessageRole.fromString(map['role']?.toString()),
      content: map['content']?.toString() ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      attachments: (map['attachments'] as List<dynamic>?)
              ?.map((a) => a is Map
                  ? AiAttachment.fromMap(Map<String, dynamic>.from(a))
                  : null)
              .whereType<AiAttachment>()
              .toList() ??
          const [],
      resourceReferences: (map['resourceReferences'] as List<dynamic>?)
              ?.map((r) => r is Map
                  ? AiResourceReference.fromMap(Map<String, dynamic>.from(r))
                  : null)
              .whereType<AiResourceReference>()
              .toList() ??
          const [],
      suggestedFollowUps: (map['suggestedFollowUps'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      isError: map['isError'] == true,
      metadata: map['metadata'] is Map
          ? Map<String, dynamic>.from(map['metadata'] as Map)
          : const {},
    );
  }

  String toJson() => json.encode(toMap());

  factory AiMessage.fromJson(String source) =>
      AiMessage.fromMap(json.decode(source) as Map<String, dynamic>);
}

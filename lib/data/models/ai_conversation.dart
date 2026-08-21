import 'dart:convert';
import 'ai_message.dart';

/// Represents a persistent AI conversation session in UniDocs
class AiConversation {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<AiMessage> messages;
  final Map<String, dynamic> modelMetadata;
  final bool isArchived;
  final Map<String, dynamic> pinnedContext;
  final int totalTokensUsed;

  const AiConversation({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.messages = const [],
    this.modelMetadata = const {},
    this.isArchived = false,
    this.pinnedContext = const {},
    this.totalTokensUsed = 0,
  });

  AiMessage? get latestMessage => messages.isNotEmpty ? messages.last : null;
  int get messageCount => messages.length;
  bool get isEmpty => messages.isEmpty;

  AiConversation copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<AiMessage>? messages,
    Map<String, dynamic>? modelMetadata,
    bool? isArchived,
    Map<String, dynamic>? pinnedContext,
    int? totalTokensUsed,
  }) {
    return AiConversation(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
      modelMetadata: modelMetadata ?? this.modelMetadata,
      isArchived: isArchived ?? this.isArchived,
      pinnedContext: pinnedContext ?? this.pinnedContext,
      totalTokensUsed: totalTokensUsed ?? this.totalTokensUsed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'messages': messages.map((m) => m.toMap()).toList(),
      'modelMetadata': modelMetadata,
      'isArchived': isArchived,
      'pinnedContext': pinnedContext,
      'totalTokensUsed': totalTokensUsed,
    };
  }

  factory AiConversation.fromMap(Map<String, dynamic> map) {
    return AiConversation(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? 'New Conversation',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      messages: (map['messages'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((m) => AiMessage.fromMap(m))
              .toList() ??
          const [],
      modelMetadata:
          (map['modelMetadata'] as Map<String, dynamic>?) ?? const {},
      isArchived: map['isArchived'] == true,
      pinnedContext:
          (map['pinnedContext'] as Map<String, dynamic>?) ?? const {},
      totalTokensUsed: (map['totalTokensUsed'] as num?)?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AiConversation.fromJson(String source) =>
      AiConversation.fromMap(json.decode(source) as Map<String, dynamic>);
}

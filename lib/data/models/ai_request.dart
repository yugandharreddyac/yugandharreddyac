import 'dart:convert';
import 'ai_context.dart';
import 'ai_message.dart';

/// Available functional capabilities in UniDocs AI
enum AiCapability {
  chat('chat', 'General Educational Assistant'),
  explain('explain', 'Concept Explainer'),
  summarize('summarize', 'Document & Topic Summarizer'),
  quiz('quiz', 'MCQ & Quiz Generator'),
  codeReview('code_review', 'Code Review & Debugger'),
  roadmapAdvice('roadmap_advice', 'Roadmap & Progress Coach'),
  interviewPractice('interview_practice', 'Mock Interview Coach'),
  documentQA('document_qa', 'Document Q&A Assistant'),
  studyPlan('study_plan', 'Study Schedule Planner'),
  projectGuidance('project_guidance', 'Project & Architecture Guide');

  final String value;
  final String displayName;
  const AiCapability(this.value, this.displayName);

  static AiCapability fromString(String? capability) {
    if (capability == null) return AiCapability.chat;
    return AiCapability.values.firstWhere(
      (c) => c.value.toLowerCase() == capability.toLowerCase().trim(),
      orElse: () => AiCapability.chat,
    );
  }
}

/// Generation hyperparameters for AI model requests
class AiGenerationConfig {
  final double temperature;
  final int maxTokens;
  final double topP;
  final List<String> stopSequences;
  final String responseFormat;

  const AiGenerationConfig({
    this.temperature = 0.7,
    this.maxTokens = 2048,
    this.topP = 0.95,
    this.stopSequences = const [],
    this.responseFormat = 'text',
  });

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'maxTokens': maxTokens,
      'topP': topP,
      'stopSequences': stopSequences,
      'responseFormat': responseFormat,
    };
  }

  factory AiGenerationConfig.fromMap(Map<String, dynamic> map) {
    return AiGenerationConfig(
      temperature: (map['temperature'] as num?)?.toDouble() ?? 0.7,
      maxTokens: (map['maxTokens'] as num?)?.toInt() ?? 2048,
      topP: (map['topP'] as num?)?.toDouble() ?? 0.95,
      stopSequences: (map['stopSequences'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      responseFormat: map['responseFormat']?.toString() ?? 'text',
    );
  }
}

/// A structured provider-independent request to the UniDocs AI subsystem
class AiRequest {
  final String conversationId;
  final List<AiMessage> messages;
  final AiContext context;
  final AiCapability capability;
  final AiGenerationConfig generationConfig;
  final Map<String, dynamic> metadata;

  const AiRequest({
    required this.conversationId,
    required this.messages,
    this.context = const AiContext(),
    this.capability = AiCapability.chat,
    this.generationConfig = const AiGenerationConfig(),
    this.metadata = const {},
  });

  AiMessage? get latestUserMessage {
    for (var i = messages.length - 1; i >= 0; i--) {
      if (messages[i].isUser) return messages[i];
    }
    return null;
  }

  AiRequest copyWith({
    String? conversationId,
    List<AiMessage>? messages,
    AiContext? context,
    AiCapability? capability,
    AiGenerationConfig? generationConfig,
    Map<String, dynamic>? metadata,
  }) {
    return AiRequest(
      conversationId: conversationId ?? this.conversationId,
      messages: messages ?? this.messages,
      context: context ?? this.context,
      capability: capability ?? this.capability,
      generationConfig: generationConfig ?? this.generationConfig,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'conversationId': conversationId,
      'messages': messages.map((m) => m.toMap()).toList(),
      'context': context.toMap(),
      'capability': capability.value,
      'generationConfig': generationConfig.toMap(),
      'metadata': metadata,
    };
  }

  factory AiRequest.fromMap(Map<String, dynamic> map) {
    return AiRequest(
      conversationId: map['conversationId']?.toString() ?? '',
      messages: (map['messages'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((m) => AiMessage.fromMap(m))
              .toList() ??
          const [],
      context: map['context'] != null
          ? AiContext.fromMap(map['context'] as Map<String, dynamic>)
          : const AiContext(),
      capability: AiCapability.fromString(map['capability']?.toString()),
      generationConfig: map['generationConfig'] != null
          ? AiGenerationConfig.fromMap(map['generationConfig'] as Map<String, dynamic>)
          : const AiGenerationConfig(),
      metadata: (map['metadata'] as Map<String, dynamic>?) ?? const {},
    );
  }

  String toJson() => json.encode(toMap());

  factory AiRequest.fromJson(String source) =>
      AiRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}

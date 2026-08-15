import 'dart:convert';
import 'ai_message.dart';

/// Standard error codes for UniDocs AI service and provider operations
enum AiErrorCode {
  noProviderConfigured('no_provider_configured'),
  networkUnavailable('network_unavailable'),
  timeout('timeout'),
  rateLimitExceeded('rate_limit_exceeded'),
  authenticationFailed('authentication_failed'),
  invalidResponse('invalid_response'),
  contextUnavailable('context_unavailable'),
  attachmentUnavailable('attachment_unavailable'),
  providerUnavailable('provider_unavailable'),
  unknown('unknown');

  final String value;
  const AiErrorCode(this.value);

  static AiErrorCode fromString(String? code) {
    if (code == null) return AiErrorCode.unknown;
    return AiErrorCode.values.firstWhere(
      (c) => c.value.toLowerCase() == code.toLowerCase().trim(),
      orElse: () => AiErrorCode.unknown,
    );
  }
}

/// Structured AI error model ensuring the application never crashes
class AiError {
  final AiErrorCode code;
  final String message;
  final String? details;
  final bool isRetryable;

  const AiError({
    required this.code,
    required this.message,
    this.details,
    this.isRetryable = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code.value,
      'message': message,
      'details': details,
      'isRetryable': isRetryable,
    };
  }

  factory AiError.fromMap(Map<String, dynamic> map) {
    final code = AiErrorCode.fromString(map['code']?.toString());
    final isExplicitRetryable = map['isRetryable'];
    final bool retryable;
    if (isExplicitRetryable is bool) {
      retryable = isExplicitRetryable;
    } else {
      retryable = code == AiErrorCode.rateLimitExceeded ||
          code == AiErrorCode.timeout ||
          code == AiErrorCode.networkUnavailable ||
          code == AiErrorCode.providerUnavailable;
    }

    return AiError(
      code: code,
      message: map['message']?.toString() ?? 'An error occurred during AI processing.',
      details: map['details']?.toString(),
      isRetryable: retryable,
    );
  }
}

/// Token and latency metrics for AI interactions
class AiUsageMetadata {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;
  final int latencyMs;

  const AiUsageMetadata({
    this.promptTokens = 0,
    this.completionTokens = 0,
    this.totalTokens = 0,
    this.latencyMs = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'promptTokens': promptTokens,
      'completionTokens': completionTokens,
      'totalTokens': totalTokens,
      'latencyMs': latencyMs,
    };
  }

  factory AiUsageMetadata.fromMap(Map<String, dynamic> map) {
    return AiUsageMetadata(
      promptTokens: (map['promptTokens'] as num?)?.toInt() ?? 0,
      completionTokens: (map['completionTokens'] as num?)?.toInt() ?? 0,
      totalTokens: (map['totalTokens'] as num?)?.toInt() ?? 0,
      latencyMs: (map['latencyMs'] as num?)?.toInt() ?? 0,
    );
  }
}

/// A verified resource reference in UniDocs (avoids hallucinating IDs)
class AiResourceReference {
  final String id;
  final String title;
  final String hubName;
  final String? route;
  final String resourceType;
  final String? categoryName;
  final Map<String, dynamic>? routeArguments;

  const AiResourceReference({
    required this.id,
    required this.title,
    required this.hubName,
    this.route,
    this.resourceType = 'topic',
    this.categoryName,
    this.routeArguments,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'hubName': hubName,
      'route': route,
      'resourceType': resourceType,
      'categoryName': categoryName,
      'routeArguments': routeArguments,
    };
  }

  factory AiResourceReference.fromMap(Map<String, dynamic> map) {
    return AiResourceReference(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      hubName: map['hubName']?.toString() ?? '',
      route: map['route']?.toString(),
      resourceType: map['resourceType']?.toString() ?? 'topic',
      categoryName: map['categoryName']?.toString(),
      routeArguments: map['routeArguments'] as Map<String, dynamic>?,
    );
  }
}

/// A citation reference pointing to a source, with optional document page grounding
class AiCitation {
  final String sourceTitle;
  final String? sourceReference;
  final String snippet;
  final String sourceType;

  /// Page number for document-grounded citations (null for hub/knowledge citations)
  final int? pageNumber;

  /// Document ID for local document citations (null for UniDocs hub resources)
  final String? documentId;

  const AiCitation({
    required this.sourceTitle,
    this.sourceReference,
    required this.snippet,
    this.sourceType = 'unidocs_knowledge',
    this.pageNumber,
    this.documentId,
  });

  /// Convenience constructor for document-grounded citations
  factory AiCitation.fromDocument({
    required String documentTitle,
    required String documentId,
    required int pageNumber,
    required String snippet,
    String sourceType = 'user_document',
  }) {
    return AiCitation(
      sourceTitle: documentTitle,
      sourceReference: 'Page $pageNumber',
      snippet: snippet,
      sourceType: sourceType,
      pageNumber: pageNumber,
      documentId: documentId,
    );
  }

  bool get isDocumentCitation => documentId != null;
  bool get hasPageNumber => pageNumber != null;

  Map<String, dynamic> toMap() {
    return {
      'sourceTitle': sourceTitle,
      'sourceReference': sourceReference,
      'snippet': snippet,
      'sourceType': sourceType,
      'pageNumber': pageNumber,
      'documentId': documentId,
    };
  }

  factory AiCitation.fromMap(Map<String, dynamic> map) {
    return AiCitation(
      sourceTitle: map['sourceTitle']?.toString() ?? '',
      sourceReference: map['sourceReference']?.toString(),
      snippet: map['snippet']?.toString() ?? '',
      sourceType: map['sourceType']?.toString() ?? 'unidocs_knowledge',
      pageNumber: (map['pageNumber'] as num?)?.toInt(),
      documentId: map['documentId']?.toString(),
    );
  }
}

/// Structured response from the UniDocs AI service
class AiResponse {
  final String id;
  final AiMessage? message;
  final AiUsageMetadata usage;
  final List<AiCitation> citations;
  final List<AiResourceReference> resourceReferences;
  final List<String> suggestedFollowUps;
  final AiError? error;

  const AiResponse({
    required this.id,
    this.message,
    this.usage = const AiUsageMetadata(),
    this.citations = const [],
    this.resourceReferences = const [],
    this.suggestedFollowUps = const [],
    this.error,
  });

  bool get isSuccessful => error == null && message != null;
  bool get isFailure => error != null;

  factory AiResponse.success({
    required String id,
    required AiMessage message,
    AiUsageMetadata usage = const AiUsageMetadata(),
    List<AiCitation> citations = const [],
    List<AiResourceReference> resourceReferences = const [],
    List<String> suggestedFollowUps = const [],
  }) {
    return AiResponse(
      id: id,
      message: message,
      usage: usage,
      citations: citations,
      resourceReferences: resourceReferences,
      suggestedFollowUps: suggestedFollowUps,
    );
  }

  factory AiResponse.failure({
    required String id,
    required AiError error,
  }) {
    return AiResponse(
      id: id,
      error: error,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message?.toMap(),
      'usage': usage.toMap(),
      'citations': citations.map((c) => c.toMap()).toList(),
      'resourceReferences': resourceReferences.map((r) => r.toMap()).toList(),
      'suggestedFollowUps': suggestedFollowUps,
      'error': error?.toMap(),
    };
  }

  factory AiResponse.fromMap(Map<String, dynamic> map) {
    return AiResponse(
      id: map['id']?.toString() ?? '',
      message: map['message'] != null
          ? AiMessage.fromMap(map['message'] as Map<String, dynamic>)
          : null,
      usage: map['usage'] != null
          ? AiUsageMetadata.fromMap(map['usage'] as Map<String, dynamic>)
          : const AiUsageMetadata(),
      citations: (map['citations'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((c) => AiCitation.fromMap(c))
              .toList() ??
          const [],
      resourceReferences: (map['resourceReferences'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((r) => AiResourceReference.fromMap(r))
              .toList() ??
          const [],
      suggestedFollowUps: (map['suggestedFollowUps'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      error: map['error'] != null
          ? AiError.fromMap(map['error'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AiResponse.fromJson(String source) =>
      AiResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

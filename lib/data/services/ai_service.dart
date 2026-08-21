import 'dart:async';
import '../datasources/ai_context_builder.dart';
import '../datasources/ai_provider_interface.dart';
import '../models/ai_attachment.dart';
import '../models/ai_context.dart';
import '../models/ai_message.dart';
import '../models/ai_request.dart';
import '../models/ai_response.dart';
import '../models/personalized_roadmap_models.dart';
import '../repositories/ai_conversation_repository.dart';
import '../repositories/document_repository.dart';

/// Central production AI service sitting between application features and AI providers
class AiService {
  AiProvider _provider;
  final AiConversationRepository _repository;
  AiContextComposer _contextComposer;
  final Duration timeout;

  AiService({
    AiProvider? provider,
    AiConversationRepository? repository,
    AiContextComposer? contextComposer,
    this.timeout = const Duration(seconds: 30),
  })  : _provider = provider ?? const NoOpAiProvider(),
        _repository = repository ?? LocalAiConversationRepository(),
        _contextComposer = contextComposer ?? const AiContextComposer();

  AiProvider get provider => _provider;
  void setProvider(AiProvider newProvider) {
    _provider = newProvider;
  }

  String get activeProviderId => _provider.providerId;
  String get activeProviderName => _provider.displayName;
  Set<AiCapability> get supportedCapabilities =>
      _provider.supportedCapabilities;
  AiContextComposer get contextComposer => _contextComposer;

  void setDocumentRepository(DocumentRepository documentRepository) {
    _contextComposer = AiContextComposer(
      studentProvider: _contextComposer.studentProvider,
      roadmapProvider: _contextComposer.roadmapProvider,
      resourceProvider: _contextComposer.resourceProvider,
      documentProvider:
          RagDocumentContextProvider(documentRepository: documentRepository),
    );
  }

  Future<bool> checkProviderHealth() async {
    try {
      return await _provider.checkHealth().timeout(const Duration(seconds: 5));
    } catch (_) {
      return false;
    }
  }

  /// Sends a user query and returns a normalized, grounded AI response
  Future<AiResponse> sendMessage({
    required String conversationId,
    required String userPrompt,
    PersonalizedProfile? profile,
    PersonalizedRoadmap? roadmap,
    LearningContext? learningContext,
    List<String>? topicIds,
    List<AiAttachment>? attachments,
    AiCapability capability = AiCapability.chat,
    AiGenerationConfig? generationConfig,
    String? customInstructions,
  }) async {
    final userTimestamp = DateTime.now();
    final userMessage = AiMessage(
      id: 'msg_${userTimestamp.millisecondsSinceEpoch}',
      conversationId: conversationId,
      role: AiMessageRole.user,
      content: userPrompt,
      timestamp: userTimestamp,
      attachments: attachments ?? const [],
    );

    // 1. Persist user message
    try {
      await _repository.saveMessage(conversationId, userMessage);
    } catch (_) {
      // Non-fatal if repository fails
    }

    // 2. Load conversation history
    final conversation = await _repository.loadConversation(conversationId);
    final historyMessages = conversation?.messages ?? [userMessage];

    // 3. Resolve RAG document context if RagDocumentContextProvider is configured
    String? documentContextText;
    if (attachments != null && attachments.isNotEmpty) {
      final docProv = _contextComposer.documentProvider;
      if (docProv is RagDocumentContextProvider) {
        documentContextText = await docProv.buildGroundedContext(
          userQuery: userPrompt,
          attachments: attachments,
        );
      }
    }

    // 4. Compose structured context
    final context = _contextComposer.compose(
      profile: profile,
      roadmap: roadmap,
      learningContext: learningContext,
      userQuery: userPrompt,
      topicIds: topicIds,
      attachments: attachments,
      customSystemInstructions: customInstructions,
      documentContextText: documentContextText,
    );

    // 4. Create request
    final request = AiRequest(
      conversationId: conversationId,
      messages: historyMessages,
      context: context,
      capability: capability,
      generationConfig: generationConfig ?? const AiGenerationConfig(),
    );

    // 5. Execute with provider
    try {
      final response =
          await _provider.generateResponse(request).timeout(timeout);

      if (response.isSuccessful && response.message != null) {
        // Save assistant response message
        await _repository.saveMessage(conversationId, response.message!);
      }

      return response;
    } on TimeoutException {
      final errorResp = AiResponse.failure(
        id: 'resp_timeout_${DateTime.now().millisecondsSinceEpoch}',
        error: const AiError(
          code: AiErrorCode.timeout,
          message: 'The AI request timed out. Please try again.',
          isRetryable: true,
        ),
      );
      return errorResp;
    } catch (e) {
      final errorResp = AiResponse.failure(
        id: 'resp_err_${DateTime.now().millisecondsSinceEpoch}',
        error: AiError(
          code: AiErrorCode.unknown,
          message:
              'An unexpected error occurred while communicating with the AI service.',
          details: e.toString(),
          isRetryable: true,
        ),
      );
      return errorResp;
    }
  }

  /// Streams response text from the active provider (extensible for streaming in Phase 2)
  Stream<String> streamMessage({
    required String conversationId,
    required String userPrompt,
    PersonalizedProfile? profile,
    PersonalizedRoadmap? roadmap,
    LearningContext? learningContext,
    List<AiAttachment>? attachments,
    AiCapability capability = AiCapability.chat,
    AiGenerationConfig? generationConfig,
  }) async* {
    String? documentContextText;
    if (attachments != null && attachments.isNotEmpty) {
      final docProv = _contextComposer.documentProvider;
      if (docProv is RagDocumentContextProvider) {
        documentContextText = await docProv.buildGroundedContext(
          userQuery: userPrompt,
          attachments: attachments,
        );
      }
    }

    final context = _contextComposer.compose(
      profile: profile,
      roadmap: roadmap,
      learningContext: learningContext,
      userQuery: userPrompt,
      attachments: attachments,
      documentContextText: documentContextText,
    );

    final request = AiRequest(
      conversationId: conversationId,
      messages: [
        AiMessage(
          id: 'stream_user_${DateTime.now().millisecondsSinceEpoch}',
          conversationId: conversationId,
          role: AiMessageRole.user,
          content: userPrompt,
          timestamp: DateTime.now(),
        ),
      ],
      context: context,
      capability: capability,
      generationConfig: generationConfig ?? const AiGenerationConfig(),
    );

    yield* _provider.streamResponse(request);
  }
}

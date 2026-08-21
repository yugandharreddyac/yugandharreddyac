import 'package:flutter/foundation.dart';
import '../../data/datasources/ai_provider_interface.dart';
import '../../data/models/ai_attachment.dart';
import '../../data/models/ai_context.dart';
import '../../data/models/ai_conversation.dart';
import '../../data/models/ai_message.dart';
import '../../data/models/ai_request.dart';
import '../../data/models/ai_response.dart';
import '../../data/models/personalized_roadmap_models.dart';
import '../../data/repositories/ai_conversation_repository.dart';
import '../../data/repositories/document_repository.dart';
import '../../data/services/ai_service.dart';

/// State management provider for UniDocs AI features
class UniDocsAiProvider extends ChangeNotifier {
  final AiService _aiService;
  final AiConversationRepository _repository;

  AiConversation? _currentConversation;
  List<AiConversation> _conversations = [];
  bool _isLoading = false;
  AiError? _lastError;
  AiCapability _selectedCapability = AiCapability.chat;
  final List<AiAttachment> _pendingAttachments = [];

  UniDocsAiProvider({
    AiService? aiService,
    AiConversationRepository? repository,
  })  : _aiService = aiService ?? AiService(),
        _repository = repository ?? LocalAiConversationRepository() {
    _init();
  }

  // Getters
  AiConversation? get currentConversation => _currentConversation;
  List<AiMessage> get messages => _currentConversation?.messages ?? [];
  List<AiConversation> get conversations => List.unmodifiable(_conversations);
  bool get isLoading => _isLoading;
  AiError? get lastError => _lastError;
  AiCapability get selectedCapability => _selectedCapability;
  List<AiAttachment> get pendingAttachments =>
      List.unmodifiable(_pendingAttachments);
  String get activeProviderName => _aiService.activeProviderName;
  AiProvider get activeProvider => _aiService.provider;

  void configureProvider(AiProvider provider) {
    _aiService.setProvider(provider);
    notifyListeners();
  }

  void configureDocumentRepository(DocumentRepository docRepo) {
    _aiService.setDocumentRepository(docRepo);
    notifyListeners();
  }

  Future<bool> checkProviderHealth() async {
    return await _aiService.checkProviderHealth();
  }

  Future<void> _init() async {
    await loadConversations();
  }

  Future<void> loadConversations() async {
    try {
      _conversations = await _repository.listConversations();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> selectConversation(String conversationId) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      _currentConversation = await _repository.loadConversation(conversationId);
    } catch (_) {
      _lastError = const AiError(
        code: AiErrorCode.unknown,
        message: 'Failed to load selected conversation.',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createNewConversation({String? initialTitle}) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final newConv =
          await _repository.createConversation(initialTitle: initialTitle);
      _currentConversation = newConv;
      await loadConversations();
    } catch (_) {
      _lastError = const AiError(
        code: AiErrorCode.unknown,
        message: 'Failed to create new conversation.',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startNewConversation({String? initialTitle}) async {
    await createNewConversation(initialTitle: initialTitle);
  }

  void setCapability(AiCapability capability) {
    if (_selectedCapability != capability) {
      _selectedCapability = capability;
      notifyListeners();
    }
  }

  void addAttachment(AiAttachment attachment) {
    _pendingAttachments.add(attachment);
    notifyListeners();
  }

  void removeAttachment(String attachmentId) {
    _pendingAttachments.removeWhere((a) => a.id == attachmentId);
    notifyListeners();
  }

  void clearPendingAttachments() {
    _pendingAttachments.clear();
    notifyListeners();
  }

  /// Sends a user message to the AI subsystem
  Future<AiResponse> sendMessage(
    String prompt, {
    PersonalizedProfile? profile,
    PersonalizedRoadmap? roadmap,
    LearningContext? learningContext,
    List<String>? topicIds,
    List<AiAttachment>? attachments,
  }) async {
    if (prompt.trim().isEmpty) {
      return AiResponse.failure(
        id: 'empty_prompt',
        error: const AiError(
          code: AiErrorCode.unknown,
          message: 'Prompt cannot be empty.',
        ),
      );
    }

    if (_currentConversation == null) {
      final newConv = await _repository.createConversation(
        initialTitle:
            prompt.length > 25 ? '${prompt.substring(0, 25)}...' : prompt,
      );
      _currentConversation = newConv;
    }

    final convId = _currentConversation!.id;
    final attachmentsToSend = [
      ..._pendingAttachments,
      if (attachments != null) ...attachments,
    ];
    _pendingAttachments.clear();

    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final response = await _aiService.sendMessage(
        conversationId: convId,
        userPrompt: prompt,
        profile: profile,
        roadmap: roadmap,
        learningContext: learningContext,
        topicIds: topicIds,
        attachments: attachmentsToSend,
        capability: _selectedCapability,
      );

      // Refresh current conversation from repository
      _currentConversation = await _repository.loadConversation(convId);
      if (response.isFailure) {
        _lastError = response.error;
      }

      await loadConversations();
      return response;
    } catch (e) {
      _lastError = AiError(
        code: AiErrorCode.unknown,
        message: 'Failed to process AI message.',
        details: e.toString(),
      );
      return AiResponse.failure(
        id: 'err_${DateTime.now().millisecondsSinceEpoch}',
        error: _lastError!,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteConversation(String conversationId) async {
    await _repository.deleteConversation(conversationId);
    if (_currentConversation?.id == conversationId) {
      _currentConversation = null;
    }
    await loadConversations();
  }

  Future<void> clearAllConversations() async {
    await _repository.clearAllConversations();
    _currentConversation = null;
    _conversations.clear();
    notifyListeners();
  }
}

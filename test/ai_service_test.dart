import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csse_study_hub/data/datasources/ai_provider_interface.dart';
import 'package:csse_study_hub/data/models/ai_message.dart';
import 'package:csse_study_hub/data/models/ai_request.dart';
import 'package:csse_study_hub/data/models/ai_response.dart';
import 'package:csse_study_hub/data/repositories/ai_conversation_repository.dart';
import 'package:csse_study_hub/data/services/ai_service.dart';
import 'package:csse_study_hub/presentation/providers/unidocs_ai_provider.dart';

/// Test mock provider implementing the vendor-agnostic AiProvider interface
class TestMockAiProvider implements AiProvider {
  AiRequest? lastReceivedRequest;
  bool shouldThrow = false;
  bool isHealthy = true;

  @override
  String get providerId => 'test_mock_provider';

  @override
  String get displayName => 'Test Mock AI Provider';

  @override
  Set<AiCapability> get supportedCapabilities => {
        AiCapability.chat,
        AiCapability.explain,
        AiCapability.quiz,
      };

  @override
  Future<bool> checkHealth() async => isHealthy;

  @override
  Future<AiResponse> generateResponse(AiRequest request) async {
    lastReceivedRequest = request;
    if (shouldThrow) {
      throw Exception('Remote server error simulation');
    }

    final prompt = request.latestUserMessage?.content ?? '';
    final responseMsg = AiMessage(
      id: 'mock_resp_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: request.conversationId,
      role: AiMessageRole.assistant,
      content: 'Echo response for: $prompt',
      timestamp: DateTime.now(),
      resourceReferences: const [
        AiResourceReference(id: 'python', title: 'Python Core', hubName: 'Coding Hub'),
      ],
    );

    return AiResponse(
      id: 'resp_success',
      message: responseMsg,
      usage: const AiUsageMetadata(promptTokens: 20, completionTokens: 10, totalTokens: 30),
      resourceReferences: responseMsg.resourceReferences,
    );
  }

  @override
  Stream<String> streamResponse(AiRequest request) async* {
    yield 'Echo: ';
    yield request.latestUserMessage?.content ?? '';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late LocalAiConversationRepository repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repo = LocalAiConversationRepository(prefs);
  });

  group('AiService & Provider Abstraction Tests', () {
    test('Default AiService uses NoOpAiProvider gracefully without throwing', () async {
      final service = AiService(repository: repo);
      expect(service.activeProviderId, equals('noop_provider'));

      final health = await service.checkProviderHealth();
      expect(health, isFalse);

      final resp = await service.sendMessage(
        conversationId: 'test_conv_noop',
        userPrompt: 'Tell me about Trees in DSA',
      );

      expect(resp.isFailure, isTrue);
      expect(resp.isSuccessful, isFalse);
      expect(resp.error?.code, equals(AiErrorCode.noProviderConfigured));
      expect(resp.error?.message, contains('not configured'));
    });

    test('AiService with Mock Provider receives context and persists conversation', () async {
      final mockProvider = TestMockAiProvider();
      final service = AiService(provider: mockProvider, repository: repo);

      final resp = await service.sendMessage(
        conversationId: 'conv_echo',
        userPrompt: 'What is Polymorphism?',
        topicIds: ['python'],
        capability: AiCapability.explain,
      );

      expect(resp.isSuccessful, isTrue);
      expect(resp.message?.content, equals('Echo response for: What is Polymorphism?'));
      expect(mockProvider.lastReceivedRequest, isNotNull);
      expect(mockProvider.lastReceivedRequest?.capability, equals(AiCapability.explain));
      expect(mockProvider.lastReceivedRequest?.context.unidocsResources.first.id, equals('python'));

      // Verify conversation persistence
      final savedConv = await repo.loadConversation('conv_echo');
      expect(savedConv, isNotNull);
      expect(savedConv!.messages.length, equals(2)); // User message + Assistant message
      expect(savedConv.messages[0].isUser, isTrue);
      expect(savedConv.messages[1].isAssistant, isTrue);
    });

    test('AiService error normalization on provider failure', () async {
      final mockProvider = TestMockAiProvider()..shouldThrow = true;
      final service = AiService(provider: mockProvider, repository: repo);

      final resp = await service.sendMessage(
        conversationId: 'conv_err',
        userPrompt: 'Will this fail?',
      );

      expect(resp.isFailure, isTrue);
      expect(resp.error?.code, equals(AiErrorCode.unknown));
      expect(resp.error?.isRetryable, isTrue);
    });

    test('AiService streaming returns stream chunks from provider', () async {
      final mockProvider = TestMockAiProvider();
      final service = AiService(provider: mockProvider, repository: repo);

      final stream = service.streamMessage(
        conversationId: 'conv_stream',
        userPrompt: 'Stream test',
      );

      final chunks = await stream.toList();
      expect(chunks, equals(['Echo: ', 'Stream test']));
    });
  });

  group('UniDocsAiProvider Presentation State Manager Tests', () {
    test('UniDocsAiProvider state management lifecycle', () async {
      final mockProvider = TestMockAiProvider();
      final service = AiService(provider: mockProvider, repository: repo);
      final stateProvider = UniDocsAiProvider(aiService: service, repository: repo);

      await stateProvider.createNewConversation(initialTitle: 'Practice Session');
      expect(stateProvider.currentConversation, isNotNull);
      expect(stateProvider.currentConversation?.title, equals('Practice Session'));

      final resp = await stateProvider.sendMessage('Explain Quick Sort');
      expect(resp.isSuccessful, isTrue);
      expect(stateProvider.messages.length, equals(2));
      expect(stateProvider.lastError, isNull);
      expect(stateProvider.isLoading, isFalse);

      stateProvider.setCapability(AiCapability.codeReview);
      expect(stateProvider.selectedCapability, equals(AiCapability.codeReview));

      await stateProvider.clearAllConversations();
      expect(stateProvider.conversations, isEmpty);
      expect(stateProvider.currentConversation, isNull);
    });
  });
}

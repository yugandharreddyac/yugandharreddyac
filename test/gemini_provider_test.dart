import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csse_study_hub/data/datasources/gemini_provider.dart';
import 'package:csse_study_hub/data/models/ai_context.dart';
import 'package:csse_study_hub/data/models/ai_message.dart';
import 'package:csse_study_hub/data/models/ai_request.dart';
import 'package:csse_study_hub/data/models/ai_response.dart';
import 'package:csse_study_hub/data/repositories/ai_conversation_repository.dart';
import 'package:csse_study_hub/data/services/ai_service.dart';

/// Test mock adapter for Dio to simulate backend responses
class MockDioAdapter implements HttpClientAdapter {
  int statusCode = 200;
  dynamic responseBody = {};
  DioExceptionType? throwType;
  RequestOptions? lastRequestOptions;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequestOptions = options;

    if (throwType != null) {
      throw DioException(
        requestOptions: options,
        type: throwType!,
        message: 'Simulated Dio Error',
      );
    }

    if (statusCode >= 400) {
      final jsonBytes = utf8.encode(json.encode(responseBody));
      final response = ResponseBody.fromBytes(
        jsonBytes,
        statusCode,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
      throw DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          data: responseBody,
          statusCode: statusCode,
        ),
        type: DioExceptionType.badResponse,
      );
    }

    final jsonBytes = utf8.encode(json.encode(responseBody));
    return ResponseBody.fromBytes(
      jsonBytes,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDioAdapter mockAdapter;
  late Dio testDio;
  late GeminiProvider provider;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockAdapter = MockDioAdapter();
    testDio = Dio()..httpClientAdapter = mockAdapter;
    provider = GeminiProvider(
      backendUrl: 'https://us-central1-csse-study-hub-prod.cloudfunctions.net/aiGenerate',
      dio: testDio,
    );
  });

  group('GeminiProvider Backend Communication Tests', () {
    test('Unconfigured backendUrl returns noProviderConfigured error gracefully', () async {
      final unconfiguredProvider = GeminiProvider(backendUrl: '');
      final req = AiRequest(
        conversationId: 'conv_1',
        messages: [
          AiMessage(
            id: 'm1',
            conversationId: 'conv_1',
            role: AiMessageRole.user,
            content: 'Hello',
            timestamp: DateTime.now(),
          ),
        ],
      );

      final resp = await unconfiguredProvider.generateResponse(req);
      expect(resp.isFailure, isTrue);
      expect(resp.error?.code, equals(AiErrorCode.noProviderConfigured));
    });

    test('generateResponse sends valid AiRequest payload and parses 200 OK response', () async {
      mockAdapter.statusCode = 200;
      mockAdapter.responseBody = {
        'id': 'resp_123',
        'message': {
          'id': 'msg_123',
          'conversationId': 'conv_1',
          'role': 'assistant',
          'content': 'Dijkstra algorithm finds the shortest path in a weighted graph.',
          'timestamp': DateTime.now().toIso8601String(),
          'resourceReferences': [
            {'id': 'dsa_graphs', 'title': 'Graph Algorithms', 'hubName': 'Coding Hub'}
          ],
          'suggestedFollowUps': ['What is the time complexity?'],
          'isError': false,
        },
        'usage': {
          'promptTokens': 45,
          'completionTokens': 20,
          'totalTokens': 65,
          'latencyMs': 420,
        },
        'resourceReferences': [
          {'id': 'dsa_graphs', 'title': 'Graph Algorithms', 'hubName': 'Coding Hub'}
        ],
      };

      final req = AiRequest(
        conversationId: 'conv_1',
        messages: [
          AiMessage(
            id: 'm1',
            conversationId: 'conv_1',
            role: AiMessageRole.user,
            content: 'Explain Dijkstra algorithm',
            timestamp: DateTime.now(),
          ),
        ],
        context: const AiContext(
          unidocsResources: [
            AiResourceReference(id: 'dsa_graphs', title: 'Graph Algorithms', hubName: 'Coding Hub'),
          ],
        ),
      );

      final resp = await provider.generateResponse(req);

      expect(resp.isSuccessful, isTrue);
      expect(resp.message?.content, contains('Dijkstra algorithm'));
      expect(resp.usage.totalTokens, equals(65));
      expect(resp.resourceReferences.first.id, equals('dsa_graphs'));

      // Verify request sent to backend
      expect(mockAdapter.lastRequestOptions?.path, contains('aiGenerate'));
      expect(mockAdapter.lastRequestOptions?.data, isA<Map<String, dynamic>>());
      final sentData = mockAdapter.lastRequestOptions?.data as Map<String, dynamic>;
      expect(sentData['conversationId'], equals('conv_1'));
      expect(sentData['messages'], isNotEmpty);
    });

    test('Error Normalization: 401 Unauthorized maps to authenticationFailed', () async {
      mockAdapter.statusCode = 401;
      mockAdapter.responseBody = {'error': {'code': 'authentication_failed', 'message': 'Unauthorized'}};

      final req = AiRequest(
        conversationId: 'conv_1',
        messages: [
          AiMessage(id: 'm1', conversationId: 'conv_1', role: AiMessageRole.user, content: 'Hi', timestamp: DateTime.now()),
        ],
      );

      final resp = await provider.generateResponse(req);
      expect(resp.isFailure, isTrue);
      expect(resp.error?.code, equals(AiErrorCode.authenticationFailed));
    });

    test('Error Normalization: 429 Too Many Requests maps to rateLimitExceeded', () async {
      mockAdapter.statusCode = 429;
      mockAdapter.responseBody = {'error': {'code': 'rate_limit_exceeded', 'message': 'Rate limit exceeded'}};

      final req = AiRequest(
        conversationId: 'conv_1',
        messages: [
          AiMessage(id: 'm1', conversationId: 'conv_1', role: AiMessageRole.user, content: 'Spam test', timestamp: DateTime.now()),
        ],
      );

      final resp = await provider.generateResponse(req);
      expect(resp.isFailure, isTrue);
      expect(resp.error?.code, equals(AiErrorCode.rateLimitExceeded));
      expect(resp.error?.isRetryable, isTrue);
    });

    test('Error Normalization: 413 Payload Too Large maps to invalidResponse', () async {
      mockAdapter.statusCode = 413;
      mockAdapter.responseBody = {'error': {'code': 'invalid_response', 'message': 'Payload too large'}};

      final req = AiRequest(
        conversationId: 'conv_1',
        messages: [
          AiMessage(id: 'm1', conversationId: 'conv_1', role: AiMessageRole.user, content: 'Giant prompt', timestamp: DateTime.now()),
        ],
      );

      final resp = await provider.generateResponse(req);
      expect(resp.isFailure, isTrue);
      expect(resp.error?.code, equals(AiErrorCode.invalidResponse));
    });

    test('Error Normalization: Timeout maps to timeout error', () async {
      mockAdapter.throwType = DioExceptionType.receiveTimeout;

      final req = AiRequest(
        conversationId: 'conv_1',
        messages: [
          AiMessage(id: 'm1', conversationId: 'conv_1', role: AiMessageRole.user, content: 'Slow question', timestamp: DateTime.now()),
        ],
      );

      final resp = await provider.generateResponse(req);
      expect(resp.isFailure, isTrue);
      expect(resp.error?.code, equals(AiErrorCode.timeout));
      expect(resp.error?.isRetryable, isTrue);
    });

    test('Error Normalization: Network connection failure maps to networkUnavailable', () async {
      mockAdapter.throwType = DioExceptionType.connectionError;

      final req = AiRequest(
        conversationId: 'conv_1',
        messages: [
          AiMessage(id: 'm1', conversationId: 'conv_1', role: AiMessageRole.user, content: 'Offline test', timestamp: DateTime.now()),
        ],
      );

      final resp = await provider.generateResponse(req);
      expect(resp.isFailure, isTrue);
      expect(resp.error?.code, equals(AiErrorCode.networkUnavailable));
    });

    test('checkHealth returns true on 200 OK and false on failure', () async {
      mockAdapter.statusCode = 200;
      final isHealthy = await provider.checkHealth();
      expect(isHealthy, isTrue);

      mockAdapter.statusCode = 500;
      final isUnhealthy = await provider.checkHealth();
      expect(isUnhealthy, isFalse);
    });
  });

  group('Security & Architectural Isolation Tests', () {
    test('Client requests contain ZERO Gemini API keys in headers or body', () async {
      mockAdapter.statusCode = 200;
      mockAdapter.responseBody = {
        'id': 'resp_sec',
        'message': {
          'id': 'msg_sec',
          'conversationId': 'conv_sec',
          'role': 'assistant',
          'content': 'Secure answer',
          'timestamp': DateTime.now().toIso8601String(),
        },
      };

      final req = AiRequest(
        conversationId: 'conv_sec',
        messages: [
          AiMessage(id: 'm1', conversationId: 'conv_sec', role: AiMessageRole.user, content: 'Security audit query', timestamp: DateTime.now()),
        ],
      );

      await provider.generateResponse(req);

      final headers = mockAdapter.lastRequestOptions?.headers ?? {};
      final data = mockAdapter.lastRequestOptions?.data ?? {};

      expect(headers.containsKey('x-goog-api-key'), isFalse);
      expect(headers.containsKey('key'), isFalse);
      expect(headers.containsKey('gemini_api_key'), isFalse);
      expect(data.toString().contains('AIzaSy'), isFalse);
    });

    test('AiService connects seamlessly with GeminiProvider', () async {
      mockAdapter.statusCode = 200;
      mockAdapter.responseBody = {
        'id': 'resp_svc',
        'message': {
          'id': 'msg_svc',
          'conversationId': 'conv_svc',
          'role': 'assistant',
          'content': 'Operating Systems handle process scheduling and memory management.',
          'timestamp': DateTime.now().toIso8601String(),
        },
      };

      final prefs = await SharedPreferences.getInstance();
      final repo = LocalAiConversationRepository(prefs);
      final service = AiService(provider: provider, repository: repo);

      final resp = await service.sendMessage(
        conversationId: 'conv_svc',
        userPrompt: 'What does an OS do?',
      );

      expect(resp.isSuccessful, isTrue);
      expect(resp.message?.content, contains('process scheduling'));

      final saved = await repo.loadConversation('conv_svc');
      expect(saved?.messages.length, equals(2));
      expect(saved?.messages.last.content, contains('process scheduling'));
    });
  });
}

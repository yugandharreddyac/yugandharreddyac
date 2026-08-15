import '../models/ai_request.dart';
import '../models/ai_response.dart';

/// Abstract contract for any AI model or provider backend
abstract class AiProvider {
  /// Unique identifier for this provider (e.g. 'noop', 'gemini_proxy', 'openai_proxy')
  String get providerId;

  /// Human-readable display name (e.g. 'UniDocs Cloud AI')
  String get displayName;

  /// Set of functional capabilities supported by this provider
  Set<AiCapability> get supportedCapabilities;

  /// Checks if the provider service is healthy and reachable
  Future<bool> checkHealth();

  /// Generates a complete AI response for the given request
  Future<AiResponse> generateResponse(AiRequest request);

  /// Streams chunks of response text for real-time output (extensible for future phases)
  Stream<String> streamResponse(AiRequest request);
}

/// Fallback provider used when no external AI backend is configured (Phase 1 Baseline)
class NoOpAiProvider implements AiProvider {
  const NoOpAiProvider();

  @override
  String get providerId => 'noop_provider';

  @override
  String get displayName => 'No-Op Provider (Unconfigured)';

  @override
  Set<AiCapability> get supportedCapabilities => {
        AiCapability.chat,
        AiCapability.explain,
        AiCapability.roadmapAdvice,
      };

  @override
  Future<bool> checkHealth() async => false;

  @override
  Future<AiResponse> generateResponse(AiRequest request) async {
    return AiResponse.failure(
      id: 'resp_${DateTime.now().millisecondsSinceEpoch}',
      error: const AiError(
        code: AiErrorCode.noProviderConfigured,
        message: 'UniDocs AI provider is not configured. Please connect an AI service backend.',
        details: 'Phase 1 Core Architecture baseline: No external AI backend configured.',
        isRetryable: false,
      ),
    );
  }

  @override
  Stream<String> streamResponse(AiRequest request) async* {
    yield 'UniDocs AI provider is not configured.';
  }
}

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/ai_request.dart';
import '../models/ai_response.dart';
import 'ai_provider_interface.dart';

/// Concrete production AI provider communicating securely with UniDocs backend proxy
class GeminiProvider implements AiProvider {
  final String backendUrl;
  final Dio _dio;
  final FirebaseAuth? _auth;

  GeminiProvider({
    this.backendUrl = '',
    Dio? dio,
    FirebaseAuth? auth,
  })  : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 30),
                sendTimeout: const Duration(seconds: 10),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ),
        _auth = auth;

  @override
  String get providerId => 'gemini_cloud';

  @override
  String get displayName => 'UniDocs AI (Gemini Flash)';

  @override
  Set<AiCapability> get supportedCapabilities => {
        AiCapability.chat,
        AiCapability.explain,
        AiCapability.summarize,
        AiCapability.quiz,
        AiCapability.codeReview,
        AiCapability.roadmapAdvice,
        AiCapability.interviewPractice,
        AiCapability.documentQA,
        AiCapability.studyPlan,
        AiCapability.projectGuidance,
      };

  @override
  Future<bool> checkHealth() async {
    if (backendUrl.trim().isEmpty) return false;
    try {
      final healthUrl = backendUrl.endsWith('/')
          ? '${backendUrl}health'
          : '$backendUrl/health';
      final res = await _dio.get(
        healthUrl,
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<AiResponse> generateResponse(AiRequest request) async {
    if (backendUrl.trim().isEmpty) {
      return AiResponse.failure(
        id: 'resp_unconfigured_${DateTime.now().millisecondsSinceEpoch}',
        error: const AiError(
          code: AiErrorCode.noProviderConfigured,
          message: 'UniDocs AI backend endpoint is not configured.',
          details:
              'Set a valid backend proxy URL to enable Gemini communication.',
          isRetryable: false,
        ),
      );
    }

    // 1. Fetch Firebase Auth ID Token if available
    String? idToken;
    try {
      final currentUser =
          _auth?.currentUser ?? FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        idToken = await currentUser.getIdToken();
      }
    } catch (_) {
      // Non-fatal if Firebase Auth is not initialized or user is offline
    }

    final headers = <String, dynamic>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (idToken != null && idToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $idToken';
    }

    // 2. Invoke Secure Backend Endpoint
    try {
      final endpointUrl =
          backendUrl.endsWith('/') ? '${backendUrl}generate' : backendUrl;
      final response = await _dio.post(
        endpointUrl,
        data: request.toMap(),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return AiResponse.fromMap(response.data as Map<String, dynamic>);
      }

      return AiResponse.failure(
        id: 'resp_invalid_${DateTime.now().millisecondsSinceEpoch}',
        error: const AiError(
          code: AiErrorCode.invalidResponse,
          message: 'Received an invalid response format from the AI backend.',
          isRetryable: true,
        ),
      );
    } on DioException catch (dioErr) {
      return _normalizeDioError(dioErr);
    } catch (e) {
      return AiResponse.failure(
        id: 'resp_err_${DateTime.now().millisecondsSinceEpoch}',
        error: AiError(
          code: AiErrorCode.unknown,
          message: 'An unexpected error occurred during AI generation.',
          details: e.toString(),
          isRetryable: true,
        ),
      );
    }
  }

  AiResponse _normalizeDioError(DioException dioErr) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final statusCode = dioErr.response?.statusCode;
    final responseData = dioErr.response?.data;

    // Check if backend returned structured error JSON
    if (responseData is Map<String, dynamic> &&
        responseData.containsKey('error')) {
      final errMap = responseData['error'];
      if (errMap is Map<String, dynamic>) {
        return AiResponse.failure(
          id: responseData['id']?.toString() ?? 'resp_err_$timestamp',
          error: AiError.fromMap(errMap),
        );
      }
    }

    // Map HTTP Status Codes
    if (statusCode == 401 || statusCode == 403) {
      return AiResponse.failure(
        id: 'resp_auth_$timestamp',
        error: const AiError(
          code: AiErrorCode.authenticationFailed,
          message:
              'Authentication failed. Please sign in to access UniDocs AI.',
          isRetryable: false,
        ),
      );
    }

    if (statusCode == 429) {
      return AiResponse.failure(
        id: 'resp_rate_$timestamp',
        error: const AiError(
          code: AiErrorCode.rateLimitExceeded,
          message:
              'You have sent too many requests. Please wait a moment before trying again.',
          isRetryable: true,
        ),
      );
    }

    if (statusCode == 413) {
      return AiResponse.failure(
        id: 'resp_payload_$timestamp',
        error: const AiError(
          code: AiErrorCode.invalidResponse,
          message:
              'Your prompt or document context is too large. Please shorten your message.',
          isRetryable: false,
        ),
      );
    }

    if (dioErr.type == DioExceptionType.connectionTimeout ||
        dioErr.type == DioExceptionType.receiveTimeout ||
        dioErr.type == DioExceptionType.sendTimeout) {
      return AiResponse.failure(
        id: 'resp_timeout_$timestamp',
        error: const AiError(
          code: AiErrorCode.timeout,
          message:
              'The request timed out while communicating with the AI service.',
          isRetryable: true,
        ),
      );
    }

    if (dioErr.type == DioExceptionType.connectionError) {
      return AiResponse.failure(
        id: 'resp_net_$timestamp',
        error: const AiError(
          code: AiErrorCode.networkUnavailable,
          message:
              'Network connection failed. Please check your internet connection.',
          isRetryable: true,
        ),
      );
    }

    return AiResponse.failure(
      id: 'resp_prov_$timestamp',
      error: AiError(
        code: AiErrorCode.providerUnavailable,
        message: 'The AI backend service is currently unavailable.',
        details: dioErr.message,
        isRetryable: true,
      ),
    );
  }

  @override
  Stream<String> streamResponse(AiRequest request) async* {
    final response = await generateResponse(request);
    if (response.isSuccessful && response.message != null) {
      yield response.message!.content;
    } else {
      yield response.error?.message ?? 'Failed to generate response.';
    }
  }
}

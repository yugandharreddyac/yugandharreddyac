import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/models/ai_message.dart';
import 'package:csse_study_hub/data/models/ai_attachment.dart';
import 'package:csse_study_hub/data/models/ai_conversation.dart';
import 'package:csse_study_hub/data/models/ai_context.dart';
import 'package:csse_study_hub/data/models/ai_request.dart';
import 'package:csse_study_hub/data/models/ai_response.dart';
import 'package:csse_study_hub/data/models/personalized_roadmap_models.dart';

void main() {
  group('AiMessage Model Tests', () {
    test('AiMessage role parsing and helper getters', () {
      expect(AiMessageRole.fromString('user'), equals(AiMessageRole.user));
      expect(AiMessageRole.fromString('assistant'), equals(AiMessageRole.assistant));
      expect(AiMessageRole.fromString('system'), equals(AiMessageRole.system));
      expect(AiMessageRole.fromString('tool'), equals(AiMessageRole.tool));
      expect(AiMessageRole.fromString('unknown'), equals(AiMessageRole.user));

      final msg = AiMessage(
        id: 'msg_1',
        conversationId: 'conv_1',
        role: AiMessageRole.assistant,
        content: 'Hello World',
        timestamp: DateTime(2026, 1, 1),
      );

      expect(msg.isAssistant, isTrue);
      expect(msg.isUser, isFalse);
      expect(msg.isSystem, isFalse);
    });

    test('AiMessage serialization round trip', () {
      final msg = AiMessage(
        id: 'msg_100',
        conversationId: 'conv_100',
        role: AiMessageRole.user,
        content: 'Explain Dijkstra algorithm',
        timestamp: DateTime(2026, 8, 15, 10, 0),
        suggestedFollowUps: const ['Show Python code', 'What is the time complexity?'],
        metadata: const {'source': 'quick_search'},
      );

      final map = msg.toMap();
      final reconstructed = AiMessage.fromMap(map);

      expect(reconstructed.id, equals(msg.id));
      expect(reconstructed.conversationId, equals(msg.conversationId));
      expect(reconstructed.role, equals(msg.role));
      expect(reconstructed.content, equals(msg.content));
      expect(reconstructed.suggestedFollowUps, equals(msg.suggestedFollowUps));
      expect(reconstructed.metadata['source'], equals('quick_search'));

      final jsonString = msg.toJson();
      final fromJson = AiMessage.fromJson(jsonString);
      expect(fromJson.id, equals(msg.id));
    });
  });

  group('AiAttachment Model Tests', () {
    test('AiAttachment parsing and serialization', () {
      expect(AiAttachmentSourceType.fromString('local_file'), equals(AiAttachmentSourceType.localFile));
      expect(AiAttachmentSourceType.fromString('unidocs_resource'), equals(AiAttachmentSourceType.unidocsResource));
      expect(AiAttachmentStatus.fromString('processed'), equals(AiAttachmentStatus.processed));

      final attachment = AiAttachment(
        id: 'att_1',
        filename: 'syllabus_dbms.pdf',
        mimeType: 'application/pdf',
        sizeBytes: 1048576,
        sourceType: AiAttachmentSourceType.localFile,
        status: AiAttachmentStatus.processed,
        extractedTextSnippet: 'Unit 1: Relational Model',
      );

      expect(attachment.isPdf, isTrue);
      expect(attachment.isProcessed, isTrue);

      final map = attachment.toMap();
      final reconstructed = AiAttachment.fromMap(map);
      expect(reconstructed.id, equals('att_1'));
      expect(reconstructed.filename, equals('syllabus_dbms.pdf'));
      expect(reconstructed.extractedTextSnippet, equals('Unit 1: Relational Model'));
    });
  });

  group('AiResponse & AiError Model Tests', () {
    test('AiResponse success and failure factory', () {
      final error = const AiError(
        code: AiErrorCode.noProviderConfigured,
        message: 'No provider connected',
        isRetryable: false,
      );

      final failResp = AiResponse.failure(id: 'resp_1', error: error);
      expect(failResp.isFailure, isTrue);
      expect(failResp.isSuccessful, isFalse);
      expect(failResp.error?.code, equals(AiErrorCode.noProviderConfigured));

      final successResp = AiResponse(
        id: 'resp_2',
        message: AiMessage(
          id: 'msg_2',
          conversationId: 'conv_1',
          role: AiMessageRole.assistant,
          content: 'Here is the explanation',
          timestamp: DateTime.now(),
        ),
        usage: const AiUsageMetadata(promptTokens: 100, completionTokens: 50, totalTokens: 150),
        resourceReferences: const [
          AiResourceReference(id: 'dsa_arrays', title: 'Arrays & Strings', hubName: 'Coding Hub'),
        ],
      );

      expect(successResp.isSuccessful, isTrue);
      expect(successResp.isFailure, isFalse);
      expect(successResp.usage.totalTokens, equals(150));
      expect(successResp.resourceReferences.first.id, equals('dsa_arrays'));

      final json = successResp.toJson();
      final fromJson = AiResponse.fromJson(json);
      expect(fromJson.id, equals('resp_2'));
      expect(fromJson.resourceReferences.length, equals(1));
    });
  });

  group('AiConversation Model Tests', () {
    test('AiConversation properties and message tracking', () {
      final now = DateTime.now();
      final conv = AiConversation(
        id: 'conv_main',
        title: 'Career Planning Session',
        createdAt: now,
        updatedAt: now,
        messages: [
          AiMessage(id: '1', conversationId: 'conv_main', role: AiMessageRole.user, content: 'Hi', timestamp: now),
          AiMessage(id: '2', conversationId: 'conv_main', role: AiMessageRole.assistant, content: 'Hello', timestamp: now),
        ],
      );

      expect(conv.messageCount, equals(2));
      expect(conv.isEmpty, isFalse);
      expect(conv.latestMessage?.content, equals('Hello'));

      final map = conv.toMap();
      final reconstructed = AiConversation.fromMap(map);
      expect(reconstructed.id, equals('conv_main'));
      expect(reconstructed.messageCount, equals(2));
    });
  });

  group('AiRequest & AiContext Model Tests', () {
    test('AiRequest latestUserMessage and serialization', () {
      final req = AiRequest(
        conversationId: 'conv_req',
        messages: [
          AiMessage(id: '1', conversationId: 'conv_req', role: AiMessageRole.user, content: 'First question', timestamp: DateTime.now()),
          AiMessage(id: '2', conversationId: 'conv_req', role: AiMessageRole.assistant, content: 'Answer', timestamp: DateTime.now()),
          AiMessage(id: '3', conversationId: 'conv_req', role: AiMessageRole.user, content: 'Second question', timestamp: DateTime.now()),
        ],
        capability: AiCapability.explain,
      );

      expect(req.latestUserMessage?.content, equals('Second question'));
      expect(req.capability, equals(AiCapability.explain));

      final json = req.toJson();
      final reconstructed = AiRequest.fromJson(json);
      expect(reconstructed.messages.length, equals(3));
      expect(reconstructed.capability, equals(AiCapability.explain));
    });

    test('AiContext with student profile and roadmap context', () {
      final profile = PersonalizedProfile(
        academicStage: AcademicStage.thirdYear,
        goals: const ['Placement'],
        careerDirections: const ['AI Engineer'],
        primaryCareerDirection: 'AI Engineer',
        primaryLanguage: 'Python',
        overallSkillLevel: SkillLevel.intermediate,
        weaknesses: const ['Mathematics'],
        dailyLearningTimeMinutes: 120,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final studentCtx = StudentContext.fromPersonalizedProfile(profile);
      expect(studentCtx.academicStage, equals('3rd Year'));
      expect(studentCtx.primaryCareerDirection, equals('AI Engineer'));
      expect(studentCtx.weaknesses, contains('Mathematics'));

      final aiContext = AiContext(
        student: studentCtx,
        unidocsResources: const [
          AiResourceReference(id: 'python', title: 'Python Core', hubName: 'Coding Hub'),
        ],
      );

      expect(aiContext.hasStudentContext, isTrue);
      expect(aiContext.hasResources, isTrue);
      expect(aiContext.hasRoadmapContext, isFalse);

      final json = aiContext.toJson();
      final fromJson = AiContext.fromJson(json);
      expect(fromJson.student?.primaryLanguage, equals('Python'));
      expect(fromJson.unidocsResources.first.id, equals('python'));
    });
  });
}

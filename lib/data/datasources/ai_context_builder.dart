import '../models/ai_attachment.dart';
import '../models/ai_context.dart';
import '../models/ai_response.dart';
import '../models/document_models.dart';
import '../models/personalized_roadmap_models.dart';
import '../repositories/document_repository.dart';
import 'non_academic_data.dart';

/// Context provider for student profile and preferences
class StudentContextProvider {
  const StudentContextProvider();

  StudentContext? build(PersonalizedProfile? profile) {
    if (profile == null) return null;
    return StudentContext.fromPersonalizedProfile(profile);
  }
}

/// Context provider for personalized learning roadmap
class RoadmapContextProvider {
  const RoadmapContextProvider();

  RoadmapContext? build(PersonalizedRoadmap? roadmap) {
    if (roadmap == null) return null;
    return RoadmapContext.fromPersonalizedRoadmap(roadmap);
  }
}

/// Context provider for grounded UniDocs curriculum resources
class UniDocsResourceContextProvider {
  const UniDocsResourceContextProvider();

  List<AiResourceReference> buildFromQuery(String query, {int limit = 3}) {
    if (query.trim().isEmpty) return const [];
    final results = <AiResourceReference>[];
    final qLower = query.toLowerCase();

    // Scan NonAcademicData for verified topics
    for (final hub in [
      NonAcademicData.codingHub,
      NonAcademicData.emergingTechHub,
      NonAcademicData.projectsHub,
      NonAcademicData.placementHub,
      NonAcademicData.higherEducationHub,
      NonAcademicData.entrepreneurshipHub,
    ]) {
      for (final cat in hub.categories) {
        for (final top in cat.topics) {
          final titleMatch = top.title.toLowerCase().contains(qLower);
          final descMatch = top.description.toLowerCase().contains(qLower);
          if (titleMatch || descMatch) {
            results.add(
              AiResourceReference(
                id: top.id,
                title: top.title,
                hubName: hub.title,
                route: hub.routeName,
                categoryName: cat.title,
                resourceType: 'hub_topic',
                routeArguments: {
                  'hub': hub,
                  'initialCategoryId': cat.id,
                  'targetTopicId': top.id,
                },
              ),
            );
            if (results.length >= limit) return results;
          }
        }
      }
    }
    return results;
  }

  List<AiResourceReference> buildFromTopicIds(List<String> topicIds) {
    final results = <AiResourceReference>[];
    for (final id in topicIds) {
      final match = NonAcademicData.findTopicById(id);
      if (match != null) {
        results.add(
          AiResourceReference(
            id: match.topic.id,
            title: match.topic.title,
            hubName: match.hub.title,
            route: match.hub.routeName,
            categoryName: match.category.title,
            resourceType: 'hub_topic',
            routeArguments: {
              'hub': match.hub,
              'initialCategoryId': match.category.id,
              'targetTopicId': match.topic.id,
            },
          ),
        );
      }
    }
    return results;
  }
}

/// Interface for future document retrieval and attachment context extraction
abstract class DocumentContextProvider {
  List<AiAttachment> buildFromAttachments(List<AiAttachment> attachments);
}

/// Default implementation passing verified attachment metadata
class DefaultDocumentContextProvider implements DocumentContextProvider {
  const DefaultDocumentContextProvider();

  @override
  List<AiAttachment> buildFromAttachments(List<AiAttachment> attachments) {
    return List.unmodifiable(attachments);
  }
}

/// Production RAG document context provider that queries DocumentRepository
class RagDocumentContextProvider implements DocumentContextProvider {
  final DocumentRepository? _documentRepository;
  final int maxChunksPerDocument;

  const RagDocumentContextProvider({
    DocumentRepository? documentRepository,
    this.maxChunksPerDocument = 8,
  }) : _documentRepository = documentRepository;

  @override
  List<AiAttachment> buildFromAttachments(List<AiAttachment> attachments) {
    return List.unmodifiable(attachments);
  }

  /// Queries the repository for relevant chunks and builds grounded text context
  Future<String?> buildGroundedContext({
    required String userQuery,
    required List<AiAttachment> attachments,
  }) async {
    if (_documentRepository == null || attachments.isEmpty) return null;

    final buffer = StringBuffer();
    int totalChunksFound = 0;

    for (final att in attachments) {
      final docId = att.id;
      final doc = await _documentRepository.getDocument(docId);
      if (doc == null || doc.chunks.isEmpty) continue;

      final searchResults = await _documentRepository.searchChunks(
        docId,
        userQuery,
        limit: maxChunksPerDocument,
      );

      final chunksToUse = searchResults.isNotEmpty
          ? searchResults
          : doc.chunks
              .take(3)
              .map((c) => DocumentSearchResult(
                  chunk: c, relevanceScore: 0.1, pageNumber: c.pageNumber))
              .toList();

      if (chunksToUse.isNotEmpty) {
        buffer.writeln(
            '\n--- DOCUMENT CONTEXT: "${doc.metadata.title}" (File: ${doc.metadata.fileName}) ---');
        for (final res in chunksToUse) {
          buffer.writeln('[Page ${res.pageNumber}] ${res.chunk.text}');
          totalChunksFound++;
        }
      }
    }

    if (totalChunksFound == 0) return null;

    buffer.writeln('\n--- INSTRUCTIONS FOR DOCUMENT-GROUNDED ANSWERS ---');
    buffer.writeln(
        '1. Answer using the provided document excerpts above whenever the student asks about the attached document.');
    buffer.writeln(
        '2. Explicitly cite the document title and page number (e.g. "[Page X]") for factual claims.');
    buffer.writeln(
        '3. If the provided document does not contain enough information to answer the question reliably, explicitly state: "I couldn\'t find enough information in the selected document to answer that reliably." Do not fabricate missing document content.');

    return buffer.toString();
  }
}

/// Composer unifying all modular context sources according to priority precedence
class AiContextComposer {
  final StudentContextProvider studentProvider;
  final RoadmapContextProvider roadmapProvider;
  final UniDocsResourceContextProvider resourceProvider;
  final DocumentContextProvider documentProvider;

  const AiContextComposer({
    this.studentProvider = const StudentContextProvider(),
    this.roadmapProvider = const RoadmapContextProvider(),
    this.resourceProvider = const UniDocsResourceContextProvider(),
    this.documentProvider = const DefaultDocumentContextProvider(),
  });

  AiContext compose({
    PersonalizedProfile? profile,
    PersonalizedRoadmap? roadmap,
    LearningContext? learningContext,
    String? userQuery,
    List<String>? topicIds,
    List<AiAttachment>? attachments,
    String? customSystemInstructions,
    String? documentContextText,
  }) {
    // 1. Build student and roadmap context
    final studentCtx = studentProvider.build(profile);
    final roadmapCtx = roadmapProvider.build(roadmap);

    // 2. Build verified UniDocs resources (grounding)
    final resources = <AiResourceReference>[];
    if (topicIds != null && topicIds.isNotEmpty) {
      resources.addAll(resourceProvider.buildFromTopicIds(topicIds));
    }
    if (userQuery != null && userQuery.isNotEmpty && resources.isEmpty) {
      resources.addAll(resourceProvider.buildFromQuery(userQuery));
    }

    // 3. Build document context
    final docRefs = attachments != null
        ? documentProvider.buildFromAttachments(attachments)
        : const <AiAttachment>[];

    // 4. Default anti-hallucination guardrail instructions
    var instructions = customSystemInstructions ??
        'You are UniDocs AI, a supportive Computer Science Engineering learning companion. '
            'Provide accurate, pedagogical, and concise explanations. '
            'Always prioritize verified UniDocs curriculum resources when available. '
            'Never fabricate nonexistent resource IDs, chapter names, or routes. '
            'Tailor advice to the student\'s academic stage, identified weaknesses, and career track.';

    // Inject document RAG context if available
    if (documentContextText != null && documentContextText.trim().isNotEmpty) {
      instructions = '$instructions\n$documentContextText';
    }

    return AiContext(
      student: studentCtx,
      roadmap: roadmapCtx,
      learning: learningContext,
      unidocsResources: resources,
      attachedDocuments: docRefs,
      systemInstructions: instructions,
    );
  }
}

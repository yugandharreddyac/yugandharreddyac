import '../models/personalized_roadmap_models.dart';

/// Abstract Generator Interface for Roadmap Generation
///
/// Designed to support:
/// 1. RuleBasedRoadmapGenerator (Deterministic, High-Speed, Offline)
/// 2. Future AiRoadmapGenerator (LLM / Agentic Coach Driven)
abstract class RoadmapGenerator {
  /// Generates a structured personalized roadmap based on the student profile
  Future<PersonalizedRoadmap> generateRoadmap({
    required PersonalizedProfile profile,
    PersonalizedRoadmap? existingRoadmap,
  });

  /// Adapts or recalculates the roadmap when progress, timeline, or goals shift
  Future<PersonalizedRoadmap> recalculateRoadmap({
    required PersonalizedProfile updatedProfile,
    required PersonalizedRoadmap currentRoadmap,
  });
}

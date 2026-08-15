import '../../core/routes/app_routes.dart';
import 'non_academic_data.dart';

/// Resolved UniDocs Resource reference connecting roadmap items to real existing content
class ResolvedResource {
  final String resourceReference;
  final String resourceType; // 'hub_topic', 'quiz', 'subject', 'coding_hub', 'project_hub', 'higher_ed'
  final String deepRoute;
  final Map<String, dynamic>? routeArguments;
  final bool isAvailable;

  const ResolvedResource({
    required this.resourceReference,
    required this.resourceType,
    required this.deepRoute,
    this.routeArguments,
    this.isAvailable = true,
  });

  static const ResolvedResource unavailable = ResolvedResource(
    resourceReference: '',
    resourceType: 'none',
    deepRoute: '',
    isAvailable: false,
  );
}

/// Dedicated Resource Resolver grounded strictly in existing UniDocs features and hubs
class RoadmapResourceResolver {
  RoadmapResourceResolver._();

  /// Resolves a technical skill into a real UniDocs entity or returns unavailable safely
  static ResolvedResource resolve(String targetSkill, {String? category, String? hintId}) {
    final skillLower = targetSkill.toLowerCase().trim();

    // 1. Direct Non-Academic Hub Match
    if (hintId != null && hintId.isNotEmpty) {
      final topicMatch = NonAcademicData.findTopicById(hintId);
      if (topicMatch != null) {
        return ResolvedResource(
          resourceReference: hintId,
          resourceType: 'hub_topic',
          deepRoute: topicMatch.hub.routeName,
          routeArguments: {
            'hub': topicMatch.hub,
            'initialCategoryId': topicMatch.category.id,
            'targetTopicId': topicMatch.topic.id,
          },
        );
      }
    }

    // 2. Specialized Hub Resolvers

    // A. Placement Mock Quiz & Aptitude
    if (skillLower.contains('aptitude') ||
        skillLower.contains('placement quiz') ||
        skillLower.contains('mock test') ||
        skillLower.contains('logical reasoning') ||
        skillLower.contains('verbal ability') ||
        skillLower.contains('technical mcq')) {
      return const ResolvedResource(
        resourceReference: 'placement_mock_quiz',
        resourceType: 'quiz',
        deepRoute: AppRoutes.quizHub,
      );
    }

    // B. Placement Hub Guidance & Interview Prep
    if (skillLower.contains('interview') ||
        skillLower.contains('resume') ||
        skillLower.contains('hr interview') ||
        skillLower.contains('placement preparation')) {
      return const ResolvedResource(
        resourceReference: 'placement_prep',
        resourceType: 'placement_hub',
        deepRoute: AppRoutes.placementHub,
      );
    }

    // C. Programming Languages & Coding Hub
    if (skillLower == 'python' ||
        skillLower.contains('python') ||
        skillLower == 'c++' ||
        skillLower.contains('c++') ||
        skillLower == 'java' ||
        skillLower.contains('java') ||
        skillLower == 'c' ||
        skillLower.contains('javascript') ||
        skillLower.contains('dart') ||
        skillLower.contains('sql')) {
      return const ResolvedResource(
        resourceReference: 'coding_hub_languages',
        resourceType: 'coding_hub',
        deepRoute: AppRoutes.codingHub,
      );
    }

    // D. Data Structures & Algorithms
    if (skillLower.contains('dsa') ||
        skillLower.contains('array') ||
        skillLower.contains('linked list') ||
        skillLower.contains('stack') ||
        skillLower.contains('queue') ||
        skillLower.contains('tree') ||
        skillLower.contains('graph') ||
        skillLower.contains('dynamic programming') ||
        skillLower.contains('recursion') ||
        skillLower.contains('sorting') ||
        skillLower.contains('searching')) {
      return const ResolvedResource(
        resourceReference: 'dsa_hub',
        resourceType: 'coding_hub',
        deepRoute: AppRoutes.codingHub,
      );
    }

    // E. Project Hub Blueprints
    if (skillLower.contains('project') ||
        skillLower.contains('blueprint') ||
        skillLower.contains('portfolio')) {
      return const ResolvedResource(
        resourceReference: 'project_blueprints',
        resourceType: 'project_hub',
        deepRoute: AppRoutes.projectHub,
      );
    }

    // F. Higher Education & Exams (GATE, GRE, CAT, MS)
    if (skillLower.contains('gate') ||
        skillLower.contains('gre') ||
        skillLower.contains('cat') ||
        skillLower.contains('higher studies') ||
        skillLower.contains('ms abroad')) {
      return const ResolvedResource(
        resourceReference: 'higher_education_exams',
        resourceType: 'higher_ed',
        deepRoute: AppRoutes.higherEducationHub,
      );
    }

    // G. Emerging Tech Hub (AI, Machine Learning, Cloud, DevOps, Cybersecurity)
    if (skillLower.contains('machine learning') ||
        skillLower.contains('deep learning') ||
        skillLower.contains('generative ai') ||
        skillLower.contains('ai') ||
        skillLower.contains('cloud') ||
        skillLower.contains('devops') ||
        skillLower.contains('docker') ||
        skillLower.contains('kubernetes') ||
        skillLower.contains('cybersecurity') ||
        skillLower.contains('ethical hacking')) {
      return const ResolvedResource(
        resourceReference: 'emerging_tech_domain',
        resourceType: 'emerging_tech',
        deepRoute: '/emerging-tech',
      );
    }

    // H. Entrepreneurship & Startups
    if (skillLower.contains('startup') ||
        skillLower.contains('entrepreneurship') ||
        skillLower.contains('mvp') ||
        skillLower.contains('pitch')) {
      return const ResolvedResource(
        resourceReference: 'entrepreneurship_hub',
        resourceType: 'entrepreneurship',
        deepRoute: AppRoutes.entrepreneurshipHub,
      );
    }

    // If no existing match is verified in UniDocs, return unavailable without broken links
    return ResolvedResource.unavailable;
  }
}

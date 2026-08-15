import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/datasources/ai_context_builder.dart';
import 'package:csse_study_hub/data/models/ai_attachment.dart';
import 'package:csse_study_hub/data/models/ai_context.dart';
import 'package:csse_study_hub/data/models/personalized_roadmap_models.dart';

void main() {
  group('AI Context Layer & Provider Tests', () {
    const studentProvider = StudentContextProvider();
    const roadmapProvider = RoadmapContextProvider();
    const resourceProvider = UniDocsResourceContextProvider();
    const composer = AiContextComposer();

    test('StudentContextProvider converts PersonalizedProfile correctly', () {
      final profile = PersonalizedProfile(
        academicStage: AcademicStage.secondYear,
        goals: const ['Skill Upgrade'],
        careerDirections: const ['Full Stack Developer'],
        primaryCareerDirection: 'Full Stack Developer',
        primaryLanguage: 'JavaScript',
        overallSkillLevel: SkillLevel.beginner,
        weaknesses: const ['Backend Development'],
        dailyLearningTimeMinutes: 60,
        targetTimeline: '1 year',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final ctx = studentProvider.build(profile);
      expect(ctx, isNotNull);
      expect(ctx!.academicStage, equals('2nd Year'));
      expect(ctx.primaryCareerDirection, equals('Full Stack Developer'));
      expect(ctx.primaryLanguage, equals('JavaScript'));
      expect(ctx.weaknesses, contains('Backend Development'));
      expect(ctx.dailyLearningMinutes, equals(60));
    });

    test('RoadmapContextProvider converts PersonalizedRoadmap correctly', () {
      final now = DateTime.now();
      final roadmap = PersonalizedRoadmap(
        id: 'rd_test',
        title: 'Full Stack Web Developer Roadmap',
        targetCareer: 'Full Stack Developer',
        mainGoal: 'Skill Upgrade',
        targetTimeline: '1 year',
        dailyMinutes: 90,
        weeklyAvailability: 'Weekdays + weekends',
        generatedAt: now,
        lastUpdatedAt: now,
        phases: [
          const RoadmapPhase(
            id: 'p1',
            title: 'Phase 1: Web Foundations',
            description: 'Foundations of web development',
            sequence: 1,
            estimatedDuration: '4 weeks',
            items: [
              RoadmapItem(
                id: 'item_1',
                title: 'HTML & CSS Mastery',
                description: 'HTML5 semantic tags & CSS3 styling',
                category: 'Frontend',
                phaseId: 'p1',
                sequence: 1,
                targetSkill: 'HTML/CSS',
                estimatedMinutes: 600,
                status: RoadmapItemStatus.completed,
              ),
              RoadmapItem(
                id: 'item_2',
                title: 'JavaScript ES6+',
                description: 'Modern JavaScript syntax & DOM APIs',
                category: 'Frontend',
                phaseId: 'p1',
                sequence: 2,
                targetSkill: 'JavaScript',
                estimatedMinutes: 900,
                status: RoadmapItemStatus.inProgress,
              ),
            ],
          ),
        ],
      );

      final ctx = roadmapProvider.build(roadmap);
      expect(ctx, isNotNull);
      expect(ctx!.roadmapTitle, equals('Full Stack Web Developer Roadmap'));
      expect(ctx.currentPhaseTitle, equals('Phase 1: Web Foundations'));
      expect(ctx.completedTasksCount, equals(1));
      expect(ctx.totalTasksCount, equals(2));
      expect(ctx.recommendedDailyMinutes, equals(90));
    });

    test('UniDocsResourceContextProvider retrieves verified topics from NonAcademicData', () {
      final queryMatches = resourceProvider.buildFromQuery('Python');
      expect(queryMatches, isNotEmpty);
      expect(queryMatches.any((r) => r.title.toLowerCase().contains('python')), isTrue);

      final idMatches = resourceProvider.buildFromTopicIds(['python', 'web_react', 'devops_docker']);
      expect(idMatches.length, equals(3));
      expect(idMatches[0].id, equals('python'));
      expect(idMatches[1].id, equals('web_react'));
      expect(idMatches[2].id, equals('devops_docker'));
    });

    test('AiContextComposer unifies all context sources with strict priority rules', () {
      final profile = PersonalizedProfile(
        academicStage: AcademicStage.thirdYear,
        goals: const ['Placement'],
        careerDirections: const ['AI Engineer'],
        primaryCareerDirection: 'AI Engineer',
        primaryLanguage: 'Python',
        dailyLearningTimeMinutes: 120,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final fullContext = composer.compose(
        profile: profile,
        userQuery: 'What are the main libraries for Machine Learning in Python?',
        topicIds: ['python', 'machine_learning'],
        attachments: [
          const AiAttachment(
            id: 'att_syllabus',
            filename: 'ai_syllabus.pdf',
            mimeType: 'application/pdf',
          ),
        ],
      );

      expect(fullContext.hasStudentContext, isTrue);
      expect(fullContext.hasResources, isTrue);
      expect(fullContext.hasDocuments, isTrue);
      expect(fullContext.unidocsResources.length, equals(2));
      expect(fullContext.attachedDocuments.first.filename, equals('ai_syllabus.pdf'));
      expect(fullContext.systemInstructions, contains('UniDocs AI'));
      expect(fullContext.precedenceRules.length, equals(5));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/datasources/local_storage_datasource.dart';
import 'package:csse_study_hub/data/models/textbook_model.dart';
import 'package:csse_study_hub/data/repositories/study_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StudyRepository repository;
  late LocalStorageDataSource localStorage;
  late FirebaseDataSource firebaseDataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    localStorage = LocalStorageDataSource(prefs);
    firebaseDataSource = FirebaseDataSource();
    repository = StudyRepository(
      firebaseDataSource: firebaseDataSource,
      localStorageDataSource: localStorage,
    );
  });

  group('Admin Textbook Manager Unit Tests', () {
    test('saveCourseOverview and fetchCourseOverview update overview data', () async {
      const subjectId = 'sub_ai';
      const overview = CourseOverviewModel(
        subjectId: subjectId,
        subjectName: 'Artificial Intelligence',
        description: 'Updated Overview Description',
        whyItMatters: 'Critical AI Core',
        prerequisites: ['Python', 'DSA'],
        learningObjectives: ['Master Search'],
        learningOutcomes: ['Build Agents'],
        estimatedStudyTime: '50 Study Hours',
        estimatedDifficulty: 'Advanced',
      );

      await repository.saveCourseOverview(overview);
      final fetched = await repository.getCourseOverview(subjectId);

      expect(fetched.description, equals('Updated Overview Description'));
      expect(fetched.estimatedDifficulty, equals('Advanced'));
    });

    test('saveTextbookChapter creates chapter and inserts new topic', () async {
      const subjectId = 'sub_ai';
      const chapter = TextbookChapterModel(
        id: 'ai_ch3',
        subjectId: subjectId,
        chapterNumber: 3,
        title: 'Adversarial Search & Game Trees',
        description: 'Minimax algorithm and alpha-beta pruning.',
        order: 3,
        sections: [
          TextbookSectionModel(
            id: 'ai_sec3_1',
            chapterId: 'ai_ch3',
            sectionNumber: '3.1',
            title: 'Game Trees & Minimax',
            description: 'Optimal decisions in games.',
            order: 1,
            topics: [
              TextbookTopicModel(
                id: 'ai_top3_1_1',
                sectionId: 'ai_sec3_1',
                topicNumber: '3.1.1',
                title: 'Minimax Algorithm',
                definition: 'Decision rule for minimizing possible loss.',
                intuition: 'Assume opponent plays optimally.',
                workingPrinciple: 'Evaluate utility functions recursively.',
                order: 1,
              ),
            ],
          ),
        ],
      );

      await repository.saveTextbookChapter(subjectId, chapter);
      final chapters = await repository.getTextbookChapters(subjectId);

      expect(chapters.any((c) => c.title.contains('Adversarial Search')), isTrue);
    });

    test('reorderTextbookChapters updates chapter order ranks', () async {
      const subjectId = 'sub_ai';
      final existingChapters = await repository.getTextbookChapters(subjectId);
      final reversed = existingChapters.reversed.toList();

      await repository.reorderTextbookChapters(subjectId, reversed);
      final reordered = await repository.getTextbookChapters(subjectId);

      expect(reordered.first.id, equals(reversed.first.id));
    });

    test('deleteTextbookChapter removes target chapter', () async {
      const subjectId = 'sub_ai';
      final initialChapters = await repository.getTextbookChapters(subjectId);
      final targetId = initialChapters.first.id;

      await repository.deleteTextbookChapter(subjectId, targetId);
      final remainingChapters = await repository.getTextbookChapters(subjectId);

      expect(remainingChapters.any((c) => c.id == targetId), isFalse);
    });
  });
}

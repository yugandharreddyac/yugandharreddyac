import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/repositories/project_repository.dart';
import 'package:csse_study_hub/presentation/providers/project_provider.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/datasources/search_index_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseDataSource firebaseDataSource;
  late ProjectRepository projectRepository;
  late ProjectProvider projectProvider;

  setUp(() {
    firebaseDataSource = FirebaseDataSource();
    projectRepository =
        ProjectRepository(firebaseDataSource: firebaseDataSource);
    projectProvider = ProjectProvider(projectRepository);
  });

  group('Project Hub Unit Tests', () {
    test('getProjects returns projects across multiple difficulty levels',
        () async {
      final projects = await projectRepository.getProjects();
      expect(projects, isNotEmpty);
      expect(projects.any((p) => p.difficulty == 'Beginner'), isTrue);
      expect(projects.any((p) => p.difficulty == 'Industry Level'), isTrue);
    });

    test('ProjectModel embeds complete blueprint metadata', () async {
      final projects = await projectRepository.getProjects();
      final p = projects.first;
      expect(p.problemStatement, isNotEmpty);
      expect(p.systemArchitecture, isNotEmpty);
      expect(p.folderStructure, isNotEmpty);
      expect(p.resumeDescription, isNotEmpty);
      expect(p.interviewQuestions, isNotEmpty);
    });

    test('ProjectProvider filters projects by category', () async {
      await projectProvider.fetchProjects();
      expect(projectProvider.projects, isNotEmpty);

      final cat = projectProvider.categories.firstWhere((c) => c != 'All');
      projectProvider.selectCategory(cat);
      expect(projectProvider.filteredProjects.every((p) => p.category == cat),
          isTrue);
    });

    test('SearchIndexEngine indexes Project Hub blueprints', () async {
      final engine = SearchIndexEngine();
      final projects = await projectRepository.getProjects();

      engine.buildIndex(
        [],
        [],
        projects: projects,
      );

      expect(engine.isIndexed, isTrue);
      final queryResult = engine.search('Study Hub');
      expect(
          queryResult.matchingItems.any((i) => i.title.contains('Study Hub')),
          isTrue);
    });
  });
}

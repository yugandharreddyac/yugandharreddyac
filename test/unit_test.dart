import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/repositories/career_repository.dart';
import 'package:csse_study_hub/data/repositories/coding_repository.dart';
import 'package:csse_study_hub/data/repositories/placement_repository.dart';
import 'package:csse_study_hub/data/repositories/project_repository.dart';
import 'package:csse_study_hub/data/repositories/higher_education_repository.dart';

void main() {
  group('CSSE Study Hub Unit Tests', () {
    final mockFirebaseDataSource = FirebaseDataSource();

    test('CareerRepository returns offline fallback data when remote is unavailable', () async {
      final repo = CareerRepository(firebaseDataSource: mockFirebaseDataSource);
      final techList = await repo.getCareerTechnologies();
      expect(techList.isNotEmpty, true);
      expect(techList.any((t) => t.name.contains('Artificial Intelligence')), true);
    });

    test('CodingRepository returns offline fallback coding resources', () async {
      final repo = CodingRepository(firebaseDataSource: mockFirebaseDataSource);
      final resources = await repo.getCodingResources();
      expect(resources.isNotEmpty, true);
      expect(resources.any((r) => r.title.contains('Striver SDE Sheet')), true);
    });

    test('PlacementRepository returns aptitude & interview preparation items', () async {
      final repo = PlacementRepository(firebaseDataSource: mockFirebaseDataSource);
      final placements = await repo.getPlacementResources();
      expect(placements.isNotEmpty, true);
      expect(placements.any((p) => p.category == 'Aptitude'), true);
      expect(placements.any((p) => p.category == 'Technical Interview'), true);
    });

    test('ProjectRepository returns mini and major projects', () async {
      final repo = ProjectRepository(firebaseDataSource: mockFirebaseDataSource);
      final projects = await repo.getProjects();
      expect(projects.isNotEmpty, true);
      expect(projects.any((p) => p.title.contains('CSSE Study Hub')), true);
    });

    test('HigherEducationRepository returns higher studies & govt exam guides', () async {
      final repo = HigherEducationRepository(firebaseDataSource: mockFirebaseDataSource);
      final exams = await repo.getHigherEducationResources();
      expect(exams.isNotEmpty, true);
      expect(exams.any((e) => e.title.contains('GATE')), true);
    });
  });
}

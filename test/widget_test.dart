import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csse_study_hub/main.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/datasources/local_storage_datasource.dart';
import 'package:csse_study_hub/data/repositories/study_repository.dart';
import 'package:csse_study_hub/data/repositories/career_repository.dart';
import 'package:csse_study_hub/data/repositories/coding_repository.dart';
import 'package:csse_study_hub/data/repositories/placement_repository.dart';
import 'package:csse_study_hub/data/repositories/project_repository.dart';
import 'package:csse_study_hub/data/repositories/higher_education_repository.dart';
import 'package:csse_study_hub/data/repositories/admin_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('CSSE Study Hub app smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final localStorage = LocalStorageDataSource(prefs);
    final firebaseDataSource = FirebaseDataSource();
    final studyRepository = StudyRepository(
      firebaseDataSource: firebaseDataSource,
      localStorageDataSource: localStorage,
    );
    final careerRepository =
        CareerRepository(firebaseDataSource: firebaseDataSource);
    final codingRepository =
        CodingRepository(firebaseDataSource: firebaseDataSource);
    final placementRepository =
        PlacementRepository(firebaseDataSource: firebaseDataSource);
    final projectRepository =
        ProjectRepository(firebaseDataSource: firebaseDataSource);
    final higherEducationRepository =
        HigherEducationRepository(firebaseDataSource: firebaseDataSource);
    final adminRepository =
        AdminRepository(firebaseDataSource: firebaseDataSource);

    await tester.pumpWidget(
      CSSEStudyHubApp(
        localStorageDataSource: localStorage,
        firebaseDataSource: firebaseDataSource,
        studyRepository: studyRepository,
        careerRepository: careerRepository,
        codingRepository: codingRepository,
        placementRepository: placementRepository,
        projectRepository: projectRepository,
        higherEducationRepository: higherEducationRepository,
        adminRepository: adminRepository,
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('UNIDOCS'), findsWidgets);
  });
}

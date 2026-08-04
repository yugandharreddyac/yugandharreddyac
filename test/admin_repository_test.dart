import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/repositories/admin_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdminRepository Unit Tests', () {
    late FirebaseDataSource firebaseDataSource;
    late AdminRepository adminRepository;

    setUp(() {
      firebaseDataSource = FirebaseDataSource();
      adminRepository = AdminRepository(firebaseDataSource: firebaseDataSource);
    });

    test('getDashboardMetrics returns default/fallback metrics dictionary', () async {
      final metrics = await adminRepository.getDashboardMetrics();
      expect(metrics.containsKey('totalSubjects'), true);
      expect(metrics.containsKey('totalResources'), true);
      expect(metrics.containsKey('totalDownloads'), true);
      expect(metrics.containsKey('totalUsers'), true);
      expect(metrics['totalSubjects'], greaterThanOrEqualTo(0));
    });

    test('getUsers returns registered user list fallback', () async {
      final users = await adminRepository.getUsers();
      expect(users.isNotEmpty, true);
      expect(users.any((u) => u.role == 'admin'), true);
    });
  });
}

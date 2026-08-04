import 'package:flutter_test/flutter_test.dart';
import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/repositories/admin_repository.dart';
import 'package:csse_study_hub/presentation/providers/admin_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdminProvider Unit Tests', () {
    late FirebaseDataSource firebaseDataSource;
    late AdminRepository adminRepository;
    late AdminProvider adminProvider;

    setUp(() {
      firebaseDataSource = FirebaseDataSource();
      adminRepository = AdminRepository(firebaseDataSource: firebaseDataSource);
      adminProvider = AdminProvider(repository: adminRepository);
    });

    test('fetchDashboardMetrics updates metrics state', () async {
      await adminProvider.fetchDashboardMetrics();
      expect(adminProvider.state, AdminViewState.success);
      expect(adminProvider.metrics['totalSubjects'], greaterThan(0));
    });

    test('setUserSearchQuery filters users list', () async {
      await adminProvider.fetchUsers();
      adminProvider.setUserSearchQuery('admin');
      final filtered = adminProvider.users;
      expect(
        filtered.every(
          (u) =>
              (u.email?.contains('admin') ?? false) ||
              (u.displayName?.toLowerCase().contains('admin') ?? false) ||
              u.role.contains('admin'),
        ),
        true,
      );
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:csse_study_hub/data/datasources/firebase_datasource.dart';
import 'package:csse_study_hub/data/datasources/local_storage_datasource.dart';
import 'package:csse_study_hub/data/repositories/admin_repository.dart';
import 'package:csse_study_hub/presentation/providers/admin_provider.dart';
import 'package:csse_study_hub/presentation/providers/auth_provider.dart';
import 'package:csse_study_hub/presentation/providers/theme_provider.dart';
import 'package:csse_study_hub/presentation/screens/admin/admin_login_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('AdminLoginScreen renders header and form fields',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final localStorage = LocalStorageDataSource(prefs);
    final firebaseDataSource = FirebaseDataSource();
    final adminRepository =
        AdminRepository(firebaseDataSource: firebaseDataSource);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider(localStorage)),
          ChangeNotifierProvider(
              create: (_) => AuthProvider(firebaseDataSource)),
          ChangeNotifierProvider(
              create: (_) => AdminProvider(repository: adminRepository)),
        ],
        child: const MaterialApp(
          home: AdminLoginScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Admin Portal Verification'), findsOneWidget);
    expect(find.text('Sign In as Admin'), findsOneWidget);
  });
}

import 'package:firebase_auth/firebase_auth.dart';
import '../datasources/firebase_datasource.dart';
import '../models/user_model.dart';

class AuthenticationRepository {
  final FirebaseDataSource firebaseDataSource;

  AuthenticationRepository({required this.firebaseDataSource});

  User? get currentUser => firebaseDataSource.currentUser;

  Stream<User?> get authStateChanges => firebaseDataSource.authStateChanges;

  /// Anonymous Sign In for MVP
  Future<UserCredential?> signInAnonymously() async {
    return await firebaseDataSource.signInAnonymously();
  }

  /// Google Sign In / Email Auth structure for modular future expansion
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    return await firebaseDataSource.signInWithEmail(email, password);
  }

  Future<UserCredential?> registerWithEmail(String email, String password) async {
    return await firebaseDataSource.registerWithEmail(email, password);
  }

  Future<void> signOut() async {
    await firebaseDataSource.signOut();
  }

  Future<UserModel?> fetchUserProfile(String uid) async {
    return await firebaseDataSource.getUserProfile(uid);
  }

  Future<void> updateUserProfile(UserModel userModel) async {
    await firebaseDataSource.syncUserProfile(userModel);
  }
}

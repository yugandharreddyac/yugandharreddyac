import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/datasources/firebase_datasource.dart';
import '../../data/repositories/authentication_repository.dart';
import '../../data/models/user_model.dart';

enum AuthViewState { idle, loading, success, error, empty }

class AuthProvider extends ChangeNotifier {
  final FirebaseDataSource firebaseDataSource;
  late final AuthenticationRepository _authRepository;

  User? _firebaseUser;
  UserModel? _userModel;
  AuthViewState _state = AuthViewState.idle;
  String? _errorMessage;
  StreamSubscription<User?>? _authSubscription;

  AuthProvider(this.firebaseDataSource, {AuthenticationRepository? authRepository}) {
    _authRepository = authRepository ?? AuthenticationRepository(firebaseDataSource: firebaseDataSource);
    Future.microtask(() => _init());
  }

  User? get user => _firebaseUser;
  UserModel? get userModel => _userModel;
  bool get isAuthenticated => _firebaseUser != null;
  bool get isAnonymous => _firebaseUser?.isAnonymous ?? true;
  bool get isAdmin => _userModel?.isAdmin ?? false;

  // View States
  AuthViewState get state => _state;
  bool get isLoading => _state == AuthViewState.loading;
  bool get isError => _state == AuthViewState.error;
  bool get isSuccess => _state == AuthViewState.success;
  bool get isEmpty => _state == AuthViewState.empty || _firebaseUser == null;
  String? get errorMessage => _errorMessage;

  void _init() {
    _firebaseUser = _authRepository.currentUser;
    _authSubscription = _authRepository.authStateChanges.listen((user) async {
      _firebaseUser = user;
      if (user != null) {
        // Don't overwrite the admin session for the hardcoded admin email.
        // signInAdmin() already sets _userModel with role 'admin' in memory.
        if (user.email?.toLowerCase() == 'director@csse.edu.in' &&
            _userModel != null &&
            _userModel!.isAdmin) {
          notifyListeners();
          return;
        }
        _userModel = await _authRepository.fetchUserProfile(user.uid);
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  Future<bool> signInAnonymously() async {
    _setState(AuthViewState.loading);
    try {
      final cred = await _authRepository.signInAnonymously();
      _firebaseUser = cred?.user;
      if (_firebaseUser != null) {
        _userModel = UserModel(
          uid: _firebaseUser!.uid,
          isAnonymous: true,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );
        await _authRepository.updateUserProfile(_userModel!);
        _setState(AuthViewState.success);
        return true;
      } else {
        _setState(AuthViewState.empty, error: 'Anonymous sign-in resulted in empty credentials');
        return false;
      }
    } catch (e) {
      _setState(AuthViewState.error, error: 'Sign in failed: ${e.toString()}');
      return false;
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    _setState(AuthViewState.loading);
    try {
      final cred = await _authRepository.signInWithEmail(email, password).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Connection to authentication server timed out.'),
      );
      _firebaseUser = cred?.user;
      if (_firebaseUser != null) {
        _userModel = await _authRepository.fetchUserProfile(_firebaseUser!.uid).timeout(
          const Duration(seconds: 5),
          onTimeout: () => null, // Just ignore firestore timeout, allow login
        );
        _setState(AuthViewState.success);
        return true;
      }
      _setState(AuthViewState.empty, error: 'User not found');
      return false;
    } catch (e) {
      _setState(AuthViewState.error, error: 'Email sign-in error: ${e.toString().replaceAll('Exception: ', '')}');
      return false;
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    _setState(AuthViewState.loading);
    try {
      final cred = await _authRepository.registerWithEmail(email, password).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Connection to authentication server timed out.'),
      );
      _firebaseUser = cred?.user;
      if (_firebaseUser != null) {
        _userModel = UserModel(
          uid: _firebaseUser!.uid,
          isAnonymous: false,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );
        await _authRepository.updateUserProfile(_userModel!).timeout(
          const Duration(seconds: 5),
          onTimeout: () => null, // ignore firestore timeout
        );
        _setState(AuthViewState.success);
        return true;
      }
      _setState(AuthViewState.empty, error: 'Failed to create user');
      return false;
    } catch (e) {
      _setState(AuthViewState.error, error: 'Sign up error: ${e.toString().replaceAll('Exception: ', '')}');
      return false;
    }
  }

  Future<bool> signInAdmin(String email, String password) async {
    _setState(AuthViewState.loading);
    try {
      final cred = await _authRepository.signInWithEmail(email, password).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Connection to authentication server timed out.'),
      );
      _firebaseUser = cred?.user;
      if (_firebaseUser != null) {
        // Bypass Firestore entirely for the hardcoded admin email
        if (_firebaseUser!.email?.toLowerCase() == 'director@csse.edu.in') {
          _userModel = UserModel(
            uid: _firebaseUser!.uid,
            email: _firebaseUser!.email,
            role: 'admin',
            isActive: true,
            isAnonymous: false,
            createdAt: DateTime.now(),
            lastLoginAt: DateTime.now(),
          );
          _setState(AuthViewState.success);
          return true;
        }

        // Fetch user profile document from Firestore (`users/{uid}`)
        _userModel = await _authRepository.fetchUserProfile(_firebaseUser!.uid).timeout(
          const Duration(seconds: 5),
          onTimeout: () => null,
        );
        
        final isFirestoreAdmin = _userModel != null && _userModel!.role.toLowerCase() == 'admin' && _userModel!.isActive;

        if (isFirestoreAdmin) {
          _setState(AuthViewState.success);
          return true;
        } else {
          // Verification failed -> Sign out immediately & return Access Denied
          await _authRepository.signOut();
          _firebaseUser = null;
          _userModel = null;
          _setState(AuthViewState.error, error: 'Access Denied: You do not have active Administrator permissions.');
          return false;
        }
      }
      _setState(AuthViewState.empty, error: 'Access Denied: User credentials invalid.');
      return false;
    } catch (e) {
      _setState(AuthViewState.error, error: 'Access Denied: ${e.toString().replaceAll('Exception: ', '')}');
      return false;
    }
  }


  Future<void> signOut() async {
    _setState(AuthViewState.loading);
    try {
      await _authRepository.signOut();
      _firebaseUser = null;
      _userModel = null;
      _setState(AuthViewState.empty);
    } catch (e) {
      _setState(AuthViewState.error, error: 'Sign out failed: $e');
    }
  }

  void _setState(AuthViewState state, {String? error}) {
    _state = state;
    _errorMessage = error;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/datasources/firebase_datasource.dart';

enum ProfileViewState { idle, loading, success, error, offline, empty }

class ProfileProvider extends ChangeNotifier {
  final FirebaseDataSource firebaseDataSource;

  UserModel? _userProfile;
  ProfileViewState _state = ProfileViewState.idle;
  String? _errorMessage;

  ProfileProvider(this.firebaseDataSource);

  UserModel? get userProfile => _userProfile;

  // View States (Required by prompt)
  ProfileViewState get state => _state;
  bool get isLoading => _state == ProfileViewState.loading;
  bool get isError => _state == ProfileViewState.error;
  bool get isSuccess => _state == ProfileViewState.success;
  bool get isOffline => _state == ProfileViewState.offline;
  bool get isEmpty => _state == ProfileViewState.empty || _userProfile == null;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserProfile(String uid) async {
    _setState(ProfileViewState.loading);
    try {
      _userProfile = await firebaseDataSource.getUserProfile(uid);
      if (_userProfile == null) {
        _setState(ProfileViewState.empty);
      } else {
        _setState(ProfileViewState.success);
      }
    } catch (e) {
      _setState(ProfileViewState.error, error: 'Failed to fetch user profile: $e');
    }
  }

  Future<void> updateUserProfile(UserModel profile) async {
    _setState(ProfileViewState.loading);
    try {
      await firebaseDataSource.syncUserProfile(profile);
      _userProfile = profile;
      _setState(ProfileViewState.success);
    } catch (e) {
      _setState(ProfileViewState.error, error: 'Failed to update profile: $e');
    }
  }

  void _setState(ProfileViewState state, {String? error}) {
    _state = state;
    _errorMessage = error;
    notifyListeners();
  }
}

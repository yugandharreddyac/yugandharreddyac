import 'package:flutter/material.dart';
import '../../data/repositories/admin_repository.dart';
import '../../data/models/user_model.dart';
import '../../data/models/resource_model.dart';

enum AdminViewState { idle, loading, success, error }

class AdminProvider extends ChangeNotifier {
  final AdminRepository repository;

  AdminViewState _state = AdminViewState.idle;
  String? _errorMessage;

  Map<String, dynamic> _metrics = {
    'totalSubjects': 24,
    'totalResources': 8,
    'totalDownloads': 1200,
    'totalUsers': 450,
    'adminCount': 1,
    'studentCount': 449,
    'storageBytesUsed': 33600000,
  };

  List<UserModel> _users = [];
  final List<ResourceModel> _selectedResourcesForBulk = [];
  String _userSearchQuery = '';

  AdminProvider({required this.repository});

  AdminViewState get state => _state;
  bool get isLoading => _state == AdminViewState.loading;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic> get metrics => _metrics;
  List<UserModel> get users {
    if (_userSearchQuery.trim().isEmpty) return _users;
    final query = _userSearchQuery.toLowerCase();
    return _users.where((u) {
      final emailMatch = u.email?.toLowerCase().contains(query) ?? false;
      final nameMatch = u.displayName?.toLowerCase().contains(query) ?? false;
      final roleMatch = u.role.toLowerCase().contains(query);
      return emailMatch || nameMatch || roleMatch;
    }).toList();
  }

  List<ResourceModel> get selectedResourcesForBulk => _selectedResourcesForBulk;

  Future<void> fetchDashboardMetrics() async {
    _state = AdminViewState.loading;
    notifyListeners();
    try {
      final data = await repository.getDashboardMetrics();
      _metrics = data;
      _state = AdminViewState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AdminViewState.error;
    }
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    _state = AdminViewState.loading;
    notifyListeners();
    try {
      _users = await repository.getUsers();
      _state = AdminViewState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AdminViewState.error;
    }
    notifyListeners();
  }

  void setUserSearchQuery(String query) {
    _userSearchQuery = query;
    notifyListeners();
  }

  Future<void> updateUserRole(String uid, String newRole) async {
    try {
      await repository.updateUserRole(uid, newRole);
      final index = _users.indexWhere((u) => u.uid == uid);
      if (index != -1) {
        _users[index] = _users[index].copyWith(role: newRole);
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateUserStatus(String uid, bool isDisabled) async {
    try {
      await repository.updateUserStatus(uid, isDisabled);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Bulk Selection Logic
  void toggleResourceSelection(ResourceModel resource) {
    if (_selectedResourcesForBulk.any((r) => r.id == resource.id)) {
      _selectedResourcesForBulk.removeWhere((r) => r.id == resource.id);
    } else {
      _selectedResourcesForBulk.add(resource);
    }
    notifyListeners();
  }

  void clearBulkSelection() {
    _selectedResourcesForBulk.clear();
    notifyListeners();
  }

  Future<void> bulkDeleteSelected() async {
    if (_selectedResourcesForBulk.isEmpty) return;
    _state = AdminViewState.loading;
    notifyListeners();
    try {
      await repository.bulkDeleteResources(_selectedResourcesForBulk);
      _selectedResourcesForBulk.clear();
      await fetchDashboardMetrics();
      _state = AdminViewState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AdminViewState.error;
    }
    notifyListeners();
  }
}

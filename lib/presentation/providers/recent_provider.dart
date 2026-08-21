import 'package:flutter/material.dart';
import '../../data/models/recent_resource_model.dart';
import '../../data/models/resource_model.dart';
import '../../data/datasources/local_storage_datasource.dart';
import '../../data/repositories/recent_repository.dart';

enum RecentViewState { loading, success, error, offline, empty, idle }

class RecentProvider extends ChangeNotifier {
  final LocalStorageDataSource localStorage;
  late final RecentRepository _recentRepository;

  List<RecentResourceModel> _recentResources = [];
  RecentViewState _state = RecentViewState.idle;
  String? _errorMessage;

  RecentProvider(this.localStorage, {RecentRepository? recentRepository}) {
    _recentRepository =
        recentRepository ?? RecentRepository(localStorage: localStorage);
    Future.microtask(() => loadRecentResources());
  }

  List<RecentResourceModel> get recentResources => _recentResources;

  RecentViewState get state => _state;
  bool get isLoading => _state == RecentViewState.loading;
  bool get isSuccess => _state == RecentViewState.success;
  bool get isError => _state == RecentViewState.error;
  bool get isOffline => _state == RecentViewState.offline;
  bool get isEmpty =>
      _state == RecentViewState.empty || _recentResources.isEmpty;
  String? get errorMessage => _errorMessage;

  void loadRecentResources() {
    _setState(RecentViewState.loading);
    try {
      _recentResources = _recentRepository.fetchRecentResources();
      if (_recentResources.isEmpty) {
        _setState(RecentViewState.empty);
      } else {
        _setState(RecentViewState.success);
      }
    } catch (e) {
      _setState(RecentViewState.error,
          error: 'Failed to load recent history: $e');
    }
  }

  Future<void> recordResourceOpened(
    ResourceModel resource, {
    int lastReadPage = 1,
    int totalPages = 1,
  }) async {
    try {
      await _recentRepository.recordResourceOpened(
        resourceId: resource.id,
        resourceTitle: resource.title,
        subjectName: resource.subjectName,
        resourceType: resource.resourceType,
        storageUrl: resource.storageUrl,
        lastReadPage: lastReadPage,
        totalPages: totalPages,
      );
      loadRecentResources();
    } catch (e) {
      _setState(RecentViewState.error,
          error: 'Failed to record recent view: $e');
    }
  }

  int getLastReadPage(String resourceId) {
    return _recentRepository.getLastReadPage(resourceId);
  }

  Future<void> updateLastReadPage(String resourceId, int pageNumber) async {
    await _recentRepository.saveLastReadPage(resourceId, pageNumber);
  }

  Future<void> clearHistory() async {
    try {
      await _recentRepository.clearHistory();
      _recentResources = [];
      _setState(RecentViewState.empty);
    } catch (e) {
      _setState(RecentViewState.error, error: 'Failed to clear history: $e');
    }
  }

  void _setState(RecentViewState state, {String? error}) {
    _state = state;
    _errorMessage = error;
    notifyListeners();
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/year_model.dart';
import '../../data/models/semester_model.dart';
import '../../data/models/subject_model.dart';
import '../../data/models/resource_model.dart';
import '../../data/repositories/study_repository.dart';

enum ViewState { idle, loading, success, error, offline, empty }

class StudyProvider extends ChangeNotifier {
  final StudyRepository repository;

  StudyProvider(this.repository);

  List<YearModel> _years = [];
  List<SemesterModel> _semesters = [];
  List<SubjectModel> _subjects = [];
  List<ResourceModel> _resources = [];
  List<SubjectModel> _subjectSearchResults = [];
  List<ResourceModel> _searchResults = [];

  ViewState _state = ViewState.idle;
  String? _errorMessage;
  String _selectedResourceType = '';
  String _searchQuery = '';
  Timer? _searchDebounceTimer;

  // Data Getters
  List<YearModel> get years => _years;
  List<SemesterModel> get semesters => _semesters;
  List<SubjectModel> get subjects => _subjects;
  List<ResourceModel> get resources => _resources;
  List<SubjectModel> get subjectSearchResults => _subjectSearchResults;
  List<ResourceModel> get searchResults => _searchResults;

  // View State Getters
  ViewState get state => _state;
  bool get isLoading => _state == ViewState.loading;
  bool get isError => _state == ViewState.error;
  bool get isSuccess => _state == ViewState.success;
  bool get isOffline => _state == ViewState.offline;
  bool get isEmpty => _state == ViewState.empty;
  String? get errorMessage => _errorMessage;

  String get selectedResourceType => _selectedResourceType;
  String get searchQuery => _searchQuery;

  // --- Load Academic Hierarchy ---

  Future<void> fetchYears() async {
    _setState(ViewState.loading);
    try {
      _years = await repository.getYears();
      if (_years.isEmpty) {
        _setState(ViewState.empty);
      } else {
        _setState(ViewState.success);
      }
    } catch (e) {
      _setState(ViewState.error, error: 'Failed to load academic years: $e');
    }
  }

  Future<void> fetchSemesters(String yearId) async {
    _setState(ViewState.loading);
    try {
      _semesters = await repository.getSemesters(yearId);
      if (_semesters.isEmpty) {
        _setState(ViewState.empty);
      } else {
        _setState(ViewState.success);
      }
    } catch (e) {
      _setState(ViewState.error, error: 'Failed to load semesters: $e');
    }
  }

  Future<void> fetchSubjects(String semesterId) async {
    _setState(ViewState.loading);
    try {
      _subjects = await repository.getSubjects(semesterId);
      if (_subjects.isEmpty) {
        _setState(ViewState.empty);
      } else {
        _setState(ViewState.success);
      }
    } catch (e) {
      _setState(ViewState.error, error: 'Failed to load subjects: $e');
    }
  }

  Future<void> fetchResources(String subjectId, {String? resourceType}) async {
    _setState(ViewState.loading);
    _selectedResourceType = resourceType ?? '';
    try {
      _resources = await repository.getResources(subjectId, resourceType: resourceType);
      if (_resources.isEmpty) {
        _setState(ViewState.empty);
      } else {
        _setState(ViewState.success);
      }
    } catch (e) {
      _setState(ViewState.error, error: 'Failed to load study resources: $e');
    }
  }

  void setFilterCategory(String subjectId, String type) {
    if (_selectedResourceType == type) {
      _selectedResourceType = '';
      fetchResources(subjectId);
    } else {
      fetchResources(subjectId, resourceType: type);
    }
  }

  // --- Global Academic Search with 300ms Debounce ---

  void search(String query) {
    _searchQuery = query;
    _searchDebounceTimer?.cancel();

    if (query.trim().isEmpty) {
      _subjectSearchResults = [];
      _searchResults = [];
      _setState(ViewState.idle);
      return;
    }

    // 300ms Debounce to prevent heavy queries while typing
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () async {
      _setState(ViewState.loading);
      try {
        final globalResult = await repository.searchGlobalAll(query);
        _subjectSearchResults = globalResult.matchingSubjects;
        _searchResults = globalResult.matchingResources;

        if (globalResult.isEmpty) {
          _setState(ViewState.empty);
        } else {
          _setState(ViewState.success);
        }
      } catch (e) {
        _subjectSearchResults = [];
        _searchResults = [];
        _setState(ViewState.error, error: 'Search failed: $e');
      }
    });
  }

  void clearSearch() {
    _searchDebounceTimer?.cancel();
    _searchQuery = '';
    _subjectSearchResults = [];
    _searchResults = [];
    _setState(ViewState.idle);
  }

  Future<void> incrementDownload(String resourceId) async {
    await repository.incrementDownloadCount(resourceId);
  }

  void _setState(ViewState state, {String? error}) {
    _state = state;
    _errorMessage = error;
    notifyListeners();
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    super.dispose();
  }
}

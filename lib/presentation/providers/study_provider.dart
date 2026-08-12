import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/year_model.dart';
import '../../data/models/semester_model.dart';
import '../../data/models/subject_model.dart';
import '../../data/models/resource_model.dart';
import '../../data/models/textbook_model.dart';
import '../../data/models/searchable_item.dart';
import '../../data/repositories/study_repository.dart';

enum ViewState { idle, loading, success, error, offline, empty }

class StudyProvider extends ChangeNotifier {
  final StudyRepository repository;

  StudyProvider(this.repository);

  List<YearModel> _years = [];
  List<SemesterModel> _semesters = [];
  List<SubjectModel> _subjects = [];
  List<ResourceModel> _resources = [];
  CourseOverviewModel? _courseOverview;
  List<TextbookChapterModel> _textbookChapters = [];
  List<AcademicQuestionModel> _importantQuestions = [];
  List<QuickRevisionModel> _quickRevisionNotes = [];
  List<LabExperimentModel> _labExperiments = [];
  List<AcademicProjectModel> _academicProjects = [];
  List<ExternalResourceModel> _additionalResources = [];
  List<SubjectModel> _subjectSearchResults = [];
  List<ResourceModel> _searchResults = [];
  List<SearchableItem> _matchingItems = [];

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
  CourseOverviewModel? get courseOverview => _courseOverview;
  List<TextbookChapterModel> get textbookChapters => _textbookChapters;
  List<AcademicQuestionModel> get importantQuestions => _importantQuestions;
  List<QuickRevisionModel> get quickRevisionNotes => _quickRevisionNotes;
  List<LabExperimentModel> get labExperiments => _labExperiments;
  List<AcademicProjectModel> get academicProjects => _academicProjects;
  List<ExternalResourceModel> get additionalResources => _additionalResources;
  List<SubjectModel> get subjectSearchResults => _subjectSearchResults;
  List<ResourceModel> get searchResults => _searchResults;
  List<SearchableItem> get matchingItems => _matchingItems;

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
      _matchingItems = [];
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
        _matchingItems = globalResult.matchingItems;

        if (globalResult.isEmpty) {
          _setState(ViewState.empty);
        } else {
          _setState(ViewState.success);
        }
      } catch (e) {
        _subjectSearchResults = [];
        _searchResults = [];
        _matchingItems = [];
        _setState(ViewState.error, error: 'Search failed: $e');
      }
    });
  }

  void clearSearch() {
    _searchDebounceTimer?.cancel();
    _searchQuery = '';
    _subjectSearchResults = [];
    _searchResults = [];
    _matchingItems = [];
    _setState(ViewState.idle);
  }

  Future<void> fetchCourseOverview(String subjectId) async {
    try {
      _courseOverview = await repository.getCourseOverview(subjectId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching course overview: $e');
    }
  }

  Future<void> fetchTextbookChapters(String subjectId) async {
    try {
      _textbookChapters = await repository.getTextbookChapters(subjectId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching textbook chapters: $e');
    }
  }

  Future<void> fetchImportantQuestions(String subjectId) async {
    try {
      _importantQuestions = await repository.getImportantQuestions(subjectId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching important questions: $e');
    }
  }

  Future<void> fetchQuickRevisionNotes(String subjectId) async {
    try {
      _quickRevisionNotes = await repository.getQuickRevisionNotes(subjectId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching quick revision notes: $e');
    }
  }

  Future<void> fetchLabExperiments(String subjectId) async {
    try {
      _labExperiments = await repository.getLabExperiments(subjectId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching lab experiments: $e');
    }
  }

  Future<void> fetchAcademicProjects(String subjectId) async {
    try {
      _academicProjects = await repository.getAcademicProjects(subjectId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching academic projects: $e');
    }
  }

  Future<void> fetchAdditionalResources(String subjectId) async {
    try {
      _additionalResources = await repository.getAdditionalResources(subjectId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching additional resources: $e');
    }
  }

  Future<void> saveCourseOverview(CourseOverviewModel overview) async {
    try {
      await repository.saveCourseOverview(overview);
      _courseOverview = overview;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving course overview: $e');
      rethrow;
    }
  }

  Future<void> deleteCourseOverview(String subjectId) async {
    try {
      await repository.deleteCourseOverview(subjectId);
      _courseOverview = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting course overview: $e');
      rethrow;
    }
  }

  Future<void> saveTextbookChapter(String subjectId, TextbookChapterModel chapter) async {
    try {
      await repository.saveTextbookChapter(subjectId, chapter);
      await fetchTextbookChapters(subjectId);
    } catch (e) {
      debugPrint('Error saving textbook chapter: $e');
      rethrow;
    }
  }

  Future<void> deleteTextbookChapter(String subjectId, String chapterId) async {
    try {
      await repository.deleteTextbookChapter(subjectId, chapterId);
      await fetchTextbookChapters(subjectId);
    } catch (e) {
      debugPrint('Error deleting textbook chapter: $e');
      rethrow;
    }
  }

  Future<void> reorderTextbookChapters(String subjectId, List<TextbookChapterModel> chapters) async {
    try {
      await repository.reorderTextbookChapters(subjectId, chapters);
      _textbookChapters = chapters;
      notifyListeners();
    } catch (e) {
      debugPrint('Error reordering chapters: $e');
      rethrow;
    }
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

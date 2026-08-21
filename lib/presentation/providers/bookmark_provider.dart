import 'package:flutter/material.dart';
import '../../data/models/bookmark_model.dart';
import '../../data/models/resource_model.dart';
import '../../data/datasources/local_storage_datasource.dart';

enum BookmarkViewState { idle, loading, success, error, offline, empty }

class BookmarkProvider extends ChangeNotifier {
  final LocalStorageDataSource _localStorage;
  List<BookmarkModel> _bookmarks = [];

  BookmarkViewState _state = BookmarkViewState.idle;
  String? _errorMessage;

  BookmarkProvider(this._localStorage) {
    Future.microtask(() => loadBookmarks());
  }

  List<BookmarkModel> get bookmarks => _bookmarks;

  // View States
  BookmarkViewState get state => _state;
  bool get isLoading => _state == BookmarkViewState.loading;
  bool get isError => _state == BookmarkViewState.error;
  bool get isSuccess => _state == BookmarkViewState.success;
  bool get isOffline => _state == BookmarkViewState.offline;
  bool get isEmpty => _state == BookmarkViewState.empty || _bookmarks.isEmpty;
  String? get errorMessage => _errorMessage;

  void loadBookmarks() {
    _setState(BookmarkViewState.loading);
    try {
      _bookmarks = _localStorage.getBookmarks();
      if (_bookmarks.isEmpty) {
        _setState(BookmarkViewState.empty);
      } else {
        _setState(BookmarkViewState.success);
      }
    } catch (e) {
      _setState(BookmarkViewState.error, error: 'Failed to load bookmarks: $e');
    }
  }

  bool isBookmarked(String resourceId, {int? pageNumber}) {
    return _bookmarks.any((b) =>
        b.resourceId == resourceId &&
        (pageNumber == null || b.pageNumber == pageNumber));
  }

  Future<void> toggleBookmark(ResourceModel resource,
      {int? pageNumber, String? note}) async {
    try {
      final existingIndex = _bookmarks.indexWhere((b) =>
          b.resourceId == resource.id &&
          (pageNumber == null
              ? b.pageNumber == null
              : b.pageNumber == pageNumber));

      if (existingIndex >= 0) {
        _bookmarks.removeAt(existingIndex);
      } else {
        final newBookmark = BookmarkModel(
          id: 'bm_${DateTime.now().millisecondsSinceEpoch}',
          resourceId: resource.id,
          resourceTitle: resource.title,
          resourceType: resource.resourceType,
          subjectName: resource.subjectName,
          pageNumber: pageNumber,
          note: note,
          createdAt: DateTime.now(),
        );
        _bookmarks.insert(0, newBookmark);
      }

      await _localStorage.saveBookmarks(_bookmarks);
      if (_bookmarks.isEmpty) {
        _setState(BookmarkViewState.empty);
      } else {
        _setState(BookmarkViewState.success);
      }
    } catch (e) {
      _setState(BookmarkViewState.error,
          error: 'Failed to update bookmark: $e');
    }
  }

  Future<void> removeBookmark(String bookmarkId) async {
    try {
      _bookmarks.removeWhere((b) => b.id == bookmarkId);
      await _localStorage.saveBookmarks(_bookmarks);
      if (_bookmarks.isEmpty) {
        _setState(BookmarkViewState.empty);
      } else {
        _setState(BookmarkViewState.success);
      }
    } catch (e) {
      _setState(BookmarkViewState.error,
          error: 'Failed to remove bookmark: $e');
    }
  }

  void _setState(BookmarkViewState state, {String? error}) {
    _state = state;
    _errorMessage = error;
    notifyListeners();
  }
}

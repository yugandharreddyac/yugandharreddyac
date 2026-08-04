import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bookmark_model.dart';
import '../models/resource_model.dart';
import '../models/recent_resource_model.dart';
import '../../core/constants/app_constants.dart';

class LocalStorageDataSource {
  final SharedPreferences _prefs;

  LocalStorageDataSource(this._prefs);

  // --- Theme Mode ---
  int getThemeIndex() {
    return _prefs.getInt(AppConstants.themePrefKey) ?? 0;
  }

  Future<void> saveThemeIndex(int index) async {
    await _prefs.setInt(AppConstants.themePrefKey, index);
  }

  // --- Bookmarks ---
  List<BookmarkModel> getBookmarks() {
    final String? raw = _prefs.getString(AppConstants.bookmarksPrefKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw);
      return list.map((item) => BookmarkModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveBookmarks(List<BookmarkModel> bookmarks) async {
    final String raw = jsonEncode(bookmarks.map((b) => b.toJson()).toList());
    await _prefs.setString(AppConstants.bookmarksPrefKey, raw);
  }

  // --- Download History & Local Files ---
  List<ResourceModel> getDownloadedResources() {
    final String? raw = _prefs.getString('downloaded_resources');
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw);
      return list
          .map((item) => ResourceModel.fromFirestore(item as Map<String, dynamic>, item['id']))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveDownloadedResources(List<ResourceModel> downloads) async {
    final String raw = jsonEncode(downloads.map((d) => d.toFirestore()).toList());
    await _prefs.setString('downloaded_resources', raw);
  }

  /// Hierarchical Download Path Creator:
  /// StudyHub/Downloads/{Year}/{Semester}/{Subject}/{ResourceType}/{filename}.pdf
  Future<String> getStructuredDownloadFilePath({
    required String year,
    required String semester,
    required String subject,
    required String resourceType,
    required String fileName,
  }) async {
    if (kIsWeb) return '';
    final baseDir = await getApplicationDocumentsDirectory();

    final cleanYear = _sanitizeFolderName(year.isEmpty ? 'GeneralYear' : year);
    final cleanSemester = _sanitizeFolderName(semester.isEmpty ? 'GeneralSemester' : semester);
    final cleanSubject = _sanitizeFolderName(subject.isEmpty ? 'GeneralSubject' : subject);
    final cleanCategory = _sanitizeFolderName(resourceType.isEmpty ? 'GeneralType' : resourceType);
    final cleanFileName = fileName.endsWith('.pdf') ? fileName : '$fileName.pdf';

    final fullDirPath = '${baseDir.path}/StudyHub/Downloads/$cleanYear/$cleanSemester/$cleanSubject/$cleanCategory';
    final directory = Directory(fullDirPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return '${directory.path}/$cleanFileName';
  }

  /// Default download directory path for legacy/fallback access
  Future<String> getAppDownloadDirectoryPath() async {
    if (kIsWeb) return '';
    final dir = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${dir.path}/StudyHub/Downloads');
    if (!await pdfDir.exists()) {
      await pdfDir.create(recursive: true);
    }
    return pdfDir.path;
  }

  // --- Recently Opened History (Max 50) ---
  List<RecentResourceModel> getRecentResources() {
    final String? raw = _prefs.getString('recent_resources_history');
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw);
      return list.map((item) => RecentResourceModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveRecentResource(RecentResourceModel recent) async {
    final list = getRecentResources();
    list.removeWhere((r) => r.resourceId == recent.resourceId);
    list.insert(0, recent);

    // Limit to max 50 items
    if (list.length > 50) {
      list.removeRange(50, list.length);
    }

    final String raw = jsonEncode(list.map((r) => r.toJson()).toList());
    await _prefs.setString('recent_resources_history', raw);
  }

  Future<void> clearRecentHistory() async {
    await _prefs.remove('recent_resources_history');
  }

  // --- Per-Resource Last Read Page Tracking ---
  int getLastReadPage(String resourceId) {
    return _prefs.getInt('last_read_page_$resourceId') ?? 1;
  }

  Future<void> saveLastReadPage(String resourceId, int pageNumber) async {
    await _prefs.setInt('last_read_page_$resourceId', pageNumber);
  }

  String _sanitizeFolderName(String name) {
    return name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
  }
}

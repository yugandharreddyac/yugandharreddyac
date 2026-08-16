import 'package:flutter/foundation.dart';
import '../models/year_model.dart';
import '../models/semester_model.dart';
import '../models/subject_model.dart';
import '../models/resource_model.dart';
import '../models/textbook_model.dart';
import '../models/global_search_result.dart';
import '../datasources/firebase_datasource.dart';
import '../datasources/local_storage_datasource.dart';
import '../datasources/mock_data.dart';
import '../datasources/textbook_mock_data.dart';
import '../datasources/search_index_engine.dart';
import 'firestore_repository.dart';
import 'storage_repository.dart';

class StudyRepository {
  final FirebaseDataSource firebaseDataSource;
  final LocalStorageDataSource localStorageDataSource;
  late final FirestoreRepository _firestoreRepository;
  late final StorageRepository _storageRepository;

  // In-Memory Caches for Instant Page Loading & Reduced Firestore Reads
  List<YearModel>? _cachedYears;
  final Map<String, List<SemesterModel>> _cachedSemesters = {};
  final Map<String, List<SubjectModel>> _cachedSubjects = {};
  final Map<String, List<ResourceModel>> _cachedResources = {};
  final Map<String, CourseOverviewModel> _cachedCourseOverviews = {};
  final Map<String, List<TextbookChapterModel>> _cachedTextbookChapters = {};

  StudyRepository({
    required this.firebaseDataSource,
    required this.localStorageDataSource,
    FirestoreRepository? firestoreRepository,
    StorageRepository? storageRepository,
  }) {
    _firestoreRepository = firestoreRepository ?? FirestoreRepository(firebaseDataSource: firebaseDataSource);
    _storageRepository = storageRepository ?? StorageRepository(firebaseDataSource: firebaseDataSource);
  }

  FirestoreRepository get firestore => _firestoreRepository;
  StorageRepository get storage => _storageRepository;

  /// Fetch Academic Years (Served from Memory Cache if available)
  Future<List<YearModel>> getYears() async {
    if (_cachedYears != null && _cachedYears!.isNotEmpty) {
      return _cachedYears!;
    }

    try {
      if (firebaseDataSource.isAvailable) {
        final list = await _firestoreRepository.fetchYears();
        if (list.isNotEmpty) {
          _cachedYears = list;
          return list;
        }
      }
    } catch (e) {
      debugPrint('Firestore fetch failed for years, using local cache: $e');
    }
    _cachedYears = MockData.years;
    return _cachedYears!;
  }

  /// Fetch Semesters for a Year (Served from Memory Cache if available)
  Future<List<SemesterModel>> getSemesters(String yearId) async {
    if (_cachedSemesters.containsKey(yearId)) {
      return _cachedSemesters[yearId]!;
    }

    try {
      if (firebaseDataSource.isAvailable) {
        final list = await _firestoreRepository.fetchSemesters(yearId);
        if (list.isNotEmpty) {
          _cachedSemesters[yearId] = list;
          return list;
        }
      }
    } catch (e) {
      debugPrint('Firestore fetch failed for semesters: $e');
    }
    final fallback = MockData.semesters.where((s) => s.yearId == yearId).toList();
    _cachedSemesters[yearId] = fallback;
    return fallback;
  }

  /// Fetch Subjects for a Semester (Served from Memory Cache if available)
  Future<List<SubjectModel>> getSubjects(String semesterId) async {
    if (_cachedSubjects.containsKey(semesterId)) {
      return _cachedSubjects[semesterId]!;
    }

    try {
      if (firebaseDataSource.isAvailable) {
        final list = await _firestoreRepository.fetchSubjects(semesterId);
        if (list.isNotEmpty) {
          _cachedSubjects[semesterId] = list;
          return list;
        }
      }
    } catch (e) {
      debugPrint('Firestore fetch failed for subjects: $e');
    }
    final fallback = MockData.subjects.where((s) => s.semesterId == semesterId).toList();
    _cachedSubjects[semesterId] = fallback;
    return fallback;
  }

  SearchIndexEngine _searchEngine = SearchIndexEngine();

  /// Fetch all subjects across the entire curriculum (Combining Firestore & Fallback)
  Future<List<SubjectModel>> getAllSubjects() async {
    final Map<String, SubjectModel> subjectMap = {};

    // 1. Load default CSSE subjects dataset
    for (final s in MockData.subjects) {
      subjectMap[s.id] = s;
    }

    // 2. Fetch Firestore subjects if available
    try {
      if (firebaseDataSource.isAvailable) {
        for (final year in MockData.years) {
          final sems = await getSemesters(year.id);
          for (final sem in sems) {
            final subjs = await getSubjects(sem.id);
            for (final subj in subjs) {
              subjectMap[subj.id] = subj;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Firestore fetch for all subjects notice: $e');
    }

    return subjectMap.values.toList();
  }

  /// Fetch all resources across the entire application (Combining Firestore & Fallback)
  Future<List<ResourceModel>> getAllResources() async {
    final Map<String, ResourceModel> resourceMap = {};

    // 1. Load default CSSE resources dataset
    for (final r in MockData.resources) {
      resourceMap[r.id] = r;
    }

    // 2. Fetch Firestore resources if available
    try {
      if (firebaseDataSource.isAvailable) {
        final firestoreList = await _firestoreRepository.searchResources('');
        for (final res in firestoreList) {
          resourceMap[res.id] = res;
        }
      }
    } catch (e) {
      debugPrint('Firestore fetch for all resources notice: $e');
    }

    return resourceMap.values.toList();
  }

  /// Build or refresh search index once
  Future<void> ensureSearchIndexBuilt() async {
    if (_searchEngine.isIndexed) return;

    final subjects = await getAllSubjects();
    final resources = await getAllResources();
    _searchEngine.buildIndex(
      subjects,
      resources,
      textbookChaptersMap: _cachedTextbookChapters,
      courseOverviewsMap: _cachedCourseOverviews,
    );
  }

  /// Fetch Resources for a Subject with optional category filter (Memory Cached)
  Future<List<ResourceModel>> getResources(String subjectId, {String? resourceType}) async {
    final cacheKey = '${subjectId}_${resourceType ?? "all"}';
    if (_cachedResources.containsKey(cacheKey)) {
      return _cachedResources[cacheKey]!;
    }

    try {
      if (firebaseDataSource.isAvailable) {
        final list = await _firestoreRepository.fetchResources(subjectId, resourceType: resourceType);
        if (list.isNotEmpty) {
          final resolvedList = await Future.wait(list.map((res) async {
            if (res.storageUrl.isNotEmpty && !res.storageUrl.startsWith('http')) {
              final resolvedUrl = await _storageRepository.resolveDownloadUrl(res.storageUrl);
              return res.copyWith(storageUrl: resolvedUrl);
            }
            return res;
          }));
          _cachedResources[cacheKey] = resolvedList;
          return resolvedList;
        }
      }
    } catch (e) {
      debugPrint('Firestore fetch failed for resources: $e');
    }

    var list = MockData.resources.where((r) => r.subjectId == subjectId).toList();
    if (resourceType != null && resourceType.isNotEmpty) {
      list = list.where((r) => r.resourceType == resourceType).toList();
    }
    _cachedResources[cacheKey] = list;
    return list;
  }

  /// True Global Search across Years, Semesters, Subjects, Syllabus Topics & Resources
  Future<GlobalSearchResult> searchGlobalAll(String query) async {
    if (query.trim().isEmpty) {
      return const GlobalSearchResult();
    }

    await ensureSearchIndexBuilt();
    return _searchEngine.search(query);
  }

  /// Backward-compatible search returning resources only
  Future<List<ResourceModel>> searchGlobal(String query) async {
    final result = await searchGlobalAll(query);
    return result.matchingResources;
  }

  /// Admin PDF Upload: Storage Upload + Firestore Document Creation + Cache Invalidation
  Future<ResourceModel> uploadAdminPdfResource({
    required YearModel year,
    required SemesterModel semester,
    required SubjectModel subject,
    required String resourceType,
    required String title,
    required String description,
    required String fileName,
    required List<int> pdfBytes,
    required void Function(double progress) onProgress,
    int pageCount = 0,
    List<String> tags = const [],
    String? sectionType,
  }) async {
    // 1. Build Storage Path
    final storagePath = _storageRepository.buildStoragePath(
      year: year.id,
      semester: semester.id,
      subject: subject.name,
      resourceType: resourceType,
      fileName: fileName,
    );

    // 2. Check for duplicate resource
    final exists = await _firestoreRepository.checkResourceExists(
      subjectId: subject.id,
      resourceType: resourceType,
      title: title,
    );
    if (exists) {
      throw Exception('A document titled "$title" already exists for ${subject.name} under $resourceType.');
    }

    // 3. Upload PDF bytes to Firebase Storage with live progress callback
    String downloadUrl = '';
    if (firebaseDataSource.isAvailable) {
      downloadUrl = await _storageRepository.uploadPdf(
        storagePath: storagePath,
        bytes: pdfBytes,
        onProgress: onProgress,
      );
    }

    // 4. Create ResourceModel instance
    final now = DateTime.now();
    final newResource = ResourceModel(
      id: '',
      title: title,
      description: description.isNotEmpty ? description : 'Official $resourceType for ${subject.name}',
      subjectId: subject.id,
      subjectName: subject.name,
      yearId: year.id,
      semesterId: semester.id,
      resourceType: resourceType,
      storagePath: storagePath,
      storageUrl: downloadUrl,
      fileSizeBytes: pdfBytes.length,
      pageCount: pageCount,
      downloadCount: 0,
      tags: tags.isNotEmpty ? tags : [subject.name, resourceType, year.title],
      lastUpdated: now,
      isFeatured: false,
      isActive: true,
      sectionType: sectionType,
    );

    // 5. Store Firestore Document in 'resources' collection
    if (firebaseDataSource.isAvailable) {
      final docId = await _firestoreRepository.createResourceDocument(newResource);
      final finalResource = newResource.copyWith(id: docId);

      // Invalidate memory cache so students instantly see the new PDF
      clearMemoryCache();
      return finalResource;
    } else {
      // Local fallback
      clearMemoryCache();
      return newResource;
    }
  }

  /// Record resource download count
  Future<void> incrementDownloadCount(String resourceId) async {
    try {
      if (firebaseDataSource.isAvailable) {
        await _firestoreRepository.incrementDownloadCount(resourceId);
      }
    } catch (e) {
      debugPrint('Error incrementing download count: $e');
    }
  }

  /// Update resource metadata
  Future<void> updateResource(ResourceModel resource) async {
    final updated = resource.copyWith(lastUpdated: DateTime.now());
    if (firebaseDataSource.isAvailable) {
      await firebaseDataSource.updateResourceDocument(updated);
    }
    clearMemoryCache();
  }

  /// Delete resource document and optional storage PDF file
  Future<void> deleteResource(String resourceId, String? storagePath) async {
    if (firebaseDataSource.isAvailable) {
      await firebaseDataSource.deleteResourceDocument(resourceId, storagePath);
    }
    clearMemoryCache();
  }

  /// Replace existing resource PDF file with a new PDF
  Future<ResourceModel> replaceResourcePdf({
    required ResourceModel existingResource,
    required String fileName,
    required List<int> newPdfBytes,
    required void Function(double progress) onProgress,
  }) async {
    // 1. Delete old storage file if it exists
    if (existingResource.storagePath.isNotEmpty) {
      await firebaseDataSource.deleteStorageFile(existingResource.storagePath);
    }

    // 2. Build new storage path
    final newStoragePath = _storageRepository.buildStoragePath(
      year: existingResource.yearId,
      semester: existingResource.semesterId,
      subject: existingResource.subjectName,
      resourceType: existingResource.resourceType,
      fileName: fileName,
    );

    // 3. Upload new PDF bytes to Firebase Storage
    String newDownloadUrl = existingResource.storageUrl;
    if (firebaseDataSource.isAvailable) {
      newDownloadUrl = await _storageRepository.uploadPdf(
        storagePath: newStoragePath,
        bytes: newPdfBytes,
        onProgress: onProgress,
      );
    }

    // 4. Update resource document with new URL & file size
    final updatedResource = existingResource.copyWith(
      storagePath: newStoragePath,
      storageUrl: newDownloadUrl,
      fileSizeBytes: newPdfBytes.length,
      lastUpdated: DateTime.now(),
    );

    if (firebaseDataSource.isAvailable) {
      await firebaseDataSource.updateResourceDocument(updatedResource);
    }

    clearMemoryCache();
    return updatedResource;
  }

  // --- Academic Hierarchy CRUD ---

  Future<void> addSubject(SubjectModel subject) async {
    if (firebaseDataSource.isAvailable) {
      await firebaseDataSource.createSubjectDocument(subject);
    }
    clearMemoryCache();
  }

  Future<void> updateSubject(SubjectModel subject) async {
    if (firebaseDataSource.isAvailable) {
      await firebaseDataSource.updateSubjectDocument(subject);
    }
    clearMemoryCache();
  }

  Future<void> deleteSubject(String subjectId) async {
    if (firebaseDataSource.isAvailable) {
      await firebaseDataSource.deleteSubjectDocument(subjectId);
    }
    clearMemoryCache();
  }

  /// Fetch Course Overview for a Subject (Firestore Primary -> Offline Fallback)
  Future<CourseOverviewModel> getCourseOverview(String subjectId) async {
    if (_cachedCourseOverviews.containsKey(subjectId)) {
      return _cachedCourseOverviews[subjectId]!;
    }

    try {
      if (firebaseDataSource.isAvailable) {
        final remoteOverview = await _firestoreRepository.fetchCourseOverview(subjectId);
        if (remoteOverview != null) {
          _cachedCourseOverviews[subjectId] = remoteOverview;
          return remoteOverview;
        }
      }
    } catch (e) {
      debugPrint('Firestore fetch failed for courseOverview ($subjectId), using offline fallback: $e');
    }

    final fallback = TextbookMockData.getCourseOverview(subjectId);
    _cachedCourseOverviews[subjectId] = fallback;
    return fallback;
  }

  /// Fetch Textbook Chapters for a Subject (Firestore Primary -> Offline Fallback)
  Future<List<TextbookChapterModel>> getTextbookChapters(String subjectId) async {
    if (_cachedTextbookChapters.containsKey(subjectId)) {
      return _cachedTextbookChapters[subjectId]!;
    }

    try {
      if (firebaseDataSource.isAvailable) {
        final remoteChapters = await _firestoreRepository.fetchTextbookChapters(subjectId);
        if (remoteChapters.isNotEmpty) {
          _cachedTextbookChapters[subjectId] = remoteChapters;
          return remoteChapters;
        }
      }
    } catch (e) {
      debugPrint('Firestore fetch failed for textbookChapters ($subjectId), using offline fallback: $e');
    }

    final fallback = TextbookMockData.getTextbookChapters(subjectId);
    _cachedTextbookChapters[subjectId] = fallback;
    return fallback;
  }

  /// Save / Update Course Overview (Admin)
  Future<void> saveCourseOverview(CourseOverviewModel overview) async {
    if (firebaseDataSource.isAvailable) {
      await _firestoreRepository.saveCourseOverview(overview);
    }
    _cachedCourseOverviews[overview.subjectId] = overview;
    invalidateSearchIndex();
  }

  /// Delete Course Overview (Admin)
  Future<void> deleteCourseOverview(String subjectId) async {
    if (firebaseDataSource.isAvailable) {
      await _firestoreRepository.deleteCourseOverview(subjectId);
    }
    _cachedCourseOverviews.remove(subjectId);
    invalidateSearchIndex();
  }

  /// Save / Update Textbook Chapter (Admin)
  Future<String> saveTextbookChapter(String subjectId, TextbookChapterModel chapter) async {
    String assignedId = chapter.id;
    if (firebaseDataSource.isAvailable) {
      assignedId = await _firestoreRepository.saveTextbookChapter(subjectId, chapter);
    }
    
    final currentList = List<TextbookChapterModel>.from(_cachedTextbookChapters[subjectId] ?? TextbookMockData.getTextbookChapters(subjectId));
    final idx = currentList.indexWhere((c) => c.id == chapter.id);
    if (idx != -1) {
      currentList[idx] = chapter;
    } else {
      currentList.add(chapter);
    }
    _cachedTextbookChapters[subjectId] = currentList;
    invalidateSearchIndex();
    return assignedId;
  }

  /// Delete Textbook Chapter (Admin)
  Future<void> deleteTextbookChapter(String subjectId, String chapterId) async {
    if (firebaseDataSource.isAvailable) {
      await _firestoreRepository.deleteTextbookChapter(subjectId, chapterId);
    }
    
    final currentList = List<TextbookChapterModel>.from(_cachedTextbookChapters[subjectId] ?? TextbookMockData.getTextbookChapters(subjectId));
    currentList.removeWhere((c) => c.id == chapterId);
    _cachedTextbookChapters[subjectId] = currentList;
    invalidateSearchIndex();
  }

  /// Reorder Textbook Chapters (Admin)
  Future<void> reorderTextbookChapters(String subjectId, List<TextbookChapterModel> chapters) async {
    if (firebaseDataSource.isAvailable) {
      await _firestoreRepository.updateChapterOrders(subjectId, chapters);
    }
    _cachedTextbookChapters[subjectId] = chapters;
    invalidateSearchIndex();
  }

  /// Fetch Important Questions for a Subject
  Future<List<AcademicQuestionModel>> getImportantQuestions(String subjectId) async {
    return TextbookMockData.getImportantQuestions(subjectId);
  }

  /// Fetch Quick Revision Notes for a Subject
  Future<List<QuickRevisionModel>> getQuickRevisionNotes(String subjectId) async {
    return TextbookMockData.getQuickRevisionNotes(subjectId);
  }

  /// Fetch Lab Experiments for a Subject
  Future<List<LabExperimentModel>> getLabExperiments(String subjectId) async {
    return TextbookMockData.getLabExperiments(subjectId);
  }

  /// Fetch Academic Projects for a Subject
  Future<List<AcademicProjectModel>> getAcademicProjects(String subjectId) async {
    return TextbookMockData.getAcademicProjects(subjectId);
  }

  /// Fetch Additional Resources for a Subject
  Future<List<ExternalResourceModel>> getAdditionalResources(String subjectId) async {
    return TextbookMockData.getAdditionalResources(subjectId);
  }

  /// Invalidate Search Index
  void invalidateSearchIndex() {
    _searchEngine = SearchIndexEngine();
  }

  void clearMemoryCache() {
    _cachedYears = null;
    _cachedSemesters.clear();
    _cachedSubjects.clear();
    _cachedResources.clear();
    _cachedCourseOverviews.clear();
    _cachedTextbookChapters.clear();
    invalidateSearchIndex();
    _storageRepository.clearCache();
  }
}


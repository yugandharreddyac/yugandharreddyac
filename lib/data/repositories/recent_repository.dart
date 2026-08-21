import '../models/recent_resource_model.dart';
import '../datasources/local_storage_datasource.dart';

class RecentRepository {
  final LocalStorageDataSource localStorage;

  RecentRepository({required this.localStorage});

  List<RecentResourceModel> fetchRecentResources() {
    return localStorage.getRecentResources();
  }

  Future<void> recordResourceOpened({
    required String resourceId,
    required String resourceTitle,
    required String subjectName,
    required String resourceType,
    String? storageUrl,
    int lastReadPage = 1,
    int totalPages = 1,
  }) async {
    final double progress = totalPages > 0
        ? (lastReadPage / totalPages * 100).clamp(0.0, 100.0)
        : 0.0;

    final recent = RecentResourceModel(
      resourceId: resourceId,
      resourceTitle: resourceTitle,
      subjectName: subjectName,
      resourceType: resourceType,
      storageUrl: storageUrl,
      openedAt: DateTime.now(),
      lastReadPage: lastReadPage,
      totalPages: totalPages,
      readingProgressPercentage: progress,
    );

    await localStorage.saveRecentResource(recent);
    await localStorage.saveLastReadPage(resourceId, lastReadPage);
  }

  int getLastReadPage(String resourceId) {
    return localStorage.getLastReadPage(resourceId);
  }

  Future<void> saveLastReadPage(String resourceId, int pageNumber) async {
    await localStorage.saveLastReadPage(resourceId, pageNumber);
  }

  Future<void> clearHistory() async {
    await localStorage.clearRecentHistory();
  }
}

import '../models/resource_model.dart';
import '../datasources/local_storage_datasource.dart';

class PdfRepository {
  final LocalStorageDataSource localStorage;

  PdfRepository({required this.localStorage});

  /// Check if local cached file exists and returns path
  String? getLocalFilePath(ResourceModel resource) {
    final downloads = localStorage.getDownloadedResources();
    try {
      final found = downloads.firstWhere((r) => r.id == resource.id);
      return found.localFilePath;
    } catch (_) {
      return null;
    }
  }

  /// Calculates reading progress percentage
  double calculateProgressPercentage(int currentPage, int totalPages) {
    if (totalPages <= 0) return 0.0;
    return ((currentPage / totalPages) * 100.0).clamp(0.0, 100.0);
  }

  /// Saves the last read page for auto-resume
  Future<void> saveReadingProgress(String resourceId, int currentPage) async {
    await localStorage.saveLastReadPage(resourceId, currentPage);
  }

  /// Fetches saved last read page for auto-resume
  int getSavedReadingPage(String resourceId) {
    return localStorage.getLastReadPage(resourceId);
  }
}

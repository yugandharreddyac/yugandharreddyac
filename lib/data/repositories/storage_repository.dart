import '../datasources/firebase_datasource.dart';

class StorageRepository {
  final FirebaseDataSource firebaseDataSource;
  final Map<String, String> _urlCache = {};

  StorageRepository({required this.firebaseDataSource});

  /// Resolves Firebase Storage relative path to downloadable HTTPS URL
  /// Uses in-memory cache to prevent duplicate network calls.
  Future<String> resolveDownloadUrl(String storagePath) async {
    if (storagePath.isEmpty) return '';
    if (storagePath.startsWith('http://') ||
        storagePath.startsWith('https://')) {
      return storagePath;
    }

    if (_urlCache.containsKey(storagePath)) {
      return _urlCache[storagePath]!;
    }

    final resolvedUrl = await firebaseDataSource.getDownloadUrl(storagePath);
    _urlCache[storagePath] = resolvedUrl;
    return resolvedUrl;
  }

  /// Builds standardized Firebase Storage folder path for academic assets
  /// Pattern: StudyHub/{Year}/{Semester}/{Subject}/{ResourceType}/{filename}.pdf
  String buildStoragePath({
    required String year,
    required String semester,
    required String subject,
    required String resourceType,
    required String fileName,
  }) {
    final safeSubject = subject
        .replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_')
        .replaceAll(RegExp(r'_+'), '_');
    final safeResourceType = resourceType
        .replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_')
        .replaceAll(RegExp(r'_+'), '_');
    var cleanFileName =
        fileName.replaceAll(RegExp(r'\.pdf$', caseSensitive: false), '');
    cleanFileName = cleanFileName
        .replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_')
        .replaceAll(RegExp(r'_+'), '_');
    cleanFileName = '$cleanFileName.pdf';

    return 'StudyHub/$year/$semester/$safeSubject/$safeResourceType/$cleanFileName';
  }

  /// Upload PDF bytes to Firebase Storage
  Future<String> uploadPdf({
    required String storagePath,
    required List<int> bytes,
    required void Function(double progress) onProgress,
  }) async {
    return await firebaseDataSource.uploadPdfToStorage(
      storagePath: storagePath,
      bytes: bytes,
      onProgress: onProgress,
    );
  }

  void clearCache() {
    _urlCache.clear();
  }
}

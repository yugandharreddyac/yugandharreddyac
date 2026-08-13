import '../config/app_config.dart';

class R2StorageHelper {
  R2StorageHelper._();

  /// Standardized Cloudflare R2 Object Storage Key Path Generator
  /// Format: academic/year_{Y}/sem_{S}/{subject_code}/{unit_id}/{document_type}/{filename}.pdf
  static String buildR2StoragePath({
    required String yearId,
    required String semesterId,
    required String subjectCode,
    required String unitId,
    required String documentType,
    required String fileName,
  }) {
    final cleanYear = yearId.toLowerCase().replaceAll('year_', 'year_');
    final cleanSem = semesterId.toLowerCase().replaceAll('sem_', 'sem_');
    final cleanSubject = _sanitize(subjectCode);
    final cleanUnit = _sanitize(unitId);
    final cleanType = _sanitize(documentType);
    final cleanFile = fileName.toLowerCase().endsWith('.pdf') ? fileName : '$fileName.pdf';

    return 'academic/$cleanYear/$cleanSem/$cleanSubject/$cleanUnit/$cleanType/$cleanFile';
  }

  /// Build complete production HTTPS CDN URL for a given R2 storage key path
  static String buildCdnUrl(String storagePath, {String? customCdnBaseUrl}) {
    final baseUrl = customCdnBaseUrl ?? AppConfig.cdnBaseUrl;
    final cleanPath = storagePath.startsWith('/') ? storagePath.substring(1) : storagePath;
    final pathWithoutAcademic = cleanPath.startsWith('academic/') ? cleanPath.substring(9) : cleanPath;
    return '$baseUrl/$pathWithoutAcademic';
  }

  static String _sanitize(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9_]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .trim();
  }
}

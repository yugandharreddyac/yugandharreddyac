enum AppEnvironment { dev, staging, prod }

class AppConfig {
  static AppEnvironment environment = AppEnvironment.prod;

  /// Default production CDN base URL for Cloudflare R2 / CDN object delivery
  static const String defaultCdnBaseUrl = 'https://cdn.csse-study-hub.org/academic';

  /// Staging CDN base URL
  static const String stagingCdnBaseUrl = 'https://staging-cdn.csse-study-hub.org/academic';

  /// Development CDN base URL
  static const String devCdnBaseUrl = 'https://dev-cdn.csse-study-hub.org/academic';

  /// Get active base CDN storage URL based on environment setting
  static String get cdnBaseUrl {
    switch (environment) {
      case AppEnvironment.dev:
        return devCdnBaseUrl;
      case AppEnvironment.staging:
        return stagingCdnBaseUrl;
      case AppEnvironment.prod:
      default:
        return defaultCdnBaseUrl;
    }
  }

  /// Production Render AI backend proxy endpoint URL
  static const String renderAiBackendUrl = 'https://unidocs-ai-backend.onrender.com';

  /// Default production AI proxy endpoint URL (Firebase Cloud Function)
  static const String defaultAiBackendUrl = 'https://us-central1-csse-study-hub-prod.cloudfunctions.net/aiGenerate';

  /// Staging AI proxy endpoint URL
  static const String stagingAiBackendUrl = 'https://us-central1-csse-study-hub-staging.cloudfunctions.net/aiGenerate';

  /// Development / Local emulator AI proxy endpoint URL
  static const String devAiBackendUrl = 'http://10.0.2.2:5001/csse-study-hub-prod/us-central1/aiGenerate';

  static String? _customAiBackendUrl;

  /// Dynamically set custom backend URL (e.g. deployed Render URL)
  static void setCustomAiBackendUrl(String? url) {
    _customAiBackendUrl = url;
  }

  /// Get active AI backend proxy URL based on environment setting or custom override
  static String get aiBackendUrl {
    if (_customAiBackendUrl != null && _customAiBackendUrl!.isNotEmpty) {
      return _customAiBackendUrl!;
    }
    switch (environment) {
      case AppEnvironment.dev:
        return devAiBackendUrl;
      case AppEnvironment.staging:
        return stagingAiBackendUrl;
      case AppEnvironment.prod:
      default:
        return defaultAiBackendUrl;
    }
  }

  /// App display title
  static const String appTitle = 'CSSE Study Hub';

  // --- Archive.org S3 Configuration ---
  static const String archiveS3Endpoint = 's3.us.archive.org';
  static const String archiveS3AccessKey = 'GV6yXXOgB7K7rWEN';
  static const String archiveS3SecretKey = 'KXwOzdPrlXUltPqE';
  // This must be a globally unique identifier for your "bucket" (Item in Archive.org)
  static const String archiveS3BucketName = 'unidocs-csse-study-hub-v1';

  /// Application version
  static const String appVersion = '1.0.0+1';

  /// Enable remote network resource downloads
  static const bool enableRemoteDownloads = true;

  /// Enable offline local caching
  static const bool enableOfflineCache = true;
}

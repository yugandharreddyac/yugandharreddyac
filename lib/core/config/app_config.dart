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

  /// App display title
  static const String appTitle = 'CSSE Study Hub';

  /// Application version
  static const String appVersion = '1.0.0+1';

  /// Enable remote network resource downloads
  static const bool enableRemoteDownloads = true;

  /// Enable offline local caching
  static const bool enableOfflineCache = true;
}

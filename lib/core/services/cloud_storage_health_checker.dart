import 'package:dio/dio.dart';

class StorageHealthResult {
  final bool isReachable;
  final int statusCode;
  final String? contentType;
  final int contentLength;
  final String? errorMessage;

  const StorageHealthResult({
    required this.isReachable,
    required this.statusCode,
    this.contentType,
    this.contentLength = 0,
    this.errorMessage,
  });
}

class CloudStorageHealthChecker {
  final Dio _dio;

  CloudStorageHealthChecker({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(connectTimeout: const Duration(seconds: 5)));

  /// Perform diagnostic HEAD request to verify remote CDN HTTPS endpoint reachability
  Future<StorageHealthResult> checkEndpointHealth(String resourceUrl) async {
    if (resourceUrl.isEmpty || !resourceUrl.startsWith('https://')) {
      return const StorageHealthResult(
        isReachable: false,
        statusCode: 400,
        errorMessage: 'Invalid resource URL: Must use https:// scheme',
      );
    }

    try {
      final response = await _dio.head(resourceUrl);
      final contentType = response.headers.value('content-type');
      final contentLengthHeader = response.headers.value('content-length');
      final contentLength = contentLengthHeader != null ? int.tryParse(contentLengthHeader) ?? 0 : 0;

      return StorageHealthResult(
        isReachable: response.statusCode == 200,
        statusCode: response.statusCode ?? 0,
        contentType: contentType,
        contentLength: contentLength,
      );
    } on DioException catch (e) {
      return StorageHealthResult(
        isReachable: false,
        statusCode: e.response?.statusCode ?? 0,
        errorMessage: e.message ?? 'Network request failed',
      );
    } catch (e) {
      return StorageHealthResult(
        isReachable: false,
        statusCode: 0,
        errorMessage: e.toString(),
      );
    }
  }

  /// Run health diagnostic across all resources in base catalog
  Future<Map<String, StorageHealthResult>> checkCatalogHealth(List<String> urls) async {
    final results = <String, StorageHealthResult>{};
    for (final url in urls) {
      if (url.startsWith('https://')) {
        results[url] = await checkEndpointHealth(url);
      }
    }
    return results;
  }
}

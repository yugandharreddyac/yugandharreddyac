import 'package:flutter/foundation.dart';
import '../../data/models/resource_model.dart';
import '../../data/datasources/local_storage_datasource.dart';
import '../../data/repositories/download_repository.dart';

enum DownloadViewState {
  loading,
  success,
  error,
  offline,
  empty,
  downloading,
  downloaded,
  paused,
  cancelled,
  idle
}

class DownloadProvider extends ChangeNotifier {
  final LocalStorageDataSource localStorage;
  late final DownloadRepository _downloadRepository;

  List<ResourceModel> _downloadedResources = [];
  final Map<String, DownloadTask> _activeTaskMap = {};

  DownloadViewState _state = DownloadViewState.idle;
  String? _errorMessage;

  DownloadProvider(this.localStorage, {DownloadRepository? downloadRepository}) {
    _downloadRepository = downloadRepository ?? DownloadRepository(localStorage: localStorage);
    Future.microtask(() => loadDownloadedResources());
  }

  List<ResourceModel> get downloadedResources => _downloadedResources;
  Map<String, DownloadTask> get activeTaskMap => _activeTaskMap;

  // View States (Required by prompt)
  DownloadViewState get state => _state;
  bool get isLoading => _state == DownloadViewState.loading;
  bool get isSuccess => _state == DownloadViewState.success;
  bool get isError => _state == DownloadViewState.error;
  bool get isOffline => _state == DownloadViewState.offline;
  bool get isEmpty => _state == DownloadViewState.empty || _downloadedResources.isEmpty;
  bool get isDownloadingAny => _state == DownloadViewState.downloading || _activeTaskMap.isNotEmpty;
  String? get errorMessage => _errorMessage;

  // Task Helpers
  double getProgress(String resourceId) => _activeTaskMap[resourceId]?.progress ?? 0.0;
  double getSpeed(String resourceId) => _activeTaskMap[resourceId]?.bytesPerSecond ?? 0.0;
  Duration getEta(String resourceId) => _activeTaskMap[resourceId]?.estimatedRemaining ?? Duration.zero;
  bool isDownloaded(String resourceId) =>
      _downloadedResources.any((r) => r.id == resourceId);
  bool isDownloading(String resourceId) =>
      _activeTaskMap[resourceId]?.status == TaskStatus.downloading;
  bool isPaused(String resourceId) =>
      _activeTaskMap[resourceId]?.status == TaskStatus.paused;

  void loadDownloadedResources() {
    _setState(DownloadViewState.loading);
    try {
      _downloadedResources = localStorage.getDownloadedResources();
      if (_downloadedResources.isEmpty) {
        _setState(DownloadViewState.empty);
      } else {
        _setState(DownloadViewState.success);
      }
    } catch (e) {
      _setState(DownloadViewState.error, error: 'Failed to load downloaded resources: $e');
    }
  }

  bool isResourceDownloaded(String resourceId) {
    return _downloadedResources.any((r) => r.id == resourceId && r.localFilePath != null);
  }

  ResourceModel? getDownloadedResource(String resourceId) {
    try {
      return _downloadedResources.firstWhere((r) => r.id == resourceId);
    } catch (_) {
      return null;
    }
  }

  Future<String?> downloadPdf(ResourceModel resource, {Function(String)? onDownloadSuccess}) async {
    _setState(DownloadViewState.downloading);

    final path = await _downloadRepository.downloadPdf(
      resource,
      onProgress: (task) {
        _activeTaskMap[resource.id] = task;
        if (task.status == TaskStatus.paused) {
          _setState(DownloadViewState.paused);
        } else if (task.status == TaskStatus.downloading) {
          _setState(DownloadViewState.downloading);
        }
        notifyListeners();
      },
      onSuccess: (updatedResource, filePath) {
        _downloadedResources.removeWhere((r) => r.id == resource.id);
        _downloadedResources.insert(0, updatedResource);
        _activeTaskMap.remove(resource.id);
        if (onDownloadSuccess != null) onDownloadSuccess(filePath);
        _setState(DownloadViewState.downloaded);
      },
      onError: (err) {
        _setState(DownloadViewState.error, error: err);
      },
    );

    return path;
  }

  void pauseDownload(String resourceId) {
    _downloadRepository.pauseDownload(resourceId);
    _setState(DownloadViewState.paused);
  }

  void resumeDownload(ResourceModel resource) {
    downloadPdf(resource);
  }

  void cancelDownload(String resourceId) {
    _downloadRepository.cancelDownload(resourceId);
    _activeTaskMap.remove(resourceId);
    _setState(DownloadViewState.cancelled);
  }

  Future<void> deleteDownload(String resourceId) async {
    try {
      await _downloadRepository.deleteDownloadedResource(resourceId);
      _downloadedResources.removeWhere((r) => r.id == resourceId);
      if (_downloadedResources.isEmpty) {
        _setState(DownloadViewState.empty);
      } else {
        _setState(DownloadViewState.success);
      }
    } catch (e) {
      _setState(DownloadViewState.error, error: 'Failed to delete download: $e');
    }
  }

  int get totalDownloadedSizeBytes {
    int sum = 0;
    for (var r in _downloadedResources) {
      sum += r.fileSizeBytes;
    }
    return sum;
  }

  void _setState(DownloadViewState state, {String? error}) {
    _state = state;
    _errorMessage = error;
    notifyListeners();
  }
}

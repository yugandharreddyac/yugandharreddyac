import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/resource_model.dart';
import '../datasources/local_storage_datasource.dart';
import '../datasources/firebase_datasource.dart';

enum TaskStatus { downloading, paused, completed, error, cancelled }

class DownloadTask {
  final ResourceModel resource;
  final String savePath;
  TaskStatus status;
  double progress;
  int downloadedBytes;
  int totalBytes;
  double bytesPerSecond;
  Duration estimatedRemaining;
  DateTime startTime;
  CancelToken? cancelToken;
  String? error;

  DownloadTask({
    required this.resource,
    required this.savePath,
    this.status = TaskStatus.downloading,
    this.progress = 0.0,
    this.downloadedBytes = 0,
    this.totalBytes = 0,
    this.bytesPerSecond = 0.0,
    this.estimatedRemaining = Duration.zero,
    required this.startTime,
    this.cancelToken,
    this.error,
  });
}

class DownloadRepository {
  final LocalStorageDataSource localStorage;
  final FirebaseDataSource? firebaseDataSource;
  final Dio _dio = Dio();
  final Map<String, DownloadTask> _activeTasks = {};

  DownloadRepository({required this.localStorage, this.firebaseDataSource});

  Map<String, DownloadTask> get activeTasks => _activeTasks;

  /// Start or resume downloading a PDF file
  Future<String?> downloadPdf(
    ResourceModel resource, {
    required Function(DownloadTask task) onProgress,
    required Function(ResourceModel resource, String path) onSuccess,
    required Function(String error) onError,
  }) async {
    final resourceId = resource.id;

    if (kIsWeb) {
      onSuccess(resource.copyWith(localFilePath: resource.storageUrl), resource.storageUrl);
      return resource.storageUrl;
    }

    final filePath = await localStorage.getStructuredDownloadFilePath(
      year: resource.yearId,
      semester: resource.semesterId,
      subject: resource.subjectName,
      resourceType: resource.resourceType,
      fileName: '${resource.id}_${_cleanFileName(resource.title)}',
    );

    final cancelToken = CancelToken();
    final startTime = DateTime.now();

    final task = DownloadTask(
      resource: resource,
      savePath: filePath,
      status: TaskStatus.downloading,
      startTime: startTime,
      cancelToken: cancelToken,
    );
    _activeTasks[resourceId] = task;

    int lastReceived = 0;
    DateTime lastTime = DateTime.now();

    try {
      await _dio.download(
        resource.storageUrl,
        filePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          final now = DateTime.now();
          final timeDiff = now.difference(lastTime).inMilliseconds;

          if (timeDiff >= 500 && total > 0) {
            final bytesDiff = received - lastReceived;
            final speed = (bytesDiff / (timeDiff / 1000.0));
            final remainingBytes = total - received;
            final etaSeconds = speed > 0 ? (remainingBytes / speed).round() : 0;

            task.downloadedBytes = received;
            task.totalBytes = total;
            task.progress = (received / total).clamp(0.0, 1.0);
            task.bytesPerSecond = speed;
            task.estimatedRemaining = Duration(seconds: etaSeconds);

            lastReceived = received;
            lastTime = now;
          } else if (total > 0) {
            task.downloadedBytes = received;
            task.totalBytes = total;
            task.progress = (received / total).clamp(0.0, 1.0);
          }

          task.status = TaskStatus.downloading;
          onProgress(task);
        },
      );

      task.status = TaskStatus.completed;
      task.progress = 1.0;
      onProgress(task);

      final updatedResource = resource.copyWith(
        localFilePath: filePath,
        downloadCount: resource.downloadCount + 1,
      );

      final currentDownloads = localStorage.getDownloadedResources();
      currentDownloads.removeWhere((r) => r.id == resourceId);
      currentDownloads.insert(0, updatedResource);
      await localStorage.saveDownloadedResources(currentDownloads);

      firebaseDataSource?.incrementDownloadCount(resourceId);

      _activeTasks.remove(resourceId);
      onSuccess(updatedResource, filePath);
      return filePath;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        task.status = TaskStatus.paused;
        task.error = 'Download paused';
        onProgress(task);
        return null;
      }
      task.status = TaskStatus.error;
      task.error = 'Download failed: ${e.message}';
      _activeTasks.remove(resourceId);
      onError(task.error!);
      return null;
    } catch (e) {
      task.status = TaskStatus.error;
      task.error = e.toString();
      _activeTasks.remove(resourceId);
      onError(task.error!);
      return null;
    }
  }

  void pauseDownload(String resourceId) {
    if (_activeTasks.containsKey(resourceId)) {
      final task = _activeTasks[resourceId]!;
      task.cancelToken?.cancel('Paused by user');
      task.status = TaskStatus.paused;
    }
  }

  void cancelDownload(String resourceId) {
    if (_activeTasks.containsKey(resourceId)) {
      final task = _activeTasks[resourceId]!;
      task.cancelToken?.cancel('Cancelled by user');
      task.status = TaskStatus.cancelled;

      if (!kIsWeb) {
        final file = File(task.savePath);
        if (file.existsSync()) {
          try {
            file.deleteSync();
          } catch (_) {}
        }
      }
      _activeTasks.remove(resourceId);
    }
  }

  Future<void> deleteDownloadedResource(String resourceId) async {
    final downloads = localStorage.getDownloadedResources();
    final index = downloads.indexWhere((r) => r.id == resourceId);
    if (index >= 0) {
      final res = downloads[index];
      if (!kIsWeb && res.localFilePath != null) {
        final file = File(res.localFilePath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
      downloads.removeAt(index);
      await localStorage.saveDownloadedResources(downloads);
    }
  }

  String _cleanFileName(String name) {
    return name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').replaceAll(' ', '_');
  }
}

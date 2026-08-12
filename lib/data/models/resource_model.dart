class ResourceModel {
  final String id;
  final String title;
  final String description;
  final String subjectId;
  final String subjectName;
  final String yearId;
  final String semesterId;
  final String resourceType;
  final String storagePath;
  final String storageUrl;
  final String? thumbnailUrl;
  final int fileSizeBytes;
  final int pageCount;
  final int downloadCount;
  final List<String> tags;
  final DateTime lastUpdated;
  final bool isFeatured;
  final bool isActive;
  final String? localFilePath;
  final String? videoUrl;
  final String? chapterId;
  final int? chapterNumber;
  final String? sectionId;
  final String? sectionNumber;
  final String? sectionType; // e.g., 'Textbook', 'Important Questions', 'Previous Papers', 'Quick Revision', 'Labs', 'Assignments', 'Projects', 'Additional Resources'

  const ResourceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.subjectId,
    required this.subjectName,
    required this.yearId,
    required this.semesterId,
    required this.resourceType,
    this.storagePath = '',
    required this.storageUrl,
    this.thumbnailUrl,
    required this.fileSizeBytes,
    this.pageCount = 0,
    this.downloadCount = 0,
    this.tags = const [],
    required this.lastUpdated,
    this.isFeatured = false,
    this.isActive = true,
    this.localFilePath,
    this.videoUrl,
    this.chapterId,
    this.chapterNumber,
    this.sectionId,
    this.sectionNumber,
    this.sectionType,
  });

  // Backward-compatibility getters
  String get downloadUrl => storageUrl;
  int get fileSize => fileSizeBytes;
  int get downloads => downloadCount;

  ResourceModel copyWith({
    String? id,
    String? title,
    String? description,
    String? subjectId,
    String? subjectName,
    String? yearId,
    String? semesterId,
    String? resourceType,
    String? storagePath,
    String? storageUrl,
    String? thumbnailUrl,
    int? fileSizeBytes,
    int? pageCount,
    int? downloadCount,
    List<String>? tags,
    DateTime? lastUpdated,
    bool? isFeatured,
    bool? isActive,
    String? localFilePath,
    String? videoUrl,
  }) {
    return ResourceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      yearId: yearId ?? this.yearId,
      semesterId: semesterId ?? this.semesterId,
      resourceType: resourceType ?? this.resourceType,
      storagePath: storagePath ?? this.storagePath,
      storageUrl: storageUrl ?? this.storageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      pageCount: pageCount ?? this.pageCount,
      downloadCount: downloadCount ?? this.downloadCount,
      tags: tags ?? this.tags,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isFeatured: isFeatured ?? this.isFeatured,
      isActive: isActive ?? this.isActive,
      localFilePath: localFilePath ?? this.localFilePath,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'yearId': yearId,
      'semesterId': semesterId,
      'resourceType': resourceType,
      'storagePath': storagePath,
      'downloadUrl': storageUrl,
      'storageUrl': storageUrl,
      'thumbnailUrl': thumbnailUrl,
      'fileSize': fileSizeBytes,
      'fileSizeBytes': fileSizeBytes,
      'pageCount': pageCount,
      'downloads': downloadCount,
      'downloadCount': downloadCount,
      'tags': tags,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isFeatured': isFeatured,
      'isActive': isActive,
      'chapterId': chapterId,
      'chapterNumber': chapterNumber,
      'sectionId': sectionId,
      'sectionNumber': sectionNumber,
      'sectionType': sectionType,
    };
  }

  factory ResourceModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ResourceModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      subjectId: data['subjectId'] ?? '',
      subjectName: data['subjectName'] ?? data['subject'] ?? '',
      yearId: data['yearId'] ?? data['year'] ?? '',
      semesterId: data['semesterId'] ?? data['semester'] ?? '',
      resourceType: data['resourceType'] ?? '',
      storagePath: data['storagePath'] ?? '',
      storageUrl: data['downloadUrl'] ?? data['storageUrl'] ?? data['firebaseStorageURL'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? data['thumbnailURL'],
      fileSizeBytes: data['fileSize'] as int? ?? data['fileSizeBytes'] as int? ?? 0,
      pageCount: data['pageCount'] as int? ?? 0,
      downloadCount: data['downloads'] as int? ?? data['downloadCount'] as int? ?? data['downloadsCount'] as int? ?? 0,
      tags: List<String>.from(data['tags'] ?? []),
      lastUpdated: data['lastUpdated'] != null
          ? DateTime.tryParse(data['lastUpdated'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isFeatured: data['isFeatured'] ?? false,
      isActive: data['isActive'] ?? true,
      chapterId: data['chapterId'],
      chapterNumber: data['chapterNumber'] as int?,
      sectionId: data['sectionId'],
      sectionNumber: data['sectionNumber'],
      sectionType: data['sectionType'],
    );
  }
}

import 'resource_model.dart';

class RecentResourceModel {
  final String resourceId;
  final String resourceTitle;
  final String subjectName;
  final String resourceType;
  final String? storageUrl;
  final DateTime openedAt;
  final int lastReadPage;
  final int totalPages;
  final double readingProgressPercentage;

  const RecentResourceModel({
    required this.resourceId,
    required this.resourceTitle,
    required this.subjectName,
    required this.resourceType,
    this.storageUrl,
    required this.openedAt,
    this.lastReadPage = 1,
    this.totalPages = 1,
    this.readingProgressPercentage = 0.0,
  });

  RecentResourceModel copyWith({
    String? resourceId,
    String? resourceTitle,
    String? subjectName,
    String? resourceType,
    String? storageUrl,
    DateTime? openedAt,
    int? lastReadPage,
    int? totalPages,
    double? readingProgressPercentage,
  }) {
    return RecentResourceModel(
      resourceId: resourceId ?? this.resourceId,
      resourceTitle: resourceTitle ?? this.resourceTitle,
      subjectName: subjectName ?? this.subjectName,
      resourceType: resourceType ?? this.resourceType,
      storageUrl: storageUrl ?? this.storageUrl,
      openedAt: openedAt ?? this.openedAt,
      lastReadPage: lastReadPage ?? this.lastReadPage,
      totalPages: totalPages ?? this.totalPages,
      readingProgressPercentage:
          readingProgressPercentage ?? this.readingProgressPercentage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resourceId': resourceId,
      'resourceTitle': resourceTitle,
      'subjectName': subjectName,
      'resourceType': resourceType,
      'storageUrl': storageUrl,
      'openedAt': openedAt.toIso8601String(),
      'lastReadPage': lastReadPage,
      'totalPages': totalPages,
      'readingProgressPercentage': readingProgressPercentage,
    };
  }

  factory RecentResourceModel.fromJson(Map<String, dynamic> json) {
    return RecentResourceModel(
      resourceId: json['resourceId'] ?? '',
      resourceTitle: json['resourceTitle'] ?? '',
      subjectName: json['subjectName'] ?? '',
      resourceType: json['resourceType'] ?? '',
      storageUrl: json['storageUrl'],
      openedAt: json['openedAt'] != null
          ? DateTime.tryParse(json['openedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      lastReadPage: json['lastReadPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      readingProgressPercentage:
          (json['readingProgressPercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ResourceModel toResourceModel() {
    return ResourceModel(
      id: resourceId,
      title: resourceTitle,
      description: resourceTitle,
      subjectId: '',
      subjectName: subjectName,
      yearId: 'year_1',
      semesterId: 'sem_1',
      resourceType: resourceType,
      storagePath: '',
      storageUrl: storageUrl ?? '',
      fileSizeBytes: 0,
      lastUpdated: openedAt,
    );
  }
}

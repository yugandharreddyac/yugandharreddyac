import 'resource_model.dart';

class BookmarkModel {
  final String id;
  final String resourceId;
  final String resourceTitle;
  final String resourceType;
  final String subjectName;
  final int? pageNumber;
  final String? note;
  final DateTime createdAt;

  const BookmarkModel({
    required this.id,
    required this.resourceId,
    required this.resourceTitle,
    required this.resourceType,
    required this.subjectName,
    this.pageNumber,
    this.note,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resourceId': resourceId,
      'resourceTitle': resourceTitle,
      'resourceType': resourceType,
      'subjectName': subjectName,
      'pageNumber': pageNumber,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      id: json['id'] ?? '',
      resourceId: json['resourceId'] ?? '',
      resourceTitle: json['resourceTitle'] ?? '',
      resourceType: json['resourceType'] ?? '',
      subjectName: json['subjectName'] ?? '',
      pageNumber: json['pageNumber'],
      note: json['note'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  ResourceModel toResourceModel() {
    return ResourceModel(
      id: resourceId,
      title: resourceTitle,
      description: 'Bookmarked Resource',
      resourceType: resourceType,
      subjectId: 'subject_default',
      subjectName: subjectName,
      yearId: 'year_1',
      semesterId: 'sem_1',
      storageUrl: 'https://raw.githubusercontent.com/flutter/pdf_viewer/main/test.pdf',
      fileSizeBytes: 2048576,
      lastUpdated: createdAt,
    );
  }
}


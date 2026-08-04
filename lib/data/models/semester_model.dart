class SemesterModel {
  final String id;
  final String yearId;
  final String title;
  final int semesterNumber;
  final String description;
  final int subjectCount;

  const SemesterModel({
    required this.id,
    required this.yearId,
    required this.title,
    required this.semesterNumber,
    required this.description,
    this.subjectCount = 5,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'yearId': yearId,
      'title': title,
      'semesterNumber': semesterNumber,
      'description': description,
      'subjectCount': subjectCount,
    };
  }

  factory SemesterModel.fromFirestore(Map<String, dynamic> data, String id) {
    return SemesterModel(
      id: id,
      yearId: data['yearId'] ?? '',
      title: data['title'] ?? '',
      semesterNumber: data['semesterNumber'] ?? 1,
      description: data['description'] ?? '',
      subjectCount: data['subjectCount'] ?? 0,
    );
  }
}

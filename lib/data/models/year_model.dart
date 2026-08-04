class YearModel {
  final String id;
  final String title;
  final int yearNumber;
  final String description;
  final int totalSemesters;
  final int totalSubjects;

  const YearModel({
    required this.id,
    required this.title,
    required this.yearNumber,
    required this.description,
    this.totalSemesters = 2,
    this.totalSubjects = 10,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'yearNumber': yearNumber,
      'description': description,
      'totalSemesters': totalSemesters,
      'totalSubjects': totalSubjects,
    };
  }

  factory YearModel.fromFirestore(Map<String, dynamic> data, String id) {
    return YearModel(
      id: id,
      title: data['title'] ?? '',
      yearNumber: data['yearNumber'] ?? 1,
      description: data['description'] ?? '',
      totalSemesters: data['totalSemesters'] ?? 2,
      totalSubjects: data['totalSubjects'] ?? 0,
    );
  }
}

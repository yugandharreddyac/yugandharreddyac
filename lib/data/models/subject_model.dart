class SubjectModel {
  final String id;
  final String name;
  final String yearId;
  final String semesterId;
  final String description;
  final int? credits;
  final String? subjectCode;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String iconName;

  const SubjectModel({
    required this.id,
    required this.name,
    required this.yearId,
    required this.semesterId,
    required this.description,
    this.credits = 3,
    this.subjectCode,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.iconName = 'code',
  });

  // Backward-compatibility getters for UI widgets
  String get code => subjectCode ?? id.toUpperCase();
  int get creditHours => credits ?? 3;
  int get resourceCount => 5;

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'yearId': yearId,
      'semesterId': semesterId,
      'description': description,
      'credits': credits,
      'subjectCode': subjectCode,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'iconName': iconName,
    };
  }

  factory SubjectModel.fromFirestore(Map<String, dynamic> data, String id) {
    return SubjectModel(
      id: id,
      name: data['name'] ?? '',
      yearId: data['yearId'] ?? '',
      semesterId: data['semesterId'] ?? '',
      description: data['description'] ?? '',
      credits: data['credits'] as int? ?? data['creditHours'] as int? ?? 3,
      subjectCode: data['subjectCode'] ?? data['code'],
      isActive: data['isActive'] ?? true,
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.tryParse(data['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      iconName: data['iconName'] ?? 'code',
    );
  }
}

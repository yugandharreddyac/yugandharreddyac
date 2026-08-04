class UniByteModel {
  final String id;
  final String learn;
  final String practice;
  final String interview;
  final String shortcut;
  final String technology;
  final int estimatedMinutes;
  final bool isFeatured;

  const UniByteModel({
    required this.id,
    required this.learn,
    required this.practice,
    required this.interview,
    required this.shortcut,
    required this.technology,
    this.estimatedMinutes = 5,
    this.isFeatured = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'learn': learn,
      'practice': practice,
      'interview': interview,
      'shortcut': shortcut,
      'technology': technology,
      'estimatedMinutes': estimatedMinutes,
      'isFeatured': isFeatured,
    };
  }

  factory UniByteModel.fromJson(Map<String, dynamic> json) {
    return UniByteModel(
      id: json['id'] ?? '',
      learn: json['learn'] ?? '',
      practice: json['practice'] ?? '',
      interview: json['interview'] ?? '',
      shortcut: json['shortcut'] ?? '',
      technology: json['technology'] ?? '',
      estimatedMinutes: json['estimatedMinutes'] ?? 5,
      isFeatured: json['isFeatured'] ?? true,
    );
  }
}

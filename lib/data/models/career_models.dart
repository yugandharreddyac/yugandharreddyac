// Career Models

enum SkillEvidenceLevel {
  notStarted,
  learning,
  practiced,
  demonstrated,
}

enum ProjectState {
  notStarted,
  planning,
  building,
  testing,
  documented,
  completed,
}

class SkillEvidenceModel {
  final String skillName;
  final String category;
  final List<String> relatedTopicIds;
  final SkillEvidenceLevel level;

  const SkillEvidenceModel({
    required this.skillName,
    required this.category,
    required this.relatedTopicIds,
    required this.level,
  });

  bool get isStarted => level != SkillEvidenceLevel.notStarted;
}

class ProjectPortfolioModel {
  final String topicId;
  final String projectName;
  final ProjectState state;
  final List<String> demonstratedSkills;

  const ProjectPortfolioModel({
    required this.topicId,
    required this.projectName,
    required this.state,
    required this.demonstratedSkills,
  });
}

class ResumeReadinessModel {
  final bool technicalSkillsIdentified;
  final bool oneCompletedProject;
  final bool projectDescriptionsPrepared;
  final bool evidenceAvailable;
  final bool educationPrepared;
  final bool careerObjectivePrepared;
  final bool resumeReviewed;

  const ResumeReadinessModel({
    this.technicalSkillsIdentified = false,
    this.oneCompletedProject = false,
    this.projectDescriptionsPrepared = false,
    this.evidenceAvailable = false,
    this.educationPrepared = false,
    this.careerObjectivePrepared = false,
    this.resumeReviewed = false,
  });

  ResumeReadinessModel copyWith({
    bool? technicalSkillsIdentified,
    bool? oneCompletedProject,
    bool? projectDescriptionsPrepared,
    bool? evidenceAvailable,
    bool? educationPrepared,
    bool? careerObjectivePrepared,
    bool? resumeReviewed,
  }) {
    return ResumeReadinessModel(
      technicalSkillsIdentified: technicalSkillsIdentified ?? this.technicalSkillsIdentified,
      oneCompletedProject: oneCompletedProject ?? this.oneCompletedProject,
      projectDescriptionsPrepared: projectDescriptionsPrepared ?? this.projectDescriptionsPrepared,
      evidenceAvailable: evidenceAvailable ?? this.evidenceAvailable,
      educationPrepared: educationPrepared ?? this.educationPrepared,
      careerObjectivePrepared: careerObjectivePrepared ?? this.careerObjectivePrepared,
      resumeReviewed: resumeReviewed ?? this.resumeReviewed,
    );
  }

  Map<String, dynamic> toJson() => {
        'technicalSkillsIdentified': technicalSkillsIdentified,
        'oneCompletedProject': oneCompletedProject,
        'projectDescriptionsPrepared': projectDescriptionsPrepared,
        'evidenceAvailable': evidenceAvailable,
        'educationPrepared': educationPrepared,
        'careerObjectivePrepared': careerObjectivePrepared,
        'resumeReviewed': resumeReviewed,
      };

  factory ResumeReadinessModel.fromJson(Map<String, dynamic> json) {
    return ResumeReadinessModel(
      technicalSkillsIdentified: json['technicalSkillsIdentified'] ?? false,
      oneCompletedProject: json['oneCompletedProject'] ?? false,
      projectDescriptionsPrepared: json['projectDescriptionsPrepared'] ?? false,
      evidenceAvailable: json['evidenceAvailable'] ?? false,
      educationPrepared: json['educationPrepared'] ?? false,
      careerObjectivePrepared: json['careerObjectivePrepared'] ?? false,
      resumeReviewed: json['resumeReviewed'] ?? false,
    );
  }

  int get completedCount {
    int count = 0;
    if (technicalSkillsIdentified) count++;
    if (oneCompletedProject) count++;
    if (projectDescriptionsPrepared) count++;
    if (evidenceAvailable) count++;
    if (educationPrepared) count++;
    if (careerObjectivePrepared) count++;
    if (resumeReviewed) count++;
    return count;
  }

  int get totalItems => 7;
  double get percentage => (completedCount / totalItems) * 100.0;
}

class CareerDimensionProgress {
  final String dimensionName;
  final int completed;
  final int total;

  const CareerDimensionProgress({
    required this.dimensionName,
    required this.completed,
    required this.total,
  });

  double get percentage => total == 0 ? 0 : (completed / total) * 100.0;
}

class CareerGapModel {
  final String title;
  final String description;
  final String actionRoute;
  final String actionLabel;
  final dynamic actionArguments;
  final int priority;

  const CareerGapModel({
    required this.title,
    required this.description,
    required this.actionRoute,
    required this.actionLabel,
    this.actionArguments,
    required this.priority,
  });
}

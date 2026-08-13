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
  final bool certificationsAdded;
  final bool achievementsAdded;

  // LinkedIn Checklist Properties
  final bool linkedInProfileCreated;
  final bool linkedInPhotoAdded;
  final bool linkedInHeadlineAdded;
  final bool linkedInAboutCompleted;
  final bool linkedInExperienceAdded;
  final bool linkedInSkillsAdded;
  final bool linkedInProjectsAdded;
  final bool linkedInCertificationsAdded;
  final bool linkedInUrlSaved;
  final bool customUrlSaved;
  final bool networkingBasicsCompleted;

  const ResumeReadinessModel({
    this.technicalSkillsIdentified = false,
    this.oneCompletedProject = false,
    this.projectDescriptionsPrepared = false,
    this.evidenceAvailable = false,
    this.educationPrepared = false,
    this.careerObjectivePrepared = false,
    this.resumeReviewed = false,
    this.certificationsAdded = false,
    this.achievementsAdded = false,
    this.linkedInProfileCreated = false,
    this.linkedInPhotoAdded = false,
    this.linkedInHeadlineAdded = false,
    this.linkedInAboutCompleted = false,
    this.linkedInExperienceAdded = false,
    this.linkedInSkillsAdded = false,
    this.linkedInProjectsAdded = false,
    this.linkedInCertificationsAdded = false,
    this.linkedInUrlSaved = false,
    this.customUrlSaved = false,
    this.networkingBasicsCompleted = false,
  });

  ResumeReadinessModel copyWith({
    bool? technicalSkillsIdentified,
    bool? oneCompletedProject,
    bool? projectDescriptionsPrepared,
    bool? evidenceAvailable,
    bool? educationPrepared,
    bool? careerObjectivePrepared,
    bool? resumeReviewed,
    bool? certificationsAdded,
    bool? achievementsAdded,
    bool? linkedInProfileCreated,
    bool? linkedInPhotoAdded,
    bool? linkedInHeadlineAdded,
    bool? linkedInAboutCompleted,
    bool? linkedInExperienceAdded,
    bool? linkedInSkillsAdded,
    bool? linkedInProjectsAdded,
    bool? linkedInCertificationsAdded,
    bool? linkedInUrlSaved,
    bool? customUrlSaved,
    bool? networkingBasicsCompleted,
  }) {
    return ResumeReadinessModel(
      technicalSkillsIdentified: technicalSkillsIdentified ?? this.technicalSkillsIdentified,
      oneCompletedProject: oneCompletedProject ?? this.oneCompletedProject,
      projectDescriptionsPrepared: projectDescriptionsPrepared ?? this.projectDescriptionsPrepared,
      evidenceAvailable: evidenceAvailable ?? this.evidenceAvailable,
      educationPrepared: educationPrepared ?? this.educationPrepared,
      careerObjectivePrepared: careerObjectivePrepared ?? this.careerObjectivePrepared,
      resumeReviewed: resumeReviewed ?? this.resumeReviewed,
      certificationsAdded: certificationsAdded ?? this.certificationsAdded,
      achievementsAdded: achievementsAdded ?? this.achievementsAdded,
      linkedInProfileCreated: linkedInProfileCreated ?? this.linkedInProfileCreated,
      linkedInPhotoAdded: linkedInPhotoAdded ?? this.linkedInPhotoAdded,
      linkedInHeadlineAdded: linkedInHeadlineAdded ?? this.linkedInHeadlineAdded,
      linkedInAboutCompleted: linkedInAboutCompleted ?? this.linkedInAboutCompleted,
      linkedInExperienceAdded: linkedInExperienceAdded ?? this.linkedInExperienceAdded,
      linkedInSkillsAdded: linkedInSkillsAdded ?? this.linkedInSkillsAdded,
      linkedInProjectsAdded: linkedInProjectsAdded ?? this.linkedInProjectsAdded,
      linkedInCertificationsAdded: linkedInCertificationsAdded ?? this.linkedInCertificationsAdded,
      linkedInUrlSaved: linkedInUrlSaved ?? this.linkedInUrlSaved,
      customUrlSaved: customUrlSaved ?? this.customUrlSaved,
      networkingBasicsCompleted: networkingBasicsCompleted ?? this.networkingBasicsCompleted,
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
        'certificationsAdded': certificationsAdded,
        'achievementsAdded': achievementsAdded,
        'linkedInProfileCreated': linkedInProfileCreated,
        'linkedInPhotoAdded': linkedInPhotoAdded,
        'linkedInHeadlineAdded': linkedInHeadlineAdded,
        'linkedInAboutCompleted': linkedInAboutCompleted,
        'linkedInExperienceAdded': linkedInExperienceAdded,
        'linkedInSkillsAdded': linkedInSkillsAdded,
        'linkedInProjectsAdded': linkedInProjectsAdded,
        'linkedInCertificationsAdded': linkedInCertificationsAdded,
        'linkedInUrlSaved': linkedInUrlSaved,
        'customUrlSaved': customUrlSaved,
        'networkingBasicsCompleted': networkingBasicsCompleted,
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
      certificationsAdded: json['certificationsAdded'] ?? false,
      achievementsAdded: json['achievementsAdded'] ?? false,
      linkedInProfileCreated: json['linkedInProfileCreated'] ?? false,
      linkedInPhotoAdded: json['linkedInPhotoAdded'] ?? false,
      linkedInHeadlineAdded: json['linkedInHeadlineAdded'] ?? false,
      linkedInAboutCompleted: json['linkedInAboutCompleted'] ?? false,
      linkedInExperienceAdded: json['linkedInExperienceAdded'] ?? false,
      linkedInSkillsAdded: json['linkedInSkillsAdded'] ?? false,
      linkedInProjectsAdded: json['linkedInProjectsAdded'] ?? false,
      linkedInCertificationsAdded: json['linkedInCertificationsAdded'] ?? false,
      linkedInUrlSaved: json['linkedInUrlSaved'] ?? false,
      customUrlSaved: json['customUrlSaved'] ?? false,
      networkingBasicsCompleted: json['networkingBasicsCompleted'] ?? false,
    );
  }

  int get resumeCompletedCount {
    int count = 0;
    if (technicalSkillsIdentified) count++;
    if (oneCompletedProject) count++;
    if (projectDescriptionsPrepared) count++;
    if (evidenceAvailable) count++;
    if (educationPrepared) count++;
    if (careerObjectivePrepared) count++;
    if (resumeReviewed) count++;
    if (certificationsAdded) count++;
    if (achievementsAdded) count++;
    return count;
  }

  int get resumeTotalItems => 9;

  int get linkedInCompletedCount {
    int count = 0;
    if (linkedInProfileCreated) count++;
    if (linkedInPhotoAdded) count++;
    if (linkedInHeadlineAdded) count++;
    if (linkedInAboutCompleted) count++;
    if (linkedInExperienceAdded) count++;
    if (linkedInSkillsAdded) count++;
    if (linkedInProjectsAdded) count++;
    if (linkedInCertificationsAdded) count++;
    if (linkedInUrlSaved) count++;
    if (customUrlSaved) count++;
    if (networkingBasicsCompleted) count++;
    return count;
  }

  int get linkedInTotalItems => 11;

  double get overallProgress {
    final total = resumeTotalItems + linkedInTotalItems;
    final done = resumeCompletedCount + linkedInCompletedCount;
    if (total == 0) return 0.0;
    return done / total;
  }

  bool get isReady => resumeReviewed && linkedInUrlSaved;
  int get completedCount => resumeCompletedCount + linkedInCompletedCount;
  int get totalItems => resumeTotalItems + linkedInTotalItems;
  double get percentage => totalItems == 0 ? 0.0 : (completedCount / totalItems) * 100.0;
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

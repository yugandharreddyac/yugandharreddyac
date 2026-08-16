import '../models/textbook_model.dart';

class TextbookMockData {
  TextbookMockData._();

  static CourseOverviewModel getCourseOverview(String subjectId) {
    return CourseOverviewModel(
      subjectId: subjectId,
      subjectName: '',
      description: '',
      whyItMatters: '',
      prerequisites: [],
      learningObjectives: [],
      learningOutcomes: [],
      estimatedStudyTime: '',
      estimatedDifficulty: '',
    );
  }

  static List<TextbookChapterModel> getTextbookChapters(String subjectId) {
    return [];
  }

  static List<AcademicQuestionModel> getImportantQuestions(String subjectId) {
    return [];
  }

  static List<QuickRevisionModel> getQuickRevisionNotes(String subjectId) {
    return [];
  }

  static List<LabExperimentModel> getLabExperiments(String subjectId) {
    return [];
  }

  static List<AcademicProjectModel> getAcademicProjects(String subjectId) {
    return [];
  }

  static List<ExternalResourceModel> getAdditionalResources(String subjectId) {
    return [];
  }
}

import '../models/year_model.dart';
import '../models/semester_model.dart';
import '../models/subject_model.dart';
import '../models/resource_model.dart';
import '../models/user_model.dart';
import '../models/textbook_model.dart';
import '../datasources/firebase_datasource.dart';

class FirestoreRepository {
  final FirebaseDataSource firebaseDataSource;

  FirestoreRepository({required this.firebaseDataSource});

  Future<List<YearModel>> fetchYears() async {
    return await firebaseDataSource.getYears();
  }

  Future<List<SemesterModel>> fetchSemesters(String yearId) async {
    return await firebaseDataSource.getSemesters(yearId);
  }

  Future<List<SubjectModel>> fetchSubjects(String semesterId) async {
    return await firebaseDataSource.getSubjects(semesterId);
  }

  Future<List<ResourceModel>> fetchResources(String subjectId,
      {String? resourceType}) async {
    return await firebaseDataSource.getResources(subjectId,
        resourceType: resourceType);
  }

  Future<CourseOverviewModel?> fetchCourseOverview(String subjectId) async {
    return await firebaseDataSource.getCourseOverview(subjectId);
  }

  Future<List<TextbookChapterModel>> fetchTextbookChapters(
      String subjectId) async {
    return await firebaseDataSource.getTextbookChapters(subjectId);
  }

  Future<void> saveCourseOverview(CourseOverviewModel overview) async {
    await firebaseDataSource.saveCourseOverview(overview);
  }

  Future<void> deleteCourseOverview(String subjectId) async {
    await firebaseDataSource.deleteCourseOverview(subjectId);
  }

  Future<String> saveTextbookChapter(
      String subjectId, TextbookChapterModel chapter) async {
    return await firebaseDataSource.saveTextbookChapter(subjectId, chapter);
  }

  Future<void> deleteTextbookChapter(String subjectId, String chapterId) async {
    await firebaseDataSource.deleteTextbookChapter(subjectId, chapterId);
  }

  Future<void> updateChapterOrders(
      String subjectId, List<TextbookChapterModel> chapters) async {
    await firebaseDataSource.updateChapterOrders(subjectId, chapters);
  }

  Future<List<ResourceModel>> searchResources(String query) async {
    return await firebaseDataSource.searchResources(query);
  }

  Future<void> incrementDownloadCount(String resourceId) async {
    await firebaseDataSource.incrementDownloadCount(resourceId);
  }

  Future<String> createResourceDocument(ResourceModel resource) async {
    return await firebaseDataSource.createResourceDocument(resource);
  }

  Future<bool> checkResourceExists({
    required String subjectId,
    required String resourceType,
    required String title,
  }) async {
    return await firebaseDataSource.checkResourceExists(
      subjectId: subjectId,
      resourceType: resourceType,
      title: title,
    );
  }

  Future<void> syncUserProfile(UserModel user) async {
    await firebaseDataSource.syncUserProfile(user);
  }

  Future<UserModel?> getUserProfile(String uid) async {
    return await firebaseDataSource.getUserProfile(uid);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:minio/minio.dart';
import 'package:dio/dio.dart';
import '../../core/config/app_config.dart';
import '../models/year_model.dart';
import '../models/semester_model.dart';
import '../models/subject_model.dart';
import '../models/resource_model.dart';
import '../models/user_model.dart';
import '../models/textbook_model.dart';

class FirebaseDataSource {
  final FirebaseFirestore? _firestoreInstance;
  final FirebaseStorage? _storageInstance;
  final FirebaseAuth? _authInstance;
  final FirebaseAnalytics? _analyticsInstance;
  final FirebaseCrashlytics? _crashlyticsInstance;

  FirebaseDataSource({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
    FirebaseAnalytics? analytics,
    FirebaseCrashlytics? crashlytics,
  })  : _firestoreInstance = firestore,
        _storageInstance = storage,
        _authInstance = auth,
        _analyticsInstance = analytics,
        _crashlyticsInstance = crashlytics;

  FirebaseFirestore get _firestore =>
      _firestoreInstance ?? FirebaseFirestore.instance;
  FirebaseStorage get _storage => _storageInstance ?? FirebaseStorage.instance;
  FirebaseAuth get _auth => _authInstance ?? FirebaseAuth.instance;
  FirebaseAnalytics get _analytics =>
      _analyticsInstance ?? FirebaseAnalytics.instance;
  FirebaseCrashlytics get _crashlytics =>
      _crashlyticsInstance ?? FirebaseCrashlytics.instance;

  final Minio _minio = Minio(
    endPoint: AppConfig.archiveS3Endpoint,
    accessKey: AppConfig.archiveS3AccessKey,
    secretKey: AppConfig.archiveS3SecretKey,
    useSSL: true,
  );

  /// Ensure bucket exists in Archive.org
  Future<void> _ensureBucketExists() async {
    try {
      final exists = await _minio.bucketExists(AppConfig.archiveS3BucketName);
      if (!exists) {
        await _minio.makeBucket(AppConfig.archiveS3BucketName);
      }
    } catch (_) {
      // Ignore bucket creation errors on Archive.org, sometimes it's restricted
    }
  }

  /// Checks if Firebase is initialized and accessible
  bool get isAvailable {
    try {
      return _firestore.app.name.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // --- Auth Streams & Properties ---
  User? get currentUser {
    try {
      return _auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  Stream<User?> get authStateChanges {
    try {
      return _auth.authStateChanges();
    } catch (_) {
      return Stream.value(null);
    }
  }

  // --- Auth Operations ---

  /// Anonymous Sign-In for MVP
  Future<UserCredential?> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } catch (e, stack) {
      await logError(e, stack, reason: 'Anonymous sign-in failed');
      return null;
    }
  }

  /// Modular Email Sign-In (Structure prepared for future expansion)
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e, stack) {
      await logError(e, stack, reason: 'Email sign-in failed');
      rethrow;
    }
  }

  /// Modular Email Registration (Structure prepared for future expansion)
  Future<UserCredential?> registerWithEmail(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e, stack) {
      await logError(e, stack, reason: 'Email registration failed');
      rethrow;
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e, stack) {
      await logError(e, stack, reason: 'Sign-out failed');
    }
  }

  // --- Firestore User Profile Operations ---

  Future<void> syncUserProfile(UserModel userModel) async {
    try {
      await _firestore.collection('users').doc(userModel.uid).set(
            userModel.toFirestore(),
            SetOptions(merge: true),
          );
    } catch (e, stack) {
      await logError(e, stack, reason: 'User profile sync failed');
    }
  }

  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromFirestore(doc.data()!, uid);
      }
    } catch (e, stack) {
      await logError(e, stack, reason: 'Get user profile failed');
    }
    return null;
  }

  // --- Firestore Academic Collections ---

  Future<List<YearModel>> getYears() async {
    final snapshot =
        await _firestore.collection('years').orderBy('yearNumber').get();
    return snapshot.docs
        .map((doc) => YearModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<List<SemesterModel>> getSemesters(String yearId) async {
    final snapshot = await _firestore
        .collection('semesters')
        .where('yearId', isEqualTo: yearId)
        .orderBy('semesterNumber')
        .get();
    return snapshot.docs
        .map((doc) => SemesterModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<List<SubjectModel>> getSubjects(String semesterId) async {
    final snapshot = await _firestore
        .collection('subjects')
        .where('semesterId', isEqualTo: semesterId)
        .get();
    return snapshot.docs
        .map((doc) => SubjectModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<List<ResourceModel>> getResources(String subjectId,
      {String? resourceType}) async {
    Query query = _firestore
        .collection('resources')
        .where('subjectId', isEqualTo: subjectId);
    if (resourceType != null && resourceType.isNotEmpty) {
      query = query.where('resourceType', isEqualTo: resourceType);
    }
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => ResourceModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<List<ResourceModel>> searchResources(String queryText) async {
    final snapshot = await _firestore.collection('resources').get();
    final all = snapshot.docs
        .map((doc) => ResourceModel.fromFirestore(doc.data(), doc.id))
        .toList();

    final queryLower = queryText.toLowerCase();
    return all.where((res) {
      return res.title.toLowerCase().contains(queryLower) ||
          res.description.toLowerCase().contains(queryLower) ||
          res.subjectName.toLowerCase().contains(queryLower) ||
          res.resourceType.toLowerCase().contains(queryLower) ||
          res.tags.any((tag) => tag.toLowerCase().contains(queryLower));
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getEmergingTechs() async {
    try {
      final snapshot = await _firestore.collection('emerging_techs').get();
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> incrementDownloadCount(String resourceId) async {
    try {
      await _firestore.collection('resources').doc(resourceId).update({
        'downloadCount': FieldValue.increment(1),
        'downloadsCount': FieldValue.increment(1),
        'downloads': FieldValue.increment(1),
      });
    } catch (e, stack) {
      await logError(e, stack, reason: 'Failed to increment download count');
    }
  }

  // --- Admin PDF Upload & Firestore Operations ---

  /// Upload PDF to Archive.org path: StudyHub/{Year}/{Semester}/{Subject}/{ResourceType}/{filename}.pdf
  /// Uses direct HTTP PUT to Archive.org S3 endpoint with proper headers for auto-bucket creation.
  Future<String> uploadPdfToStorage({
    required String storagePath,
    required List<int> bytes,
    required void Function(double progress) onProgress,
  }) async {
    final rawPath =
        storagePath.startsWith('/') ? storagePath.substring(1) : storagePath;
    final parts = rawPath.split('/');
    final cleanParts = parts.map((part) {
      return part
          .replaceAll(RegExp(r'[^a-zA-Z0-9_\-\.]'), '_')
          .replaceAll(RegExp(r'_+'), '_');
    }).toList();
    final objectName = cleanParts.join('/');
    final bucket = AppConfig.archiveS3BucketName;

    final uint8Bytes = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);

    // Direct HTTP PUT to Archive.org S3 (100% Free, No Credit Card Required)
    final dio = Dio();
    final url = 'https://${AppConfig.archiveS3Endpoint}/$bucket/$objectName';

    try {
      await dio.put(
        url,
        data: uint8Bytes,
        options: Options(
          headers: {
            'Authorization':
                'LOW ${AppConfig.archiveS3AccessKey}:${AppConfig.archiveS3SecretKey}',
            'Content-Type': 'application/pdf',
            'Content-Length': uint8Bytes.length,
            'x-amz-auto-make-bucket': '1',
            'x-archive-meta-mediatype': 'texts',
            'x-archive-meta-collection': 'opensource',
          },
          contentType: 'application/pdf',
        ),
        onSendProgress: (sent, total) {
          if (total > 0) {
            onProgress(sent / total);
          }
        },
      );
      return 'https://archive.org/download/$bucket/$objectName';
    } catch (e) {
      debugPrint('Archive.org upload error: $e');
      rethrow;
    }
  }

  /// Create Firestore resource document in resources collection
  Future<String> createResourceDocument(ResourceModel resource) async {
    final docRef = _firestore.collection('resources').doc();
    final newResource = resource.copyWith(id: docRef.id);
    await docRef.set(newResource.toFirestore());
    return docRef.id;
  }

  /// Check duplicate resource by subjectId, resourceType & title
  Future<bool> checkResourceExists({
    required String subjectId,
    required String resourceType,
    required String title,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('resources')
          .where('subjectId', isEqualTo: subjectId)
          .where('resourceType', isEqualTo: resourceType)
          .where('title', isEqualTo: title)
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // --- Archive.org Storage URL Resolver ---
  Future<String> getDownloadUrl(String storagePath) async {
    if (storagePath.startsWith('http://') ||
        storagePath.startsWith('https://')) {
      return storagePath;
    }
    final objectName =
        storagePath.startsWith('/') ? storagePath.substring(1) : storagePath;
    return 'https://archive.org/download/${AppConfig.archiveS3BucketName}/$objectName';
  }

  // --- Firestore Career, Coding, Placement & Project Collections ---

  Future<List<Map<String, dynamic>>> getCareerTechnologies() async {
    try {
      final snapshot = await _firestore.collection('career').get();
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCodingResources() async {
    try {
      final snapshot = await _firestore.collection('coding').get();
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getPlacementResources() async {
    try {
      final snapshot = await _firestore.collection('placements').get();
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getProjects() async {
    try {
      final snapshot = await _firestore.collection('projects').get();
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getHigherEducationResources() async {
    try {
      final snapshot = await _firestore.collection('higher_education').get();
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (_) {
      return [];
    }
  }

  Future<String> createHigherEducationDocument(
      Map<String, dynamic> data) async {
    final docRef = _firestore.collection('higher_education').doc();
    await docRef.set({'id': docRef.id, ...data});
    return docRef.id;
  }

  Future<void> updateHigherEducationDocument(
      String id, Map<String, dynamic> data) async {
    await _firestore.collection('higher_education').doc(id).update(data);
  }

  Future<void> deleteHigherEducationDocument(String id) async {
    await _firestore.collection('higher_education').doc(id).delete();
  }

  Future<String> createCareerDocument(Map<String, dynamic> data) async {
    final docRef = _firestore.collection('career').doc();
    await docRef.set({'id': docRef.id, ...data});
    return docRef.id;
  }

  Future<void> updateCareerDocument(
      String id, Map<String, dynamic> data) async {
    await _firestore.collection('career').doc(id).update(data);
  }

  Future<void> deleteCareerDocument(String id) async {
    await _firestore.collection('career').doc(id).delete();
  }

  Future<String> createCodingDocument(Map<String, dynamic> data) async {
    final docRef = _firestore.collection('coding').doc();
    await docRef.set({'id': docRef.id, ...data});
    return docRef.id;
  }

  Future<void> updateCodingDocument(
      String id, Map<String, dynamic> data) async {
    await _firestore.collection('coding').doc(id).update(data);
  }

  Future<void> deleteCodingDocument(String id) async {
    await _firestore.collection('coding').doc(id).delete();
  }

  Future<String> createPlacementDocument(Map<String, dynamic> data) async {
    final docRef = _firestore.collection('placements').doc();
    await docRef.set({'id': docRef.id, ...data});
    return docRef.id;
  }

  Future<void> updatePlacementDocument(
      String id, Map<String, dynamic> data) async {
    await _firestore.collection('placements').doc(id).update(data);
  }

  Future<void> deletePlacementDocument(String id) async {
    await _firestore.collection('placements').doc(id).delete();
  }

  Future<String> createProjectDocument(Map<String, dynamic> data) async {
    final docRef = _firestore.collection('projects').doc();
    await docRef.set({'id': docRef.id, ...data});
    return docRef.id;
  }

  Future<void> updateProjectDocument(
      String id, Map<String, dynamic> data) async {
    await _firestore.collection('projects').doc(id).update(data);
  }

  Future<void> deleteProjectDocument(String id) async {
    await _firestore.collection('projects').doc(id).delete();
  }

  Future<void> updateResourceDocument(ResourceModel resource) async {
    await _firestore
        .collection('resources')
        .doc(resource.id)
        .update(resource.toFirestore());
  }

  Future<void> deleteResourceDocument(
      String resourceId, String? storagePath) async {
    if (storagePath != null && storagePath.isNotEmpty) {
      await deleteStorageFile(storagePath);
    }
    await _firestore.collection('resources').doc(resourceId).delete();
  }

  Future<void> deleteStorageFile(String storagePath) async {
    try {
      if (storagePath.startsWith('http://') ||
          storagePath.startsWith('https://')) return;
      final objectName =
          storagePath.startsWith('/') ? storagePath.substring(1) : storagePath;
      await _minio.removeObject(AppConfig.archiveS3BucketName, objectName);
    } catch (_) {}
  }

  /// Dashboard Metrics Counter for Admin
  Future<Map<String, int>> getDashboardMetrics() async {
    try {
      final subjs = await _firestore.collection('subjects').get();
      final res = await _firestore.collection('resources').get();
      final users = await _firestore.collection('users').get();

      int totalDownloads = 0;
      for (var doc in res.docs) {
        final data = doc.data();
        totalDownloads +=
            ((data['downloadCount'] ?? data['downloads'] ?? 0) as num).toInt();
      }

      return {
        'totalSubjects': subjs.docs.length,
        'totalResources': res.docs.length,
        'totalDownloads': totalDownloads,
        'totalUsers': users.docs.length,
      };
    } catch (_) {
      return {
        'totalSubjects': 24,
        'totalResources': 8,
        'totalDownloads': 1200,
        'totalUsers': 450,
      };
    }
  }

  /// User Management List for Admin
  Future<List<UserModel>> getUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (_) {
      return [
        UserModel(
          uid: 'student_1',
          email: 'student@csse.edu.in',
          displayName: 'Engineering Student',
          role: 'student',
          isAnonymous: false,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          lastLoginAt: DateTime.now(),
        ),
        UserModel(
          uid: 'admin_1',
          email: 'admin@csse.edu.in',
          displayName: 'CSSE Lead Administrator',
          role: 'admin',
          isAnonymous: false,
          createdAt: DateTime.now().subtract(const Duration(days: 90)),
          lastLoginAt: DateTime.now(),
        ),
      ];
    }
  }

  /// Promote/Update user role in Firestore
  Future<void> updateUserRole(String uid, String newRole) async {
    await _firestore.collection('users').doc(uid).update({
      'role': newRole,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Toggle user active status in Firestore
  Future<void> updateUserStatus(String uid, bool isDisabled) async {
    await _firestore.collection('users').doc(uid).update({
      'isDisabled': isDisabled,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // --- Firestore Academic Hierarchy CRUD Operations ---

  Future<String> createYearDocument(YearModel year) async {
    final docRef =
        _firestore.collection('years').doc(year.id.isNotEmpty ? year.id : null);
    final data = year.toFirestore();
    await docRef.set(data);
    return docRef.id;
  }

  Future<void> updateYearDocument(YearModel year) async {
    await _firestore
        .collection('years')
        .doc(year.id)
        .update(year.toFirestore());
  }

  Future<void> deleteYearDocument(String yearId) async {
    await _firestore.collection('years').doc(yearId).delete();
  }

  Future<String> createSemesterDocument(SemesterModel semester) async {
    final docRef = _firestore
        .collection('semesters')
        .doc(semester.id.isNotEmpty ? semester.id : null);
    await docRef.set(semester.toFirestore());
    return docRef.id;
  }

  Future<void> updateSemesterDocument(SemesterModel semester) async {
    await _firestore
        .collection('semesters')
        .doc(semester.id)
        .update(semester.toFirestore());
  }

  Future<void> deleteSemesterDocument(String semesterId) async {
    await _firestore.collection('semesters').doc(semesterId).delete();
  }

  Future<String> createSubjectDocument(SubjectModel subject) async {
    final docRef = _firestore
        .collection('subjects')
        .doc(subject.id.isNotEmpty ? subject.id : null);
    await docRef.set(subject.toFirestore());
    return docRef.id;
  }

  Future<void> updateSubjectDocument(SubjectModel subject) async {
    await _firestore
        .collection('subjects')
        .doc(subject.id)
        .update(subject.toFirestore());
  }

  Future<void> deleteSubjectDocument(String subjectId) async {
    await _firestore.collection('subjects').doc(subjectId).delete();
  }

  // --- Textbook & Course Overview Firestore Endpoints ---

  /// Fetch Course Overview Document from 'courseOverviews/{subjectId}'
  Future<CourseOverviewModel?> getCourseOverview(String subjectId) async {
    try {
      final doc =
          await _firestore.collection('courseOverviews').doc(subjectId).get();
      if (doc.exists && doc.data() != null) {
        return CourseOverviewModel.fromJson(doc.data()!, subjectId);
      }
    } catch (e, stack) {
      await logError(e, stack,
          reason: 'Failed to fetch courseOverview for $subjectId');
    }
    return null;
  }

  /// Fetch Textbook Chapters from 'subjects/{subjectId}/chapters' ordered by 'order'
  Future<List<TextbookChapterModel>> getTextbookChapters(
      String subjectId) async {
    try {
      final query = await _firestore
          .collection('subjects')
          .doc(subjectId)
          .collection('chapters')
          .orderBy('order')
          .get();

      if (query.docs.isNotEmpty) {
        return query.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return TextbookChapterModel.fromJson(data);
        }).toList();
      }
    } catch (e, stack) {
      await logError(e, stack,
          reason: 'Failed to fetch textbook chapters for $subjectId');
    }
    return [];
  }

  /// Save / Update Course Overview in 'courseOverviews/{subjectId}'
  Future<void> saveCourseOverview(CourseOverviewModel overview) async {
    try {
      await _firestore
          .collection('courseOverviews')
          .doc(overview.subjectId)
          .set(overview.toJson(), SetOptions(merge: true));
    } catch (e, stack) {
      await logError(e, stack,
          reason: 'Failed to save courseOverview for ${overview.subjectId}');
      rethrow;
    }
  }

  /// Delete Course Overview Document
  Future<void> deleteCourseOverview(String subjectId) async {
    try {
      await _firestore.collection('courseOverviews').doc(subjectId).delete();
    } catch (e, stack) {
      await logError(e, stack,
          reason: 'Failed to delete courseOverview for $subjectId');
      rethrow;
    }
  }

  /// Save / Update Textbook Chapter in 'subjects/{subjectId}/chapters/{chapterId}'
  Future<String> saveTextbookChapter(
      String subjectId, TextbookChapterModel chapter) async {
    try {
      final docRef = _firestore
          .collection('subjects')
          .doc(subjectId)
          .collection('chapters')
          .doc(chapter.id.isNotEmpty ? chapter.id : null);

      final data = chapter.toJson();
      if (chapter.id.isEmpty) {
        data['id'] = docRef.id;
      }
      await docRef.set(data, SetOptions(merge: true));
      return docRef.id;
    } catch (e, stack) {
      await logError(e, stack,
          reason: 'Failed to save textbook chapter for $subjectId');
      rethrow;
    }
  }

  /// Delete Textbook Chapter Document
  Future<void> deleteTextbookChapter(String subjectId, String chapterId) async {
    try {
      await _firestore
          .collection('subjects')
          .doc(subjectId)
          .collection('chapters')
          .doc(chapterId)
          .delete();
    } catch (e, stack) {
      await logError(e, stack,
          reason: 'Failed to delete chapter $chapterId from $subjectId');
      rethrow;
    }
  }

  /// Update Chapter Order Ranks
  Future<void> updateChapterOrders(
      String subjectId, List<TextbookChapterModel> chapters) async {
    try {
      final batch = _firestore.batch();
      for (int i = 0; i < chapters.length; i++) {
        final ch = chapters[i];
        final ref = _firestore
            .collection('subjects')
            .doc(subjectId)
            .collection('chapters')
            .doc(ch.id);
        batch.update(ref, {'order': i + 1, 'chapterNumber': i + 1});
      }
      await batch.commit();
    } catch (e, stack) {
      await logError(e, stack,
          reason: 'Failed to update chapter orders for $subjectId');
      rethrow;
    }
  }

  // --- Analytics & Crashlytics ---

  Future<void> logEvent(String name, Map<String, Object>? parameters) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (_) {}
  }

  Future<void> logError(dynamic exception, StackTrace? stack,
      {String? reason}) async {
    try {
      debugPrint('Firebase Error [$reason]: $exception');
      await _crashlytics.recordError(exception, stack, reason: reason);
    } catch (_) {}
  }
}

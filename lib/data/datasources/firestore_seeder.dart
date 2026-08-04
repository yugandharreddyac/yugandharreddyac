import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'mock_data.dart';

class FirestoreSeeder {
  final FirebaseFirestore _firestore;

  FirestoreSeeder({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Checks if Firestore academic collections exist; if empty, populates them.
  Future<void> seedAcademicHierarchyIfEmpty() async {
    try {
      final yearsSnapshot = await _firestore.collection('years').limit(1).get();
      if (yearsSnapshot.docs.isEmpty) {
        debugPrint('🌱 Seeding Firestore with CSSE Academic Hierarchy...');
        await _seedYears();
        await _seedSemesters();
        await _seedSubjects();
        debugPrint('✅ Firestore Academic Hierarchy Seeding Complete!');
      }
    } catch (e) {
      debugPrint('Firestore Seeder notice: $e (Skipping auto-seeding)');
    }
  }

  Future<void> _seedYears() async {
    final batch = _firestore.batch();
    for (final year in MockData.years) {
      final docRef = _firestore.collection('years').doc(year.id);
      batch.set(docRef, year.toFirestore());
    }
    await batch.commit();
  }

  Future<void> _seedSemesters() async {
    final batch = _firestore.batch();
    for (final sem in MockData.semesters) {
      final docRef = _firestore.collection('semesters').doc(sem.id);
      batch.set(docRef, sem.toFirestore());
    }
    await batch.commit();
  }

  Future<void> _seedSubjects() async {
    final batch = _firestore.batch();
    for (final subj in MockData.subjects) {
      final docRef = _firestore.collection('subjects').doc(subj.id);
      batch.set(docRef, subj.toFirestore());
    }
    await batch.commit();
  }
}

import 'subject_model.dart';
import 'resource_model.dart';
import 'textbook_model.dart';
import 'career_model.dart';

class SearchableItem {
  final String id;
  final String category; // 'Subject', 'Textbook Chapter', 'Textbook Section', 'Textbook Topic', 'Notes', 'Previous Paper', 'Syllabus', 'Career Path'
  final String title;
  final String subtitle;
  final String subjectName;
  final String subjectCode;
  final String semester;
  final String year;
  final List<String> keywords;
  final List<String> syllabusTopics;
  final List<String> unitTitles;
  final List<String> noteTitles;
  final List<String> previousPaperTitles;
  final String? storageUrl;
  final SubjectModel? subject;
  final ResourceModel? resource;
  final CareerModel? careerTech;
  final String? chapterId;
  final int? chapterNumber;
  final String? chapterTitle;
  final String? sectionId;
  final String? sectionNumber;
  final String? sectionTitle;
  final String? sectionType;
  final int? sectionIndex;
  final String? topicId;
  final String? topicNumber;
  final String? topicTitle;
  final TextbookTopicModel? topicModel;

  const SearchableItem({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.subjectName,
    required this.subjectCode,
    required this.semester,
    required this.year,
    this.keywords = const [],
    this.syllabusTopics = const [],
    this.unitTitles = const [],
    this.noteTitles = const [],
    this.previousPaperTitles = const [],
    this.storageUrl,
    this.subject,
    this.resource,
    this.careerTech,
    this.chapterId,
    this.chapterNumber,
    this.chapterTitle,
    this.sectionId,
    this.sectionNumber,
    this.sectionTitle,
    this.sectionType,
    this.sectionIndex,
    this.topicId,
    this.topicNumber,
    this.topicTitle,
    this.topicModel,
  });

  /// Evaluates whether this item matches a search query
  bool matches(String rawQuery) {
    if (rawQuery.trim().isEmpty) return false;

    // 1. Trim whitespace & ignore multiple consecutive spaces
    final q = rawQuery.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

    // 2. Direct exact or substring matching on key fields
    if (title.toLowerCase().contains(q) ||
        subtitle.toLowerCase().contains(q) ||
        subjectName.toLowerCase().contains(q) ||
        subjectCode.toLowerCase().contains(q) ||
        semester.toLowerCase().contains(q) ||
        year.toLowerCase().contains(q) ||
        category.toLowerCase().contains(q)) {
      return true;
    }

    // 3. Common abbreviations and acronym mapping
    if (q == 'c' && (subjectCode.toLowerCase() == 'cs1104' || subjectName.toLowerCase().contains('c programming') || subjectName.toLowerCase().contains('using c'))) return true;
    if (q == 'os' && (subjectName.toLowerCase().contains('operating system') || subjectCode.toLowerCase().contains('1105') || subjectCode.toLowerCase().contains('2105'))) return true;
    if (q == 'dbms' && (subjectName.toLowerCase().contains('database') || subjectName.toLowerCase().contains('dbms'))) return true;
    if (q == 'dld' && (subjectName.toLowerCase().contains('digital logic') || subjectCode.toLowerCase() == 'cs1204')) return true;
    if (q == 'coa' && (subjectName.toLowerCase().contains('organization') || subjectName.toLowerCase().contains('architecture'))) return true;
    if (q == 'ai' && (subjectName.toLowerCase().contains('artificial intelligence') || subjectName.toLowerCase().contains('ai'))) return true;
    if (q == 'ml' && (subjectName.toLowerCase().contains('machine learning') || subjectName.toLowerCase().contains('ml'))) return true;

    // 4. Match against keywords list
    for (final kw in keywords) {
      if (kw.trim().isEmpty) continue;
      final kwLower = kw.toLowerCase();
      if (kwLower.contains(q) || (kwLower.length >= 3 && q.contains(kwLower))) return true;
    }

    // 5. Match against syllabusTopics list
    for (final topic in syllabusTopics) {
      final tLower = topic.toLowerCase();
      if (tLower.contains(q)) return true;
    }

    // 6. Match against unitTitles list
    for (final unit in unitTitles) {
      final uLower = unit.toLowerCase();
      if (uLower.contains(q)) return true;
    }

    // 7. Match against noteTitles & previousPaperTitles list
    for (final note in noteTitles) {
      if (note.toLowerCase().contains(q)) return true;
    }
    for (final paper in previousPaperTitles) {
      if (paper.toLowerCase().contains(q)) return true;
    }

    return false;
  }
}

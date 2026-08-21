import '../../core/utils/fuzzy_matcher.dart';
import 'subject_model.dart';
import 'resource_model.dart';
import 'textbook_model.dart';
import 'career_model.dart';

class SearchableItem {
  final String id;
  final String
      category; // 'Subject', 'Textbook Chapter', 'Textbook Section', 'Textbook Topic', 'Notes', 'Previous Paper', 'Syllabus', 'Career Path'
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
  bool matches(String rawQuery) => matchScore(rawQuery) > 0;

  /// Returns an intelligent match score (0 = no match, 100 = exact match)
  int matchScore(String rawQuery) {
    if (rawQuery.trim().isEmpty) return 0;

    final q = rawQuery.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
    final tLower = title.toLowerCase();
    final sNameLower = subjectName.toLowerCase();
    final sCodeLower = subjectCode.toLowerCase();

    // Tier 1: Exact Match (Score = 100)
    if (tLower == q || sCodeLower == q || sNameLower == q) {
      return 100;
    }

    // Tier 2: Prefix Match (Score = 85)
    if (tLower.startsWith(q) ||
        sCodeLower.startsWith(q) ||
        sNameLower.startsWith(q)) {
      return 85;
    }

    // Tier 3: CS Abbreviation expansion match (Score = 80)
    final expansions = FuzzyMatcher.expandAbbreviations(q);
    for (final exp in expansions) {
      if (tLower.contains(exp) ||
          sNameLower.contains(exp) ||
          sCodeLower.contains(exp)) {
        return 80;
      }
      for (final kw in keywords) {
        if (kw.toLowerCase().contains(exp)) return 75;
      }
    }

    // Hardcoded high-priority abbreviations for backwards compatibility
    if (q == 'c' &&
        (sCodeLower == 'cs1104' ||
            sNameLower.contains('c programming') ||
            sNameLower.contains('using c'))) return 80;
    if (q == 'os' &&
        (sNameLower.contains('operating system') ||
            sCodeLower.contains('1105') ||
            sCodeLower.contains('2105'))) return 80;
    if (q == 'dbms' &&
        (sNameLower.contains('database') || sNameLower.contains('dbms')))
      return 80;
    if (q == 'dld' &&
        (sNameLower.contains('digital logic') || sCodeLower == 'cs1204'))
      return 80;
    if (q == 'coa' &&
        (sNameLower.contains('organization') ||
            sNameLower.contains('architecture'))) return 80;
    if (q == 'ai' &&
        (sNameLower.contains('artificial intelligence') ||
            sNameLower.contains('ai'))) return 80;
    if (q == 'ml' &&
        (sNameLower.contains('machine learning') || sNameLower.contains('ml')))
      return 80;

    // Tier 4: Direct Substring Match in title, subjectName or category (Score = 65)
    if (tLower.contains(q) ||
        sNameLower.contains(q) ||
        category.toLowerCase().contains(q)) {
      return 65;
    }

    // Tier 5: Direct Substring in keywords, syllabus, units, notes, or previous papers (Score = 50)
    for (final kw in keywords) {
      if (kw.trim().isEmpty) continue;
      final kwLower = kw.toLowerCase();
      if (kwLower.contains(q) || (kwLower.length >= 3 && q.contains(kwLower)))
        return 50;
    }

    for (final topic in syllabusTopics) {
      if (topic.toLowerCase().contains(q)) return 50;
    }

    for (final unit in unitTitles) {
      if (unit.toLowerCase().contains(q)) return 50;
    }

    for (final note in noteTitles) {
      if (note.toLowerCase().contains(q)) return 50;
    }

    for (final paper in previousPaperTitles) {
      if (paper.toLowerCase().contains(q)) return 50;
    }

    // Tier 6: Substring match in subtitle (Score = 40)
    if (subtitle.toLowerCase().contains(q) ||
        semester.toLowerCase().contains(q) ||
        year.toLowerCase().contains(q)) {
      return 40;
    }

    // Tier 7: Fuzzy / Typo Tolerance Match (Score = 25)
    if (q.length >= 3) {
      if (FuzzyMatcher.isFuzzyMatch(q, title, threshold: 0.70)) return 25;
      if (FuzzyMatcher.isFuzzyMatch(q, subjectName, threshold: 0.70)) return 25;

      for (final kw in keywords) {
        if (kw.length >= 3 &&
            FuzzyMatcher.isFuzzyMatch(q, kw, threshold: 0.72)) {
          return 25;
        }
      }
    }

    return 0;
  }
}

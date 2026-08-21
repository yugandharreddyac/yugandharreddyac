import 'dart:math';

/// High-performance fuzzy matching and abbreviation expansion utilities for UniDocs.
class FuzzyMatcher {
  FuzzyMatcher._();

  /// Standard Computer Science & Academic abbreviation dictionary
  static const Map<String, List<String>> csAbbreviations = {
    'c': ['c programming', 'programming in c', 'cs1104'],
    'cpp': ['c++', 'c plus plus', 'object oriented c++'],
    'py': ['python', 'python programming'],
    'js': ['javascript', 'web development'],
    'ts': ['typescript'],
    'os': ['operating system', 'operating systems'],
    'dbms': [
      'database management system',
      'database management systems',
      'database',
      'sql'
    ],
    'dld': ['digital logic design', 'digital logic', 'boolean algebra'],
    'cn': ['computer networks', 'networking', 'tcp/ip'],
    'se': ['software engineering', 'agile'],
    'daa': ['design and analysis of algorithms', 'algorithms', 'dsa'],
    'coa': ['computer organization and architecture', 'computer organization'],
    'toc': ['theory of computation', 'automata'],
    'cd': ['compiler design', 'compiler'],
    'ai': ['artificial intelligence'],
    'ml': ['machine learning'],
    'dl': ['deep learning', 'neural networks'],
    'nlp': ['natural language processing'],
    'cv': ['computer vision'],
    'dsa': ['data structures and algorithms', 'data structures'],
    'oop': ['object oriented programming', 'oops'],
    'oops': ['object oriented programming', 'oop'],
    'sql': ['structured query language', 'database'],
    'pyq': ['previous question papers', 'past papers', 'pyqs'],
    'pyqs': ['previous question papers', 'past papers', 'pyq'],
    'gate': ['graduate aptitude test in engineering', 'gate cse'],
    'gre': ['graduate record examinations'],
    'jwt': ['json web token', 'authentication'],
    'rest': ['representational state transfer', 'rest api', 'api'],
    'maths 1': ['mathematics-i', 'cs1101'],
    'maths 2': ['mathematics-ii', 'cs1201'],
    'm1': ['mathematics-i', 'cs1101'],
    'm2': ['mathematics-ii', 'cs1201'],
  };

  /// Computes the Levenshtein edit distance between two strings
  static int levenshteinDistance(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<int> v0 = List<int>.filled(t.length + 1, 0);
    List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i <= t.length; i++) {
      v0[i] = i;
    }

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;

      for (int j = 0; j < t.length; j++) {
        int cost = (s.codeUnitAt(i) == t.codeUnitAt(j)) ? 0 : 1;
        v1[j + 1] = min(v1[j] + 1, min(v0[j + 1] + 1, v0[j] + cost));
      }

      for (int j = 0; j <= t.length; j++) {
        v0[j] = v1[j];
      }
    }

    return v1[t.length];
  }

  /// Calculates normalized string similarity ratio between 0.0 and 1.0
  static double similarity(String s1, String s2) {
    final s1Clean = s1.trim().toLowerCase();
    final s2Clean = s2.trim().toLowerCase();

    if (s1Clean == s2Clean) return 1.0;
    if (s1Clean.isEmpty || s2Clean.isEmpty) return 0.0;

    final maxLen = max(s1Clean.length, s2Clean.length);
    final distance = levenshteinDistance(s1Clean, s2Clean);
    return (maxLen - distance) / maxLen;
  }

  /// Tests if [query] is a fuzzy match for [target]
  static bool isFuzzyMatch(String query, String target,
      {double threshold = 0.70}) {
    final q = query.trim().toLowerCase();
    final t = target.trim().toLowerCase();

    if (q.isEmpty || t.isEmpty) return false;
    if (t.contains(q) || q.contains(t)) return true;

    // Word-by-word fuzzy comparison for multi-word targets
    final targetWords = t.split(RegExp(r'[\s\-_\/]+'));
    for (final word in targetWords) {
      if (word.length < 3) continue;
      if (q.length < 3) {
        if (word.startsWith(q)) return true;
      } else {
        final dist = levenshteinDistance(q, word);
        if (dist <= 2 && (word.length >= 4 || dist <= 1)) {
          return true;
        }
        if (similarity(q, word) >= threshold) {
          return true;
        }
      }
    }

    // Full string comparison
    if (q.length >= 4 && t.length >= 4) {
      final sim = similarity(q, t);
      if (sim >= threshold) return true;
    }

    return false;
  }

  /// Expands abbreviations and returns candidate matching terms
  static List<String> expandAbbreviations(String query) {
    final q = query.trim().toLowerCase();
    return csAbbreviations[q] ?? const [];
  }
}

import '../datasources/firebase_datasource.dart';
import '../models/coding_resource_model.dart';

class CodingRepository {
  final FirebaseDataSource _firebaseDataSource;

  CodingRepository({required FirebaseDataSource firebaseDataSource})
      : _firebaseDataSource = firebaseDataSource;

  Future<List<CodingResourceModel>> getCodingResources() async {
    try {
      final remoteData = await _firebaseDataSource.getCodingResources();
      if (remoteData.isNotEmpty) {
        return remoteData.map((e) => CodingResourceModel.fromJson(e)).toList();
      }
    } catch (_) {}

    return _fallbackCodingResources;
  }

  static const List<CodingResourceModel> _fallbackCodingResources = [
    CodingResourceModel(
      id: 'dsa_roadmap_1',
      title: 'Complete Data Structures & Algorithms Roadmap',
      platform: 'DSA Roadmap',
      category: 'Roadmap',
      difficulty: 'All Levels',
      url: 'https://roadmap.sh/computer-science',
      description: 'Step-by-step master plan from Arrays, Linked Lists to Dynamic Programming & Graphs.',
      sheetName: 'CS Foundations',
      tags: ['DSA', 'Roadmap', 'Algorithms', 'Basics'],
    ),
    CodingResourceModel(
      id: 'striver_sde',
      title: 'Striver SDE Sheet (180 Questions)',
      platform: 'Coding Sheets',
      category: 'SDE Sheet',
      difficulty: 'Hard',
      url: 'https://takeuforward.org/strivers-sde-sheet-top-coding-interview-problems/',
      description: 'Top coding interview problems asked in FAANG and product-based companies.',
      sheetName: 'Striver SDE Sheet',
      tags: ['Striver', 'Interview', 'SDE', 'Top Problems'],
    ),
    CodingResourceModel(
      id: 'love_babbar_450',
      title: 'Love Babbar 450 DSA Cracker',
      platform: 'Coding Sheets',
      category: 'Coding Sheet',
      difficulty: 'Medium',
      url: 'https://450dsa.com/',
      description: 'Curated 450 coding questions across topic-wise DSA modules.',
      sheetName: 'Love Babbar 450',
      tags: ['Love Babbar', '450 DSA', 'Practice'],
    ),
    CodingResourceModel(
      id: 'neetcode_150',
      title: 'NeetCode 150 - LeetCode Pattern Practice',
      platform: 'LeetCode',
      category: 'LeetCode Patterns',
      difficulty: 'Medium',
      url: 'https://neetcode.io/practice',
      description: '150 curated LeetCode questions categorized by 18 coding patterns with video solutions.',
      sheetName: 'NeetCode 150',
      tags: ['NeetCode', 'LeetCode', 'Patterns'],
    ),
    CodingResourceModel(
      id: 'hackerrank_problem_solving',
      title: 'HackerRank Problem Solving Badge',
      platform: 'HackerRank',
      category: 'Badges',
      difficulty: 'Beginner',
      url: 'https://www.hackerrank.com/domains/python',
      description: 'Practice basic data structures, algorithms, and SQL to earn 6-star problem solving badges.',
      sheetName: 'HackerRank Star',
      tags: ['HackerRank', 'Beginner', 'Badges'],
    ),
    CodingResourceModel(
      id: 'codeforces_div2',
      title: 'Codeforces Division 2 & 3 Contest Practice',
      platform: 'Codeforces',
      category: 'Competitive Programming',
      difficulty: 'Hard',
      url: 'https://codeforces.com/problemset',
      description: 'Enhance speed, mathematical logic, and competitive programming ratings.',
      sheetName: 'CP Rating',
      tags: ['Codeforces', 'CP', 'Contests'],
    ),
    CodingResourceModel(
      id: 'sql_50',
      title: 'LeetCode 50 SQL Study Plan',
      platform: 'SQL Practice',
      category: 'Database SQL',
      difficulty: 'Easy',
      url: 'https://leetcode.com/studyplan/top-sql-50/',
      description: 'Master Joins, Aggregates, Subqueries, Window Functions, and Database Normalization.',
      sheetName: 'SQL 50',
      tags: ['SQL', 'LeetCode', 'Database', 'Queries'],
    ),
    CodingResourceModel(
      id: 'gfg_dsa_self_paced',
      title: 'GeeksforGeeks Must Do Coding Questions',
      platform: 'GeeksforGeeks',
      category: 'GFG Practice',
      difficulty: 'Medium',
      url: 'https://www.geeksforgeeks.org/must-do-coding-questions-for-companies-like-amazon-microsoft-adobe/',
      description: 'Most frequently asked company-wise interview questions on GeeksforGeeks.',
      sheetName: 'GFG Must Do',
      tags: ['GFG', 'Interview', 'Company Wise'],
    ),
  ];
}

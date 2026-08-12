import '../datasources/firebase_datasource.dart';
import '../models/coding_resource_model.dart';
import '../models/beyond_academics_model.dart';

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

  Future<List<CodingLanguageModel>> getCodingLanguages() async {
    return _fallbackCodingLanguages;
  }

  Future<List<DsaTopicModel>> getDsaTopics() async {
    return _fallbackDsaTopics;
  }

  Future<List<IndustryProjectModel>> getCodingProjects() async {
    return _fallbackCodingProjects;
  }

  static List<CodingLanguageModel> get fallbackCodingLanguages => _fallbackCodingLanguages;
  static List<DsaTopicModel> get fallbackDsaTopics => _fallbackDsaTopics;
  static List<IndustryProjectModel> get fallbackCodingProjects => _fallbackCodingProjects;

  // --- TRACK 1: CURATED PRACTICE SHEETS ---
  static const List<CodingResourceModel> _fallbackCodingResources = [
    CodingResourceModel(
      id: 'striver_sde',
      title: 'Striver SDE Sheet 180',
      platform: 'TakeUForward',
      sheetName: 'SDE Sheet 180',
      difficulty: 'Medium-Hard',
      url: 'https://takeuforward.org/strivers-sde-sheet-top-coding-interview-problems',
      category: 'Interview Sheet',
      description: 'Striver SDE Sheet containing top 180 curated coding interview questions for FAANG/MANG.',
      tags: ['SDE', 'Interview', 'DSA', 'Striver', 'Top 180'],
    ),
    CodingResourceModel(
      id: 'leetcode_75',
      title: 'LeetCode 75 Essential Study Plan',
      platform: 'LeetCode',
      sheetName: 'LeetCode 75',
      difficulty: 'Easy-Hard',
      url: 'https://leetcode.com/studyplan/leetcode-75',
      category: 'Practice Sheet',
      description: 'Official LeetCode 75 problem set covering core algorithms and data structures.',
      tags: ['LeetCode', 'Practice', 'Study Plan'],
    ),
    CodingResourceModel(
      id: 'blind_75',
      title: 'Blind 75 Must-Do LeetCode Questions',
      platform: 'Tech Interview Handbook',
      sheetName: 'Blind 75',
      difficulty: 'Medium-Hard',
      url: 'https://www.techinterviewhandbook.org/grind75',
      category: 'Interview Sheet',
      description: 'The famous Blind 75 list by Yangshun Tay categorized by problem solving patterns.',
      tags: ['Blind 75', 'Patterns', 'Interview Prep'],
    ),
    CodingResourceModel(
      id: 'neetcode_150',
      title: 'NeetCode 150 Practice Roadmap',
      platform: 'NeetCode.io',
      sheetName: 'NeetCode 150',
      difficulty: 'Easy-Hard',
      url: 'https://neetcode.io/roadmap',
      category: 'Practice Sheet',
      description: 'Structured 150 problem roadmap with video walkthroughs and visual animations.',
      tags: ['NeetCode', 'Video Solutions', 'Roadmap'],
    ),
  ];

  // --- TRACK 2: PROGRAMMING LANGUAGES ---
  static const List<CodingLanguageModel> _fallbackCodingLanguages = [
    CodingLanguageModel(
      id: 'python',
      name: 'Python 3',
      icon: 'terminal',
      introduction: 'High-level, interpreted programming language renowned for clear syntax, dynamic typing, and immense AI/Data Science libraries.',
      whyLearn: 'Preferred language for AI/ML, Data Structures, Web Backend (FastAPI, Django), and rapid scripting.',
      syntaxFundamentals: 'Indentation-based scoping (4 spaces), dynamic typing, built-in memory management, and rich standard library.',
      variablesAndDataTypes: 'int, float, bool, str, list, dict, set, tuple, NoneType. Dynamic type casting using int(), str().',
      operatorsAndConditions: 'Arithmetic (+, -, *, /, //, %), Logical (and, or, not), Conditional (if, elif, else), Ternary (x if cond else y).',
      loopsAndControlFlow: 'for item in iterable, while condition, break, continue, pass, enumerate(), zip(), range(start, stop, step).',
      functionsAndScope: 'def function_name(*args, **kwargs) -> ReturnType:. Local vs Global scope, lambda functions, decorators.',
      collectionsAndArrays: 'Lists [1, 2], Tuples (1, 2), Sets {1, 2}, Dicts {"a": 1}. List comprehensions: [x*2 for x in arr if x > 0].',
      stringHandling: 'f-strings f"Value: {x}", slicing s[start:end:step], methods: .split(), .join(), .strip(), .replace(), .lower().',
      objectOrientedProgramming: 'class Car:\n    def __init__(self, make):\n        self.make = make\nInheritance, dunder methods (__str__, __repr__), @classmethod, @staticmethod.',
      errorAndFileHandling: 'try...except Exception as e...else...finally block. Context manager: with open("file.txt", "r") as f:',
      practiceProblems: ['Reverse a String in O(N)', 'Two Sum using Hash Map', 'Valid Anagram Check', 'Group Anagrams'],
      recommendedProjects: ['CLI Student Note Tracker', 'FastAPI REST Server', 'Web Scraper with BeautifulSoup'],
      interviewQuestions: ['Difference between List vs Tuple?', 'How does Python garbage collection work?', 'Explain Python GIL (Global Interpreter Lock).'],
      officialDocsUrl: 'https://docs.python.org/3/',
      youtubePlaylistUrl: 'https://youtube.com',
    ),

    CodingLanguageModel(
      id: 'cpp',
      name: 'C++',
      icon: 'code',
      introduction: 'High-performance system-level programming language offering low-level memory access and rich Standard Template Library (STL).',
      whyLearn: 'Industry standard for Competitive Programming, Game Engines, Operating Systems, and high-frequency trading systems.',
      syntaxFundamentals: '#include <iostream>, int main() entry point, static typing, semicolon statements, manual memory control.',
      variablesAndDataTypes: 'int, double, float, char, bool, long long, std::string. Type qualifiers: const, auto, static, constexpr.',
      operatorsAndConditions: 'Arithmetic (+, -, *, /, %), Bitwise (&, |, ^, ~, <<, >>), Increment (++, --), if/else, switch/case.',
      loopsAndControlFlow: 'for(int i=0; i<n; i++), range-based for(auto& x : vec), while(cond), do-while(cond).',
      functionsAndScope: 'Return-type signatures, pass-by-value vs pass-by-reference (int &x), default parameters, inline functions.',
      collectionsAndArrays: 'STL Containers: std::vector, std::pair, std::set, std::map, std::unordered_map, std::priority_queue, std::stack, std::queue.',
      stringHandling: 'std::string, .size(), .substr(pos, len), .find(), std::stringstream, C-style char arrays (char*).',
      objectOrientedProgramming: 'class Node { public: int data; Node* next; }; Constructors, destructors (~Node), virtual functions, polymorphism, inheritance.',
      errorAndFileHandling: 'Pointers (int* p), References (int& r), Dynamic Allocation (new/delete), Smart Pointers (std::unique_ptr, std::shared_ptr).',
      practiceProblems: ['Array Rotation in O(1) Space', 'Binary Search Implementation', 'Reverse a Linked List', 'Detect Loop in Linked List'],
      recommendedProjects: ['Banking Management System CLI', 'Custom Memory Allocator', 'High-Performance Matrix Multiplier'],
      interviewQuestions: ['Difference between Pointer and Reference?', 'Explain C++ Virtual Functions & VTable.', 'How does std::vector dynamic resizing work?'],
      officialDocsUrl: 'https://en.cppreference.com/w/',
      youtubePlaylistUrl: 'https://youtube.com',
    ),

    CodingLanguageModel(
      id: 'java',
      name: 'Java',
      icon: 'coffee',
      introduction: 'Class-based, object-oriented programming language designed for platform independence via the Java Virtual Machine (JVM).',
      whyLearn: 'Enterprise backend foundation (Spring Boot), Android application development, and large-scale corporate software systems.',
      syntaxFundamentals: 'public class Main { public static void main(String[] args) {} }. Strongly typed, garbage collected.',
      variablesAndDataTypes: 'Primitives: int, double, float, boolean, char, long, byte, short. Objects: String, Integer, Double, BigInteger.',
      operatorsAndConditions: 'Arithmetic, Relational, Logical, Ternary. Control: if/else, switch-case with String support.',
      loopsAndControlFlow: 'for loop, enhanced for (for (int x : arr)), while, do-while, break label.',
      functionsAndScope: 'Methods inside classes, access modifiers (public, private, protected, package-private), method overloading & overriding.',
      collectionsAndArrays: 'Java Collections Framework: ArrayList, LinkedList, HashSet, TreeSet, HashMap, ConcurrentHashMap, PriorityQueue.',
      stringHandling: 'String immutability, StringBuilder for high-performance concatenation, StringBuffer for thread safety, .substring(), .split().',
      objectOrientedProgramming: 'Encapsulation, Inheritance (extends), Polymorphism, Abstraction (abstract class & interface), generics (<T>).',
      errorAndFileHandling: 'try...catch...finally, throw/throws. Try-with-resources: try (BufferedReader br = new BufferedReader(...)).',
      practiceProblems: ['Subarray Sum Equals K', 'Implement Queue using Stacks', 'Validate Binary Search Tree'],
      recommendedProjects: ['Student Information Management API', 'Spring Boot E-Commerce Microservice'],
      interviewQuestions: ['Difference between HashMap vs ConcurrentHashMap?', 'Explain Java Garbage Collection algorithms.', 'String vs StringBuilder vs StringBuffer?'],
      officialDocsUrl: 'https://docs.oracle.com/en/java/',
      youtubePlaylistUrl: 'https://youtube.com',
    ),
  ];

  // --- TRACK 3: CORE DSA TOPICS ---
  static const List<DsaTopicModel> _fallbackDsaTopics = [
    DsaTopicModel(
      id: 'arrays_strings',
      topicName: 'Arrays & Dynamic Arrays',
      category: 'Arrays',
      definition: 'A linear data structure storing elements in contiguous memory locations, offering constant time O(1) index-based access.',
      intuition: 'Think of an array like a row of numbered lockers where jumping to locker #i takes instant constant time because memory offset = base_address + i * element_size.',
      approach: 'Use index offsets for O(1) access. For searching, use linear traversal O(N) or Binary Search O(log N) if sorted.',
      algorithm: '1. Access element at index i: Return arr[i]\n2. Search element K: Loop from 0 to N-1, if arr[j] == K return j',
      pseudocode: '''FOR i FROM 0 TO N-1 DO
    IF arr[i] == Target THEN
        RETURN i
    END IF
END FOR
RETURN -1''',
      codeImplementation: '''// Python Implementation
def linear_search(arr, target):
    for i, num in enumerate(arr):
        if num == target:
            return i
    return -1

// C++ Implementation
int linearSearch(vector<int>& arr, int target) {
    for (int i = 0; i < arr.size(); i++) {
        if (arr[i] == target) return i;
    }
    return -1;
}''',
      timeComplexity: 'Access: O(1), Search: O(N), Insert/Delete: O(N)',
      spaceComplexity: 'O(N) for storing N elements.',
      example: 'Input: arr = [10, 20, 30, 40], target = 30 -> Output Index: 2',
      commonMistakes: ['Index out of bounds error', 'Forgetting dynamic resizing overhead in vectors'],
      practiceProblems: ['Two Sum (LeetCode #1)', 'Best Time to Buy & Sell Stock (LeetCode #121)', 'Contains Duplicate (LeetCode #217)'],
      interviewQuestions: ['How does vector dynamic array doubling strategy guarantee O(1) amortized insertion?'],
    ),

    DsaTopicModel(
      id: 'dynamic_programming',
      topicName: 'Dynamic Programming (DP)',
      category: 'DP',
      definition: 'An algorithmic optimization technique that breaks a complex problem down into overlapping subproblems and caches their intermediate results.',
      intuition: 'Write down 1+1+1+1+1 = 5. Now add "+ 1" to the end. How do you know it is 6? Because you remembered the 5! DP is remembering past answers.',
      approach: 'Identify Overlapping Subproblems & Optimal Substructure. Formulate State Transition Equation. Choose Top-Down Memoization or Bottom-Up Tabulation.',
      algorithm: '1. Define DP Table dp[i]\n2. Establish Base Cases\n3. Recurrence: dp[i] = dp[i-1] + dp[i-2]',
      pseudocode: '''FUNCTION climbStairs(n):
    IF n <= 2 THEN RETURN n
    dp = ARRAY of size (n+1)
    dp[1] = 1, dp[2] = 2
    FOR i FROM 3 TO n DO
        dp[i] = dp[i-1] + dp[i-2]
    END FOR
    RETURN dp[n]''',
      codeImplementation: '''# Python Memoized DP
def climbStairs(n: int) -> int:
    if n <= 2: return n
    dp = [0] * (n + 1)
    dp[1], dp[2] = 1, 2
    for i in range(3, n + 1):
        dp[i] = dp[i-1] + dp[i-2]
    return dp[n]''',
      timeComplexity: 'Time: O(N), Space: O(N) or O(1) space optimized.',
      spaceComplexity: 'O(N) for DP table or O(1) with rolling variables.',
      example: 'Input: n = 5 -> Output: 8 distinct stair climbing paths.',
      commonMistakes: ['Incorrect base case initialization', 'State transition recurrence off-by-one'],
      practiceProblems: ['Climbing Stairs (LeetCode #70)', 'Coin Change (LeetCode #322)', 'Longest Common Subsequence (LeetCode #1143)'],
      interviewQuestions: ['Explain top-down memoization vs bottom-up tabulation with call stack analysis.'],
    ),
  ];

  // --- TRACK 4: INDUSTRY PROJECTS ---
  static const List<IndustryProjectModel> _fallbackCodingProjects = [
    IndustryProjectModel(
      id: 'proj_notes',
      title: 'Smart Task & Notes App',
      problemStatement: 'Students need offline task tracking with SQLite local persistence and fast search.',
      whyBuild: 'Demonstrates offline local database persistence, MVVM/Clean Architecture, and state management.',
      architecture: 'Clean Architecture (Data, Domain, Presentation Layers)',
      databaseRequirements: 'SQLite / Room Database with local index',
      apiRequirements: 'Local CRUD operations with async streams',
      folderStructure: 'lib/\n  data/\n  domain/\n  presentation/',
      testingRequirements: 'Unit tests for repository & Provider state',
      deploymentRequirements: 'Android APK / iOS build bundle',
      readmeRequirements: 'Project setup guide, screenshots, and architectural diagram',
      resumeDescription: 'Built offline-first task tracker using SQLite and Clean Architecture in Flutter.',
      techStack: ['Flutter', 'SQLite', 'Provider', 'Dart'],
      difficulty: 'Beginner',
    ),
  ];
}

import 'package:flutter/material.dart';
import '../models/hierarchy_node_model.dart';

class NonAcademicData {
  NonAcademicData._();

  static final List<HubModel> allHubs = [
    codingHub,
    emergingTechHub,
    higherEducationHub,
    placementHub,
    projectsHub,
    entrepreneurshipHub,
  ];

  static HubModel? getHubById(String id) {
    try {
      return allHubs.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

  // ==========================================
  // 1. CODING HUB (COMPLETE LEARNING SYSTEM)
  // ==========================================
  static const HubModel codingHub = HubModel(
    id: 'coding',
    title: 'Coding Hub',
    description: 'Master programming languages, data structures, algorithms, web, app development & databases.',
    icon: Icons.code_rounded,
    routeName: '/coding',
    startHereSteps: [
      StartHereStepModel(
        stepNumber: 1,
        title: 'Computer Basics & Logic Building',
        description: 'Understand how computers execute code, binary math, flowcharts, and pseudo-code.',
        targetCategoryId: 'programming_basics',
      ),
      StartHereStepModel(
        stepNumber: 2,
        title: 'Choose a Core Language',
        description: 'Master Python, C++, Java, C, JavaScript, Dart, or SQL with hands-on practice.',
        targetCategoryId: 'programming_languages',
      ),
      StartHereStepModel(
        stepNumber: 3,
        title: 'Master Data Structures & Algorithms',
        description: 'Conquer 23+ core DSA topics with intuition, complexity analysis & LeetCode problems.',
        targetCategoryId: 'dsa',
      ),
      StartHereStepModel(
        stepNumber: 4,
        title: 'Fullstack & Mobile Engineering',
        description: 'Build web applications with React/Node and cross-platform mobile apps with Flutter.',
        targetCategoryId: 'web_dev',
      ),
      StartHereStepModel(
        stepNumber: 5,
        title: 'Databases & Software Architecture',
        description: 'Master SQL, PostgreSQL, MongoDB, Redis, Git branching, CI/CD & clean code design.',
        targetCategoryId: 'databases',
      ),
      StartHereStepModel(
        stepNumber: 6,
        title: 'Build Portfolio Projects & Competitive Prep',
        description: 'Construct real-world projects and practice tech interview questions on LeetCode.',
        targetCategoryId: 'dsa',
      ),
    ],
    categories: [
      // Category 1: Programming Basics
      CategoryModel(
        id: 'programming_basics',
        title: 'Programming Basics',
        description: 'Fundamental concepts, logic building, flowcharts, compilers & execution models.',
        icon: Icons.lightbulb_outline_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'basics_intro',
            title: 'Introduction to Programming',
            description: 'What is code, compilers vs interpreters, and algorithm flowcharts.',
            icon: Icons.menu_book_rounded,
            resources: [
              HierarchyResourceModel(
                id: 'res_basics_notes',
                title: 'Programming Fundamentals Notes',
                description: 'Comprehensive guide to algorithms, flowcharts, and basic syntax concepts.',
                type: HierarchyResourceType.notes,
                url: 'https://docs.python.org/3/tutorial/index.html',
                platform: 'Python Official Docs',
              ),
              HierarchyResourceModel(
                id: 'res_basics_online',
                title: 'Interactive Code Basics',
                description: 'Hands-on interactive introduction to programming logic online.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.geeksforgeeks.org/fundamentals-of-algorithms/',
                platform: 'GeeksforGeeks',
              ),
            ],
          ),
        ],
      ),

      // Category 2: Programming Languages
      CategoryModel(
        id: 'programming_languages',
        title: 'Programming Languages',
        description: 'Master Python, C, C++, Java, JavaScript, Dart, and SQL from beginner to advanced.',
        icon: Icons.laptop_mac_rounded,
        availableLevels: [
          LearningLevel.beginner,
          LearningLevel.intermediate,
          LearningLevel.advanced,
          LearningLevel.projects,
        ],
        topics: [
          // PYTHON
          HierarchicalTopicModel(
            id: 'python',
            title: 'Python',
            description: 'High-level, readable language widely used in AI, Data Science, and Web Development.',
            icon: Icons.code_rounded,
            subtopics: [
              // Beginner Python
              HierarchicalTopicModel(
                id: 'python_basics',
                title: 'Python Basics & Setup',
                description: 'Overview of Python language, syntax, interpreter, memory model, and code execution.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_py_basics_notes',
                    title: 'Python Basics & Syntax Cheat Sheet',
                    description: 'Comprehensive guide covering print(), comments, indentation, keywords, and execution flow.',
                    type: HierarchyResourceType.notes,
                    url: 'https://docs.python.org/3/tutorial/introduction.html',
                    platform: 'Official Python Docs',
                  ),
                  HierarchyResourceModel(
                    id: 'res_py_basics_video',
                    title: 'Python for Absolute Beginners (Full Course)',
                    description: 'Full guided video tutorial covering installation, VS Code setup, and core syntax.',
                    type: HierarchyResourceType.video,
                    url: 'https://www.youtube.com/watch?v=_uQrJ0TkZlc',
                    platform: 'YouTube / Programming with Mosh',
                  ),
                  HierarchyResourceModel(
                    id: 'res_py_basics_practice',
                    title: 'Basic Syntax & Input/Output Exercises',
                    description: '15 hands-on introductory coding challenges on basic I/O and arithmetic.',
                    type: HierarchyResourceType.practice,
                    url: 'https://www.geeksforgeeks.org/python-programming-examples/',
                    platform: 'GeeksforGeeks',
                  ),
                  HierarchyResourceModel(
                    id: 'res_py_basics_online',
                    title: 'Interactive Python Basics Playground',
                    description: 'Run basic Python code directly in your web browser with instant feedback.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.w3schools.com/python/python_intro.asp',
                    platform: 'W3Schools Interactive',
                  ),
                ],
              ),
              HierarchicalTopicModel(
                id: 'python_variables',
                title: 'Variables & Data Types',
                description: 'Integers, floats, booleans, strings, type casting, dynamic typing, and memory allocation.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_py_var_notes',
                    title: 'Python Variables & Types Master Guide',
                    description: 'Detailed breakdown of int, float, bool, str, type casting (int(), str()), and type() inspection.',
                    type: HierarchyResourceType.notes,
                    url: 'https://docs.python.org/3/library/stdtypes.html',
                    platform: 'Official Python Docs',
                  ),
                  HierarchyResourceModel(
                    id: 'res_py_var_video',
                    title: 'Python Variables & Dynamic Typing Video',
                    description: 'Visual video guide explaining variable assignment, pointers, and dynamic typing.',
                    type: HierarchyResourceType.video,
                    url: 'https://www.youtube.com/watch?v=khKv-8q7YmY',
                    platform: 'YouTube / Corey Schafer',
                  ),
                  HierarchyResourceModel(
                    id: 'res_py_var_practice',
                    title: 'Variables & Type Casting Exercises',
                    description: 'Practice 10 exercises on type conversion and variable scope.',
                    type: HierarchyResourceType.practice,
                    url: 'https://www.geeksforgeeks.org/python-variables/',
                    platform: 'GeeksforGeeks',
                  ),
                  HierarchyResourceModel(
                    id: 'res_py_var_online',
                    title: 'Interactive Variables Playground',
                    description: 'Interactive online tutorial and code editor for Python data types.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.w3schools.com/python/python_variables.asp',
                    platform: 'W3Schools Interactive',
                  ),
                ],
              ),
              HierarchicalTopicModel(
                id: 'python_ds',
                title: 'Data Structures in Python',
                description: 'Lists, Tuples, Sets, and Dictionaries.',
                level: LearningLevel.beginner,
                subtopics: [
                  HierarchicalTopicModel(
                    id: 'python_ds_lists',
                    title: 'Python Lists',
                    description: 'Ordered, mutable sequences. Indexing, slicing, list comprehension, and methods.',
                    level: LearningLevel.beginner,
                    resources: [
                      HierarchyResourceModel(
                        id: 'res_py_lists_notes',
                        title: 'Python Lists & Comprehensions Guide',
                        description: 'Detailed tutorial on list methods (append, pop, sort, reverse) and list comprehension syntax.',
                        type: HierarchyResourceType.notes,
                        url: 'https://docs.python.org/3/tutorial/datastructures.html#more-on-lists',
                        platform: 'Official Python Docs',
                      ),
                      HierarchyResourceModel(
                        id: 'res_py_lists_video',
                        title: 'Python Lists & Slicing Deep Dive',
                        description: 'Video tutorial covering list indexing, slicing [start:stop:step], and nested lists.',
                        type: HierarchyResourceType.video,
                        url: 'https://www.youtube.com/watch?v=tw7ror9x32s',
                        platform: 'YouTube / Corey Schafer',
                      ),
                      HierarchyResourceModel(
                        id: 'res_py_lists_practice',
                        title: 'Python List Manipulation Practice',
                        description: '20 practical coding problems on list filtering, reversing, and matrix operations.',
                        type: HierarchyResourceType.practice,
                        url: 'https://www.geeksforgeeks.org/python-list-exercise/',
                        platform: 'GeeksforGeeks',
                      ),
                      HierarchyResourceModel(
                        id: 'res_py_lists_online',
                        title: 'W3Schools Interactive Python Lists',
                        description: 'Interactive tutorial and browser code runner for Python lists.',
                        type: HierarchyResourceType.learnOnline,
                        url: 'https://www.w3schools.com/python/python_lists.asp',
                        platform: 'W3Schools Interactive',
                      ),
                    ],
                  ),
                ],
              ),
              // Intermediate Python
              HierarchicalTopicModel(
                id: 'python_oop',
                title: 'Object-Oriented Programming (OOP)',
                description: 'Classes, objects, inheritance, polymorphism, encapsulation, dunder methods (`__init__`).',
                level: LearningLevel.intermediate,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_py_oop_notes',
                    title: 'Python OOP Masterclass Guide',
                    description: 'Class attributes, instance variables, inheritance, and encapsulation principles.',
                    type: HierarchyResourceType.notes,
                    url: 'https://realpython.com/python3-object-oriented-programming/',
                    platform: 'Real Python',
                  ),
                  HierarchyResourceModel(
                    id: 'res_py_oop_online',
                    title: 'Interactive Python OOP',
                    description: 'Interactive tutorial on classes, objects, and method overriding.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.w3schools.com/python/python_classes.asp',
                    platform: 'W3Schools Interactive',
                  ),
                ],
              ),
              // Advanced Python
              HierarchicalTopicModel(
                id: 'python_decorators',
                title: 'Decorators, Generators & Async',
                description: 'Higher-order functions, decorators (`@`), generators (`yield`), context managers, asyncio.',
                level: LearningLevel.advanced,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_py_decorators_notes',
                    title: 'Advanced Python Patterns & Decorators',
                    description: 'Comprehensive guide to decorators, context managers (`with`), and generator expressions.',
                    type: HierarchyResourceType.notes,
                    url: 'https://realpython.com/primer-on-python-decorators/',
                    platform: 'Real Python',
                  ),
                ],
              ),
            ],
          ),

          // C LANGUAGE
          HierarchicalTopicModel(
            id: 'c_lang',
            title: 'C Language',
            description: 'Foundational procedural language. Pointers, direct memory allocation, and low-level system control.',
            icon: Icons.code_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'c_pointers',
                title: 'Pointers & Memory Allocation',
                description: 'Address-of (`&`), dereferencing (`*`), pointer arithmetic, `malloc`, `calloc`, `free`, and memory leaks.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_c_ptr_notes',
                    title: 'C Pointers & Memory Allocation Guide',
                    description: 'Visual guide to memory addresses, pointers, arrays vs pointers, and heap management.',
                    type: HierarchyResourceType.notes,
                    url: 'https://www.geeksforgeeks.org/c-pointers/',
                    platform: 'GeeksforGeeks',
                  ),
                  HierarchyResourceModel(
                    id: 'res_c_ptr_online',
                    title: 'Learn C Online Tutorial',
                    description: 'Interactive compiler and step-by-step C programming tutorial.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.programiz.com/c-programming',
                    platform: 'Programiz Interactive',
                  ),
                ],
              ),
            ],
          ),

          // C++ LANGUAGE
          HierarchicalTopicModel(
            id: 'cpp_lang',
            title: 'C++',
            description: 'High-performance object-oriented language widely used in competitive programming & systems engineering.',
            icon: Icons.code_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'cpp_stl',
                title: 'Standard Template Library (STL)',
                description: 'Vectors, maps, sets, pairs, queues, stacks, iterators, and algorithms (`std::sort`, `std::binary_search`).',
                level: LearningLevel.intermediate,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_cpp_stl_notes',
                    title: 'C++ STL Master Reference & Cheat Sheet',
                    description: 'Complete guide to std::vector, std::map, std::set, std::unordered_map, and complexity constraints.',
                    type: HierarchyResourceType.notes,
                    url: 'https://www.geeksforgeeks.org/the-c-standard-template-library-stl/',
                    platform: 'GeeksforGeeks',
                  ),
                  HierarchyResourceModel(
                    id: 'res_cpp_stl_online',
                    title: 'cppreference.com STL Containers',
                    description: 'Official C++ Standard Library container reference manual.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://en.cppreference.com/w/cpp/container',
                    platform: 'CPPReference Official',
                  ),
                ],
              ),
            ],
          ),

          // JAVA
          HierarchicalTopicModel(
            id: 'java_lang',
            title: 'Java',
            description: 'Robust, object-oriented enterprise language. Platform independent with JVM execution.',
            icon: Icons.code_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'java_collections',
                title: 'Java Collections Framework',
                description: 'ArrayList, LinkedList, HashMap, HashSet, PriorityQueue, and Comparator/Comparable interfaces.',
                level: LearningLevel.intermediate,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_java_coll_notes',
                    title: 'Java Collections Framework Complete Guide',
                    description: 'Detailed explanation of collection interfaces, underlying algorithms, and thread safety.',
                    type: HierarchyResourceType.notes,
                    url: 'https://docs.oracle.com/javase/tutorial/collections/index.html',
                    platform: 'Oracle Java Official Tutorial',
                  ),
                  HierarchyResourceModel(
                    id: 'res_java_coll_online',
                    title: 'W3Schools Java Collections Interactive',
                    description: 'Interactive tutorial for Java lists, maps, and sets.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.w3schools.com/java/java_user_input.asp',
                    platform: 'W3Schools Interactive',
                  ),
                ],
              ),
            ],
          ),

          // JAVASCRIPT
          HierarchicalTopicModel(
            id: 'javascript_lang',
            title: 'JavaScript',
            description: 'The language of the web. Asynchronous event-driven programming, DOM manipulation, ES6+ features.',
            icon: Icons.code_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'js_es6',
                title: 'Modern ES6+ JavaScript',
                description: 'Arrow functions, Promises, Async/Await, Destructuring, Modules, Spread/Rest, Closures.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_js_es6_online',
                    title: 'javascript.info Modern JavaScript',
                    description: 'The Modern JavaScript Tutorial from elementary syntax to advanced topics.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://javascript.info/',
                    platform: 'JavaScript.info Official',
                  ),
                  HierarchyResourceModel(
                    id: 'res_js_mdn',
                    title: 'MDN JavaScript Guide',
                    description: 'Authoritative Mozilla Developer Network documentation on JavaScript.',
                    type: HierarchyResourceType.notes,
                    url: 'https://developer.mozilla.org/en-US/docs/Web/JavaScript',
                    platform: 'MDN Web Docs',
                  ),
                ],
              ),
            ],
          ),

          // DART & FLUTTER CORE
          HierarchicalTopicModel(
            id: 'dart_lang',
            title: 'Dart',
            description: 'Client-optimized language for fast apps on any platform. Strongly typed with sound null-safety.',
            icon: Icons.mobile_friendly_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'dart_null_safety',
                title: 'Dart Language & Sound Null Safety',
                description: 'Variables, null-safety (`?`, `!`, `late`), OOP, mixins, streams, and async/await.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_dart_online',
                    title: 'Official Dart Documentation',
                    description: 'Official Dart language tour, effective Dart guidelines, and API docs.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://dart.dev/guides',
                    platform: 'Dart.dev Official',
                  ),
                ],
              ),
            ],
          ),

          // SQL LANGUAGE
          HierarchicalTopicModel(
            id: 'sql_lang',
            title: 'SQL (Structured Query Language)',
            description: 'Standard declarative language for relational database management, data querying, and schema definition.',
            icon: Icons.storage_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'sql_queries_core',
                title: 'SQL DDL, DML & JOIN Queries',
                description: 'SELECT, INSERT, UPDATE, DELETE, CREATE TABLE, ALTER TABLE, INNER/LEFT/RIGHT JOINs, and GROUP BY.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_sql_lang_online',
                    title: 'W3Schools Interactive SQL Tutorial',
                    description: 'Interactive online SQL query runner and reference manual.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.w3schools.com/sql/',
                    platform: 'W3Schools Interactive',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Category 3: Data Structures & Algorithms (COMPLETE 23+ ROADMAP)
      CategoryModel(
        id: 'dsa',
        title: 'Data Structures & Algorithms',
        description: 'Comprehensive 23-topic DSA roadmap: Time Complexity, Arrays, Trees, Graphs, Sorting & Dynamic Programming.',
        icon: Icons.account_tree_rounded,
        availableLevels: [
          LearningLevel.beginner,
          LearningLevel.intermediate,
          LearningLevel.advanced,
        ],
        topics: [
          // 1. Complexity Analysis
          HierarchicalTopicModel(
            id: 'dsa_complexity',
            title: 'Complexity Analysis (Big-O)',
            description: 'Time and Space Complexity, Big-O, Big-Omega, Big-Theta notation, and recursion recurrence relations.',
            level: LearningLevel.beginner,
            resources: [
              HierarchyResourceModel(
                id: 'res_dsa_comp_notes',
                title: 'Big-O Cheat Sheet & Complexity Guide',
                description: 'Time complexity breakdown for array, linked list, tree, graph, and sorting algorithms.',
                type: HierarchyResourceType.notes,
                url: 'https://www.geeksforgeeks.org/analysis-algorithm-set-1-asymptotic-analysis/',
                platform: 'GeeksforGeeks',
              ),
            ],
          ),
          // 2. Arrays & Strings
          HierarchicalTopicModel(
            id: 'dsa_arrays',
            title: 'Arrays & Strings',
            description: 'Contiguous memory, Two Pointers, Sliding Window, Prefix Sum, Kadane\'s Algorithm.',
            level: LearningLevel.beginner,
            resources: [
              HierarchyResourceModel(
                id: 'res_dsa_arr_notes',
                title: 'Array Data Structure Notes & Interview Patterns',
                description: 'Operations, time complexity, and top 20 interview array problems.',
                type: HierarchyResourceType.notes,
                url: 'https://www.geeksforgeeks.org/array-data-structure/',
                platform: 'GeeksforGeeks',
              ),
              HierarchyResourceModel(
                id: 'res_dsa_arr_practice',
                title: 'LeetCode Array Practice Tag',
                description: 'Curated list of array questions on LeetCode with instant online judge.',
                type: HierarchyResourceType.practice,
                url: 'https://leetcode.com/tag/array/',
                platform: 'LeetCode Practice',
              ),
            ],
          ),
          // 3. Linked Lists
          HierarchicalTopicModel(
            id: 'dsa_linked_list',
            title: 'Linked Lists',
            description: 'Singly, Doubly, Circular Linked Lists, Floyd\'s Cycle Detection, list reversal, merge sort on list.',
            level: LearningLevel.beginner,
            resources: [
              HierarchyResourceModel(
                id: 'res_ll_notes',
                title: 'Linked List Data Structure Guide',
                description: 'Node pointers, insertion, deletion, cycle detection, and interview problems.',
                type: HierarchyResourceType.notes,
                url: 'https://www.geeksforgeeks.org/data-structures/linked-list/',
                platform: 'GeeksforGeeks',
              ),
              HierarchyResourceModel(
                id: 'res_ll_practice',
                title: 'LeetCode Linked List Problem Set',
                description: 'Solve top linked list interview problems on LeetCode.',
                type: HierarchyResourceType.practice,
                url: 'https://leetcode.com/tag/linked-list/',
                platform: 'LeetCode Practice',
              ),
            ],
          ),
          // 4. Stacks & Queues
          HierarchicalTopicModel(
            id: 'dsa_stacks_queues',
            title: 'Stacks & Queues',
            description: 'LIFO & FIFO semantics, Monotonic Stack, Next Greater Element, Circular Queue, Deque.',
            level: LearningLevel.beginner,
            resources: [
              HierarchyResourceModel(
                id: 'res_sq_notes',
                title: 'Stacks & Queues Concept Guide',
                description: 'Infix/Postfix conversion, parenthesis matching, stack using queue.',
                type: HierarchyResourceType.notes,
                url: 'https://www.geeksforgeeks.org/stack-data-structure/',
                platform: 'GeeksforGeeks',
              ),
            ],
          ),
          // 5. Trees & BST
          HierarchicalTopicModel(
            id: 'dsa_trees',
            title: 'Trees & Binary Search Trees (BST)',
            description: 'Binary Tree traversals (Inorder, Preorder, Postorder, Level Order), BST properties, LCA, AVL Trees.',
            level: LearningLevel.intermediate,
            resources: [
              HierarchyResourceModel(
                id: 'res_tree_notes',
                title: 'Binary Tree & BST Master Guide',
                description: 'Recursive & iterative traversals, height, diameter, and BST operations.',
                type: HierarchyResourceType.notes,
                url: 'https://www.geeksforgeeks.org/binary-tree-data-structure/',
                platform: 'GeeksforGeeks',
              ),
              HierarchyResourceModel(
                id: 'res_tree_practice',
                title: 'LeetCode Tree Problems',
                description: 'Solve tree & BST interview questions on LeetCode.',
                type: HierarchyResourceType.practice,
                url: 'https://leetcode.com/tag/tree/',
                platform: 'LeetCode',
              ),
            ],
          ),
          // 6. Graphs & Algorithms
          HierarchicalTopicModel(
            id: 'dsa_graphs',
            title: 'Graphs & Graph Algorithms',
            description: 'Adjacency List/Matrix, BFS, DFS, Dijkstra, Bellman-Ford, Floyd-Warshall, Topological Sort, Kruskal, Prim.',
            level: LearningLevel.advanced,
            resources: [
              HierarchyResourceModel(
                id: 'res_graph_notes',
                title: 'Graph Data Structure & Shortest Path Guide',
                description: 'Graph representations, traversal algorithms, shortest paths & minimum spanning trees.',
                type: HierarchyResourceType.notes,
                url: 'https://www.geeksforgeeks.org/graph-data-structure-and-algorithms/',
                platform: 'GeeksforGeeks',
              ),
              HierarchyResourceModel(
                id: 'res_graph_practice',
                title: 'LeetCode Graph Problem Set',
                description: 'Solve top graph interview questions on LeetCode.',
                type: HierarchyResourceType.practice,
                url: 'https://leetcode.com/tag/graph/',
                platform: 'LeetCode',
              ),
            ],
          ),
          // 7. Dynamic Programming
          HierarchicalTopicModel(
            id: 'dsa_dp',
            title: 'Dynamic Programming (DP)',
            description: 'Memoization (Top-down) vs Tabulation (Bottom-up), 0/1 Knapsack, Unbounded Knapsack, LCS, LIS, Matrix Chain.',
            level: LearningLevel.advanced,
            resources: [
              HierarchyResourceModel(
                id: 'res_dp_notes',
                title: 'Dynamic Programming Master Patterns Sheet',
                description: 'Breakdown of standard DP patterns: Subsets, Grid DP, Strings DP, and State Compression.',
                type: HierarchyResourceType.notes,
                url: 'https://www.geeksforgeeks.org/dynamic-programming/',
                platform: 'GeeksforGeeks',
              ),
              HierarchyResourceModel(
                id: 'res_dp_practice',
                title: 'LeetCode Dynamic Programming Tag',
                description: 'Curated list of DP problems from easy to hard on LeetCode.',
                type: HierarchyResourceType.practice,
                url: 'https://leetcode.com/tag/dynamic-programming/',
                platform: 'LeetCode',
              ),
            ],
          ),
        ],
      ),

      // Category 4: Web Development
      CategoryModel(
        id: 'web_dev',
        title: 'Web Development',
        description: 'HTML5, CSS3, JavaScript, React, Node.js, Express, REST APIs & Fullstack Web Architecture.',
        icon: Icons.web_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'web_html_css',
            title: 'Frontend: HTML5, CSS3 & Responsive Design',
            description: 'Semantic tags, Flexbox, CSS Grid, media queries, accessibility (a11y), responsive design.',
            resources: [
              HierarchyResourceModel(
                id: 'res_web_html_online',
                title: 'MDN Web Docs: HTML & CSS',
                description: 'Official Mozilla Developer Network guides for web fundamentals.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://developer.mozilla.org/en-US/docs/Learn',
                platform: 'MDN Web Docs Official',
              ),
              HierarchyResourceModel(
                id: 'res_web_w3',
                title: 'W3Schools HTML & CSS Tutorial',
                description: 'Interactive browser tutorial for HTML5 and CSS3.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.w3schools.com/html/',
                platform: 'W3Schools Interactive',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'web_react',
            title: 'Frontend Framework: React',
            description: 'JSX, Components, Props, State (`useState`, `useEffect`), Custom Hooks, Context API, Redux/Zustand.',
            resources: [
              HierarchyResourceModel(
                id: 'res_react_docs',
                title: 'Official React Documentation',
                description: 'Official interactive documentation for React framework.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://react.dev/',
                platform: 'React.dev Official',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'web_backend_node',
            title: 'Backend: Node.js & Express.js',
            description: 'Event loop, Asynchronous I/O, Express routing, Middleware, JWT authentication, RESTful APIs.',
            resources: [
              HierarchyResourceModel(
                id: 'res_node_docs',
                title: 'Node.js Official Guides & API Docs',
                description: 'Official Node.js documentation and tutorial guides.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://nodejs.org/en/docs/guides/',
                platform: 'Nodejs.org Official',
              ),
            ],
          ),
        ],
      ),

      // Category 5: App Development
      CategoryModel(
        id: 'app_dev',
        title: 'App Development',
        description: 'Flutter, Dart, Android (Kotlin), State Management, Firebase & Mobile App Architecture.',
        icon: Icons.phone_android_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'flutter_basics',
            title: 'Flutter & Dart Framework Overview',
            description: 'Stateless vs Stateful Widgets, Provider/Riverpod/Bloc state management, HTTP networking, SQLite/Hive.',
            resources: [
              HierarchyResourceModel(
                id: 'res_flutter_online',
                title: 'Official Flutter Documentation & Guides',
                description: 'Official Flutter framework guides, widget catalog, and API documentation.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://docs.flutter.dev/',
                platform: 'Flutter.dev Official',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'kotlin_android',
            title: 'Android Development with Kotlin',
            description: 'Kotlin syntax, Jetpack Compose UI, ViewModel, LiveData, Room Database, Retrofit API calls.',
            resources: [
              HierarchyResourceModel(
                id: 'res_kotlin_docs',
                title: 'Android Developers Kotlin Training Portal',
                description: 'Official Google Android developer Kotlin courses and documentation.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://developer.android.com/courses/kotlin-android-basics/course',
                platform: 'Android Developers Official',
              ),
            ],
          ),
        ],
      ),

      // Category 6: Databases
      CategoryModel(
        id: 'databases',
        title: 'Databases & Data Management',
        description: 'Relational Databases (MySQL, PostgreSQL), NoSQL (MongoDB, Firebase), Caching (Redis) & Database Design.',
        icon: Icons.storage_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'sql_basics',
            title: 'Relational Databases & SQL',
            description: 'Entity-Relationship (ER) diagrams, Normalization (1NF to 3NF), JOINs, Indexing, ACID properties.',
            resources: [
              HierarchyResourceModel(
                id: 'res_sql_notes',
                title: 'SQL & Database Design Essentials Guide',
                description: 'SELECT, INSERT, UPDATE, DELETE, JOINs, indexing & transaction isolation levels.',
                type: HierarchyResourceType.notes,
                url: 'https://www.w3schools.com/sql/',
                platform: 'W3Schools',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'nosql_mongo',
            title: 'NoSQL Databases & MongoDB',
            description: 'Document databases, BSON format, Aggregation pipeline, Mongoose ORM, Redis caching concepts.',
            resources: [
              HierarchyResourceModel(
                id: 'res_mongo_docs',
                title: 'MongoDB University & Manual',
                description: 'Official MongoDB manual and free interactive developer courses.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.mongodb.com/docs/manual/',
                platform: 'MongoDB Official Docs',
              ),
            ],
          ),
        ],
      ),

      // Category 7: Git & Software Engineering
      CategoryModel(
        id: 'git_github',
        title: 'Git, GitHub & Software Engineering',
        description: 'Version control, Git branching strategies, Pull Requests, CI/CD pipelines, Clean Code & Design Patterns.',
        icon: Icons.merge_type_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'git_basics',
            title: 'Git & GitHub Fundamentals',
            description: 'git init, commit, push, pull, branch, merge, rebase, cherry-pick, resolving merge conflicts.',
            resources: [
              HierarchyResourceModel(
                id: 'res_git_notes',
                title: 'GitHub Education Git Cheat Sheet',
                description: 'Essential git commands cheat sheet for developers.',
                type: HierarchyResourceType.notes,
                url: 'https://education.github.com/git-cheat-sheet-education.pdf',
                platform: 'GitHub Education',
              ),
              HierarchyResourceModel(
                id: 'res_git_online',
                title: 'Official Git Reference Manual',
                description: 'Official Git documentation and Pro Git book.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://git-scm.com/doc',
                platform: 'Git-SCM Official',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'clean_code_design_patterns',
            title: 'Clean Code & Design Patterns',
            description: 'SOLID Principles, Design Patterns (Singleton, Factory, Observer, Strategy), Code refactoring.',
            resources: [
              HierarchyResourceModel(
                id: 'res_patterns_online',
                title: 'Refactoring.Guru Design Patterns',
                description: 'Visual explanation of software design patterns and refactoring techniques.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://refactoring.guru/design-patterns',
                platform: 'Refactoring.Guru',
              ),
            ],
          ),
        ],
      ),
    ],
  );

  // ==========================================
  // 2. EMERGING TECHNOLOGIES HUB (FUTURE TECH)
  // ==========================================
  static const HubModel emergingTechHub = HubModel(
    id: 'emerging_tech',
    title: 'Emerging Technologies',
    description: 'Explore AI, Machine Learning, Deep Learning, GenAI, Cloud Computing, DevOps & Cybersecurity.',
    icon: Icons.smart_toy_rounded,
    routeName: '/career',
    startHereSteps: [
      StartHereStepModel(
        stepNumber: 1,
        title: 'Understand the AI & Future Tech Landscape',
        description: 'Explore how Artificial Intelligence, Cloud, and DevOps shape global computing careers.',
        targetCategoryId: 'ai_ml',
      ),
      StartHereStepModel(
        stepNumber: 2,
        title: 'Master Machine Learning Fundamentals',
        description: 'Learn NumPy, Pandas, Scikit-Learn, Supervised/Unsupervised models & Evaluation metrics.',
        targetCategoryId: 'ai_ml',
      ),
      StartHereStepModel(
        stepNumber: 3,
        title: 'Deep Learning & Generative AI',
        description: 'Train Neural Networks with PyTorch/TensorFlow, Transformers, LLMs, RAG & Fine-tuning.',
        targetCategoryId: 'ai_ml',
      ),
      StartHereStepModel(
        stepNumber: 4,
        title: 'Cloud & DevOps Infrastructure',
        description: 'Master AWS, Docker containerization, Kubernetes orchestration & CI/CD deployment.',
        targetCategoryId: 'cloud_computing',
      ),
    ],
    categories: [
      // Category 1: Artificial Intelligence & Machine Learning
      CategoryModel(
        id: 'ai_ml',
        title: 'Artificial Intelligence & Machine Learning',
        description: 'Supervised ML, Deep Learning, Computer Vision, Natural Language Processing, GenAI & LLMs.',
        icon: Icons.psychology_rounded,
        availableLevels: [
          LearningLevel.beginner,
          LearningLevel.intermediate,
          LearningLevel.advanced,
        ],
        topics: [
          HierarchicalTopicModel(
            id: 'machine_learning',
            title: 'Machine Learning',
            description: 'Supervised, Unsupervised, and Reinforcement learning algorithms & mathematical foundations.',
            icon: Icons.memory_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'ml_intro_beginner',
                title: 'Introduction to Machine Learning',
                description: 'Core concepts of ML: Features, Labels, Training vs Testing, Linear Regression.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_ml_notes',
                    title: 'Machine Learning Basics & Scikit-Learn Notes',
                    description: 'Concise intro to supervised vs unsupervised learning and evaluation metrics.',
                    type: HierarchyResourceType.notes,
                    url: 'https://scikit-learn.org/stable/getting_started.html',
                    platform: 'Scikit-Learn Docs',
                  ),
                  HierarchyResourceModel(
                    id: 'res_ml_video',
                    title: 'Machine Learning Course for Beginners',
                    description: 'Comprehensive 4-hour video course on ML algorithms and Python setup.',
                    type: HierarchyResourceType.video,
                    url: 'https://www.youtube.com/watch?v=i_LwzRVP7bg',
                    platform: 'YouTube / freeCodeCamp',
                  ),
                  HierarchyResourceModel(
                    id: 'res_ml_practice',
                    title: 'Kaggle Beginner ML Micro-Course',
                    description: 'Practical exercises building your first Decision Tree and Random Forest models.',
                    type: HierarchyResourceType.practice,
                    url: 'https://www.kaggle.com/learn/intro-to-machine-learning',
                    platform: 'Kaggle',
                  ),
                  HierarchyResourceModel(
                    id: 'res_ml_learn_online',
                    title: 'Learn Machine Learning Online',
                    description: 'Interactive Andrew Ng Machine Learning Specialization & Open Source Course.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.coursera.org/specializations/machine-learning-introduction',
                    platform: 'Coursera / Stanford AI',
                  ),
                  HierarchyResourceModel(
                    id: 'res_ml_project',
                    title: 'Project: House Price Predictor',
                    description: 'Build a Scikit-Learn regression model to predict housing prices.',
                    type: HierarchyResourceType.project,
                    url: 'https://github.com/scikit-learn/scikit-learn',
                    platform: 'GitHub Repository',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'deep_learning',
            title: 'Deep Learning & Neural Networks',
            description: 'Artificial Neural Networks (ANN), CNNs for vision, RNNs/LSTMs, Transformers.',
            icon: Icons.auto_awesome_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'dl_intro',
                title: 'Neural Networks Basics',
                description: 'Perceptrons, activation functions (ReLU, Softmax), backpropagation.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_dl_online',
                    title: 'Deep Learning TensorFlow Guide',
                    description: 'Official Keras and TensorFlow beginner documentation.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.tensorflow.org/tutorials',
                    platform: 'TensorFlow Official',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'genai_llms',
            title: 'Generative AI & LLMs',
            description: 'Large Language Models, Embeddings, RAG (Retrieval-Augmented Generation), Prompt Engineering, Fine-tuning.',
            level: LearningLevel.advanced,
            resources: [
              HierarchyResourceModel(
                id: 'res_genai_online',
                title: 'Hugging Face Course & Transformer Docs',
                description: 'Official Hugging Face NLP and Transformer library documentation.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://huggingface.co/course/chapter1/1',
                platform: 'Hugging Face Official',
              ),
            ],
          ),
        ],
      ),

      // Category 2: Cloud Computing & DevOps
      CategoryModel(
        id: 'cloud_computing',
        title: 'Cloud Computing & DevOps',
        description: 'AWS, Google Cloud, Azure, Docker containers, Kubernetes orchestration & CI/CD automation.',
        icon: Icons.cloud_done_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'aws_basics',
            title: 'AWS Cloud Fundamentals',
            description: 'EC2 compute instances, S3 object storage, IAM security policies, AWS Lambda serverless.',
            resources: [
              HierarchyResourceModel(
                id: 'res_aws_online',
                title: 'AWS Educator & Practitioner Portal',
                description: 'Official AWS practitioner documentation and hands-on labs.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://aws.amazon.com/getting-started/',
                platform: 'AWS Official',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'devops_docker',
            title: 'DevOps: Docker & Containers',
            description: 'Containerization basics, Dockerfile, Docker Compose, multi-stage builds.',
            resources: [
              HierarchyResourceModel(
                id: 'res_docker_online',
                title: 'Official Docker Manual',
                description: 'Official Docker getting started documentation.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://docs.docker.com/get-started/',
                platform: 'Docker Official Docs',
              ),
            ],
          ),
        ],
      ),

      // Category 3: Cybersecurity
      CategoryModel(
        id: 'cybersecurity',
        title: 'Cybersecurity & Ethical Hacking',
        description: 'Network security, cryptography, penetration testing & OWASP Web Security.',
        icon: Icons.security_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'cyber_intro',
            title: 'Network & Web Security (OWASP)',
            description: 'Firewalls, Wireshark packet inspection, OWASP Top 10 vulnerabilities, SQL injection, XSS.',
            resources: [
              HierarchyResourceModel(
                id: 'res_owasp_online',
                title: 'OWASP Top 10 Vulnerabilities Guide',
                description: 'Standard security awareness guide for web developers.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://owasp.org/www-project-top-ten/',
                platform: 'OWASP Official',
              ),
            ],
          ),
        ],
      ),
    ],
  );

  // ==========================================
  // 3. HIGHER EDUCATION HUB (EXAMS & DEGREES)
  // ==========================================
  static const HubModel higherEducationHub = HubModel(
    id: 'higher_education',
    title: 'Higher Education & Exams',
    description: 'Explore Master\'s degrees, GATE, CAT, GRE, TOEFL, IELTS, GMAT, Study Abroad & Research Fellowships.',
    icon: Icons.school_rounded,
    routeName: '/higher-education',
    startHereSteps: [
      StartHereStepModel(
        stepNumber: 1,
        title: 'Explore Postgraduate Pathways',
        description: 'Compare M.Tech, M.S. Abroad, MBA, MCA, and PhD doctoral research degrees.',
        targetCategoryId: 'pg_studies',
      ),
      StartHereStepModel(
        stepNumber: 2,
        title: 'Prepare for Competitive Exams',
        description: 'Access syllabus, past papers, and prep portals for GATE, GRE, GMAT, IELTS, and TOEFL.',
        targetCategoryId: 'entrance_exams',
      ),
      StartHereStepModel(
        stepNumber: 3,
        title: 'Study Abroad Guidance',
        description: 'University selection, SOP/LOR writing, application timelines, and visa interviews.',
        targetCategoryId: 'study_abroad',
      ),
      StartHereStepModel(
        stepNumber: 4,
        title: 'Scholarships & Financial Aid',
        description: 'Discover government scholarships, university assistantships (TA/RA), and international grants.',
        targetCategoryId: 'scholarships_aid',
      ),
    ],
    categories: [
      // Category 1: Postgraduate Studies
      CategoryModel(
        id: 'pg_studies',
        title: 'Postgraduate Studies',
        description: 'Explore Master\'s Degree, M.Tech, MBA, MCA, MS, and PhD pathways.',
        icon: Icons.workspace_premium_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'masters_degree',
            title: 'Master\'s Degree Overview',
            description: 'Graduate level academic degrees focusing on advanced specialization and research.',
            icon: Icons.school_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'choosing_masters',
                title: 'Choosing a Master\'s Program',
                description: 'Key criteria for selecting degree specializations, course structures & credit requirements.',
                resources: [
                  HierarchyResourceModel(
                    id: 'res_masters_notes',
                    title: 'Master\'s Degree Selection Guide',
                    description: 'Comprehensive breakdown of MSc vs MA vs MS programs and course structures.',
                    type: HierarchyResourceType.notes,
                    url: 'https://www.prospects.ac.uk/postgraduate-study/masters-degrees/choosing-a-masters-degree',
                    platform: 'Prospects UK Guide',
                  ),
                  HierarchyResourceModel(
                    id: 'res_masters_online',
                    title: 'Learn Online: Choosing a Master\'s Program',
                    description: 'Interactive online guide on choosing the right postgraduate master\'s degree.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.prospects.ac.uk/postgraduate-study/masters-degrees/choosing-a-masters-degree',
                    platform: 'Prospects UK',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'mtech',
            title: 'M.Tech (Master of Technology)',
            description: 'Advanced technical specialization degrees at IITs, NITs, and premier institutes via GATE score.',
            icon: Icons.engineering_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'mtech_admission',
                title: 'Admission & Preparation',
                description: 'GATE score requirements, CCMT counseling, and specialization branches.',
                resources: [
                  HierarchyResourceModel(
                    id: 'res_mtech_notes',
                    title: 'M.Tech Admission & Cutoff Guide',
                    description: 'IIT & NIT M.Tech cutoff trends and specializations overview.',
                    type: HierarchyResourceType.notes,
                    url: 'https://gate.iisc.ac.in/',
                    platform: 'IISc GATE Portal',
                  ),
                  HierarchyResourceModel(
                    id: 'res_mtech_online',
                    title: 'Learn Online: M.Tech Admission Portal',
                    description: 'Official IISc & IIT GATE examination and M.Tech admission portal.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://gate.iisc.ac.in/',
                    platform: 'GATE IISc',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'mba',
            title: 'MBA (Master of Business Administration)',
            description: 'Business management, tech leadership, product management, and corporate strategy.',
            icon: Icons.business_center_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'mba_fundamentals',
                title: 'MBA Fundamentals & Admissions',
                description: 'CAT, GMAT, b-school shortlisting, and profile building.',
                resources: [
                  HierarchyResourceModel(
                    id: 'res_mba_online',
                    title: 'Learn Online: Official MBA Portal',
                    description: 'Official GMAT and global business school planning portal.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.mba.com/',
                    platform: 'mba.com Official',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Category 2: Entrance Exams
      CategoryModel(
        id: 'entrance_exams',
        title: 'Entrance Exams',
        description: 'Syllabus, question papers & preparation for GATE, GRE, GMAT, IELTS, and TOEFL.',
        icon: Icons.quiz_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'exam_gate',
            title: 'GATE (Graduate Aptitude Test in Engineering)',
            description: 'National level examination for M.Tech admissions at IITs & PSU recruitment.',
            icon: Icons.menu_book_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'gate_cs_prep',
                title: 'GATE CS / IT Preparation',
                description: 'Complete subject wise preparation and previous year question solutions.',
                resources: [
                  HierarchyResourceModel(
                    id: 'res_gate_cs_notes',
                    title: 'GATE CS Formula & Notes Sheet',
                    description: 'Complete subject wise notes for Algorithms, OS, DBMS & TOC.',
                    type: HierarchyResourceType.notes,
                    url: 'https://gateoverflow.in/',
                    platform: 'GATE Overflow Notes',
                  ),
                  HierarchyResourceModel(
                    id: 'res_gate_cs_online',
                    title: 'Learn Online: GATE Overflow',
                    description: 'Community-verified solutions for all GATE CS papers.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://gateoverflow.in/',
                    platform: 'GATE Overflow',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'exam_gre',
            title: 'GRE (Graduate Record Examination)',
            description: 'Standardized test for MS & PhD admissions at top international universities.',
            icon: Icons.assignment_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'gre_general',
                title: 'GRE General Test Prep',
                description: 'Verbal reasoning, Quantitative reasoning, and Analytical Writing (AWA).',
                resources: [
                  HierarchyResourceModel(
                    id: 'res_gre_general_online',
                    title: 'Learn Online: ETS Official GRE',
                    description: 'Official ETS GRE test preparation and practice portal.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.ets.org/gre.html',
                    platform: 'ETS GRE Official',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Category 3: Study Abroad
      CategoryModel(
        id: 'study_abroad',
        title: 'Study Abroad',
        description: 'Country selection, university shortlisting, applications, visas, and scholarships.',
        icon: Icons.flight_takeoff_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'choosing_country',
            title: 'Choosing a Country',
            description: 'Compare USA, UK, Canada, Germany, Australia for tuition, post-study work & living.',
            resources: [
              HierarchyResourceModel(
                id: 'res_country_online',
                title: 'Study in Europe & Overseas Guide',
                description: 'Explore top study destinations, tuition fees, and post-study work visas.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.study.eu/',
                platform: 'Study.eu Portal',
              ),
            ],
          ),
        ],
      ),

      // Category 4: Scholarships & Financial Aid
      CategoryModel(
        id: 'scholarships_aid',
        title: 'Scholarships & Financial Aid',
        description: 'Government schemes, university fellowships, international grants & merit aid.',
        icon: Icons.payments_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'govt_scholarships',
            title: 'Government Scholarships',
            description: 'Central and state government student scholarships and research fellowships.',
            resources: [
              HierarchyResourceModel(
                id: 'res_govt_schol_online',
                title: 'National Scholarship Portal (NSP)',
                description: 'Official Government of India national scholarship portal.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://scholarships.gov.in/',
                platform: 'NSP Govt Portal',
              ),
            ],
          ),
        ],
      ),
    ],
  );

  // ==========================================
  // 4. PLACEMENT HUB (CAREER READY PREPARATION)
  // ==========================================
  static const HubModel placementHub = HubModel(
    id: 'placement',
    title: 'Placement Hub',
    description: 'Technical interview prep, DSA problem solving, aptitude, HR questions & job search guides.',
    icon: Icons.work_rounded,
    routeName: '/placement',
    startHereSteps: [
      StartHereStepModel(
        stepNumber: 1,
        title: 'Master Programming Language & Logic',
        description: 'Pick C++, Java, or Python and learn fundamental syntax & logic building.',
        targetCategoryId: 'tech_prep',
      ),
      StartHereStepModel(
        stepNumber: 2,
        title: 'Conquer DSA Interview Patterns',
        description: 'Master Arrays, Strings, Linked Lists, Trees, Graphs & Dynamic Programming.',
        targetCategoryId: 'tech_prep',
      ),
      StartHereStepModel(
        stepNumber: 3,
        title: 'Revise Core CS Subjects',
        description: 'Review Operating Systems, DBMS, SQL, Computer Networks, and OOP concepts.',
        targetCategoryId: 'tech_prep',
      ),
      StartHereStepModel(
        stepNumber: 4,
        title: 'Master Aptitude & Reasoning',
        description: 'Practice Quantitative Aptitude, Logical Reasoning, and Verbal Ability questions.',
        targetCategoryId: 'aptitude_prep',
      ),
      StartHereStepModel(
        stepNumber: 5,
        title: 'Resume & Portfolio Building',
        description: 'Draft an ATS-friendly single page technical resume and optimize LinkedIn/GitHub.',
        targetCategoryId: 'resume_profile',
      ),
      StartHereStepModel(
        stepNumber: 6,
        title: 'Mock Interviews & Application',
        description: 'Practice mock technical and HR rounds using the STAR framework.',
        targetCategoryId: 'interview_prep',
      ),
    ],
    categories: [
      // Category 1: Technical Preparation
      CategoryModel(
        id: 'tech_prep',
        title: 'Technical Preparation',
        description: 'Data Structures, Algorithms, Programming Languages, DBMS, OS, Computer Networks & SQL.',
        icon: Icons.terminal_rounded,
        availableLevels: [
          LearningLevel.beginner,
          LearningLevel.intermediate,
          LearningLevel.advanced,
        ],
        topics: [
          HierarchicalTopicModel(
            id: 'placement_dsa',
            title: 'Data Structures & Algorithms Interview Prep',
            description: 'Arrays, Strings, Linked Lists, Stacks, Queues, Trees, Graphs, Sorting & DP.',
            icon: Icons.account_tree_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'dsa_top_interview_topic',
                title: 'Top Interview Coding Patterns',
                description: 'Two Pointers, Sliding Window, Fast & Slow Pointers, Monotonic Stack.',
                level: LearningLevel.intermediate,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_dsa_top_notes',
                    title: 'DSA Interview Master Sheet',
                    description: '150 handpicked coding interview questions with optimal time complexities.',
                    type: HierarchyResourceType.notes,
                    url: 'https://takeuforward.org/strivers-a2zdsa-course/strivers-a2z-dsa-course-sheet-2/',
                    platform: 'Striver A2Z DSA Sheet',
                  ),
                  HierarchyResourceModel(
                    id: 'res_dsa_top_video',
                    title: 'Top 10 Coding Interview Patterns',
                    description: 'Video walkthrough explaining sliding window and two-pointer techniques.',
                    type: HierarchyResourceType.video,
                    url: 'https://www.youtube.com/watch?v=0k7j015X27c',
                    platform: 'YouTube',
                  ),
                  HierarchyResourceModel(
                    id: 'res_dsa_top_practice',
                    title: 'Practice DSA Interview Questions',
                    description: 'Solve top interview coding problems interactively on GeeksforGeeks and LeetCode.',
                    type: HierarchyResourceType.practice,
                    url: 'https://practice.geeksforgeeks.org/explore?page=1&curated[]=1',
                    platform: 'GeeksforGeeks Practice Portal',
                  ),
                  HierarchyResourceModel(
                    id: 'res_dsa_top_online',
                    title: 'LeetCode 75 Study Plan',
                    description: 'Curated list of 75 essential coding questions for tech interviews.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://leetcode.com/studyplan/leetcode-75/',
                    platform: 'LeetCode Official',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Category 2: Aptitude
      CategoryModel(
        id: 'aptitude_prep',
        title: 'Aptitude & Reasoning',
        description: 'Quantitative Aptitude, Logical Reasoning & Verbal Ability for campus screening tests.',
        icon: Icons.calculate_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'quant_aptitude',
            title: 'Quantitative Aptitude',
            description: 'Percentages, Profit & Loss, Time & Work, Speed Distance & Time, Ratios, Probability.',
            icon: Icons.functions_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'percentages_topic',
                title: 'Percentages',
                description: 'Percentage increase/decrease, successive percentage changes, and application formulas.',
                subtopics: [
                  HierarchicalTopicModel(
                    id: 'percentages_basics',
                    title: 'Percentages Fundamentals',
                    description: 'Basic percentage conversions, fraction shortcuts, and practice questions.',
                    resources: [
                      HierarchyResourceModel(
                        id: 'res_percent_practice',
                        title: 'Practice: IndiaBIX Percentages Questions',
                        description: 'Solve interactive percentage questions with step-by-step solutions.',
                        type: HierarchyResourceType.practice,
                        url: 'https://www.indiabix.com/aptitude/percentage/',
                        platform: 'IndiaBIX Practice',
                      ),
                      HierarchyResourceModel(
                        id: 'res_percent_online',
                        title: 'Learn Online: Percentages Shortcuts & Formulas',
                        description: 'Learn speed math shortcuts and percentage formulas.',
                        type: HierarchyResourceType.learnOnline,
                        url: 'https://www.indiabix.com/aptitude/percentage/formulas',
                        platform: 'IndiaBIX Formulas',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Category 3: Communication & HR
      CategoryModel(
        id: 'communication_hr',
        title: 'Communication & HR Interviews',
        description: 'HR interview questions, behavioral frameworks & the STAR method.',
        icon: Icons.people_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'hr_questions',
            title: 'HR Interview Preparation',
            description: 'Standard HR questions: Tell me about yourself, Strengths & Weaknesses, 5-year goal.',
            subtopics: [
              HierarchicalTopicModel(
                id: 'hr_common_q',
                title: 'Common HR Interview Questions',
                description: 'Sample responses and frameworks for HR behavioral rounds.',
                resources: [
                  HierarchyResourceModel(
                    id: 'res_hr_practice',
                    title: 'Practice: Top 50 HR Interview Questions',
                    description: 'Practice questions and sample responses for HR rounds.',
                    type: HierarchyResourceType.practice,
                    url: 'https://www.geeksforgeeks.org/hr-interview-questions/',
                    platform: 'GeeksforGeeks',
                  ),
                  HierarchyResourceModel(
                    id: 'res_hr_online',
                    title: 'Learn Online: Behavioral HR Interview Guide',
                    description: 'Comprehensive guide to answering HR questions effectively.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.geeksforgeeks.org/hr-interview-questions/',
                    platform: 'GeeksforGeeks Portal',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Category 4: Resume & Profile
      CategoryModel(
        id: 'resume_profile',
        title: 'Resume & Profile',
        description: 'Technical resume building, ATS templates, LinkedIn optimization & GitHub profile.',
        icon: Icons.badge_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'resume_building',
            title: 'Resume Building & Templates',
            description: 'ATS-friendly resume templates, action verbs, project formatting & metric outcomes.',
            subtopics: [
              HierarchicalTopicModel(
                id: 'creating_student_resume',
                title: 'Creating a Technical Student Resume',
                description: 'Single page LaTeX and Markdown templates tailored for computer science students.',
                resources: [
                  HierarchyResourceModel(
                    id: 'res_student_resume_notes',
                    title: 'Technical Student Resume Guide',
                    description: 'Step-by-step checklist for section ordering, skills list, and project bullet points.',
                    type: HierarchyResourceType.notes,
                    url: 'https://www.overleaf.com/latex/templates/jakes-resume/syzsqfdxflqy',
                    platform: 'Jake\'s Resume Guide',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Category 5: Interview Preparation
      CategoryModel(
        id: 'interview_prep',
        title: 'Interview Preparation',
        description: 'Technical interviews, coding rounds, HR rounds, mock interviews & STAR method.',
        icon: Icons.quiz_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'technical_interviews',
            title: 'Technical Interview Preparation',
            description: 'System design basics, live coding etiquette, explaining complexity & thinking aloud.',
            subtopics: [
              HierarchicalTopicModel(
                id: 'tech_interview_basics',
                title: 'Technical Interview Basics',
                description: 'Preparation strategies for live whiteboarding and technical problem solving.',
                resources: [
                  HierarchyResourceModel(
                    id: 'res_tech_interview_practice',
                    title: 'Practice: LeetCode 75 Study Plan',
                    description: '75 essential technical coding interview problems.',
                    type: HierarchyResourceType.practice,
                    url: 'https://leetcode.com/studyplan/leetcode-75/',
                    platform: 'LeetCode Study Plan',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Category 6: Job Search
      CategoryModel(
        id: 'job_search',
        title: 'Job Search & Off-Campus Drives',
        description: 'Campus placements, internships, off-campus applications & job portals.',
        icon: Icons.work_history_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'job_portals',
            title: 'Job Portals & Applications',
            description: 'Leveraging LinkedIn Jobs, Instahyre, Wellfound (AngelList), and Glassdoor.',
            resources: [
              HierarchyResourceModel(
                id: 'res_linkedin_jobs_online',
                title: 'Learn Online: LinkedIn Jobs Portal',
                description: 'Official LinkedIn jobs search and placement application platform.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.linkedin.com/jobs/',
                platform: 'LinkedIn Jobs',
              ),
            ],
          ),
        ],
      ),
    ],
  );

  // ==========================================
  // 5. PROJECTS & PRACTICE HUB
  // ==========================================
  static const HubModel projectsHub = HubModel(
    id: 'projects',
    title: 'Projects & Practice',
    description: 'Real-world project blueprints, source code repositories & interactive coding practice.',
    icon: Icons.rocket_launch_rounded,
    routeName: '/projects',
    startHereSteps: [
      StartHereStepModel(
        stepNumber: 1,
        title: 'Build Beginner Mini-Projects',
        description: 'Start with Calculator, To-Do List, and Expense Tracker to master basic state & UI.',
        targetCategoryId: 'beginner_projects',
      ),
      StartHereStepModel(
        stepNumber: 2,
        title: 'Build Responsive Web Applications',
        description: 'Construct Personal Portfolio, Blog Website, E-Commerce, and Weather Apps.',
        targetCategoryId: 'web_projects',
      ),
      StartHereStepModel(
        stepNumber: 3,
        title: 'Build AI & Machine Learning Blueprints',
        description: 'Implement House Price Predictor, Spam Detection, and NLP Chatbot models.',
        targetCategoryId: 'ai_projects',
      ),
    ],
    categories: [
      CategoryModel(
        id: 'beginner_projects',
        title: 'Beginner Projects',
        description: 'To-Do List, Calculator, Student Record System, and Expense Tracker mini-projects.',
        icon: Icons.lightbulb_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'todo_list_proj',
            title: 'To-Do List Application',
            description: 'Task management application with CRUD operations, completion toggles, and local storage.',
            icon: Icons.check_box_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'build_todo_list',
                title: 'Build a To-Do List App',
                description: 'Step-by-step guide to building a responsive To-Do application.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_todo_notes',
                    title: 'To-Do App Architecture & State Guide',
                    description: 'Architecture breakdown and state management notes.',
                    type: HierarchyResourceType.notes,
                    url: 'https://github.com/topics/todo-list',
                    platform: 'GitHub Guide',
                  ),
                  HierarchyResourceModel(
                    id: 'res_todo_project',
                    title: 'Source Code: To-Do App Starter',
                    description: 'Complete open-source To-Do List starter template on GitHub.',
                    type: HierarchyResourceType.project,
                    url: 'https://github.com/topics/todo-list',
                    platform: 'GitHub Repository',
                  ),
                  HierarchyResourceModel(
                    id: 'res_todo_online',
                    title: 'Learn Online: Build a Vanilla JS / React To-Do List',
                    description: 'Interactive freeCodeCamp tutorial on constructing a complete To-Do app.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.freecodecamp.org/news/build-a-todo-app-with-react/',
                    platform: 'freeCodeCamp',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      CategoryModel(
        id: 'web_projects',
        title: 'Web Projects',
        description: 'Personal Portfolio, Blog Website, E-Commerce, and Weather Application blueprints.',
        icon: Icons.language_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'portfolio_proj',
            title: 'Personal Developer Portfolio',
            description: 'Single page developer portfolio with about, skills, projects, and contact form.',
            resources: [
              HierarchyResourceModel(
                id: 'res_portfolio_notes',
                title: 'Developer Portfolio Design Checklist',
                description: 'Best practices for showcasing projects and contact info.',
                type: HierarchyResourceType.notes,
                url: 'https://github.com/topics/portfolio-website',
                platform: 'GitHub Guide',
              ),
            ],
          ),
        ],
      ),
      CategoryModel(
        id: 'ai_projects',
        title: 'AI & Data Projects',
        description: 'House Price Prediction, Spam Detection, Student Performance Prediction, and Chatbot.',
        icon: Icons.smart_toy_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'house_price_proj',
            title: 'House Price Prediction Model',
            description: 'Scikit-Learn Machine Learning regression model predicting real estate prices.',
            resources: [
              HierarchyResourceModel(
                id: 'res_house_price_notes',
                title: 'Scikit-Learn Regression Pipeline Notes',
                description: 'Data preprocessing, feature scaling, model training, and RMSE metrics.',
                type: HierarchyResourceType.notes,
                url: 'https://scikit-learn.org/stable/tutorial/basic/tutorial.html',
                platform: 'Scikit-Learn Docs',
              ),
            ],
          ),
        ],
      ),
    ],
  );

  // ==========================================
  // 6. ENTREPRENEURSHIP & STARTUP HUB
  // ==========================================
  static const HubModel entrepreneurshipHub = HubModel(
    id: 'entrepreneurship',
    title: 'Entrepreneurship & Startup Hub',
    description: 'Master problem discovery, lean startup principles, MVP development, business models & pitch decks.',
    icon: Icons.rocket_launch_rounded,
    routeName: '/entrepreneurship',
    startHereSteps: [
      StartHereStepModel(
        stepNumber: 1,
        title: 'Discover Real-World Problems',
        description: 'Identify customer pain points, conduct Mom Test interviews, and assess TAM/SAM/SOM market size.',
        targetCategoryId: 'startup_ideation',
      ),
      StartHereStepModel(
        stepNumber: 2,
        title: 'Build a Minimum Viable Product (MVP)',
        description: 'Apply Lean Startup methodology to rapid prototype and test core value propositions.',
        targetCategoryId: 'lean_startup',
      ),
      StartHereStepModel(
        stepNumber: 3,
        title: 'Formulate Business Model & Pitch Deck',
        description: 'Design unit economics, revenue streams, and build investor-ready pitch decks.',
        targetCategoryId: 'fundraising_pitch',
      ),
      StartHereStepModel(
        stepNumber: 4,
        title: 'Fundraising & YC Application',
        description: 'Apply to Y Combinator, angel networks, university incubators, and manage SAFE notes.',
        targetCategoryId: 'fundraising_pitch',
      ),
    ],
    categories: [
      CategoryModel(
        id: 'startup_ideation',
        title: 'Ideation & Problem Discovery',
        description: 'Uncover real customer pain points, conduct interviews, and assess TAM/SAM/SOM market size.',
        icon: Icons.lightbulb_rounded,
        availableLevels: [
          LearningLevel.beginner,
          LearningLevel.intermediate,
          LearningLevel.advanced,
        ],
        topics: [
          HierarchicalTopicModel(
            id: 'problem_discovery',
            title: 'Problem Discovery & Customer Validation',
            description: 'Frameworks for finding genuine customer problems and conducting Mom Test interviews.',
            icon: Icons.search_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'customer_interviews',
                title: 'Customer Discovery & Mom Test',
                description: 'How to talk to users and learn if your business idea is good when everyone is lying to you.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_mom_test_notes',
                    title: 'The Mom Test Summary & Rules',
                    description: 'Golden rules for customer validation interviews without bias.',
                    type: HierarchyResourceType.notes,
                    url: 'https://www.momtestbook.com/',
                    platform: 'The Mom Test Guide',
                  ),
                  HierarchyResourceModel(
                    id: 'res_customer_disc_video',
                    title: 'Y Combinator: How to Talk to Users',
                    description: 'Official YC video on customer discovery techniques.',
                    type: HierarchyResourceType.video,
                    url: 'https://www.youtube.com/watch?v=z1iF1c8w5Lg',
                    platform: 'Y Combinator Channel',
                  ),
                  HierarchyResourceModel(
                    id: 'res_customer_disc_online',
                    title: 'Learn Online: YC Startup School Ideation',
                    description: 'Free interactive YC startup curriculum on ideation and user interviews.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.startupschool.org/',
                    platform: 'Y Combinator Startup School',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      CategoryModel(
        id: 'lean_startup',
        title: 'Lean Startup & MVP Execution',
        description: 'Build-Measure-Learn feedback loops, rapid prototyping, and Minimum Viable Products.',
        icon: Icons.speed_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'mvp_development',
            title: 'Minimum Viable Product (MVP)',
            description: 'Building lean prototypes with no-code tools or minimal full-stack code.',
            resources: [
              HierarchyResourceModel(
                id: 'res_mvp_notes',
                title: 'Lean Startup Methodology & Business Model Canvas',
                description: '9 building blocks of the Business Model Canvas explained.',
                type: HierarchyResourceType.notes,
                url: 'https://www.strategyzer.com/canvas/business-model-canvas',
                platform: 'Strategyzer Guide',
              ),
            ],
          ),
        ],
      ),
      CategoryModel(
        id: 'fundraising_pitch',
        title: 'Fundraising & Pitching',
        description: 'Unit economics, 10-slide pitch decks, angel investors, seed funding & incubator applications.',
        icon: Icons.monetization_on_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'pitch_decks',
            title: 'Crafting Investor Pitch Decks',
            description: 'Structure of winning 10-slide decks: Problem, Solution, Traction, Team, Financials.',
            resources: [
              HierarchyResourceModel(
                id: 'res_pitch_notes',
                title: 'Sequoia Capital Pitch Deck Template',
                description: 'Official 10-slide startup pitch deck framework by Sequoia Capital.',
                type: HierarchyResourceType.notes,
                url: 'https://www.sequoiacap.com/company-building/writing-a-business-plan/',
                platform: 'Sequoia Capital',
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

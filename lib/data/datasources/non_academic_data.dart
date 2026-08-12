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
  ];

  static HubModel? getHubById(String id) {
    try {
      return allHubs.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

  // ==========================================
  // 1. CODING HUB (NEW HIERARCHICAL SYSTEM)
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
        title: 'Computer Basics & Logic',
        description: 'Understand how computers execute programs, binary logic, and basic computational thinking.',
        targetCategoryId: 'programming_basics',
      ),
      StartHereStepModel(
        stepNumber: 2,
        title: 'Programming Basics',
        description: 'Learn fundamental syntax, variables, conditional statements, and loops.',
        targetCategoryId: 'programming_basics',
      ),
      StartHereStepModel(
        stepNumber: 3,
        title: 'Choose a Programming Language',
        description: 'Pick Python, C, C++, Java or JavaScript based on your career goals.',
        targetCategoryId: 'programming_languages',
      ),
      StartHereStepModel(
        stepNumber: 4,
        title: 'Data Structures & Algorithms',
        description: 'Master arrays, lists, stacks, queues, trees, graphs, and algorithmic problem solving.',
        targetCategoryId: 'dsa',
      ),
      StartHereStepModel(
        stepNumber: 5,
        title: 'Build Real-World Projects',
        description: 'Apply your knowledge by building web applications, mobile apps, or automation scripts.',
        targetCategoryId: 'web_dev',
      ),
      StartHereStepModel(
        stepNumber: 6,
        title: 'Placement & Competitive Prep',
        description: 'Solve coding interview problems on LeetCode/GeeksforGeeks and prepare for tech roles.',
        targetCategoryId: 'dsa',
      ),
    ],
    categories: [
      // Category 1: Programming Basics
      CategoryModel(
        id: 'programming_basics',
        title: 'Programming Basics',
        description: 'Fundamental concepts, logic building, pseudo code & problem solving.',
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
                platform: 'UniDocs Guides',
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

      // Category 2: Programming Languages (Includes Flow 1)
      CategoryModel(
        id: 'programming_languages',
        title: 'Programming Languages',
        description: 'Learn Python, C, C++, Java, and JavaScript from beginner to advanced.',
        icon: Icons.laptop_mac_rounded,
        availableLevels: [
          LearningLevel.beginner,
          LearningLevel.intermediate,
          LearningLevel.advanced,
          LearningLevel.projects,
        ],
        topics: [
          // PYTHON (Flow 1 Target)
          HierarchicalTopicModel(
            id: 'python',
            title: 'Python',
            description: 'High-level, readable language widely used in AI, Data Science, and Web Development.',
            icon: Icons.code_rounded,
            subtopics: [
              // Beginner Topics (8 Standard Topics)
              HierarchicalTopicModel(
                id: 'python_basics',
                title: 'Python Basics',
                description: 'Overview of Python language, syntax, interpreter, and execution.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_py_basics_notes',
                    title: 'Python Basics Cheat Sheet',
                    description: 'Quick reference guide for Python syntax, variables, and keywords.',
                    type: HierarchyResourceType.notes,
                    url: 'https://docs.python.org/3/tutorial/introduction.html',
                    platform: 'Official Docs',
                  ),
                  HierarchyResourceModel(
                    id: 'res_py_basics_video',
                    title: 'Python for Absolute Beginners',
                    description: 'Full guided video tutorial covering setup and core syntax.',
                    type: HierarchyResourceType.video,
                    url: 'https://www.youtube.com/watch?v=_uQrJ0TkZlc',
                    platform: 'YouTube / Programming with Mosh',
                  ),
                ],
              ),
              HierarchicalTopicModel(
                id: 'python_variables',
                title: 'Variables & Data Types',
                description: 'Integers, floats, booleans, type casting, dynamic typing, and memory allocation.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_py_var_notes',
                    title: 'Python Variables & Types Notes',
                    description: 'Guide to primitive data types, scope, and mutability.',
                    type: HierarchyResourceType.notes,
                    url: 'https://docs.python.org/3/library/stdtypes.html',
                  ),
                ],
              ),
              HierarchicalTopicModel(
                id: 'python_operators',
                title: 'Operators',
                description: 'Arithmetic, comparison, logical, bitwise, assignment, and identity operators.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_py_op_notes',
                    title: 'Python Operators Guide',
                    description: 'Complete guide to expression evaluation and operator precedence.',
                    type: HierarchyResourceType.notes,
                    url: 'https://www.geeksforgeeks.org/python-operators/',
                  ),
                ],
              ),
              HierarchicalTopicModel(
                id: 'python_conditions',
                title: 'Conditions',
                description: 'If, elif, else statements, nested conditionals, and ternary expressions.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_py_cond_notes',
                    title: 'Python Conditions & Branching',
                    description: 'Detailed guide to control flow and decision-making statements.',
                    type: HierarchyResourceType.notes,
                    url: 'https://docs.python.org/3/tutorial/controlflow.html#if-statements',
                  ),
                ],
              ),
              HierarchicalTopicModel(
                id: 'python_loops',
                title: 'Loops',
                description: 'For loops, while loops, range(), enumerate(), break, continue, and else-with-loops.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_py_loops_notes',
                    title: 'Python Iteration & Loops Guide',
                    description: 'Loop constructs, range generators, and iteration protocols.',
                    type: HierarchyResourceType.notes,
                    url: 'https://docs.python.org/3/tutorial/controlflow.html#for-statements',
                  ),
                ],
              ),
              HierarchicalTopicModel(
                id: 'python_functions',
                title: 'Functions',
                description: 'Defining functions, parameters, default values, *args, **kwargs, and return values.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_py_fn_notes',
                    title: 'Python Functions & Scope',
                    description: 'Master modular programming with functions and lambdas.',
                    type: HierarchyResourceType.notes,
                    url: 'https://docs.python.org/3/tutorial/controlflow.html#defining-functions',
                  ),
                ],
              ),
              // FLOW 1 Target Topic: Python -> Beginner -> Data Structures -> Lists
              HierarchicalTopicModel(
                id: 'python_ds',
                title: 'Data Structures',
                description: 'Built-in Python data structures: Lists, Tuples, Sets, Dictionaries, and Strings.',
                level: LearningLevel.beginner,
                subtopics: [
                  HierarchicalTopicModel(
                    id: 'python_ds_lists',
                    title: 'Lists',
                    description: 'Learn how to store, access, modify and work with collections of values in Python.',
                    level: LearningLevel.beginner,
                    resources: [
                      HierarchyResourceModel(
                        id: 'res_py_lists_notes',
                        title: 'Python Lists & Operations Notes',
                        description: 'Detailed explanation of indexing, slicing, appending, popping, and sorting lists.',
                        type: HierarchyResourceType.notes,
                        url: 'https://docs.python.org/3/tutorial/datastructures.html#more-on-lists',
                        platform: 'UniDocs Notes',
                      ),
                      HierarchyResourceModel(
                        id: 'res_py_lists_video',
                        title: 'Python Lists Tutorial & Deep Dive',
                        description: 'Visual video guide explaining memory representation and performance of Python lists.',
                        type: HierarchyResourceType.video,
                        url: 'https://www.youtube.com/watch?v=tw7ror9x32s',
                        platform: 'YouTube',
                      ),
                      HierarchyResourceModel(
                        id: 'res_py_lists_practice',
                        title: 'List Problem Solving Exercises',
                        description: '20 practical coding problems on array manipulation and list slicing.',
                        type: HierarchyResourceType.practice,
                        url: 'https://www.geeksforgeeks.org/python-list-exercise/',
                        platform: 'GeeksforGeeks',
                      ),
                      HierarchyResourceModel(
                        id: 'res_py_lists_learn_online',
                        title: 'Learn Python Lists Online',
                        description: 'Interactive online documentation and code playground for Python lists.',
                        type: HierarchyResourceType.learnOnline,
                        url: 'https://www.w3schools.com/python/python_lists.asp',
                        platform: 'W3Schools Interactive',
                      ),
                    ],
                  ),
                  HierarchicalTopicModel(
                    id: 'python_ds_tuples',
                    title: 'Tuples',
                    description: 'Immutable sequence data structures in Python.',
                    level: LearningLevel.beginner,
                    resources: [
                      HierarchyResourceModel(
                        id: 'res_py_tuples_notes',
                        title: 'Tuples & Packing/Unpacking',
                        description: 'Understanding immutability and memory efficiency of tuples.',
                        type: HierarchyResourceType.notes,
                        url: 'https://docs.python.org/3/tutorial/datastructures.html#tuples-and-sequences',
                      ),
                    ],
                  ),
                  HierarchicalTopicModel(
                    id: 'python_ds_sets',
                    title: 'Sets',
                    description: 'Unordered collections of unique elements.',
                    level: LearningLevel.beginner,
                    resources: [
                      HierarchyResourceModel(
                        id: 'res_py_sets_online',
                        title: 'Learn Sets Online',
                        description: 'Set operations: union, intersection, difference.',
                        type: HierarchyResourceType.learnOnline,
                        url: 'https://www.w3schools.com/python/python_sets.asp',
                      ),
                    ],
                  ),
                  HierarchicalTopicModel(
                    id: 'python_ds_dicts',
                    title: 'Dictionaries',
                    description: 'Key-value pairs, hash mapping, and lookup methods in Python.',
                    level: LearningLevel.beginner,
                    resources: [
                      HierarchyResourceModel(
                        id: 'res_py_dict_notes',
                        title: 'Python Dictionaries Guide',
                        description: 'Key lookup, iterations, dict comprehensions.',
                        type: HierarchyResourceType.notes,
                        url: 'https://docs.python.org/3/tutorial/datastructures.html#dictionaries',
                      ),
                    ],
                  ),
                  HierarchicalTopicModel(
                    id: 'python_ds_strings',
                    title: 'Strings',
                    description: 'Sequence of characters, string immutability, formatting, and string methods.',
                    level: LearningLevel.beginner,
                    resources: [
                      HierarchyResourceModel(
                        id: 'res_py_str_notes',
                        title: 'Python Strings Masterclass',
                        description: 'Slicing, formatting (f-strings), split, join, and regex basics.',
                        type: HierarchyResourceType.notes,
                        url: 'https://docs.python.org/3/tutorial/introduction.html#text',
                      ),
                    ],
                  ),
                ],
              ),
              HierarchicalTopicModel(
                id: 'python_file_handling',
                title: 'File Handling',
                description: 'Reading and writing files with the `with open()` context manager.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_py_files_notes',
                    title: 'File I/O Notes',
                    description: 'Text and binary file operations in Python.',
                    type: HierarchyResourceType.notes,
                    url: 'https://docs.python.org/3/tutorial/inputoutput.html#reading-and-writing-files',
                  ),
                ],
              ),
              // Intermediate Python
              HierarchicalTopicModel(
                id: 'python_oop',
                title: 'Object-Oriented Programming (OOP)',
                description: 'Classes, Objects, Inheritance, Encapsulation, and Polymorphism in Python.',
                level: LearningLevel.intermediate,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_py_oop_notes',
                    title: 'Python OOP Masterclass',
                    description: 'Class attributes, dunder methods (`__init__`, `__str__`), and inheritance.',
                    type: HierarchyResourceType.notes,
                    url: 'https://realpython.com/python3-object-oriented-programming/',
                  ),
                  HierarchyResourceModel(
                    id: 'res_py_oop_learn_online',
                    title: 'Interactive Python OOP',
                    description: 'Hands-on object-oriented programming tutorial.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.w3schools.com/python/python_classes.asp',
                  ),
                ],
              ),
              // Advanced Python
              HierarchicalTopicModel(
                id: 'python_decorators',
                title: 'Decorators & Generators',
                description: 'Higher-order functions, function decorators, and memory-efficient generators.',
                level: LearningLevel.advanced,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_py_decorators_notes',
                    title: 'Advanced Python Patterns',
                    description: 'Decorators, context managers, and generator expressions.',
                    type: HierarchyResourceType.notes,
                    url: 'https://realpython.com/primer-on-python-decorators/',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'c_lang',
            title: 'C',
            description: 'Foundational procedural language. Pointers, memory allocation, and low-level control.',
            icon: Icons.code_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'c_pointers',
                title: 'Pointers & Memory',
                description: 'Address-of operator, dereferencing, pointer arithmetic, malloc and free.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_c_ptr_notes',
                    title: 'C Pointers Explained',
                    description: 'Visual explanation of memory addresses and pointer variables.',
                    type: HierarchyResourceType.notes,
                    url: 'https://www.geeksforgeeks.org/c-pointers/',
                  ),
                  HierarchyResourceModel(
                    id: 'res_c_ptr_online',
                    title: 'Learn C Online',
                    description: 'Interactive C language tutorial and compiler.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.programiz.com/c-programming',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'cpp_lang',
            title: 'C++',
            description: 'Fast, high-performance OOP language widely used in competitive programming & systems.',
            icon: Icons.code_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'cpp_stl',
                title: 'Standard Template Library (STL)',
                description: 'Vectors, maps, sets, pairs, algorithms (sort, binary_search) in C++.',
                level: LearningLevel.intermediate,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_cpp_stl_notes',
                    title: 'C++ STL Cheat Sheet',
                    description: 'Complete guide to vector, map, set, unordered_map and iterators.',
                    type: HierarchyResourceType.notes,
                    url: 'https://www.geeksforgeeks.org/the-c-standard-template-library-stl/',
                  ),
                  HierarchyResourceModel(
                    id: 'res_cpp_stl_online',
                    title: 'C++ Reference STL',
                    description: 'Comprehensive C++ STL reference manual.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://en.cppreference.com/w/cpp/container',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'java_lang',
            title: 'Java',
            description: 'Robust, object-oriented enterprise language. Platform independent with JVM.',
            icon: Icons.code_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'java_collections',
                title: 'Java Collections Framework',
                description: 'ArrayList, LinkedList, HashMap, HashSet, and PriorityQueue.',
                level: LearningLevel.intermediate,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_java_coll_notes',
                    title: 'Java Collections Guide',
                    description: 'Detailed explanation of interfaces and implementing classes.',
                    type: HierarchyResourceType.notes,
                    url: 'https://docs.oracle.com/javase/tutorial/collections/index.html',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'javascript_lang',
            title: 'JavaScript',
            description: 'The language of the web. Asynchronous programming, DOM manipulation, ES6+ features.',
            icon: Icons.code_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'js_es6',
                title: 'Modern ES6+ JavaScript',
                description: 'Arrow functions, promises, async/await, destructuring, modules.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_js_es6_online',
                    title: 'JavaScript Info Guide',
                    description: 'Modern JavaScript tutorial from basics to advanced.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://javascript.info/',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Category 3: Data Structures & Algorithms
      CategoryModel(
        id: 'dsa',
        title: 'Data Structures & Algorithms',
        description: 'Arrays, Linked Lists, Stacks, Queues, Trees, Graphs, Sorting & Dynamic Programming.',
        icon: Icons.account_tree_rounded,
        availableLevels: [
          LearningLevel.beginner,
          LearningLevel.intermediate,
          LearningLevel.advanced,
        ],
        topics: [
          HierarchicalTopicModel(
            id: 'dsa_arrays',
            title: 'Arrays & Strings',
            description: 'Contiguous memory allocation, two-pointer techniques, sliding window.',
            level: LearningLevel.beginner,
            resources: [
              HierarchyResourceModel(
                id: 'res_dsa_arr_notes',
                title: 'Array Data Structure Notes',
                description: 'Operations, time complexity, and top 15 interview problems.',
                type: HierarchyResourceType.notes,
                url: 'https://www.geeksforgeeks.org/array-data-structure/',
              ),
              HierarchyResourceModel(
                id: 'res_dsa_arr_practice',
                title: 'Practice Array Problems',
                description: 'Curated list of array questions on LeetCode.',
                type: HierarchyResourceType.practice,
                url: 'https://leetcode.com/tag/array/',
              ),
            ],
          ),
        ],
      ),

      // Category 4: Web Development
      CategoryModel(
        id: 'web_dev',
        title: 'Web Development',
        description: 'HTML, CSS, JavaScript, React, Node.js, and Fullstack Development.',
        icon: Icons.web_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'web_html_css',
            title: 'HTML5 & CSS3 Responsive Design',
            description: 'Semantic tags, Flexbox, CSS Grid, media queries.',
            resources: [
              HierarchyResourceModel(
                id: 'res_web_html_online',
                title: 'MDN Web Docs HTML/CSS',
                description: 'Official web documentation for frontend design.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://developer.mozilla.org/en-US/docs/Learn',
              ),
            ],
          ),
        ],
      ),

      // Category 5: App Development
      CategoryModel(
        id: 'app_dev',
        title: 'App Development',
        description: 'Flutter, Android (Kotlin), iOS (Swift), and Cross-platform mobile development.',
        icon: Icons.phone_android_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'flutter_basics',
            title: 'Flutter & Dart Overview',
            description: 'Widgets, state management, and cross-platform UI engineering.',
            resources: [
              HierarchyResourceModel(
                id: 'res_flutter_online',
                title: 'Flutter Documentation & Guides',
                description: 'Official Flutter framework guides and API documentation.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://docs.flutter.dev/',
              ),
            ],
          ),
        ],
      ),

      // Category 6: Databases
      CategoryModel(
        id: 'databases',
        title: 'Databases',
        description: 'Relational SQL (MySQL, PostgreSQL) & NoSQL (MongoDB, Firebase) design.',
        icon: Icons.storage_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'sql_basics',
            title: 'SQL & Relational Databases',
            description: 'Queries, JOINs, indexing, normalization, and ACID properties.',
            resources: [
              HierarchyResourceModel(
                id: 'res_sql_notes',
                title: 'SQL Essentials Cheat Sheet',
                description: 'SELECT, INSERT, UPDATE, DELETE, and JOIN queries explained.',
                type: HierarchyResourceType.notes,
                url: 'https://www.w3schools.com/sql/',
              ),
            ],
          ),
        ],
      ),

      // Category 7: Git & GitHub
      CategoryModel(
        id: 'git_github',
        title: 'Git & GitHub',
        description: 'Version control, branching, pull requests, open source contributions.',
        icon: Icons.merge_type_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'git_basics',
            title: 'Git Fundamentals',
            description: 'git init, commit, push, pull, branch, merge, and stash.',
            resources: [
              HierarchyResourceModel(
                id: 'res_git_notes',
                title: 'Git Command Cheat Sheet',
                description: 'All essential git commands summarized.',
                type: HierarchyResourceType.notes,
                url: 'https://education.github.com/git-cheat-sheet-education.pdf',
              ),
            ],
          ),
        ],
      ),
    ],
  );

  // ==========================================
  // 2. EMERGING TECHNOLOGIES HUB (NEW HIERARCHICAL SYSTEM)
  // ==========================================
  static const HubModel emergingTechHub = HubModel(
    id: 'emerging_tech',
    title: 'Emerging Technologies',
    description: 'Explore cutting-edge developments in AI, Machine Learning, Cloud Computing & Cybersecurity.',
    icon: Icons.smart_toy_rounded,
    routeName: '/career', // preserved route mapping
    startHereSteps: [
      StartHereStepModel(
        stepNumber: 1,
        title: 'Understand Future Tech Landscape',
        description: 'Explore how Artificial Intelligence, Cloud, and Quantum computing shape the industry.',
        targetCategoryId: 'ai_ml',
      ),
      StartHereStepModel(
        stepNumber: 2,
        title: 'Learn AI Fundamentals',
        description: 'Start with Artificial Intelligence concepts, Python math libraries, and data modeling.',
        targetCategoryId: 'ai_ml',
      ),
    ],
    categories: [
      // Category 1: Artificial Intelligence & Machine Learning (Flow 2 Target)
      CategoryModel(
        id: 'ai_ml',
        title: 'Artificial Intelligence',
        description: 'Machine Learning, Deep Learning, Natural Language Processing, and Computer Vision.',
        icon: Icons.psychology_rounded,
        availableLevels: [
          LearningLevel.beginner,
          LearningLevel.intermediate,
          LearningLevel.advanced,
        ],
        topics: [
          // FLOW 2 Target Topic: Emerging Tech -> Artificial Intelligence -> Machine Learning -> Beginner -> Topic -> Learn Online
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
                    title: 'Machine Learning Basics Notes',
                    description: 'Concise intro to supervised vs unsupervised learning and model evaluation metrics.',
                    type: HierarchyResourceType.notes,
                    url: 'https://scikit-learn.org/stable/getting_started.html',
                    platform: 'Scikit-Learn Docs',
                  ),
                  HierarchyResourceModel(
                    id: 'res_ml_video',
                    title: 'Machine Learning Course for Beginners',
                    description: 'Comprehensive 4-hour video course on ML algorithms and NumPy/Pandas setup.',
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
                  // FLOW 2 REDIRECTION LINK: Learn Online -> Machine Learning
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
            description: 'Artificial Neural Networks (ANN), CNNs for vision, RNNs/Transformers for NLP.',
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
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Category 2: Cloud Computing
      CategoryModel(
        id: 'cloud_computing',
        title: 'Cloud Computing & DevOps',
        description: 'AWS, Google Cloud, Azure, Docker containers & Kubernetes orchestration.',
        icon: Icons.cloud_done_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'aws_basics',
            title: 'AWS Cloud Fundamentals',
            description: 'EC2 instances, S3 storage, IAM security, AWS Lambda serverless.',
            resources: [
              HierarchyResourceModel(
                id: 'res_aws_online',
                title: 'AWS Educator Portal',
                description: 'Official AWS practitioner documentation.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://aws.amazon.com/getting-started/',
              ),
            ],
          ),
        ],
      ),

      // Category 3: Cybersecurity
      CategoryModel(
        id: 'cybersecurity',
        title: 'Cybersecurity & Ethical Hacking',
        description: 'Network security, cryptography, penetration testing & web application security.',
        icon: Icons.security_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'cyber_intro',
            title: 'Network & System Security',
            description: 'Firewalls, Wireshark packet analysis, OWASP Top 10 vulnerabilities.',
            resources: [
              HierarchyResourceModel(
                id: 'res_owasp_online',
                title: 'OWASP Top 10 Vulnerabilities',
                description: 'Standard security awareness guide for developers.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://owasp.org/www-project-top-ten/',
              ),
            ],
          ),
        ],
      ),
    ],
  );

  // ==========================================
  // 3. HIGHER EDUCATION HUB (NEW HIERARCHICAL SYSTEM)
  // ==========================================
  static const HubModel higherEducationHub = HubModel(
    id: 'higher_education',
    title: 'Higher Education & Exams',
    description: 'Explore Postgraduate degrees, Study Abroad, Scholarships, Entrance Exams & Research pathways.',
    icon: Icons.school_rounded,
    routeName: '/higher-education',
    startHereSteps: [
      StartHereStepModel(
        stepNumber: 1,
        title: 'Explore Postgraduate Studies',
        description: 'Understand Master\'s degrees, M.Tech, MBA, MCA, MS Abroad & PhD options.',
        targetCategoryId: 'pg_studies',
      ),
      StartHereStepModel(
        stepNumber: 2,
        title: 'Prepare for Entrance Exams',
        description: 'Syllabus, previous year questions & practice portals for GATE, GRE, GMAT, IELTS & TOEFL.',
        targetCategoryId: 'entrance_exams',
      ),
      StartHereStepModel(
        stepNumber: 3,
        title: 'Study Abroad Guidance',
        description: 'Country selection, university shortlisting, application processes & visa preparation.',
        targetCategoryId: 'study_abroad',
      ),
      StartHereStepModel(
        stepNumber: 4,
        title: 'Scholarships & Financial Aid',
        description: 'Government schemes, university fellowships, and international student grants.',
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
            title: 'Master\'s Degree',
            description: 'Graduate level academic degrees focusing on advanced specialization.',
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
            title: 'M.Tech',
            description: 'Master of Technology degrees at IITs, NITs, and premier technical institutions.',
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
            title: 'MBA',
            description: 'Master of Business Administration for management and leadership roles.',
            icon: Icons.business_center_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'mba_fundamentals',
                title: 'MBA Fundamentals',
                description: 'Entrance tests (CAT/GMAT), business school selection, and specialization tracks.',
                resources: [
                  HierarchyResourceModel(
                    id: 'res_mba_notes',
                    title: 'MBA Admission & Profile Building',
                    description: 'GMAT/CAT requirements, interviews, and business school selection.',
                    type: HierarchyResourceType.notes,
                    url: 'https://www.mba.com/',
                    platform: 'GMAC Portal',
                  ),
                  HierarchyResourceModel(
                    id: 'res_mba_online',
                    title: 'Learn Online: Official MBA Portal',
                    description: 'Official GMAT and global business school planning portal.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.mba.com/',
                    platform: 'mba.com',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'mca',
            title: 'MCA',
            description: 'Master of Computer Applications for software engineering careers.',
            icon: Icons.computer_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'mca_overview',
                title: 'MCA Overview & Preparation',
                description: 'NIMCET syllabus, top MCA colleges, and computer application curriculum.',
                resources: [
                  HierarchyResourceModel(
                    id: 'res_mca_online',
                    title: 'Learn Online: MCA Course Overview',
                    description: 'Detailed overview of MCA course structure and NIMCET exam prep.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.geeksforgeeks.org/mca-full-form/',
                    platform: 'GeeksforGeeks',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'ms',
            title: 'MS',
            description: 'Master of Science degrees at international and domestic research universities.',
            icon: Icons.science_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'ms_overview',
                title: 'MS Program Overview',
                description: 'Coursework vs Thesis MS tracks, assistantships, and admission prerequisites.',
                resources: [
                  HierarchyResourceModel(
                    id: 'res_ms_online',
                    title: 'Learn Online: MS Program Rankings',
                    description: 'US News ranking and overview of top international Master of Science programs.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.usnews.com/education/best-graduate-schools',
                    platform: 'US News Education',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'phd_program',
            title: 'PhD',
            description: 'Doctor of Philosophy doctoral research degrees and academic fellowships.',
            icon: Icons.psychology_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'phd_overview',
                title: 'PhD Preparation & Fellowships',
                description: 'Advisors, research proposals, doctoral stipends, and dissertation defense.',
                resources: [
                  HierarchyResourceModel(
                    id: 'res_phd_online',
                    title: 'Learn Online: PhD & Research Guidance',
                    description: 'Nature Careers guide to pursuing a PhD and finding doctoral advisors.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.nature.com/careers',
                    platform: 'Nature Careers',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Category 2: Study Abroad
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
          HierarchicalTopicModel(
            id: 'university_selection',
            title: 'University Selection',
            description: 'Shortlisting ambitious, target, and safe universities using QS/THE rankings.',
            resources: [
              HierarchyResourceModel(
                id: 'res_univ_rank_online',
                title: 'QS World University Rankings',
                description: 'Official global university rankings by subject and reputation.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.topuniversities.com/qs-world-university-rankings',
                platform: 'QS TopUniversities',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'application_process',
            title: 'Application Process',
            description: 'Statement of Purpose (SOP), Letters of Recommendation (LOR), transcripts & resume.',
            resources: [
              HierarchyResourceModel(
                id: 'res_app_proc_online',
                title: 'Common Application Portal',
                description: 'Centralized application system for higher education applications.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.commonapp.org/',
                platform: 'Common App',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'visa_prep',
            title: 'Visa Preparation',
            description: 'Student visa interviews (F-1, Student Route), financial proof & SEVIS requirements.',
            resources: [
              HierarchyResourceModel(
                id: 'res_visa_online',
                title: 'US Student Visa Official Guide',
                description: 'Official U.S. Department of State student visa procedures.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://travel.state.gov/content/travel/en/us-visas/study/student-visa.html',
                platform: 'U.S. Travel State Dept',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'abroad_scholarships',
            title: 'Scholarships',
            description: 'International student grants, tuition waivers, and assistantships.',
            resources: [
              HierarchyResourceModel(
                id: 'res_abroad_schol_online',
                title: 'International Scholarship Portal',
                description: 'Search thousands of scholarships for international students.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.scholarshipportal.com/',
                platform: 'ScholarshipPortal',
              ),
            ],
          ),
        ],
      ),

      // Category 3: Scholarships & Financial Aid
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
          HierarchicalTopicModel(
            id: 'univ_scholarships',
            title: 'University Scholarships',
            description: 'Departmental scholarships, TA/RA assistantships, and tuition fee waivers.',
            resources: [
              HierarchyResourceModel(
                id: 'res_univ_schol_online',
                title: 'Fastweb College Scholarships',
                description: 'Database of university scholarships and institutional aid.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.fastweb.com/',
                platform: 'Fastweb',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'intl_scholarships',
            title: 'International Scholarships',
            description: 'Fulbright, Chevening, DAAD, Commonwealth, and Erasmus Mundus fellowships.',
            resources: [
              HierarchyResourceModel(
                id: 'res_intl_schol_online',
                title: 'Fulbright Foreign Student Program',
                description: 'Official binational Fulbright grants for master\'s and PhD studies.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://fulbright-fulbright.org/',
                platform: 'Fulbright Program',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'merit_scholarships',
            title: 'Merit Scholarships',
            description: 'Rank-based and academic achievement scholarships for top performers.',
            resources: [
              HierarchyResourceModel(
                id: 'res_merit_schol_online',
                title: 'Scholarships.com Merit Directory',
                description: 'Search academic merit-based scholarships and awards.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.scholarships.com/',
                platform: 'Scholarships.com',
              ),
            ],
          ),
        ],
      ),

      // Category 4: Entrance Exams
      CategoryModel(
        id: 'entrance_exams',
        title: 'Entrance Exams',
        description: 'Syllabus, question banks & preparation for GATE, GRE, GMAT, IELTS, and TOEFL.',
        icon: Icons.quiz_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'exam_gate',
            title: 'GATE',
            description: 'Graduate Aptitude Test in Engineering for M.Tech admissions & PSU recruitment.',
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
            title: 'GRE',
            description: 'Graduate Record Examination for MS & MBA admissions globally.',
            icon: Icons.assignment_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'gre_general',
                title: 'GRE General Test Prep',
                description: 'Verbal reasoning, Quantitative reasoning, and Analytical Writing (AWA).',
                resources: [
                  HierarchyResourceModel(
                    id: 'res_gre_general_notes',
                    title: 'GRE Vocabulary & Math Formula Sheet',
                    description: 'High-frequency GRE words and math shortcut formulas.',
                    type: HierarchyResourceType.notes,
                    url: 'https://www.ets.org/gre.html',
                    platform: 'ETS Guide',
                  ),
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
          HierarchicalTopicModel(
            id: 'exam_gmat',
            title: 'GMAT',
            description: 'Graduate Management Admission Test for premier global MBA programs.',
            icon: Icons.analytics_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'gmat_focus',
                title: 'GMAT Focus Edition',
                description: 'Quantitative reasoning, Verbal reasoning, and Data Insights sections.',
                resources: [
                  HierarchyResourceModel(
                    id: 'res_gmat_online',
                    title: 'Learn Online: Official GMAT Exam Portal',
                    description: 'Official GMAC GMAT Focus Edition practice tests and prep.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.mba.com/exams/gmat-exam',
                    platform: 'GMAC mba.com',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'exam_ielts',
            title: 'IELTS',
            description: 'International English Language Testing System for study and immigration.',
            icon: Icons.record_voice_over_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'ielts_academic',
                title: 'IELTS Academic Module',
                description: 'Listening, Reading, Writing (Task 1 & Task 2), and Speaking interview.',
                resources: [
                  HierarchyResourceModel(
                    id: 'res_ielts_online',
                    title: 'Learn Online: Official IELTS Portal',
                    description: 'Official IELTS sample test papers and scoring rubrics.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.ielts.org/',
                    platform: 'IELTS Official',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'exam_toefl',
            title: 'TOEFL',
            description: 'Test of English as a Foreign Language iBT for university admissions.',
            icon: Icons.language_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'toefl_ibt',
                title: 'TOEFL iBT Test',
                description: 'Reading comprehension, listening tasks, speaking tasks, and academic writing.',
                resources: [
                  HierarchyResourceModel(
                    id: 'res_toefl_online',
                    title: 'Learn Online: ETS Official TOEFL Portal',
                    description: 'Official ETS TOEFL iBT practice tests and prep materials.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.ets.org/toefl.html',
                    platform: 'ETS TOEFL Official',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Category 5: Universities & Colleges
      CategoryModel(
        id: 'universities_colleges',
        title: 'Universities & Colleges',
        description: 'Finding the right university, ranking, accreditation, and comparison tools.',
        icon: Icons.account_balance_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'finding_univ',
            title: 'Finding the Right University',
            description: 'Factors: location, tuition fees, faculty research, campus culture & career placement.',
            resources: [
              HierarchyResourceModel(
                id: 'res_find_univ_online',
                title: 'QS Top Universities Finder',
                description: 'Search and filter world universities by location and major.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.topuniversities.com/',
                platform: 'QS TopUniversities',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'ranking_accreditation',
            title: 'Ranking & Accreditation',
            description: 'Understanding NIRF, QS, THE, Shanghai ARWU rankings and ABET/AACSB accreditations.',
            resources: [
              HierarchyResourceModel(
                id: 'res_rank_online',
                title: 'Academic Ranking of World Universities',
                description: 'Shanghai ARWU global research rankings.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.shanghairanking.com/',
                platform: 'ShanghaiRanking',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'app_requirements',
            title: 'Application Requirements',
            description: 'GPA minimums, GRE/GMAT cutoffs, English proficiency & transcript evaluations.',
            resources: [
              HierarchyResourceModel(
                id: 'res_app_req_online',
                title: 'GradSchools Requirements Portal',
                description: 'Guide to graduate program admission prerequisites.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.gradschools.com/',
                platform: 'GradSchools.com',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'comparing_univs',
            title: 'Comparing Universities',
            description: 'Side-by-side comparison of acceptance rates, tuition costs, and alumni outcomes.',
            resources: [
              HierarchyResourceModel(
                id: 'res_comp_univ_online',
                title: 'Niche College & Grad School Comparison',
                description: 'Detailed college reviews, ratings, and comparison tools.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.niche.com/colleges/search/best-colleges/',
                platform: 'Niche',
              ),
            ],
          ),
        ],
      ),

      // Category 6: Research & PhD
      CategoryModel(
        id: 'research_phd',
        title: 'Research & PhD',
        description: 'Research methodology, proposal writing, publishing papers, and doctoral programs.',
        icon: Icons.biotech_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'research_fundamentals',
            title: 'Research Fundamentals',
            description: 'Literature review, scientific method, experimental design, and data analysis.',
            resources: [
              HierarchyResourceModel(
                id: 'res_research_online',
                title: 'Nature Research Portal',
                description: 'Scientific research news, methodology, and peer-reviewed journals.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.nature.com/',
                platform: 'Nature Journal',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'research_topic',
            title: 'Finding a Research Topic',
            description: 'Identifying research gaps, reading survey papers, and formulating hypotheses.',
            resources: [
              HierarchyResourceModel(
                id: 'res_scholar_online',
                title: 'Google Scholar Search',
                description: 'Search academic papers, citations, and patents across disciplines.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://scholar.google.com/',
                platform: 'Google Scholar',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'research_proposal',
            title: 'Writing a Research Proposal',
            description: 'Structuring problem statement, objectives, methodology, and timeline.',
            resources: [
              HierarchyResourceModel(
                id: 'res_proposal_online',
                title: 'Research Proposal Writing Guide',
                description: 'Step by step guide to writing a successful academic research proposal.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.scribbr.com/category/research-proposal/',
                platform: 'Scribbr Academic',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'publishing_research',
            title: 'Publishing Research',
            description: 'Selecting peer-reviewed journals (IEEE, ACM, Springer), peer review, and LaTeX formatting.',
            resources: [
              HierarchyResourceModel(
                id: 'res_ieee_online',
                title: 'IEEE Xplore Digital Library',
                description: 'Global repository of computer science and engineering research papers.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://ieeexplore.ieee.org/',
                platform: 'IEEE Xplore',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'phd_prep',
            title: 'PhD Preparation',
            description: 'Contacting prospective professors, securing research assistantships, and qualifying exams.',
            resources: [
              HierarchyResourceModel(
                id: 'res_phd_prep_online',
                title: 'FindAPhD Global Portal',
                description: 'Database of funded PhD projects and research degrees globally.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.findaphd.com/',
                platform: 'FindAPhD',
              ),
            ],
          ),
        ],
      ),

      // Category 7: Professional Certifications
      CategoryModel(
        id: 'certifications',
        title: 'Professional Certifications',
        description: 'Cloud, programming, cybersecurity, and AI industry certifications.',
        icon: Icons.card_membership_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'cloud_certs',
            title: 'Cloud Certifications',
            description: 'AWS Certified Solutions Architect, Google Cloud Engineer, Azure Fundamentals.',
            resources: [
              HierarchyResourceModel(
                id: 'res_aws_cert_online',
                title: 'AWS Official Certification Portal',
                description: 'Official exam guides and practice exams for AWS certifications.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://aws.amazon.com/certification/',
                platform: 'AWS Certification',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'coding_certs',
            title: 'Programming Certifications',
            description: 'Python Institute PCAP/PCPP, Oracle Certified Java Professional.',
            resources: [
              HierarchyResourceModel(
                id: 'res_python_cert_online',
                title: 'Python Institute Certifications',
                description: 'Official Python programming certification levels.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://pythoninstitute.org/',
                platform: 'Python Institute',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'cyber_certs',
            title: 'Cybersecurity Certifications',
            description: 'CompTIA Security+, Certified Ethical Hacker (CEH), CISSP.',
            resources: [
              HierarchyResourceModel(
                id: 'res_cyber_cert_online',
                title: 'ISC2 CISSP & Security Certifications',
                description: 'Global standard cybersecurity certifications directory.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.isc2.org/Certifications',
                platform: 'ISC2 Official',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'data_ai_certs',
            title: 'Data & AI Certifications',
            description: 'TensorFlow Developer Certificate, Databricks Machine Learning Associate.',
            resources: [
              HierarchyResourceModel(
                id: 'res_tf_cert_online',
                title: 'TensorFlow Developer Certificate Guide',
                description: 'Official TensorFlow deep learning developer certification program.',
                type: HierarchyResourceType.learnOnline,
                url: 'https://www.tensorflow.org/certificate',
                platform: 'TensorFlow Official',
              ),
            ],
          ),
        ],
      ),
    ],
  );

  // ==========================================
  // 4. PLACEMENT HUB (NEW HIERARCHICAL SYSTEM)
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
        title: 'Step 1 — Build Programming Fundamentals',
        description: 'Master Python, C++, Java, or JavaScript syntax, functions, and logic building.',
        targetCategoryId: 'tech_prep',
      ),
      StartHereStepModel(
        stepNumber: 2,
        title: 'Step 2 — Learn Data Structures',
        description: 'Understand Arrays, Strings, Linked Lists, Stacks, Queues, Trees, and Graphs.',
        targetCategoryId: 'tech_prep',
      ),
      StartHereStepModel(
        stepNumber: 3,
        title: 'Step 3 — Practice Problem Solving',
        description: 'Solve top coding interview problems on LeetCode and GeeksforGeeks.',
        targetCategoryId: 'tech_prep',
      ),
      StartHereStepModel(
        stepNumber: 4,
        title: 'Step 4 — Learn CS Core Subjects',
        description: 'Review Operating Systems, DBMS, SQL, Computer Networks, and OOP concepts.',
        targetCategoryId: 'tech_prep',
      ),
      StartHereStepModel(
        stepNumber: 5,
        title: 'Step 5 — Build Projects',
        description: 'Develop fullstack or mobile app projects to showcase on your portfolio.',
        targetCategoryId: 'resume_profile',
      ),
      StartHereStepModel(
        stepNumber: 6,
        title: 'Step 6 — Prepare Resume',
        description: 'Draft an ATS-friendly single page technical resume and optimize LinkedIn.',
        targetCategoryId: 'resume_profile',
      ),
      StartHereStepModel(
        stepNumber: 7,
        title: 'Step 7 — Practice Interviews',
        description: 'Conduct mock technical and HR interviews using the STAR method.',
        targetCategoryId: 'interview_prep',
      ),
      StartHereStepModel(
        stepNumber: 8,
        title: 'Step 8 — Apply for Jobs',
        description: 'Apply for campus placement drives, off-campus jobs, and internships.',
        targetCategoryId: 'job_search',
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
            title: 'Data Structures & Algorithms',
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
                    platform: 'LeetCode',
                  ),
                ],
              ),
              HierarchicalTopicModel(
                id: 'arrays_topic',
                title: 'Arrays',
                description: 'Contiguous memory allocation, element access, two-pointers & sliding window.',
                level: LearningLevel.beginner,
                subtopics: [
                  HierarchicalTopicModel(
                    id: 'array_basics',
                    title: 'Array Basics',
                    description: 'Introduction to 1D/2D arrays, indexing, traversal, insertion, and deletion.',
                    level: LearningLevel.beginner,
                    resources: [
                      HierarchyResourceModel(
                        id: 'res_array_basics_notes',
                        title: 'Array Data Structure Notes',
                        description: 'Memory layout, time complexities of array operations, and fundamental concepts.',
                        type: HierarchyResourceType.notes,
                        url: 'https://www.geeksforgeeks.org/array-data-structure/',
                        platform: 'GeeksforGeeks Notes',
                      ),
                      HierarchyResourceModel(
                        id: 'res_array_basics_video',
                        title: 'Arrays & Memory Layout in 30 Minutes',
                        description: 'Visual walkthrough of array contiguous storage and memory addresses.',
                        type: HierarchyResourceType.video,
                        url: 'https://www.youtube.com/watch?v=n60TiZ517ZY',
                        platform: 'YouTube / freeCodeCamp',
                      ),
                      HierarchyResourceModel(
                        id: 'res_array_basics_practice',
                        title: 'Practice: LeetCode Array Practice',
                        description: 'Solve curated array coding problems interactively on LeetCode.',
                        type: HierarchyResourceType.practice,
                        url: 'https://leetcode.com/tag/array/',
                        platform: 'LeetCode Practice',
                      ),
                      HierarchyResourceModel(
                        id: 'res_array_basics_online',
                        title: 'Learn Online: GeeksforGeeks Arrays Guide',
                        description: 'Comprehensive online tutorial on Array data structures.',
                        type: HierarchyResourceType.learnOnline,
                        url: 'https://www.geeksforgeeks.org/array-data-structure/',
                        platform: 'GeeksforGeeks Portal',
                      ),
                    ],
                  ),
                ],
              ),
              HierarchicalTopicModel(
                id: 'strings_topic',
                title: 'Strings',
                description: 'ASCII/Unicode encoding, string immutability, pattern matching & anagrams.',
                level: LearningLevel.beginner,
                subtopics: [
                  HierarchicalTopicModel(
                    id: 'string_basics',
                    title: 'String Basics',
                    description: 'String manipulation, reversing strings, checking palindromes, and substrings.',
                    level: LearningLevel.beginner,
                    resources: [
                      HierarchyResourceModel(
                        id: 'res_string_basics_notes',
                        title: 'String Basics & Manipulation Notes',
                        description: 'String operations and common interview pattern notes.',
                        type: HierarchyResourceType.notes,
                        url: 'https://www.geeksforgeeks.org/string-data-structure/',
                        platform: 'GeeksforGeeks',
                      ),
                      HierarchyResourceModel(
                        id: 'res_string_basics_practice',
                        title: 'Practice: LeetCode String Practice',
                        description: 'Solve top string coding questions on LeetCode.',
                        type: HierarchyResourceType.practice,
                        url: 'https://leetcode.com/tag/string/',
                        platform: 'LeetCode',
                      ),
                      HierarchyResourceModel(
                        id: 'res_string_basics_online',
                        title: 'Learn Online: GeeksforGeeks Strings Guide',
                        description: 'Detailed tutorial on String algorithms and functions.',
                        type: HierarchyResourceType.learnOnline,
                        url: 'https://www.geeksforgeeks.org/string-data-structure/',
                        platform: 'GeeksforGeeks',
                      ),
                    ],
                  ),
                ],
              ),
              HierarchicalTopicModel(
                id: 'linked_lists',
                title: 'Linked Lists',
                description: 'Singly, Doubly, and Circular linked lists, pointer manipulation & reversal.',
              ),
              HierarchicalTopicModel(
                id: 'stacks_queues',
                title: 'Stacks & Queues',
                description: 'LIFO & FIFO operations, monotonic stacks, priority queues, and deque.',
              ),
              HierarchicalTopicModel(
                id: 'trees',
                title: 'Trees',
                description: 'Binary Trees, Binary Search Trees (BST), Traversals (Inorder, Preorder, Postorder).',
              ),
              HierarchicalTopicModel(
                id: 'graphs',
                title: 'Graphs',
                description: 'BFS, DFS, Dijkstra\'s algorithm, Topological Sort, Minimum Spanning Trees.',
              ),
              HierarchicalTopicModel(
                id: 'sorting',
                title: 'Sorting',
                description: 'Bubble Sort, Merge Sort, Quick Sort, Heap Sort, and Time Complexity comparisons.',
              ),
              HierarchicalTopicModel(
                id: 'searching',
                title: 'Searching',
                description: 'Linear Search, Binary Search, and Binary Search on Answer space.',
              ),
              HierarchicalTopicModel(
                id: 'dp_topic',
                title: 'Dynamic Programming',
                description: 'Memoization, Tabulation, 0/1 Knapsack, Longest Common Subsequence.',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'placement_prog_langs',
            title: 'Programming Languages',
            description: 'Core concepts in C++, Java, Python, and JavaScript for interviews.',
            icon: Icons.code_rounded,
          ),
          HierarchicalTopicModel(
            id: 'dbms',
            title: 'DBMS',
            description: 'Database Management Systems, Normalization (1NF-3NF), B-Trees, and Transactions.',
            icon: Icons.storage_rounded,
          ),
          HierarchicalTopicModel(
            id: 'operating_systems',
            title: 'Operating Systems',
            description: 'Processes, Threads, CPU Scheduling, Deadlocks, Virtual Memory & Paging.',
            icon: Icons.memory_rounded,
          ),
          HierarchicalTopicModel(
            id: 'computer_networks',
            title: 'Computer Networks',
            description: 'OSI 7-Layer Model, TCP/IP, IP Addressing, Subnetting, HTTP/HTTPS, DNS & Sockets.',
            icon: Icons.hub_rounded,
          ),
          HierarchicalTopicModel(
            id: 'oop_concepts',
            title: 'OOP',
            description: 'Object-Oriented Programming: Encapsulation, Abstraction, Inheritance & Polymorphism.',
            icon: Icons.category_rounded,
          ),
          HierarchicalTopicModel(
            id: 'sql_prep',
            title: 'SQL',
            description: 'Queries, JOINs, Group By, Having, Subqueries & Window Functions.',
            icon: Icons.dataset_rounded,
          ),
        ],
      ),

      // Category 2: Aptitude
      CategoryModel(
        id: 'aptitude_prep',
        title: 'Aptitude',
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
              HierarchicalTopicModel(
                id: 'profit_loss',
                title: 'Profit & Loss',
                description: 'Cost price, selling price, marked price, discount, and margin calculations.',
              ),
              HierarchicalTopicModel(
                id: 'time_work',
                title: 'Time & Work',
                description: 'Man-hours, efficiency ratios, pipes and cisterns problems.',
              ),
              HierarchicalTopicModel(
                id: 'speed_distance',
                title: 'Time Speed & Distance',
                description: 'Relative speed, trains crossing platforms, boats and streams.',
              ),
              HierarchicalTopicModel(
                id: 'ratio_proportion',
                title: 'Ratio & Proportion',
                description: 'Ratios, proportions, mixtures, and alligation techniques.',
              ),
              HierarchicalTopicModel(
                id: 'probability_topic',
                title: 'Probability',
                description: 'Combinations, permutations, sample spaces, and conditional probability.',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'logical_reasoning',
            title: 'Logical Reasoning',
            description: 'Number Series, Coding-Decoding, Blood Relations & Seating Arrangement.',
            icon: Icons.psychology_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'number_series',
                title: 'Number Series',
                description: 'Arithmetic, geometric, square/cube, and alternating number series patterns.',
              ),
              HierarchicalTopicModel(
                id: 'coding_decoding',
                title: 'Coding-Decoding',
                description: 'Letter coding, number coding, and substitution coding puzzles.',
              ),
              HierarchicalTopicModel(
                id: 'blood_relations',
                title: 'Blood Relations',
                description: 'Family tree diagrams and coded relation statements.',
              ),
              HierarchicalTopicModel(
                id: 'seating_arrangement',
                title: 'Seating Arrangement',
                description: 'Linear, circular, and matrix seating arrangement logic puzzles.',
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'verbal_ability',
            title: 'Verbal Ability',
            description: 'Reading Comprehension, Vocabulary, Grammar & Sentence Correction.',
            icon: Icons.record_voice_over_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'rc_topic',
                title: 'Reading Comprehension',
                description: 'Passage analysis, main idea identification, and inference questions.',
              ),
              HierarchicalTopicModel(
                id: 'vocab_topic',
                title: 'Vocabulary',
                description: 'Synonyms, antonyms, idioms, phrases, and one-word substitutions.',
              ),
              HierarchicalTopicModel(
                id: 'grammar_topic',
                title: 'Grammar',
                description: 'Subject-verb agreement, tenses, prepositions, and conjunctions.',
              ),
              HierarchicalTopicModel(
                id: 'sentence_correction',
                title: 'Sentence Correction',
                description: 'Spotting errors, misplaced modifiers, and parallel structure.',
              ),
            ],
          ),
        ],
      ),

      // Category 3: Communication & HR
      CategoryModel(
        id: 'communication_hr',
        title: 'Communication & HR',
        description: 'Communication skills, Group Discussions, HR interview questions & the STAR method.',
        icon: Icons.people_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'comm_skills',
            title: 'Communication Skills',
            description: 'Articulate expression, active listening, body language, and professional etiquette.',
          ),
          HierarchicalTopicModel(
            id: 'group_discussion',
            title: 'Group Discussion',
            description: 'GD roles (Initiator, Moderator, Summarizer), topic types & dos and don\'ts.',
          ),
          HierarchicalTopicModel(
            id: 'hr_questions',
            title: 'HR Questions',
            description: 'Standard HR interview questions and behavioral answer frameworks.',
            subtopics: [
              HierarchicalTopicModel(
                id: 'hr_common_q',
                title: 'Common HR Interview Questions',
                description: 'Answers for "Tell me about yourself", "Strengths & Weaknesses", and "Where do you see yourself in 5 years?".',
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
          HierarchicalTopicModel(
            id: 'behavioral_q',
            title: 'Behavioral Questions',
            description: 'Handling conflict, leadership examples, failure, and teamwork scenarios.',
          ),
          HierarchicalTopicModel(
            id: 'star_method',
            title: 'STAR Method',
            description: 'Structuring behavioral answers using Situation, Task, Action, Result framework.',
          ),
        ],
      ),

      // Category 4: Resume & Profile
      CategoryModel(
        id: 'resume_profile',
        title: 'Resume & Profile',
        description: 'Technical resume building, LinkedIn optimization, GitHub portfolio & personal branding.',
        icon: Icons.badge_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'resume_building',
            title: 'Resume Building',
            description: 'ATS-friendly resume templates, action verbs, project formatting & metric outcomes.',
            subtopics: [
              HierarchicalTopicModel(
                id: 'creating_student_resume',
                title: 'Creating a Student Resume',
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
                  HierarchyResourceModel(
                    id: 'res_student_resume_online',
                    title: 'Learn Online: Jake\'s Resume Latex Template',
                    description: 'Industry standard open-source technical resume LaTeX template.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.overleaf.com/latex/templates/jakes-resume/syzsqfdxflqy',
                    platform: 'Overleaf LaTeX',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'linkedin_profile',
            title: 'LinkedIn Profile',
            description: 'Headline optimization, summary, experience, recommendations, and networking.',
          ),
          HierarchicalTopicModel(
            id: 'github_profile',
            title: 'GitHub Profile',
            description: 'Profile README, repository documentation, commit streak, and open-source contributions.',
          ),
          HierarchicalTopicModel(
            id: 'portfolio_building',
            title: 'Portfolio',
            description: 'Personal developer website, live demo links, and project case studies.',
          ),
          HierarchicalTopicModel(
            id: 'personal_branding',
            title: 'Personal Branding',
            description: 'Tech blogging (Hashnode/Medium), sharing learnings, and community engagement.',
          ),
        ],
      ),

      // Category 5: Interview Preparation
      CategoryModel(
        id: 'interview_prep',
        title: 'Interview Preparation',
        description: 'Technical interviews, coding rounds, HR rounds, mock interviews & common mistakes.',
        icon: Icons.quiz_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'technical_interviews',
            title: 'Technical Interviews',
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
                  HierarchyResourceModel(
                    id: 'res_tech_interview_online',
                    title: 'Learn Online: Striver A2Z DSA Sheet',
                    description: 'Comprehensive DSA interview roadmap with detailed solutions.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://takeuforward.org/strivers-a2zdsa-course/strivers-a2z-dsa-course-sheet-2/',
                    platform: 'Striver A2Z',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'coding_interviews',
            title: 'Coding Interviews',
            description: 'Time management during online coding assessments (OA) and edge case handling.',
          ),
          HierarchicalTopicModel(
            id: 'hr_interviews',
            title: 'HR Interviews',
            description: 'Salary negotiation basics, company research, and asking insightful questions.',
          ),
          HierarchicalTopicModel(
            id: 'mock_interviews',
            title: 'Mock Interviews',
            description: 'Peer-to-peer mock interviews, Pramp/Interviewing.io practice, and self-recording.',
          ),
          HierarchicalTopicModel(
            id: 'interview_mistakes',
            title: 'Interview Mistakes',
            description: 'Common pitfalls: staying silent, rushing into code without clarifying questions.',
          ),
        ],
      ),

      // Category 6: Job Search
      CategoryModel(
        id: 'job_search',
        title: 'Job Search',
        description: 'Campus placements, internships, off-campus applications, cold emailing & job portals.',
        icon: Icons.work_history_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'finding_jobs',
            title: 'Finding Jobs',
            description: 'Job search strategies, referral requests, and targeted company lists.',
          ),
          HierarchicalTopicModel(
            id: 'campus_placements',
            title: 'Campus Placements',
            description: 'On-campus recruitment drives, company eligibility cutoffs & PPT sessions.',
          ),
          HierarchicalTopicModel(
            id: 'internships',
            title: 'Internships',
            description: 'Summer internships, winter research internships, and conversion to Full-Time (PPO).',
          ),
          HierarchicalTopicModel(
            id: 'off_campus_jobs',
            title: 'Off-Campus Jobs',
            description: 'Applying on career portals, reaching out to recruiters, and hiring challenges.',
          ),
          HierarchicalTopicModel(
            id: 'job_portals',
            title: 'Job Portals',
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

      // Category 7: Placement Roadmap
      CategoryModel(
        id: 'placement_roadmap',
        title: 'Placement Roadmap',
        description: 'End-to-end 8-step placement preparation roadmap for computer science engineering students.',
        icon: Icons.map_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'roadmap_overview',
            title: '8-Step Placement Preparation Roadmap',
            description: 'Structured roadmap covering programming, DSA, CS core, projects, resume & job search.',
            resources: [
              HierarchyResourceModel(
                id: 'res_roadmap_notes',
                title: 'Complete Student Placement Roadmap Notes',
                description: 'Month-by-month study plan and resource checklist for technical placements.',
                type: HierarchyResourceType.notes,
                url: 'https://takeuforward.org/strivers-a2zdsa-course/strivers-a2z-dsa-course-sheet-2/',
                platform: 'Striver Placement Roadmap',
              ),
            ],
          ),
        ],
      ),
    ],
  );

  // ==========================================
  // 5. PROJECTS & PRACTICE HUB (NEW HIERARCHICAL SYSTEM)
  // ==========================================
  static const HubModel projectsHub = HubModel(
    id: 'projects',
    title: 'Projects & Practice',
    description: 'Real-world project blueprints, source code repositories & interactive coding and SQL practice.',
    icon: Icons.rocket_launch_rounded,
    routeName: '/projects',
    startHereSteps: [
      StartHereStepModel(
        stepNumber: 1,
        title: 'Step 1 — Build Beginner Mini-Projects',
        description: 'Start with Calculator, To-Do List, and Expense Tracker to master basic state & UI.',
        targetCategoryId: 'beginner_projects',
      ),
      StartHereStepModel(
        stepNumber: 2,
        title: 'Step 2 — Build Responsive Web Applications',
        description: 'Construct Personal Portfolio, Blog Website, E-Commerce, and Weather Apps.',
        targetCategoryId: 'web_projects',
      ),
      StartHereStepModel(
        stepNumber: 3,
        title: 'Step 3 — Build Cross-Platform Mobile Apps',
        description: 'Develop Flutter and Android apps with offline local storage and state management.',
        targetCategoryId: 'app_projects',
      ),
      StartHereStepModel(
        stepNumber: 4,
        title: 'Step 4 — Build AI & Machine Learning Blueprints',
        description: 'Implement House Price Predictor, Spam Detection, and NLP Chatbot models.',
        targetCategoryId: 'ai_projects',
      ),
      StartHereStepModel(
        stepNumber: 5,
        title: 'Step 5 — Practice Daily Coding Problems',
        description: 'Solve topic-wise DSA problems on Arrays, Strings, Linked Lists, and Trees.',
        targetCategoryId: 'coding_practice',
      ),
      StartHereStepModel(
        stepNumber: 6,
        title: 'Step 6 — Master SQL Queries & Relational Data',
        description: 'Practice SELECT, JOINs, GROUP BY, and Subqueries on interactive SQL portals.',
        targetCategoryId: 'sql_practice',
      ),
    ],
    categories: [
      // Category 1: Beginner Projects
      CategoryModel(
        id: 'beginner_projects',
        title: 'Beginner Projects',
        description: 'Calculator, To-Do List, Student Management System, and Expense Tracker mini-projects.',
        icon: Icons.lightbulb_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'calculator_proj',
            title: 'Calculator',
            description: 'Basic arithmetic calculator app with grid layout and button state handling.',
          ),
          HierarchicalTopicModel(
            id: 'todo_list_proj',
            title: 'To-Do List',
            description: 'Task management application with CRUD operations, completion toggles, and persistence.',
            icon: Icons.check_box_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'build_todo_list',
                title: 'Build a To-Do List',
                description: 'Step-by-step guide to building a responsive To-Do application.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_todo_notes',
                    title: 'To-Do App Architecture & State Management Guide',
                    description: 'Architecture breakdown, state management, and localStorage persistence notes.',
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
          HierarchicalTopicModel(
            id: 'student_mgmt_proj',
            title: 'Student Management System',
            description: 'Console or GUI app managing student records, grades, and attendance.',
          ),
          HierarchicalTopicModel(
            id: 'expense_tracker_proj',
            title: 'Expense Tracker',
            description: 'Income and expense logging app calculating net balance and category charts.',
          ),
        ],
      ),

      // Category 2: Web Projects
      CategoryModel(
        id: 'web_projects',
        title: 'Web Projects',
        description: 'Personal Portfolio, Blog Website, E-Commerce, and Weather Application blueprints.',
        icon: Icons.language_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'portfolio_proj',
            title: 'Personal Portfolio',
            description: 'Single page developer portfolio with about, skills, projects, and contact form.',
            icon: Icons.person_pin_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'build_portfolio',
                title: 'Build a Personal Portfolio',
                description: 'Design and deploy a professional developer portfolio website.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_portfolio_notes',
                    title: 'Developer Portfolio Design Checklist',
                    description: 'Best practices for showcasing projects, resume links, and contact info.',
                    type: HierarchyResourceType.notes,
                    url: 'https://github.com/topics/portfolio-website',
                    platform: 'GitHub Guide',
                  ),
                  HierarchyResourceModel(
                    id: 'res_portfolio_project',
                    title: 'Source Code: Developer Portfolio Template',
                    description: 'Open source responsive portfolio website template on GitHub.',
                    type: HierarchyResourceType.project,
                    url: 'https://github.com/topics/portfolio-template',
                    platform: 'GitHub Repository',
                  ),
                  HierarchyResourceModel(
                    id: 'res_portfolio_online',
                    title: 'Learn Online: Build & Deploy Personal Portfolio',
                    description: 'freeCodeCamp step-by-step guide to building and hosting your portfolio.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.freecodecamp.org/news/how-to-build-a-developer-portfolio/',
                    platform: 'freeCodeCamp',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'blog_proj',
            title: 'Blog Website',
            description: 'Content management system (CMS) with markdown post rendering and comments.',
          ),
          HierarchicalTopicModel(
            id: 'ecom_proj',
            title: 'E-Commerce Website',
            description: 'Product catalog, shopping cart state, search filters, and checkout simulation.',
          ),
          HierarchicalTopicModel(
            id: 'weather_app_proj',
            title: 'Weather Application',
            description: 'Weather forecasting app fetching live OpenWeather API data.',
          ),
        ],
      ),

      // Category 3: App Projects
      CategoryModel(
        id: 'app_projects',
        title: 'App Projects',
        description: 'To-Do Mobile App, Notes App, Expense Tracker App, and Student Resource App.',
        icon: Icons.phone_android_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'todo_mobile_proj',
            title: 'To-Do Mobile App',
            description: 'Mobile task manager with swipe gestures and local notification reminders.',
          ),
          HierarchicalTopicModel(
            id: 'notes_app_proj',
            title: 'Notes App',
            description: 'Markdown note-taking mobile application with offline SQLite database.',
            icon: Icons.note_alt_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'build_notes_app',
                title: 'Build a Notes App',
                description: 'Build a cross-platform mobile notes app using Flutter or React Native.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_notes_app_notes',
                    title: 'Offline Notes App Schema & Local DB Guide',
                    description: 'SQLite database table design, search indexing, and note model architecture.',
                    type: HierarchyResourceType.notes,
                    url: 'https://github.com/topics/notes-app',
                    platform: 'GitHub Guide',
                  ),
                  HierarchyResourceModel(
                    id: 'res_notes_app_project',
                    title: 'Source Code: Flutter Notes App Template',
                    description: 'Open source Flutter offline notes app sample repository.',
                    type: HierarchyResourceType.project,
                    url: 'https://github.com/flutter/samples/tree/main/provider_shopper',
                    platform: 'Flutter Samples Repo',
                  ),
                  HierarchyResourceModel(
                    id: 'res_notes_app_online',
                    title: 'Learn Online: Build a Flutter Offline Notes App',
                    description: 'Official Flutter cookbook guide on SQLite local storage and persistence.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://flutter.dev/docs/cookbook/persistence/sqlite',
                    platform: 'Flutter Docs',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'expense_app_proj',
            title: 'Expense Tracker App',
            description: 'Personal finance mobile app tracking monthly budgets with pie charts.',
          ),
          HierarchicalTopicModel(
            id: 'student_resource_app',
            title: 'Student Resource App',
            description: 'Study material aggregator app with PDF viewer and subject bookmarks.',
          ),
        ],
      ),

      // Category 4: AI & Data Projects
      CategoryModel(
        id: 'ai_projects',
        title: 'AI & Data Projects',
        description: 'House Price Prediction, Spam Detection, Student Performance Prediction, and Chatbot.',
        icon: Icons.smart_toy_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'house_price_proj',
            title: 'House Price Prediction',
            description: 'Scikit-Learn Machine Learning regression model predicting real estate prices.',
            icon: Icons.home_work_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'build_house_price',
                title: 'Build a House Price Predictor',
                description: 'End-to-end Machine Learning pipeline: EDA, feature engineering, linear regression.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_house_price_notes',
                    title: 'Scikit-Learn Regression Pipeline Notes',
                    description: 'Data preprocessing, feature scaling, model training, and RMSE metrics.',
                    type: HierarchyResourceType.notes,
                    url: 'https://scikit-learn.org/stable/tutorial/basic/tutorial.html',
                    platform: 'Scikit-Learn Docs',
                  ),
                  HierarchyResourceModel(
                    id: 'res_house_price_project',
                    title: 'Source Code: Kaggle House Prices Repo',
                    description: 'Open source Python Jupyter notebook for House Price Prediction.',
                    type: HierarchyResourceType.project,
                    url: 'https://github.com/topics/house-price-prediction',
                    platform: 'GitHub ML Repo',
                  ),
                  HierarchyResourceModel(
                    id: 'res_house_price_online',
                    title: 'Learn Online: Kaggle House Prices Competition',
                    description: 'Kaggle benchmark Machine Learning dataset and starter tutorial.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://www.kaggle.com/c/house-prices-advanced-regression-techniques',
                    platform: 'Kaggle Portal',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'spam_detection_proj',
            title: 'Spam Detection',
            description: 'Natural Language Processing Naive Bayes model classifying emails as spam or ham.',
          ),
          HierarchicalTopicModel(
            id: 'student_perf_proj',
            title: 'Student Performance Prediction',
            description: 'Machine Learning classification model predicting exam scores based on study hours.',
          ),
          HierarchicalTopicModel(
            id: 'chatbot_proj',
            title: 'Chatbot',
            description: 'Rule-based or LLM API powered conversational assistant.',
          ),
        ],
      ),

      // Category 5: Coding Practice
      CategoryModel(
        id: 'coding_practice',
        title: 'Coding Practice',
        description: 'Interactive problem sets for Arrays, Strings, Linked Lists, Trees, and Algorithms.',
        icon: Icons.code_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'beginner_coding_probs',
            title: 'Beginner Problems',
            description: 'Basic loops, conditional logic, Fibonacci, primes, and palindrome numbers.',
          ),
          HierarchicalTopicModel(
            id: 'coding_arrays_proj',
            title: 'Arrays',
            description: 'Two Pointers, Sliding Window, Prefix Sum, and Subarray problem sets.',
            icon: Icons.account_tree_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'array_problem_solving',
                title: 'Array Problem Solving',
                description: 'Solve top array interview problems interactively.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_coding_arr_notes',
                    title: 'Top Array Interview Patterns Notes',
                    description: 'Master list of 15 essential array patterns and complexities.',
                    type: HierarchyResourceType.notes,
                    url: 'https://takeuforward.org/strivers-a2zdsa-course/strivers-a2z-dsa-course-sheet-2/',
                    platform: 'Striver A2Z',
                  ),
                  HierarchyResourceModel(
                    id: 'res_coding_arr_practice',
                    title: 'Practice: LeetCode Array Problem Set',
                    description: 'Solve array questions on LeetCode.',
                    type: HierarchyResourceType.practice,
                    url: 'https://leetcode.com/tag/array/',
                    platform: 'LeetCode Practice',
                  ),
                  HierarchyResourceModel(
                    id: 'res_coding_arr_online',
                    title: 'Learn Online: GeeksforGeeks Array Problems',
                    description: 'GeeksforGeeks curated array problem solving list.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://practice.geeksforgeeks.org/explore?page=1&category[]=Arrays',
                    platform: 'GeeksforGeeks Practice',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'coding_strings_proj',
            title: 'Strings',
            description: 'Anagrams, string matching, palindrome partitioning, and Trie structures.',
          ),
          HierarchicalTopicModel(
            id: 'coding_linked_lists_proj',
            title: 'Linked Lists',
            description: 'Reversing lists, cycle detection (Floyd\'s algorithm), merging sorted lists.',
          ),
          HierarchicalTopicModel(
            id: 'coding_trees_proj',
            title: 'Trees',
            description: 'Binary Tree traversals, Lowest Common Ancestor (LCA), BST validation.',
          ),
          HierarchicalTopicModel(
            id: 'coding_algos_proj',
            title: 'Algorithms',
            description: 'Binary Search, Divide and Conquer, Greedy Algorithms, Dynamic Programming.',
          ),
        ],
      ),

      // Category 6: SQL Practice
      CategoryModel(
        id: 'sql_practice',
        title: 'SQL Practice',
        description: 'Interactive SQL query practice: SELECT, JOINs, GROUP BY, and Subqueries.',
        icon: Icons.storage_rounded,
        topics: [
          HierarchicalTopicModel(
            id: 'sql_basics_practice',
            title: 'SQL Basics',
            description: 'Fundamental SQL syntax, WHERE clauses, ORDER BY, and LIMIT.',
            icon: Icons.dataset_rounded,
            subtopics: [
              HierarchicalTopicModel(
                id: 'sql_query_practice',
                title: 'SQL Query Practice',
                description: 'Solve interactive relational database query problems.',
                level: LearningLevel.beginner,
                resources: [
                  HierarchyResourceModel(
                    id: 'res_sql_practice_notes',
                    title: 'SQL Essentials & JOIN Cheat Sheet',
                    description: 'Quick reference cheat sheet for SQL queries and JOIN syntax.',
                    type: HierarchyResourceType.notes,
                    url: 'https://www.w3schools.com/sql/',
                    platform: 'W3Schools SQL Guide',
                  ),
                  HierarchyResourceModel(
                    id: 'res_sql_practice_practice',
                    title: 'Practice: LeetCode Top 50 SQL Study Plan',
                    description: '50 essential SQL interview problems on LeetCode.',
                    type: HierarchyResourceType.practice,
                    url: 'https://leetcode.com/studyplan/top-sql-50/',
                    platform: 'LeetCode SQL Plan',
                  ),
                  HierarchyResourceModel(
                    id: 'res_sql_practice_online',
                    title: 'Learn Online: SQLZoo Interactive SQL Tutorial',
                    description: 'Interactive online SQL environment with instant query feedback.',
                    type: HierarchyResourceType.learnOnline,
                    url: 'https://sqlzoo.net/',
                    platform: 'SQLZoo Interactive',
                  ),
                ],
              ),
            ],
          ),
          HierarchicalTopicModel(
            id: 'select_queries',
            title: 'SELECT Queries',
            description: 'Column selection, filtering with operators (AND/OR/IN/BETWEEN), and aliasing.',
          ),
          HierarchicalTopicModel(
            id: 'joins_practice',
            title: 'JOINs',
            description: 'INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN, and Self JOINs.',
          ),
          HierarchicalTopicModel(
            id: 'groupby_practice',
            title: 'GROUP BY',
            description: 'Aggregate functions (COUNT, SUM, AVG, MIN, MAX) and HAVING filter clauses.',
          ),
          HierarchicalTopicModel(
            id: 'subqueries_practice',
            title: 'Subqueries',
            description: 'Nested subqueries, correlated subqueries, and Common Table Expressions (CTEs).',
          ),
        ],
      ),
    ],
  );
}

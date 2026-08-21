import '../datasources/firebase_datasource.dart';
import '../models/project_model.dart';

class ProjectRepository {
  final FirebaseDataSource _firebaseDataSource;

  ProjectRepository({required FirebaseDataSource firebaseDataSource})
      : _firebaseDataSource = firebaseDataSource;

  Future<List<ProjectModel>> getProjects() async {
    try {
      final remoteData = await _firebaseDataSource.getProjects();
      if (remoteData.isNotEmpty) {
        return remoteData.map((e) => ProjectModel.fromJson(e)).toList();
      }
    } catch (_) {}

    return _fallbackProjects;
  }

  static List<ProjectModel> get fallbackProjects => _fallbackProjects;

  static const List<ProjectModel> _fallbackProjects = [
    // --- TIER 1: BEGINNER ---
    ProjectModel(
      id: 'proj_task_notes',
      title: 'Smart Task & Student Notes App',
      description:
          'An offline-first task tracker and notes application with local SQLite persistence and categorization.',
      category: 'Flutter Mobile',
      difficulty: 'Beginner',
      estimatedDuration: '2 Weeks',
      problemStatement:
          'Engineering students need a simple, zero-latency offline application to organize daily study tasks, lab notes, and assignment deadlines without requiring internet access.',
      realWorldUseCase:
          'Personal productivity app for college students with zero server overhead.',
      targetUsers: 'Students, self-learners, task managers.',
      prerequisites: [
        'Dart Basics',
        'Flutter Widgets',
        'SQLite / sqflite plugin'
      ],
      requiredSkills: [
        'Flutter',
        'SQLite',
        'Provider State Management',
        'Clean Code'
      ],
      technologies: ['Flutter', 'Dart', 'SQLite', 'Provider'],
      whyTheseTechnologies:
          'Flutter provides smooth cross-platform rendering; SQLite guarantees reliable offline storage with instant query speed.',
      systemArchitecture:
          'Model-View-Provider (MVP) / Clean Architecture split into Presentation, State Provider, and Data Access Layers.',
      majorModules: [
        'Task Creation & Tagging',
        'SQLite Storage Engine',
        'Search & Category Filter',
        'Progress Overview'
      ],
      databaseDesign:
          'SQLite Table `notes` (id INTEGER PRIMARY KEY, title TEXT, content TEXT, category TEXT, is_completed INTEGER, created_at TEXT).',
      apiRequirements:
          'Local SQLite CRUD operations using sqflite helper methods (insert, query, update, delete).',
      folderStructure: '''lib/
  core/
    constants/
    utils/
  data/
    datasources/
      db_helper.dart
    models/
      note_model.dart
  presentation/
    providers/
      notes_provider.dart
    screens/
      home_notes_screen.dart
      add_note_screen.dart''',
      developmentPhases: [
        'Phase 1: Build UI screens & forms',
        'Phase 2: Integrate SQLite database helper',
        'Phase 3: Wire Provider state management',
        'Phase 4: Test offline persistence & search'
      ],
      implementationRoadmap: [
        'Step 1: Setup Flutter project & dependencies (sqflite, path, provider)',
        'Step 2: Create NoteModel with toMap() & fromMap() serialization',
        'Step 3: Build DatabaseHelper singleton class',
        'Step 4: Implement NotesProvider and UI list view'
      ],
      testingStrategy:
          'Unit test DatabaseHelper CRUD methods using mock sqflite FFI database in memory.',
      securityConsiderations:
          'Sanitize SQL query parameters to prevent local injection vulnerabilities.',
      deploymentStrategy:
          'Build standalone Android APK and iOS runner bundle using `flutter build apk`.',
      documentationRequirements:
          'README.md containing setup steps, screenshots, and SQLite schema definition.',
      githubRepoStructure:
          'Standard Flutter repository layout with test/ folder and doc screenshots.',
      resumeDescription:
          'Built offline-first task tracker in Flutter using SQLite local database persistence and Provider state management.',
      interviewQuestions: [
        'How does SQLite local caching differ from Shared Preferences?',
        'What is the advantage of using a DatabaseHelper singleton pattern?'
      ],
      possibleImprovements: [
        'Add cloud sync with Firebase Cloud Firestore',
        'Add reminder notifications'
      ],
      advancedVersionIdeas: [
        'Add rich text markdown editor and PDF export option'
      ],
      sourceCodeUrl: 'https://github.com/flutter/samples',
      githubUrl: 'https://github.com/flutter/samples',
      learningOutcome:
          'Master local SQLite database management, asynchronous state flow, and mobile UI design.',
      keyFeatures: [
        'Offline SQLite storage',
        'Category filter',
        'Instant search',
        'Completion toggle'
      ],
      architectureNotes:
          'Clean separation between presentation widgets and local database data access layer.',
    ),

    // --- TIER 2: INTERMEDIATE ---
    ProjectModel(
      id: 'proj_ecommerce',
      title: 'E-Commerce Store & Payment Platform',
      description:
          'Full Stack web e-commerce platform with product catalog, cart management, PostgreSQL database, and Stripe payment checkout.',
      category: 'Web Development',
      difficulty: 'Intermediate',
      estimatedDuration: '4 Weeks',
      problemStatement:
          'Online merchants require a scalable web store featuring real-time product inventories, secure user checkout, and order history tracking.',
      realWorldUseCase:
          'Production web application for online retail stores and digital marketplaces.',
      targetUsers: 'Online shoppers and store administrators.',
      prerequisites: [
        'React.js',
        'Node.js Express',
        'SQL / PostgreSQL',
        'REST APIs'
      ],
      requiredSkills: [
        'React.js',
        'TypeScript',
        'Node.js',
        'PostgreSQL',
        'Stripe API',
        'Docker'
      ],
      technologies: [
        'React.js',
        'TypeScript',
        'Node.js',
        'Express',
        'PostgreSQL',
        'Stripe'
      ],
      whyTheseTechnologies:
          'React enables high-performance single page application UI; Node.js Express & PostgreSQL deliver scalable backend REST APIs.',
      systemArchitecture:
          'Client-Server REST Architecture: React Single Page Application frontend communicating with Node.js Express REST API backend and PostgreSQL database.',
      majorModules: [
        'User Authentication (JWT)',
        'Product Catalog & Search',
        'Shopping Cart & Orders',
        'Stripe Payment Gateway'
      ],
      databaseDesign:
          'PostgreSQL relational schema with tables: `users`, `products`, `orders`, `order_items`.',
      apiRequirements:
          'REST APIs: GET /api/products, POST /api/cart, POST /api/checkout-session, GET /api/orders.',
      folderStructure: '''client/
  src/
    components/
    pages/
    services/
server/
  src/
    controllers/
    models/
    routes/
    middleware/''',
      developmentPhases: [
        'Phase 1: Design database schema & setup PostgreSQL',
        'Phase 2: Build Node.js REST API controllers',
        'Phase 3: Develop React frontend components & cart state',
        'Phase 4: Integrate Stripe Payment Webhooks'
      ],
      testingStrategy:
          'Integration tests for API endpoints using Jest & Supertest; End-to-End testing with Playwright.',
      securityConsiderations:
          'Store API secrets in environment variables (.env); hashing passwords using bcrypt; validating payment webhooks.',
      deploymentStrategy:
          'Deploy Node.js API to Render/AWS App Runner; deploy React frontend to Vercel/Netlify; managed PostgreSQL database on Supabase/Neon.',
      documentationRequirements:
          'Comprehensive API documentation with Swagger / Postman collection.',
      resumeDescription:
          'Architected full stack e-commerce web platform using React, TypeScript, Node.js REST APIs, PostgreSQL, and Stripe payment gateway.',
      interviewQuestions: [
        'How do you handle race conditions during product inventory checkout?',
        'Explain how Stripe webhook signatures prevent fraudulent order confirmations.'
      ],
      sourceCodeUrl: 'https://github.com/gothinkster/realworld',
      githubUrl: 'https://github.com/gothinkster/realworld',
      learningOutcome:
          'Master REST API design, relational database transactions, authentication, and payment gateway integration.',
    ),

    // --- TIER 3: ADVANCED ---
    ProjectModel(
      id: 'proj_ai_rag',
      title: 'Real-Time AI Document Q&A Assistant',
      description:
          'Retrieval-Augmented Generation (RAG) system enabling natural language Q&A over custom technical PDF documentation using LangChain & Vector Databases.',
      category: 'AI & Machine Learning',
      difficulty: 'Advanced',
      estimatedDuration: '6 Weeks',
      problemStatement:
          'Engineers spend excessive time reading through multi-hundred page PDF specifications to find exact configuration rules.',
      realWorldUseCase:
          'Enterprise knowledge base assistant for internal technical documentation.',
      targetUsers: 'Software engineers, researchers, technical support teams.',
      prerequisites: [
        'Python',
        'LangChain / LlamaIndex',
        'Vector Math',
        'FastAPI'
      ],
      requiredSkills: [
        'Python',
        'PyTorch',
        'LangChain',
        'ChromaDB / Pinecone',
        'FastAPI',
        'Streamlit'
      ],
      technologies: [
        'Python',
        'LangChain',
        'ChromaDB',
        'FastAPI',
        'OpenAI / Llama 3',
        'Streamlit'
      ],
      whyTheseTechnologies:
          'LangChain provides orchestrations for document chunking and vector embeddings; ChromaDB offers fast similarity search.',
      systemArchitecture:
          'RAG Pipeline: PDF Document -> Chunking -> Vector Embeddings -> Chroma Vector DB -> Similarity Search -> LLM Contextual Generation.',
      majorModules: [
        'PDF Ingestion & Text Chunking',
        'Vector Embedding Generation',
        'Semantic Similarity Search',
        'LLM Response Streaming UI'
      ],
      databaseDesign:
          'ChromaDB Vector Store indexed with HNSW (Hierarchical Navigable Small World) for cosine similarity lookup.',
      apiRequirements:
          'FastAPI endpoints: POST /api/upload-pdf, POST /api/query-stream (Server-Sent Events streaming).',
      folderStructure: '''backend/
  app/
    core/
    rag_engine.py
    vector_store.py
    main.py
frontend/
  src/
    app.py (Streamlit UI)''',
      developmentPhases: [
        'Phase 1: Implement PDF parser & text splitter',
        'Phase 2: Setup ChromaDB vector embedding storage',
        'Phase 3: Build RAG chain with LangChain',
        'Phase 4: Create FastAPI streaming endpoint & UI'
      ],
      testingStrategy:
          'Evaluate retrieval precision & recall using RAGAS benchmark framework.',
      securityConsiderations:
          'Sanitize prompt inputs against prompt injection attacks; rate limit API queries.',
      deploymentStrategy:
          'Containerize application with Docker Compose; deploy to AWS ECS or Hugging Face Spaces.',
      documentationRequirements:
          'Architecture diagram showing vector embedding generation and RAG retrieval flow.',
      resumeDescription:
          'Engineered RAG document Q&A pipeline using Python, LangChain, ChromaDB vector store, and FastAPI streaming response endpoints.',
      interviewQuestions: [
        'What is the difference between dense vector retrieval and sparse keyword search?',
        'How do chunk size and chunk overlap impact RAG context recall?'
      ],
      sourceCodeUrl: 'https://github.com/langchain-ai/langchain',
      githubUrl: 'https://github.com/langchain-ai/langchain',
      learningOutcome:
          'Master vector embeddings, similarity search algorithms, RAG pipeline orchestration, and LLM application development.',
    ),

    // --- TIER 4: INDUSTRY LEVEL ---
    ProjectModel(
      id: 'proj_unidocs',
      title: 'CSSE Study Hub Platform',
      description:
          'Production-grade academic curriculum & career development mobile/web platform with Clean Architecture, Firebase Auth, and local offline indexing.',
      category: 'Industry Level',
      difficulty: 'Industry Level',
      estimatedDuration: '8 Weeks',
      problemStatement:
          'Computer Science students need a single unified platform providing semester syllabus textbooks, lab manuals, and 5 career development hubs without needing internet for downloaded files.',
      realWorldUseCase:
          'Production educational mobile app deployed on Google Play Store serving thousands of engineering students.',
      targetUsers: 'Engineering students, professors, placement aspirants.',
      prerequisites: [
        'Dart / Flutter',
        'Clean Architecture',
        'Firebase / GCP',
        'Offline Storage',
        'CI/CD'
      ],
      requiredSkills: [
        'Flutter',
        'Clean Architecture',
        'Firebase Firestore',
        'Firebase Storage',
        'Provider',
        'CI/CD'
      ],
      technologies: [
        'Flutter',
        'Dart',
        'Firebase Auth',
        'Cloud Firestore',
        'Cloud Storage',
        'Provider'
      ],
      whyTheseTechnologies:
          'Flutter delivers single codebase iOS/Android native performance; Firebase delivers serverless authentication, metadata database, and cloud file delivery.',
      systemArchitecture:
          'Clean Architecture with 3 Layers: Data Layer (Repositories & Firebase Data Sources), Domain Layer (Models & Business Logic), Presentation Layer (Providers & Material 3 UI Screens).',
      majorModules: [
        'Academic Curriculum Engine (Years -> Sems -> Subjects -> Textbooks -> PDFs)',
        '5 Beyond-Academics Hubs (Career, Coding, Placement, Projects, Higher Ed)',
        'Global Search Engine (Indexed offline search)',
        'Admin Content Portal'
      ],
      databaseDesign:
          'Cloud Firestore NoSQL collections: `years`, `semesters`, `subjects`, `resources`, `career_techs`, `placement_resources`, `projects`.',
      apiRequirements:
          'Firebase SDK streams and REST fallback methods with offline persistence.',
      folderStructure: '''lib/
  core/
    constants/
    routes/
    theme/
    utils/
  data/
    datasources/
    models/
    repositories/
  presentation/
    providers/
    screens/
    widgets/''',
      developmentPhases: [
        'Phase 1: Establish Clean Architecture layer contracts',
        'Phase 2: Implement Academic Curriculum PDF navigation engine',
        'Phase 3: Build 5 Beyond-Academics Hubs',
        'Phase 4: Integrate Global Search Engine & Automated Tests'
      ],
      testingStrategy:
          'Unit tests for repositories & search engine; Widget testing for screens; 100% clean static analysis with `flutter analyze`.',
      securityConsiderations:
          'Firebase Security Rules (Role-based: Admin write vs Public read); environment key configuration; input sanitization.',
      deploymentStrategy:
          'Automated release pipeline generating signed Android App Bundles (AAB) for Google Play Console distribution.',
      documentationRequirements:
          'Complete project walkthrough.md, architectural implementation plan, and API reference documentation.',
      resumeDescription:
          'Architected production-grade CSSE Study Hub mobile platform in Flutter using Clean Architecture, Firebase serverless backend, offline indexing engine, and automated CI/CD release pipelines.',
      interviewQuestions: [
        'How do you decouple presentation screens from Firebase SDK dependencies using Repository interfaces?',
        'Explain your strategy for separating lightweight Firestore JSON metadata from heavy Cloud Storage PDF binaries.'
      ],
      sourceCodeUrl: 'https://github.com/flutter/samples',
      githubUrl: 'https://github.com/flutter/samples',
      learningOutcome:
          'Master enterprise Clean Architecture, serverless cloud database design, offline mobile caching, and Play Store release engineering.',
    ),
  ];
}

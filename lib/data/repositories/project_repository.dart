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

  static const List<ProjectModel> _fallbackProjects = [
    ProjectModel(
      id: 'proj_flutter_studyhub',
      title: 'CSSE Study Hub - Academic & Career Platform',
      description: 'Cross-platform mobile and web application for engineering students featuring resources, roadmaps, and coding sheets.',
      category: 'Flutter Projects',
      difficulty: 'Advanced',
      technologies: ['Flutter', 'Dart', 'Firebase Auth', 'Cloud Firestore', 'Firebase Storage', 'Provider'],
      sourceCodeUrl: 'https://github.com/flutter/samples',
      githubUrl: 'https://github.com/flutter/flutter',
      learningOutcome: 'Mastered Clean Architecture, Multi-Provider state management, Cloud Firestore offline caching, and responsive UI design.',
      keyFeatures: ['Offline PDF Caching', 'Global Search Engine', 'Career Roadmaps', 'Dark/Light Theme Switching'],
      architectureNotes: 'Clean Architecture with explicit separation of Data, Domain, and Presentation layers.',
    ),
    ProjectModel(
      id: 'proj_ai_object_detection',
      title: 'Real-Time Edge Object Detection System',
      description: 'Computer vision application detecting objects from live webcam or video feeds using YOLOv8 and PyTorch.',
      category: 'AI Projects',
      difficulty: 'Intermediate',
      technologies: ['Python', 'PyTorch', 'YOLOv8', 'OpenCV', 'Streamlit'],
      sourceCodeUrl: 'https://github.com/ultralytics/ultralytics',
      githubUrl: 'https://github.com/ultralytics/ultralytics',
      learningOutcome: 'Learned bounding box inference, OpenCV video processing, confidence threshold tuning, and web interface deployment.',
      keyFeatures: ['30+ FPS Inference', 'Custom Class Training', 'Bounding Box Visualization'],
      architectureNotes: 'Model loading decoupled from frame capture pipeline using asynchronous threads.',
    ),
    ProjectModel(
      id: 'proj_web_ecommerce',
      title: 'Scalable Microservices E-Commerce Platform',
      description: 'Full-stack e-commerce web platform featuring product catalog, shopping cart, Stripe payment gateway, and order tracking.',
      category: 'Web Development Projects',
      difficulty: 'Advanced',
      technologies: ['React.js', 'Node.js', 'Express.js', 'MongoDB', 'Redis', 'Stripe API', 'Docker'],
      sourceCodeUrl: 'https://github.com/gothinkster/realworld',
      githubUrl: 'https://github.com/gothinkster/realworld',
      learningOutcome: 'Understood RESTful API design, JWT authentication, MongoDB schema design, and Redis caching.',
      keyFeatures: ['JWT Auth', 'Stripe Integration', 'Order History', 'Admin Inventory Dashboard'],
      architectureNotes: 'Express backend architecture structured with Controllers, Routes, Services, and Mongoose Models.',
    ),
    ProjectModel(
      id: 'proj_py_facerecog',
      title: 'Smart Automated Attendance System using Face Recognition',
      description: 'Automated classroom attendance monitoring system using Python face_recognition library and SQLite.',
      category: 'Python Projects',
      difficulty: 'Beginner',
      technologies: ['Python', 'OpenCV', 'face_recognition', 'Pandas', 'Tkinter / Streamlit'],
      sourceCodeUrl: 'https://github.com/ageitgey/face_recognition',
      githubUrl: 'https://github.com/ageitgey/face_recognition',
      learningOutcome: 'Understood facial feature encoding vectors, Euclidean distance matching, and CSV automated log creation.',
      keyFeatures: ['Live Camera Capture', 'Automated CSV Export', 'Duplicate Attendance Prevention'],
      architectureNotes: 'Simple modular script structure separating Camera Capture from Face Encoder and Storage Logger.',
    ),
    ProjectModel(
      id: 'proj_java_bank',
      title: 'Core Banking System & Transaction Engine',
      description: 'Console and GUI based banking simulation in Java demonstrating OOP principles, file handling, and multithreaded transaction processing.',
      category: 'Java Projects',
      difficulty: 'Intermediate',
      technologies: ['Java', 'JDBC', 'MySQL', 'Swing / JavaFX', 'JUnit 5'],
      sourceCodeUrl: 'https://github.com/spring-projects/spring-petclinic',
      githubUrl: 'https://github.com/spring-projects/spring-petclinic',
      learningOutcome: 'Mastered Java OOP concepts (Inheritance, Polymorphism, Encapsulation), JDBC connections, and SQL Transactions.',
      keyFeatures: ['Account Creation', 'Fund Transfer with Lock Handling', 'Transaction History Statement'],
      architectureNotes: 'DAO (Data Access Object) Pattern used for SQL queries separation.',
    ),
    ProjectModel(
      id: 'proj_mini_url_shortener',
      title: 'URL Shortener Service (Bit.ly Clone)',
      description: 'Lightweight Mini Project generating short URLs with analytics tracking for clicks and geolocation.',
      category: 'Mini Projects',
      difficulty: 'Beginner',
      technologies: ['Node.js', 'Express.js', 'MongoDB / SQLite', 'HTML/CSS'],
      sourceCodeUrl: 'https://github.com/expressjs/express',
      githubUrl: 'https://github.com/expressjs/express',
      learningOutcome: 'Learned Base62 encoding, short hash mapping, HTTP 302 redirects, and database indexing.',
      keyFeatures: ['Instant Short URL Generation', 'Click Analytics Counter'],
      architectureNotes: 'Singular MVC Express app.',
    ),
  ];
}

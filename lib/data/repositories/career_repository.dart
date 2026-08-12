import '../datasources/firebase_datasource.dart';
import '../models/career_model.dart';
import '../models/beyond_academics_model.dart';

class CareerRepository {
  final FirebaseDataSource _firebaseDataSource;

  CareerRepository({required FirebaseDataSource firebaseDataSource})
      : _firebaseDataSource = firebaseDataSource;

  Future<List<CareerModel>> getCareerTechnologies() async {
    try {
      final remoteData = await _firebaseDataSource.getCareerTechnologies();
      if (remoteData.isNotEmpty) {
        return remoteData.map((e) => CareerModel.fromJson(e)).toList();
      }
    } catch (_) {}

    return _fallbackCareerTechnologies;
  }

  static List<CareerModel> get fallbackCareerTechnologies => _fallbackCareerTechnologies;

  static const List<CareerModel> _fallbackCareerTechnologies = [
    // --- DOMAIN 1: EMERGING TECH & AI ---
    CareerModel(
      id: 'ai_engineer',
      name: 'Artificial Intelligence & Machine Learning Engineer',
      category: 'Emerging Tech & AI',
      icon: 'smart_toy_rounded',
      introduction: 'Design, train, and deploy deep learning neural networks, computer vision algorithms, and natural language models.',
      whyLearn: 'Core cognitive engineering role powering autonomous systems, medical imaging, and enterprise automation.',
      careerOpportunities: ['AI Research Engineer', 'Machine Learning Engineer', 'Computer Vision Specialist', 'Data Scientist'],
      requiredSkills: ['Python', 'Linear Algebra', 'PyTorch', 'TensorFlow', 'Scikit-Learn', 'OpenCV'],
      learningRoadmap: [
        'Phase 1: Python, Linear Algebra & Probability Fundamentals',
        'Phase 2: Classical Machine Learning Algorithms (Regression, Decision Trees, SVMs)',
        'Phase 3: Deep Learning & Neural Network Architectures (CNNs, RNNs, Transformers)',
        'Phase 4: MLOps, Model Quantization & Production API Deployment'
      ],
      learningPhases: [
        LearningPhaseModel(
          phaseNumber: 1,
          title: 'Math & Python Core',
          subtitle: 'Linear Algebra, Calculus & Tensors',
          description: 'Master matrix operations, partial derivatives, and tensor manipulations in PyTorch.',
          estimatedDuration: '4 Weeks',
          topics: ['Linear Algebra', 'Calculus', 'PyTorch Tensors'],
          milestones: ['Build custom autograd engine', 'Implement linear regression from scratch'],
        ),
        LearningPhaseModel(
          phaseNumber: 2,
          title: 'Deep Learning & Neural Networks',
          subtitle: 'CNNs, Transformers & Backprop',
          description: 'Train deep convolutional networks and self-attention mechanisms for vision and text.',
          estimatedDuration: '6 Weeks',
          topics: ['CNNs', 'ResNets', 'Object Detection', 'Transformers'],
          milestones: ['Classify CIFAR-10 images at 90%+ accuracy', 'Fine-tune Vision Transformer'],
        ),
      ],
      skillMatrix: [
        SkillMatrixModel(
          skillName: 'Python & PyTorch',
          category: 'Programming & Frameworks',
          level: 'Advanced',
          importance: 'Mandatory',
          description: 'Deep neural network design, CUDA tensor acceleration, and model autograd.',
        ),
        SkillMatrixModel(
          skillName: 'Computer Vision & OpenCV',
          category: 'Domain Mastery',
          level: 'Intermediate',
          importance: 'Recommended',
          description: 'Image filtering, bounding box regressions, and YOLO object tracking.',
        ),
      ],
      portfolioRequirements: [
        'End-to-End Image Classification Model deployed with FastAPI',
        'Fine-Tuned LLM on custom technical documentation'
      ],
      resumeRequirements: [
        'Trained PyTorch ResNet-50 achieving 94.2% top-1 accuracy on custom dataset.',
        'Optimized model inference latency by 40% using ONNX Runtime quantization.'
      ],
      interviewPrepTopics: ['Bias-Variance Tradeoff', 'Backpropagation derivation', 'Overfitting regularization'],
      entryLevelResponsibilities: ['Train and evaluate ML models', 'Clean and preprocess datasets', 'Build model serving APIs'],
      bestFreeResources: [
        CareerResourceLink(title: 'Fast.ai Practical Deep Learning', url: 'https://fast.ai', platform: 'Fast.ai'),
        CareerResourceLink(title: 'Google Machine Learning Crash Course', url: 'https://developers.google.com/machine-learning/crash-course', platform: 'Google'),
      ],
      books: [
        CareerResourceLink(title: 'Hands-On Machine Learning with Scikit-Learn, Keras, & TensorFlow', url: 'https://oreilly.com', platform: 'OReilly'),
      ],
      certifications: [
        CareerResourceLink(title: 'Deep Learning Specialization by Andrew Ng', url: 'https://coursera.org', platform: 'Coursera'),
      ],
      youtubePlaylists: [
        CareerResourceLink(title: '3Blue1Brown Neural Networks', url: 'https://youtube.com', platform: 'YouTube'),
      ],
      miniProjects: [
        CareerProjectInfo(title: 'CIFAR-10 Image Classifier', description: 'Build CNN using PyTorch', difficulty: 'Beginner'),
      ],
      advancedProjects: [
        CareerProjectInfo(title: 'Real-Time Edge Object Detector', description: 'YOLOv8 Streamlit application', difficulty: 'Advanced'),
      ],
      githubRepos: [
        CareerResourceLink(title: 'PyTorch Examples', url: 'https://github.com/pytorch/examples', platform: 'GitHub'),
      ],
      futureScope: 'Rapid growth driven by autonomous robotics, generative AI, and edge AI hardware.',
    ),

    CareerModel(
      id: 'genai_engineer',
      name: 'Generative AI & LLM Systems Engineer',
      category: 'Emerging Tech & AI',
      icon: 'psychology_rounded',
      introduction: 'Architect applications powered by Large Language Models, Retrieval-Augmented Generation (RAG), and autonomous AI agents.',
      whyLearn: 'Fastest-growing engineering specialization transforming enterprise software, search, and productivity.',
      careerOpportunities: ['GenAI Engineer', 'LLM Systems Architect', 'Prompt Engineer Specialist'],
      requiredSkills: ['Python', 'LangChain', 'LlamaIndex', 'Vector Databases (Pinecone, Chroma)', 'Fine-tuning (LoRA)', 'FastAPI'],
      learningRoadmap: [
        'Phase 1: Transformer Attention Mechanism & Open-Source LLMs',
        'Phase 2: Vector Embeddings & Similarity Search',
        'Phase 3: RAG Pipelines & Semantic Search Optimization',
        'Phase 4: Fine-tuning Open LLMs (Llama 3, Mistral) with PEFT/LoRA'
      ],
      bestFreeResources: [
        CareerResourceLink(title: 'Hugging Face NLP Course', url: 'https://huggingface.co/learn', platform: 'HuggingFace'),
      ],
      books: [
        CareerResourceLink(title: 'Generative AI on AWS', url: 'https://oreilly.com', platform: 'OReilly'),
      ],
      certifications: [
        CareerResourceLink(title: 'LangChain Developer Certification', url: 'https://langchain.com', platform: 'LangChain'),
      ],
      youtubePlaylists: [
        CareerResourceLink(title: 'Andrej Karpathy - Let us build GPT', url: 'https://youtube.com', platform: 'YouTube'),
      ],
      miniProjects: [
        CareerProjectInfo(title: 'PDF Document Q&A Bot', description: 'RAG system using LangChain & ChromaDB', difficulty: 'Intermediate'),
      ],
      advancedProjects: [
        CareerProjectInfo(title: 'Multi-Agent Autonomous Coding Assistant', description: 'CrewAI agent swarm writing code', difficulty: 'Advanced'),
      ],
      githubRepos: [
        CareerResourceLink(title: 'LangChain GitHub Repo', url: 'https://github.com/langchain-ai/langchain', platform: 'GitHub'),
      ],
      futureScope: 'Critical infrastructure layer for next-generation AI-native software applications.',
    ),

    // --- DOMAIN 2: SOFTWARE ENGINEERING ---
    CareerModel(
      id: 'fullstack_dev',
      name: 'Full Stack Web Development Engineer',
      category: 'Software Engineering',
      icon: 'web_rounded',
      introduction: 'Build modern responsive frontends and resilient backend REST/GraphQL microservices.',
      whyLearn: 'Foundational engineering role across global tech companies, high-growth startups, and freelancing.',
      careerOpportunities: ['Full Stack Engineer', 'Frontend Engineer', 'Backend Developer', 'Web Architect'],
      requiredSkills: ['TypeScript', 'React.js', 'Node.js', 'Express', 'PostgreSQL', 'Redis', 'Docker'],
      learningRoadmap: [
        'Phase 1: HTML5, CSS3, Modern JavaScript (ES6+), DOM Manipulation',
        'Phase 2: React.js Component Architecture, Hooks, State Management',
        'Phase 3: Node.js Express REST APIs, Authentication (JWT), PostgreSQL ORMs',
        'Phase 4: Caching (Redis), Containerization (Docker), CI/CD & Vercel/Render Deployment'
      ],
      bestFreeResources: [
        CareerResourceLink(title: 'The Odin Project', url: 'https://theodinproject.com', platform: 'Web'),
        CareerResourceLink(title: 'Full Stack Open (University of Helsinki)', url: 'https://fullstackopen.com', platform: 'Helsinki'),
      ],
      books: [
        CareerResourceLink(title: 'Eloquent JavaScript', url: 'https://eloquentjavascript.net', platform: 'Web'),
      ],
      certifications: [
        CareerResourceLink(title: 'Meta Front-End Developer Certificate', url: 'https://coursera.org', platform: 'Coursera'),
      ],
      youtubePlaylists: [
        CareerResourceLink(title: 'Traversy Media Web Dev Tutorials', url: 'https://youtube.com', platform: 'YouTube'),
      ],
      miniProjects: [
        CareerProjectInfo(title: 'Collaborative Task Board', description: 'React & Node.js Kanban app', difficulty: 'Beginner'),
      ],
      advancedProjects: [
        CareerProjectInfo(title: 'E-Commerce Platform with Stripe Checkout', description: 'Full stack microservices store', difficulty: 'Advanced'),
      ],
      githubRepos: [
        CareerResourceLink(title: 'RealWorld Example App', url: 'https://github.com/gothinkster/realworld', platform: 'GitHub'),
      ],
      futureScope: 'Constant demand as business digital transformation expands globally.',
    ),

    CareerModel(
      id: 'backend_engineer',
      name: 'Backend Systems & Microservices Engineer',
      category: 'Software Engineering',
      icon: 'dns_rounded',
      introduction: 'Design high-throughput backend APIs, distributed databases, event-driven messaging, and server infrastructure.',
      whyLearn: 'Core discipline ensuring scalable software performance, data integrity, and system reliability.',
      careerOpportunities: ['Backend Engineer', 'Systems Architect', 'Database Administrator', 'API Developer'],
      requiredSkills: ['Go (Golang)', 'Java Spring Boot', 'PostgreSQL', 'Apache Kafka', 'Redis', 'gRPC'],
      learningRoadmap: [
        'Phase 1: Data Structures, OOP, SQL Relational Schemas & Indexing',
        'Phase 2: REST & gRPC API Design, Authentication, Middleware',
        'Phase 3: Database Transactions (ACID), Caching (Redis), Connection Pools',
        'Phase 4: Distributed Systems, Message Queues (Kafka), Docker & Kubernetes'
      ],
      bestFreeResources: [
        CareerResourceLink(title: 'System Design Primer', url: 'https://github.com/donnemartin/system-design-primer', platform: 'GitHub'),
      ],
      books: [
        CareerResourceLink(title: 'Designing Data-Intensive Applications by Martin Kleppmann', url: 'https://oreilly.com', platform: 'OReilly'),
      ],
      certifications: [
        CareerResourceLink(title: 'AWS Certified Developer Associate', url: 'https://aws.amazon.com', platform: 'AWS'),
      ],
      youtubePlaylists: [
        CareerResourceLink(title: 'Hussein Nasser Database & Systems', url: 'https://youtube.com', platform: 'YouTube'),
      ],
      miniProjects: [
        CareerProjectInfo(title: 'Base62 URL Shortener Microservice', description: 'Fast Node.js / Go shortener', difficulty: 'Beginner'),
      ],
      advancedProjects: [
        CareerProjectInfo(title: 'Distributed Multi-Tenant Payment Processor', description: 'Go + Kafka idempotency engine', difficulty: 'Industry Level'),
      ],
      githubRepos: [
        CareerResourceLink(title: 'Awesome System Design', url: 'https://github.com', platform: 'GitHub'),
      ],
      futureScope: 'High compensation and long-term career growth in cloud enterprise engineering.',
    ),

    // --- DOMAIN 3: CLOUD & SECURITY ---
    CareerModel(
      id: 'cloud_devops',
      name: 'Cloud Native & DevOps Engineer',
      category: 'Cloud & Security',
      icon: 'cloud_rounded',
      introduction: 'Automate infrastructure provisioning, CI/CD deployment pipelines, container orchestration, and cloud monitoring.',
      whyLearn: 'Essential engineering function bridging software development and IT cloud infrastructure.',
      careerOpportunities: ['DevOps Engineer', 'Cloud Architect', 'Site Reliability Engineer (SRE)', 'Infrastructure Engineer'],
      requiredSkills: ['Linux', 'Docker', 'Kubernetes', 'Terraform', 'GitHub Actions', 'AWS / GCP', 'Prometheus'],
      learningRoadmap: [
        'Phase 1: Linux Administration, Bash Shell Scripting & Networking (TCP/IP, DNS)',
        'Phase 2: Docker Containerization & Docker Compose Multi-Container Orchestration',
        'Phase 3: Kubernetes Deployment, Pods, Services, Helm Charts & Ingress',
        'Phase 4: Infrastructure as Code (Terraform), CI/CD Automation & Grafana Monitoring'
      ],
      bestFreeResources: [
        CareerResourceLink(title: 'Kubernetes Official Documentation', url: 'https://kubernetes.io/docs', platform: 'Kubernetes'),
      ],
      books: [
        CareerResourceLink(title: 'The Phoenix Project', url: 'https://oreilly.com', platform: 'OReilly'),
      ],
      certifications: [
        CareerResourceLink(title: 'Certified Kubernetes Administrator (CKA)', url: 'https://cncf.io', platform: 'CNCF'),
      ],
      youtubePlaylists: [
        CareerResourceLink(title: 'TechWorld with Nana DevOps Course', url: 'https://youtube.com', platform: 'YouTube'),
      ],
      miniProjects: [
        CareerProjectInfo(title: 'Dockerized Web App with CI/CD', description: 'GitHub Actions deploy pipeline', difficulty: 'Beginner'),
      ],
      advancedProjects: [
        CareerProjectInfo(title: 'Multi-Region Kubernetes Cluster with Terraform', description: 'Production AWS EKS Setup', difficulty: 'Advanced'),
      ],
      githubRepos: [
        CareerResourceLink(title: 'DevOps Exercises', url: 'https://github.com/bregman-arie/devops-exercises', platform: 'GitHub'),
      ],
      futureScope: 'Indispensable role as enterprise software moves 100% to cloud infrastructure.',
    ),

    CareerModel(
      id: 'cybersecurity',
      name: 'Cyber Security & Ethical Hacking Specialist',
      category: 'Cloud & Security',
      icon: 'security_rounded',
      introduction: 'Protect networks, web applications, and cloud environments against cyber threats, vulnerabilities, and unauthorized intrusions.',
      whyLearn: 'Critical global defense discipline protecting user data, finance systems, and infrastructure.',
      careerOpportunities: ['Ethical Hacker', 'Penetration Tester', 'SOC Security Analyst', 'Cybersecurity Engineer'],
      requiredSkills: ['Linux', 'Network Protocols', 'OWASP Top 10', 'Wireshark', 'Metasploit', 'Burp Suite', 'Python'],
      learningRoadmap: [
        'Phase 1: Computer Networks (OSI Model, Wireshark Packet Analysis, TCP/IP Security)',
        'Phase 2: Linux Security, Privilege Escalation & Cryptography (RSA, AES)',
        'Phase 3: Web Application Penetration Testing & OWASP Vulnerability Exploitation',
        'Phase 4: Cloud Security Auditing, SIEM Monitoring & Incident Response'
      ],
      bestFreeResources: [
        CareerResourceLink(title: 'TryHackMe Cyber Security Training', url: 'https://tryhackme.com', platform: 'TryHackMe'),
        CareerResourceLink(title: 'Hack The Box', url: 'https://hackthebox.com', platform: 'HackTheBox'),
      ],
      books: [
        CareerResourceLink(title: 'The Web Application Hacker’s Handbook', url: 'https://wiley.com', platform: 'Wiley'),
      ],
      certifications: [
        CareerResourceLink(title: 'CompTIA Security+ / CEH', url: 'https://comptia.org', platform: 'CompTIA'),
      ],
      youtubePlaylists: [
        CareerResourceLink(title: 'NetworkChuck Security Lessons', url: 'https://youtube.com', platform: 'YouTube'),
      ],
      miniProjects: [
        CareerProjectInfo(title: 'Port Scanner & Vulnerability Detector', description: 'Python socket security tool', difficulty: 'Beginner'),
      ],
      advancedProjects: [
        CareerProjectInfo(title: 'Automated Web Vulnerability Scanner', description: 'OWASP Top 10 auditing tool', difficulty: 'Advanced'),
      ],
      githubRepos: [
        CareerResourceLink(title: 'PayloadsAllTheThings', url: 'https://github.com/swisskyrepo/PayloadsAllTheThings', platform: 'GitHub'),
      ],
      futureScope: 'High demand driven by increasing cloud data security regulations and threat landscape.',
    ),

    // --- DOMAIN 4: MOBILE & SYSTEMS ---
    CareerModel(
      id: 'flutter_engineer',
      name: 'Flutter & Cross-Platform Mobile Engineer',
      category: 'Mobile & Systems',
      icon: 'phone_android_rounded',
      introduction: 'Build high-performance, beautiful mobile and web applications using Dart, Flutter, and Clean Architecture.',
      whyLearn: 'Single codebase powering native iOS, Android, and Web applications used by millions.',
      careerOpportunities: ['Flutter Developer', 'Mobile Systems Architect', 'Cross-Platform Engineer'],
      requiredSkills: ['Dart', 'Flutter SDK', 'Clean Architecture', 'Provider / Riverpod', 'Firebase', 'REST APIs'],
      learningRoadmap: [
        'Phase 1: Dart Programming, OOP, Functional Concepts & Async Future/Streams',
        'Phase 2: Flutter Widget Tree, Layout Alignment, Custom Painters & Material 3',
        'Phase 3: State Management (Provider/Riverpod/Bloc), Clean Architecture & SQLite',
        'Phase 4: Firebase Integration, Offline Caching, Automated Testing & Play Store Release'
      ],
      bestFreeResources: [
        CareerResourceLink(title: 'Official Flutter Documentation', url: 'https://flutter.dev/docs', platform: 'Flutter'),
      ],
      books: [
        CareerResourceLink(title: 'Flutter in Action by Eric Windmill', url: 'https://manning.com', platform: 'Manning'),
      ],
      certifications: [
        CareerResourceLink(title: 'Google Associate Android Developer', url: 'https://developers.google.com', platform: 'Google'),
      ],
      youtubePlaylists: [
        CareerResourceLink(title: 'Flutter Official YouTube Channel', url: 'https://youtube.com', platform: 'YouTube'),
      ],
      miniProjects: [
        CareerProjectInfo(title: 'Smart Task & Student Notes App', description: 'Offline Flutter + SQLite app', difficulty: 'Beginner'),
      ],
      advancedProjects: [
        CareerProjectInfo(title: 'UniDocs Academic & Career Platform', description: 'Production Clean Architecture app', difficulty: 'Industry Level'),
      ],
      githubRepos: [
        CareerResourceLink(title: 'Flutter Samples Repo', url: 'https://github.com/flutter/samples', platform: 'GitHub'),
      ],
      futureScope: 'Dominant cross-platform framework choice for modern mobile startups and corporate apps.',
    ),

    CareerModel(
      id: 'android_engineer',
      name: 'Native Android & Kotlin Systems Engineer',
      category: 'Mobile & Systems',
      icon: 'android_rounded',
      introduction: 'Develop native high-performance Android applications using Kotlin, Jetpack Compose, Coroutines, and Dagger Hilt.',
      whyLearn: 'Core OS engineering role driving 3+ billion Android devices worldwide.',
      careerOpportunities: ['Native Android Engineer', 'Kotlin Specialist', 'Mobile SDK Developer'],
      requiredSkills: ['Kotlin', 'Jetpack Compose', 'Coroutines & Flow', 'Room Database', 'Dagger Hilt', 'Retrofit'],
      learningRoadmap: [
        'Phase 1: Kotlin Syntax, Lambdas, Null Safety & Coroutines',
        'Phase 2: Jetpack Compose Declarative UI & Navigation',
        'Phase 3: MVVM / MVI Architecture, Room DB & Retrofit APIs',
        'Phase 4: Dependency Injection (Hilt), WorkManager & Play Console Release'
      ],
      bestFreeResources: [
        CareerResourceLink(title: 'Android Developers Training', url: 'https://developer.android.com/courses', platform: 'Google'),
      ],
      books: [
        CareerResourceLink(title: 'Android Programming: The Big Nerd Ranch Guide', url: 'https://bignerdbranch.com', platform: 'BigNerdRanch'),
      ],
      certifications: [
        CareerResourceLink(title: 'Google Certified Associate Android Developer', url: 'https://developers.google.com', platform: 'Google'),
      ],
      youtubePlaylists: [
        CareerResourceLink(title: 'Philipp Lackner Android Tutorials', url: 'https://youtube.com', platform: 'YouTube'),
      ],
      miniProjects: [
        CareerProjectInfo(title: 'Weather Forecast App', description: 'Jetpack Compose + OpenWeather API', difficulty: 'Beginner'),
      ],
      advancedProjects: [
        CareerProjectInfo(title: 'Offline Video & Audio Streaming Player', description: 'Media3 Exoplayer + Room DB app', difficulty: 'Advanced'),
      ],
      githubRepos: [
        CareerResourceLink(title: 'Android Architecture Samples', url: 'https://github.com/android/architecture-samples', platform: 'GitHub'),
      ],
      futureScope: 'Enduring demand across mobile hardware, smart TVs, automotive (Android Auto), and wearables.',
    ),
  ];
}

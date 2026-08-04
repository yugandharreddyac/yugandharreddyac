import '../datasources/firebase_datasource.dart';
import '../models/career_model.dart';

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

  static const List<CareerModel> _fallbackCareerTechnologies = [
    CareerModel(
      id: 'ai',
      name: 'Artificial Intelligence',
      category: 'AI & Data',
      icon: 'smart_toy_rounded',
      introduction:
          'Artificial Intelligence involves creating intelligent agents that perceive their environment and make decisions to achieve specific goals, replicating human cognition.',
      whyLearn:
          'AI is driving automated decision-making across healthcare, finance, robotics, and consumer applications. High demand for engineers skilled in neural networks and deep learning.',
      careerOpportunities: [
        'AI Engineer',
        'Research Scientist',
        'Computer Vision Specialist',
        'NLP Engineer',
        'AI Ethics Officer'
      ],
      requiredSkills: [
        'Python',
        'Mathematics & Linear Algebra',
        'Probability & Statistics',
        'PyTorch / TensorFlow',
        'Neural Networks'
      ],
      learningRoadmap: [
        '1. Master Python & Scientific Libraries (NumPy, Pandas)',
        '2. Study Mathematics (Calculus, Linear Algebra, Probability)',
        '3. Learn Core Machine Learning Algorithms',
        '4. Deep Learning Architectures (CNN, RNN, Transformers)',
        '5. Model Deployment (ONNX, FastAPI, Docker)'
      ],
      bestFreeResources: [
        CareerResourceLink(
            title: 'Elements of AI (University of Helsinki)',
            url: 'https://www.elementsofai.com/',
            platform: 'Web',
            type: 'Course'),
        CareerResourceLink(
            title: 'Fast.ai - Practical Deep Learning for Coders',
            url: 'https://www.fast.ai/',
            platform: 'Fast.ai',
            type: 'Course'),
      ],
      books: [
        CareerResourceLink(
            title: 'Artificial Intelligence: A Modern Approach by Stuart Russell & Peter Norvig',
            url: '',
            platform: 'Book',
            type: 'Book'),
        CareerResourceLink(
            title: 'Deep Learning by Ian Goodfellow, Yoshua Bengio, and Aaron Courville',
            url: '',
            platform: 'Book',
            type: 'Book'),
      ],
      certifications: [
        CareerResourceLink(
            title: 'DeepLearning.AI TensorFlow Developer Professional Certificate',
            url: 'https://www.coursera.org/professional-certificates/tensorflow-in-practice',
            platform: 'Coursera',
            type: 'Certification'),
      ],
      youtubePlaylists: [
        CareerResourceLink(
            title: '3Blue1Brown - Neural Networks Series',
            url: 'https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi',
            platform: 'YouTube',
            type: 'Playlist'),
      ],
      miniProjects: [
        CareerProjectInfo(
            title: 'Handwritten Digit Recognizer (MNIST)',
            description: 'Train a CNN model using PyTorch to recognize handwritten numbers 0-9.',
            difficulty: 'Beginner'),
        CareerProjectInfo(
            title: 'Sentiment Analyzer App',
            description: 'Classify user review text as positive, neutral, or negative using DistilBERT.',
            difficulty: 'Intermediate'),
      ],
      advancedProjects: [
        CareerProjectInfo(
            title: 'Autonomous Mobile Robot Navigator',
            description: 'Real-time object detection and pathfinding using YOLOv8 and ROS2.',
            difficulty: 'Advanced'),
      ],
      githubRepos: [
        CareerResourceLink(
            title: 'huggingface/transformers',
            url: 'https://github.com/huggingface/transformers',
            platform: 'GitHub',
            type: 'Repository'),
      ],
      futureScope:
          'Generative AI, Autonomous Systems, AI-powered Healthcare Diagnostics, and Edge AI deployment will define the next decade of technology.',
    ),
    CareerModel(
      id: 'ml',
      name: 'Machine Learning',
      category: 'AI & Data',
      icon: 'psychology_rounded',
      introduction:
          'Machine Learning focuses on building models that automatically learn patterns from data and improve accuracy over time without being explicitly programmed.',
      whyLearn:
          'ML forms the core backbone of recommendation engines, predictive analytics, fraud detection, and modern data-driven software.',
      careerOpportunities: [
        'Machine Learning Engineer',
        'MLOps Engineer',
        'Data Scientist',
        'Applied Scientist'
      ],
      requiredSkills: [
        'Python / R',
        'Scikit-Learn',
        'XGBoost',
        'Feature Engineering',
        'ML Pipeline Optimization'
      ],
      learningRoadmap: [
        '1. Data Wrangling with Pandas & Data Visualization',
        '2. Supervised Learning (Regression, Classification)',
        '3. Unsupervised Learning (Clustering, PCA)',
        '4. Model Evaluation & Hyperparameter Tuning',
        '5. MLOps (MLflow, DVC, Kubernetes)'
      ],
      bestFreeResources: [
        CareerResourceLink(
            title: 'Andrew Ng Machine Learning Specialization',
            url: 'https://www.coursera.org/specializations/machine-learning-introduction',
            platform: 'Coursera',
            type: 'Course'),
      ],
      books: [
        CareerResourceLink(
            title: 'Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow by Aurélien Géron',
            url: '',
            platform: 'Book',
            type: 'Book'),
      ],
      certifications: [
        CareerResourceLink(
            title: 'AWS Certified Machine Learning - Specialty',
            url: 'https://aws.amazon.com/certification/certified-machine-learning-specialty/',
            platform: 'AWS',
            type: 'Certification'),
      ],
      youtubePlaylists: [
        CareerResourceLink(
            title: 'StatQuest with Josh Starmer - Machine Learning',
            url: 'https://www.youtube.com/c/joshstarmer',
            platform: 'YouTube',
            type: 'Playlist'),
      ],
      miniProjects: [
        CareerProjectInfo(
            title: 'House Price Prediction System',
            description: 'Build a multi-variable regression model with Scikit-Learn.',
            difficulty: 'Beginner'),
      ],
      advancedProjects: [
        CareerProjectInfo(
            title: 'End-to-End MLOps Pipeline',
            description: 'Deploy an automated ML pipeline using Fast-API, Docker, MLflow, and GitHub Actions.',
            difficulty: 'Advanced'),
      ],
      githubRepos: [
        CareerResourceLink(
            title: 'scikit-learn/scikit-learn',
            url: 'https://github.com/scikit-learn/scikit-learn',
            platform: 'GitHub',
            type: 'Repository'),
      ],
      futureScope:
          'Automated Machine Learning (AutoML), Federated Learning, and Continuous Online Learning systems.',
    ),
    CareerModel(
      id: 'cloud',
      name: 'Cloud Computing',
      category: 'Infrastructure',
      icon: 'cloud_done_rounded',
      introduction:
          'Cloud Computing provides on-demand availability of computing resources (servers, databases, networking, software) over the internet with pay-as-you-go pricing.',
      whyLearn:
          'Every enterprise app relies on AWS, GCP, or Azure for scalable hosting, global elasticity, and high reliability.',
      careerOpportunities: [
        'Cloud Solutions Architect',
        'Cloud Infrastructure Engineer',
        'DevOps Engineer',
        'Site Reliability Engineer (SRE)'
      ],
      requiredSkills: [
        'AWS / GCP / Azure Services',
        'Linux Administration',
        'Networking (VPC, Subnets, DNS)',
        'Infrastructure as Code (Terraform)',
        'Docker & Kubernetes'
      ],
      learningRoadmap: [
        '1. Master Networking Fundamentals & Linux Command Line',
        '2. Choose a Primary Cloud Provider (AWS/Azure/GCP)',
        '3. Learn Core Cloud Compute, Storage & Database Services',
        '4. Automate Infrastructure using Terraform / CloudFormation',
        '5. Container Orchestration with Kubernetes'
      ],
      bestFreeResources: [
        CareerResourceLink(
            title: 'AWS Skill Builder Free Tier',
            url: 'https://explore.skillbuilder.aws/',
            platform: 'AWS',
            type: 'Course'),
      ],
      books: [
        CareerResourceLink(
            title: 'Cloud Native Patterns by Cornelia Davis',
            url: '',
            platform: 'Book',
            type: 'Book'),
      ],
      certifications: [
        CareerResourceLink(
            title: 'AWS Certified Solutions Architect – Associate',
            url: 'https://aws.amazon.com/certification/certified-solutions-architect-associate/',
            platform: 'AWS',
            type: 'Certification'),
      ],
      youtubePlaylists: [
        CareerResourceLink(
            title: 'freeCodeCamp - AWS Certified Cloud Practitioner Course',
            url: 'https://www.youtube.com/watch?v=3hLmDS179YE',
            platform: 'YouTube',
            type: 'Playlist'),
      ],
      miniProjects: [
        CareerProjectInfo(
            title: 'Static Website Hosting on S3 + CloudFront',
            description: 'Configure SSL, custom domain, and global CDN caching on AWS.',
            difficulty: 'Beginner'),
      ],
      advancedProjects: [
        CareerProjectInfo(
            title: 'Multi-Region High-Availability Cluster',
            description: 'Deploy auto-scaling web application across multi-AZs using Terraform and EKS.',
            difficulty: 'Advanced'),
      ],
      githubRepos: [
        CareerResourceLink(
            title: 'hashicorp/terraform',
            url: 'https://github.com/hashicorp/terraform',
            platform: 'GitHub',
            type: 'Repository'),
      ],
      futureScope:
          'Serverless Architectures, Multi-Cloud Orchestration, and Edge Cloud Infrastructure.',
    ),
    CareerModel(
      id: 'cybersecurity',
      name: 'Cyber Security',
      category: 'Security',
      icon: 'security_rounded',
      introduction:
          'Cyber Security focuses on protecting systems, networks, devices, and data from digital attacks, unauthorized access, and data breaches.',
      whyLearn:
          'Crucial field protecting global digital assets, financial transactions, and privacy against evolving cyber threats.',
      careerOpportunities: [
        'Ethical Hacker / Penetration Tester',
        'Security Operations Center (SOC) Analyst',
        'Information Security Engineer',
        'Cyber Security Architect'
      ],
      requiredSkills: [
        'Networking & TCP/IP Protocols',
        'Linux & Bash Scripting',
        'OWASP Top 10 Vulnerabilities',
        'Penetration Testing Tools (Burp Suite, Wireshark)',
        'Cryptography Fundamentals'
      ],
      learningRoadmap: [
        '1. Learn Fundamentals of Networking & Cryptography',
        '2. Practice Linux Commands & Scripting',
        '3. Understand Web Application Security (OWASP)',
        '4. Hands-on Capture The Flag (CTF) Challenges on TryHackMe/HackTheBox',
        '5. Security Automation & SIEM Analysis'
      ],
      bestFreeResources: [
        CareerResourceLink(
            title: 'TryHackMe Learning Paths',
            url: 'https://tryhackme.com/',
            platform: 'Web',
            type: 'Interactive'),
      ],
      books: [
        CareerResourceLink(
            title: 'The Web Application Hacker\'s Handbook by Dafydd Stuttard & Marcus Pinto',
            url: '',
            platform: 'Book',
            type: 'Book'),
      ],
      certifications: [
        CareerResourceLink(
            title: 'CompTIA Security+',
            url: 'https://www.comptia.org/certifications/security',
            platform: 'CompTIA',
            type: 'Certification'),
      ],
      youtubePlaylists: [
        CareerResourceLink(
            title: 'NetworkChuck - Cyber Security & Networking',
            url: 'https://www.youtube.com/c/NetworkChuck',
            platform: 'YouTube',
            type: 'Playlist'),
      ],
      miniProjects: [
        CareerProjectInfo(
            title: 'Network Packet Sniffer & Analyzer',
            description: 'Write a Python script using Scapy to analyze local network traffic.',
            difficulty: 'Beginner'),
      ],
      advancedProjects: [
        CareerProjectInfo(
            title: 'Vulnerability Scanner & Reporting Engine',
            description: 'Automate web application security auditing against OWASP Top 10.',
            difficulty: 'Advanced'),
      ],
      githubRepos: [
        CareerResourceLink(
            title: 'OWASP/CheatSheetSeries',
            url: 'https://github.com/OWASP/CheatSheetSeries',
            platform: 'GitHub',
            type: 'Repository'),
      ],
      futureScope:
          'Zero-Trust Architecture, Quantum Cryptography, and AI-Driven Cyber Defense.',
    ),
    CareerModel(
      id: 'flutter',
      name: 'Flutter Development',
      category: 'Mobile & Web',
      icon: 'flutter_dash_rounded',
      introduction:
          'Flutter is Google’s open-source UI toolkit for building natively compiled applications for mobile, web, desktop, and embedded devices from a single codebase.',
      whyLearn:
          'Build beautiful, high-performance apps for iOS, Android, and Web simultaneously using Dart, saving development time and effort.',
      careerOpportunities: [
        'Flutter Mobile App Developer',
        'Cross-Platform Software Engineer',
        'Frontend Engineer',
        'Mobile Tech Lead'
      ],
      requiredSkills: [
        'Dart Programming Language',
        'Flutter Widget Tree & Custom UI',
        'State Management (Provider, Riverpod, Bloc)',
        'Firebase & REST API Integration',
        'Clean Architecture'
      ],
      learningRoadmap: [
        '1. Master Dart Fundamentals & OOP Principles',
        '2. Flutter Basics (Layouts, Navigation, Material 3 Widgets)',
        '3. State Management (Provider, Riverpod)',
        '4. Backend & Firebase Integration (Firestore, Storage, Auth)',
        '5. App Optimization, CI/CD, and Publishing to Google Play Store & Apple App Store'
      ],
      bestFreeResources: [
        CareerResourceLink(
            title: 'Official Flutter Documentation & Codelabs',
            url: 'https://docs.flutter.dev/',
            platform: 'Flutter.dev',
            type: 'Documentation'),
      ],
      books: [
        CareerResourceLink(
            title: 'Flutter in Action by Eric Windmill',
            url: '',
            platform: 'Book',
            type: 'Book'),
      ],
      certifications: [
        CareerResourceLink(
            title: 'Google Associate Android / Flutter Developer Roadmap',
            url: 'https://flutter.dev/learn',
            platform: 'Google',
            type: 'Certification'),
      ],
      youtubePlaylists: [
        CareerResourceLink(
            title: 'Flutter Official YouTube Channel',
            url: 'https://www.youtube.com/@cFlutter',
            platform: 'YouTube',
            type: 'Playlist'),
      ],
      miniProjects: [
        CareerProjectInfo(
            title: 'Expense Tracker App',
            description: 'Build a dark/light themed expense tracker with local database storage.',
            difficulty: 'Beginner'),
      ],
      advancedProjects: [
        CareerProjectInfo(
            title: 'CSSE Study Hub Platform',
            description: 'Complete cross-platform academic and career development suite with Firebase backend.',
            difficulty: 'Advanced'),
      ],
      githubRepos: [
        CareerResourceLink(
            title: 'flutter/flutter',
            url: 'https://github.com/flutter/flutter',
            platform: 'GitHub',
            type: 'Repository'),
      ],
      futureScope:
          'Multi-platform desktop applications, Flutter Web optimization, and Flutter for embedded IoT displays.',
    ),
    CareerModel(
      id: 'devops',
      name: 'DevOps',
      category: 'Infrastructure',
      icon: 'loop_rounded',
      introduction:
          'DevOps combines software development (Dev) and IT operations (Ops) to shorten the systems development life cycle and provide continuous delivery with high quality.',
      whyLearn:
          'Enables automated building, testing, continuous integration, and rapid deployment of cloud applications.',
      careerOpportunities: [
        'DevOps Engineer',
        'Build & Release Engineer',
        'Cloud DevOps Architect',
        'Site Reliability Engineer'
      ],
      requiredSkills: [
        'Git & GitHub Actions / Jenkins',
        'Docker Containerization',
        'Kubernetes',
        'Terraform / Ansible',
        'CI/CD Pipelines'
      ],
      learningRoadmap: [
        '1. Master Linux & Shell Scripting',
        '2. Version Control with Git & GitHub Flow',
        '3. Docker Containerization & Docker Compose',
        '4. CI/CD Pipeline Automation (GitHub Actions / Jenkins)',
        '5. Kubernetes Cluster Management & Helm Charts'
      ],
      bestFreeResources: [
        CareerResourceLink(
            title: 'DevOps Roadmap by Roadmap.sh',
            url: 'https://roadmap.sh/devops',
            platform: 'Web',
            type: 'Roadmap'),
      ],
      books: [
        CareerResourceLink(
            title: 'The Phoenix Project by Gene Kim, Kevin Behr, and George Spafford',
            url: '',
            platform: 'Book',
            type: 'Book'),
      ],
      certifications: [
        CareerResourceLink(
            title: 'Certified Kubernetes Administrator (CKA)',
            url: 'https://www.cncf.io/certification/cka/',
            platform: 'Linux Foundation',
            type: 'Certification'),
      ],
      youtubePlaylists: [
        CareerResourceLink(
            title: 'TechWorld with Nana - DevOps Beginner Tutorial',
            url: 'https://www.youtube.com/@TechWorldwithNana',
            platform: 'YouTube',
            type: 'Playlist'),
      ],
      miniProjects: [
        CareerProjectInfo(
            title: 'Dockerize a Full-Stack Node/React App',
            description: 'Write Dockerfile and Docker Compose configurations for multi-container deployment.',
            difficulty: 'Beginner'),
      ],
      advancedProjects: [
        CareerProjectInfo(
            title: 'Automated GitOps Pipeline with ArgoCD',
            description: 'Deploy microservices to a Kubernetes cluster using Infrastructure as Code.',
            difficulty: 'Advanced'),
      ],
      githubRepos: [
        CareerResourceLink(
            title: 'kubernetes/kubernetes',
            url: 'https://github.com/kubernetes/kubernetes',
            platform: 'GitHub',
            type: 'Repository'),
      ],
      futureScope:
          'DevSecOps (Security integrated into CI/CD), GitOps, and Platform Engineering.',
    ),
    CareerModel(
      id: 'system_design',
      name: 'System Design',
      category: 'Software Architecture',
      icon: 'architecture_rounded',
      introduction:
          'System Design is the process of defining the architecture, components, modules, interfaces, and data for a system to satisfy specified requirements.',
      whyLearn:
          'Essential for senior software engineering roles and technical interview rounds at top tech companies.',
      careerOpportunities: [
        'Software Architect',
        'Principal Software Engineer',
        'Engineering Manager',
        'Backend System Architect'
      ],
      requiredSkills: [
        'Scalability & Load Balancing',
        'Database Sharding & Caching (Redis)',
        'Microservices Architecture',
        'Message Queues (Kafka, RabbitMQ)',
        'Distributed Systems Design'
      ],
      learningRoadmap: [
        '1. Master Basic Building Blocks (DNS, CDN, Load Balancers)',
        '2. Caching Strategies (Redis/Memcached) & Database Indexing',
        '3. SQL vs NoSQL & Data Replication/Sharding',
        '4. Asynchronous Processing with Message Queues (Kafka)',
        '5. Study Real-World Architectures (Netflix, Uber, WhatsApp)'
      ],
      bestFreeResources: [
        CareerResourceLink(
            title: 'System Design Primer on GitHub',
            url: 'https://github.com/donnemartin/system-design-primer',
            platform: 'GitHub',
            type: 'Guide'),
      ],
      books: [
        CareerResourceLink(
            title: 'Designing Data-Intensive Applications by Martin Kleppmann',
            url: '',
            platform: 'Book',
            type: 'Book'),
      ],
      certifications: [
        CareerResourceLink(
            title: 'AWS Certified Solutions Architect – Professional',
            url: 'https://aws.amazon.com/certification/certified-solutions-architect-professional/',
            platform: 'AWS',
            type: 'Certification'),
      ],
      youtubePlaylists: [
        CareerResourceLink(
            title: 'Gaurav Sen - System Design Tutorials',
            url: 'https://www.youtube.com/@GauravSensei',
            platform: 'YouTube',
            type: 'Playlist'),
      ],
      miniProjects: [
        CareerProjectInfo(
            title: 'Design a URL Shortener (Bit.ly Clone)',
            description: 'Implement key generation service, base62 encoding, and Redis cache.',
            difficulty: 'Intermediate'),
      ],
      advancedProjects: [
        CareerProjectInfo(
            title: 'Distributed Real-Time Chat System',
            description: 'Architect a scalable chat system supporting millions of concurrent WebSocket connections.',
            difficulty: 'Advanced'),
      ],
      githubRepos: [
        CareerResourceLink(
            title: 'donnemartin/system-design-primer',
            url: 'https://github.com/donnemartin/system-design-primer',
            platform: 'GitHub',
            type: 'Repository'),
      ],
      futureScope:
          'Ultra-low-latency edge computing, serverless event-driven architecture, and global distributed storage.',
    ),
  ];
}

import '../models/personalized_roadmap_models.dart';
import 'roadmap_generator_interface.dart';
import 'roadmap_resource_resolver.dart';

/// Production Deterministic Rule-Based Roadmap Generation Engine
///
/// Implements RoadmapGenerator abstraction and builds structured,
/// prerequisite-aware, timeline-fitted, and resource-grounded learning roadmaps.
class RuleBasedRoadmapGenerator implements RoadmapGenerator {
  const RuleBasedRoadmapGenerator();

  @override
  Future<PersonalizedRoadmap> generateRoadmap({
    required PersonalizedProfile profile,
    PersonalizedRoadmap? existingRoadmap,
  }) async {
    return _buildRoadmap(profile: profile, existingRoadmap: existingRoadmap);
  }

  @override
  Future<PersonalizedRoadmap> recalculateRoadmap({
    required PersonalizedProfile updatedProfile,
    required PersonalizedRoadmap currentRoadmap,
  }) async {
    return _buildRoadmap(profile: updatedProfile, existingRoadmap: currentRoadmap);
  }

  PersonalizedRoadmap _buildRoadmap({
    required PersonalizedProfile profile,
    PersonalizedRoadmap? existingRoadmap,
  }) {
    // 1. Identify previous completion state for preservation
    final completedSkillMap = <String, bool>{};
    if (existingRoadmap != null) {
      for (final item in existingRoadmap.allItems) {
        if (item.isCompleted) {
          completedSkillMap[item.id] = true;
          completedSkillMap[item.targetSkill.toLowerCase()] = true;
        }
      }
    }
    for (final completed in profile.alreadyCompletedSkills) {
      completedSkillMap[completed.toLowerCase()] = true;
    }

    // 2. Determine Primary Track & Candidate Phases
    final phases = _generateTrackPhases(profile, completedSkillMap);

    // 3. Resolve Prerequisite Locks across all items
    final allCompletedIds = <String>{};
    for (final phase in phases) {
      for (final item in phase.items) {
        if (item.isCompleted) {
          allCompletedIds.add(item.id);
        }
      }
    }

    final resolvedPhases = phases.map((phase) {
      final updatedItems = phase.items.map((item) {
        if (item.isCompleted) return item;
        // Check if all prerequisites are fulfilled
        final hasUnmetPrereq = item.prerequisites.any((prereqId) => !allCompletedIds.contains(prereqId));
        if (hasUnmetPrereq) {
          return item.copyWith(status: RoadmapItemStatus.locked);
        }
        return item.status == RoadmapItemStatus.locked
            ? item.copyWith(status: RoadmapItemStatus.notStarted)
            : item;
      }).toList();
      return phase.copyWith(items: updatedItems);
    }).toList();

    return PersonalizedRoadmap(
      id: 'roadmap_${profile.primaryCareerDirection.toLowerCase().replaceAll(RegExp(r'\s+'), '_')}_${DateTime.now().millisecondsSinceEpoch}',
      title: '${profile.primaryCareerDirection} Learning Navigator',
      targetCareer: profile.primaryCareerDirection,
      mainGoal: profile.goals.isNotEmpty ? profile.goals.first : 'Placement',
      targetTimeline: profile.targetTimeline,
      dailyMinutes: profile.dailyLearningTimeMinutes,
      weeklyAvailability: profile.weeklyAvailability,
      phases: resolvedPhases,
      profileVersion: profile.profileVersion,
      generatorVersion: '1.0.0 (RuleBasedEngine)',
      roadmapVersion: (existingRoadmap?.roadmapVersion ?? 0) + 1,
      generatedAt: existingRoadmap?.generatedAt ?? DateTime.now(),
      lastUpdatedAt: DateTime.now(),
    );
  }

  List<RoadmapPhase> _generateTrackPhases(
    PersonalizedProfile profile,
    Map<String, bool> completedSkillMap,
  ) {
    final career = profile.primaryCareerDirection.toLowerCase();
    final isAi = career.contains('ai') || career.contains('machine learning') || career.contains('data scientist');
    final isWeb = career.contains('web') || career.contains('frontend') || career.contains('full stack');
    final isSecurity = career.contains('cyber') || career.contains('security');
    final isCloud = career.contains('cloud') || career.contains('devops');
    final isPlacement = profile.goals.contains('Placement') || profile.goals.contains('Internship');
    final isHigherEd = profile.goals.contains('Higher Studies') || profile.goals.contains('Competitive Exams');

    if (isAi) {
      return _buildAiTrack(profile, completedSkillMap);
    } else if (isWeb) {
      return _buildWebTrack(profile, completedSkillMap);
    } else if (isSecurity) {
      return _buildCybersecurityTrack(profile, completedSkillMap);
    } else if (isCloud) {
      return _buildCloudDevOpsTrack(profile, completedSkillMap);
    } else if (isHigherEd) {
      return _buildHigherEdTrack(profile, completedSkillMap);
    } else if (isPlacement) {
      return _buildPlacementSprintTrack(profile, completedSkillMap);
    } else {
      return _buildSoftwareEngineeringTrack(profile, completedSkillMap);
    }
  }

  // --- AI / ML Track Generator ---
  List<RoadmapPhase> _buildAiTrack(PersonalizedProfile profile, Map<String, bool> completed) {
    final lang = profile.primaryLanguage.isNotEmpty ? profile.primaryLanguage : 'Python';
    final isWeakMath = profile.weaknesses.any((w) => w.toLowerCase().contains('math'));
    final isWeakDsa = profile.weaknesses.any((w) => w.toLowerCase().contains('dsa'));

    // Phase 1: Foundations
    final p1Items = <RoadmapItem>[
      _createItem(
        id: 'ai_p1_lang',
        title: '$lang Programming for AI',
        description: 'Control structures, object-oriented concepts, and functional patterns in $lang.',
        category: 'Programming',
        difficulty: RoadmapDifficulty.beginner,
        estimatedMinutes: 45,
        priority: RoadmapItemPriority.critical,
        phaseId: 'p1_foundations',
        sequence: 1,
        targetSkill: lang,
        hintId: 'python',
        recommendationReason: 'Core foundation language required for data handling & ML algorithms.',
        completed: completed,
      ),
      _createItem(
        id: 'ai_p1_math',
        title: 'Mathematics & Statistics for Machine Learning',
        description: 'Linear algebra, matrix calculus, probability distributions, and hypothesis testing.',
        category: 'Mathematics',
        difficulty: isWeakMath ? RoadmapDifficulty.beginner : RoadmapDifficulty.intermediate,
        estimatedMinutes: 45,
        priority: isWeakMath ? RoadmapItemPriority.critical : RoadmapItemPriority.high,
        phaseId: 'p1_foundations',
        sequence: 2,
        targetSkill: 'Mathematics',
        recommendationReason: isWeakMath
            ? 'Prioritized because Mathematics was selected as a focus improvement area in your profile.'
            : 'Essential for understanding loss functions and gradient descent optimization.',
        completed: completed,
      ),
      _createItem(
        id: 'ai_p1_dsa',
        title: 'Essential DSA & Complexity Analysis',
        description: 'Arrays, hash maps, binary trees, recursion, and Big-O efficiency.',
        category: 'DSA',
        difficulty: RoadmapDifficulty.intermediate,
        estimatedMinutes: 45,
        priority: isWeakDsa ? RoadmapItemPriority.critical : RoadmapItemPriority.high,
        prerequisites: ['ai_p1_lang'],
        phaseId: 'p1_foundations',
        sequence: 3,
        targetSkill: 'DSA',
        hintId: 'dsa_arrays',
        recommendationReason: isWeakDsa
            ? 'Reinforced early because DSA is an identified weakness.'
            : 'Required for writing performant data processing code.',
        completed: completed,
      ),
    ];

    // Phase 2: Data Science & ML Core
    final p2Items = <RoadmapItem>[
      _createItem(
        id: 'ai_p2_data',
        title: 'Data Wrangling with NumPy & Pandas',
        description: 'Vectorized operations, dataframe cleaning, feature filtering, and aggregations.',
        category: 'Data Science',
        difficulty: RoadmapDifficulty.intermediate,
        estimatedMinutes: 60,
        priority: RoadmapItemPriority.critical,
        prerequisites: ['ai_p1_lang'],
        phaseId: 'p2_ml_core',
        sequence: 1,
        targetSkill: 'Data Science',
        hintId: 'ai_machine_learning',
        recommendationReason: 'NumPy & Pandas are standard prerequisites for data manipulation in AI.',
        completed: completed,
      ),
      _createItem(
        id: 'ai_p2_ml',
        title: 'Supervised & Unsupervised Machine Learning',
        description: 'Regression, Decision Trees, Random Forests, SVMs, Clustering with Scikit-learn.',
        category: 'Machine Learning',
        difficulty: RoadmapDifficulty.intermediate,
        estimatedMinutes: 60,
        priority: RoadmapItemPriority.critical,
        prerequisites: ['ai_p2_data', 'ai_p1_math'],
        phaseId: 'p2_ml_core',
        sequence: 2,
        targetSkill: 'Machine Learning',
        hintId: 'ai_machine_learning',
        recommendationReason: 'Core discipline for your target AI Engineer career track.',
        completed: completed,
      ),
    ];

    // Phase 3: Deep Learning & Generative AI
    final p3Items = <RoadmapItem>[
      _createItem(
        id: 'ai_p3_dl',
        title: 'Neural Networks & Deep Learning Foundations',
        description: 'Feedforward networks, backpropagation, CNNs, RNNs, and PyTorch / TensorFlow.',
        category: 'Deep Learning',
        difficulty: RoadmapDifficulty.advanced,
        estimatedMinutes: 60,
        priority: RoadmapItemPriority.high,
        prerequisites: ['ai_p2_ml'],
        phaseId: 'p3_advanced_ai',
        sequence: 1,
        targetSkill: 'Deep Learning',
        hintId: 'ai_deep_learning',
        recommendationReason: 'Prerequisite for Computer Vision, NLP, and modern LLM architectures.',
        completed: completed,
      ),
      _createItem(
        id: 'ai_p3_genai',
        title: 'Generative AI & LLM Prompt Engineering',
        description: 'Transformers, embeddings, RAG pipelines, LangChain, and AI Agent workflows.',
        category: 'Generative AI',
        difficulty: RoadmapDifficulty.advanced,
        estimatedMinutes: 60,
        priority: RoadmapItemPriority.high,
        prerequisites: ['ai_p3_dl'],
        phaseId: 'p3_advanced_ai',
        sequence: 2,
        targetSkill: 'Generative AI',
        hintId: 'ai_nlp',
        recommendationReason: 'High-demand industry competency for modern AI engineering roles.',
        completed: completed,
      ),
    ];

    // Phase 4: Applied Projects & Placement Prep
    final p4Items = <RoadmapItem>[
      _createItem(
        id: 'ai_p4_project',
        title: 'End-to-End AI Portfolio Blueprint Project',
        description: 'Develop and deploy an AI/ML web application with FastAPI, Docker, and Streamlit.',
        category: 'Project',
        difficulty: RoadmapDifficulty.advanced,
        estimatedMinutes: 90,
        priority: RoadmapItemPriority.critical,
        prerequisites: ['ai_p2_ml'],
        phaseId: 'p4_projects_career',
        sequence: 1,
        targetSkill: 'Project',
        hintId: 'house_price_proj',
        recommendationReason: 'Tangible proof-of-work project necessary for technical resumes and interviews.',
        completed: completed,
      ),
      _createItem(
        id: 'ai_p4_quiz',
        title: 'Technical MCQs & Coding Interview Practice',
        description: 'Timed quantitative aptitude, logic drills, and CS mock test simulations in UniDocs.',
        category: 'Placement',
        difficulty: RoadmapDifficulty.intermediate,
        estimatedMinutes: 45,
        priority: RoadmapItemPriority.high,
        phaseId: 'p4_projects_career',
        sequence: 2,
        targetSkill: 'Placement Quiz',
        hintId: 'quant_aptitude',
        recommendationReason: 'Sharpens problem-solving speed and interview readiness.',
        completed: completed,
      ),
    ];

    return [
      RoadmapPhase(
        id: 'p1_foundations',
        title: 'Phase 1: Foundations & Core Mathematical Intuition',
        description: 'Master $lang fundamentals, essential mathematics, and algorithm complexity.',
        sequence: 1,
        estimatedDuration: '3–4 weeks',
        items: p1Items,
      ),
      RoadmapPhase(
        id: 'p2_ml_core',
        title: 'Phase 2: Data Science & Classical Machine Learning',
        description: 'Data transformation with Pandas and standard algorithms with Scikit-learn.',
        sequence: 2,
        estimatedDuration: '4–5 weeks',
        items: p2Items,
      ),
      RoadmapPhase(
        id: 'p3_advanced_ai',
        title: 'Phase 3: Deep Learning, PyTorch & Generative AI',
        description: 'Neural networks, Transformers, embeddings, and intelligent agent workflows.',
        sequence: 3,
        estimatedDuration: '4–6 weeks',
        items: p3Items,
      ),
      RoadmapPhase(
        id: 'p4_projects_career',
        title: 'Phase 4: Applied Capstone Projects & Interview Readiness',
        description: 'Deploy production AI systems and practice technical assessments.',
        sequence: 4,
        estimatedDuration: '3–4 weeks',
        items: p4Items,
      ),
    ];
  }

  // --- Web & Full Stack Track Generator ---
  List<RoadmapPhase> _buildWebTrack(PersonalizedProfile profile, Map<String, bool> completed) {
    final p1Items = <RoadmapItem>[
      _createItem(
        id: 'web_p1_html',
        title: 'Modern HTML5, Semantic Structure & CSS3',
        description: 'Flexbox, CSS Grid, responsive design, and accessible DOM structures.',
        category: 'Frontend',
        difficulty: RoadmapDifficulty.beginner,
        estimatedMinutes: 45,
        priority: RoadmapItemPriority.critical,
        phaseId: 'p1_web_foundations',
        sequence: 1,
        targetSkill: 'HTML/CSS',
        hintId: 'web_html_css',
        recommendationReason: 'Core building block for all browser-based interfaces.',
        completed: completed,
      ),
      _createItem(
        id: 'web_p1_js',
        title: 'JavaScript ES6+ & Asynchronous Programming',
        description: 'Closures, promises, async/await, fetch API, and event loop mechanics.',
        category: 'Programming',
        difficulty: RoadmapDifficulty.beginner,
        estimatedMinutes: 45,
        priority: RoadmapItemPriority.critical,
        prerequisites: ['web_p1_html'],
        phaseId: 'p1_web_foundations',
        sequence: 2,
        targetSkill: 'JavaScript',
        hintId: 'javascript_lang',
        recommendationReason: 'Mandatory programming foundation for React and backend Node.js.',
        completed: completed,
      ),
    ];

    final p2Items = <RoadmapItem>[
      _createItem(
        id: 'web_p2_react',
        title: 'React Components, State Management & Hooks',
        description: 'Component lifecycles, useState, useEffect, context API, and modular UI patterns.',
        category: 'Frontend',
        difficulty: RoadmapDifficulty.intermediate,
        estimatedMinutes: 60,
        priority: RoadmapItemPriority.critical,
        prerequisites: ['web_p1_js'],
        phaseId: 'p2_frontend_mastery',
        sequence: 1,
        targetSkill: 'React',
        hintId: 'web_react',
        recommendationReason: 'Most widely adopted frontend framework in modern web software engineering.',
        completed: completed,
      ),
      _createItem(
        id: 'web_p2_dsa',
        title: 'Data Structures for Web Engineers (Hash Maps, Trees)',
        description: 'State graph traversals, JSON manipulation, and efficient lookup algorithms.',
        category: 'DSA',
        difficulty: RoadmapDifficulty.intermediate,
        estimatedMinutes: 45,
        priority: RoadmapItemPriority.high,
        phaseId: 'p2_frontend_mastery',
        sequence: 2,
        targetSkill: 'DSA',
        hintId: 'dsa_arrays',
        recommendationReason: 'Critical for passing technical coding screens.',
        completed: completed,
      ),
    ];

    final p3Items = <RoadmapItem>[
      _createItem(
        id: 'web_p3_backend',
        title: 'Backend APIs & RESTful Microservices',
        description: 'Express.js, authentication (JWT), request routing, and middleware patterns.',
        category: 'Backend',
        difficulty: RoadmapDifficulty.intermediate,
        estimatedMinutes: 60,
        priority: RoadmapItemPriority.critical,
        prerequisites: ['web_p1_js'],
        phaseId: 'p3_fullstack_backend',
        sequence: 1,
        targetSkill: 'Backend',
        hintId: 'web_backend_node',
        recommendationReason: 'Connects frontend clients with reliable server-side business logic.',
        completed: completed,
      ),
      _createItem(
        id: 'web_p3_db',
        title: 'Relational & NoSQL Databases (PostgreSQL / MongoDB)',
        description: 'Schema design, normalization, indexing, queries, and ORM integration.',
        category: 'Databases',
        difficulty: RoadmapDifficulty.intermediate,
        estimatedMinutes: 45,
        priority: RoadmapItemPriority.critical,
        prerequisites: ['web_p3_backend'],
        phaseId: 'p3_fullstack_backend',
        sequence: 2,
        targetSkill: 'Databases',
        hintId: 'db_sql',
        recommendationReason: 'Essential database persistence required for all full stack web apps.',
        completed: completed,
      ),
    ];

    final p4Items = <RoadmapItem>[
      _createItem(
        id: 'web_p4_project',
        title: 'Production Full Stack Application Blueprint',
        description: 'Build and deploy a complete web application with auth, database, and cloud hosting.',
        category: 'Project',
        difficulty: RoadmapDifficulty.advanced,
        estimatedMinutes: 90,
        priority: RoadmapItemPriority.critical,
        prerequisites: ['web_p2_react', 'web_p3_db'],
        phaseId: 'p4_deployment_career',
        sequence: 1,
        targetSkill: 'Project',
        hintId: 'portfolio_website_proj',
        recommendationReason: 'Serves as the flagship portfolio project during interviews.',
        completed: completed,
      ),
    ];

    return [
      RoadmapPhase(
        id: 'p1_web_foundations',
        title: 'Phase 1: Web Fundamentals & JavaScript Core',
        description: 'Master HTML5 semantic markup, CSS layouts, and modern ES6+ programming.',
        sequence: 1,
        estimatedDuration: '3–4 weeks',
        items: p1Items,
      ),
      RoadmapPhase(
        id: 'p2_frontend_mastery',
        title: 'Phase 2: React Framework & Frontend Architecture',
        description: 'Build interactive, responsive single-page applications with reusable components.',
        sequence: 2,
        estimatedDuration: '4–5 weeks',
        items: p2Items,
      ),
      RoadmapPhase(
        id: 'p3_fullstack_backend',
        title: 'Phase 3: Server-Side APIs & Database Systems',
        description: 'Design RESTful APIs, manage databases, and implement secure auth.',
        sequence: 3,
        estimatedDuration: '4–5 weeks',
        items: p3Items,
      ),
      RoadmapPhase(
        id: 'p4_deployment_career',
        title: 'Phase 4: Full Stack Capstone & Interview Preparation',
        description: 'Deploy production systems and prepare for software engineering interviews.',
        sequence: 4,
        estimatedDuration: '3–4 weeks',
        items: p4Items,
      ),
    ];
  }

  // --- Cybersecurity Track Generator ---
  List<RoadmapPhase> _buildCybersecurityTrack(PersonalizedProfile profile, Map<String, bool> completed) {
    return [
      RoadmapPhase(
        id: 'p1_cyber_foundations',
        title: 'Phase 1: Networking & Linux Fundamentals',
        description: 'Master TCP/IP, OSI layers, DNS, subnetting, and Linux CLI shell scripting.',
        sequence: 1,
        estimatedDuration: '4 weeks',
        items: [
          _createItem(
            id: 'sec_p1_net',
            title: 'Computer Networks & Internet Protocols',
            description: 'Packets, routing, Wireshark packet analysis, TCP handshakes, and firewalls.',
            category: 'Networking',
            difficulty: RoadmapDifficulty.beginner,
            estimatedMinutes: 45,
            priority: RoadmapItemPriority.critical,
            phaseId: 'p1_cyber_foundations',
            sequence: 1,
            targetSkill: 'Computer Networks',
            hintId: 'cyber_intro',
            recommendationReason: 'Core prerequisite for all defensive and offensive security concepts.',
            completed: completed,
          ),
          _createItem(
            id: 'sec_p1_linux',
            title: 'Linux Systems & Shell Administration',
            description: 'File permissions, process management, bash scripting, and system security.',
            category: 'Operating Systems',
            difficulty: RoadmapDifficulty.beginner,
            estimatedMinutes: 45,
            priority: RoadmapItemPriority.critical,
            phaseId: 'p1_cyber_foundations',
            sequence: 2,
            targetSkill: 'Linux',
            hintId: 'basics_intro',
            recommendationReason: 'Standard operating system environment for cybersecurity tools.',
            completed: completed,
          ),
        ],
      ),
      RoadmapPhase(
        id: 'p2_cyber_security',
        title: 'Phase 2: Security Principles & Ethical Hacking',
        description: 'Cryptography, web vulnerability scanning (OWASP Top 10), and pen-testing tools.',
        sequence: 2,
        estimatedDuration: '5 weeks',
        items: [
          _createItem(
            id: 'sec_p2_owasp',
            title: 'Web Application Security & OWASP Top 10',
            description: 'SQL Injection, XSS, CSRF, authentication bypass, and security headers.',
            category: 'Security',
            difficulty: RoadmapDifficulty.intermediate,
            estimatedMinutes: 60,
            priority: RoadmapItemPriority.critical,
            prerequisites: ['sec_p1_net'],
            phaseId: 'p2_cyber_security',
            sequence: 1,
            targetSkill: 'Cybersecurity',
            hintId: 'cyber_intro',
            recommendationReason: 'Core industry standard for securing web applications.',
            completed: completed,
          ),
        ],
      ),
      RoadmapPhase(
        id: 'p3_cyber_defense',
        title: 'Phase 3: SOC Defense, SIEM & Capstone Labs',
        description: 'Threat hunting, log analysis, and incident response exercises.',
        sequence: 3,
        estimatedDuration: '4 weeks',
        items: [
          _createItem(
            id: 'sec_p3_soc',
            title: 'Incident Response & Defensive Security Blueprint',
            description: 'Configure security monitoring, analyze malicious traffic, and write reports.',
            category: 'Project',
            difficulty: RoadmapDifficulty.advanced,
            estimatedMinutes: 90,
            priority: RoadmapItemPriority.high,
            prerequisites: ['sec_p2_owasp'],
            phaseId: 'p3_cyber_defense',
            sequence: 1,
            targetSkill: 'Project',
            hintId: 'portfolio_website_proj',
            recommendationReason: 'Practical hands-on lab demonstration needed for cybersecurity roles.',
            completed: completed,
          ),
        ],
      ),
    ];
  }

  // --- Cloud / DevOps Track Generator ---
  List<RoadmapPhase> _buildCloudDevOpsTrack(PersonalizedProfile profile, Map<String, bool> completed) {
    return [
      RoadmapPhase(
        id: 'p1_devops_basics',
        title: 'Phase 1: Linux, Git & Networking Foundations',
        description: 'Version control workflows, SSH keys, CLI commands, and network fundamentals.',
        sequence: 1,
        estimatedDuration: '3–4 weeks',
        items: [
          _createItem(
            id: 'cloud_p1_git',
            title: 'Git Version Control & CI/CD Fundamentals',
            description: 'Branching strategies, merge conflicts, pull requests, and automated actions.',
            category: 'Tools',
            difficulty: RoadmapDifficulty.beginner,
            estimatedMinutes: 45,
            priority: RoadmapItemPriority.critical,
            phaseId: 'p1_devops_basics',
            sequence: 1,
            targetSkill: 'Git',
            hintId: 'basics_intro',
            recommendationReason: 'Foundational tool for infrastructure-as-code and release pipelines.',
            completed: completed,
          ),
        ],
      ),
      RoadmapPhase(
        id: 'p2_containers_cloud',
        title: 'Phase 2: Docker Containers & Cloud Platforms',
        description: 'Containerizing services, Docker Compose, and AWS/GCP cloud services.',
        sequence: 2,
        estimatedDuration: '5 weeks',
        items: [
          _createItem(
            id: 'cloud_p2_docker',
            title: 'Docker Containerization & Microservices',
            description: 'Dockerfiles, multi-stage builds, container networking, and volume management.',
            category: 'Cloud',
            difficulty: RoadmapDifficulty.intermediate,
            estimatedMinutes: 60,
            priority: RoadmapItemPriority.critical,
            prerequisites: ['cloud_p1_git'],
            phaseId: 'p2_containers_cloud',
            sequence: 1,
            targetSkill: 'Docker',
            hintId: 'devops_docker',
            recommendationReason: 'Standard container runtime essential for modern cloud deployments.',
            completed: completed,
          ),
        ],
      ),
      RoadmapPhase(
        id: 'p3_kubernetes_iac',
        title: 'Phase 3: Kubernetes Orchestration & Capstone Blueprint',
        description: 'Pods, Deployments, Services, Helm charts, and continuous deployment.',
        sequence: 3,
        estimatedDuration: '4–5 weeks',
        items: [
          _createItem(
            id: 'cloud_p3_k8s',
            title: 'Kubernetes Cluster Deployment Project',
            description: 'Deploy a multi-service web app to a cloud Kubernetes cluster with monitoring.',
            category: 'Project',
            difficulty: RoadmapDifficulty.advanced,
            estimatedMinutes: 90,
            priority: RoadmapItemPriority.critical,
            prerequisites: ['cloud_p2_docker'],
            phaseId: 'p3_kubernetes_iac',
            sequence: 1,
            targetSkill: 'Project',
            hintId: 'devops_docker',
            recommendationReason: 'Demonstrates end-to-end cloud infrastructure proficiency.',
            completed: completed,
          ),
        ],
      ),
    ];
  }

  // --- Higher Education & GATE Track Generator ---
  List<RoadmapPhase> _buildHigherEdTrack(PersonalizedProfile profile, Map<String, bool> completed) {
    return [
      RoadmapPhase(
        id: 'p1_gate_core',
        title: 'Phase 1: Engineering Mathematics & Discrete Structures',
        description: 'Calculus, linear algebra, graph theory, combinatorics, and probability.',
        sequence: 1,
        estimatedDuration: '4–6 weeks',
        items: [
          _createItem(
            id: 'gate_p1_math',
            title: 'Discrete Mathematics & Theory of Computation',
            description: 'Automata theory, regular expressions, context-free grammars, and Turing machines.',
            category: 'Higher Studies',
            difficulty: RoadmapDifficulty.intermediate,
            estimatedMinutes: 60,
            priority: RoadmapItemPriority.critical,
            phaseId: 'p1_gate_core',
            sequence: 1,
            targetSkill: 'Higher Studies',
            hintId: 'gate_cse',
            recommendationReason: 'High weightage subject in GATE CS and MS entrance examinations.',
            completed: completed,
          ),
        ],
      ),
      RoadmapPhase(
        id: 'p2_gate_systems',
        title: 'Phase 2: Core Computer Systems (OS, DBMS, CN, COA)',
        description: 'Memory hierarchy, SQL normalization, pipelining, and routing protocols.',
        sequence: 2,
        estimatedDuration: '6–8 weeks',
        items: [
          _createItem(
            id: 'gate_p2_systems',
            title: 'Core Systems Mastery (Operating Systems & DBMS)',
            description: 'Process scheduling, deadlocks, virtual memory, relational algebra, and ACID transactions.',
            category: 'Operating Systems',
            difficulty: RoadmapDifficulty.advanced,
            estimatedMinutes: 60,
            priority: RoadmapItemPriority.critical,
            phaseId: 'p2_gate_systems',
            sequence: 1,
            targetSkill: 'Operating Systems',
            hintId: 'db_sql',
            recommendationReason: 'Essential theoretical pillars tested in competitive exams.',
            completed: completed,
          ),
        ],
      ),
    ];
  }

  // --- Placement Sprint Track Generator ---
  List<RoadmapPhase> _buildPlacementSprintTrack(PersonalizedProfile profile, Map<String, bool> completed) {
    final lang = profile.primaryLanguage.isNotEmpty ? profile.primaryLanguage : 'Java';

    return [
      RoadmapPhase(
        id: 'p1_placement_dsa',
        title: 'Phase 1: High-Yield DSA & Problem Solving Sprint',
        description: 'Arrays, two pointers, sliding window, binary search, trees, and graphs in $lang.',
        sequence: 1,
        estimatedDuration: '4 weeks',
        items: [
          _createItem(
            id: 'plc_p1_dsa',
            title: 'Top 75 Interview Data Structures & Algorithms',
            description: 'Master time complexity, arrays, strings, hash maps, and recursion patterns.',
            category: 'DSA',
            difficulty: RoadmapDifficulty.intermediate,
            estimatedMinutes: 45,
            priority: RoadmapItemPriority.critical,
            phaseId: 'p1_placement_dsa',
            sequence: 1,
            targetSkill: 'DSA',
            hintId: 'dsa_arrays',
            recommendationReason: 'Primary filter in technical interview screening rounds.',
            completed: completed,
          ),
          _createItem(
            id: 'plc_p1_apt',
            title: 'Quantitative Aptitude & Logical Reasoning Tests',
            description: 'Speed math, percentages, ratios, syllogisms, and coding aptitude quizzes.',
            category: 'Placement',
            difficulty: RoadmapDifficulty.intermediate,
            estimatedMinutes: 30,
            priority: RoadmapItemPriority.critical,
            phaseId: 'p1_placement_dsa',
            sequence: 2,
            targetSkill: 'Placement Quiz',
            hintId: 'quant_aptitude',
            recommendationReason: 'Essential first round qualification for campus placement drives.',
            completed: completed,
          ),
        ],
      ),
      RoadmapPhase(
        id: 'p2_placement_core_interviews',
        title: 'Phase 2: CS Core Pillars & Technical Mock Interviews',
        description: 'OOP concepts, DBMS normalization, OS concurrency, and system design basics.',
        sequence: 2,
        estimatedDuration: '4 weeks',
        items: [
          _createItem(
            id: 'plc_p2_core',
            title: 'OOPs, DBMS, OS & Networks Interview Questions',
            description: 'Standard conceptual interview questions, SQL queries, and architecture diagrams.',
            category: 'Technical Interview',
            difficulty: RoadmapDifficulty.intermediate,
            estimatedMinutes: 45,
            priority: RoadmapItemPriority.critical,
            phaseId: 'p2_placement_core_interviews',
            sequence: 1,
            targetSkill: 'Technical Interview',
            hintId: 'core_cs_interview',
            recommendationReason: 'Crucial for technical face-to-face interview clearing.',
            completed: completed,
          ),
          _createItem(
            id: 'plc_p2_mock',
            title: 'Timed Assessment & Mock Quiz Drills in UniDocs',
            description: 'Simulate real company placement rounds with automated scorecards.',
            category: 'Placement',
            difficulty: RoadmapDifficulty.intermediate,
            estimatedMinutes: 45,
            priority: RoadmapItemPriority.high,
            phaseId: 'p2_placement_core_interviews',
            sequence: 2,
            targetSkill: 'Placement Quiz',
            hintId: 'logical_reasoning_topic',
            recommendationReason: 'Builds test-taking stamina and reduces assessment anxiety.',
            completed: completed,
          ),
        ],
      ),
    ];
  }

  // --- Software / General Track Generator ---
  List<RoadmapPhase> _buildSoftwareEngineeringTrack(PersonalizedProfile profile, Map<String, bool> completed) {
    final lang = profile.primaryLanguage.isNotEmpty ? profile.primaryLanguage : 'Java';

    return [
      RoadmapPhase(
        id: 'p1_se_foundations',
        title: 'Phase 1: Programming Foundations & Clean Code',
        description: 'Modular design, OOP principles, data structures, and debugging in $lang.',
        sequence: 1,
        estimatedDuration: '4 weeks',
        items: [
          _createItem(
            id: 'se_p1_lang',
            title: '$lang Object-Oriented Software Development',
            description: 'Encapsulation, inheritance, polymorphism, design patterns, and unit tests.',
            category: 'Programming',
            difficulty: RoadmapDifficulty.beginner,
            estimatedMinutes: 45,
            priority: RoadmapItemPriority.critical,
            phaseId: 'p1_se_foundations',
            sequence: 1,
            targetSkill: lang,
            hintId: 'java_lang',
            recommendationReason: 'Core language foundation for software engineering practices.',
            completed: completed,
          ),
          _createItem(
            id: 'se_p1_dsa',
            title: 'Data Structures & Algorithmic Problem Solving',
            description: 'Trees, graphs, dynamic programming, sorting, and binary search.',
            category: 'DSA',
            difficulty: RoadmapDifficulty.intermediate,
            estimatedMinutes: 45,
            priority: RoadmapItemPriority.critical,
            prerequisites: ['se_p1_lang'],
            phaseId: 'p1_se_foundations',
            sequence: 2,
            targetSkill: 'DSA',
            hintId: 'dsa_arrays',
            recommendationReason: 'Crucial for passing coding interviews and writing efficient software.',
            completed: completed,
          ),
        ],
      ),
      RoadmapPhase(
        id: 'p2_se_systems',
        title: 'Phase 2: Database Design & Backend Architecture',
        description: 'Relational databases, indexing, transactions, and REST APIs.',
        sequence: 2,
        estimatedDuration: '4–5 weeks',
        items: [
          _createItem(
            id: 'se_p2_dbms',
            title: 'Database Management Systems (DBMS) & SQL',
            description: 'Normalization, joins, indexing, query execution, and transactions.',
            category: 'Databases',
            difficulty: RoadmapDifficulty.intermediate,
            estimatedMinutes: 45,
            priority: RoadmapItemPriority.high,
            phaseId: 'p2_se_systems',
            sequence: 1,
            targetSkill: 'Databases',
            hintId: 'db_sql',
            recommendationReason: 'Essential database persistence and query optimization skills.',
            completed: completed,
          ),
        ],
      ),
      RoadmapPhase(
        id: 'p3_se_projects',
        title: 'Phase 3: Software Engineering Capstone & Career Launch',
        description: 'Construct a multi-tier software system and prepare technical credentials.',
        sequence: 3,
        estimatedDuration: '4 weeks',
        items: [
          _createItem(
            id: 'se_p3_proj',
            title: 'Production Software Portfolio Project Blueprint',
            description: 'Build a production-grade software utility with unit tests, CI/CD, and docs.',
            category: 'Project',
            difficulty: RoadmapDifficulty.advanced,
            estimatedMinutes: 90,
            priority: RoadmapItemPriority.critical,
            prerequisites: ['se_p1_dsa', 'se_p2_dbms'],
            phaseId: 'p3_se_projects',
            sequence: 1,
            targetSkill: 'Project',
            hintId: 'portfolio_website_proj',
            recommendationReason: 'Tangible portfolio project showcasing software development capabilities.',
            completed: completed,
          ),
        ],
      ),
    ];
  }

  RoadmapItem _createItem({
    required String id,
    required String title,
    required String description,
    required String category,
    required RoadmapDifficulty difficulty,
    required int estimatedMinutes,
    required RoadmapItemPriority priority,
    required String phaseId,
    required int sequence,
    required String targetSkill,
    required String recommendationReason,
    required Map<String, bool> completed,
    String? hintId,
    List<String> prerequisites = const [],
  }) {
    final isAlreadyDone = completed[id] == true || completed[targetSkill.toLowerCase()] == true;
    final status = isAlreadyDone ? RoadmapItemStatus.completed : RoadmapItemStatus.notStarted;

    // Ground against real UniDocs resources
    final resolved = RoadmapResourceResolver.resolve(targetSkill, category: category, hintId: hintId);

    return RoadmapItem(
      id: id,
      title: title,
      description: description,
      category: category,
      difficulty: difficulty,
      estimatedMinutes: estimatedMinutes,
      priority: priority,
      prerequisites: prerequisites,
      status: status,
      phaseId: phaseId,
      sequence: sequence,
      targetSkill: targetSkill,
      recommendationReason: recommendationReason,
      resourceReference: resolved.isAvailable ? resolved.resourceReference : null,
      resourceType: resolved.isAvailable ? resolved.resourceType : null,
      deepRoute: resolved.isAvailable ? resolved.deepRoute : null,
      routeArguments: resolved.isAvailable ? resolved.routeArguments : null,
    );
  }
}

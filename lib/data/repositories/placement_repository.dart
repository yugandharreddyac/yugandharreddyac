import '../datasources/firebase_datasource.dart';
import '../models/placement_model.dart';

class PlacementRepository {
  final FirebaseDataSource _firebaseDataSource;

  PlacementRepository({required FirebaseDataSource firebaseDataSource})
      : _firebaseDataSource = firebaseDataSource;

  Future<List<PlacementModel>> getPlacementResources() async {
    try {
      final remoteData = await _firebaseDataSource.getPlacementResources();
      if (remoteData.isNotEmpty) {
        return remoteData.map((e) => PlacementModel.fromJson(e)).toList();
      }
    } catch (_) {}

    return _fallbackPlacementResources;
  }

  static List<PlacementModel> get fallbackPlacementResources => _fallbackPlacementResources;

  static const List<PlacementModel> _fallbackPlacementResources = [
    // --- STAGE 1: QUANTITATIVE APTITUDE ---
    PlacementModel(
      id: 'aptitude_time_work',
      category: 'Aptitude',
      title: 'Quantitative Aptitude: Time, Work, Speed & Distance',
      description: 'Master core mathematical concepts, shortcut formulas, and time-saving calculation techniques required for company online assessment tests.',
      roadmap: 'Phase 1: Basic Fractions & Ratios → Phase 2: Work Rates & Pipe Problems → Phase 3: Speed, Distance & Train Problems → Phase 4: Mock Tests.',
      tips: [
        'Formula: Work Done = Rate × Time. If A takes X days and B takes Y days, combined rate = (X*Y)/(X+Y).',
        'Speed Conversion: To convert km/h to m/s, multiply by 5/18. To convert m/s to km/h, multiply by 18/5.',
        'Relative Speed: If two objects move in opposite directions, relative speed = S1 + S2. If same direction, relative speed = |S1 - S2|.',
        'Practice 20 speed math calculations daily to reduce assessment time by 30%.'
      ],
      resourceUrls: [
        'https://www.indiabix.com/aptitude/time-and-work/',
        'https://www.geeksforgeeks.org/aptitude-questions-and-answers/',
      ],
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          category: 'Aptitude',
          question: 'A can complete a task in 10 days and B can complete the same task in 15 days. How many days will they take working together?',
          answer: 'Combined Days = (10 × 15) / (10 + 15) = 150 / 25 = 6 Days.',
          keyPoints: ['Use reciprocal rate addition: 1/10 + 1/15 = 5/30 = 1/6', 'Combined Rate = 1/6 task per day -> 6 Days total'],
        ),
        PlacementQuestionAnswer(
          category: 'Aptitude',
          question: 'A train 150 meters long passes a telegraph post in 9 seconds. What is the speed of the train in km/h?',
          answer: 'Speed in m/s = Distance / Time = 150 / 9 = 50/3 m/s. Convert to km/h: (50/3) × (18/5) = 60 km/h.',
          keyPoints: ['Distance covered passing a pole = Length of train (150m)', 'Multiply m/s by 18/5 to get km/h'],
        ),
      ],
    ),

    // --- STAGE 2: LOGICAL REASONING ---
    PlacementModel(
      id: 'logical_reasoning',
      category: 'Logical Reasoning',
      title: 'Logical Reasoning & Data Interpretation',
      description: 'Master circular & linear seating arrangements, blood relations, syllogisms, and bar/pie chart data interpretation.',
      roadmap: 'Phase 1: Blood Relations & Directions → Phase 2: Syllogism Venn Diagrams → Phase 3: Seating Arrangements → Phase 4: Data Interpretation Charts.',
      tips: [
        'Always draw a visual diagram (Venn diagram for syllogisms, circle for seating arrangements).',
        'Identify definite clues first (e.g. "A sits 3rd to the left of B") before testing conditional assumptions.',
        'Eliminate options using boundary checks in inequality and series completion questions.'
      ],
      resourceUrls: [
        'https://www.indiabix.com/logical-reasoning/questions-and-answers/',
      ],
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          category: 'Logical Reasoning',
          question: 'Statements: All cats are dogs. All dogs are mammals. Conclusion: Are all cats mammals?',
          answer: 'Yes, valid. Since Cats ⊂ Dogs ⊂ Mammals, all cats are transitively mammals.',
          keyPoints: ['Draw nested concentric circles: Cats inside Dogs inside Mammals', 'Transitive property holds for universal affirmative statements'],
        ),
      ],
    ),

    // --- STAGE 3: CORE CS TECHNICAL INTERVIEW ---
    PlacementModel(
      id: 'tech_interview_cs',
      category: 'Technical Interview',
      title: 'Core CS Technical Q&A: OS, DBMS & Computer Networks',
      description: 'High-frequency technical interview questions on Operating Systems, Database Management Systems, SQL, Computer Networks, and OOP.',
      roadmap: 'Phase 1: OS Processes, Threads & Deadlocks → Phase 2: DBMS ACID Transactions & SQL Joins → Phase 3: Computer Networks OSI Layers & Protocols → Phase 4: OOP SOLID Principles.',
      tips: [
        'Structure technical answers using: Definition → Core Mechanism → Real-World Example → Tradeoffs.',
        'Be ready to write clean SQL queries (INNER JOIN, GROUP BY, HAVING, subqueries) on a whiteboard or shared editor.',
        'Explain OS process synchronization using the Semaphore / Mutex analogy.'
      ],
      resourceUrls: [
        'https://www.geeksforgeeks.org/operating-systems/',
        'https://www.geeksforgeeks.org/dbms/',
      ],
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          category: 'Technical',
          question: 'Explain the difference between a Process and a Thread.',
          answer: 'A Process is an executing program instance with its own independent memory space (heap, stack, code). A Thread is a lightweight execution unit inside a process that shares memory and resources with sibling threads.',
          keyPoints: ['Process context switching is heavy; thread switching is fast', 'Threads share heap memory; processes do not share memory space'],
        ),
        PlacementQuestionAnswer(
          category: 'Technical',
          question: 'What are ACID properties in Database Systems?',
          answer: 'ACID guarantees database transaction reliability: Atomicity (all-or-nothing), Consistency (data validity rules enforced), Isolation (concurrent transactions execute independently), Durability (committed changes persist despite crashes).',
          keyPoints: ['Atomicity prevents partial writes', 'Isolation prevents dirty reads & phantom reads', 'Durability guaranteed via Write-Ahead Logging (WAL)'],
        ),
        PlacementQuestionAnswer(
          category: 'Technical',
          question: 'What happens when you type a URL into a web browser?',
          answer: '1. Browser checks cache -> 2. DNS resolution converts domain name to IP -> 3. TCP 3-way handshake established -> 4. TLS handshake for HTTPS -> 5. HTTP GET request sent -> 6. Server responds with HTML/CSS/JS -> 7. Browser renders DOM tree.',
          keyPoints: ['DNS lookup hierarchy: Browser -> OS -> Resolver -> Root -> TLD -> Authoritative', 'TCP 3-Way Handshake: SYN -> SYN-ACK -> ACK'],
        ),
      ],
    ),

    // --- STAGE 4: HR & BEHAVIORAL STAR METHOD ---
    PlacementModel(
      id: 'hr_interview_star',
      category: 'HR Interview',
      title: 'HR Interview Mastery & STAR Behavioral Method',
      description: 'Structure behavioral interview responses using the STAR method (Situation, Task, Action, Result) to impress HR interviewers.',
      roadmap: 'Phase 1: Draft STAR stories for 5 core scenarios → Phase 2: Practice 2-minute elevator pitch → Phase 3: Master salary negotiation & company culture alignment.',
      tips: [
        'STAR Formula: 20% Situation, 15% Task, 50% Action (What YOU specifically did), 15% Measurable Result.',
        'Never speak negatively about past teammates, professors, or employers.',
        'Always ask 2 thoughtful questions at the end of the interview (e.g. "What tech stack initiatives is the team focusing on for the next 6 months?")'
      ],
      resourceUrls: [
        'https://www.techinterviewhandbook.org/behavioral-interview-cheatsheet/',
      ],
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          category: 'HR',
          question: 'Tell me about a time you faced a major technical challenge during a team project.',
          answer: 'Situation: During our 3rd-year engineering project, our API response time spiked to 4 seconds.\nTask: I was responsible for backend performance.\nAction: I profiled database queries, discovered missing indexes on foreign keys, and implemented Redis caching for frequent GET requests.\nResult: Response time dropped by 85% down to 180ms, enabling our app to handle 500 concurrent test users.',
          keyPoints: ['Quantify results with numbers (85% reduction, 180ms)', 'Highlight YOUR individual contribution within the team'],
        ),
        PlacementQuestionAnswer(
          category: 'HR',
          question: 'Where do you see yourself in 5 years?',
          answer: 'In 5 years, I aim to have grown into a Senior Software Engineer specializing in scalable cloud microservices, taking technical ownership of critical products and mentoring junior engineers.',
          keyPoints: ['Demonstrate long-term commitment to software engineering excellence', 'Align personal goals with technical growth and team leadership'],
        ),
      ],
    ),

    // --- STAGE 5: RESUME & LINKEDIN PREPARATION ---
    PlacementModel(
      id: 'resume_linkedin_guide',
      category: 'Resume Guide',
      title: 'ATS-Friendly Resume Building & LinkedIn Optimization',
      description: 'Format an ATS-optimized one-page engineering resume and build an active LinkedIn professional profile.',
      roadmap: 'Phase 1: Choose single-column ATS LaTeX/Markdown layout → Phase 2: Write action-verb bullet points with metrics → Phase 3: Optimize LinkedIn headline & GitHub portfolio links.',
      tips: [
        'Use single-column layout without tables, graphics, or multi-column text frames so ATS parsers extract data 100% cleanly.',
        'XYZ Bullet Formula: Accomplished [X] as measured by [Y], by doing [Z]. Example: "Increased test coverage by 35% by implementing automated Flutter unit & widget integration test suites."',
        'Include clickable hyperlinked URLs to live demo apps and GitHub repositories.'
      ],
      resourceUrls: [
        'https://overleaf.com/latex/templates/jakes-resume/syzsqrzwvwcd',
      ],
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          category: 'Resume Guide',
          question: 'What are the essential sections for a CS/IT student resume?',
          answer: '1. Header (Name, Email, Phone, GitHub, LinkedIn, Location)\n2. Education (Degree, Branch, CGPA/Percentage, Graduation Year)\n3. Technical Skills (Languages, Frameworks, Databases, Tools)\n4. Projects (Title, Tech Stack, 2-3 Action Bullets with Metrics)\n5. Certifications & Achievements.',
          keyPoints: ['Keep to 1 single page', 'List strongest projects first with active GitHub links'],
        ),
      ],
    ),
  ];
}

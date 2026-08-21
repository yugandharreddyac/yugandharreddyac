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

  static List<PlacementModel> get fallbackPlacementResources =>
      _fallbackPlacementResources;

  static const List<PlacementModel> _fallbackPlacementResources = [
    // --- STAGE 1: PLACEMENT FUNDAMENTALS & ROADMAP ---
    PlacementModel(
      id: 'placement_fundamentals',
      category: 'Placement Roadmap',
      title: 'Campus Placement Roadmap & Process Masterclass',
      description:
          'Complete beginner-first placement roadmap for CSE students: understand campus recruitment rounds, CGPA benchmarks, eligibility criteria, online assessments (OA), and 4-year preparation timeline.',
      roadmap:
          'Year 1: Core Programming & Math → Year 2: DSA & CS Fundamentals → Year 3: Projects, Resume & OA Practice → Year 4: Company Prep & Mock Interviews.',
      tips: [
        'Understand the 4 main recruitment rounds: 1. Online Aptitude & Coding Assessment (OA), 2. Technical Coding Round, 3. Core CS Technical Interview, 4. HR Behavioral Round.',
        'Maintain a target CGPA of 7.5+ (preferably 8.0+) to remain eligible for 95%+ of visiting campus placement companies.',
        'Start aptitude practice in 1st year and DSA practice by 2nd year to avoid last-minute cramming in 4th year.',
        'Track your preparation daily using solved problem count, timed test scores, and project portfolio commits.'
      ],
      resourceUrls: [
        'https://www.geeksforgeeks.org/campus-placement-preparation-course/',
        'https://practice.geeksforgeeks.org/explore?page=1&curated[]=1',
      ],
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          category: 'Roadmap',
          question:
              'What is the standard campus placement selection process for CSE students?',
          answer:
              'The typical process consists of 4 stages: 1. Resume Shortlisting & CGPA Cutoff -> 2. Online Assessment (Aptitude, Reasoning, Verbal & 2 Coding Problems) -> 3. Technical Interview Rounds (DSA, CS Fundamentals, Projects) -> 4. HR / Management Interview.',
          keyPoints: [
            'First round filter is OA + CGPA',
            'Technical round evaluates DSA problem-solving & CS fundamentals',
            'HR round evaluates communication & company culture fit'
          ],
        ),
        PlacementQuestionAnswer(
          category: 'Roadmap',
          question:
              'What should a first-year CSE student focus on for placements?',
          answer:
              '1st Year Focus: 1. Master one programming language deeply (C++ / Java / Python), 2. Practice basic quantitative math & logical reasoning 30 mins daily, 3. Maintain CGPA above 8.0, 4. Build strong English & communication skills.',
          keyPoints: [
            'Master language fundamentals first',
            'Do not stress over advanced system design in 1st year'
          ],
        ),
      ],
    ),

    // --- STAGE 2: QUANTITATIVE APTITUDE ---
    PlacementModel(
      id: 'aptitude_time_work',
      category: 'Aptitude',
      title: 'Quantitative Aptitude: Speed Math, Work & Percentages',
      description:
          'Master core mathematical concepts, shortcut formulas, percentages, ratios, time & work, and speed distance required for company online assessment tests.',
      roadmap:
          'Phase 1: Basic Fractions & Ratios → Phase 2: Percentages & Profit/Loss → Phase 3: Work Rates & Pipe Problems → Phase 4: Speed, Distance & Timed Practice.',
      tips: [
        'Formula: Work Done = Rate × Time. If A takes X days and B takes Y days, combined rate = (X*Y)/(X+Y).',
        'Speed Conversion: To convert km/h to m/s, multiply by 5/18. To convert m/s to km/h, multiply by 18/5.',
        'Percentage Shortcut: X% of Y = Y% of X. E.g., 16% of 50 = 50% of 16 = 8.',
        'Relative Speed: If two objects move in opposite directions, relative speed = S1 + S2. If same direction, relative speed = |S1 - S2|.',
        'Practice 20 speed math calculations daily to reduce assessment time by 30%.'
      ],
      resourceUrls: [
        'https://www.indiabix.com/aptitude/percentage/',
        'https://www.indiabix.com/aptitude/time-and-work/',
        'https://www.geeksforgeeks.org/aptitude-questions-and-answers/',
      ],
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          category: 'Aptitude',
          question:
              'A can complete a task in 10 days and B can complete the same task in 15 days. How many days will they take working together?',
          answer: 'Combined Days = (10 × 15) / (10 + 15) = 150 / 25 = 6 Days.',
          keyPoints: [
            'Use reciprocal rate addition: 1/10 + 1/15 = 5/30 = 1/6',
            'Combined Rate = 1/6 task per day -> 6 Days total'
          ],
        ),
        PlacementQuestionAnswer(
          category: 'Aptitude',
          question:
              'A train 150 meters long passes a telegraph post in 9 seconds. What is the speed of the train in km/h?',
          answer:
              'Speed in m/s = Distance / Time = 150 / 9 = 50/3 m/s. Convert to km/h: (50/3) × (18/5) = 60 km/h.',
          keyPoints: [
            'Distance covered passing a pole = Length of train (150m)',
            'Multiply m/s by 18/5 to get km/h'
          ],
        ),
        PlacementQuestionAnswer(
          category: 'Aptitude',
          question:
              'If the price of sugar increases by 25%, by what percentage must a household reduce consumption to keep expenditure constant?',
          answer:
              'Reduction % = [R / (100 + R)] × 100 = [25 / 125] × 100 = 20%.',
          keyPoints: [
            'Use standard percentage formula: R / (100 + R) * 100 for price increase',
            '25% increase requires 20% consumption reduction'
          ],
        ),
      ],
    ),

    // --- STAGE 3: LOGICAL REASONING ---
    PlacementModel(
      id: 'logical_reasoning',
      category: 'Logical Reasoning',
      title: 'Logical Reasoning & Data Interpretation',
      description:
          'Master circular & linear seating arrangements, blood relations, syllogisms, number/letter series, coding-decoding, and chart interpretation.',
      roadmap:
          'Phase 1: Series & Coding-Decoding → Phase 2: Blood Relations & Directions → Phase 3: Syllogism Venn Diagrams → Phase 4: Seating Arrangements & Puzzles.',
      tips: [
        'Always draw a visual diagram (Venn diagram for syllogisms, circle/line for seating arrangements).',
        'Identify definite clues first (e.g. "A sits 3rd to the left of B") before testing conditional assumptions.',
        'Eliminate options using boundary checks in inequality and series completion questions.',
        'Blood Relations Strategy: Trace relationships starting from yourself ("My father\'s brother\'s son" = Cousin).'
      ],
      resourceUrls: [
        'https://www.indiabix.com/logical-reasoning/number-series/',
        'https://www.indiabix.com/logical-reasoning/blood-relation-test/',
        'https://www.geeksforgeeks.org/logical-reasoning/',
      ],
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          category: 'Logical Reasoning',
          question:
              'Statements: All cats are dogs. All dogs are mammals. Conclusion: Are all cats mammals?',
          answer:
              'Yes, valid. Since Cats ⊂ Dogs ⊂ Mammals, all cats are transitively mammals.',
          keyPoints: [
            'Draw nested concentric circles: Cats inside Dogs inside Mammals',
            'Transitive property holds for universal affirmative statements'
          ],
        ),
        PlacementQuestionAnswer(
          category: 'Logical Reasoning',
          question:
              'Pointing to a photograph, a man said "I have no brother or sister, but that man\'s father is my father\'s son." Whose photograph was it?',
          answer:
              'His son\'s photograph. "My father\'s son" = Himself (since he has no siblings). So "that man\'s father is myself" -> The photograph is of his son.',
          keyPoints: [
            'Break down statement backward',
            '"My father\'s son" with no siblings = Me'
          ],
        ),
      ],
    ),

    // --- STAGE 4: VERBAL ABILITY & COMMUNICATION ---
    PlacementModel(
      id: 'verbal_ability',
      category: 'Verbal Ability',
      title: 'Verbal Ability, Grammar & Professional Communication',
      description:
          'Master English grammar rules, spotting errors, sentence correction, reading comprehension strategies, vocabulary building, and interview communication.',
      roadmap:
          'Phase 1: Grammar Rules & Subject-Verb Agreement → Phase 2: Vocabulary & Synonym/Antonym Practice → Phase 3: Reading Comprehension Techniques → Phase 4: Professional Self Introduction.',
      tips: [
        'Subject-Verb Agreement Rule: Singular subjects take singular verbs ("The list of items is..."), plural subjects take plural verbs.',
        'Reading Comprehension Strategy: Read the questions first before reading the long passage to locate key answers quickly.',
        'Interview Speaking Rule: Speak at a moderate pace, avoid filler words ("um", "like", "you know"), and maintain steady eye contact.'
      ],
      resourceUrls: [
        'https://www.indiabix.com/verbal-ability/spotting-errors/',
        'https://www.geeksforgeeks.org/verbal-ability/',
      ],
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          category: 'Verbal Ability',
          question:
              'Spot the error: "Each of the students have submitted their assignment."',
          answer:
              'Error: "have". Correct sentence: "Each of the students HAS submitted his/her assignment." Reason: "Each" is a singular indefinite pronoun requiring a singular verb ("has").',
          keyPoints: [
            'Indefinite pronouns (each, every, someone) take singular verbs',
            'Do not get confused by plural noun "students" inside prepositional phrase'
          ],
        ),
      ],
    ),

    // --- STAGE 5: CORE CS TECHNICAL INTERVIEW ---
    PlacementModel(
      id: 'tech_interview_cs',
      category: 'Technical Interview',
      title: 'Core CS Technical Q&A: OS, DBMS, Networks & SQL',
      description:
          'High-frequency technical interview questions on Operating Systems, Database Management Systems, SQL queries, Computer Networks, and OOP.',
      roadmap:
          'Phase 1: OS Processes, Threads & Deadlocks → Phase 2: DBMS ACID Transactions & SQL Joins → Phase 3: Computer Networks OSI Layers & Protocols → Phase 4: OOP SOLID Principles.',
      tips: [
        'Structure technical answers using: Definition → Core Mechanism → Real-World Example → Tradeoffs.',
        'Be ready to write clean SQL queries (INNER JOIN, GROUP BY, HAVING, subqueries) on a whiteboard or shared editor.',
        'Explain OS process synchronization using the Semaphore / Mutex analogy.',
        'For Networks: Be ready to trace a URL request from DNS lookup to TCP handshake to HTTP response.'
      ],
      resourceUrls: [
        'https://www.geeksforgeeks.org/operating-systems/',
        'https://www.geeksforgeeks.org/dbms/',
        'https://www.geeksforgeeks.org/sql-tutorial/',
      ],
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          category: 'Technical',
          question: 'Explain the difference between a Process and a Thread.',
          answer:
              'A Process is an executing program instance with its own independent memory space (heap, stack, code). A Thread is a lightweight execution unit inside a process that shares memory and resources with sibling threads.',
          keyPoints: [
            'Process context switching is heavy; thread switching is fast',
            'Threads share heap memory; processes do not share memory space'
          ],
        ),
        PlacementQuestionAnswer(
          category: 'Technical',
          question: 'What are ACID properties in Database Systems?',
          answer:
              'ACID guarantees database transaction reliability: Atomicity (all-or-nothing), Consistency (data validity rules enforced), Isolation (concurrent transactions execute independently), Durability (committed changes persist despite crashes).',
          keyPoints: [
            'Atomicity prevents partial writes',
            'Isolation prevents dirty reads & phantom reads',
            'Durability guaranteed via Write-Ahead Logging (WAL)'
          ],
        ),
        PlacementQuestionAnswer(
          category: 'Technical',
          question: 'What happens when you type a URL into a web browser?',
          answer:
              '1. Browser checks cache -> 2. DNS resolution converts domain name to IP -> 3. TCP 3-way handshake established -> 4. TLS handshake for HTTPS -> 5. HTTP GET request sent -> 6. Server responds with HTML/CSS/JS -> 7. Browser renders DOM tree.',
          keyPoints: [
            'DNS lookup hierarchy: Browser -> OS -> Resolver -> Root -> TLD -> Authoritative',
            'TCP 3-Way Handshake: SYN -> SYN-ACK -> ACK'
          ],
        ),
      ],
    ),

    // --- STAGE 6: CODING INTERVIEWS ---
    PlacementModel(
      id: 'coding_interviews',
      category: 'Coding Interviews',
      title: 'Coding Interview Patterns & DSA Problem Solving',
      description:
          'High-frequency coding interview patterns: Two Pointers, Sliding Window, Fast & Slow Pointers, Linked Lists, Binary Trees, Graphs, Dynamic Programming, and time/space complexity trade-offs.',
      roadmap:
          'Phase 1: Arrays & Two Pointers → Phase 2: Sliding Window & Fast/Slow Pointers → Phase 3: Trees & Graphs → Phase 4: Dynamic Programming & Top 150 LeetCode.',
      tips: [
        'Always communicate your thought process aloud before writing a single line of code.',
        'Start with a Brute Force approach, state its time/space complexity, then optimize using patterns (Hashing, Two Pointers, DP).',
        'Dry run your solution with a sample input and test boundary cases (empty array, null pointer, single element) before declaring finished.'
      ],
      resourceUrls: [
        'https://leetcode.com/studyplan/top-interview-150/',
        'https://takeuforward.org/strivers-a2zdsa-course/strivers-a2z-dsa-course-sheet-2/',
        'https://neetcode.io/roadmap',
      ],
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          category: 'Coding',
          question:
              'How do you solve the Two Sum problem in O(N) time complexity?',
          answer:
              'Use a Hash Map storing value -> index. Iterate through the array once: for element X, check if (Target - X) exists in the Hash Map. If found, return [map[Target - X], current_index]. If not, insert X -> current_index into map.',
          keyPoints: [
            'Brute force is O(N^2) using nested loops',
            'Hash map reduces lookup to O(1), achieving overall O(N) time and O(N) space'
          ],
        ),
      ],
    ),

    // --- STAGE 7: HR & BEHAVIORAL STAR METHOD ---
    PlacementModel(
      id: 'hr_interview_star',
      category: 'HR Interview',
      title: 'HR Interview Mastery & STAR Behavioral Method',
      description:
          'Structure behavioral interview responses using the STAR method (Situation, Task, Action, Result) to impress HR interviewers for Tell me about yourself, Strengths/Weaknesses, and Career Goals.',
      roadmap:
          'Phase 1: Draft STAR stories for 5 core scenarios → Phase 2: Practice 2-minute elevator pitch → Phase 3: Master salary negotiation & company culture alignment.',
      tips: [
        'STAR Formula: 20% Situation, 15% Task, 50% Action (What YOU specifically did), 15% Measurable Result.',
        'Never speak negatively about past teammates, professors, or employers.',
        'Always ask 2 thoughtful questions at the end of the interview (e.g. "What tech stack initiatives is the team focusing on for the next 6 months?")'
      ],
      resourceUrls: [
        'https://www.techinterviewhandbook.org/behavioral-interview-cheatsheet/',
        'https://www.geeksforgeeks.org/hr-interview-questions/',
      ],
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          category: 'HR',
          question:
              'Tell me about a time you faced a major technical challenge during a team project.',
          answer:
              'Situation: During our 3rd-year engineering project, our API response time spiked to 4 seconds.\nTask: I was responsible for backend performance.\nAction: I profiled database queries, discovered missing indexes on foreign keys, and implemented Redis caching for frequent GET requests.\nResult: Response time dropped by 85% down to 180ms, enabling our app to handle 500 concurrent test users.',
          keyPoints: [
            'Quantify results with numbers (85% reduction, 180ms)',
            'Highlight YOUR individual contribution within the team'
          ],
        ),
        PlacementQuestionAnswer(
          category: 'HR',
          question: 'Where do you see yourself in 5 years?',
          answer:
              'In 5 years, I aim to have grown into a Senior Software Engineer specializing in scalable cloud microservices, taking technical ownership of critical products and mentoring junior engineers.',
          keyPoints: [
            'Demonstrate long-term commitment to software engineering excellence',
            'Align personal goals with technical growth and team leadership'
          ],
        ),
      ],
    ),

    // --- STAGE 8: RESUME & LINKEDIN PREPARATION ---
    PlacementModel(
      id: 'resume_linkedin_guide',
      category: 'Resume Guide',
      title: 'ATS-Friendly Resume Building & LinkedIn Optimization',
      description:
          'Format an ATS-optimized one-page engineering resume (Jake\'s LaTeX template) and build an active LinkedIn professional profile.',
      roadmap:
          'Phase 1: Choose single-column ATS LaTeX/Markdown layout → Phase 2: Write action-verb bullet points with metrics → Phase 3: Optimize LinkedIn headline & GitHub portfolio links.',
      tips: [
        'Use single-column layout without tables, graphics, or multi-column text frames so ATS parsers extract data 100% cleanly.',
        'XYZ Bullet Formula: Accomplished [X] as measured by [Y], by doing [Z]. Example: "Increased test coverage by 35% by implementing automated Flutter unit & widget integration test suites."',
        'Include clickable hyperlinked URLs to live demo apps and GitHub repositories.'
      ],
      resourceUrls: [
        'https://www.overleaf.com/latex/templates/jakes-resume/syzsqfdxflqy',
        'https://resumeworded.com/',
      ],
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          category: 'Resume Guide',
          question:
              'What are the essential sections for a CS/IT student resume?',
          answer:
              '1. Header (Name, Email, Phone, GitHub, LinkedIn, Location)\n2. Education (Degree, Branch, CGPA/Percentage, Graduation Year)\n3. Technical Skills (Languages, Frameworks, Databases, Tools)\n4. Projects (Title, Tech Stack, 2-3 Action Bullets with Metrics)\n5. Certifications & Achievements.',
          keyPoints: [
            'Keep to 1 single page',
            'List strongest projects first with active GitHub links'
          ],
        ),
      ],
    ),

    // --- STAGE 9: COMPANY PREPARATION & CHECKLIST ---
    PlacementModel(
      id: 'company_prep',
      category: 'Company Preparation',
      title: 'Target Company Research & Application Checklist',
      description:
          'Learn how to research target tech companies, analyze job descriptions, identify required skills, review interview rounds, and follow a pre-interview application checklist.',
      roadmap:
          'Phase 1: Job Description & Skill Gap Analysis → Phase 2: Company Products & Tech Stack Research → Phase 3: Review Past Interview Experiences → Phase 4: Final Day Checklist.',
      tips: [
        'Analyze the Job Description (JD) to identify mandatory vs nice-to-have skills (e.g. React vs Docker).',
        'Research company news, recent funding, product releases, and engineering blog posts before your interview.',
        'Prepare 2 specific questions about the company\'s engineering culture and challenges.'
      ],
      resourceUrls: [
        'https://www.geeksforgeeks.org/company-interview-corner/',
        'https://www.linkedin.com/jobs/',
      ],
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          category: 'Company Prep',
          question:
              'How should a student prepare for a specific company\'s campus placement drive?',
          answer:
              '1. Research the company\'s core products and tech stack. 2. Solve past company interview questions on GeeksforGeeks Company Corner. 3. Review core CS subjects relevant to their tech stack (e.g., DBMS & SQL for backend roles). 4. Prepare customized questions for the interviewer.',
          keyPoints: [
            'Solve past 3 years company specific coding & aptitude questions',
            'Customize your resume highlights according to the job role'
          ],
        ),
      ],
    ),
  ];
}

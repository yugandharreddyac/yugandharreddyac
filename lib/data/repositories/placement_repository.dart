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

  static const List<PlacementModel> _fallbackPlacementResources = [
    PlacementModel(
      id: 'aptitude',
      category: 'Aptitude',
      title: 'Quantitative Aptitude Master Guide',
      description: 'Comprehensive formulas, shortcuts, and practice sets for campus placement exams.',
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          question: 'A train 150m long is running at 54 km/hr. How long will it take to cross a platform 250m long?',
          answer: 'Speed = 54 * (5/18) = 15 m/s. Total distance = 150 + 250 = 400m. Time = 400 / 15 = 26.67 seconds.',
          category: 'Time & Distance',
          keyPoints: ['Convert km/hr to m/s by multiplying with 5/18', 'Total distance = Train length + Platform length'],
        ),
        PlacementQuestionAnswer(
          question: 'If A can complete a work in 10 days and B in 15 days, in how many days can they complete it together?',
          answer: 'A\'s 1-day work = 1/10. B\'s 1-day work = 1/15. Together 1-day work = 1/10 + 1/15 = 5/30 = 1/6. Total days = 6 days.',
          category: 'Time & Work',
          keyPoints: ['Use LCM method for faster calculations: LCM(10, 15) = 30 units total work.'],
        ),
      ],
      tips: [
        'Memorize squares up to 30, cubes up to 20, and fraction-to-percentage conversions.',
        'Use options elimination techniques for faster solving in online assessment tests (TCS NQT, Infosys, Wipro).'
      ],
      resourceUrls: [
        'https://www.indiabix.com/aptitude/questions-and-answers/',
      ],
      roadmap: 'Phase 1: Arithmetic (Percentages, Profit/Loss, Ratio) -> Phase 2: Algebra & Geometry -> Phase 3: Speed Math & Data Interpretation.',
    ),
    PlacementModel(
      id: 'reasoning',
      category: 'Logical Reasoning',
      title: 'Logical Reasoning & Analytical Thinking',
      description: 'Master Puzzles, Seating Arrangements, Blood Relations, Syllogisms, and Coding-Decoding.',
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          question: 'All cats are animals. All animals are mammals. Conclusion: Are all cats mammals?',
          answer: 'Yes. By Venn diagram / Syllogism rules, Cat ⊂ Animal ⊂ Mammal, hence All cats are mammals.',
          category: 'Syllogisms',
          keyPoints: ['Draw Venn diagrams for 100% accuracy in Syllogism conclusions.'],
        ),
      ],
      tips: [
        'Practice 5 complex seating arrangement puzzles daily to build mental speed.',
        'Draw clean diagrams immediately when solving Blood Relations or Direction Sense questions.'
      ],
      resourceUrls: ['https://www.geeksforgeeks.org/logical-reasoning/'],
      roadmap: 'Clocks & Calendars -> Syllogisms -> Blood Relations -> Seating Arrangement -> Data Sufficiency.',
    ),
    PlacementModel(
      id: 'verbal',
      category: 'Verbal Ability',
      title: 'Verbal Ability & Grammar Accuracy',
      description: 'Reading Comprehension, Error Spotting, Sentence Completion, Synonyms & Antonyms.',
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          question: 'Spot the error: "Neither of the two candidates have submitted their application."',
          answer: 'Error in "have". Correct: "Neither of the two candidates HAS submitted HIS/HER application." "Neither of" takes a singular verb.',
          category: 'Subject-Verb Agreement',
          keyPoints: ['"Neither of", "Either of", "Each of" always take a singular verb.'],
        ),
      ],
      tips: [
        'Read editorial articles from The Hindu or Guardian daily to expand vocabulary and speed up Reading Comprehension.',
        'Revise standard Subject-Verb Agreement rules.'
      ],
      resourceUrls: ['https://www.indiabix.com/verbal-ability/questions-and-answers/'],
      roadmap: 'Grammar Rules -> Vocabulary Building -> Para Jumbles -> Reading Comprehension.',
    ),
    PlacementModel(
      id: 'tech_interview',
      category: 'Technical Interview',
      title: 'Core Technical Interview Questions (CS/IT)',
      description: 'Top questions on Data Structures, OOPs, DBMS, Operating Systems, Computer Networks.',
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          question: 'What is the difference between Process and Thread?',
          answer: 'A Process is an independent executing program with its own memory space. A Thread is a lightweight subset of a process sharing the parent process\'s memory space.',
          category: 'Operating Systems',
          keyPoints: ['Process isolation vs Thread shared memory', 'Context switching overhead is higher in processes.'],
        ),
        PlacementQuestionAnswer(
          question: 'Explain ACID properties in DBMS with an example.',
          answer: 'Atomicity (All or nothing), Consistency (State remains valid), Isolation (Concurrent transactions don\'t interfere), Durability (Committed data survives crashes). Example: Bank money transfer.',
          category: 'DBMS',
          keyPoints: ['Crucial for relational databases like PostgreSQL/MySQL.'],
        ),
      ],
      tips: [
        'Always speak your thought process aloud during technical coding rounds.',
        'Be prepared to explain the Time & Space Complexity (Big-O notation) of your solution.'
      ],
      resourceUrls: ['https://www.geeksforgeeks.org/top-100-technical-interview-questions/'],
      roadmap: 'OOPs & C++/Java Basics -> Data Structures & Algorithms -> DBMS & SQL -> OS & Networks.',
    ),
    PlacementModel(
      id: 'hr_interview',
      category: 'HR Interview',
      title: 'HR & Behavioral Interview Preparation',
      description: 'Master STAR method for behavioral questions like "Tell me about yourself", "Strengths/Weaknesses", "Conflict Resolution".',
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          question: 'Tell me about yourself.',
          answer: 'Present your pitch in 90 seconds: Present (your current degree, major project), Past (key achievements, technical skills learned), Future (why you are passionate about this company and role).',
          category: 'HR Basics',
          keyPoints: ['Keep it professional, structured, concise, and enthusiastic.'],
        ),
      ],
      tips: [
        'Use the STAR method (Situation, Task, Action, Result) when describing past projects or team experiences.',
        'Research the company\'s core values, products, and recent tech news prior to the HR round.'
      ],
      resourceUrls: ['https://www.geeksforgeeks.org/common-hr-interview-questions/'],
      roadmap: 'Elevator Pitch -> Behavioral STAR Stories -> Company Research -> Salary & Relocation Answers.',
    ),
    PlacementModel(
      id: 'resume_guide',
      category: 'Resume Building',
      title: 'ATS-Friendly Engineering Resume Master Guide',
      description: 'How to build single-page ATS-optimized resumes that land technical interviews.',
      questionsAndAnswers: [
        PlacementQuestionAnswer(
          question: 'How do I optimize my resume for ATS (Applicant Tracking Systems)?',
          answer: 'Use a clean single-column layout, plain PDF format, standard bullet points starting with strong action verbs (Built, Developed, Optimized), and include key technical keywords from the job description.',
          category: 'ATS Strategy',
          keyPoints: ['Never use multi-column graphical templates or images in ATS resumes.', 'Quantify results (e.g. "Reduced load time by 35%").'],
        ),
      ],
      tips: [
        'Keep engineering resume strictly to 1 page.',
        'Use Overleaf / LaTeX template (e.g. Jake\'s Resume template).'
      ],
      resourceUrls: ['https://overleaf.com/latex/templates/jakes-resume/syzsgwyzngvd'],
      roadmap: 'Format Selection -> Work Experience / Projects Bullet Points -> Skill Sectioning -> Final Proofreading.',
    ),
  ];
}

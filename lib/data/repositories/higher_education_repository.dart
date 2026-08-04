import '../datasources/firebase_datasource.dart';
import '../models/higher_education_model.dart';

class HigherEducationRepository {
  final FirebaseDataSource firebaseDataSource;

  HigherEducationRepository({required this.firebaseDataSource});

  Future<List<HigherEducationModel>> getHigherEducationResources() async {
    try {
      final data = await firebaseDataSource.getHigherEducationResources();
      if (data.isNotEmpty) {
        return data.map((json) => HigherEducationModel.fromJson(json)).toList();
      }
    } catch (_) {}

    return _getFallbackData();
  }

  List<HigherEducationModel> _getFallbackData() {
    return const [
      // --- SECTION 1: HIGHER STUDIES ---
      HigherEducationModel(
        id: 'gate_exam',
        title: 'GATE CSE 2027 (Graduate Aptitude Test in Engineering - Computer Science)',
        category: 'Higher Studies',
        subtitle: 'M.Tech / M.E. Admission in IISc, IITs & PSU Scientist / Executive Recruitment',
        overview: 'GATE CSE 2027 is the premier national-level entrance examination for Computer Science & Engineering (CSSE/CSE) students. Conducted jointly by IISc and IITs (IIT Kanpur organizing institute), GATE CSE provides admission into M.Tech, M.S. and Ph.D. programs at premier institutes and direct recruitment into top Public Sector Undertakings (PSUs).',
        eligibilityCriteria: 'B.E. / B.Tech / B.Sc / M.Sc pre-final year (3rd Year) and final year (4th Year) CSSE, CSE, and IT students. No upper age limit.',
        whoShouldApply: 'CSSE students preparing for M.Tech/Ph.D. at IISc, IITs, NITs, or direct PSU Engineering Scientist jobs (DRDO, ISRO, BARC, PowerGrid, NTPC, IOCL).',
        examPattern: 'Computer Based Test (CBT), 3 Hours, 65 Questions, 100 Marks. General Aptitude: 15 Marks (10 Qs), CSSE Core & Math: 85 Marks (55 Qs). Question Types: MCQs (1/3 & 2/3 negative marking), MSQs (Multiple Select - No negative marking), NAT (Numerical Answer Type - No negative marking).',
        syllabusTopics: [
          'General Aptitude (Verbal Ability, Numerical Ability, Analytical & Spatial Reasoning)',
          'Engineering Mathematics (Discrete Mathematics, Linear Algebra, Calculus, Probability & Statistics)',
          'Digital Logic (Boolean Algebra, Combinational & Sequential Circuits, Minimization)',
          'Computer Organization & Architecture (COA, Pipelining, Memory Hierarchy, Cache, Addressing Modes)',
          'Programming & Data Structures (C Programming, Recursion, Arrays, Stacks, Queues, Trees, Graphs, Hashing)',
          'Algorithms (Searching, Sorting, Dynamic Programming, Greedy Algorithms, Graph Algorithms, Complexity)',
          'Theory of Computation (TOC, Finite Automata, Regular Expressions, Context-Free Grammars, Turing Machines)',
          'Compiler Design (Lexical Analysis, Parsing, Syntax-Directed Translation, Intermediate Code Generation)',
          'Operating Systems (Processes, Threads, CPU Scheduling, Deadlocks, Memory Management, File Systems)',
          'Database Management Systems (DBMS, ER Model, Relational Algebra, SQL, Normalization, Transactions)',
          'Computer Networks (OSI & TCP/IP Reference Models, Data Link Layer, IP Subnetting, Routing, TCP/UDP, DNS)'
        ],
        preparationTimeline: [
          'Months 1-4: Core CSSE Subjects & Engineering Mathematics Fundamental Concepts',
          'Months 5-7: Subject-wise Problem Solving & 25 Years of GATE CSE PYQs (2000-2026)',
          'Months 8-9: Topic-wise Test Series & Formula Handbook Revision',
          'Months 10-11: Full-length Mock Tests & Speed/Accuracy Calibration',
          'Month 12: Final Formula & High-Yield Topic Revision'
        ],
        recommendedBooks: [
          'Discrete Mathematics and Its Applications by Kenneth H. Rosen',
          'Introduction to Algorithms (CLRS) by Cormen, Leiserson, Rivest, Stein',
          'Operating System Concepts by Silberschatz, Galvin, Gagne',
          'Database System Concepts by Korth, Silberchatz, Sudarshan',
          'Computer Networking: A Top-Down Approach by Kurose & Ross',
          'Computer Organization and Architecture by William Stallings',
          'Theory of Computation by Michael Sipser'
        ],
        youtubeChannels: [
          'NPTEL Official IIT Computer Science Lectures',
          'Gate Smashers (Varun Singla)',
          'Unacademy Computer Science',
          'Knowledge Gate (Sanchit Jain)',
          'GeeksforGeeks GATE CS'
        ],
        officialWebsites: [
          'https://gate2027.iitk.ac.in',
          'https://gate.iisc.ac.in',
          'https://coap.iitk.ac.in',
          'https://ccmt.admissions.nic.in',
          'https://nptel.ac.in',
          'https://swayam.gov.in'
        ],
        latestNotifications: [
          ExamNotificationItem(title: 'GATE CSE 2027 Official Information Brochure Released', date: 'August 2026', url: 'https://gate2027.iitk.ac.in'),
          ExamNotificationItem(title: 'GOAPS Online Application Portal Opening', date: 'September 2026', url: 'https://gate2027.iitk.ac.in'),
          ExamNotificationItem(title: 'GATE 2027 Application Deadline without Late Fee', date: 'October 2026', url: 'https://gate2027.iitk.ac.in'),
          ExamNotificationItem(title: 'Admit Card Download Portal Opening', date: 'January 2027', url: 'https://gate2027.iitk.ac.in'),
          ExamNotificationItem(title: 'GATE CSE 2027 Examination Dates', date: 'February 2027', url: 'https://gate2027.iitk.ac.in'),
          ExamNotificationItem(title: 'GATE 2027 Official Results & Scorecard Announcement', date: 'March 2027', url: 'https://gate2027.iitk.ac.in'),
        ],
        faqs: [
          ExamFaqItem(question: 'How long is the GATE 2027 score valid?', answer: 'GATE 2027 scorecards are valid for 3 full years from the date of official result declaration for M.Tech admissions.'),
          ExamFaqItem(question: 'Which PSUs recruit directly through GATE CSE 2027?', answer: 'DRDO (RAC), ISRO (ICRB), BARC (OCES), PowerGrid (PGCIL), NTPC, IOCL, GAIL, POSOCO, BIS, and CDAC recruit CSSE engineers directly based on GATE CSE marks.'),
          ExamFaqItem(question: 'What is the difference between COAP and CCMT counselling?', answer: 'COAP (Common Offer Acceptance Portal) handles M.Tech seat allotment for IITs & IISc. CCMT (Centralized Counselling) manages admissions for NITs, IIITs, and CFTIs.'),
          ExamFaqItem(question: 'Is there any negative marking in MSQs or NATs?', answer: 'No! MSQ (Multiple Select) and NAT (Numerical Answer Type) questions have ZERO negative marking. Negative marking applies only to MCQs.'),
          ExamFaqItem(question: 'Are 3rd-year CSSE engineering students eligible for GATE 2027?', answer: 'Yes! Pre-final year (3rd year) students enrolled in B.E./B.Tech CSSE programs are fully eligible to write GATE 2027.'),
        ],
        salaryRange: '₹12 LPA - ₹24 LPA in PSUs | ₹1.44 Lakhs/yr Stipend in M.Tech (MHRD Scholarship)',
        careerOpportunities: 'Direct PSU Scientist/Engineer, M.Tech in IITs/IISc, Research Fellowship (JRF/PMRF), Foreign Universities (NTU Singapore, TUM Germany).',
        topInstitutes: ['IISc Bangalore', 'IIT Bombay', 'IIT Delhi', 'IIT Madras', 'IIT Kharagpur', 'IIT Kanpur', 'IIT Roorkee', 'IIT Guwahati'],
        scholarships: ['MHRD GATE Monthly Stipend (₹12,400/month)', 'Prime Minister’s Research Fellowship (PMRF)'],
        applicationProcess: '1. Register on GOAPS Portal (gate2027.iitk.ac.in)\n2. Fill online application form with CSSE details\n3. Upload photo, signature & category certificate\n4. Pay application fee online',
        successStrategy: 'Dedicate 70% of study time to solving 25 years of GATE CSE PYQs. Maintain a formula & key concepts handbook for last 30 days revision.',
      ),

      HigherEducationModel(
        id: 'cat_exam',
        title: 'CAT (Common Admission Test)',
        category: 'Higher Studies',
        subtitle: 'MBA Admission in IIMs, FMS, XLRI & Premier B-Schools',
        overview: 'CAT is the premier computer-based management entrance exam conducted annually by Indian Institutes of Management (IIMs) for admission to postgraduate business programs.',
        eligibilityCriteria: 'Bachelor’s degree with at least 50% marks or equivalent CGPA (45% for SC/ST/PwD). Final year students are eligible.',
        whoShouldApply: 'Engineers & graduates seeking executive leadership roles, management consulting, product management, or investment banking careers.',
        examPattern: 'Computer Based Test (CBT), 120 Minutes, 3 Sections: VARC (24 Qs), DILR (20 Qs), QA (22 Qs).',
        syllabusTopics: [
          'Verbal Ability & Reading Comprehension (VARC)',
          'Data Interpretation & Logical Reasoning (DILR)',
          'Quantitative Ability (Arithmetic, Algebra, Geometry, Modern Math)'
        ],
        preparationTimeline: [
          'Months 1-3: Fundamentals & Sectional Concepts',
          'Months 4-6: Advanced Problem Sets & Speed Drills',
          'Months 7-8: Sectional Mocks & 30+ Full Length Mocks'
        ],
        recommendedBooks: [
          'How to Prepare for Quantitative Aptitude by Arun Sharma',
          'Word Power Made Easy by Norman Lewis',
          'Logical Reasoning for CAT by Nishit K. Sinha'
        ],
        youtubeChannels: [
          'iQuanta CAT Preparation',
          '2iim CAT Preparation',
          'Rodha (Ravi Prakash)'
        ],
        officialWebsites: [
          'https://iimcat.ac.in'
        ],
        latestNotifications: [
          ExamNotificationItem(title: 'CAT Official Registration Announcement', date: 'August 2026', url: 'https://iimcat.ac.in'),
        ],
        faqs: [
          ExamFaqItem(question: 'Can engineers crack CAT without coaching?', answer: 'Yes! Over 65% of top IIM converts are engineers who self-study using mocks and online resources.'),
        ],
        salaryRange: '₹22 LPA - ₹45 LPA (Average IIM A/B/C Placements)',
        careerOpportunities: 'Management Consultant (McKinsey, BCG, Bain), Product Manager, Investment Banker, Brand Manager.',
        topInstitutes: ['IIM Ahmedabad', 'IIM Bangalore', 'IIM Calcutta', 'FMS Delhi', 'XLRI Jamshedpur', 'SPJIMR Mumbai'],
        scholarships: ['IIM Need-Based Financial Assistance', 'Central Sector Scholarship Scheme'],
        applicationProcess: '1. Register at iimcat.ac.in\n2. Select IIM interview choices\n3. Pay registration fee\n4. Download admit card in October',
        successStrategy: 'Consistent reading of international editorials (Aeon, Economist) and taking at least 25 proctored mock tests with detailed analysis.',
      ),

      HigherEducationModel(
        id: 'gre_exam',
        title: 'GRE (Graduate Record Examination)',
        category: 'Higher Studies',
        subtitle: 'MS / Ph.D. / MBA Admissions in USA, Europe & Worldwide',
        overview: 'GRE General Test is accepted by thousands of graduate and business schools worldwide for Master’s, MBA, Specialized Master’s, and Doctoral degrees.',
        eligibilityCriteria: 'No specific age or qualification restrictions; valid passport is required.',
        whoShouldApply: 'Students planning for Master’s (MS in Computer Science, Data Science, AI) or MBA in USA, Canada, Germany, UK & Australia.',
        examPattern: 'Adaptive Computer Test, 1 Hour 58 Minutes. Analytical Writing (1 Essay), Verbal Reasoning (27 Qs), Quantitative Reasoning (27 Qs). Score range: 260-340.',
        syllabusTopics: [
          'Analytical Writing: Analyze an Issue Task',
          'Verbal Reasoning: Text Completion, Sentence Equivalence, Reading Comprehension',
          'Quantitative Reasoning: Arithmetic, Algebra, Geometry, Data Analysis'
        ],
        preparationTimeline: [
          'Month 1: Vocabulary Building & Quant Concepts',
          'Month 2: Practice Questions & ETS Official Guide',
          'Month 3: Full Length Official ETS Practice Tests'
        ],
        recommendedBooks: [
          'The Official Guide to the GRE General Test by ETS',
          'Manhattan Prep 5 lb. Book of GRE Practice Problems',
          'Word Power Made Easy by Norman Lewis'
        ],
        youtubeChannels: [
          'GregMat (Official Strategies)',
          'Magoosh GRE',
          'Galvanize Test Prep'
        ],
        officialWebsites: [
          'https://www.ets.org/gre'
        ],
        latestNotifications: [
          ExamNotificationItem(title: 'GRE Shorter Test Pattern Live Worldwide', date: 'Active', url: 'https://www.ets.org/gre'),
        ],
        faqs: [
          ExamFaqItem(question: 'How long is the GRE score valid?', answer: 'GRE score is valid for 5 years from the test date.'),
        ],
        salaryRange: '\$85,000 - \$160,000 / year (Average US MS in CS starting salary)',
        careerOpportunities: 'Software Engineer, Data Scientist, Machine Learning Engineer, AI Researcher in USA/Europe.',
        topInstitutes: ['MIT', 'Stanford University', 'Carnegie Mellon University', 'UC Berkeley', 'TUM Germany', 'ETH Zurich'],
        scholarships: ['Fulbright-Nehru Master’s Fellowships', 'Erasmus Mundus Joint Master Degrees', 'DAAD Scholarships Germany'],
        applicationProcess: '1. Create ETS Account\n2. Schedule test date at home or test center\n3. Send scores to 4 free universities',
        successStrategy: 'Master 1,000 high-frequency GRE vocabulary words and achieve 165+ in Quant with error log tracking.',
      ),

      HigherEducationModel(
        id: 'gmat_exam',
        title: 'GMAT Focus Edition',
        category: 'Higher Studies',
        subtitle: 'Global MBA & Master in Management (MiM) Admissions',
        overview: 'GMAT Focus Edition is the premier management assessment test tailored for business school candidates seeking MBA or MiM degrees worldwide.',
        eligibilityCriteria: 'Any candidate aged 18+ with a valid passport.',
        whoShouldApply: 'Professionals & top graduates aiming for Harvard, Stanford, INSEAD, LBS, and top global MBA programs.',
        examPattern: 'Computer Adaptive Test, 2 Hours 15 Minutes. 3 Sections: Quantitative Reasoning, Verbal Reasoning, Data Insights. Score Range: 205-805.',
        syllabusTopics: [
          'Quantitative Reasoning: Problem Solving (Algebra, Arithmetic)',
          'Verbal Reasoning: Reading Comprehension, Critical Reasoning',
          'Data Insights: Data Sufficiency, Multi-Source Reasoning, Table Analysis, Graphics Interpretation'
        ],
        preparationTimeline: [
          'Months 1-2: Core Concepts & Practice Sets',
          'Month 3: Official GMAT Prep Practice Mocks'
        ],
        recommendedBooks: [
          'GMAT Official Guide Focus Edition',
          'Manhattan Prep GMAT Guides'
        ],
        youtubeChannels: [
          'GMAT Club Official',
          'e-GMAT',
          'Target Test Prep'
        ],
        officialWebsites: [
          'https://www.mba.com'
        ],
        latestNotifications: [
          ExamNotificationItem(title: 'GMAT Focus Edition Official Testing Live', date: 'Active', url: 'https://www.mba.com'),
        ],
        faqs: [
          ExamFaqItem(question: 'What is a competitive GMAT Focus score?', answer: 'A score of 655+ corresponds to the 90th percentile and is competitive for top 20 B-schools.'),
        ],
        salaryRange: '\$140,000 - \$210,000 / year (Global Top MBA Placements)',
        careerOpportunities: 'Strategy Consultant, Investment Banker, VP of Product, Chief of Staff.',
        topInstitutes: ['Harvard Business School', 'Stanford GSB', 'INSEAD France/Singapore', 'London Business School', 'Wharton'],
        scholarships: ['Forté Foundation Fellowships', 'Rotary Peace Fellowships', 'Dean’s Excellence Scholarships'],
        applicationProcess: '1. Register at mba.com\n2. Select test date\n3. Report scores directly to selected B-schools',
        successStrategy: 'Emphasize Data Insights & Critical Reasoning accuracy using official GMAC question banks.',
      ),

      HigherEducationModel(
        id: 'ielts_exam',
        title: 'IELTS Academic',
        category: 'Higher Studies',
        subtitle: 'English Proficiency Exam for Higher Education in UK, Canada, Australia & USA',
        overview: 'IELTS Academic tests English proficiency for higher education admissions and professional registration worldwide.',
        eligibilityCriteria: 'Open to anyone seeking study or work abroad; valid passport mandatory.',
        whoShouldApply: 'Students applying for foreign universities in UK, Canada, Australia, Ireland, New Zealand, and USA.',
        examPattern: 'Paper-based or Computer-delivered, 2 Hours 45 Minutes. 4 Sections: Listening (30 min), Reading (60 min), Writing (60 min), Speaking (11-14 min). Band Score: 1-9.',
        syllabusTopics: [
          'Listening: 4 Audio Recordings & 40 Questions',
          'Academic Reading: 3 Long Texts & 40 Questions',
          'Academic Writing: Task 1 (Graph/Chart Report) & Task 2 (Essay)',
          'Speaking: Face-to-Face Interview (Part 1, Part 2 Cue Card, Part 3 Discussion)'
        ],
        preparationTimeline: [
          'Week 1-2: Format Familiarization & Listening/Reading Practice',
          'Week 3-4: Writing Task Structure & Speaking Mock Interviews'
        ],
        recommendedBooks: [
          'The Official Cambridge Guide to IELTS',
          'Barron’s IELTS Superpack'
        ],
        youtubeChannels: [
          'IELTS Liz',
          'E2 IELTS (Jay)',
          'IELTS Advantage (Chris Pell)'
        ],
        officialWebsites: [
          'https://www.ielts.org',
          'https://www.idp.com'
        ],
        latestNotifications: [
          ExamNotificationItem(title: 'IELTS One Skill Retake Available Nationwide', date: 'Active', url: 'https://www.ielts.org'),
        ],
        faqs: [
          ExamFaqItem(question: 'What is a good IELTS Academic score?', answer: 'An overall band score of 7.5+ with no band less than 7.0 is accepted by almost all top universities globally.'),
        ],
        salaryRange: 'Unlocks study visas, teaching assistantships & global employment eligibility.',
        careerOpportunities: 'Direct admission into MS/Ph.D./MBA programs globally.',
        topInstitutes: ['University of Oxford', 'University of Cambridge', 'University of Toronto', 'University of Melbourne'],
        scholarships: ['Commonwealth Scholarships', 'Chevening Scholarships UK', 'Australia Awards'],
        applicationProcess: '1. Register on IDP IELTS website\n2. Select computer or paper test mode\n3. Attend test center with original passport',
        successStrategy: 'Practice Cambridge IELTS Official Test Books 11 to 18 under strict exam timed conditions.',
      ),

      HigherEducationModel(
        id: 'toefl_exam',
        title: 'TOEFL iBT',
        category: 'Higher Studies',
        subtitle: 'Internet-Based English Test for Admissions in USA & 160+ Countries',
        overview: 'TOEFL iBT measures your ability to use and understand English at the university level with 100% academic task integration.',
        eligibilityCriteria: 'Open to all candidates with a valid passport.',
        whoShouldApply: 'Students targeting US, Canadian, and European universities accepting TOEFL.',
        examPattern: 'Computer Test, 1 Hour 56 Minutes. Reading (20 Qs), Listening (28 Qs), Speaking (4 Tasks), Writing (2 Tasks). Score range: 0-120.',
        syllabusTopics: [
          'Reading: University Textbook Passages & Comprehension',
          'Listening: Campus Lectures & Conversations',
          'Speaking: Expressing Opinion & Summarizing Integrated Material',
          'Writing: Integrated Writing Task & Academic Discussion Essay'
        ],
        preparationTimeline: [
          'Weeks 1-3: Skill Building & Integrated Speaking Drills',
          'Week 4: ETS Official TOEFL iBT Mocks'
        ],
        recommendedBooks: [
          'The Official Guide to the TOEFL iBT Test by ETS',
          'Official TOEFL iBT Tests Volume 1 & 2'
        ],
        youtubeChannels: [
          'TST Prep (Josh MacPherson)',
          'Notefull TOEFL Performance'
        ],
        officialWebsites: [
          'https://www.ets.org/toefl'
        ],
        latestNotifications: [
          ExamNotificationItem(title: 'New Shorter 2-Hour TOEFL iBT Live', date: 'Active', url: 'https://www.ets.org/toefl'),
        ],
        faqs: [
          ExamFaqItem(question: 'Is TOEFL accepted in UK and Canada?', answer: 'Yes! 100% of UK universities and top Canadian universities accept TOEFL iBT scores.'),
        ],
        salaryRange: 'Unlocks US Assistantships, Fellowships & University Admissions.',
        careerOpportunities: 'Global Higher Education & Foreign Research Fellowships.',
        topInstitutes: ['Harvard', 'MIT', 'Stanford', 'Columbia University', 'Cornell University'],
        scholarships: ['Fulbright Fellowships', 'University Graduate Assistantships'],
        applicationProcess: '1. Create ETS TOEFL Account\n2. Schedule test date at center or home edition\n3. Send scores directly to universities',
        successStrategy: 'Use TST Prep templates for Speaking & Writing integrated tasks for maximum consistency.',
      ),

      // --- SECTION 2: GOVERNMENT & PUBLIC SECTOR ---
      HigherEducationModel(
        id: 'upsc_cse',
        title: 'UPSC Civil Services Examination',
        category: 'Government & Public Sector',
        subtitle: 'IAS, IPS, IFS, IRS & Central Group A Engineering Services',
        overview: 'The Civil Services Examination (CSE) conducted by Union Public Service Commission (UPSC) is India’s premier competitive exam for recruitment to prestigious administrative and police services.',
        eligibilityCriteria: 'Graduate degree in any discipline from a recognized university. Age limit: 21-32 years (Relaxation for OBC/SC/ST).',
        whoShouldApply: 'Engineers & graduates seeking nation-building leadership roles, district administration, foreign service, and public policy policymaking.',
        examPattern: 'Three-Stage Examination: 1. Prelims (GS-1 & CSAT) 2. Mains (9 Written Papers) 3. Personality Test (Interview).',
        syllabusTopics: [
          'Prelims GS-1: History, Polity, Geography, Economy, Environment, Science & Tech, Current Affairs',
          'Prelims GS-2 (CSAT): Quantitative Aptitude, Logical Reasoning, Reading Comprehension',
          'Mains Papers: Essay, GS-1, GS-2, GS-3, GS-4 (Ethics), Optional Subject (Paper 1 & 2)'
        ],
        preparationTimeline: [
          'Months 1-6: NCERT Foundations & Standard Reference Books',
          'Months 7-10: Optional Subject Completion & Mains Answer Writing',
          'Months 11-12: Prelims Test Series & Intensive Current Affairs Revision'
        ],
        recommendedBooks: [
          'Indian Polity by M. Laxmikanth',
          'Indian Economy by Ramesh Singh',
          'A Brief History of Modern India by Spectrum',
          'Certificate Physical and Human Geography by GC Leong'
        ],
        youtubeChannels: [
          'Unacademy UPSC',
          'Drishti IAS',
          'Visions IAS Answer Writing',
          'StudyIQ IAS'
        ],
        officialWebsites: [
          'https://upsc.gov.in'
        ],
        latestNotifications: [
          ExamNotificationItem(title: 'UPSC CSE Official Notification Released', date: 'February 2026', url: 'https://upsc.gov.in'),
        ],
        faqs: [
          ExamFaqItem(question: 'Can CSSE engineering students clear UPSC?', answer: 'Yes! Engineering graduates make up over 60% of final UPSC Civil Services converts every year.'),
        ],
        salaryRange: '₹56,100 - ₹2,500,000 / month (Pay Level 10 + Government Quarters, Security, Car & Benefits)',
        careerOpportunities: 'District Collector (IAS), Superintendent of Police (IPS), Ambassador (IFS), Commissioner of IT (IRS).',
        topInstitutes: ['LBSNAA Mussoorie (IAS Training)', 'SVPNPA Hyderabad (IPS Training)', 'Sushma Swaraj Institute (IFS Training)'],
        scholarships: ['State Civil Services Coaching Stipends'],
        applicationProcess: '1. Register at upsc.gov.in\n2. Fill OTR (One Time Registration)\n3. Submit CSE Prelims Form online',
        successStrategy: 'Daily newspaper analysis (The Hindu / Indian Express) combined with weekly Mains answer writing practice.',
      ),

      HigherEducationModel(
        id: 'ssc_cgl',
        title: 'SSC CGL (Combined Graduate Level)',
        category: 'Government & Public Sector',
        subtitle: 'Assistant Section Officer (ASO), Inspector & Central Officer Jobs',
        overview: 'SSC CGL is conducted by the Staff Selection Commission for recruitment to Group B and Group C non-technical posts in top Ministries and Departments of Government of India.',
        eligibilityCriteria: 'Bachelor’s degree from a recognized university. Age limit: 18-32 years.',
        whoShouldApply: 'Graduates desiring central government administrative posts with job security, regular hours, and central pay perks.',
        examPattern: 'Tier 1 (CBT - Qualifying) + Tier 2 (CBT - Scoring). Sectional subjects: Math, Reasoning, English, General Awareness, Computer Knowledge.',
        syllabusTopics: [
          'Quantitative Aptitude: Arithmetic & Advanced Mathematics',
          'Reasoning: Verbal & Non-Verbal Logic',
          'English Language: Grammar, Comprehension, Vocabulary',
          'General Awareness: History, Polity, Geography, Economics, Science',
          'Computer Knowledge Module'
        ],
        preparationTimeline: [
          'Months 1-3: Concepts & Shortcuts in Quant/Reasoning',
          'Months 4-5: Speed Building & Mocks',
          'Month 6: Tier 2 Advanced Drills'
        ],
        recommendedBooks: [
          'Quantitative Aptitude for Competitive Examinations by R.S. Aggarwal',
          'Objective General English by S.P. Bakshi',
          'Lucent’s General Knowledge'
        ],
        youtubeChannels: [
          'RBG Revolution by Abhinay Sharma',
          'Aditya Ranjan Talks (Rankers Gurukul)',
          'Gagan Pratap Maths'
        ],
        officialWebsites: [
          'https://ssc.gov.in'
        ],
        latestNotifications: [
          ExamNotificationItem(title: 'SSC CGL Official Notification Announcement', date: 'June 2026', url: 'https://ssc.gov.in'),
        ],
        faqs: [
          ExamFaqItem(question: 'Is SSC CGL an easy exam for engineers?', answer: 'Engineers generally excel in Tier 2 Mathematics and Computer modules due to high quantitative aptitude skills.'),
        ],
        salaryRange: '₹44,900 - ₹1,42,400 (Pay Level 7 + HRA, DA & Central Allowances)',
        careerOpportunities: 'Assistant Section Officer (Central Secretariat Service, MEA), Inspector of Income Tax, Excise Inspector, CAG Auditor.',
        topInstitutes: ['ISTM Delhi (ASO Training)', 'National Academy of Direct Taxes'],
        scholarships: ['Government Coaching Subsidies'],
        applicationProcess: '1. Register on ssc.gov.in\n2. Fill online application form\n3. Select exam centers\n4. Pay application fee',
        successStrategy: 'Master advanced math formulas and take 50+ timed full-length online mocks.',
      ),

      HigherEducationModel(
        id: 'banking_ibps',
        title: 'IBPS PO & SBI PO (Banking Officers)',
        category: 'Government & Public Sector',
        subtitle: 'Probationary Officer in State Bank of India & Nationalized Banks',
        overview: 'IBPS PO and SBI PO exams select Probationary Officers for Public Sector Banks across India offering rapid promotion tracks and competitive banking remuneration.',
        eligibilityCriteria: 'Bachelor’s degree in any discipline. Age limit: 20-30 years.',
        whoShouldApply: 'Graduates looking for fast-paced financial management, credit risk evaluation, and branch banking leadership careers.',
        examPattern: '3 Stages: 1. Prelims (100 Marks, 1 Hour) 2. Mains (200 Marks + Essay/Letter Writing) 3. Group Discussion & Interview.',
        syllabusTopics: [
          'Quantitative Aptitude & Data Interpretation',
          'Reasoning Ability & Computer Aptitude',
          'English Language & Professional Writing',
          'General, Economy & Banking Awareness'
        ],
        preparationTimeline: [
          'Months 1-2: High Level Data Interpretation & Puzzles',
          'Months 3-4: Sectional Speed Tests & Financial Awareness Drills'
        ],
        recommendedBooks: [
          'Data Interpretation & Data Sufficiency by Ananta Ashisha',
          'Ace Reasoning by Adda247',
          'Banking Awareness by Arihant'
        ],
        youtubeChannels: [
          'Adda247 Banking',
          'Unacademy Banker10',
          'Meritshine'
        ],
        officialWebsites: [
          'https://www.ibps.in',
          'https://sbi.co.in/web/careers'
        ],
        latestNotifications: [
          ExamNotificationItem(title: 'IBPS PO Official Notification Released', date: 'August 2026', url: 'https://www.ibps.in'),
        ],
        faqs: [
          ExamFaqItem(question: 'What is the salary of SBI PO?', answer: 'SBI PO receives a starting gross salary of approx. ₹65,000+ per month along with leased accommodation benefits.'),
        ],
        salaryRange: '₹52,000 - ₹75,000 / month (SBI PO Starting Salary + Leased Accommodation)',
        careerOpportunities: 'Probationary Officer ➔ Manager ➔ Assistant General Manager ➔ Chief General Manager ➔ Executive Director.',
        topInstitutes: ['State Bank Academy Gurgaon', 'IBPS Training Centers'],
        scholarships: ['Bank Sponsored Executive Development Programs'],
        applicationProcess: '1. Apply online at ibps.in or sbi.co.in\n2. Upload thumb impression & handwritten declaration\n3. Complete online payment',
        successStrategy: 'Daily practice of complex seating arrangement puzzles and high-level Data Interpretation sets.',
      ),

      HigherEducationModel(
        id: 'rrb_ntpc',
        title: 'RRB NTPC & JE (Indian Railways)',
        category: 'Government & Public Sector',
        subtitle: 'Junior Engineer & Non-Technical Popular Categories in Indian Railways',
        overview: 'Railway Recruitment Board (RRB) conducts national exams for technical Junior Engineer (JE) posts and Non-Technical Popular Categories (NTPC) across Indian Railways zones.',
        eligibilityCriteria: 'Diploma/Degree in Engineering for RRB JE; Graduation for RRB NTPC. Age limit: 18-33 years.',
        whoShouldApply: 'Engineers & graduates seeking railway infrastructure management, locomotive operations, and public transport administration.',
        examPattern: 'CBT 1 (Screening) + CBT 2 (Technical/Specialized) + Document Verification & Medical Test.',
        syllabusTopics: [
          'General Awareness & Current Affairs',
          'Mathematics & Quantitative Aptitude',
          'General Intelligence & Reasoning',
          'Technical Abilities (Civil, Electrical, Mechanical, CS/IT for RRB JE)'
        ],
        preparationTimeline: [
          'Months 1-3: Non-Tech Subjects & Tech Basics',
          'Months 4-5: CBT 2 Technical Branch Preparation'
        ],
        recommendedBooks: [
          'RRB JE Computer Science & IT Handbook by Made Easy',
          'Fast Track Objective Arithmetic by Rajesh Verma'
        ],
        youtubeChannels: [
          'Wifistudy (Unacademy)',
          'Testbook Railway Prep'
        ],
        officialWebsites: [
          'https://indianrailways.gov.in'
        ],
        latestNotifications: [
          ExamNotificationItem(title: 'RRB JE Centralized Employment Notice', date: 'Active Zone Releases', url: 'https://indianrailways.gov.in'),
        ],
        faqs: [
          ExamFaqItem(question: 'Does RRB JE recruit Computer Science engineers?', answer: 'Yes! RRB JE (IT) recruits CS/IT engineering graduates for railway IT system operations.'),
        ],
        salaryRange: '₹35,400 - ₹1,12,400 (Pay Level 6 + Railway Passes, Medical & Quarters)',
        careerOpportunities: 'Junior Engineer (IT/Civil/Electrical), Station Master, Commercial Apprentice, Senior Clerk.',
        topInstitutes: ['Indian Railways Institute of Signal Engineering and Telecommunications (IRISET)'],
        scholarships: ['Railway Employees Welfare Educational Assistance'],
        applicationProcess: '1. Select regional RRB portal (e.g. RRB Secunderabad / Mumbai)\n2. Fill online application & uploaded photo\n3. Select preferred post preferences',
        successStrategy: 'Focus on Science & Tech NCERT fundamentals for CBT 1 and branch-specific engineering papers for CBT 2.',
      ),

      HigherEducationModel(
        id: 'psu_recruitment',
        title: 'PSU Recruitment via GATE / Direct Exam',
        category: 'Government & Public Sector',
        subtitle: 'Executive Engineer in IOCL, NTPC, ONGC, BHEL, ISRO, BARC & HPCL',
        overview: 'Public Sector Undertakings (PSUs) are Maharatna & Navratna government corporations recruiting top engineering graduates as Assistant Executive Engineers and Scientists.',
        eligibilityCriteria: 'B.E. / B.Tech degree with minimum 65% aggregate (or valid GATE score).',
        whoShouldApply: 'Engineers who desire high salary packages, core technical work, job security, and executive government status.',
        examPattern: 'GATE Score Shortlisting ➔ Group Discussion (GD) / Group Task (GT) ➔ Personal Interview (PI) or Direct PSU CBT Exam (ISRO/BARC).',
        syllabusTopics: [
          'Core CSSE Subjects (Algorithms, OS, DBMS, Networks, Data Structures, Software Engineering)',
          'General Aptitude & Reasoning',
          'Technical Personal Interview Topics'
        ],
        preparationTimeline: [
          'Months 1-6: GATE Exam Preparation',
          'Months 7-8: PSU Interview Prep & Core Project Revisions'
        ],
        recommendedBooks: [
          'GATE CSSE Previous Years Solved Papers by Made Easy',
          'Core Computer Science Subject Handbooks'
        ],
        youtubeChannels: [
          'Gate Smashers Interview Guidance',
          'Made Easy Official'
        ],
        officialWebsites: [
          'https://iocl.com',
          'https://ntpc.co.in',
          'https://isro.gov.in',
          'https://barc.gov.in'
        ],
        latestNotifications: [
          ExamNotificationItem(title: 'IOCL Engineer Recruitment via GATE Notification', date: 'Active', url: 'https://iocl.com'),
          ExamNotificationItem(title: 'NTPC Executive Trainee Application Live', date: 'Active', url: 'https://ntpc.co.in'),
        ],
        faqs: [
          ExamFaqItem(question: 'Which PSUs recruit Computer Science graduates?', answer: 'NTPC, IOCL, PowerGrid, ONGC, POSOCO, BEL, BARC, and ISRO actively recruit CS/IT engineers.'),
        ],
        salaryRange: '₹14 LPA - ₹24 LPA (Cost to Company including Performance Pay, Housing & Medical)',
        careerOpportunities: 'Executive Engineer, Scientist B (ISRO/BARC), Technical Manager, Project Lead.',
        topInstitutes: ['ISRO Satellite Centre', 'Bhabha Atomic Research Centre (BARC)', 'IOCL R&D Centre'],
        scholarships: ['PSU Executive Higher Education Sponsorship'],
        applicationProcess: '1. Register for GATE exam\n2. Apply individually on target PSU career portal using GATE Registration Number\n3. Attend GD/PI upon shortlisting',
        successStrategy: 'Achieve a GATE rank under 500 in CSSE stream and prepare final year B.Tech thesis project thoroughly for personal interviews.',
      ),
    ];
  }
}

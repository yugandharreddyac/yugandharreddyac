import '../datasources/firebase_datasource.dart';
import '../models/higher_education_model.dart';

class HigherEducationRepository {
  final FirebaseDataSource _firebaseDataSource;

  HigherEducationRepository({required FirebaseDataSource firebaseDataSource})
      : _firebaseDataSource = firebaseDataSource;

  Future<List<HigherEducationModel>> getHigherEducationResources() async {
    try {
      final remoteData = await _firebaseDataSource.getHigherEducationResources();
      if (remoteData.isNotEmpty) {
        return remoteData.map((e) => HigherEducationModel.fromJson(e)).toList();
      }
    } catch (_) {}

    return _fallbackHigherEducationResources;
  }

  static List<HigherEducationModel> get fallbackHigherEducationResources => _fallbackHigherEducationResources;

  static const List<HigherEducationModel> _fallbackHigherEducationResources = [
    // --- STAGE 1: GATE EXAM & M.TECH IN INDIA ---
    HigherEducationModel(
      id: 'gate_cse',
      title: 'GATE CSE (Graduate Aptitude Test in Engineering)',
      category: 'Higher Studies',
      subtitle: 'Gateway to M.Tech / Direct Ph.D. in IITs/IISc & Public Sector PSU Recruitment',
      overview: 'GATE CSE is India’s premier national engineering examination conducted jointly by Indian Institutes of Technology (IITs) and IISc Bangalore. It tests core Computer Science undergraduate fundamentals for admission to M.Tech/Ph.D. programs and recruitment at PSUs like ISRO, DRDO, and BARC.',
      eligibilityCriteria: 'B.Tech / B.E. in CS/IT or 3rd & 4th year undergraduate engineering students. No upper age limit.',
      whoShouldApply: 'Students seeking M.Tech/Ph.D. in top IITs/IISc with MHRD stipend (₹12,400/month), or R&D jobs in top tech institutions.',
      examPattern: 'Computer-Based Test (3 Hours, 65 Questions, 100 Marks). Question Types: Multiple Choice Questions (MCQ), Multiple Select Questions (MSQ), and Numerical Answer Type (NAT). Negative marking (1/3rd) applies ONLY to MCQs.',
      syllabusTopics: [
        'Data Structures & Algorithms (15-18 Marks)',
        'Operating Systems (8-10 Marks)',
        'Database Management Systems (8-10 Marks)',
        'Computer Networks (7-9 Marks)',
        'Theory of Computation & Compiler Design (10-12 Marks)',
        'Computer Organization & Architecture (8-10 Marks)',
        'Digital Logic & Discrete Mathematics (12-15 Marks)',
        'General Aptitude & Engineering Math (15 Marks)'
      ],
      preparationTimeline: [
        '1st Year: Build strong Discrete Math, C Programming, and Data Structures foundations',
        '2nd Year: Master OS, DBMS, Computer Networks, Algorithms & start PYQs',
        '3rd Year: Complete TOC, Compilers, COA & solve 15 years of GATE PYQs (Eligible for GATE exam!)',
        '4th Year: Full-length 3-hour Mock Tests, Virtual Calculator practice, and Revision'
      ],
      recommendedBooks: [
        'Introduction to Algorithms by Cormen, Leiserson, Rivest, Stein (CLRS)',
        'Operating System Concepts by Silberschatz, Galvin, Gagne',
        'Database System Concepts by Korth, Sudarshan',
        'Computer Networking: A Top-Down Approach by Kurose & Ross'
      ],
      youtubeChannels: [
        'Gate Smashers (Ravindrababu Ravula)',
        'Unacademy Computer Science',
        'NPTEL Computer Science Courses'
      ],
      officialWebsites: [
        'https://gate.iisc.ac.in',
        'https://coap.iitk.ac.in',
      ],
      latestNotifications: [
        ExamNotificationItem(
          title: 'Official GATE Examination Portal Open for Online Applications',
          date: 'September - October 2026',
          url: 'https://gate.iisc.ac.in',
        ),
      ],
      faqs: [
        ExamFaqItem(
          question: 'Is MSQ (Multiple Select Question) negative marking applicable in GATE?',
          answer: 'No, MSQ and NAT questions have ZERO negative marking. Only MCQs carry 1/3rd negative marking.',
        ),
        ExamFaqItem(
          question: 'Can 3rd year CSE students write GATE?',
          answer: 'Yes! Final year and 3rd year engineering undergraduates are fully eligible to write GATE.',
        ),
      ],
      salaryRange: 'M.Tech Stipend: ₹12,400/month | Post-M.Tech Package: ₹18 LPA - ₹45 LPA',
      careerOpportunities: 'Research Scientist, Senior Systems Engineer, Software Architect, PSU Officer.',
      topInstitutes: ['IISc Bangalore', 'IIT Bombay', 'IIT Delhi', 'IIT Madras', 'IIT Kanpur', 'IIT Kharagpur'],
      scholarships: ['MHRD GATE Monthly Stipend (₹12,400/month)', 'PMRF Prime Minister Research Fellowship'],
      applicationProcess: 'Apply online via official GATE GOAPS portal between September-October. Exam conducted in February.',
      successStrategy: 'Focus 70% of study time on solving 20-year PYQs on GATE Overflow. Master Multiple Select Questions (MSQ) and revision error logs.',
    ),

    HigherEducationModel(
      id: 'mtech_iit',
      title: 'M.Tech & Direct Ph.D. Admissions (IITs & IISc Bangalore)',
      category: 'Higher Studies',
      subtitle: 'Advanced Master of Technology & Research Degrees at India’s Top Technical Institutes',
      overview: 'Detailed guide for securing M.Tech seats in Computer Science, Artificial Intelligence, Cybersecurity, and Data Science across 23 IITs through GATE COAP counseling.',
      eligibilityCriteria: 'Valid GATE Score + B.Tech degree with minimum 60% / 6.5 CGPA (Relaxation for SC/ST).',
      whoShouldApply: 'Engineering graduates seeking high-paying product development roles, research fellowships, or academic faculty positions.',
      examPattern: 'Selection via GATE Score + Shortlisting Written Test / Interview for TA/RA seats.',
      syllabusTopics: [
        'GATE CS Core Syllabus',
        'Coding Round (C++ / Python Data Structures)',
        'Technical Interview on B.Tech Major Project'
      ],
      preparationTimeline: [
        'Post-GATE Feb: Prepare B.Tech major project presentation',
        'March: Register on COAP Portal',
        'April-May: Attend COAP Seat Acceptance Rounds'
      ],
      recommendedBooks: [
        'GATE CS Standard Reference Textbooks'
      ],
      youtubeChannels: [
        'IISc CSA Department Official Channel'
      ],
      officialWebsites: [
        'https://coap.iitk.ac.in',
        'https://ccmt.admissions.nic.in',
      ],
      salaryRange: 'Stipend: ₹12,400/mo (TA) / ₹31,000/mo (Ph.D.) | Campus Placements: ₹22 LPA - ₹55 LPA',
      careerOpportunities: 'AI Research Scientist, Systems Architect, Quantum Computing Researcher.',
      topInstitutes: ['IISc Bangalore', 'IIT Bombay', 'IIT Delhi', 'IIT Madras'],
      applicationProcess: 'Register on COAP for IITs and CCMT for NITs post GATE result declaration.',
      successStrategy: 'Accept best offer in early COAP rounds; keep B.Tech project presentation ready for interviews.',
    ),

    // --- STAGE 2: GRE & INTERNATIONAL MS ABROAD ---
    HigherEducationModel(
      id: 'gre_ms_abroad',
      title: 'GRE & MS in Computer Science Abroad (USA, Germany, Canada)',
      category: 'International Education',
      subtitle: 'Complete Beginner Guide for Pursuing Master of Science (MS in CS) in Global Top-100 Universities',
      overview: 'Comprehensive roadmap for applying to international MS in CS programs, including GRE General Test prep, TOEFL/IELTS language tests, Statement of Purpose (SOP) writing, and university shortlisting.',
      eligibilityCriteria: '4-Year B.Tech / B.E. degree with minimum 3.0/4.0 GPA equivalent + GRE Score + TOEFL/IELTS.',
      whoShouldApply: 'Students aiming for global career exposure, Silicon Valley tech jobs, or advanced research in USA, Germany, or Canada.',
      examPattern: 'GRE General Test (1 hour 58 Mins): Analytical Writing (1 Essay), Verbal Reasoning (130-170 scale), Quantitative Reasoning (130-170 scale). Target: 320+ total.',
      syllabusTopics: [
        'GRE Quantitative Reasoning (Arithmetic, Algebra, Geometry, Data Analysis)',
        'GRE Verbal Reasoning (Reading Comprehension, Text Completion, Sentence Equivalence)',
        'TOEFL / IELTS English Proficiency (Reading, Listening, Speaking, Writing)',
        'Statement of Purpose (SOP) & Letters of Recommendation (LORs)'
      ],
      preparationTimeline: [
        '12 Months Prior: GRE Prep & Quant Practice (Target 165+ Quant)',
        '9 Months Prior: TOEFL/IELTS Test + Finalize SOP & 3 LORs',
        '6 Months Prior: Submit Fall Semester Applications (Nov-Dec Deadlines)',
        '3 Months Prior: Receive Admission Letters & Apply for F-1 / Student Visa'
      ],
      recommendedBooks: [
        'Official GRE Super Power Pack by ETS',
        'Manhattan Prep 5 lb. Book of GRE Practice Problems',
        'Word Power Made Easy by Norman Lewis'
      ],
      youtubeChannels: [
        'GregMat (GRE Prep)',
        'Yocket Higher Education',
        'Stilt US Admissions Guide'
      ],
      officialWebsites: [
        'https://www.ets.org/gre.html',
        'https://www.ets.org/toefl.html',
      ],
      latestNotifications: [
        ExamNotificationItem(
          title: 'Fall Semester International Application Window Open',
          date: 'October - December 2026',
          url: 'https://www.ets.org/gre.html',
        ),
      ],
      faqs: [
        ExamFaqItem(
          question: 'Do US universities waive GRE requirements for MS in CS?',
          answer: 'Many US universities offer optional GRE waivers, but submitting a 320+ GRE score significantly boosts scholarship and TA/RA chances.',
        ),
      ],
      salaryRange: 'US MS CS Average Starting Salary: \$115,000 - \$160,000 / year (₹95 LPA - ₹1.3 Cr)',
      careerOpportunities: 'Software Development Engineer in Silicon Valley, Cloud Solutions Architect, Machine Learning Researcher.',
      topInstitutes: ['CMU', 'Stanford', 'UC Berkeley', 'MIT', 'UT Austin', 'TU Munich (Germany)'],
      scholarships: ['Graduate Teaching Assistantship (TA)', 'Research Assistantship (RA)', 'Fulbright Scholarship'],
      applicationProcess: 'Create ETS portal account -> Book GRE & TOEFL test slots -> Submit university online portals with SOP/LORs.',
      successStrategy: 'Highlight hands-on engineering projects and research publications in your SOP. Target 168+ in GRE Quant section.',
    ),

    // --- STAGE 3: SOP, LOR & DOCUMENTS ---
    HigherEducationModel(
      id: 'sop_lor_documents',
      title: 'Statement of Purpose (SOP) & LOR Mastery Guide',
      category: 'International Education',
      subtitle: 'Draft High-Impact Statements of Purpose and Letters of Recommendation',
      overview: 'Step-by-step masterclass explaining SOP (Statement of Purpose), LOR (Letters of Recommendation), Academic Transcripts, and Resume tailoring for MS/Ph.D. admissions.',
      eligibilityCriteria: 'Required for 100% of global master\'s applications in USA, Canada, Germany, and Europe.',
      whoShouldApply: 'All undergraduate students applying for higher studies abroad or premier Indian research programs.',
      examPattern: 'Document Evaluation by University Admissions Committee (AdCom).',
      syllabusTopics: [
        'SOP Hook & Academic Motivation Paragraph',
        'Technical Projects & Research Work Paragraphs',
        'Career Goals & Program Fit Paragraph',
        'Selecting 3 LOR Recommenders (2 Academic + 1 Project/Work)'
      ],
      preparationTimeline: [
        'Month 1: Brainstorm academic story and project achievements',
        'Month 2: Draft SOP V1 and request LORs from professors',
        'Month 3: Review SOP feedback with mentors and finalize PDF'
      ],
      recommendedBooks: [
        'Write Your Way Into Graduate School by Amy Bhahn',
        'Overleaf LaTeX SOP & Resume Templates'
      ],
      youtubeChannels: [
        'Jordan Peterson SOP Guide',
        'Yocket SOP Review Series'
      ],
      officialWebsites: [
        'https://www.shiksha.com/studyabroad/how-to-write-sop-statement-of-purpose-apply-page-254',
        'https://www.overleaf.com/',
      ],
      salaryRange: 'Unlocks entry to top 50 ranked global university programs',
      careerOpportunities: 'Admissions success at tier-1 international computer science departments.',
      topInstitutes: ['CMU', 'ETH Zurich', 'TU Munich', 'Georgia Tech'],
      scholarships: ['Tuition Waivers', 'Graduate Assistantships'],
      applicationProcess: 'Submit final PDF SOP and request professors to upload LORs directly via university applicant portals.',
      successStrategy: 'Customize the final paragraph of every SOP to mention specific university research labs and professors.',
    ),

    // --- STAGE 4: GOVERNMENT & PUBLIC SECTOR (PSUs) ---
    HigherEducationModel(
      id: 'isro_drdo_psu',
      title: 'ISRO & DRDO Scientist Recruitment (Computer Science)',
      category: 'Government & Public Sector',
      subtitle: 'Prestigious Scientist SC Recruitment in India’s National Space & Defense Research Labs',
      overview: 'Official guide for Computer Science graduates seeking Scientist / Engineer \'SC\' positions in ISRO (Indian Space Research Organisation) and DRDO (Defence Research and Development Organisation).',
      eligibilityCriteria: 'B.Tech/B.E. in CS/IT with First Class (Minimum 65% aggregate marks or CGPA 6.84/10). Age limit: 28-35 years.',
      whoShouldApply: 'Engineers passionate about space research, satellite communications, cyber defense systems, and high-security government careers.',
      examPattern: 'Written Test (80 Objective Technical Questions, 90 Minutes) + 1:5 Interview Shortlisting. Final selection based 100% on Interview performance.',
      syllabusTopics: [
        'CS Core: Data Structures, Algorithms, OS, DBMS, Computer Networks, Software Engineering',
        'Hardware: Computer Architecture, Microprocessors, Digital Logic',
        'Mathematics: Discrete Math, Linear Algebra, Probability & Statistics'
      ],
      preparationTimeline: [
        'Phase 1: Solve ISRO Scientist CS Previous Year Question Papers (2012-2025)',
        'Phase 2: Master Core CS Fundamentals & Speed Math Calculations',
        'Phase 3: Technical Interview Coaching on B.Tech Major Project'
      ],
      recommendedBooks: [
        'ISRO Computer Science Previous Years Solved Papers by MADE EASY',
        'GATE CS Standard Reference Books'
      ],
      youtubeChannels: [
        'ISRO Official Media Channel',
        'GATE Smashers ISRO Prep'
      ],
      officialWebsites: [
        'https://www.isro.gov.in/Careers.html',
        'https://www.drdo.gov.in/careers',
      ],
      salaryRange: '7th Pay Commission Level 10: Basic Pay ₹56,100 + DA + HRA (Total Starting Gross: ₹95,000/month) + Govt Benefits',
      careerOpportunities: 'Scientist SC, Mission Control Systems Engineer, Satellite Software Engineer, Cyber Defense Researcher.',
      topInstitutes: ['ISRO Satellite Centre (URSC Bengaluru)', 'VSSC Thiruvananthapuram', 'DRDO CAIR Bengaluru'],
      applicationProcess: 'Apply online via ISRO ICRB or DRDO RAC portals upon advertisement release.',
      successStrategy: 'Master speed accuracy on 80 technical questions in 90 minutes. Review core CS definitions thoroughly for the interview round.',
    ),
  ];
}


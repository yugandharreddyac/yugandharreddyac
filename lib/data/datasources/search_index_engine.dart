import 'package:flutter/foundation.dart';
import '../models/subject_model.dart';
import '../models/resource_model.dart';
import '../models/searchable_item.dart';
import '../models/global_search_result.dart';
import '../models/textbook_model.dart';
import '../models/career_model.dart';
import '../models/beyond_academics_model.dart';
import '../models/project_model.dart';
import '../models/placement_model.dart';
import '../models/higher_education_model.dart';
import '../models/hierarchy_node_model.dart';
import 'non_academic_data.dart';
import 'textbook_mock_data.dart';
import '../repositories/career_repository.dart';
import '../repositories/coding_repository.dart';
import '../repositories/project_repository.dart';
import '../repositories/placement_repository.dart';
import '../repositories/higher_education_repository.dart';
import '../repositories/emerging_tech_repository.dart';

/// High-performance Global Search Index Engine that pre-indexes all
/// subjects, course overviews, textbook chapters, sections, topics, resources, and PYQs.
class SearchIndexEngine {
  List<SearchableItem> _index = [];
  bool _isIndexed = false;

  bool get isIndexed => _isIndexed;
  int get itemCount => _index.length;

  /// Builds the search index from subjects, resources, and textbook content
  void buildIndex(
    List<SubjectModel> subjects,
    List<ResourceModel> resources, {
    Map<String, List<TextbookChapterModel>>? textbookChaptersMap,
    Map<String, CourseOverviewModel>? courseOverviewsMap,
    List<CareerModel>? careerTechs,
    List<CodingLanguageModel>? codingLangs,
    List<DsaTopicModel>? dsaTopics,
    List<IndustryProjectModel>? codingProjects,
    List<ProjectModel>? projects,
    List<PlacementModel>? placements,
    List<HigherEducationModel>? higherEdItems,
    List<EmergingTechDetailModel>? emergingTechs,
  }) {
    final List<SearchableItem> items = [];

    // 1. Index Subjects & their Course Overviews + Textbook Hierarchy
    for (final subj in subjects) {
      final syllabusMetadata = _getSyllabusMetadata(subj.subjectCode ?? subj.code, subj.name);
      final overview = courseOverviewsMap?[subj.id] ?? TextbookMockData.getCourseOverview(subj.id);
      final chapters = textbookChaptersMap?[subj.id] ?? TextbookMockData.getTextbookChapters(subj.id);

      // Index Subject Level
      items.add(
        SearchableItem(
          id: 'idx_subj_${subj.id}',
          category: 'Subject',
          title: subj.name,
          subtitle: '${subj.code} • ${subj.creditHours} Credits',
          subjectName: subj.name,
          subjectCode: subj.code,
          semester: subj.semesterId,
          year: subj.yearId,
          keywords: [
            subj.name,
            subj.code,
            ...syllabusMetadata['keywords'] as List<String>? ?? [],
            ...overview.prerequisites,
            ...overview.learningObjectives,
          ],
          syllabusTopics: syllabusMetadata['topics'] as List<String>? ?? [],
          unitTitles: syllabusMetadata['units'] as List<String>? ?? [],
          subject: subj,
        ),
      );

      // Index Course Overview
      items.add(
        SearchableItem(
          id: 'idx_overview_${subj.id}',
          category: 'Course Overview',
          title: '${subj.name} Overview & Syllabus',
          subtitle: '${subj.name} • Prerequisites & Learning Outcomes',
          subjectName: subj.name,
          subjectCode: subj.code,
          semester: subj.semesterId,
          year: subj.yearId,
          keywords: [
            'overview',
            'syllabus',
            'prerequisites',
            'learning outcomes',
            ...overview.learningOutcomes,
          ],
          subject: subj,
          sectionIndex: 0,
        ),
      );

      // Index 3 Standardized Subject Section Types
      final sectionTypes = [
        {'title': 'Syllabus', 'index': 0, 'kw': ['syllabus', 'curriculum', 'overview']},
        {'title': 'Notes & Lecture Material', 'index': 1, 'kw': ['notes', 'textbook', 'lecture notes', 'summary']},
        {'title': 'Previous Question Papers', 'index': 2, 'kw': ['previous papers', 'past papers', 'pyqs', 'exam papers']},
      ];


      for (final sec in sectionTypes) {
        final secTitle = sec['title'] as String;
        final secIdx = sec['index'] as int;
        final secKw = sec['kw'] as List<String>;

        items.add(
          SearchableItem(
            id: 'idx_sec_${subj.id}_$secIdx',
            category: secTitle,
            title: '${subj.name} $secTitle',
            subtitle: '${subj.name} • Academic Section $secIdx',
            subjectName: subj.name,
            subjectCode: subj.code,
            semester: subj.semesterId,
            year: subj.yearId,
            keywords: [secTitle, subj.name, subj.code, ...secKw],
            subject: subj,
            sectionIndex: secIdx,
            sectionType: secTitle,
          ),
        );
      }

      // Index Chapter-wise Important Questions
      final questions = TextbookMockData.getImportantQuestions(subj.id);
      for (final q in questions) {
        items.add(
          SearchableItem(
            id: 'idx_q_${subj.id}_${q.id}',
            category: 'Important Question',
            title: q.question,
            subtitle: '${subj.name} → Chapter ${q.chapterNumber} • ${q.category}',
            subjectName: subj.name,
            subjectCode: subj.code,
            semester: subj.semesterId,
            year: subj.yearId,
            keywords: [q.question, q.answer, q.category, subj.name],
            subject: subj,
            sectionIndex: 2,
            sectionType: 'Important Questions',
          ),
        );
      }

      // Index Practical / Lab Experiments
      final labs = TextbookMockData.getLabExperiments(subj.id);
      for (final lab in labs) {
        items.add(
          SearchableItem(
            id: 'idx_lab_${subj.id}_${lab.id}',
            category: 'Practical / Laboratory',
            title: 'Exp ${lab.experimentNumber}: ${lab.title}',
            subtitle: '${subj.name} • ${lab.objective}',
            subjectName: subj.name,
            subjectCode: subj.code,
            semester: subj.semesterId,
            year: subj.yearId,
            keywords: [lab.title, lab.objective, lab.theory, lab.code, ...lab.vivaQuestions, subj.name],
            subject: subj,
            sectionIndex: 1,

            sectionType: 'Practical / Laboratory',
          ),
        );
      }

      // Index Textbook Chapters, Sections, and Topics
      for (final ch in chapters) {
        // Chapter Item
        items.add(
          SearchableItem(
            id: 'idx_ch_${subj.id}_${ch.id}',
            category: 'Textbook Chapter',
            title: 'Chapter ${ch.chapterNumber}: ${ch.title}',
            subtitle: '${subj.name} • ${ch.description}',
            subjectName: subj.name,
            subjectCode: subj.code,
            semester: subj.semesterId,
            year: subj.yearId,
            keywords: [ch.title, ch.description, 'chapter ${ch.chapterNumber}', subj.name],
            subject: subj,
            chapterId: ch.id,
            chapterNumber: ch.chapterNumber,
            chapterTitle: 'Chapter ${ch.chapterNumber}: ${ch.title}',
            sectionIndex: 1,
          ),
        );

        for (final sec in ch.sections) {
          // Section Item
          items.add(
            SearchableItem(
              id: 'idx_sec_${subj.id}_${sec.id}',
              category: 'Textbook Section',
              title: '${sec.sectionNumber} ${sec.title}',
              subtitle: '${subj.name} → Chapter ${ch.chapterNumber}',
              subjectName: subj.name,
              subjectCode: subj.code,
              semester: subj.semesterId,
              year: subj.yearId,
              keywords: [sec.title, sec.description, sec.sectionNumber, subj.name],
              subject: subj,
              chapterId: ch.id,
              chapterNumber: ch.chapterNumber,
              chapterTitle: 'Chapter ${ch.chapterNumber}: ${ch.title}',
              sectionId: sec.id,
              sectionNumber: sec.sectionNumber,
              sectionTitle: '${sec.sectionNumber} ${sec.title}',
              sectionIndex: 1,
            ),
          );

          for (final top in sec.topics) {
            // Topic Item (Deep Navigation to TopicDetailScreen)
            items.add(
              SearchableItem(
                id: 'idx_top_${subj.id}_${top.id}',
                category: 'Textbook Topic',
                title: '${top.topicNumber} ${top.title}',
                subtitle: '${subj.name} → Chapter ${ch.chapterNumber} → ${sec.sectionNumber}',
                subjectName: subj.name,
                subjectCode: subj.code,
                semester: subj.semesterId,
                year: subj.yearId,
                keywords: [
                  top.title,
                  top.topicNumber,
                  top.definition,
                  top.intuition,
                  top.workingPrinciple,
                  if (top.algorithm != null) top.algorithm!,
                  if (top.pseudocode != null) top.pseudocode!,
                  if (top.codeImplementation != null) top.codeImplementation!,
                  if (top.timeComplexity != null) top.timeComplexity!,
                  if (top.spaceComplexity != null) top.spaceComplexity!,
                  ...top.advantages,
                  ...top.disadvantages,
                  ...top.practiceQuestions,
                  ...top.examQuestions,
                  subj.name,
                  subj.code,
                ],
                subject: subj,
                chapterId: ch.id,
                chapterNumber: ch.chapterNumber,
                chapterTitle: 'Chapter ${ch.chapterNumber}: ${ch.title}',
                sectionId: sec.id,
                sectionNumber: sec.sectionNumber,
                sectionTitle: '${sec.sectionNumber} ${sec.title}',
                topicId: top.id,
                topicNumber: top.topicNumber,
                topicTitle: top.title,
                topicModel: top,
              ),
            );
          }
        }
      }
    }

    // 2. Index Study Resources (Notes, Syllabi, Previous Papers)
    for (final res in resources) {
      items.add(
        SearchableItem(
          id: 'idx_res_${res.id}',
          category: res.resourceType,
          title: res.title,
          subtitle: '${res.subjectName} • ${res.resourceType}',
          subjectName: res.subjectName,
          subjectCode: res.subjectId,
          semester: res.semesterId,
          year: res.yearId,
          keywords: [res.title, res.description, ...res.tags],
          noteTitles: res.resourceType == 'Notes' ? [res.title] : [],
          previousPaperTitles: res.resourceType.contains('Paper') || res.resourceType.contains('PYQ') ? [res.title] : [],
          storageUrl: res.storageUrl,
          resource: res,
          sectionType: res.sectionType ?? res.resourceType,
        ),
      );
    }

    // 3. Index Career Roles & Technologies
    final careerList = careerTechs ?? CareerRepository.fallbackCareerTechnologies;
    for (final car in careerList) {
      items.add(
        SearchableItem(
          id: 'idx_car_${car.id}',
          category: 'Career Path',
          title: car.name,
          subtitle: '${car.category} • Career & Skill Path',
          subjectName: car.name,
          subjectCode: car.id,
          semester: 'N/A',
          year: 'N/A',
          keywords: [
            car.name,
            car.category,
            car.introduction,
            car.whyLearn,
            ...car.requiredSkills,
            ...car.careerOpportunities,
            ...car.learningRoadmap,
            ...car.interviewPrepTopics,
          ],
          careerTech: car,
        ),
      );
    }

    // 4. Index Coding Languages, DSA Topics & Projects
    final codingLangsList = codingLangs ?? CodingRepository.fallbackCodingLanguages;
    for (final lang in codingLangsList) {
      items.add(
        SearchableItem(
          id: 'idx_lang_${lang.id}',
          category: 'Coding Language',
          title: lang.name,
          subtitle: 'Programming Language • ${lang.whyLearn}',
          subjectName: lang.name,
          subjectCode: lang.id,
          semester: 'N/A',
          year: 'N/A',
          keywords: [lang.name, lang.introduction, lang.syntaxFundamentals, ...lang.practiceProblems, ...lang.interviewQuestions],
        ),
      );
    }

    final dsaTopicsList = dsaTopics ?? CodingRepository.fallbackDsaTopics;
    for (final dsa in dsaTopicsList) {
      items.add(
        SearchableItem(
          id: 'idx_dsa_${dsa.id}',
          category: 'DSA Topic',
          title: dsa.topicName,
          subtitle: 'Data Structures & Algorithms • ${dsa.category}',
          subjectName: dsa.topicName,
          subjectCode: dsa.id,
          semester: 'N/A',
          year: 'N/A',
          keywords: [dsa.topicName, dsa.category, dsa.definition, dsa.intuition, dsa.algorithm, ...dsa.practiceProblems, ...dsa.interviewQuestions],
        ),
      );
    }

    final codingProjectsList = codingProjects ?? CodingRepository.fallbackCodingProjects;
    for (final proj in codingProjectsList) {
      items.add(
        SearchableItem(
          id: 'idx_proj_${proj.id}',
          category: 'Coding Project',
          title: proj.title,
          subtitle: '${proj.difficulty} • ${proj.problemStatement}',
          subjectName: proj.title,
          subjectCode: proj.id,
          semester: 'N/A',
          year: 'N/A',
          keywords: [proj.title, proj.problemStatement, proj.architecture, ...proj.techStack, ...proj.requiredSkills],
        ),
      );
    }

    final projectsList = projects ?? ProjectRepository.fallbackProjects;
    for (final p in projectsList) {
      items.add(
        SearchableItem(
          id: 'idx_hub_proj_${p.id}',
          category: 'Industry Project Blueprint',
          title: p.title,
          subtitle: '${p.category} • ${p.difficulty} (${p.estimatedDuration})',
          subjectName: p.title,
          subjectCode: p.id,
          semester: 'N/A',
          year: 'N/A',
          keywords: [p.title, p.category, p.difficulty, p.description, p.problemStatement, p.systemArchitecture, p.resumeDescription, ...p.technologies, ...p.requiredSkills],
        ),
      );
    }

    final placementsList = placements ?? PlacementRepository.fallbackPlacementResources;
    for (final plc in placementsList) {
      final qKeywords = plc.questionsAndAnswers.map((qa) => '${qa.question} ${qa.answer}').toList();
      items.add(
        SearchableItem(
          id: 'idx_plc_${plc.id}',
          category: 'Placement Prep',
          title: plc.title,
          subtitle: 'Placement Hub • ${plc.category}',
          subjectName: plc.title,
          subjectCode: plc.id,
          semester: 'N/A',
          year: 'N/A',
          keywords: [plc.title, plc.category, plc.description, plc.roadmap, ...plc.tips, ...qKeywords],
        ),
      );
    }

    final higherEdList = higherEdItems ?? HigherEducationRepository.fallbackHigherEducationResources;
    for (final ed in higherEdList) {
      final faqKeywords = ed.faqs.map((f) => '${f.question} ${f.answer}').toList();
      items.add(
        SearchableItem(
          id: 'idx_hed_${ed.id}',
          category: 'Higher Education',
          title: ed.title,
          subtitle: '${ed.category} • ${ed.subtitle}',
          subjectName: ed.title,
          subjectCode: ed.id,
          semester: 'N/A',
          year: 'N/A',
          keywords: [ed.title, ed.category, ed.subtitle, ed.overview, ed.eligibilityCriteria, ed.careerOpportunities, ...ed.syllabusTopics, ...ed.scholarships, ...faqKeywords],
        ),
      );
    }

    final emergingTechList = emergingTechs ?? EmergingTechRepository.fallbackEmergingTechs;
    for (final em in emergingTechList) {
      items.add(
        SearchableItem(
          id: 'idx_em_${em.id}',
          category: 'Emerging Technology',
          title: em.title,
          subtitle: '${em.category} • ${em.whyItMatters}',
          subjectName: em.title,
          subjectCode: em.id,
          semester: 'N/A',
          year: 'N/A',
          keywords: [em.title, em.category, em.overview, em.whyItMatters, em.futureDirection, ...em.coreConcepts, ...em.tools, ...em.frameworks, ...em.prerequisites, ...em.careerRoles, ...em.projects],
        ),
      );
    }

    // 5. Index New Non-Academic Hierarchy Hubs, Categories, Topics & Resources
    for (final hub in NonAcademicData.allHubs) {
      items.add(
        SearchableItem(
          id: 'idx_hub_${hub.id}',
          category: 'Learning Hub',
          title: hub.title,
          subtitle: hub.description,
          subjectName: hub.title,
          subjectCode: hub.id,
          semester: 'N/A',
          year: 'N/A',
          keywords: [hub.title, hub.description],
        ),
      );

      for (final cat in hub.categories) {
        items.add(
          SearchableItem(
            id: 'idx_cat_${hub.id}_${cat.id}',
            category: '${hub.title} Category',
            title: cat.title,
            subtitle: '${hub.title} → ${cat.description}',
            subjectName: cat.title,
            subjectCode: cat.id,
            semester: 'N/A',
            year: 'N/A',
            keywords: [cat.title, cat.description, hub.title],
          ),
        );

        _indexHierarchicalTopics(items, hub, cat, cat.topics);
      }
    }

    _index = items;
    _isIndexed = true;

    debugPrint('[GlobalSearchEngine] Documents loaded: ${subjects.length} subjects, ${resources.length} resources');
    debugPrint('[GlobalSearchEngine] Total Searchable items indexed: ${_index.length}');
  }

  /// Searches the pre-built index locally in O(N) time with 0 network calls
  GlobalSearchResult search(String rawQuery) {
    if (rawQuery.trim().isEmpty) {
      debugPrint('[GlobalSearchEngine] Query: "" -> Empty query');
      return const GlobalSearchResult();
    }

    final query = rawQuery.trim();

    final List<SearchableItem> matchingItems = [];
    final List<SubjectModel> matchingSubjects = [];
    final List<ResourceModel> matchingResources = [];

    final Set<String> seenSubjectIds = {};
    final Set<String> seenResourceIds = {};

    for (final item in _index) {
      if (item.matches(query)) {
        matchingItems.add(item);

        if (item.subject != null && !seenSubjectIds.contains(item.subject!.id)) {
          seenSubjectIds.add(item.subject!.id);
          matchingSubjects.add(item.subject!);
        }

        if (item.resource != null && !seenResourceIds.contains(item.resource!.id)) {
          seenResourceIds.add(item.resource!.id);
          matchingResources.add(item.resource!);
        }
      }
    }

    debugPrint('[GlobalSearchEngine] User search query: "$query" -> Found ${matchingItems.length} matching items (${matchingSubjects.length} subjects, ${matchingResources.length} resources)');

    return GlobalSearchResult(
      matchingSubjects: matchingSubjects,
      matchingResources: matchingResources,
      matchingItems: matchingItems,
    );
  }

  /// Detailed syllabus topics, units, and keywords database per CSSE subject code
  static Map<String, dynamic> _getSyllabusMetadata(String code, String name) {
    final c = code.toUpperCase();
    final n = name.toLowerCase();

    if (c == 'CS1101' || n.contains('mathematics-i') || n.contains('mathematics i')) {
      return {
        'units': [
          'Unit 1: Partial Differentiation',
          'Unit 2: Applications of Partial Differentiation',
          'Unit 3: Multiple Integrals',
          'Unit 4: Applications of Multiple Integrals',
          'Unit 5: Fourier Series'
        ],
        'topics': [
          'Partial differentiation',
          'Homogeneous functions',
          'Euler theorem',
          'Jacobians',
          'Mean value theorems',
          'Tangent plane and Normal to surface',
          'Taylor theorem',
          'Errors and approximations',
          'Maxima and Minima',
          'Lagrange multipliers',
          'Leibnitz rule',
          'Double Integrals',
          'Triple Integrals',
          'Change of order of integration',
          'Beta Function',
          'Gamma Function',
          'Error Function',
          'Fourier series',
          'Euler formula',
          'Parseval formula',
          'Harmonic analysis'
        ],
        'keywords': ['maths 1', 'CS1101', 'jacobians', 'euler theorem', 'lagrange multipliers', 'leibnitz rule', 'beta function', 'gamma function', 'fourier series', 'parseval formula', 'double integrals', 'triple integrals']
      };
    } else if (c == 'CS1102' || n.contains('green chemistry') || n.contains('chemistry')) {
      return {
        'units': [
          'Unit 1: Introduction to Green Chemistry',
          'Unit 2: Green Synthesis and Green Reagents',
          'Unit 3: Renewable Resources and Energy',
          'Unit 4: Water Chemistry and Environmental Chemistry',
          'Unit 5: Green Polymers and Nanomaterials'
        ],
        'topics': [
          'Twelve Principles of Green Chemistry',
          'Green Synthesis',
          'Green Reagents',
          'Green Catalysts',
          'Green Solvents',
          'Microwave Assisted Synthesis',
          'Ultrasound Assisted Synthesis',
          'Biomass and Biofuels',
          'Biodiesel',
          'Hydrogen as Fuel',
          'Fuel Cells',
          'Water Quality Parameters',
          'Hardness of Water',
          'Wastewater Treatment',
          'Ozone Layer Depletion',
          'Biodegradable Polymers',
          'Carbon Nanotubes',
          'Green Nanotechnology'
        ],
        'keywords': ['chemistry', 'CS1102', 'green chemistry', 'twelve principles', 'green solvents', 'microwave synthesis', 'biodiesel', 'fuel cells', 'hardness of water', 'EDTA', 'carbon nanotubes']
      };
    } else if (c == 'CS1103' || n.contains('english')) {
      return {
        'units': [
          'Module 1: Literary Texts & Life Skills',
          'Module 2: Communication & Personality Development',
          'Module 3: Grammar',
          'Module 4: Vocabulary',
          'Module 5: Writing Skills'
        ],
        'topics': [
          'William Hazlitt Conduct of Life',
          'Rudyard Kipling If poem',
          'Alfred Tennyson The Brook',
          'George Bernard Shaw Public Speaker',
          'Saki The Death Trap',
          'Seneca On Saving Time',
          'George Orwell Politics and English Language',
          'Prepositions and Articles',
          'Subject-Verb Agreement',
          'Misplaced Modifiers and Clichés',
          'Word Formation, Prefixes and Suffixes',
          'Synonyms and Antonyms',
          'Essay Writing and Summarizing'
        ],
        'keywords': ['english', 'CS1103', 'grammar', 'vocabulary', 'essay writing', 'subject verb agreement', 'prepositions', 'articles', 'william hazlitt', 'rudyard kipling', 'george orwell']
      };
    } else if (c == 'CS1104' || n.contains('c programming') || n.contains('programming using c') || n.contains('programming in c')) {
      return {
        'units': [
          'Chapter 1: Introduction to C',
          'Chapter 2: Decision Making, Branching and Looping',
          'Chapter 3: Arrays and Strings',
          'Chapter 4: Functions',
          'Chapter 5: Pointers',
          'Chapter 6: Structures and Unions',
          'Chapter 7: File Handling'
        ],
        'topics': [
          'C Program Structure',
          'Constants, Variables and Data Types',
          'Operators and Expressions',
          'Formatted Input and Output (printf, scanf)',
          'If-Else and Switch Case Branching',
          'While, Do-While and For Loops',
          '1D and 2D Arrays',
          'Strings and String Handling Functions (strlen, strcpy, strcat, strcmp)',
          'Function Declaration, Calls and Recursion',
          'Pointers, Address-of, Dereference and Pointer Arithmetic',
          'Array of Pointers and Pointers to Functions',
          'Structures, Unions and Bit-fields',
          'File Handling (fopen, fclose, fread, fwrite, fseek, ftell)',
          'Command Line Arguments (argc, argv)'
        ],
        'keywords': ['c', 'programming', 'CS1104', 'pointers', 'arrays', 'functions', 'recursion', 'strings', 'structs', 'unions', 'files', 'printf', 'scanf', 'fopen', 'argc', 'argv']
      };
    } else if (c == 'CS1105' || n.contains('it essentials') || n.contains('essentials')) {
      return {
        'units': [
          'Chapter 1: Introduction to Computer',
          'Chapter 2: Computer Memory and Storage Devices',
          'Chapter 3: Computer Software',
          'Chapter 4: Computer Networks and Internet',
          'Chapter 5: Cyber Security',
          'Chapter 6: Emerging Technologies'
        ],
        'topics': [
          'Computer Architecture, CPU, ALU and Control Unit',
          'Number Systems (Binary, Octal, Hexadecimal, ASCII, Unicode)',
          'Memory Hierarchy, RAM, ROM, Cache and SSD/HDD Storage',
          'Operating Systems, Compilers, Interpreters and Antivirus',
          'Computer Networks, LAN, WAN, Topologies and Fiber Optics',
          'TCP/IP, DNS, Web Browsers and Cloud Computing',
          'Cybersecurity, Malware, Phishing, Firewalls and Encryption',
          'Emerging Technologies (AI, Machine Learning, IoT, Big Data, Blockchain, AR/VR)'
        ],
        'keywords': ['it', 'essentials', 'CS1105', 'hardware', 'RAM', 'ROM', 'cache', 'networks', 'operating systems', 'cybersecurity', 'firewalls', 'AI', 'IoT', 'blockchain']
      };
    } else if (c == 'CS1201' || n.contains('mathematics – ii') || n.contains('mathematics ii')) {
      return {
        'units': [
          'Chapter 1: Linear Algebra',
          'Chapter 2: Eigen Values and Eigen Vectors',
          'Chapter 3: Ordinary Differential Equations of First Order',
          'Chapter 4: Differential Equations of Higher Order',
          'Chapter 5: Laplace Transforms'
        ],
        'topics': [
          'Matrix Rank, Echelon Form and Normal Form',
          'Gauss Elimination, LU Factorization and Gauss Seidel',
          'Hermitian, Skew-Hermitian and Unitary Matrices',
          'Eigenvalues, Eigenvectors and Cayley-Hamilton Theorem',
          'Matrix Diagonalization and Quadratic Forms',
          'First Order Linear ODEs, Exact and Bernoulli Equations',
          'LR and CR Circuits and Newton Law of Cooling',
          'Higher Order Linear ODEs, Particular Integral and Variation of Parameters',
          'Cauchy and Legendre Linear Equations',
          'Laplace Transforms, Inverse Laplace and Convolution Theorem',
          'Unit Step Function, Dirac Delta Impulse and Periodic Functions'
        ],
        'keywords': ['maths 2', 'CS1201', 'linear algebra', 'eigenvalues', 'eigenvectors', 'Cayley Hamilton', 'Laplace transforms', 'differential equations', 'Gauss elimination', 'circuits']
      };
    } else if (c == 'CS1202' || n.contains('physics')) {
      return {
        'units': [
          'Chapter 1: Waves and Oscillations',
          'Chapter 2: Optics',
          'Chapter 3: Quantum Mechanics',
          'Chapter 4: Semiconductor Physics',
          'Chapter 5: Nanotechnology'
        ],
        'topics': [
          'SHM, Damped/Forced Oscillations and Acoustics',
          'Interference, Young Double Slit, Diffraction and Polarization',
          'Lasers, Population Inversion and Optical Fibers',
          'Black Body Radiation, Planck Theory and Photoelectric Effect',
          'Compton Effect, de Broglie Waves and Schrödinger Wave Equation',
          'Intrinsic/Extrinsic Semiconductors, PN Junction and Zener Diode',
          'Rectifiers, Transistors, LED and Solar Cells',
          'Sol-Gel Synthesis and Carbon Nanotubes (CNT)'
        ],
        'keywords': ['physics', 'CS1202', 'waves', 'optics', 'lasers', 'quantum mechanics', 'Schrodinger equation', 'semiconductors', 'PN junction', 'Zener diode', 'nanotechnology']
      };
    } else if (c == 'CS1203' || n.contains('data structures')) {
      return {
        'units': [
          'Chapter 1: Introduction & Algorithm Analysis',
          'Chapter 2: Stacks and Queues',
          'Chapter 3: Linked Lists',
          'Chapter 4: Trees & Sorting',
          'Chapter 5: Graphs & Shortest Paths'
        ],
        'topics': [
          'Abstract Data Types (ADT) and Algorithm Complexity (Big-O)',
          'Stacks, Push/Pop Operations and Infix to Postfix Conversion',
          'Queues, Circular Queue, Priority Queue and Deque',
          'Singly, Doubly and Circular Linked Lists',
          'Polynomial Addition and Sparse Matrix Representation',
          'Binary Trees, BST, Inorder/Preorder/Postorder Traversals',
          'Threaded Binary Trees, AVL Trees, Heap and Heap Sort',
          'Graph Representation (Adjacency Matrix/List), BFS and DFS',
          'Minimum Spanning Trees (Prim\'s, Kruskal\'s)',
          'Dijkstra\'s Shortest Path Algorithm'
        ],
        'keywords': ['ds', 'data structures', 'CS1203', 'stacks', 'queues', 'linked lists', 'trees', 'BST', 'AVL', 'heap sort', 'graphs', 'BFS', 'DFS', 'Dijkstra', 'algorithms']
      };
    } else if (c == 'CS1204' || n.contains('digital logic')) {
      return {
        'units': [
          'Chapter 1: Number Systems and Codes',
          'Chapter 2: Boolean Algebra',
          'Chapter 3: Combinational Logic Circuits',
          'Chapter 4: Sequential Logic Circuits',
          'Chapter 5: Memory and Programmable Logic'
        ],
        'topics': [
          'Binary Arithmetic, 1\'s/2\'s Complements, Gray Code and Hamming Code',
          'Boolean Algebra Laws, De Morgan\'s Theorem and Logic Gates',
          'Universal Gates (NAND, NOR), SOP and POS Canonical Forms',
          'Karnaugh Maps (K-Maps) Minimization',
          'Adders (Half/Full), Subtractors, MUX, DEMUX, Encoders, Decoders',
          'Flip-Flops (SR, JK, D, T, Master-Slave), Shift Registers and Counters',
          'RAM, ROM, PLA, PAL, FPGA and Introduction to Verilog/VHDL'
        ],
        'keywords': ['dld', 'digital logic', 'CS1204', 'K maps', 'boolean algebra', 'adders', 'MUX', 'flip flops', 'counters', 'RAM', 'ROM', 'FPGA', 'Verilog']
      };
    }

    return {
      'units': ['Unit 1: Overview', 'Unit 2: Core Concepts', 'Unit 3: Advanced Topics'],
      'topics': [name, '$code Basics', 'Core Algorithms', 'Applications'],
      'keywords': [name.toLowerCase(), code.toLowerCase()]
    };
  }

  static void _indexHierarchicalTopics(
    List<SearchableItem> items,
    HubModel hub,
    CategoryModel cat,
    List<HierarchicalTopicModel> topics,
  ) {
    for (final topic in topics) {
      final levelLabel = topic.level != null ? ' (${topic.level!.displayName})' : '';

      items.add(
        SearchableItem(
          id: 'idx_top_${hub.id}_${cat.id}_${topic.id}',
          category: '${hub.title} Topic',
          title: '${topic.title}$levelLabel',
          subtitle: '${hub.title} → ${cat.title} → ${topic.description}',
          subjectName: topic.title,
          subjectCode: topic.id,
          semester: 'N/A',
          year: 'N/A',
          keywords: [
            topic.title,
            topic.description,
            hub.title,
            cat.title,
            if (topic.level != null) topic.level!.plainTitle,
          ],
        ),
      );

      for (final res in topic.resources) {
        items.add(
          SearchableItem(
            id: 'idx_res_${topic.id}_${res.id}',
            category: res.type.displayName,
            title: res.title,
            subtitle: '${hub.title} → ${cat.title} → ${topic.title} • ${res.description}',
            subjectName: res.title,
            subjectCode: res.id,
            semester: 'N/A',
            year: 'N/A',
            keywords: [res.title, res.description, topic.title, cat.title, hub.title, res.type.displayName],
          ),
        );
      }

      if (topic.hasSubtopics) {
        _indexHierarchicalTopics(items, hub, cat, topic.subtopics);
      }
    }
  }
}

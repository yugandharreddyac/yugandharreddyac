import '../models/resource_model.dart';

class AcademicResourceCatalog {
  /// Base CDN Storage Domain for Cloudflare R2 / CDN object delivery
  static const String baseCdnUrl = 'https://cdn.csse-study-hub.org/academic';

  /// Centralized Production Academic Resources Catalog
  static List<ResourceModel> get allAcademicResources => [
        // ==========================================
        // 1st Year - Semester 1 (1-1)
        // ==========================================
        // 1. Computer Programming Using C (CS1104) - Recommended Start Here Notes
        ResourceModel(
          id: 'pdf_c_prog_start_here_unit1',
          title: '⭐ Unit 1: C Programming Syntax, Compilers & Control Flow',
          description: 'Beginner-first introductory guide to C compilers, variables, data types, printf/scanf syntax, and conditional loops.',
          subjectId: 'subj_1_1_4',
          subjectName: 'Computer Programming Using C',
          yearId: 'year_1',
          semesterId: 'sem_1_1',
          resourceType: 'Lecture Notes',
          sectionType: 'Quick Revision',
          chapterId: 'unit_1',
          sectionId: 'topic_c_basics',
          storagePath: 'academic/year_1/sem_1_1/c_prog/unit_1_c_syntax.pdf',
          storageUrl: '$baseCdnUrl/year_1/sem_1_1/c_prog/unit_1_c_syntax.pdf',
          fileSizeBytes: 2457600, // 2.4 MB
          pageCount: 32,
          lastUpdated: DateTime(2026, 1, 15),
          difficultyLevel: 'Beginner',
          version: '1.0',
          sourceProvider: 'JNTUH Academic Council',
          isFeatured: true,
          whatIsThis: 'Introductory notes covering C programming foundation, variable declarations, and loops.',
          whyUseIt: 'Start here! Essential reading for 1st-year students before writing C code in laboratory sessions.',
          estimatedStudyTime: '20 mins',
          isOfficial: true,
          language: 'English',
          ordering: 1,
          availabilityStatus: 'available',
          copyrightTier: 'officially_provided',
          tags: ['C Programming', 'Start Here', 'Variables', 'Loops', 'Lecture Notes'],
        ),
        // 2. Computer Programming Using C - PYQ Bank
        ResourceModel(
          id: 'pdf_c_prog_pyq_2023_2025',
          title: 'C Programming Solved Examination PYQs (2022 - 2025)',
          description: 'Previous year university examination questions with step-by-step solved C programs and scoring keys.',
          subjectId: 'subj_1_1_4',
          subjectName: 'Computer Programming Using C',
          yearId: 'year_1',
          semesterId: 'sem_1_1',
          resourceType: 'Previous Papers',
          sectionType: 'Previous Papers',
          chapterId: 'all_units',
          sectionId: 'pyq_bank',
          storagePath: 'academic/year_1/sem_1_1/c_prog/c_prog_pyq_bank.pdf',
          storageUrl: '$baseCdnUrl/year_1/sem_1_1/c_prog/c_prog_pyq_bank.pdf',
          fileSizeBytes: 4194304, // 4.0 MB
          pageCount: 48,
          lastUpdated: DateTime(2026, 2, 10),
          difficultyLevel: 'Beginner',
          version: '2.0',
          sourceProvider: 'University Examination Cell',
          isFeatured: false,
          whatIsThis: '3-year solved question paper collection for C programming exams.',
          whyUseIt: 'Helps students identify high-frequency exam questions and scoring patterns.',
          estimatedStudyTime: '45 mins',
          isOfficial: true,
          language: 'English',
          ordering: 2,
          availabilityStatus: 'available',
          copyrightTier: 'officially_provided',
          tags: ['C Programming', 'PYQs', 'Exam Papers', 'Solutions'],
        ),
        // 3. Computer Programming Using C - Unit 4 Notes (Coming Soon Example)
        ResourceModel(
          id: 'pdf_c_prog_unit4_coming_soon',
          title: 'Unit 4: Dynamic Memory Allocation & File I/O Notes',
          description: 'Upcoming comprehensive notes on malloc, free, pointer arithmetic, and binary file streams.',
          subjectId: 'subj_1_1_4',
          subjectName: 'Computer Programming Using C',
          yearId: 'year_1',
          semesterId: 'sem_1_1',
          resourceType: 'Lecture Notes',
          sectionType: 'Quick Revision',
          chapterId: 'unit_4',
          sectionId: 'topic_file_io',
          storagePath: 'academic/year_1/sem_1_1/c_prog/unit_4_file_io.pdf',
          storageUrl: '$baseCdnUrl/year_1/sem_1_1/c_prog/unit_4_file_io.pdf',
          fileSizeBytes: 0,
          pageCount: 0,
          lastUpdated: DateTime(2026, 2, 12),
          difficultyLevel: 'Intermediate',
          version: '0.9',
          sourceProvider: 'CSSED Department Notes',
          availabilityStatus: 'coming_soon',
          whatIsThis: 'Notes for this unit are currently being formatted and proofread.',
          whyUseIt: 'Will provide clear code examples for file operations in C.',
          estimatedStudyTime: '30 mins',
          isOfficial: true,
          language: 'English',
          ordering: 3,
          copyrightTier: 'created_by_cssed',
          tags: ['C Programming', 'Pointers', 'File I/O', 'Coming Soon'],
        ),

        // ==========================================
        // 2nd Year - Semester 1 (2-1)
        // ==========================================
        // 4. Data Structures (CSSE2101) - Recommended Start Here Notes
        ResourceModel(
          id: 'pdf_ds_start_here_unit2',
          title: '⭐ Unit 2: Singly, Doubly & Circular Linked Lists Guide',
          description: 'Detailed structural notes on pointer memory allocation, linked list node insertion, deletion, and LRU cache implementation.',
          subjectId: 'subj_2_1_1',
          subjectName: 'Data Structures',
          yearId: 'year_2',
          semesterId: 'sem_2_1',
          resourceType: 'Lecture Notes',
          sectionType: 'Quick Revision',
          chapterId: 'unit_2',
          sectionId: 'topic_linked_list',
          storagePath: 'academic/year_2/sem_2_1/ds/unit2_linked_lists.pdf',
          storageUrl: '$baseCdnUrl/year_2/sem_2_1/ds/unit2_linked_lists.pdf',
          fileSizeBytes: 3145728, // 3.0 MB
          pageCount: 40,
          lastUpdated: DateTime(2026, 1, 20),
          difficultyLevel: 'Intermediate',
          version: '1.2',
          sourceProvider: 'IIT Madras NPTEL Notes',
          isFeatured: true,
          whatIsThis: 'Complete conceptual and code walkthrough of dynamic linked data structures.',
          whyUseIt: 'Start here! Crucial for 2nd-year CSE students preparing for data structure lab exams and coding interviews.',
          estimatedStudyTime: '35 mins',
          isOfficial: true,
          language: 'English',
          ordering: 1,
          availabilityStatus: 'available',
          copyrightTier: 'open_licensed',
          tags: ['Data Structures', 'Start Here', 'Linked Lists', 'Pointers', 'Lab Manual'],
        ),
        // 5. Operating Systems (CSSE2104) - Galvin Textbook Reference
        ResourceModel(
          id: 'pdf_os_textbook_galvin',
          title: 'Operating System Concepts (Silberschatz & Galvin)',
          description: 'Standard reference textbook covering process management, CPU scheduling, deadlocks, and virtual memory.',
          subjectId: 'subj_2_1_4',
          subjectName: 'Operating Systems',
          yearId: 'year_2',
          semesterId: 'sem_2_1',
          resourceType: 'Textbook',
          sectionType: 'Textbook',
          chapterId: 'all_units',
          sectionId: 'os_concepts',
          storagePath: 'academic/year_2/sem_2_1/os/os_concepts_galvin.pdf',
          storageUrl: '$baseCdnUrl/year_2/sem_2_1/os/os_concepts_galvin.pdf',
          fileSizeBytes: 12582912, // 12 MB
          pageCount: 850,
          lastUpdated: DateTime(2025, 11, 5),
          difficultyLevel: 'Intermediate',
          version: '10.0',
          sourceProvider: 'Wiley Global Higher Education',
          isFeatured: true,
          whatIsThis: 'Gold-standard Operating Systems reference textbook.',
          whyUseIt: 'Provides deep theoretical foundations for OS core algorithms and system design interviews.',
          estimatedStudyTime: '60 mins',
          isOfficial: true,
          language: 'English',
          ordering: 1,
          availabilityStatus: 'available',
          copyrightTier: 'officially_provided',
          tags: ['Operating Systems', 'Textbook', 'Processes', 'Deadlocks'],
        ),
        // 6. Operating Systems - Linux Kernel Docs (External Copyright Safe Example)
        ResourceModel(
          id: 'pdf_os_official_docs_kernel',
          title: 'Official Linux Kernel Scheduler Documentation',
          description: 'Official Linux kernel documentation for process memory mapping and Completely Fair Scheduler (CFS).',
          subjectId: 'subj_2_1_4',
          subjectName: 'Operating Systems',
          yearId: 'year_2',
          semesterId: 'sem_2_1',
          resourceType: 'Official Documentation',
          sectionType: 'Additional Resources',
          chapterId: 'unit_3',
          sectionId: 'kernel_scheduler',
          storagePath: '',
          storageUrl: 'https://www.kernel.org/doc/html/latest/scheduler/sched-design-CFS.html',
          fileSizeBytes: 0,
          pageCount: 0,
          lastUpdated: DateTime(2026, 1, 30),
          difficultyLevel: 'Advanced',
          version: '6.8',
          sourceProvider: 'Linux Kernel Organization',
          isOfficial: true,
          copyrightTier: 'external_copyrighted',
          isDownloadable: false,
          whatIsThis: 'Official reference documentation maintained by kernel core developers.',
          whyUseIt: 'Deep-dive reference for understanding real-world operating system schedulers.',
          estimatedStudyTime: '25 mins',
          language: 'English',
          ordering: 2,
          availabilityStatus: 'available',
          tags: ['Linux', 'Kernel', 'OS', 'Official Docs'],
        ),

        // ==========================================
        // 3rd Year - Semester 1 (3-1)
        // ==========================================
        // 7. Computer Networks (CSSE3101) - Lab Manual
        ResourceModel(
          id: 'pdf_cn_lab_manual',
          title: 'Computer Networks Socket Programming Lab Manual',
          description: 'Step-by-step experiment guide for Wireshark packet capture, TCP 3-way handshake, and C socket programming.',
          subjectId: 'subj_3_1_1',
          subjectName: 'Data Communication & Computer Networks',
          yearId: 'year_3',
          semesterId: 'sem_3_1',
          resourceType: 'Lab Manual',
          sectionType: 'Practical / Lab',
          chapterId: 'unit_3',
          sectionId: 'socket_programming',
          storagePath: 'academic/year_3/sem_3_1/cn/cn_lab_manual.pdf',
          storageUrl: '$baseCdnUrl/year_3/sem_3_1/cn/cn_lab_manual.pdf',
          fileSizeBytes: 1835008, // 1.75 MB
          pageCount: 24,
          lastUpdated: DateTime(2026, 2, 1),
          difficultyLevel: 'Intermediate',
          version: '1.0',
          sourceProvider: 'CSSED Department Labs',
          isFeatured: true,
          whatIsThis: 'Hands-on practical guide for network protocol experiments.',
          whyUseIt: 'Required for completing semester lab assignments and viva voce examination.',
          estimatedStudyTime: '30 mins',
          isOfficial: true,
          language: 'English',
          ordering: 1,
          availabilityStatus: 'available',
          copyrightTier: 'created_by_cssed',
          tags: ['Computer Networks', 'Wireshark', 'Sockets', 'Lab Manual'],
        ),
      ];

  /// Get Resources for a specific Subject ID
  static List<ResourceModel> getResourcesForSubject(String subjectId) {
    return allAcademicResources.where((res) => res.subjectId == subjectId).toList();
  }

  /// Get Featured "Start Here / Recommended" Resource for a Subject
  static ResourceModel? getRecommendedResource(String subjectId) {
    try {
      return allAcademicResources.firstWhere(
        (res) => res.subjectId == subjectId && res.isFeatured && res.availabilityStatus == 'available',
      );
    } catch (_) {
      try {
        return allAcademicResources.firstWhere((res) => res.subjectId == subjectId);
      } catch (_) {
        return null;
      }
    }
  }
}

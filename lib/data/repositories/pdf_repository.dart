import '../models/resource_model.dart';
import '../datasources/local_storage_datasource.dart';

class PdfRepository {
  final LocalStorageDataSource? localStorage;

  PdfRepository({this.localStorage});

  /// Check if local cached file exists and returns path
  String? getLocalFilePath(ResourceModel resource) {
    if (localStorage == null) return null;
    final downloads = localStorage!.getDownloadedResources();
    try {
      final found = downloads.firstWhere((r) => r.id == resource.id);
      return found.localFilePath;
    } catch (_) {
      return null;
    }
  }

  /// Calculates reading progress percentage
  double calculateProgressPercentage(int currentPage, int totalPages) {
    if (totalPages <= 0) return 0.0;
    return ((currentPage / totalPages) * 100.0).clamp(0.0, 100.0);
  }

  /// Saves the last read page for auto-resume
  Future<void> saveReadingProgress(String resourceId, int currentPage) async {
    if (localStorage != null) {
      await localStorage!.saveLastReadPage(resourceId, currentPage);
    }
  }

  /// Fetches saved last read page for auto-resume
  int getSavedReadingPage(String resourceId) {
    if (localStorage == null) return 0;
    return localStorage!.getLastReadPage(resourceId);
  }

  /// Query & Filter Academic PDF Documents
  List<ResourceModel> filterDocuments(
    List<ResourceModel> allResources, {
    String? yearId,
    String? semesterId,
    String? subjectId,
    String? unitId,
    String? topicId,
    String? documentType,
    String? difficultyLevel,
  }) {
    return allResources.where((doc) {
      if (yearId != null && yearId.isNotEmpty && doc.yearId != yearId)
        return false;
      if (semesterId != null &&
          semesterId.isNotEmpty &&
          doc.semesterId != semesterId) return false;
      if (subjectId != null &&
          subjectId.isNotEmpty &&
          doc.subjectId != subjectId) return false;
      if (unitId != null && unitId.isNotEmpty && doc.unitId != unitId)
        return false;
      if (topicId != null && topicId.isNotEmpty && doc.topicId != topicId)
        return false;
      if (documentType != null &&
          documentType.isNotEmpty &&
          doc.documentType != documentType) return false;
      if (difficultyLevel != null &&
          difficultyLevel.isNotEmpty &&
          doc.difficultyLevel != difficultyLevel) return false;
      return true;
    }).toList();
  }

  /// Validate HTTPS Scheme & URL formatting for PDF resources
  List<String> validateDocumentUrls(List<ResourceModel> resources) {
    final errors = <String>[];
    final seenIds = <String>{};
    final seenUrls = <String>{};

    for (final res in resources) {
      if (seenIds.contains(res.id)) {
        errors.add('Duplicate Resource ID detected: ${res.id}');
      }
      seenIds.add(res.id);

      if (res.storageUrl.isEmpty) {
        errors.add('Empty storage URL for Resource ID: ${res.id}');
      } else if (!res.storageUrl.startsWith('https://') &&
          !res.storageUrl.startsWith('http://')) {
        errors.add(
            'Invalid URL scheme (must be HTTPS/HTTP) for Resource ID: ${res.id} (${res.storageUrl})');
      }

      if (seenUrls.contains(res.storageUrl)) {
        // Log duplicate URL warning if needed
      }
      seenUrls.add(res.storageUrl);
    }
    return errors;
  }

  /// Sample Remote HTTPS Academic PDF Catalog for Testing & Demonstration
  static List<ResourceModel> get sampleAcademicPdfCatalog => [
        // 1-1 Semester: C Programming Lecture Notes
        ResourceModel(
          id: 'pdf_c_prog_notes_unit1',
          title: 'Unit 1: C Syntax, Data Types & Control Structures',
          description:
              'Comprehensive beginner lecture notes introducing C compilers, variables, printf/scanf syntax, and conditional loops.',
          subjectId: 'subj_1_1_4',
          subjectName: 'Computer Programming Using C',
          yearId: 'year_1',
          semesterId: 'sem_1_1',
          resourceType: 'Lecture Notes',
          sectionType: 'Unit Notes',
          chapterId: 'unit_1',
          sectionId: 'topic_c_basics',
          storagePath: 'academic/year_1/sem_1_1/c_prog/unit_1_c_syntax.pdf',
          storageUrl:
              'https://cdn.csse-study-hub.org/academic/year_1/sem_1_1/c_prog/unit_1_c_syntax.pdf',
          fileSizeBytes: 2457600, // 2.4 MB
          pageCount: 32,
          lastUpdated: DateTime(2026, 1, 15),
          difficultyLevel: 'Beginner',
          version: '1.0',
          sourceProvider: 'JNTUH Academic Council',
          whatIsThis:
              'Introductory notes covering C programming foundation, variable declarations, and loops.',
          whyUseIt:
              'Essential reading for 1st-year students before writing C code in laboratory sessions.',
          tags: ['C Programming', 'Variables', 'Loops', 'Lecture Notes'],
        ),
        // 1-1 Semester: C Programming PYQ Bank
        ResourceModel(
          id: 'pdf_c_prog_pyq_2023_2025',
          title: 'C Programming Solved PYQs (2022 - 2025)',
          description:
              'Previous year university examination questions with step-by-step solved C programs and answer keys.',
          subjectId: 'subj_1_1_4',
          subjectName: 'Computer Programming Using C',
          yearId: 'year_1',
          semesterId: 'sem_1_1',
          resourceType: 'Previous Papers',
          sectionType: 'Previous Year Questions',
          chapterId: 'all_units',
          sectionId: 'pyq_bank',
          storagePath: 'academic/year_1/sem_1_1/c_prog/c_prog_pyq_bank.pdf',
          storageUrl:
              'https://cdn.csse-study-hub.org/academic/year_1/sem_1_1/c_prog/c_prog_pyq_bank.pdf',
          fileSizeBytes: 4194304, // 4.0 MB
          pageCount: 48,
          lastUpdated: DateTime(2026, 2, 10),
          difficultyLevel: 'Beginner',
          version: '2.0',
          sourceProvider: 'University Examination Cell',
          whatIsThis:
              '3-year solved question paper collection for C programming exams.',
          whyUseIt:
              'Helps students identify high-frequency exam questions and scoring patterns.',
          tags: ['C Programming', 'PYQs', 'Exam Papers', 'Solutions'],
        ),
        // 2-1 Semester: Data Structures Lecture Notes
        ResourceModel(
          id: 'pdf_ds_unit2_linked_list',
          title: 'Unit 2: Singly, Doubly & Circular Linked Lists',
          description:
              'Detailed structural notes on pointer memory allocation, linked list node insertion, deletion, and LRU cache.',
          subjectId: 'subj_2_1_1',
          subjectName: 'Data Structures',
          yearId: 'year_2',
          semesterId: 'sem_2_1',
          resourceType: 'Lecture Notes',
          sectionType: 'Unit Notes',
          chapterId: 'unit_2',
          sectionId: 'topic_linked_list',
          storagePath: 'academic/year_2/sem_2_1/ds/unit2_linked_lists.pdf',
          storageUrl:
              'https://cdn.csse-study-hub.org/academic/year_2/sem_2_1/ds/unit2_linked_lists.pdf',
          fileSizeBytes: 3145728, // 3.0 MB
          pageCount: 40,
          lastUpdated: DateTime(2026, 1, 20),
          difficultyLevel: 'Intermediate',
          version: '1.2',
          sourceProvider: 'IIT Madras NPTEL Notes',
          whatIsThis:
              'Complete conceptual and code walkthrough of dynamic linked data structures.',
          whyUseIt:
              'Crucial for 2nd-year CSE students preparing for data structure lab exams and coding interviews.',
          tags: ['Data Structures', 'Linked Lists', 'Pointers', 'Lab Manual'],
        ),
        // 2-1 Semester: Operating Systems Reference Book
        ResourceModel(
          id: 'pdf_os_textbook_galvin',
          title: 'Operating System Concepts (Silberschatz & Galvin)',
          description:
              'Standard reference textbook covering process management, CPU scheduling, deadlocks, and virtual memory.',
          subjectId: 'subj_2_1_4',
          subjectName: 'Operating Systems',
          yearId: 'year_2',
          semesterId: 'sem_2_1',
          resourceType: 'Textbook',
          sectionType: 'Reference Book',
          chapterId: 'all_units',
          sectionId: 'os_concepts',
          storagePath: 'academic/year_2/sem_2_1/os/os_concepts_galvin.pdf',
          storageUrl:
              'https://cdn.csse-study-hub.org/academic/year_2/sem_2_1/os/os_concepts_galvin.pdf',
          fileSizeBytes: 12582912, // 12 MB
          pageCount: 850,
          lastUpdated: DateTime(2025, 11, 5),
          difficultyLevel: 'Intermediate',
          version: '10.0',
          sourceProvider: 'Wiley Global Higher Education',
          whatIsThis: 'Gold-standard Operating Systems reference textbook.',
          whyUseIt:
              'Provides deep theoretical foundations for OS core algorithms and system design interviews.',
          tags: ['Operating Systems', 'Textbook', 'Processes', 'Deadlocks'],
        ),
        // 3-1 Semester: Computer Networks Lab Manual
        ResourceModel(
          id: 'pdf_cn_lab_manual',
          title: 'Computer Networks Socket Programming Lab Manual',
          description:
              'Step-by-step experiment guide for Wireshark packet capture, TCP 3-way handshake, and C socket programming.',
          subjectId: 'subj_3_1_1',
          subjectName: 'Data Communication & Computer Networks',
          yearId: 'year_3',
          semesterId: 'sem_3_1',
          resourceType: 'Lab Manual',
          sectionType: 'Lab Manual',
          chapterId: 'unit_3',
          sectionId: 'socket_programming',
          storagePath: 'academic/year_3/sem_3_1/cn/cn_lab_manual.pdf',
          storageUrl:
              'https://cdn.csse-study-hub.org/academic/year_3/sem_3_1/cn/cn_lab_manual.pdf',
          fileSizeBytes: 1835008, // 1.75 MB
          pageCount: 24,
          lastUpdated: DateTime(2026, 2, 1),
          difficultyLevel: 'Intermediate',
          version: '1.0',
          sourceProvider: 'CSSED Department Labs',
          whatIsThis:
              'Hands-on practical guide for network protocol experiments.',
          whyUseIt:
              'Required for completing semester lab assignments and viva voce examination.',
          tags: ['Computer Networks', 'Wireshark', 'Sockets', 'Lab Manual'],
        ),
        // 1-1 Semester: C Programming Unit 4 Notes (Coming Soon Example)
        ResourceModel(
          id: 'pdf_c_prog_unit4_coming_soon',
          title: 'Unit 4: Dynamic Memory Allocation & File I/O Notes',
          description:
              'Upcoming comprehensive notes on malloc, free, pointer arithmetic, and binary file streams.',
          subjectId: 'subj_1_1_4',
          subjectName: 'Computer Programming Using C',
          yearId: 'year_1',
          semesterId: 'sem_1_1',
          resourceType: 'Lecture Notes',
          sectionType: 'Unit Notes',
          chapterId: 'unit_4',
          sectionId: 'topic_file_io',
          storagePath: 'academic/year_1/sem_1_1/c_prog/unit_4_file_io.pdf',
          storageUrl:
              'https://cdn.csse-study-hub.org/academic/year_1/sem_1_1/c_prog/unit_4_file_io.pdf',
          fileSizeBytes: 0,
          pageCount: 0,
          lastUpdated: DateTime(2026, 2, 12),
          difficultyLevel: 'Intermediate',
          version: '0.9',
          sourceProvider: 'CSSED Department Notes',
          availabilityStatus: 'coming_soon',
          whatIsThis:
              'Notes for this unit are currently being formatted and proofread.',
          whyUseIt:
              'Will provide clear code examples for file operations in C.',
          tags: ['C Programming', 'Pointers', 'File I/O', 'Coming Soon'],
        ),
        // 2-1 Semester: Official Kernel Documentation (External Copyright Safe Example)
        ResourceModel(
          id: 'pdf_os_official_docs_kernel',
          title: 'Official Linux Kernel Development & Process Scheduling Docs',
          description:
              'Official Linux kernel documentation for process memory mapping and Completely Fair Scheduler (CFS).',
          subjectId: 'subj_2_1_4',
          subjectName: 'Operating Systems',
          yearId: 'year_2',
          semesterId: 'sem_2_1',
          resourceType: 'Official Documentation',
          sectionType: 'Official Documentation',
          chapterId: 'unit_3',
          sectionId: 'kernel_scheduler',
          storagePath: '',
          storageUrl:
              'https://www.kernel.org/doc/html/latest/scheduler/sched-design-CFS.html',
          fileSizeBytes: 0,
          pageCount: 0,
          lastUpdated: DateTime(2026, 1, 30),
          difficultyLevel: 'Advanced',
          version: '6.8',
          sourceProvider: 'Linux Kernel Organization',
          isOfficial: true,
          copyrightTier: 'external_copyrighted',
          isDownloadable: false,
          whatIsThis:
              'Official reference documentation maintained by kernel core developers.',
          whyUseIt:
              'Deep-dive reference for understanding real-world operating system schedulers.',
          tags: ['Linux', 'Kernel', 'OS', 'Official Docs'],
        ),
      ];
}

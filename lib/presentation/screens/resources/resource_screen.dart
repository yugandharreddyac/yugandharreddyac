import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/subject_model.dart';
import '../../../data/models/textbook_model.dart';
import '../../../data/models/resource_model.dart';
import '../../providers/study_provider.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/resource_card.dart';
import '../../widgets/shimmer_loading.dart';
import '../../widgets/empty_state_widget.dart';

class ResourceScreen extends StatefulWidget {
  final String subjectId;
  final String subjectName;
  final int? initialSectionIndex;

  const ResourceScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
    this.initialSectionIndex,
  });

  @override
  State<ResourceScreen> createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  late int _selectedSectionIndex;
  String _selectedYearFilter = 'All';

  final List<Map<String, dynamic>> _subjectSections = const [
    {
      'index': 0,
      'title': 'Syllabus',
      'icon': Icons.assignment_outlined,
      'badge': 'Curriculum'
    },
    {
      'index': 1,
      'title': 'Notes',
      'icon': Icons.menu_book_rounded,
      'badge': 'Core'
    },
    {
      'index': 2,
      'title': 'Previous Papers',
      'icon': Icons.description_rounded,
      'badge': 'PYQs'
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedSectionIndex = _mapInitialIndex(widget.initialSectionIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<StudyProvider>();
      provider.fetchResources(widget.subjectId);
      provider.fetchCourseOverview(widget.subjectId);
      provider.fetchTextbookChapters(widget.subjectId);
    });
  }

  int _mapInitialIndex(int? inputIndex) {
    if (inputIndex == null) return 0;
    if (inputIndex == 0) return 0; // Syllabus
    if (inputIndex == 1) return 1; // Notes
    if (inputIndex == 2 || inputIndex == 3) return 2; // Previous Papers
    return 0; // Default fallback
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final studyProvider = context.watch<StudyProvider>();

    SubjectModel? currentSubject;
    try {
      currentSubject =
          studyProvider.subjects.firstWhere((s) => s.id == widget.subjectId);
    } catch (_) {}

    final overview = studyProvider.courseOverview;
    final chapters = studyProvider.textbookChapters;
    final allResources = studyProvider.resources;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF4F4F5);
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE4E4E7);
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : const Color(0xFF09090B);
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : const Color(0xFF71717A);
    const orangeAccent = AppColors.primary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar(
        title: widget.subjectName,
        subtitle: 'Syllabus • Notes • Previous Papers',
      ),
      body: Column(
        children: [
          // Header Summary Card
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: orangeAccent.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.school_rounded,
                      color: orangeAccent, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.subjectName,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Code: ${currentSubject?.code ?? widget.subjectId} • ${currentSubject?.credits ?? 4} Credits',
                        style: TextStyle(
                            color: textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3-Tab Filter Bar
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              itemCount: _subjectSections.length,
              itemBuilder: (context, index) {
                final sec = _subjectSections[index];
                final isSelected = _selectedSectionIndex == sec['index'];

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    avatar: Icon(
                      sec['icon'] as IconData,
                      size: 16,
                      color: isSelected ? Colors.white : textSecondary,
                    ),
                    label: Text(
                      sec['title'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: orangeAccent,
                    backgroundColor: cardBg,
                    side: BorderSide(
                      color: isSelected ? orangeAccent : borderColor,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedSectionIndex = sec['index'] as int;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),

          // Tab Section Content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _buildSectionContent(
                _selectedSectionIndex,
                studyProvider,
                overview,
                chapters,
                allResources,
                cardBg,
                borderColor,
                textPrimary,
                textSecondary,
                isDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent(
    int sectionIndex,
    StudyProvider provider,
    CourseOverviewModel? overview,
    List<TextbookChapterModel> chapters,
    List<ResourceModel> allResources,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    switch (sectionIndex) {
      case 0:
        return _buildSyllabusTab(provider, overview, cardBg, borderColor,
            textPrimary, textSecondary, isDark);
      case 1:
        return _buildNotesTab(provider, chapters, cardBg, borderColor,
            textPrimary, textSecondary, isDark);
      case 2:
        return _buildPreviousPapersTab(provider, allResources, cardBg,
            borderColor, textPrimary, textSecondary, isDark);
      default:
        return _buildSyllabusTab(provider, overview, cardBg, borderColor,
            textPrimary, textSecondary, isDark);
    }
  }

  // 1. SYLLABUS TAB
  Widget _buildSyllabusTab(
    StudyProvider provider,
    CourseOverviewModel? overview,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    if (provider.isLoading) {
      return const ShimmerListLoading();
    }

    final syllabusPdfs = provider.resources.where((r) {
      final t =
          (r.resourceType + (r.sectionType ?? '') + r.title).toLowerCase();
      return t.contains('syllabus') || t.contains('curriculum');
    }).toList();

    if ((overview == null || overview.description.isEmpty) &&
        syllabusPdfs.isEmpty) {
      return const EmptyStateWidget(
        title: 'No syllabus available yet.',
        message:
            'Syllabus details and official curriculum documents for this subject will appear here.',
        icon: Icons.assignment_outlined,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (overview != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Syllabus & Course Curriculum',
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  overview.description,
                  style: TextStyle(
                      color: textSecondary, fontSize: 14, height: 1.5),
                ),
                if (overview.prerequisites.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text('Prerequisites',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textPrimary)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: overview.prerequisites
                        .map((p) => Chip(
                              label: Text(p,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500)),
                              backgroundColor:
                                  AppColors.primary.withOpacity(0.12),
                              side: const BorderSide(color: AppColors.primary),
                            ))
                        .toList(),
                  ),
                ],
                if (overview.learningObjectives.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text('Learning Objectives',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textPrimary)),
                  const SizedBox(height: 6),
                  ...overview.learningObjectives.map((obj) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold)),
                            Expanded(
                                child: Text(obj,
                                    style: TextStyle(
                                        color: textSecondary,
                                        fontSize: 13,
                                        height: 1.4))),
                          ],
                        ),
                      )),
                ],
                if (overview.learningOutcomes.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text('Course Outcomes',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textPrimary)),
                  const SizedBox(height: 6),
                  ...overview.learningOutcomes.map((out) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline,
                                size: 16, color: Colors.green),
                            const SizedBox(width: 6),
                            Expanded(
                                child: Text(out,
                                    style: TextStyle(
                                        color: textSecondary,
                                        fontSize: 13,
                                        height: 1.4))),
                          ],
                        ),
                      )),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (syllabusPdfs.isNotEmpty) ...[
          Text('Official Syllabus Documents & PDFs',
              style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textPrimary)),
          const SizedBox(height: 10),
          ...syllabusPdfs.map((res) => ResourceCard(
                resource: res,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.pdfViewer,
                    arguments: res,
                  );
                },
              )),
        ],
      ],
    );
  }

  // 2. NOTES TAB (RENAMED FROM TEXTBOOK)
  Widget _buildNotesTab(
    StudyProvider provider,
    List<TextbookChapterModel> chapters,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    if (provider.isLoading) {
      return const ShimmerListLoading();
    }

    final notesPdfs = provider.resources.where((r) {
      final t =
          (r.resourceType + (r.sectionType ?? '') + r.title).toLowerCase();
      return t.contains('note') ||
          t.contains('material') ||
          t.contains('lecture');
    }).toList();

    if (chapters.isEmpty && notesPdfs.isEmpty) {
      return const EmptyStateWidget(
        title: 'No notes available yet.',
        message:
            'Chapter notes, section explanations, and lecture study material for this subject will appear here.',
        icon: Icons.menu_book_rounded,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (chapters.isNotEmpty) ...[
          Text('Interactive Course Modules',
              style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textPrimary)),
          const SizedBox(height: 10),
          ...chapters.map((ch) => Card(
                color: cardBg,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: borderColor),
                ),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    child: Text(
                      '${ch.chapterNumber}',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    'Chapter ${ch.chapterNumber}: ${ch.title}',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: textPrimary),
                  ),
                  subtitle: Text(
                    '${ch.sections.length} Sections • ${ch.description}',
                    style: TextStyle(color: textSecondary, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  children: ch.sections.map((sec) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          '${sec.sectionNumber} ${sec.title}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: textPrimary),
                        ),
                        children: sec.topics.map((top) {
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 2),
                            leading: const Icon(Icons.topic_outlined,
                                size: 18, color: AppColors.primary),
                            title: Text(
                              '${top.topicNumber} ${top.title}',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: textPrimary),
                            ),
                            trailing: const Icon(Icons.chevron_right,
                                size: 18, color: AppColors.primary),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.topicDetail,
                                arguments: {
                                  'topic': top,
                                  'subjectName': widget.subjectName,
                                  'chapterTitle':
                                      'Chapter ${ch.chapterNumber}: ${ch.title}',
                                  'sectionTitle':
                                      '${sec.sectionNumber} ${sec.title}',
                                },
                              );
                            },
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              )),
        ],
        if (notesPdfs.isNotEmpty) ...[
          if (chapters.isNotEmpty) const SizedBox(height: 16),
          Text('PDF Notes & Materials',
              style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textPrimary)),
          const SizedBox(height: 10),
          ...notesPdfs.map((res) => ResourceCard(
                resource: res,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.pdfViewer,
                    arguments: res,
                  );
                },
              )),
        ],
      ],
    );
  }

  // 3. PREVIOUS PAPERS TAB
  Widget _buildPreviousPapersTab(
    StudyProvider provider,
    List<ResourceModel> allResources,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    if (provider.isLoading) {
      return const ShimmerListLoading();
    }

    final paperResources = allResources.where((r) {
      final t =
          (r.resourceType + (r.sectionType ?? '') + r.title).toLowerCase();
      return t.contains('previous') ||
          t.contains('pyq') ||
          t.contains('paper') ||
          t.contains('exam');
    }).toList();

    final filteredPapers = paperResources.where((r) {
      if (_selectedYearFilter == 'All') return true;
      return r.yearId.contains(_selectedYearFilter) ||
          r.title.contains(_selectedYearFilter);
    }).toList();

    if (paperResources.isEmpty) {
      return const EmptyStateWidget(
        title: 'No previous papers available yet.',
        message:
            'Mid-term, end-term, and university question papers for this subject will appear here.',
        icon: Icons.description_rounded,
      );
    }

    return Column(
      children: [
        // Year Filter Chips Bar
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text('Filter Year: ',
                  style: TextStyle(
                      color: textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
              const SizedBox(width: 8),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ['All', '2025', '2024', '2023'].map((yr) {
                    final isSel = _selectedYearFilter == yr;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(yr,
                            style: TextStyle(
                                color: isSel ? Colors.black : textPrimary,
                                fontSize: 12,
                                fontWeight: isSel
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                        selected: isSel,
                        selectedColor: AppColors.primary,
                        backgroundColor: cardBg,
                        onSelected: (_) =>
                            setState(() => _selectedYearFilter = yr),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: filteredPapers.isEmpty
              ? EmptyStateWidget(
                  title: 'No $_selectedYearFilter question papers found.',
                  message:
                      'Try switching the year filter to view available examination papers.',
                  icon: Icons.filter_alt_off_rounded,
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredPapers.length,
                  itemBuilder: (context, index) {
                    final res = filteredPapers[index];
                    return ResourceCard(
                      resource: res,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.pdfViewer,
                          arguments: res,
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

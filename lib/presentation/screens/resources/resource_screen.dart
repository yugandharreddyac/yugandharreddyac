import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/subject_model.dart';
import '../../../data/models/textbook_model.dart';
import '../../../data/models/resource_model.dart';
import '../../../data/datasources/academic_resource_catalog.dart';
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

  final List<Map<String, dynamic>> _subjectSections = const [
    {'index': 0, 'title': 'Course Overview', 'icon': Icons.info_outline_rounded, 'badge': 'Overview'},
    {'index': 1, 'title': 'Textbook', 'icon': Icons.menu_book_rounded, 'badge': 'Core'},
    {'index': 2, 'title': 'Important Questions', 'icon': Icons.quiz_rounded, 'badge': 'Exam'},
    {'index': 3, 'title': 'Previous Papers', 'icon': Icons.description_rounded, 'badge': 'Past'},
    {'index': 4, 'title': 'Quick Revision', 'icon': Icons.bolt_rounded, 'badge': 'Notes'},
    {'index': 5, 'title': 'Practical / Lab', 'icon': Icons.science_rounded, 'badge': 'Labs'},
    {'index': 6, 'title': 'Assignments', 'icon': Icons.assignment_turned_in_rounded, 'badge': 'Tasks'},
    {'index': 7, 'title': 'Projects', 'icon': Icons.folder_special_rounded, 'badge': 'Build'},
    {'index': 8, 'title': 'Additional Resources', 'icon': Icons.link_rounded, 'badge': 'Links'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedSectionIndex = widget.initialSectionIndex ?? 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<StudyProvider>();
      provider.fetchResources(widget.subjectId);
      provider.fetchCourseOverview(widget.subjectId);
      provider.fetchTextbookChapters(widget.subjectId);
      provider.fetchImportantQuestions(widget.subjectId);
      provider.fetchQuickRevisionNotes(widget.subjectId);
      provider.fetchLabExperiments(widget.subjectId);
      provider.fetchAcademicProjects(widget.subjectId);
      provider.fetchAdditionalResources(widget.subjectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final studyProvider = context.watch<StudyProvider>();

    SubjectModel? currentSubject;
    try {
      currentSubject = studyProvider.subjects.firstWhere((s) => s.id == widget.subjectId);
    } catch (_) {}

    final overview = studyProvider.courseOverview;
    final chapters = studyProvider.textbookChapters;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final textSecondary = isDark ? AppColors.textSecondaryDark : const Color(0xFF475569);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar(
        title: widget.subjectName,
        subtitle: 'Complete Academic Textbook & Learning System',
      ),
      body: Column(
        children: [
          // Header Summary Card
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.school_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.subjectName,
                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                currentSubject != null ? '${currentSubject.code} • ${currentSubject.creditHours} Credits' : 'Academic Core Subject',
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                              const Spacer(),
                              if (overview != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.cyanAccent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(overview.estimatedStudyTime, style: const TextStyle(color: Colors.cyanAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Progress Bar
                const Row(
                  children: [
                    Text('Subject Progress:', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
                    Spacer(),
                    Text('45% Completed', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const LinearProgressIndicator(
                    value: 0.45,
                    minHeight: 6,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
                  ),
                ),
              ],
            ),
          ),

          // Standardized 8-Section Horizontal Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _subjectSections.map((sec) {
                final idx = sec['index'] as int;
                final isSelected = _selectedSectionIndex == idx;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    avatar: Icon(sec['icon'] as IconData, size: 16, color: isSelected ? Colors.white : AppColors.primary),
                    label: Text('${sec['index']}. ${sec['title']}'),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: cardBg,
                    labelStyle: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : textPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isSelected ? AppColors.primary : borderColor),
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedSectionIndex = idx;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1),

          // Section Content Views
          Expanded(
            child: studyProvider.isLoading
                ? const ShimmerListLoading(itemCount: 4, itemHeight: 120)
                : _buildSectionContent(context, overview, chapters, studyProvider.resources, cardBg, borderColor, textPrimary, textSecondary, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent(
    BuildContext context,
    CourseOverviewModel? overview,
    List<TextbookChapterModel> chapters,
    List<ResourceModel> rawResources,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    final provider = context.watch<StudyProvider>();

    switch (_selectedSectionIndex) {
      case 0:
        return _buildCourseOverviewTab(overview, cardBg, borderColor, textPrimary, textSecondary, isDark);
      case 1:
        return _buildTextbookTab(context, chapters, cardBg, borderColor, textPrimary, textSecondary, isDark);
      case 2:
        return _buildImportantQuestionsTab(context, provider.importantQuestions, rawResources, cardBg, borderColor, textPrimary, textSecondary, isDark);
      case 3:
        return _buildFilteredResourcesList('Previous Question Papers', 'Mid-term and end-term university past question papers.', rawResources, cardBg, borderColor, textPrimary, textSecondary);
      case 4:
        return _buildQuickRevisionTab(context, provider.quickRevisionNotes, rawResources, cardBg, borderColor, textPrimary, textSecondary, isDark);
      case 5:
        return _buildLabExperimentsTab(context, provider.labExperiments, rawResources, cardBg, borderColor, textPrimary, textSecondary, isDark);
      case 6:
        return _buildFilteredResourcesList('Assignments', 'Homework problem sets and graded assignments.', rawResources, cardBg, borderColor, textPrimary, textSecondary);
      case 7:
        return _buildAcademicProjectsTab(context, provider.academicProjects, rawResources, cardBg, borderColor, textPrimary, textSecondary, isDark);
      case 8:
      default:
        return _buildAdditionalResourcesTab(context, provider.additionalResources, rawResources, cardBg, borderColor, textPrimary, textSecondary, isDark);
    }
  }

  // 0. COURSE OVERVIEW TAB
  Widget _buildCourseOverviewTab(CourseOverviewModel? overview, Color cardBg, Color borderColor, Color textPrimary, Color textSecondary, bool isDark) {
    if (overview == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCardHeader('Subject Overview', Icons.info_outline_rounded),
        const SizedBox(height: 8),
        _buildCard(cardBg, borderColor, child: Text(overview.description, style: TextStyle(color: textPrimary, fontSize: 14, height: 1.5))),

        const SizedBox(height: 18),
        _buildCardHeader('Why This Subject Matters', Icons.star_outline_rounded),
        const SizedBox(height: 8),
        _buildCard(cardBg, borderColor, child: Text(overview.whyItMatters, style: TextStyle(color: textSecondary, fontSize: 13, height: 1.4))),

        const SizedBox(height: 18),
        _buildCardHeader('Prerequisites', Icons.checklist_rtl_rounded),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: overview.prerequisites.map((p) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? AppColors.primary.withOpacity(0.18) : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Text(p, style: TextStyle(color: isDark ? Colors.cyanAccent : AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
            );
          }).toList(),
        ),

        const SizedBox(height: 18),
        _buildCardHeader('Learning Objectives', Icons.track_changes_rounded),
        const SizedBox(height: 8),
        _buildBulletCard(overview.learningObjectives, cardBg, borderColor, textPrimary),

        const SizedBox(height: 18),
        _buildCardHeader('Expected Learning Outcomes', Icons.verified_rounded),
        const SizedBox(height: 8),
        _buildBulletCard(overview.learningOutcomes, cardBg, borderColor, textPrimary),
      ],
    );
  }

  // 1. TEXTBOOK TAB (Table of Contents Node Tree)
  Widget _buildTextbookTab(BuildContext context, List<TextbookChapterModel> chapters, Color cardBg, Color borderColor, Color textPrimary, Color textSecondary, bool isDark) {
    if (chapters.isEmpty) {
      return EmptyStateWidget(
        title: 'Textbook Chapters Coming Soon',
        message: 'Formal chapters for ${widget.subjectName} are currently being structured.',
        onActionTap: () => context.read<StudyProvider>().fetchTextbookChapters(widget.subjectId),
        actionLabel: 'Refresh',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Row(
          children: [
            Icon(Icons.format_list_bulleted_rounded, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('TABLE OF CONTENTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 4),
        Text('Tap any chapter or section to view formal topics and mini-lessons.', style: TextStyle(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 14),

        ...chapters.map((ch) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: ExpansionTile(
              initiallyExpanded: ch.chapterNumber == 1,
              leading: CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primary,
                child: Text('${ch.chapterNumber}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              title: Text('Chapter ${ch.chapterNumber}: ${ch.title}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
              subtitle: Text(ch.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: textSecondary)),
              children: ch.sections.map((sec) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.subdirectory_arrow_right_rounded, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text('${sec.sectionNumber} ${sec.title}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: textPrimary)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...sec.topics.map((top) {
                        return Container(
                          margin: const EdgeInsets.only(left: 20, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderColor),
                          ),
                          child: ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            leading: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(top.topicNumber, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            ),
                            title: Text(top.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: textPrimary)),
                            subtitle: Text(top.definition, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10.5, color: textSecondary)),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primary),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.topicDetail,
                                arguments: {
                                  'topic': top,
                                  'subjectName': widget.subjectName,
                                  'chapterTitle': 'Chapter ${ch.chapterNumber}',
                                  'sectionTitle': '${sec.sectionNumber} ${sec.title}',
                                },
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  // 2. IMPORTANT QUESTIONS TAB
  Widget _buildImportantQuestionsTab(
    BuildContext context,
    List<AcademicQuestionModel> questions,
    List<ResourceModel> rawResources,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    if (questions.isEmpty) {
      return _buildFilteredResourcesList('Important Questions', 'Exam preparation question bank.', rawResources, cardBg, borderColor, textPrimary, textSecondary);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Row(
          children: [
            Icon(Icons.quiz_rounded, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('CHAPTER-WISE IMPORTANT QUESTIONS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 4),
        Text('Curated university exam questions categorized by probability and depth.', style: TextStyle(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 14),

        ...questions.map((q) {
          final isHighPriority = q.category == 'High Priority';
          final badgeColor = isHighPriority ? Colors.redAccent : AppColors.primary;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isHighPriority ? Colors.redAccent.withAlpha(120) : borderColor),
            ),
            child: ExpansionTile(
              leading: CircleAvatar(
                radius: 14,
                backgroundColor: badgeColor.withAlpha(30),
                child: Text('Ch${q.chapterNumber}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeColor)),
              ),
              title: Text(q.question, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: textPrimary)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Chip(
                      label: Text(q.category, style: TextStyle(fontSize: 10, color: badgeColor, fontWeight: FontWeight.bold)),
                      backgroundColor: badgeColor.withAlpha(20),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('MODEL ANSWER / SOLUTION:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary, letterSpacing: 0.5)),
                        const SizedBox(height: 6),
                        Text(q.answer, style: TextStyle(fontSize: 12.5, color: textPrimary, height: 1.45)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // 4. QUICK REVISION TAB
  Widget _buildQuickRevisionTab(
    BuildContext context,
    List<QuickRevisionModel> revisionNotes,
    List<ResourceModel> rawResources,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    if (revisionNotes.isEmpty) {
      return _buildFilteredResourcesList('Quick Revision Notes', 'Bite-sized revision notes and formula sheets.', rawResources, cardBg, borderColor, textPrimary, textSecondary);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Row(
          children: [
            Icon(Icons.bolt_rounded, color: Colors.amber, size: 20),
            SizedBox(width: 8),
            Text('QUICK REVISION & CHEAT-SHEETS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 4),
        Text('Fast last-minute definitions, key formulas, and exam review notes.', style: TextStyle(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 14),

        ...revisionNotes.map((rev) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rev.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
                const SizedBox(height: 10),
                if (rev.keyDefinitions.isNotEmpty) ...[
                  const Text('Key Definitions:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: AppColors.primary)),
                  const SizedBox(height: 4),
                  ...rev.keyDefinitions.map((d) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('• $d', style: TextStyle(fontSize: 12, color: textPrimary, height: 1.35)),
                      )),
                  const SizedBox(height: 8),
                ],
                if (rev.formulas.isNotEmpty) ...[
                  const Text('Formulas & Rules:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: Colors.amber)),
                  const SizedBox(height: 4),
                  ...rev.formulas.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('⚡ $f', style: TextStyle(fontSize: 12, color: isDark ? Colors.amberAccent : Colors.orange, fontWeight: FontWeight.bold)),
                      )),
                  const SizedBox(height: 8),
                ],
                if (rev.lastMinutePoints.isNotEmpty) ...[
                  const Text('Last-Minute Exam Points:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: Color(0xFF10B981))),
                  const SizedBox(height: 4),
                  ...rev.lastMinutePoints.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('✓ $p', style: TextStyle(fontSize: 12, color: textSecondary, height: 1.35)),
                      )),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  // 5. PRACTICAL / LAB TAB
  Widget _buildLabExperimentsTab(
    BuildContext context,
    List<LabExperimentModel> labExperiments,
    List<ResourceModel> rawResources,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    if (labExperiments.isEmpty) {
      return _buildFilteredResourcesList('Practical / Laboratory', 'Lab experiments, manual codes, and viva questions.', rawResources, cardBg, borderColor, textPrimary, textSecondary);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Row(
          children: [
            Icon(Icons.science_rounded, color: Colors.purpleAccent, size: 20),
            SizedBox(width: 8),
            Text('PRACTICAL LAB EXPERIMENTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 4),
        Text('Official curriculum lab experiments complete with procedure, Python code, and viva Q&A.', style: TextStyle(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 14),

        ...labExperiments.map((lab) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: ExpansionTile(
              leading: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.purpleAccent.withAlpha(30),
                child: Text('${lab.experimentNumber}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purpleAccent)),
              ),
              title: Text('Exp ${lab.experimentNumber}: ${lab.title}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
              subtitle: Text(lab.objective, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: textSecondary)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('OBJECTIVE:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.purpleAccent)),
                      Text(lab.objective, style: TextStyle(fontSize: 12.5, color: textPrimary)),
                      const SizedBox(height: 10),
                      const Text('THEORY:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary)),
                      Text(lab.theory, style: TextStyle(fontSize: 12.5, color: textSecondary, height: 1.35)),
                      const SizedBox(height: 10),
                      const Text('PYTHON CODE IMPLEMENTATION:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.amber)),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(lab.code, style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: Colors.greenAccent, height: 1.4)),
                      ),
                      const SizedBox(height: 10),
                      const Text('EXPECTED OUTPUT:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.cyanAccent)),
                      Text(lab.expectedOutput, style: TextStyle(fontSize: 12, color: textPrimary)),
                      if (lab.vivaQuestions.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        const Text('PRACTICAL VIVA QUESTIONS:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.redAccent)),
                        ...lab.vivaQuestions.map((v) => Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text('❓ $v', style: TextStyle(fontSize: 12, color: textPrimary)),
                            )),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // 7. ACADEMIC PROJECTS TAB
  Widget _buildAcademicProjectsTab(
    BuildContext context,
    List<AcademicProjectModel> projects,
    List<ResourceModel> rawResources,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    if (projects.isEmpty) {
      return _buildFilteredResourcesList('Projects', 'Subject mini & major practical project ideas.', rawResources, cardBg, borderColor, textPrimary, textSecondary);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Row(
          children: [
            Icon(Icons.folder_special_rounded, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('SUBJECT ACADEMIC PROJECTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 4),
        Text('Curriculum mini-projects directly aligned with syllabus concepts.', style: TextStyle(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 14),

        ...projects.map((proj) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(proj.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimary))),
                    Chip(label: Text(proj.difficulty, style: const TextStyle(fontSize: 10)), backgroundColor: AppColors.primary.withAlpha(25)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(proj.description, style: TextStyle(fontSize: 12.5, color: textSecondary, height: 1.4)),
                const SizedBox(height: 10),
                const Text('Architecture & Approach:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary)),
                Text(proj.architecture, style: TextStyle(fontSize: 12, color: textPrimary)),
                if (proj.sourceCodeUrl != null) ...[
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse(proj.sourceCodeUrl!);
                      if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                    icon: const Icon(Icons.code_rounded, size: 16),
                    label: const Text('View Project Repository', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  // 8. ADDITIONAL RESOURCES TAB
  Widget _buildAdditionalResourcesTab(
    BuildContext context,
    List<ExternalResourceModel> externalResources,
    List<ResourceModel> rawResources,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    if (externalResources.isEmpty) {
      return _buildFilteredResourcesList('Additional Resources', 'Reference web links and video tutorials.', rawResources, cardBg, borderColor, textPrimary, textSecondary);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Row(
          children: [
            Icon(Icons.link_rounded, color: Colors.blueAccent, size: 20),
            SizedBox(width: 8),
            Text('CURATED VERIFIED EXTERNAL LEARNING LINKS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 4),
        Text('Hand-curated, authoritative external references (GeeksforGeeks, W3Schools, roadmap.sh, official docs).', style: TextStyle(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 14),

        ...externalResources.map((ext) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.open_in_new_rounded, color: Colors.blueAccent, size: 18),
              ),
              title: Row(
                children: [
                  Expanded(child: Text(ext.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: textPrimary))),
                  if (ext.isVerified)
                    const Icon(Icons.verified_rounded, color: Colors.blueAccent, size: 16),
                ],
              ),
              subtitle: Text(ext.description, style: TextStyle(fontSize: 11.5, color: textSecondary)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey),
              onTap: () async {
                final uri = Uri.parse(ext.url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          );
        }),
      ],
    );
  }

  // RESOURCE LIST FOR OTHER SECTIONS (3 & 6 & GENERAL)
  Widget _buildFilteredResourcesList(
    String sectionTitle,
    String description,
    List<ResourceModel> rawResources,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    final catalogResources = AcademicResourceCatalog.getResourcesForSubject(widget.subjectId);
    final combinedMap = <String, ResourceModel>{};

    for (final res in catalogResources) {
      combinedMap[res.id] = res;
    }
    for (final res in rawResources) {
      combinedMap[res.id] = res;
    }
    final allResources = combinedMap.values.toList();

    final recommended = AcademicResourceCatalog.getRecommendedResource(widget.subjectId);

    if (allResources.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.picture_as_pdf_outlined, size: 54, color: Colors.orange),
            const SizedBox(height: 14),
            Text(
              'No PDF Added Yet for $sectionTitle',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'No PDF file has been uploaded for this unit yet. You can still continue learning using these recommended alternative options:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: textSecondary, height: 1.4),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => setState(() => _selectedSectionIndex = 1),
                  icon: const Icon(Icons.menu_book_rounded, size: 16),
                  label: const Text('Read Textbook'),
                ),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _selectedSectionIndex = 4),
                  icon: const Icon(Icons.bolt_rounded, size: 16),
                  label: const Text('Quick Revision'),
                ),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _selectedSectionIndex = 8),
                  icon: const Icon(Icons.link_rounded, size: 16),
                  label: const Text('External Web Links'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (recommended != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.amber.shade400),
            ),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '⭐ RECOMMENDED FOR YOU / START HERE',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF92400E), letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Top beginner-friendly resource recommended for ${widget.subjectName}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF78350F)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ResourceCard(
            resource: recommended,
            index: 0,
            onTap: () async {
              Navigator.pushNamed(
                context,
                AppRoutes.pdfViewer,
                arguments: recommended,
              );
            },
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Icon(Icons.folder_copy_rounded, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text('ALL SUBJECT RESOURCES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
            ],
          ),
          const SizedBox(height: 10),
        ],

        ...allResources.where((r) => r.id != recommended?.id).map((res) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ResourceCard(
              resource: res,
              index: allResources.indexOf(res),
              onTap: () async {
                if (res.videoUrl != null && res.videoUrl!.isNotEmpty) {
                  final Uri uri = Uri.parse(res.videoUrl!);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                } else {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.pdfViewer,
                    arguments: res,
                  );
                }
              },
            ),
          );
        }),
      ],
    );
  }

  // HELPER WIDGETS
  Widget _buildCardHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildCard(Color cardBg, Color borderColor, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }

  Widget _buildBulletCard(List<String> items, Color cardBg, Color borderColor, Color textPrimary) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 3, backgroundColor: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(item, style: TextStyle(fontSize: 12.5, color: textPrimary, height: 1.35))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

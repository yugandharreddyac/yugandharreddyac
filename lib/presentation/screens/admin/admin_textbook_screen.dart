import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/year_model.dart';
import '../../../data/models/semester_model.dart';
import '../../../data/models/subject_model.dart';
import '../../../data/models/textbook_model.dart';
import '../../providers/study_provider.dart';
import '../../widgets/custom_app_bar.dart';

class AdminTextbookScreen extends StatefulWidget {
  const AdminTextbookScreen({super.key});

  @override
  State<AdminTextbookScreen> createState() => _AdminTextbookScreenState();
}

class _AdminTextbookScreenState extends State<AdminTextbookScreen> {
  YearModel? _selectedYear;
  SemesterModel? _selectedSemester;
  SubjectModel? _selectedSubject;

  List<YearModel> _years = [];
  List<SemesterModel> _semesters = [];
  List<SubjectModel> _subjects = [];

  bool _isLoadingDropdowns = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoadingDropdowns = true);
    final provider = context.read<StudyProvider>();
    final years = await provider.repository.getYears();
    setState(() {
      _years = years;
      if (years.isNotEmpty) {
        _selectedYear = years.first;
      }
    });

    if (_selectedYear != null) {
      await _loadSemesters(_selectedYear!.id);
    } else {
      setState(() => _isLoadingDropdowns = false);
    }
  }

  Future<void> _loadSemesters(String yearId) async {
    final provider = context.read<StudyProvider>();
    final sems = await provider.repository.getSemesters(yearId);
    setState(() {
      _semesters = sems;
      _selectedSemester = sems.isNotEmpty ? sems.first : null;
    });

    if (_selectedSemester != null) {
      await _loadSubjects(_selectedSemester!.id);
    } else {
      setState(() {
        _subjects = [];
        _selectedSubject = null;
        _isLoadingDropdowns = false;
      });
    }
  }

  Future<void> _loadSubjects(String semesterId) async {
    final provider = context.read<StudyProvider>();
    final subjs = await provider.repository.getSubjects(semesterId);
    setState(() {
      _subjects = subjs;
      _selectedSubject = subjs.isNotEmpty ? subjs.first : null;
      _isLoadingDropdowns = false;
    });

    if (_selectedSubject != null) {
      _fetchTextbookContent(_selectedSubject!.id);
    }
  }

  void _fetchTextbookContent(String subjectId) {
    final provider = context.read<StudyProvider>();
    provider.fetchCourseOverview(subjectId);
    provider.fetchTextbookChapters(subjectId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor =
        isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? Colors.white70 : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CustomAppBar(
        title: 'Textbook Manager',
        showBackButton: true,
      ),
      body: _isLoadingDropdowns
          ? const Center(child: CircularProgressIndicator())
          : Consumer<StudyProvider>(
              builder: (context, studyProvider, child) {
                final overview = studyProvider.courseOverview;
                final chapters = studyProvider.textbookChapters;

                int totalSections = 0;
                int totalTopics = 0;
                for (final ch in chapters) {
                  totalSections += ch.sections.length;
                  for (final sec in ch.sections) {
                    totalTopics += sec.topics.length;
                  }
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // 1. Selector Bar (Year -> Semester -> Subject)
                    _buildSelectorCard(
                        cardColor, borderColor, textPrimary, textSecondary),

                    const SizedBox(height: 16),

                    // 2. Metrics Header
                    _buildMetricsHeader(
                        chapters.length,
                        totalSections,
                        totalTopics,
                        cardColor,
                        borderColor,
                        textPrimary,
                        textSecondary),

                    const SizedBox(height: 16),

                    if (_selectedSubject != null) ...[
                      // 3. Course Overview Manager
                      _buildOverviewCard(overview, cardColor, borderColor,
                          textPrimary, textSecondary),

                      const SizedBox(height: 16),

                      // 4. Chapter & Topic Tree Manager
                      _buildChaptersCard(chapters, cardColor, borderColor,
                          textPrimary, textSecondary),
                    ] else
                      Center(
                        child: Text(
                          'Select a subject to manage textbook chapters.',
                          style: TextStyle(color: textSecondary),
                        ),
                      ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildSelectorCard(Color cardColor, Color borderColor,
      Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tune_rounded, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text('SELECT ACADEMIC SUBJECT',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 0.5)),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 600;
              return isNarrow
                  ? Column(
                      children: [
                        _buildYearDropdown(textPrimary),
                        const SizedBox(height: 8),
                        _buildSemesterDropdown(textPrimary),
                        const SizedBox(height: 8),
                        _buildSubjectDropdown(textPrimary),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: _buildYearDropdown(textPrimary)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSemesterDropdown(textPrimary)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSubjectDropdown(textPrimary)),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildYearDropdown(Color textPrimary) {
    return DropdownButtonFormField<YearModel>(
      value: _selectedYear,
      decoration: const InputDecoration(
          labelText: 'Year',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
      items: _years
          .map((y) => DropdownMenuItem(
              value: y,
              child: Text(y.title,
                  style: TextStyle(color: textPrimary, fontSize: 13))))
          .toList(),
      onChanged: (val) {
        if (val != null) {
          setState(() {
            _selectedYear = val;
            _isLoadingDropdowns = true;
          });
          _loadSemesters(val.id);
        }
      },
    );
  }

  Widget _buildSemesterDropdown(Color textPrimary) {
    return DropdownButtonFormField<SemesterModel>(
      value: _selectedSemester,
      decoration: const InputDecoration(
          labelText: 'Semester',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
      items: _semesters
          .map((s) => DropdownMenuItem(
              value: s,
              child: Text(s.title,
                  style: TextStyle(color: textPrimary, fontSize: 13))))
          .toList(),
      onChanged: (val) {
        if (val != null) {
          setState(() {
            _selectedSemester = val;
            _isLoadingDropdowns = true;
          });
          _loadSubjects(val.id);
        }
      },
    );
  }

  Widget _buildSubjectDropdown(Color textPrimary) {
    return DropdownButtonFormField<SubjectModel>(
      value: _selectedSubject,
      decoration: const InputDecoration(
          labelText: 'Subject',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
      items: _subjects
          .map((s) => DropdownMenuItem(
              value: s,
              child: Text(s.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: textPrimary, fontSize: 13))))
          .toList(),
      onChanged: (val) {
        if (val != null) {
          setState(() => _selectedSubject = val);
          _fetchTextbookContent(val.id);
        }
      },
    );
  }

  Widget _buildMetricsHeader(
      int chaptersCount,
      int sectionsCount,
      int topicsCount,
      Color cardColor,
      Color borderColor,
      Color textPrimary,
      Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricBadge('Chapters', '$chaptersCount',
              Icons.bookmark_border_rounded, AppColors.primary),
          _buildMetricBadge('Sections', '$sectionsCount',
              Icons.account_tree_outlined, Colors.amber),
          _buildMetricBadge('Topics', '$topicsCount', Icons.article_outlined,
              Colors.purpleAccent),
        ],
      ),
    );
  }

  Widget _buildMetricBadge(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildOverviewCard(CourseOverviewModel? overview, Color cardColor,
      Color borderColor, Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_outlined,
                  color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              const Text('COURSE OVERVIEW',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 0.5)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showOverviewDialog(overview),
                icon: const Icon(Icons.edit_rounded, size: 14),
                label: Text(
                    overview == null ? 'Create Overview' : 'Edit Overview',
                    style: const TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (overview == null)
            Text(
                'No custom course overview defined yet. Tap "Create Overview" to add syllabus metadata.',
                style: TextStyle(color: textSecondary, fontSize: 12))
          else ...[
            Text(overview.description,
                style: TextStyle(color: textPrimary, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                Chip(
                    label: Text('Difficulty: ${overview.estimatedDifficulty}',
                        style: const TextStyle(fontSize: 11)),
                    backgroundColor: AppColors.primary.withAlpha(20)),
                Chip(
                    label: Text('Time: ${overview.estimatedStudyTime}',
                        style: const TextStyle(fontSize: 11)),
                    backgroundColor: Colors.amber.withAlpha(20)),
                Chip(
                    label: Text(
                        '${overview.prerequisites.length} Prerequisites',
                        style: const TextStyle(fontSize: 11)),
                    backgroundColor: Colors.purple.withAlpha(20)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChaptersCard(
      List<TextbookChapterModel> chapters,
      Color cardColor,
      Color borderColor,
      Color textPrimary,
      Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.format_list_numbered_rounded,
                  color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              const Text('TEXTBOOK CHAPTERS & TOPICS',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 0.5)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showChapterDialog(null, chapters.length + 1),
                icon: const Icon(Icons.add_rounded, size: 16),
                label:
                    const Text('Add Chapter', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (chapters.isEmpty)
            Center(
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                        'No textbook chapters found. Tap "Add Chapter" to build the subject textbook hierarchy.',
                        style: TextStyle(color: textSecondary, fontSize: 12))))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                final ch = chapters[index];
                return _buildChapterTile(ch, index, chapters, cardColor,
                    borderColor, textPrimary, textSecondary);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildChapterTile(
      TextbookChapterModel ch,
      int index,
      List<TextbookChapterModel> allChapters,
      Color cardColor,
      Color borderColor,
      Color textPrimary,
      Color textSecondary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        color: cardColor,
      ),
      child: ExpansionTile(
        title: Text('Chapter ${ch.chapterNumber}: ${ch.title}',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: textPrimary)),
        subtitle: Text('${ch.sections.length} Sections • ${ch.description}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, color: textSecondary)),
        leading: CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.primary.withAlpha(30),
          child: Text('${ch.chapterNumber}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.primary)),
        ),
        childrenPadding: const EdgeInsets.all(12),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_upward_rounded, size: 16),
              onPressed: index > 0
                  ? () => _reorderChapter(index, index - 1, allChapters)
                  : null,
              tooltip: 'Move Up',
            ),
            IconButton(
              icon: const Icon(Icons.arrow_downward_rounded, size: 16),
              onPressed: index < allChapters.length - 1
                  ? () => _reorderChapter(index, index + 1, allChapters)
                  : null,
              tooltip: 'Move Down',
            ),
            IconButton(
              icon: const Icon(Icons.edit_rounded,
                  size: 16, color: Colors.blueAccent),
              onPressed: () => _showChapterDialog(ch, ch.chapterNumber),
              tooltip: 'Edit Chapter',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  size: 16, color: Colors.redAccent),
              onPressed: () => _confirmDeleteChapter(ch),
              tooltip: 'Delete Chapter',
            ),
          ],
        ),
        children: [
          Row(
            children: [
              const Text('SECTIONS',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 0.5,
                      color: Colors.grey)),
              const Spacer(),
              TextButton.icon(
                onPressed: () =>
                    _showSectionDialog(ch, null, ch.sections.length + 1),
                icon: const Icon(Icons.add_rounded, size: 14),
                label:
                    const Text('Add Section', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (ch.sections.isEmpty)
            Text('No sections in this chapter yet.',
                style: TextStyle(color: textSecondary, fontSize: 11))
          else
            ...ch.sections.map((sec) => _buildSectionTile(
                ch, sec, cardColor, borderColor, textPrimary, textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSectionTile(
      TextbookChapterModel ch,
      TextbookSectionModel sec,
      Color cardColor,
      Color borderColor,
      Color textPrimary,
      Color textSecondary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor.withAlpha(100)),
        color: cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${sec.sectionNumber} ${sec.title}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: textPrimary)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded,
                    size: 16, color: AppColors.primary),
                onPressed: () =>
                    _showTopicDialog(ch, sec, null, sec.topics.length + 1),
                tooltip: 'Add Topic',
              ),
              IconButton(
                icon: const Icon(Icons.edit_rounded,
                    size: 15, color: Colors.blueAccent),
                onPressed: () => _showSectionDialog(ch, sec, sec.order),
                tooltip: 'Edit Section',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    size: 15, color: Colors.redAccent),
                onPressed: () => _confirmDeleteSection(ch, sec),
                tooltip: 'Delete Section',
              ),
            ],
          ),
          if (sec.topics.isNotEmpty) ...[
            const SizedBox(height: 6),
            ...sec.topics.map((top) => Padding(
                  padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.article_outlined,
                          size: 14, color: Colors.purpleAccent),
                      const SizedBox(width: 6),
                      Expanded(
                          child: Text('${top.topicNumber} ${top.title}',
                              style:
                                  TextStyle(fontSize: 12, color: textPrimary))),
                      IconButton(
                        icon: const Icon(Icons.edit_rounded,
                            size: 14, color: Colors.blueAccent),
                        onPressed: () =>
                            _showTopicDialog(ch, sec, top, top.order),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            size: 14, color: Colors.redAccent),
                        onPressed: () => _confirmDeleteTopic(ch, sec, top),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  // --- Reordering & Deletion Handlers ---

  void _reorderChapter(
      int oldIndex, int newIndex, List<TextbookChapterModel> chapters) async {
    final List<TextbookChapterModel> updated = List.from(chapters);
    final moved = updated.removeAt(oldIndex);
    updated.insert(newIndex, moved);

    if (_selectedSubject != null) {
      await context
          .read<StudyProvider>()
          .reorderTextbookChapters(_selectedSubject!.id, updated);
    }
  }

  void _confirmDeleteChapter(TextbookChapterModel ch) async {
    int topicCount = 0;
    for (final sec in ch.sections) {
      topicCount += sec.topics.length;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Chapter?'),
        content: Text(
            'This chapter contains ${ch.sections.length} sections and $topicCount topics. Deleting it will permanently remove all associated textbook hierarchy.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white),
            child: const Text('Delete Chapter'),
          ),
        ],
      ),
    );

    if (confirm == true && _selectedSubject != null) {
      if (!mounted) return;
      await context
          .read<StudyProvider>()
          .deleteTextbookChapter(_selectedSubject!.id, ch.id);
    }
  }

  void _confirmDeleteSection(
      TextbookChapterModel ch, TextbookSectionModel sec) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Section?'),
        content: Text(
            'This section contains ${sec.topics.length} topics. Are you sure you want to delete it?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white),
            child: const Text('Delete Section'),
          ),
        ],
      ),
    );

    if (confirm == true && _selectedSubject != null) {
      final updatedSections = ch.sections.where((s) => s.id != sec.id).toList();
      final updatedChapter = ch.copyWith(sections: updatedSections);
      if (!mounted) return;
      await context
          .read<StudyProvider>()
          .saveTextbookChapter(_selectedSubject!.id, updatedChapter);
    }
  }

  void _confirmDeleteTopic(TextbookChapterModel ch, TextbookSectionModel sec,
      TextbookTopicModel top) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Topic?'),
        content: Text('Are you sure you want to delete topic "${top.title}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white),
            child: const Text('Delete Topic'),
          ),
        ],
      ),
    );

    if (confirm == true && _selectedSubject != null) {
      final updatedTopics = sec.topics.where((t) => t.id != top.id).toList();
      final updatedSection = sec.copyWith(topics: updatedTopics);
      final updatedSections =
          ch.sections.map((s) => s.id == sec.id ? updatedSection : s).toList();
      final updatedChapter = ch.copyWith(sections: updatedSections);
      if (!mounted) return;
      await context
          .read<StudyProvider>()
          .saveTextbookChapter(_selectedSubject!.id, updatedChapter);
    }
  }

  // --- Dialog Form Editors ---

  void _showOverviewDialog(CourseOverviewModel? overview) {
    final descCtrl = TextEditingController(text: overview?.description ?? '');
    final whyCtrl = TextEditingController(text: overview?.whyItMatters ?? '');
    final prereqCtrl =
        TextEditingController(text: overview?.prerequisites.join(', ') ?? '');
    final objCtrl = TextEditingController(
        text: overview?.learningObjectives.join(', ') ?? '');
    final outcomesCtrl = TextEditingController(
        text: overview?.learningOutcomes.join(', ') ?? '');
    final timeCtrl = TextEditingController(
        text: overview?.estimatedStudyTime ?? '45 Study Hours');
    final diffCtrl = TextEditingController(
        text: overview?.estimatedDifficulty ?? 'Intermediate');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(overview == null
            ? 'Create Course Overview'
            : 'Edit Course Overview'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2),
              TextField(
                  controller: whyCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Why It Matters'),
                  maxLines: 2),
              TextField(
                  controller: prereqCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Prerequisites (comma-separated)')),
              TextField(
                  controller: objCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Objectives (comma-separated)')),
              TextField(
                  controller: outcomesCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Outcomes (comma-separated)')),
              TextField(
                  controller: timeCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Estimated Study Time')),
              TextField(
                  controller: diffCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Estimated Difficulty')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_selectedSubject == null || descCtrl.text.trim().isEmpty)
                return;

              final model = CourseOverviewModel(
                subjectId: _selectedSubject!.id,
                subjectName: _selectedSubject!.name,
                description: descCtrl.text.trim(),
                whyItMatters: whyCtrl.text.trim(),
                prerequisites: prereqCtrl.text
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList(),
                learningObjectives: objCtrl.text
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList(),
                learningOutcomes: outcomesCtrl.text
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList(),
                estimatedStudyTime: timeCtrl.text.trim(),
                estimatedDifficulty: diffCtrl.text.trim(),
              );

              await context.read<StudyProvider>().saveCourseOverview(model);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save Overview'),
          ),
        ],
      ),
    );
  }

  void _showChapterDialog(TextbookChapterModel? ch, int nextOrder) {
    final titleCtrl = TextEditingController(text: ch?.title ?? '');
    final descCtrl = TextEditingController(text: ch?.description ?? '');
    final numCtrl =
        TextEditingController(text: '${ch?.chapterNumber ?? nextOrder}');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title:
            Text(ch == null ? 'Add Textbook Chapter' : 'Edit Textbook Chapter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: numCtrl,
                decoration: const InputDecoration(labelText: 'Chapter Number'),
                keyboardType: TextInputType.number),
            TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Title')),
            TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_selectedSubject == null || titleCtrl.text.trim().isEmpty)
                return;

              final chapterNum = int.tryParse(numCtrl.text.trim()) ?? nextOrder;
              final model = TextbookChapterModel(
                id: ch?.id ?? 'ch_${DateTime.now().millisecondsSinceEpoch}',
                subjectId: _selectedSubject!.id,
                chapterNumber: chapterNum,
                title: titleCtrl.text.trim(),
                description: descCtrl.text.trim(),
                order: chapterNum,
                sections: ch?.sections ?? [],
              );

              await context
                  .read<StudyProvider>()
                  .saveTextbookChapter(_selectedSubject!.id, model);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save Chapter'),
          ),
        ],
      ),
    );
  }

  void _showSectionDialog(
      TextbookChapterModel ch, TextbookSectionModel? sec, int nextOrder) {
    final numCtrl = TextEditingController(
        text: sec?.sectionNumber ?? '${ch.chapterNumber}.$nextOrder');
    final titleCtrl = TextEditingController(text: sec?.title ?? '');
    final descCtrl = TextEditingController(text: sec?.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(sec == null ? 'Add Section' : 'Edit Section'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: numCtrl,
                decoration: const InputDecoration(
                    labelText: 'Section Number (e.g. 1.1)')),
            TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Title')),
            TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_selectedSubject == null || titleCtrl.text.trim().isEmpty)
                return;

              final newSection = TextbookSectionModel(
                id: sec?.id ?? 'sec_${DateTime.now().millisecondsSinceEpoch}',
                chapterId: ch.id,
                sectionNumber: numCtrl.text.trim(),
                title: titleCtrl.text.trim(),
                description: descCtrl.text.trim(),
                order: nextOrder,
                topics: sec?.topics ?? [],
              );

              final List<TextbookSectionModel> updatedSections =
                  List.from(ch.sections);
              if (sec != null) {
                final idx = updatedSections.indexWhere((s) => s.id == sec.id);
                if (idx != -1) updatedSections[idx] = newSection;
              } else {
                updatedSections.add(newSection);
              }

              final updatedChapter = ch.copyWith(sections: updatedSections);
              await context
                  .read<StudyProvider>()
                  .saveTextbookChapter(_selectedSubject!.id, updatedChapter);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save Section'),
          ),
        ],
      ),
    );
  }

  void _showTopicDialog(TextbookChapterModel ch, TextbookSectionModel sec,
      TextbookTopicModel? top, int nextOrder) {
    final numCtrl = TextEditingController(
        text: top?.topicNumber ?? '${sec.sectionNumber}.$nextOrder');
    final titleCtrl = TextEditingController(text: top?.title ?? '');
    final defCtrl = TextEditingController(text: top?.definition ?? '');
    final intuCtrl = TextEditingController(text: top?.intuition ?? '');
    final workCtrl = TextEditingController(text: top?.workingPrinciple ?? '');
    final algoCtrl = TextEditingController(text: top?.algorithm ?? '');
    final pseudoCtrl = TextEditingController(text: top?.pseudocode ?? '');
    final codeCtrl = TextEditingController(text: top?.codeImplementation ?? '');
    final timeCtrl = TextEditingController(text: top?.timeComplexity ?? '');
    final spaceCtrl = TextEditingController(text: top?.spaceComplexity ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(top == null ? 'Add Topic' : 'Edit Topic'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: numCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Topic Number (e.g. 1.1.1)')),
              TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title')),
              TextField(
                  controller: defCtrl,
                  decoration: const InputDecoration(labelText: 'Definition'),
                  maxLines: 2),
              TextField(
                  controller: intuCtrl,
                  decoration: const InputDecoration(labelText: 'Intuition'),
                  maxLines: 2),
              TextField(
                  controller: workCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Working Principle'),
                  maxLines: 2),
              TextField(
                  controller: algoCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Algorithm Name')),
              TextField(
                  controller: pseudoCtrl,
                  decoration: const InputDecoration(labelText: 'Pseudocode'),
                  maxLines: 2),
              TextField(
                  controller: codeCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Code Implementation'),
                  maxLines: 2),
              TextField(
                  controller: timeCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Time Complexity (e.g. O(V+E))')),
              TextField(
                  controller: spaceCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Space Complexity (e.g. O(V))')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_selectedSubject == null || titleCtrl.text.trim().isEmpty)
                return;

              final newTopic = TextbookTopicModel(
                id: top?.id ?? 'top_${DateTime.now().millisecondsSinceEpoch}',
                sectionId: sec.id,
                topicNumber: numCtrl.text.trim(),
                title: titleCtrl.text.trim(),
                definition: defCtrl.text.trim(),
                intuition: intuCtrl.text.trim(),
                workingPrinciple: workCtrl.text.trim(),
                algorithm:
                    algoCtrl.text.trim().isEmpty ? null : algoCtrl.text.trim(),
                pseudocode: pseudoCtrl.text.trim().isEmpty
                    ? null
                    : pseudoCtrl.text.trim(),
                codeImplementation:
                    codeCtrl.text.trim().isEmpty ? null : codeCtrl.text.trim(),
                timeComplexity:
                    timeCtrl.text.trim().isEmpty ? null : timeCtrl.text.trim(),
                spaceComplexity: spaceCtrl.text.trim().isEmpty
                    ? null
                    : spaceCtrl.text.trim(),
                order: nextOrder,
              );

              final List<TextbookTopicModel> updatedTopics =
                  List.from(sec.topics);
              if (top != null) {
                final idx = updatedTopics.indexWhere((t) => t.id == top.id);
                if (idx != -1) updatedTopics[idx] = newTopic;
              } else {
                updatedTopics.add(newTopic);
              }

              final updatedSection = sec.copyWith(topics: updatedTopics);
              final List<TextbookSectionModel> updatedSections = ch.sections
                  .map((s) => s.id == sec.id ? updatedSection : s)
                  .toList();
              final updatedChapter = ch.copyWith(sections: updatedSections);

              await context
                  .read<StudyProvider>()
                  .saveTextbookChapter(_selectedSubject!.id, updatedChapter);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save Topic'),
          ),
        ],
      ),
    );
  }
}

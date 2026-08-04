import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/year_model.dart';
import '../../../../data/models/semester_model.dart';
import '../../../../data/models/subject_model.dart';
import '../../../../data/models/resource_model.dart';
import '../../../providers/study_provider.dart';
import '../../../providers/admin_provider.dart';
import '../admin_upload_screen.dart';
import '../../pdf_viewer/pdf_viewer_screen.dart';

class AcademicAdminPage extends StatefulWidget {
  const AcademicAdminPage({super.key});

  @override
  State<AcademicAdminPage> createState() => _AcademicAdminPageState();
}

class _AcademicAdminPageState extends State<AcademicAdminPage> {
  final TextEditingController _searchController = TextEditingController();
  YearModel? _filterYear;
  SemesterModel? _filterSemester;
  SubjectModel? _filterSubject;
  String? _filterType;

  List<SemesterModel> _availableSemesters = [];
  List<SubjectModel> _availableSubjects = [];
  List<ResourceModel> _allResources = [];
  bool _isLoading = false;
  bool _isBulkMode = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    final studyProvider = context.read<StudyProvider>();
    await studyProvider.fetchYears();

    // Fetch resources across initial subjects
    await _loadResources();
    setState(() => _isLoading = false);
  }

  Future<void> _loadResources() async {
    final studyRepository = context.read<StudyProvider>().repository;
    if (_filterSubject != null) {
      final res = await studyRepository.getResources(_filterSubject!.id, resourceType: _filterType);
      setState(() => _allResources = res);
    } else {
      final res = await studyRepository.searchGlobal('');
      setState(() => _allResources = res);
    }
  }

  Future<void> _onYearFilterChanged(YearModel? year) async {
    setState(() {
      _filterYear = year;
      _filterSemester = null;
      _filterSubject = null;
      _availableSemesters = [];
      _availableSubjects = [];
    });
    if (year != null) {
      final sems = await context.read<StudyProvider>().repository.getSemesters(year.id);
      setState(() => _availableSemesters = sems);
    }
    _loadResources();
  }

  Future<void> _onSemesterFilterChanged(SemesterModel? semester) async {
    setState(() {
      _filterSemester = semester;
      _filterSubject = null;
      _availableSubjects = [];
    });
    if (semester != null) {
      final subjs = await context.read<StudyProvider>().repository.getSubjects(semester.id);
      setState(() => _availableSubjects = subjs);
    }
    _loadResources();
  }

  List<ResourceModel> get _filteredResources {
    final query = _searchController.text.toLowerCase().trim();
    return _allResources.where((res) {
      final matchesQuery = query.isEmpty ||
          res.title.toLowerCase().contains(query) ||
          res.subjectName.toLowerCase().contains(query) ||
          res.description.toLowerCase().contains(query) ||
          res.resourceType.toLowerCase().contains(query);

      final matchesType = _filterType == null || res.resourceType == _filterType;
      return matchesQuery && matchesType;
    }).toList();
  }

  // --- CRUD Action Dialogs ---

  Future<void> _showEditMetadataDialog(ResourceModel resource) async {
    final titleCtrl = TextEditingController(text: resource.title);
    final descCtrl = TextEditingController(text: resource.description);

    final updated = await showDialog<ResourceModel>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Resource Metadata'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Document Title')),
            const SizedBox(height: 12),
            TextField(controller: descCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                ctx,
                resource.copyWith(
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  lastUpdated: DateTime.now(),
                ),
              );
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );

    if (updated != null && mounted) {
      final studyProvider = context.read<StudyProvider>();
      await studyProvider.repository.updateResource(updated);
      if (mounted) {
        _loadResources();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resource metadata updated successfully.')),
        );
      }
    }
  }

  Future<void> _showReplacePdfDialog(ResourceModel resource) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result == null || result.files.isEmpty || result.files.first.bytes == null) return;

    final file = result.files.first;

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Uploading replacement PDF to Firebase Storage...')),
    );

    try {
      await context.read<StudyProvider>().repository.replaceResourcePdf(
        existingResource: resource,
        fileName: file.name,
        newPdfBytes: file.bytes!,
        onProgress: (_) {},
      );

      if (mounted) {
        _loadResources();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF replaced and updated live!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error replacing PDF: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  Future<void> _confirmDeleteResource(ResourceModel resource) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Resource Document?'),
        content: Text('Are you sure you want to delete "${resource.title}"? This will permanently remove the document metadata and Storage PDF file.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final studyProvider = context.read<StudyProvider>();
      await studyProvider.repository.deleteResource(resource.id, resource.storagePath);
      if (mounted) {
        _loadResources();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resource deleted permanently.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final studyProvider = context.watch<StudyProvider>();
    final adminProvider = context.watch<AdminProvider>();

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    const royalBlue = Color(0xFF2563EB);

    final displayList = _filteredResources;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          '📚 Academic Resources Control',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: textPrimary),
        ),
        backgroundColor: cardColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isBulkMode ? Icons.close_rounded : Icons.checklist_rounded),
            tooltip: _isBulkMode ? 'Cancel Bulk' : 'Bulk Select',
            onPressed: () {
              setState(() => _isBulkMode = !_isBulkMode);
              if (!_isBulkMode) adminProvider.clearBulkSelection();
            },
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminUploadScreen()),
              ).then((_) => _loadResources());
            },
            icon: const Icon(Icons.cloud_upload_rounded, size: 18),
            label: const Text('Upload PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: royalBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // --- Filter Header Panel ---
          Container(
            padding: const EdgeInsets.all(16),
            color: cardColor,
            child: Column(
              children: [
                // Search Input
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search resources by title, subject or category...',
                    prefixIcon: const Icon(Icons.search_rounded, color: royalBlue),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () => setState(() => _searchController.clear()),
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? AppColors.surfaceDark : const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: borderColor),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Filter Dropdowns
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Year Filter
                      DropdownButton<YearModel>(
                        value: _filterYear,
                        hint: const Text('All Years'),
                        items: studyProvider.years.map((y) => DropdownMenuItem(value: y, child: Text(y.title))).toList(),
                        onChanged: _onYearFilterChanged,
                      ),
                      const SizedBox(width: 12),

                      // Semester Filter
                      DropdownButton<SemesterModel>(
                        value: _filterSemester,
                        hint: const Text('All Semesters'),
                        items: _availableSemesters.map((s) => DropdownMenuItem(value: s, child: Text(s.title))).toList(),
                        onChanged: _onSemesterFilterChanged,
                      ),
                      const SizedBox(width: 12),

                      // Subject Filter
                      DropdownButton<SubjectModel>(
                        value: _filterSubject,
                        hint: const Text('All Subjects'),
                        items: _availableSubjects.map((sub) => DropdownMenuItem(value: sub, child: Text(sub.name))).toList(),
                        onChanged: (sub) {
                          setState(() => _filterSubject = sub);
                          _loadResources();
                        },
                      ),
                      const SizedBox(width: 12),

                      // Type Filter
                      DropdownButton<String>(
                        value: _filterType,
                        hint: const Text('All Types'),
                        items: AppConstants.resourceTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                        onChanged: (type) {
                          setState(() => _filterType = type);
                          _loadResources();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (_isBulkMode && adminProvider.selectedResourcesForBulk.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: royalBlue.withAlpha(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${adminProvider.selectedResourcesForBulk.length} Selected for Bulk Operations',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: royalBlue),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await adminProvider.bulkDeleteSelected();
                      _loadResources();
                    },
                    icon: const Icon(Icons.delete_forever_rounded, size: 16),
                    label: const Text('Delete Selected'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                  ),
                ],
              ),
            ),

          // --- Resource List ---
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : displayList.isEmpty
                    ? Center(
                        child: Text(
                          'No resources match current filter criteria.',
                          style: GoogleFonts.inter(color: textSubtitle),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: displayList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final resource = displayList[index];
                          final isSelected = adminProvider.selectedResourcesForBulk.any((r) => r.id == resource.id);
                          final sizeMb = (resource.fileSizeBytes / (1024 * 1024)).toStringAsFixed(2);
                          final dateStr = DateFormat('MMM d, yyyy').format(resource.lastUpdated);

                          return Container(
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? royalBlue : borderColor,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: ListTile(
                              leading: _isBulkMode
                                  ? Checkbox(
                                      value: isSelected,
                                      onChanged: (_) => adminProvider.toggleResourceSelection(resource),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent.withAlpha(20),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent, size: 22),
                                    ),
                              title: Text(
                                resource.title,
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimary),
                              ),
                              subtitle: Text(
                                '${resource.subjectName} • ${resource.resourceType} • $sizeMb MB • $dateStr',
                                style: GoogleFonts.inter(fontSize: 12, color: textSubtitle),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility_outlined, color: royalBlue),
                                    tooltip: 'Preview PDF',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => PdfViewerScreen(resource: resource)),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, color: Colors.amber),
                                    tooltip: 'Edit Metadata',
                                    onPressed: () => _showEditMetadataDialog(resource),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.published_with_changes_rounded, color: Colors.blue),
                                    tooltip: 'Replace PDF File',
                                    onPressed: () => _showReplacePdfDialog(resource),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                    tooltip: 'Delete PDF',
                                    onPressed: () => _confirmDeleteResource(resource),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

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
    final studyProvider = context.read<StudyProvider>();
    if (_filterSubject != null) {
      final res = await studyProvider.repository
          .getResources(_filterSubject!.id, resourceType: _filterType);
      setState(() => _allResources = res);
    } else {
      // Fetch all resources from Firestore directly
      final res =
          await studyProvider.repository.firebaseDataSource.searchResources('');
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
      final sems =
          await context.read<StudyProvider>().repository.getSemesters(year.id);
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
      final subjs = await context
          .read<StudyProvider>()
          .repository
          .getSubjects(semester.id);
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

      final matchesType =
          _filterType == null || res.resourceType == _filterType;
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
            TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Document Title')),
            const SizedBox(height: 12),
            TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
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
          const SnackBar(
              content: Text('Resource metadata updated successfully.')),
        );
      }
    }
  }

  Future<void> _showReplacePdfDialog(ResourceModel resource) async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result == null ||
        result.files.isEmpty ||
        result.files.first.bytes == null) return;

    final file = result.files.first;

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Uploading replacement PDF to Firebase Storage...')),
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
          const SnackBar(
              content: Text('PDF replaced and updated live!'),
              backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error replacing PDF: $e'),
              backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  Future<void> _confirmDeleteResource(ResourceModel resource) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Resource Document?'),
        content: Text(
            'Are you sure you want to delete "${resource.title}"? This will permanently remove the document metadata and Storage PDF file.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final studyProvider = context.read<StudyProvider>();
      await studyProvider.repository
          .deleteResource(resource.id, resource.storagePath);
      if (mounted) {
        _loadResources();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resource deleted permanently.')),
        );
      }
    }
  }

  String _formatYear(String yearId, List<YearModel> years) {
    if (yearId.isEmpty) return 'Year 1';
    for (final y in years) {
      if (y.id == yearId) return y.title;
    }
    if (yearId.toLowerCase().contains('y1') || yearId == '1') return '1st Year';
    if (yearId.toLowerCase().contains('y2') || yearId == '2') return '2nd Year';
    if (yearId.toLowerCase().contains('y3') || yearId == '3') return '3rd Year';
    if (yearId.toLowerCase().contains('y4') || yearId == '4') return '4th Year';
    return yearId.replaceAll('_', ' ').toUpperCase();
  }

  Widget _buildPublicationStatus(ResourceModel resource) {
    final isArchive = resource.storageUrl.contains('archive.org');
    final isAvailable =
        resource.isAvailable && resource.availabilityStatus != 'coming_soon';

    if (isAvailable && !isArchive) {
      final dateStr =
          DateFormat('MMM d, yyyy – h:mm a').format(resource.lastUpdated);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.withAlpha(80)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded,
                    size: 14, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  'Published',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              dateStr,
              style:
                  GoogleFonts.inter(fontSize: 10, color: Colors.green.shade800),
            ),
          ],
        ),
      );
    } else if (isArchive) {
      final minutesSinceUpload =
          DateTime.now().difference(resource.lastUpdated).inMinutes;
      if (minutesSinceUpload < 60) {
        final remainingMin = 60 - minutesSinceUpload;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber.withAlpha(80)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.schedule_rounded,
                      size: 14, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    'Processing',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.amber,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '~$remainingMin min left to publish',
                style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.amber.shade900,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      }
    }

    final minutesSince =
        DateTime.now().difference(resource.lastUpdated).inMinutes;
    final remaining = (30 - minutesSince) > 0 ? (30 - minutesSince) : 15;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.access_time_filled_rounded,
                  size: 14, color: Colors.blue),
              const SizedBox(width: 4),
              Text(
                'Publish Pending',
                style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '~$remaining min to publish',
            style: GoogleFonts.inter(
                fontSize: 10,
                color: Colors.blue.shade900,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // --- Resource List & Metadata Columns Table ---
  Widget _buildMetadataColumnsTable({
    required List<ResourceModel> displayList,
    required bool isDark,
    required Color cardColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSubtitle,
    required Color royalBlue,
    required StudyProvider studyProvider,
    required AdminProvider adminProvider,
  }) {
    if (displayList.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'No resources match current filter criteria.',
            style: GoogleFonts.inter(color: textSubtitle),
          ),
        ),
      );
    }

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 1000,
          child: Column(
            children: [
              // --- Column Headers ---
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      isDark ? AppColors.surfaceDark : const Color(0xFFEBF1FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    if (_isBulkMode) const SizedBox(width: 32),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '📄 PDF Name & Details',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: royalBlue),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '🎓 Year',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: royalBlue),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '📘 Subject',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: royalBlue),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '🚀 Publication Status / Timeline',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: royalBlue),
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: Text(
                        '⚡ Actions',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: royalBlue),
                      ),
                    ),
                  ],
                ),
              ),

              // --- Column Rows ---
              Expanded(
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  itemCount: displayList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final resource = displayList[index];
                    final isSelected = adminProvider.selectedResourcesForBulk
                        .any((r) => r.id == resource.id);
                    final sizeMb = (resource.fileSizeBytes / (1024 * 1024))
                        .toStringAsFixed(2);
                    final formattedYear =
                        _formatYear(resource.yearId, studyProvider.years);

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? royalBlue : borderColor,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (_isBulkMode) ...[
                            Checkbox(
                              value: isSelected,
                              onChanged: (_) => adminProvider
                                  .toggleResourceSelection(resource),
                            ),
                            const SizedBox(width: 8),
                          ],

                          // Column 1: PDF Name
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withAlpha(18),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                      Icons.picture_as_pdf_rounded,
                                      color: Colors.redAccent,
                                      size: 20),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        resource.title,
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: textPrimary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${resource.fileName} • $sizeMb MB',
                                        style: GoogleFonts.inter(
                                            fontSize: 11, color: textSubtitle),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Column 2: Year
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: royalBlue.withAlpha(15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                formattedYear,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: royalBlue),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                          // Column 3: Subject
                          Expanded(
                            flex: 2,
                            child: Text(
                              resource.subjectName.isNotEmpty
                                  ? resource.subjectName
                                  : 'General Subject',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: textPrimary),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Column 4: Publication Status & Timeline
                          Expanded(
                            flex: 2,
                            child: _buildPublicationStatus(resource),
                          ),

                          // Column 5: Actions
                          SizedBox(
                            width: 140,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.visibility_outlined,
                                      color: royalBlue, size: 18),
                                  tooltip: 'Preview PDF',
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => PdfViewerScreen(
                                              resource: resource)),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined,
                                      color: Colors.amber, size: 18),
                                  tooltip: 'Edit Metadata',
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () =>
                                      _showEditMetadataDialog(resource),
                                ),
                                IconButton(
                                  icon: const Icon(
                                      Icons.published_with_changes_rounded,
                                      color: Colors.blue,
                                      size: 18),
                                  tooltip: 'Replace PDF File',
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () =>
                                      _showReplacePdfDialog(resource),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded,
                                      color: Colors.redAccent, size: 18),
                                  tooltip: 'Delete PDF',
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () =>
                                      _confirmDeleteResource(resource),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle =
        isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    const royalBlue = Color(0xFF2563EB);

    final displayList = _filteredResources;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          '📚 Academic Resources Control',
          style: GoogleFonts.inter(
              fontWeight: FontWeight.bold, fontSize: 18, color: textPrimary),
        ),
        backgroundColor: cardColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
                _isBulkMode ? Icons.close_rounded : Icons.checklist_rounded),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
                    hintText:
                        'Search resources by title, subject or category...',
                    prefixIcon:
                        const Icon(Icons.search_rounded, color: royalBlue),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () =>
                                setState(() => _searchController.clear()),
                          )
                        : null,
                    filled: true,
                    fillColor: isDark
                        ? AppColors.surfaceDark
                        : const Color(0xFFF9FAFB),
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
                        items: studyProvider.years
                            .map((y) => DropdownMenuItem(
                                value: y, child: Text(y.title)))
                            .toList(),
                        onChanged: _onYearFilterChanged,
                      ),
                      const SizedBox(width: 12),

                      // Semester Filter
                      DropdownButton<SemesterModel>(
                        value: _filterSemester,
                        hint: const Text('All Semesters'),
                        items: _availableSemesters
                            .map((s) => DropdownMenuItem(
                                value: s, child: Text(s.title)))
                            .toList(),
                        onChanged: _onSemesterFilterChanged,
                      ),
                      const SizedBox(width: 12),

                      // Subject Filter
                      DropdownButton<SubjectModel>(
                        value: _filterSubject,
                        hint: const Text('All Subjects'),
                        items: _availableSubjects
                            .map((sub) => DropdownMenuItem(
                                value: sub, child: Text(sub.name)))
                            .toList(),
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
                        items: [
                          const DropdownMenuItem<String>(
                              value: null, child: Text('All Types')),
                          ...AppConstants.resourceTypes.map((t) =>
                              DropdownMenuItem(value: t, child: Text(t))),
                        ],
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
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, color: royalBlue),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await adminProvider.bulkDeleteSelected();
                      _loadResources();
                    },
                    icon: const Icon(Icons.delete_forever_rounded, size: 16),
                    label: const Text('Delete Selected'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white),
                  ),
                ],
              ),
            ),

          // --- Resource List & Reorganized Metadata Columns ---
          _isLoading
              ? const Expanded(
                  child: Center(child: CircularProgressIndicator()))
              : _buildMetadataColumnsTable(
                  displayList: displayList,
                  isDark: isDark,
                  cardColor: cardColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSubtitle: textSubtitle,
                  royalBlue: royalBlue,
                  studyProvider: studyProvider,
                  adminProvider: adminProvider,
                ),
        ],
      ),
    );
  }
}

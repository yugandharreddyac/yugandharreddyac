import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/year_model.dart';
import '../../../data/models/semester_model.dart';
import '../../../data/models/subject_model.dart';
import '../../../data/models/resource_model.dart';
import '../../providers/study_provider.dart';
import '../pdf_viewer/pdf_viewer_screen.dart';

class ArchiveUploadScreen extends StatefulWidget {
  const ArchiveUploadScreen({super.key});

  @override
  State<ArchiveUploadScreen> createState() => _ArchiveUploadScreenState();
}

class _ArchiveUploadScreenState extends State<ArchiveUploadScreen> {
  // We'll store resources by semester ID to easily display them
  final Map<String, List<ResourceModel>> _semesterResources = {};
  final Map<String, int> _yearResourceCount = {};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    final studyProvider = context.read<StudyProvider>();
    final repo = studyProvider.repository;

    if (studyProvider.years.isEmpty) {
      await studyProvider.fetchYears();
    }

    _semesterResources.clear();
    _yearResourceCount.clear();

    final allResources = await repo.getAllResources();

    for (var year in studyProvider.years) {
      int countForYear = 0;
      final semesters = await repo.getSemesters(year.id);
      
      for (var sem in semesters) {
        final semResources = allResources.where((r) => r.semesterId == sem.id).toList();
        _semesterResources[sem.id] = semResources;
        countForYear += semResources.length;
      }
      _yearResourceCount[year.id] = countForYear;
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showUploadModal() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const _UploadModal(),
    );
    if (result == true) {
      _loadAllData(); // Refresh data after upload
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final studyProvider = context.watch<StudyProvider>();

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Archive Upload Dashboard',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: textPrimary),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Global Upload Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _showUploadModal,
                      icon: const Icon(Icons.cloud_upload_rounded),
                      label: Text(
                        'Upload PDF to Archive.org',
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4 Year Boxes
                  Expanded(
                    child: ListView.builder(
                      itemCount: studyProvider.years.length,
                      itemBuilder: (context, index) {
                        final year = studyProvider.years[index];
                        return _YearBox(
                          year: year,
                          totalFiles: _yearResourceCount[year.id] ?? 0,
                          semesterResources: _semesterResources,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _YearBox extends StatefulWidget {
  final YearModel year;
  final int totalFiles;
  final Map<String, List<ResourceModel>> semesterResources;

  const _YearBox({
    required this.year,
    required this.totalFiles,
    required this.semesterResources,
  });

  @override
  State<_YearBox> createState() => _YearBoxState();
}

class _YearBoxState extends State<_YearBox> {
  String? _selectedSemesterId;
  List<SemesterModel> _semesters = [];
  bool _isLoadingSems = true;

  @override
  void initState() {
    super.initState();
    _loadSemesters();
  }

  Future<void> _loadSemesters() async {
    final repo = context.read<StudyProvider>().repository;
    final sems = await repo.getSemesters(widget.year.id);
    if (mounted) {
      setState(() {
        _semesters = sems;
        if (sems.isNotEmpty) {
          _selectedSemesterId = sems.first.id; // default to first semester toggle
        }
        _isLoadingSems = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withAlpha(50), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Year Title & Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.year.title,
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18, color: textPrimary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${widget.totalFiles} Files Uploaded',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_isLoadingSems)
            const Center(child: CircularProgressIndicator())
          else if (_semesters.isNotEmpty) ...[
            // Semester Toggles
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _semesters.map((sem) {
                  final isSelected = _selectedSemesterId == sem.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(sem.title),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _selectedSemesterId = sem.id);
                      },
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Files List for Selected Semester
            if (_selectedSemesterId != null) ...[
              Builder(builder: (ctx) {
                final files = widget.semesterResources[_selectedSemesterId!] ?? [];
                if (files.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('No files uploaded yet for this semester.', style: TextStyle(color: Colors.grey.shade600)),
                  );
                }
                return Container(
                  constraints: const BoxConstraints(maxHeight: 250),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black12 : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withAlpha(30)),
                  ),
                  child: RawScrollbar(
                    thumbVisibility: true,
                    thumbColor: AppColors.primary.withAlpha(150),
                    radius: const Radius.circular(8),
                    thickness: 6,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      itemCount: files.length,
                      itemBuilder: (ctx, idx) {
                        final f = files[idx];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                          leading: const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent),
                          title: Text(f.title, style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text(f.subjectName, style: const TextStyle(fontSize: 12)),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_red_eye, color: AppColors.primary),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => PdfViewerScreen(resource: f)));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ]
          ],
        ],
      ),
    );
  }
}

class _UploadModal extends StatefulWidget {
  const _UploadModal();

  @override
  State<_UploadModal> createState() => _UploadModalState();
}

class _UploadModalState extends State<_UploadModal> {
  final _formKey = GlobalKey<FormState>();

  YearModel? _selectedYear;
  SemesterModel? _selectedSemester;
  SubjectModel? _selectedSubject;
  String _selectedResourceType = AppConstants.typeNotes;
  final TextEditingController _titleController = TextEditingController();
  PlatformFile? _selectedFile;

  List<SemesterModel> _availableSemesters = [];
  List<SubjectModel> _availableSubjects = [];

  bool _isUploading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf'], withData: true);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
        if (_titleController.text.isEmpty) {
          _titleController.text = _selectedFile!.name.replaceAll(RegExp(r'\.pdf$', caseSensitive: false), '');
        }
      });
    }
  }

  Future<void> _onYearChanged(YearModel? year) async {
    if (year == null) return;
    setState(() {
      _selectedYear = year;
      _selectedSemester = null;
      _selectedSubject = null;
      _availableSemesters = [];
      _availableSubjects = [];
    });
    final sems = await context.read<StudyProvider>().repository.getSemesters(year.id);
    setState(() => _availableSemesters = sems);
  }

  Future<void> _onSemesterChanged(SemesterModel? semester) async {
    if (semester == null) return;
    setState(() {
      _selectedSemester = semester;
      _selectedSubject = null;
      _availableSubjects = [];
    });
    final subjs = await context.read<StudyProvider>().repository.getSubjects(semester.id);
    setState(() => _availableSubjects = subjs);
  }

  Future<void> _upload() async {
    if (!_formKey.currentState!.validate() || _selectedFile == null) return;

    setState(() => _isUploading = true);
    try {
      await context.read<StudyProvider>().repository.uploadAdminPdfResource(
        year: _selectedYear!,
        semester: _selectedSemester!,
        subject: _selectedSubject!,
        resourceType: _selectedResourceType,
        title: _titleController.text.trim(),
        description: '',
        fileName: _selectedFile!.name,
        pdfBytes: _selectedFile!.bytes!,
        sectionType: 'Notes',
        onProgress: (_) {},
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final studyProvider = context.read<StudyProvider>();
    return AlertDialog(
      title: const Text('Upload PDF to Archive'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<YearModel>(
                  value: _selectedYear,
                  decoration: const InputDecoration(labelText: 'Select Year'),
                  items: studyProvider.years.map((y) => DropdownMenuItem(value: y, child: Text(y.title))).toList(),
                  onChanged: _onYearChanged,
                  validator: (val) => val == null ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<SemesterModel>(
                  value: _selectedSemester,
                  decoration: const InputDecoration(labelText: 'Select Semester'),
                  items: _availableSemesters.map((s) => DropdownMenuItem(value: s, child: Text(s.title))).toList(),
                  onChanged: _onSemesterChanged,
                  validator: (val) => val == null ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<SubjectModel>(
                  value: _selectedSubject,
                  decoration: const InputDecoration(labelText: 'Select Subject'),
                  items: _availableSubjects.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                  onChanged: (val) => setState(() => _selectedSubject = val),
                  validator: (val) => val == null ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedResourceType,
                  decoration: const InputDecoration(labelText: 'Resource Type'),
                  items: AppConstants.resourceTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (val) => setState(() => _selectedResourceType = val!),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'PDF Title'),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: Text(_selectedFile == null ? 'Choose PDF File' : _selectedFile!.name),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _isUploading ? null : _upload,
          child: _isUploading ? const CircularProgressIndicator() : const Text('Upload'),
        ),
      ],
    );
  }
}

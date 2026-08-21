import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/year_model.dart';
import '../../../data/models/semester_model.dart';
import '../../../data/models/subject_model.dart';
import '../../providers/study_provider.dart';
import '../../widgets/custom_app_bar.dart';

class AdminUploadScreen extends StatefulWidget {
  const AdminUploadScreen({super.key});

  @override
  State<AdminUploadScreen> createState() => _AdminUploadScreenState();
}

class _AdminUploadScreenState extends State<AdminUploadScreen> {
  final _formKey = GlobalKey<FormState>();

  YearModel? _selectedYear;
  SemesterModel? _selectedSemester;
  SubjectModel? _selectedSubject;
  String _selectedResourceType = AppConstants.typeNotes;
  String _selectedSectionType = 'Notes';

  final List<_BatchPdfItem> _batchItems = [];

  List<SemesterModel> _availableSemesters = [];
  List<SubjectModel> _availableSubjects = [];

  bool _isLoadingHierarchy = false;
  bool _isUploading = false;
  double _overallProgress = 0.0;
  String? _uploadError;
  bool _isSuccess = false;

  static const int _maxFileSizeBytes = 500 * 1024 * 1024; // 500 MB limit

  @override
  void initState() {
    super.initState();
    _loadYears();
  }

  @override
  void dispose() {
    for (final item in _batchItems) {
      item.dispose();
    }
    super.dispose();
  }

  Future<void> _loadYears() async {
    final studyProvider = context.read<StudyProvider>();
    if (studyProvider.years.isEmpty) {
      setState(() => _isLoadingHierarchy = true);
      await studyProvider.fetchYears();
      setState(() => _isLoadingHierarchy = false);
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
      _isLoadingHierarchy = true;
    });

    final studyRepository = context.read<StudyProvider>().repository;
    final sems = await studyRepository.getSemesters(year.id);
    setState(() {
      _availableSemesters = sems;
      _isLoadingHierarchy = false;
    });
  }

  Future<void> _onSemesterChanged(SemesterModel? semester) async {
    if (semester == null) return;
    setState(() {
      _selectedSemester = semester;
      _selectedSubject = null;
      _availableSubjects = [];
      _isLoadingHierarchy = true;
    });

    final studyRepository = context.read<StudyProvider>().repository;
    final subjs = await studyRepository.getSubjects(semester.id);
    setState(() {
      _availableSubjects = subjs;
      _isLoadingHierarchy = false;
    });
  }

  Future<void> _pickPdfFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
        allowMultiple: true, // Allow multiple PDF selection
      );

      if (result != null && result.files.isNotEmpty) {
        final newItems = <_BatchPdfItem>[];
        int skippedCount = 0;

        for (final file in result.files) {
          if (file.extension?.toLowerCase() != 'pdf') {
            skippedCount++;
            continue;
          }
          if (file.size > _maxFileSizeBytes) {
            _showSnackBar('Skipped "${file.name}" (Exceeds 500 MB limit)');
            continue;
          }
          if (file.bytes == null) continue;

          final nameWithoutExt =
              file.name.replaceAll(RegExp(r'\.pdf$', caseSensitive: false), '');
          newItems.add(_BatchPdfItem(
            file: file,
            title: nameWithoutExt,
          ));
        }

        if (skippedCount > 0) {
          _showSnackBar('Skipped $skippedCount invalid non-PDF file(s).');
        }

        setState(() {
          _batchItems.addAll(newItems);
          _uploadError = null;
          _isSuccess = false;
        });
      }
    } catch (e) {
      _showSnackBar('Error picking PDF files: $e');
    }
  }

  void _removeBatchItem(int index) {
    setState(() {
      _batchItems[index].dispose();
      _batchItems.removeAt(index);
    });
  }

  Future<void> _startBatchUpload() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedYear == null ||
        _selectedSemester == null ||
        _selectedSubject == null) {
      _showSnackBar('Please select Academic Year, Semester, and Subject.');
      return;
    }

    if (_batchItems.isEmpty) {
      _showSnackBar('Please select at least one PDF file to upload.');
      return;
    }

    setState(() {
      _isUploading = true;
      _overallProgress = 0.0;
      _uploadError = null;
      _isSuccess = false;
    });

    final studyRepository = context.read<StudyProvider>().repository;
    int successCount = 0;
    int failCount = 0;

    for (int i = 0; i < _batchItems.length; i++) {
      final item = _batchItems[i];
      if (item.status == 'success') {
        successCount++;
        continue;
      }

      setState(() {
        item.status = 'uploading';
        item.progress = 0.0;
        item.error = null;
      });

      try {
        final titleToUse = item.titleController.text.trim().isNotEmpty
            ? item.titleController.text.trim()
            : item.file.name
                .replaceAll(RegExp(r'\.pdf$', caseSensitive: false), '');

        await studyRepository.uploadAdminPdfResource(
          year: _selectedYear!,
          semester: _selectedSemester!,
          subject: _selectedSubject!,
          resourceType: _selectedResourceType,
          title: titleToUse,
          description: item.descriptionController.text.trim(),
          fileName: item.file.name,
          pdfBytes: item.file.bytes!,
          sectionType: _selectedSectionType,
          onProgress: (progress) {
            if (mounted) {
              setState(() {
                item.progress = progress;
                _overallProgress =
                    ((i + progress) / _batchItems.length).clamp(0.0, 1.0);
              });
            }
          },
        );

        if (mounted) {
          setState(() {
            item.status = 'success';
            item.progress = 1.0;
          });
          successCount++;
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            item.status = 'error';
            item.error = e.toString().replaceAll('Exception: ', '');
          });
          failCount++;
        }
      }
    }

    if (mounted) {
      setState(() {
        _isUploading = false;
        _overallProgress = 1.0;
        if (failCount == 0 && successCount > 0) {
          _isSuccess = true;
        } else if (failCount > 0) {
          _uploadError =
              '$failCount file(s) failed to upload. Check individual file status above.';
        }
      });

      // Trigger global provider refresh
      context.read<StudyProvider>().fetchResources(_selectedSubject!.id);
    }
  }

  void _resetForm() {
    setState(() {
      for (final item in _batchItems) {
        item.dispose();
      }
      _batchItems.clear();
      _overallProgress = 0.0;
      _uploadError = null;
      _isSuccess = false;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final studyProvider = context.watch<StudyProvider>();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Admin PDF Batch Upload Portal',
        subtitle: 'Upload multiple syllabus, notes & papers at once',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header Card ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.admin_panel_settings_rounded,
                        color: Colors.white, size: 36),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CSSE Academic Multi-PDF Upload Engine',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Push multiple PDF documents simultaneously to Firebase Storage & Firestore.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --- Step 1: Academic Target ---
              Text(
                '1. Select Academic Target',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),

              if (_isLoadingHierarchy) ...[
                const LinearProgressIndicator(),
                const SizedBox(height: 12),
              ],

              // Year Dropdown
              DropdownButtonFormField<YearModel>(
                value: _selectedYear,
                decoration: _buildInputDecoration(
                    isDark, 'Academic Year', Icons.school_rounded),
                items: studyProvider.years.map((y) {
                  return DropdownMenuItem<YearModel>(
                    value: y,
                    child: Text(y.title),
                  );
                }).toList(),
                onChanged: _onYearChanged,
                validator: (val) => val == null ? 'Please select Year' : null,
              ),

              const SizedBox(height: 14),

              // Semester Dropdown
              DropdownButtonFormField<SemesterModel>(
                value: _selectedSemester,
                decoration: _buildInputDecoration(
                    isDark, 'Semester', Icons.calendar_view_day_rounded),
                items: _availableSemesters.map((s) {
                  return DropdownMenuItem<SemesterModel>(
                    value: s,
                    child: Text(s.title),
                  );
                }).toList(),
                onChanged: _onSemesterChanged,
                validator: (val) =>
                    val == null ? 'Please select Semester' : null,
              ),

              const SizedBox(height: 14),

              // Subject Dropdown
              DropdownButtonFormField<SubjectModel>(
                value: _selectedSubject,
                decoration: _buildInputDecoration(
                    isDark, 'Subject', Icons.book_rounded),
                items: _availableSubjects.map((sub) {
                  return DropdownMenuItem<SubjectModel>(
                    value: sub,
                    child: Text('${sub.name} (${sub.code})'),
                  );
                }).toList(),
                onChanged: (sub) => setState(() => _selectedSubject = sub),
                validator: (val) =>
                    val == null ? 'Please select Subject' : null,
              ),

              const SizedBox(height: 14),

              // Resource Format & Section Dropdowns
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedResourceType,
                      decoration: _buildInputDecoration(
                          isDark, 'Resource Format', Icons.category_rounded),
                      items: AppConstants.resourceTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (type) {
                        if (type != null)
                          setState(() => _selectedResourceType = type);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedSectionType,
                      decoration: _buildInputDecoration(isDark,
                          'Learning Section', Icons.auto_stories_rounded),
                      items: const ['Syllabus', 'Notes', 'Previous Papers']
                          .map((sec) {
                        return DropdownMenuItem<String>(
                          value: sec,
                          child: Text(sec),
                        );
                      }).toList(),
                      onChanged: (sec) {
                        if (sec != null)
                          setState(() => _selectedSectionType = sec);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- Step 2: Multi-PDF Selection & Batch Queue ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '2. Choose Multiple PDF Files (${_batchItems.length} selected)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (_batchItems.isNotEmpty && !_isUploading)
                    TextButton.icon(
                      onPressed: _resetForm,
                      icon: const Icon(Icons.clear_all_rounded,
                          size: 18, color: Colors.redAccent),
                      label: const Text('Clear All',
                          style: TextStyle(color: Colors.redAccent)),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              InkWell(
                onTap: _isUploading ? null : _pickPdfFiles,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _batchItems.isNotEmpty
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight),
                      width: _batchItems.isNotEmpty ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.note_add_rounded,
                          size: 42, color: AppColors.primary),
                      const SizedBox(height: 8),
                      Text(
                        _batchItems.isEmpty
                            ? 'Click to Pick PDF Files (Batch Upload)'
                            : 'Click to Add More PDF Files',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Select single or multiple PDF documents at once (Max 500 MB per file)',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_batchItems.isNotEmpty) ...[
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _batchItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _batchItems[index];
                    final sizeMb =
                        (item.file.size / (1024 * 1024)).toStringAsFixed(2);

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: item.status == 'error'
                              ? Colors.redAccent
                              : item.status == 'success'
                                  ? Colors.green
                                  : (isDark
                                      ? AppColors.borderDark
                                      : AppColors.borderLight),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                item.status == 'success'
                                    ? Icons.check_circle_rounded
                                    : item.status == 'error'
                                        ? Icons.error_rounded
                                        : Icons.picture_as_pdf_rounded,
                                color: item.status == 'success'
                                    ? Colors.green
                                    : item.status == 'error'
                                        ? Colors.redAccent
                                        : Colors.redAccent,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${item.file.name} ($sizeMb MB)',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (item.status == 'success')
                                const Chip(
                                  label: Text('Uploaded ✓',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold)),
                                  backgroundColor: Colors.green,
                                  visualDensity: VisualDensity.compact,
                                )
                              else if (!_isUploading)
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded,
                                      color: Colors.redAccent, size: 20),
                                  onPressed: () => _removeBatchItem(index),
                                  tooltip: 'Remove PDF',
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Title editing input per file
                          TextFormField(
                            controller: item.titleController,
                            enabled: !_isUploading && item.status != 'success',
                            decoration: InputDecoration(
                              labelText: 'Document Title for PDF #${index + 1}',
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          if (item.status == 'uploading') ...[
                            const SizedBox(height: 8),
                            LinearProgressIndicator(value: item.progress),
                          ],
                          if (item.error != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Error: ${item.error}',
                              style: const TextStyle(
                                  color: Colors.redAccent, fontSize: 11),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ],

              const SizedBox(height: 24),

              // --- Overall Upload Progress View ---
              if (_isUploading) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Batch Uploading to Firebase Storage & Firestore...',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          '${(_overallProgress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _overallProgress,
                        minHeight: 8,
                        backgroundColor: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              if (_uploadError != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.redAccent),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: Colors.redAccent),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _uploadError!,
                          style: const TextStyle(
                              color: Colors.redAccent, fontSize: 13),
                        ),
                      ),
                      TextButton(
                        onPressed: _startBatchUpload,
                        child: const Text('Retry Failed'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              if (_isSuccess) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: Colors.green, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'All ${_batchItems.length} PDFs Uploaded Successfully!',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: 15),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Documents are now live on Firestore & student application.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: _resetForm,
                        child: const Text('Upload More'),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms).scaleY(begin: 0.9, end: 1),
                const SizedBox(height: 24),
              ],

              // --- Submit Action Button ---
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isUploading || _batchItems.isEmpty
                      ? null
                      : _startBatchUpload,
                  icon: _isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.cloud_upload_rounded),
                  label: Text(
                    _isUploading
                        ? 'Uploading Batch...'
                        : 'Push ${_batchItems.length > 1 ? "${_batchItems.length} PDFs" : "PDF"} to Firebase',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
      bool isDark, String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      filled: true,
      fillColor: isDark ? AppColors.surfaceDark : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}

class _BatchPdfItem {
  final PlatformFile file;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  double progress;
  String status; // 'queued', 'uploading', 'success', 'error'
  String? error;

  _BatchPdfItem({
    required this.file,
    required String title,
    String description = '',
    this.progress = 0.0,
    this.status = 'queued',
    this.error,
  })  : titleController = TextEditingController(text: title),
        descriptionController = TextEditingController(text: description);

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
  }
}

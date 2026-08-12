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
  String _selectedSectionType = 'Textbook';

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<SemesterModel> _availableSemesters = [];
  List<SubjectModel> _availableSubjects = [];

  PlatformFile? _selectedFile;
  bool _isLoadingHierarchy = false;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String? _uploadError;
  bool _isSuccess = false;

  static const int _maxFileSizeBytes = 50 * 1024 * 1024; // 50 MB limit

  @override
  void initState() {
    super.initState();
    _loadYears();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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

  Future<void> _pickPdfFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // Extension check
        if (file.extension?.toLowerCase() != 'pdf') {
          _showSnackBar('Invalid File: Only PDF documents (.pdf) are allowed.');
          return;
        }

        // Size check
        if (file.size > _maxFileSizeBytes) {
          _showSnackBar('File Too Large: Maximum allowed size is 50 MB.');
          return;
        }

        setState(() {
          _selectedFile = file;
          _uploadError = null;
          if (_titleController.text.isEmpty) {
            final nameWithoutExt = file.name.replaceAll(RegExp(r'\.pdf$', caseSensitive: false), '');
            _titleController.text = nameWithoutExt;
          }
        });
      }
    } catch (e) {
      _showSnackBar('Error picking file: $e');
    }
  }

  Future<void> _startUpload() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedYear == null || _selectedSemester == null || _selectedSubject == null) {
      _showSnackBar('Please select Academic Year, Semester, and Subject.');
      return;
    }

    if (_selectedFile == null || _selectedFile!.bytes == null) {
      _showSnackBar('Please choose a valid PDF file to upload.');
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _uploadError = null;
      _isSuccess = false;
    });

    try {
      final studyRepository = context.read<StudyProvider>().repository;

      await studyRepository.uploadAdminPdfResource(
        year: _selectedYear!,
        semester: _selectedSemester!,
        subject: _selectedSubject!,
        resourceType: _selectedResourceType,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        fileName: _selectedFile!.name,
        pdfBytes: _selectedFile!.bytes!,
        sectionType: _selectedSectionType,
        onProgress: (progress) {
          if (mounted) {
            setState(() {
              _uploadProgress = progress;
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadProgress = 1.0;
          _isSuccess = true;
        });

        // Trigger global provider refresh
        context.read<StudyProvider>().fetchResources(_selectedSubject!.id);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadError = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  void _resetForm() {
    setState(() {
      _selectedFile = null;
      _titleController.clear();
      _descriptionController.clear();
      _uploadProgress = 0.0;
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
        title: 'Admin PDF Upload Portal',
        subtitle: 'Upload official CSSE syllabus, study notes & question papers',
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
                    Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 36),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CSSE Academic Repository Management',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Upload study resources directly to Firebase Storage & Firestore.',
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

              // --- Step 1: Academic Hierarchy Dropdowns ---
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
                decoration: _buildInputDecoration(isDark, 'Academic Year', Icons.school_rounded),
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
                decoration: _buildInputDecoration(isDark, 'Semester', Icons.calendar_view_day_rounded),
                items: _availableSemesters.map((s) {
                  return DropdownMenuItem<SemesterModel>(
                    value: s,
                    child: Text(s.title),
                  );
                }).toList(),
                onChanged: _onSemesterChanged,
                validator: (val) => val == null ? 'Please select Semester' : null,
              ),

              const SizedBox(height: 14),

              // Subject Dropdown
              DropdownButtonFormField<SubjectModel>(
                value: _selectedSubject,
                decoration: _buildInputDecoration(isDark, 'Subject', Icons.book_rounded),
                items: _availableSubjects.map((sub) {
                  return DropdownMenuItem<SubjectModel>(
                    value: sub,
                    child: Text('${sub.name} (${sub.code})'),
                  );
                }).toList(),
                onChanged: (sub) => setState(() => _selectedSubject = sub),
                validator: (val) => val == null ? 'Please select Subject' : null,
              ),

              const SizedBox(height: 14),

              // Resource Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedResourceType,
                decoration: _buildInputDecoration(isDark, 'Resource Format', Icons.category_rounded),
                items: AppConstants.resourceTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (type) {
                  if (type != null) setState(() => _selectedResourceType = type);
                },
              ),

              const SizedBox(height: 14),

              // Textbook Section Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedSectionType,
                decoration: _buildInputDecoration(isDark, 'Subject Learning Section', Icons.auto_stories_rounded),
                items: const [
                  'Textbook',
                  'Important Questions',
                  'Previous Papers',
                  'Quick Revision',
                  'Practical / Lab',
                  'Assignments',
                  'Projects',
                  'Additional Resources',
                ].map((sec) {
                  return DropdownMenuItem<String>(
                    value: sec,
                    child: Text(sec),
                  );
                }).toList(),
                onChanged: (sec) {
                  if (sec != null) setState(() => _selectedSectionType = sec);
                },
              ),

              const SizedBox(height: 24),

              // --- Step 2: File Picker & Preview ---
              Text(
                '2. Choose PDF Document',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),

              InkWell(
                onTap: _pickPdfFile,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedFile != null ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                      width: _selectedFile != null ? 2 : 1,
                    ),
                  ),
                  child: _selectedFile == null
                      ? Column(
                          children: [
                            const Icon(Icons.picture_as_pdf_rounded, size: 40, color: AppColors.primary),
                            const SizedBox(height: 8),
                            const Text(
                              'Click to Browse PDF File',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Only PDF files allowed (Max 50 MB)',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            const Icon(Icons.picture_as_pdf_rounded, size: 36, color: Colors.redAccent),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedFile!.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${(_selectedFile!.size / (1024 * 1024)).toStringAsFixed(2)} MB',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.change_circle_outlined, color: AppColors.primary),
                              onPressed: _pickPdfFile,
                              tooltip: 'Change File',
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // --- Step 3: Document Metadata ---
              Text(
                '3. Document Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _titleController,
                decoration: _buildInputDecoration(isDark, 'Document Title', Icons.title_rounded),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter Document Title' : null,
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: _buildInputDecoration(isDark, 'Description (Optional)', Icons.description_rounded),
              ),

              const SizedBox(height: 24),

              // --- Upload Progress / Status View ---
              if (_isUploading) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Uploading to Firebase Storage...',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          '${(_uploadProgress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _uploadProgress,
                        minHeight: 8,
                        backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
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
                      const Icon(Icons.error_outline_rounded, color: Colors.redAccent),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _uploadError!,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                        ),
                      ),
                      TextButton(
                        onPressed: _startUpload,
                        child: const Text('Retry'),
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
                      const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload Complete!',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 15),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Document is now live on Firestore & student application.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: _resetForm,
                        child: const Text('Upload Another'),
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
                  onPressed: _isUploading ? null : _startUpload,
                  icon: _isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.cloud_upload_rounded),
                  label: Text(
                    _isUploading ? 'Uploading PDF...' : 'Upload PDF to Firebase',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  InputDecoration _buildInputDecoration(bool isDark, String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      filled: true,
      fillColor: isDark ? AppColors.surfaceDark : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}

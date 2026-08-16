import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/resource_model.dart';
import '../../providers/bookmark_provider.dart';
import '../../providers/download_provider.dart';
import '../../providers/recent_provider.dart';

class PdfViewerScreen extends StatefulWidget {
  final ResourceModel resource;

  const PdfViewerScreen({
    super.key,
    required this.resource,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PDFViewController? _pdfViewController;
  int _totalPages = 0;
  int _currentPage = 0;
  bool _isReady = false;
  String? _localFilePath;
  bool _isLoadingFile = true;
  String? _errorMessage;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _preparePdfFile();
      }
    });
  }

  Future<void> _preparePdfFile() async {
    final recentProvider = context.read<RecentProvider>();
    final downloadProvider = context.read<DownloadProvider>();

    // Initial page load attempt (auto-resume last read page)
    final savedPage = recentProvider.getLastReadPage(widget.resource.id);
    _currentPage = (savedPage > 0) ? savedPage - 1 : 0;

    // For Web, downloadProvider.downloadPdf() instantly resolves the secure Firebase Storage URL and returns it.

    // Check if file is downloaded locally
    final isDownloaded = downloadProvider.isResourceDownloaded(widget.resource.id);
    if (isDownloaded) {
      final res = downloadProvider.getDownloadedResource(widget.resource.id);
      if (res?.localFilePath != null) {
        setState(() {
          _localFilePath = res!.localFilePath;
          _isLoadingFile = false;
        });
        recentProvider.recordResourceOpened(
          widget.resource,
          lastReadPage: _currentPage + 1,
        );
        return;
      }
    }

    // Stream/Download from Firebase Storage
    try {
      final downloadedPath = await downloadProvider.downloadPdf(widget.resource);
      if (mounted) {
        setState(() {
          _localFilePath = downloadedPath;
          _isLoadingFile = false;
        });
        recentProvider.recordResourceOpened(
          widget.resource,
          lastReadPage: _currentPage + 1,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'Could not load PDF document. Please check network connection or try downloading for offline access.';
          _isLoadingFile = false;
        });
      }
    }
  }

  void _onPageChanged(int? page, int? total) {
    if (page == null) return;
    setState(() {
      _currentPage = page;
      _totalPages = total ?? _totalPages;
    });

    final recentProvider = context.read<RecentProvider>();
    recentProvider.updateLastReadPage(widget.resource.id, page + 1);
    recentProvider.recordResourceOpened(
      widget.resource,
      lastReadPage: page + 1,
      totalPages: _totalPages > 0 ? _totalPages : 1,
    );
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bookmarkProvider = context.watch<BookmarkProvider>();
    final isPageBookmarked = bookmarkProvider.isBookmarked(
      widget.resource.id,
      pageNumber: _currentPage + 1,
    );

    final readingProgress =
        _totalPages > 0 ? ((_currentPage + 1) / _totalPages * 100).toStringAsFixed(0) : '0';

    const royalBlue = Color(0xFF2563EB);

    return Scaffold(
      appBar: _isFullScreen
          ? null
          : AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.resource.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_isReady && !kIsWeb)
                    Text(
                      'Page ${_currentPage + 1} of $_totalPages ($readingProgress%)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isPageBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    color: isPageBookmarked ? royalBlue : null,
                  ),
                  tooltip: 'Bookmark Page',
                  onPressed: () {
                    bookmarkProvider.toggleBookmark(
                      widget.resource,
                      pageNumber: kIsWeb ? null : _currentPage + 1,
                      note: kIsWeb ? null : 'Page ${_currentPage + 1}',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isPageBookmarked
                              ? 'Removed bookmark from Page ${_currentPage + 1}'
                              : 'Bookmarked Page ${_currentPage + 1}',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline_rounded),
                  tooltip: 'File Information',
                  onPressed: () => _showFileInformationDialog(),
                ),
                if (!kIsWeb)
                  IconButton(
                    icon: const Icon(Icons.import_contacts_rounded),
                    tooltip: 'Jump to Page',
                    onPressed: () => _showJumpToPageDialog(),
                  ),
                IconButton(
                  icon: Icon(_isFullScreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded),
                  tooltip: _isFullScreen ? 'Exit Full Screen' : 'Full Screen Reading',
                  onPressed: _toggleFullScreen,
                ),
              ],
            ),
      body: GestureDetector(
        onDoubleTap: _toggleFullScreen,
        child: _isLoadingFile
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: royalBlue),
                    const SizedBox(height: 16),
                    Text(
                      'Loading PDF Document...',
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.resource.title,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              )

            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.orange),
                          const SizedBox(height: 16),
                          Text(
                            'Offline Document Access',
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _isLoadingFile = true;
                                _errorMessage = null;
                              });
                              _preparePdfFile();
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Retry Loading'),
                          ),
                        ],
                      ),
                    ),
                  )
                : kIsWeb
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(20),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.picture_as_pdf_rounded,
                                  size: 54,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                widget.resource.title,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Show Archive.org processing notice for newly uploaded files
                              if (_isArchiveOrgUrl(_localFilePath ?? widget.resource.storageUrl)) ...[
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withAlpha(25),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.amber.withAlpha(80)),
                                  ),
                                  child: Column(
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(Icons.schedule_rounded, color: Colors.amber, size: 22),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              'Recently Uploaded — Processing',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'This document was recently uploaded to Archive.org. '
                                        'New files typically take 30–60 minutes to become available for viewing. '
                                        'Please try again shortly.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  'Web PDF Stream Ready. Click below to view in browser tab.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ],

                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  try {
                                    final urlStr = (_localFilePath ?? widget.resource.storageUrl).trim();
                                    if (urlStr.isEmpty) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('No external document URL available for this resource.'),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                      }
                                      return;
                                    }
                                    final Uri uri = Uri.parse(urlStr);
                                    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
                                    if (!launched && context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Could not open document URL: $urlStr'),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Error opening document: $e'),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                                label: Text(
                                  _isArchiveOrgUrl(_localFilePath ?? widget.resource.storageUrl)
                                      ? 'Try Opening PDF'
                                      : 'Open PDF Document',
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          PDFView(
                            filePath: _localFilePath,
                            enableSwipe: true,
                            swipeHorizontal: false,
                            autoSpacing: true,
                            pageFling: true,
                            pageSnap: true,
                            defaultPage: _currentPage,
                            onRender: (pages) {
                              setState(() {
                                _totalPages = pages ?? 0;
                                _isReady = true;
                              });
                              if (_currentPage > 0 && _pdfViewController != null) {
                                _pdfViewController?.setPage(_currentPage);
                              }
                            },
                            onError: (error) {
                              setState(() {
                                _errorMessage = error.toString();
                              });
                            },
                            onPageChanged: _onPageChanged,
                            onViewCreated: (PDFViewController controller) {
                              _pdfViewController = controller;
                            },
                          ),
                          if (!_isReady)
                            const Center(child: CircularProgressIndicator()),
                          if (_isFullScreen)
                            Positioned(
                              top: 40,
                              right: 16,
                              child: FloatingActionButton.small(
                                backgroundColor: AppColors.primary,
                                onPressed: _toggleFullScreen,
                                child: const Icon(Icons.fullscreen_exit_rounded, color: Colors.white),
                              ),
                            ),
                        ],
                      ),
      ),
      bottomNavigationBar: (_isReady && !kIsWeb && !_isFullScreen)
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.navigate_before_rounded),
                    onPressed: _currentPage > 0
                        ? () {
                            _pdfViewController?.setPage(_currentPage - 1);
                          }
                        : null,
                  ),
                  Text(
                    'Page ${_currentPage + 1} / $_totalPages ($readingProgress%)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.navigate_next_rounded),
                    onPressed: _currentPage < _totalPages - 1
                        ? () {
                            _pdfViewController?.setPage(_currentPage + 1);
                          }
                        : null,
                  ),
                ],
              ),
            )
          : null,
    );
  }

  void _showJumpToPageDialog() {
    final controller = TextEditingController(text: '${_currentPage + 1}');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Jump to Page'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Page Number (1 - $_totalPages)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final page = int.tryParse(controller.text);
              if (page != null && page >= 1 && page <= _totalPages) {
                _pdfViewController?.setPage(page - 1);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Go'),
          ),
        ],
      ),
    );
  }

  void _showFileInformationDialog() {
    final res = widget.resource;
    final sizeKb = (res.fileSizeBytes / 1024).toStringAsFixed(1);
    final sizeMb = (res.fileSizeBytes / (1024 * 1024)).toStringAsFixed(2);
    final sizeString = res.fileSizeBytes > 1024 * 1024 ? '$sizeMb MB' : '$sizeKb KB';

    final lastUpdated = DateFormat.yMMMd().format(res.lastUpdated);
    final readingProgress =
        _totalPages > 0 ? ((_currentPage + 1) / _totalPages * 100).toStringAsFixed(0) : '0';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('File Information'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _infoRow('Title', res.title),
              _infoRow('Subject', res.subjectName),
              _infoRow('Year / Semester', '${res.yearId} / ${res.semesterId}'),
              _infoRow('Resource Category', res.resourceType),
              _infoRow('File Size', sizeString),
              _infoRow('Last Updated', lastUpdated),
              _infoRow('Downloads', '${res.downloadCount}'),
              _infoRow('Reading Progress', 'Page ${_currentPage + 1} of $_totalPages ($readingProgress%)'),
              if (_localFilePath != null) _infoRow('Storage Path', _localFilePath!),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  /// Check if the URL is from Archive.org (processing delay applies)
  bool _isArchiveOrgUrl(String url) {
    return url.contains('archive.org');
  }
}

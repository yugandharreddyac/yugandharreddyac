import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../providers/download_provider.dart';
import '../pdf_viewer/pdf_viewer_screen.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<DownloadProvider>().loadDownloadedResources();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final downloadProvider = context.watch<DownloadProvider>();
    final downloadedList = downloadProvider.downloadedResources;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF4F4F5);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE4E4E7);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF09090B);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF71717A);

    const orangeAccent = AppColors.primary;
    const emeraldGreen = Color(0xFF10B981);

    // Storage calculation
    final totalBytes = downloadProvider.totalDownloadedSizeBytes;
    final totalMb = (totalBytes / (1024 * 1024)).toStringAsFixed(1);
    const maxStorageMb = 500.0;
    final storageProgress = ((totalBytes / (1024 * 1024)) / maxStorageMb).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          tooltip: 'Back',
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
        ),
        title: Text(
          'Downloads Manager',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: textPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: cardColor,
        elevation: 0,
        actions: [
          if (downloadedList.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
              tooltip: 'Clear All Downloads',
              onPressed: () {
                _showClearAllDialog(context, downloadProvider);
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ==========================================
          // 1. STORAGE USED METER WIDGET
          // ==========================================
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 30 : 6),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: orangeAccent.withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.sd_storage_rounded, color: orangeAccent, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Offline Storage Used',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$totalMb MB / 500 MB',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: orangeAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: storageProgress > 0 ? storageProgress : 0.02,
                    minHeight: 8,
                    backgroundColor: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                    color: orangeAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${downloadedList.length} downloaded PDF files ready for offline reading.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: textSubtitle,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ==========================================
          // 2. HEADER BAR & SORT OPTIONS
          // ==========================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Downloaded Files',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: orangeAccent.withAlpha(15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${downloadedList.length} Items',
                  style: GoogleFonts.inter(
                    color: orangeAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ==========================================
          // 3. DOWNLOADED LIST OR PROFESSIONAL EMPTY STATE
          // ==========================================
          if (downloadedList.isEmpty)
            _buildEmptyDownloadsState(context, textPrimary, textSubtitle, orangeAccent, isDark, cardColor, borderColor)
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: downloadedList.length,
              itemBuilder: (context, index) {
                final resource = downloadedList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(isDark ? 30 : 6),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: emeraldGreen.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.offline_pin_rounded, color: emeraldGreen, size: 22),
                    ),
                    title: Text(
                      resource.title,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: textPrimary,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: orangeAccent.withAlpha(15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              resource.resourceType,
                              style: GoogleFonts.inter(
                                color: orangeAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            Formatters.formatFileSize(resource.fileSizeBytes),
                            style: GoogleFonts.inter(fontSize: 13, color: textSubtitle),
                          ),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                          tooltip: 'Delete File',
                          onPressed: () {
                            downloadProvider.deleteDownload(resource.id);
                          },
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PdfViewerScreen(resource: resource),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyDownloadsState(
    BuildContext context,
    Color textPrimary,
    Color textSubtitle,
    Color orangeAccent,
    bool isDark,
    Color cardColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 6),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: orangeAccent.withAlpha(15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.cloud_download_outlined, color: orangeAccent, size: 48),
          ),
          const SizedBox(height: 16),
          Text(
            'No Downloads Yet',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Download lecture notes and previous question papers to read offline anytime without internet access.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: textSubtitle,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
            icon: const Icon(Icons.search_rounded, size: 18),
            label: Text(
              'Explore Resources ➔',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: orangeAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, DownloadProvider downloadProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Clear All Downloads?',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This will delete all saved PDF files from your device offline storage.',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              for (var r in List.from(downloadProvider.downloadedResources)) {
                downloadProvider.deleteDownload(r.id);
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Clear All', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

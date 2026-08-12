import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/share_helper.dart';
import '../../data/models/resource_model.dart';
import '../providers/bookmark_provider.dart';
import '../providers/download_provider.dart';

class ResourceCard extends StatefulWidget {
  final ResourceModel resource;
  final VoidCallback onTap;
  final int index;

  const ResourceCard({
    super.key,
    required this.resource,
    required this.onTap,
    this.index = 0,
  });

  @override
  State<ResourceCard> createState() => _ResourceCardState();
}

class _ResourceCardState extends State<ResourceCard> {
  bool _isHovered = false;

  String _getCategoryBadge(String resourceType) {
    switch (resourceType) {
      case AppConstants.typeSyllabus:
        return '📖 Syllabus';
      case AppConstants.typeNotes:
        return '📝 Notes';
      case AppConstants.typePastPapers:
        return '📄 Previous Papers';
      default:
        return '📁 Study Document';
    }
  }

  bool _isNew(DateTime lastUpdated) {
    return DateTime.now().difference(lastUpdated).inDays <= 7;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bookmarkProvider = context.watch<BookmarkProvider>();
    final downloadProvider = context.watch<DownloadProvider>();

    final isBookmarked = bookmarkProvider.isBookmarked(widget.resource.id);
    final isDownloaded = downloadProvider.isDownloaded(widget.resource.id);
    final isDownloading = downloadProvider.isDownloading(widget.resource.id);
    final downloadProgress = downloadProvider.getProgress(widget.resource.id);

    final typeColor = Formatters.getResourceTypeColor(widget.resource.resourceType);
    final categoryBadge = _getCategoryBadge(widget.resource.resourceType);
    final isNewItem = _isNew(widget.resource.lastUpdated);

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: _isHovered ? (Matrix4.identity()..translate(0, -3)) : Matrix4.identity(),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(18),
              splashColor: typeColor.withAlpha(20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _isHovered
                        ? typeColor
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    width: _isHovered ? 1.6 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? typeColor.withAlpha(40)
                          : Colors.black.withAlpha(isDark ? 25 : 6),
                      blurRadius: _isHovered ? 16 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Header Row with Badges
                    Row(
                      children: [
                        // Category Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: typeColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: typeColor.withAlpha(50)),
                          ),
                          child: Text(
                            categoryBadge,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: typeColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // New Badge
                        if (isNewItem) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withAlpha(20),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],

                        // Featured Badge
                        if (widget.resource.isFeatured) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.amber.withAlpha(25),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                                SizedBox(width: 2),
                                Text(
                                  'Featured',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],

                        const Spacer(),

                        // Native Share Trigger
                        IconButton(
                          icon: const Icon(Icons.share_outlined, size: 18, color: Colors.grey),
                          onPressed: () {
                            ShareHelper.shareResource(context, widget.resource);
                          },
                        ),

                        // Bookmark Toggle
                        IconButton(
                          icon: Icon(
                            isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                            color: isBookmarked ? AppColors.primary : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            bookmarkProvider.toggleBookmark(widget.resource);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Resource Title
                    Text(
                      widget.resource.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.3,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Description / Subtitle
                    Text(
                      widget.resource.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Bottom Metadata & Action Bar
                    Row(
                      children: [
                        const Icon(Icons.picture_as_pdf_rounded, size: 16, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          Formatters.formatBytes(widget.resource.fileSizeBytes),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.download_rounded, size: 14, color: AppColors.primary),
                        const SizedBox(width: 2),
                        Text(
                          '${widget.resource.downloadCount}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.calendar_today_rounded, size: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            Formatters.formatDate(widget.resource.lastUpdated),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Action Buttons: Open & Download
                        if (isDownloading) ...[
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              value: downloadProgress > 0 ? downloadProgress : null,
                              strokeWidth: 2.5,
                              color: AppColors.primary,
                            ),
                          ),
                        ] else ...[
                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(6),
                            tooltip: isDownloaded ? 'Downloaded Offline' : 'Download PDF',
                            icon: Icon(
                              isDownloaded ? Icons.check_circle_rounded : Icons.file_download_outlined,
                              color: isDownloaded ? AppColors.primary : AppColors.primary,
                              size: 22,
                            ),
                            onPressed: () async {
                              if (!isDownloaded) {
                                await downloadProvider.downloadPdf(widget.resource);
                              }
                            },
                          ),
                          const SizedBox(width: 4),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: widget.onTap,
                            icon: const Icon(Icons.picture_as_pdf_rounded, size: 14),
                            label: const Text('Open', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 300.ms, delay: (widget.index * 50).ms),
      ),
    );
  }
}

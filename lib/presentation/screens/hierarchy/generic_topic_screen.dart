import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/url_launcher_util.dart';
import '../../../data/models/hierarchy_node_model.dart';
import '../../../data/models/resource_model.dart';
import '../../providers/bookmark_provider.dart';
import '../../providers/recent_provider.dart';
import '../../widgets/hierarchy/breadcrumb_bar.dart';

class GenericTopicScreen extends StatefulWidget {
  final HubModel hub;
  final CategoryModel category;
  final HierarchicalTopicModel topic;
  final LearningLevel? level;
  final List<String> breadcrumbTrail;

  const GenericTopicScreen({
    super.key,
    required this.hub,
    required this.category,
    required this.topic,
    this.level,
    required this.breadcrumbTrail,
  });

  @override
  State<GenericTopicScreen> createState() => _GenericTopicScreenState();
}

class _GenericTopicScreenState extends State<GenericTopicScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          final recentProvider = context.read<RecentProvider>();
          recentProvider.recordResourceOpened(
            ResourceModel(
              id: widget.topic.id,
              title: widget.topic.title,
              description: widget.topic.description,
              subjectId: widget.hub.id,
              subjectName: '${widget.hub.title} › ${widget.category.title}',
              yearId: 'non_academic',
              semesterId: 'non_academic',
              resourceType: widget.level?.displayName ?? 'Topic',
              storageUrl: widget.topic.resources.isNotEmpty ? widget.topic.resources.first.url : '',
              fileSizeBytes: 0,
              lastUpdated: DateTime.now(),
            ),
          );
        } catch (_) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);

    const royalBlue = Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          widget.topic.title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textPrimary,
          ),
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumbs Bar (Deep path tracking)
                BreadcrumbBar(
                  items: _buildBreadcrumbs(context),
                ),
                const SizedBox(height: 16),

                // Topic Banner Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(isDark ? 20 : 6),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
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
                              color: royalBlue.withAlpha(20),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(widget.topic.icon, color: royalBlue, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.topic.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary,
                                  ),
                                ),
                                if (widget.level != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.level!.displayName,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: royalBlue,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.topic.description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: textSubtitle,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: -0.04, end: 0),

                const SizedBox(height: 24),

                // IF TOPIC HAS SUBTOPICS: Render Subtopics List
                if (widget.topic.hasSubtopics) ...[
                  Text(
                    'Explore Subtopics',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.topic.subtopics.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final subtopic = widget.topic.subtopics[index];
                      return _buildSubtopicCard(
                        context,
                        subtopic: subtopic,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                        textSubtitle: textSubtitle,
                        royalBlue: royalBlue,
                        isDark: isDark,
                      ).animate().fadeIn(delay: (index * 40).ms).slideX(begin: 0.03, end: 0);
                    },
                  ),
                  const SizedBox(height: 24),
                ],

                // IF TOPIC HAS DIRECT RESOURCES: Render Resource Cards
                if (widget.topic.hasResources) ...[
                  Text(
                    'Learning Resources',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.topic.resources.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final resource = widget.topic.resources[index];
                      return _buildResourceCard(
                        context,
                        resource: resource,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                        textSubtitle: textSubtitle,
                        isDark: isDark,
                      ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.04, end: 0);
                    },
                  ),
                ],

                if (!widget.topic.hasSubtopics && !widget.topic.hasResources)
                  _buildEmptyResourceState(isDark, cardBg, borderColor, textPrimary, textSubtitle),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<BreadcrumbItem> _buildBreadcrumbs(BuildContext context) {
    final List<BreadcrumbItem> items = [];

    items.add(
      BreadcrumbItem(
        label: 'Home',
        onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
      ),
    );

    for (int i = 0; i < widget.breadcrumbTrail.length; i++) {
      final label = widget.breadcrumbTrail[i];
      final isLast = i == widget.breadcrumbTrail.length - 1;

      items.add(
        BreadcrumbItem(
          label: label,
          onTap: isLast ? null : () => Navigator.pop(context),
        ),
      );
    }

    return items;
  }

  Widget _buildSubtopicCard(
    BuildContext context, {
    required HierarchicalTopicModel subtopic,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSubtitle,
    required Color royalBlue,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GenericTopicScreen(
              hub: widget.hub,
              category: widget.category,
              topic: subtopic,
              level: widget.level,
              breadcrumbTrail: [...widget.breadcrumbTrail, subtopic.title],
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 20 : 5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: royalBlue.withAlpha(18),
                shape: BoxShape.circle,
              ),
              child: Icon(subtopic.icon, color: royalBlue, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtopic.title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtopic.description,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: textSubtitle,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(
    BuildContext context, {
    required HierarchyResourceModel resource,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSubtitle,
    required bool isDark,
  }) {
    final resColor = resource.type.color;
    final resIcon = resource.type.icon;

    BookmarkProvider? bookmarkProvider;
    try {
      bookmarkProvider = context.watch<BookmarkProvider>();
    } catch (_) {}

    final bool isBookmarked = bookmarkProvider?.isBookmarked(resource.id) ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 20 : 5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: resColor.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(resIcon, color: resColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: resColor.withAlpha(18),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            resource.type.displayName,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: resColor,
                            ),
                          ),
                        ),
                        if (resource.platform != null) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '• ${resource.platform}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: textSubtitle,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      resource.title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      resource.description,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: textSubtitle,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              if (bookmarkProvider != null)
                IconButton(
                  onPressed: () {
                    final resModel = ResourceModel(
                      id: resource.id,
                      title: resource.title,
                      description: resource.description,
                      subjectId: widget.hub.id,
                      subjectName: '${widget.hub.title} › ${widget.category.title}',
                      yearId: 'non_academic',
                      semesterId: 'non_academic',
                      resourceType: resource.type.displayName,
                      storageUrl: resource.url,
                      fileSizeBytes: 0,
                      lastUpdated: DateTime.now(),
                    );
                    context.read<BookmarkProvider>().toggleBookmark(resModel);
                  },
                  icon: Icon(
                    isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                    color: isBookmarked ? resColor : Colors.grey,
                    size: 22,
                  ),
                  tooltip: isBookmarked ? 'Remove Bookmark' : 'Bookmark Resource',
                ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {
                UrlLauncherUtil.openUrl(context, resource.url);
              },
              icon: Icon(
                resource.type == HierarchyResourceType.learnOnline
                    ? Icons.open_in_new_rounded
                    : Icons.arrow_forward_rounded,
                size: 18,
              ),
              label: Text(
                resource.type == HierarchyResourceType.learnOnline
                    ? 'Open Online Resource'
                    : 'Access ${resource.type.displayName}',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: resColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyResourceState(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSubtitle,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(Icons.folder_open_rounded, size: 48, color: textSubtitle.withAlpha(150)),
          const SizedBox(height: 12),
          Text(
            'No learning resources added yet',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'New notes and interactive guides will appear here soon.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: textSubtitle,
            ),
          ),
        ],
      ),
    );
  }
}

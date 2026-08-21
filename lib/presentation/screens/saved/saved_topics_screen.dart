import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/datasources/non_academic_data.dart';
import '../../providers/roadmap_provider.dart';
import '../hierarchy/generic_topic_screen.dart';

class SavedTopicsScreen extends StatelessWidget {
  const SavedTopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roadmapProvider = context.watch<RoadmapProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const royalBlue = Color(0xFF2563EB);
    const emeraldGreen = Color(0xFF059669);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubtitle =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    final bookmarkedIds = roadmapProvider.bookmarkedTopicIds;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Topics & Bookmarks',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: bookmarkedIds.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_outline_rounded,
                        size: 64, color: textSubtitle.withAlpha(120)),
                    const SizedBox(height: 16),
                    Text(
                      'No Saved Topics Yet',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the bookmark icon on any educational topic to save it here for quick access.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: textSubtitle,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: bookmarkedIds.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final topicId = bookmarkedIds[index];
                final match = NonAcademicData.findTopicById(topicId);
                final topicTitle = match?.topic.title ?? topicId;
                final categoryTitle = match?.category.title ?? 'CSSED Module';
                final progress = roadmapProvider.getProgressForTopic(topicId);

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: royalBlue.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          progress.isFullyCompleted
                              ? Icons.check_circle_rounded
                              : Icons.bookmark_rounded,
                          color: progress.isFullyCompleted
                              ? emeraldGreen
                              : royalBlue,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topicTitle,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$categoryTitle • ${progress.completedCount}/4 activities (${progress.percentage.toStringAsFixed(0)}%)',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: textSubtitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_remove_rounded,
                            color: Colors.grey),
                        tooltip: 'Remove Bookmark',
                        onPressed: () {
                          roadmapProvider.toggleTopicBookmark(topicId);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 16, color: royalBlue),
                        onPressed: () {
                          if (match != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GenericTopicScreen(
                                  hub: match.hub,
                                  category: match.category,
                                  topic: match.topic,
                                  breadcrumbTrail: [
                                    match.hub.title,
                                    match.category.title,
                                    match.topic.title
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

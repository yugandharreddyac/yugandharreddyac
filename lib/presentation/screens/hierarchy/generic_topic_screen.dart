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
import '../../providers/roadmap_provider.dart';
import '../../../data/models/user_goal_model.dart';
import '../../../data/datasources/non_academic_data.dart';
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

        try {
          final roadmapProvider = context.read<RoadmapProvider>();
          roadmapProvider.recordTopicOpened(widget.topic.id);
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

    RoadmapProvider? roadmapProvider;
    TopicProgressModel? progress;
    try {
      roadmapProvider = context.watch<RoadmapProvider>();
      progress = roadmapProvider.getProgressForTopic(widget.topic.id);
    } catch (_) {}
    final isBookmarked = roadmapProvider?.isTopicBookmarked(widget.topic.id) ?? false;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
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
          widget.topic.title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
              color: isBookmarked ? royalBlue : textSubtitle,
            ),
            tooltip: isBookmarked ? 'Remove Bookmark' : 'Bookmark Topic',
            onPressed: () {
              roadmapProvider?.toggleTopicBookmark(widget.topic.id);
            },
          ),
        ],
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

                if (roadmapProvider != null)
                  _buildActiveLearningBanner(context, roadmapProvider, isDark, royalBlue, textPrimary),
                  
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
                      const SizedBox(height: 16),
                      
                      // STATUS & PROGRESS
                      if (progress != null) ...[
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: progress.isFullyCompleted ? const Color(0xFF10B981) : (progress.isInProgress ? royalBlue : textSubtitle.withAlpha(50)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                progress.isFullyCompleted ? 'COMPLETED' : (progress.isInProgress ? 'IN PROGRESS' : 'NOT STARTED'),
                                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: progress.isFullyCompleted || progress.isInProgress ? Colors.white : textPrimary),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${progress.completedCount} / 4 Activities',
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: textSubtitle),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: royalBlue.withAlpha(isDark ? 30 : 15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: royalBlue.withAlpha(isDark ? 80 : 40),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.lightbulb_outline_rounded,
                              color: royalBlue,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'WHY THIS MATTERS',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: royalBlue,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Mastering ${widget.topic.title} builds core engineering intuition required for technical coding interviews, software architecture design, and competitive CS assessments.${_getCareerConnection(context)}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: textPrimary,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // NEXT ACTION (If Completed)
                      if (progress != null && progress.isFullyCompleted) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF10B981).withAlpha(50),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.next_plan_rounded, color: Color(0xFF10B981), size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'NEXT ACTION',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF10B981),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Return to your dashboard or My Roadmap to proceed to the next recommended topic.',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: textPrimary,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: -0.04, end: 0),

                const SizedBox(height: 20),

                // ==========================================
                // REAL TOPIC PROGRESS & ACTIVITY CHECKLIST
                // ==========================================
                _buildActivityChecklistCard(
                  context,
                  topicId: widget.topic.id,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSubtitle: textSubtitle,
                  royalBlue: royalBlue,
                  isDark: isDark,
                ),

                const SizedBox(height: 24),
                
                Consumer<RoadmapProvider>(
                  builder: (context, provider, child) {
                    final skills = provider.getSkillsForTopic(widget.topic.id);
                    if (skills.isEmpty) return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Skill Evidence',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...skills.map((s) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(s.skillName, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: textPrimary)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: royalBlue.withAlpha(isDark ? 30 : 15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  s.level.name.toUpperCase(),
                                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: royalBlue),
                                ),
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(height: 24),
                      ],
                    );
                  },
                ),

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
                  
                if (roadmapProvider != null && roadmapProvider.getProgressForTopic(widget.topic.id).isFullyCompleted)
                  _buildNextTopicSection(context, roadmapProvider, isDark, cardBg, borderColor, royalBlue, textPrimary, textSubtitle),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCareerConnection(BuildContext context) {
    try {
      final roadmapProvider = context.read<RoadmapProvider>();
      final goal = roadmapProvider.profile?.goal;
      if (goal != null) {
         return '\n\nCAREER CONNECTION\nThis topic directly contributes to your chosen goal: ${goal.title}.';
      }
    } catch (_) {}
    return '';
  }

  Widget _buildActiveLearningBanner(BuildContext context, RoadmapProvider provider, bool isDark, Color royalBlue, Color textPrimary) {
    final progress = provider.getProgressForTopic(widget.topic.id);
    
    String stateLabel = 'NOT STARTED';
    Color stateColor = Colors.grey;
    String nextAction = 'LEARN';
    
    if (progress.isFullyCompleted) {
      stateLabel = 'COMPLETED ✓';
      stateColor = Colors.green;
      return const SizedBox.shrink(); // Hidden if completed
    } else if (progress.isInProgress) {
      stateLabel = 'IN PROGRESS';
      stateColor = royalBlue;
      if (!progress.learnCompleted) {
        nextAction = 'LEARN';
      } else if (!progress.practiceCompleted) {
        nextAction = 'PRACTICE';
      } else if (!progress.buildCompleted) {
        nextAction = 'BUILD';
      } else if (!progress.reviewCompleted) {
        nextAction = 'REVIEW';
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: stateColor.withAlpha(isDark ? 40 : 20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: stateColor.withAlpha(isDark ? 80 : 40)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status: $stateLabel',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: stateColor),
              ),
              const SizedBox(height: 4),
              Text(
                'Next Action: $nextAction',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
              ),
            ],
          ),
          if (progress.isInProgress)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: stateColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text('CONTINUE →', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildNextTopicSection(BuildContext context, RoadmapProvider provider, bool isDark, Color cardBg, Color borderColor, Color royalBlue, Color textPrimary, Color textSubtitle) {
    final nextTopicId = provider.getNextRecommendedTopicId(widget.topic.id);
    if (nextTopicId == null) return const SizedBox.shrink();

    final nextTopicMatch = NonAcademicData.findTopicById(nextTopicId);
    if (nextTopicMatch == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: royalBlue.withAlpha(isDark ? 40 : 15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: royalBlue.withAlpha(isDark ? 80 : 40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 40),
            const SizedBox(height: 12),
            Text('TOPIC COMPLETED ✓', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 8),
            Text('NEXT RECOMMENDED TOPIC', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: textSubtitle)),
            const SizedBox(height: 4),
            Text(nextTopicMatch.topic.title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GenericTopicScreen(
                      topic: nextTopicMatch.topic,
                      hub: nextTopicMatch.hub,
                      category: nextTopicMatch.category,
                      breadcrumbTrail: [nextTopicMatch.hub.title, nextTopicMatch.category.title],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('CONTINUE TO NEXT →', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
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
              icon: const Icon(
                Icons.open_in_new_rounded,
                size: 18,
              ),
              label: Text(
                _getActionTextForResource(resource),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.5,
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

  String _getActionTextForResource(HierarchyResourceModel resource) {
    final url = resource.url.toLowerCase();
    if (url.contains('leetcode.com')) return 'PRACTICE ON LEETCODE →';
    if (url.contains('geeksforgeeks.org') && resource.type == HierarchyResourceType.practice) return 'PRACTICE ON GEEKSFORGEEKS →';
    if (url.contains('github.com')) return 'VIEW GITHUB REPOSITORY →';
    if (resource.type == HierarchyResourceType.notes) return 'OPEN CONCEPT DOCS →';
    if (resource.type == HierarchyResourceType.video) return 'WATCH VIDEO TUTORIAL →';
    return 'LEARN ONLINE →';
  }

  Widget _buildActivityChecklistCard(
    BuildContext context, {
    required String topicId,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSubtitle,
    required Color royalBlue,
    required bool isDark,
  }) {
    RoadmapProvider? roadmapProvider;
    try {
      roadmapProvider = context.watch<RoadmapProvider>();
    } catch (_) {}

    if (roadmapProvider == null) return const SizedBox.shrink();

    final progress = roadmapProvider.getProgressForTopic(topicId);
    const emeraldGreen = Color(0xFF059669);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: progress.isFullyCompleted
              ? emeraldGreen.withAlpha(150)
              : borderColor,
          width: progress.isFullyCompleted ? 2 : 1,
        ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    progress.isFullyCompleted
                        ? Icons.check_circle_rounded
                        : Icons.fact_check_rounded,
                    color: progress.isFullyCompleted ? emeraldGreen : royalBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Topic Activity Checklist',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (progress.isFullyCompleted ? emeraldGreen : royalBlue).withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${progress.completedCount} / 4 (${progress.percentage.toStringAsFixed(0)}%)',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: progress.isFullyCompleted ? emeraldGreen : royalBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress.percentage / 100.0,
              minHeight: 6,
              backgroundColor: isDark ? Colors.black.withAlpha(64) : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress.isFullyCompleted ? emeraldGreen : royalBlue,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Checkbox List
          _buildCheckTile(
            context,
            label: '1. Read concept & understand theory',
            value: progress.learnCompleted,
            onChanged: (_) => roadmapProvider?.toggleActivity(
              topicId: topicId,
              type: ActivityType.learn,
            ),
            textPrimary: textPrimary,
            activeColor: royalBlue,
          ),
          _buildCheckTile(
            context,
            label: '2. Complete practice problems / exercises',
            value: progress.practiceCompleted,
            onChanged: (_) => roadmapProvider?.toggleActivity(
              topicId: topicId,
              type: ActivityType.practice,
            ),
            textPrimary: textPrimary,
            activeColor: royalBlue,
          ),
          _buildCheckTile(
            context,
            label: '3. Build code mini-project / application',
            value: progress.buildCompleted,
            onChanged: (_) => roadmapProvider?.toggleActivity(
              topicId: topicId,
              type: ActivityType.build,
            ),
            textPrimary: textPrimary,
            activeColor: royalBlue,
          ),
          _buildCheckTile(
            context,
            label: '4. Review & self-assess knowledge',
            value: progress.reviewCompleted,
            onChanged: (_) => roadmapProvider?.toggleActivity(
              topicId: topicId,
              type: ActivityType.review,
            ),
            textPrimary: textPrimary,
            activeColor: royalBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckTile(
    BuildContext context, {
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required Color textPrimary,
    required Color activeColor,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: activeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: value ? FontWeight.bold : FontWeight.w500,
                  color: value ? activeColor : textPrimary,
                  decoration: value ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
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

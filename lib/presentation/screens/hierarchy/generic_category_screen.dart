import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/hierarchy_node_model.dart';
import '../../widgets/hierarchy/breadcrumb_bar.dart';
import 'generic_topic_screen.dart';

class GenericCategoryScreen extends StatefulWidget {
  final HubModel hub;
  final CategoryModel category;
  final LearningLevel? initialLevel;

  const GenericCategoryScreen({
    super.key,
    required this.hub,
    required this.category,
    this.initialLevel,
  });

  @override
  State<GenericCategoryScreen> createState() => _GenericCategoryScreenState();
}

class _GenericCategoryScreenState extends State<GenericCategoryScreen> {
  LearningLevel? _selectedLevel;

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.initialLevel ??
        (widget.category.hasLevels ? widget.category.availableLevels!.first : null);
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

    // Filter topics based on level selection if category supports levels
    final displayedTopics = widget.category.topics.where((topic) {
      if (_selectedLevel == null) return true;
      // If topic has direct subtopics with levels, include topic
      if (topic.level == _selectedLevel) return true;
      if (topic.hasSubtopics) {
        return topic.subtopics.any((sub) => sub.level == _selectedLevel || sub.level == null);
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                tooltip: 'Back',
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          widget.category.title,
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
                // Breadcrumbs
                BreadcrumbBar(
                  items: [
                    BreadcrumbItem(
                      label: 'Home',
                      onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                    ),
                    BreadcrumbItem(
                      label: widget.hub.title,
                      onTap: () => Navigator.pop(context),
                    ),
                    BreadcrumbItem(label: widget.category.title),
                  ],
                ),
                const SizedBox(height: 16),

                // Category Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(isDark ? 20 : 6),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: royalBlue.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(widget.category.icon, color: royalBlue, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.category.title,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.category.description,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: textSubtitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: -0.04, end: 0),

                const SizedBox(height: 20),

                // ==========================================
                // LEVEL SELECTION CHIPS (🌱 Beginner, 🌿 Intermediate, 🌳 Advanced, 🚀 Projects)
                // ==========================================
                if (widget.category.hasLevels) ...[
                  Text(
                    'Select Learning Level',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: widget.category.availableLevels!.map((level) {
                        final isSelected = _selectedLevel == level;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(level.displayName),
                            selected: isSelected,
                            selectedColor: royalBlue,
                            backgroundColor: cardBg,
                            labelStyle: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : textPrimary,
                              fontSize: 13,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected ? royalBlue : borderColor,
                              ),
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedLevel = level;
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Topics Section Title
                Text(
                  _selectedLevel != null ? '${_selectedLevel!.displayName} Topics' : 'Topics',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                if (displayedTopics.isEmpty)
                  _buildEmptyState(isDark, cardBg, borderColor, textPrimary, textSubtitle)
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayedTopics.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final topic = displayedTopics[index];
                      return _buildTopicCard(
                        context,
                        topic: topic,
                        cardBg: cardBg,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                        textSubtitle: textSubtitle,
                        royalBlue: royalBlue,
                        isDark: isDark,
                      ).animate().fadeIn(delay: (index * 40).ms).slideX(begin: 0.03, end: 0);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicCard(
    BuildContext context, {
    required HierarchicalTopicModel topic,
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
              topic: topic,
              level: _selectedLevel,
              breadcrumbTrail: [
                widget.hub.title,
                widget.category.title,
                if (_selectedLevel != null) _selectedLevel!.plainTitle,
                topic.title,
              ],
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
              child: Icon(topic.icon, color: royalBlue, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    topic.description,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: textSubtitle,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (topic.hasSubtopics) ...[
                    const SizedBox(height: 6),
                    Text(
                      '${topic.subtopics.length} subtopics available',
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
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
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
          Icon(Icons.auto_stories_rounded, size: 48, color: textSubtitle.withAlpha(150)),
          const SizedBox(height: 12),
          Text(
            'No topics found for this level',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try selecting another learning level above.',
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

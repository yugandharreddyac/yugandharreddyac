import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/placement_provider.dart';
import '../../widgets/shimmer_loading.dart';
import 'placement_detail_screen.dart';
import 'quiz/quiz_hub_screen.dart';

class PlacementHubScreen extends StatefulWidget {
  const PlacementHubScreen({super.key});

  @override
  State<PlacementHubScreen> createState() => _PlacementHubScreenState();
}

class _PlacementHubScreenState extends State<PlacementHubScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<PlacementProvider>().fetchPlacementResources();
      }
    });
  }

  Future<void> _launchUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
    }
  }

  IconData _getCategoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'placement roadmap':
        return Icons.map_rounded;
      case 'aptitude':
        return Icons.calculate_rounded;
      case 'technical interview':
        return Icons.code_rounded;
      case 'coding interviews':
        return Icons.terminal_rounded;
      case 'resume preparation':
      case 'resume building':
        return Icons.description_rounded;
      case 'hr interview':
        return Icons.people_outline_rounded;
      case 'company preparation':
        return Icons.business_center_rounded;
      case 'interview experiences':
        return Icons.forum_rounded;
      case 'mock tests':
        return Icons.fact_check_rounded;
      case 'verified resources':
        return Icons.verified_rounded;
      default:
        return Icons.work_history_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<PlacementProvider>();

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle =
        isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);
    const orangeAccent = AppColors.primary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Campus Placement Preparation Hub',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: textPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: cardColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Banner Card
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF334155)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    Icons.school_rounded,
                    size: 140,
                    color: Colors.white.withAlpha(15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.workspace_premium_rounded,
                            color: Color(0xFF34D399), size: 30),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Complete Placement Readiness Engine',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Aptitude → Technical Q&A → Coding Patterns → HR STAR Method → Mock Tests & ATS Resumes.',
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 11.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Interactive Mock Test & Quiz Banner Action
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuizHubScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.quiz_rounded,
                            color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Interactive Mock Test & Quiz Engine',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Aptitude, Reasoning & CS MCQs with timed simulator & scorecards',
                              style: GoogleFonts.inter(
                                  fontSize: 11, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Category Filter Bar
          if (provider.categories.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: provider.categories.map((cat) {
                  final isSelected = provider.selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      avatar: Icon(_getCategoryIcon(cat),
                          size: 16,
                          color: isSelected ? Colors.white : AppColors.primary),
                      label: Text(
                        cat,
                        style: GoogleFonts.inter(
                          color: isSelected ? Colors.white : textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: orangeAccent,
                      backgroundColor: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                            color: isSelected ? orangeAccent : borderColor),
                      ),
                      onSelected: (_) => provider.selectCategory(cat),
                    ),
                  );
                }).toList(),
              ),
            ),

          // Placement Content List
          Expanded(
            child: provider.isLoading
                ? const ShimmerListLoading(itemCount: 4, itemHeight: 140)
                : provider.filteredResources.isEmpty
                    ? Center(
                        child: Text(
                          'No placement resources found.',
                          style: TextStyle(color: textSubtitle, fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.filteredResources.length,
                        itemBuilder: (context, index) {
                          final item = provider.filteredResources[index];
                          final catIcon = _getCategoryIcon(item.category);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderColor),
                            ),
                            child: ExpansionTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    AppColors.primary.withAlpha(25),
                                child: Icon(catIcon,
                                    color: AppColors.primary, size: 20),
                              ),
                              title: Text(
                                item.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: textPrimary),
                              ),
                              subtitle: Text(
                                item.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12, color: textSubtitle),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (item.roadmap.isNotEmpty) ...[
                                        const Text(
                                            'RECOMMENDED LEARNING ROADMAP:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                                color: AppColors.primary)),
                                        const SizedBox(height: 4),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? AppColors.surfaceDark
                                                : const Color(0xFFEFF6FF),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: AppColors.primary
                                                    .withAlpha(40)),
                                          ),
                                          child: Text(item.roadmap,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: textPrimary,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                        const SizedBox(height: 14),
                                      ],
                                      if (item
                                          .questionsAndAnswers.isNotEmpty) ...[
                                        const Text(
                                            'SAMPLE INTERVIEW / APTITUDE QUESTIONS:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                                color: Color(0xFF10B981))),
                                        const SizedBox(height: 8),
                                        ...item.questionsAndAnswers.map((qa) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? AppColors.surfaceDark
                                                  : const Color(0xFFF8FAFC),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: borderColor),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Chip(
                                                        label: Text(qa.category,
                                                            style: const TextStyle(
                                                                fontSize: 9.5,
                                                                color: AppColors
                                                                    .primary)),
                                                        backgroundColor:
                                                            AppColors.primary
                                                                .withAlpha(20)),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text('Q: ${qa.question}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                        color: textPrimary)),
                                                const SizedBox(height: 6),
                                                Text('A: ${qa.answer}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: textSubtitle,
                                                        height: 1.35)),
                                              ],
                                            ),
                                          );
                                        }),
                                        const SizedBox(height: 12),
                                      ],
                                      if (item.tips.isNotEmpty) ...[
                                        const Text('PLACEMENT TIPS & STRATEGY:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                                color: Colors.amber)),
                                        const SizedBox(height: 4),
                                        ...item.tips.map((t) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                      Icons.lightbulb_rounded,
                                                      color: Colors.amber,
                                                      size: 16),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                      child: Text(t,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  textPrimary))),
                                                ],
                                              ),
                                            )),
                                        const SizedBox(height: 14),
                                      ],
                                      if (item.resourceUrls.isNotEmpty) ...[
                                        const Text(
                                            'VERIFIED EXTERNAL PRACTICE LINKS:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                                color: Colors.purpleAccent)),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children:
                                              item.resourceUrls.map((url) {
                                            return ElevatedButton.icon(
                                              onPressed: () => _launchUrl(url),
                                              icon: const Icon(
                                                  Icons.open_in_new_rounded,
                                                  size: 14),
                                              label: Text(
                                                  url.contains('geeksforgeeks')
                                                      ? 'GeeksforGeeks'
                                                      : (url.contains(
                                                              'indiabix')
                                                          ? 'IndiaBIX'
                                                          : (url.contains(
                                                                  'leetcode')
                                                              ? 'LeetCode'
                                                              : 'Practice Resource')),
                                                  style: const TextStyle(
                                                      fontSize: 11)),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.primary,
                                                  foregroundColor:
                                                      Colors.white),
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(height: 14),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    PlacementDetailScreen(
                                                        placement: item),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                              Icons.auto_stories_rounded,
                                              size: 14),
                                          label: const Text(
                                              'Open 5-Tab Placement Guide',
                                              style: TextStyle(fontSize: 11)),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF059669),
                                              foregroundColor: Colors.white),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                              .animate()
                              .fadeIn(delay: (index * 40).ms)
                              .slideY(begin: 0.05, end: 0);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

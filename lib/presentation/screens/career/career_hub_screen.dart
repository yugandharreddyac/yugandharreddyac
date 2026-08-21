import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/career_model.dart';
import '../../providers/career_provider.dart';
import '../../widgets/shimmer_loading.dart';
import 'career_detail_screen.dart';

class CareerHubScreen extends StatefulWidget {
  const CareerHubScreen({super.key});

  @override
  State<CareerHubScreen> createState() => _CareerHubScreenState();
}

class _CareerHubScreenState extends State<CareerHubScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<CareerProvider>().fetchCareerTechnologies();
      }
    });
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'smart_toy_rounded':
        return Icons.smart_toy_rounded;
      case 'psychology_rounded':
        return Icons.psychology_rounded;
      case 'cloud_done_rounded':
        return Icons.cloud_done_rounded;
      case 'security_rounded':
        return Icons.security_rounded;
      case 'flutter_dash_rounded':
        return Icons.flutter_dash_rounded;
      case 'loop_rounded':
        return Icons.loop_rounded;
      case 'architecture_rounded':
        return Icons.architecture_rounded;
      case 'auto_awesome_rounded':
        return Icons.auto_awesome_rounded;
      case 'chat_bubble_outline_rounded':
        return Icons.chat_bubble_outline_rounded;
      case 'remove_red_eye_rounded':
        return Icons.remove_red_eye_rounded;
      case 'storage_rounded':
        return Icons.storage_rounded;
      case 'currency_bitcoin_rounded':
        return Icons.currency_bitcoin_rounded;
      case 'developer_board_rounded':
        return Icons.developer_board_rounded;
      default:
        return Icons.terminal_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<CareerProvider>();

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF4F4F5);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE4E4E7);
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : const Color(0xFF09090B);
    final textSubtitle =
        isDark ? AppColors.textSecondaryDark : const Color(0xFF71717A);

    const orangeAccent = AppColors.primary;
    const emeraldGreen = Color(0xFF10B981);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Career & Tech Hub',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: textPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: cardColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Value Proposition Banner
          Container(
            margin: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 25 : 6),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
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
                    Icons.work_outline_rounded,
                    size: 140,
                    color: orangeAccent.withAlpha(isDark ? 15 : 10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: orangeAccent.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified_rounded,
                          color: orangeAccent,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Why CSSE Hub vs 10,000+ Web Books?',
                              style: GoogleFonts.inter(
                                color: textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Zero fluff. Structured step-by-step master paths with direct links to GeeksforGeeks, W3Schools, roadmap.sh, & official docs.',
                              style: GoogleFonts.inter(
                                color: textSubtitle,
                                fontSize: 12,
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
            ),
          ),

          // Category Filter Bar
          if (provider.categories.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: provider.categories.map((cat) {
                  final isSelected = provider.selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        cat,
                        style: GoogleFonts.inter(
                          color: isSelected ? Colors.white : textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
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

          // Main List
          Expanded(
            child: provider.isLoading
                ? const ShimmerListLoading(itemHeight: 110)
                : provider.filteredTechnologies.isEmpty
                    ? Center(
                        child: Text(
                          'No technologies found for "${provider.selectedCategory}"',
                          style: GoogleFonts.inter(
                              color: textSubtitle, fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        itemCount: provider.filteredTechnologies.length,
                        itemBuilder: (context, index) {
                          final tech = provider.filteredTechnologies[index];
                          return _buildTechCard(
                                  context,
                                  tech,
                                  orangeAccent,
                                  emeraldGreen,
                                  cardColor,
                                  borderColor,
                                  textPrimary,
                                  textSubtitle,
                                  isDark)
                              .animate()
                              .fadeIn(delay: (30 * index).ms)
                              .slideY(begin: 0.05, end: 0);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechCard(
    BuildContext context,
    CareerModel tech,
    Color orangeAccent,
    Color emeraldGreen,
    Color cardColor,
    Color borderColor,
    Color textPrimary,
    Color textSubtitle,
    bool isDark,
  ) {
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
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CareerDetailScreen(career: tech),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: orangeAccent.withAlpha(20),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _getIconData(tech.icon),
                  color: orangeAccent,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tech.name,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: emeraldGreen.withAlpha(15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'FREE ROADMAP',
                            style: GoogleFonts.inter(
                              color: emeraldGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tech.introduction,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: textSubtitle,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: orangeAccent.withAlpha(15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tech.category,
                            style: GoogleFonts.inter(
                              color: orangeAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${tech.requiredSkills.length} Skills • High Demand',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: textSubtitle,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

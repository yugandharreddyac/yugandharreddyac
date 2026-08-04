import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/coding_resource_model.dart';
import '../../providers/coding_provider.dart';
import '../../widgets/shimmer_loading.dart';

class CodingHubScreen extends StatefulWidget {
  const CodingHubScreen({super.key});

  @override
  State<CodingHubScreen> createState() => _CodingHubScreenState();
}

class _CodingHubScreenState extends State<CodingHubScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<CodingProvider>().fetchCodingResources();
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

  Color _getDifficultyColor(String diff) {
    switch (diff.toLowerCase()) {
      case 'easy':
      case 'beginner':
        return const Color(0xFF10B981);
      case 'medium':
      case 'intermediate':
        return const Color(0xFFF59E0B);
      case 'hard':
      case 'advanced':
        return Colors.redAccent;
      default:
        return const Color(0xFF2563EB);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<CodingProvider>();

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB);
    final cardColor = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE5E7EB);
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    const royalBlue = Color(0xFF2563EB);
    const emeraldGreen = Color(0xFF10B981);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Coding & DSA Hub',
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
          // Filter Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            color: cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: provider.platforms.map((plat) {
                      final isSelected = provider.selectedPlatform == plat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            plat,
                            style: GoogleFonts.inter(
                              color: isSelected ? Colors.white : textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: royalBlue,
                          backgroundColor: cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: isSelected ? royalBlue : borderColor),
                          ),
                          onSelected: (_) => provider.selectPlatform(plat),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Easy', 'Medium', 'Hard'].map((diff) {
                      final isSelected = provider.selectedDifficulty == diff;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text(
                            diff,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isSelected ? royalBlue : textSubtitle,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: royalBlue.withAlpha(25),
                          backgroundColor: cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: isSelected ? royalBlue : borderColor),
                          ),
                          onSelected: (_) => provider.selectDifficulty(diff),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Main List
          Expanded(
            child: provider.isLoading
                ? const ShimmerListLoading(itemHeight: 110)
                : provider.filteredResources.isEmpty
                    ? Center(
                        child: Text(
                          'No coding resources found for selected filters.',
                          style: GoogleFonts.inter(color: textSubtitle, fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        itemCount: provider.filteredResources.length,
                        itemBuilder: (context, index) {
                          final item = provider.filteredResources[index];
                          return _buildCodingCard(context, item, provider, royalBlue, emeraldGreen, cardColor, borderColor, textPrimary, textSubtitle, isDark)
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

  Widget _buildCodingCard(
    BuildContext context,
    CodingResourceModel item,
    CodingProvider provider,
    Color royalBlue,
    Color emeraldGreen,
    Color cardColor,
    Color borderColor,
    Color textPrimary,
    Color textSubtitle,
    bool isDark,
  ) {
    final diffColor = _getDifficultyColor(item.difficulty);

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
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: royalBlue.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.platform,
                    style: GoogleFonts.inter(
                      color: royalBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: diffColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.difficulty,
                    style: GoogleFonts.inter(
                      color: diffColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    item.isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    color: item.isFavorite ? royalBlue : Colors.grey,
                  ),
                  onPressed: () => provider.toggleFavorite(item.id),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.description,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: textSubtitle,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: item.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: royalBlue.withAlpha(12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '#$tag',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: royalBlue,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: () => _launchUrl(item.url),
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: Text(
                  'Start Practice ➔',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: royalBlue,
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
    );
  }
}

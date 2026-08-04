import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/placement_model.dart';
import '../../providers/placement_provider.dart';
import '../../widgets/shimmer_loading.dart';

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
      case 'aptitude':
        return Icons.calculate_rounded;
      case 'logical reasoning':
        return Icons.psychology_alt_rounded;
      case 'verbal ability':
        return Icons.record_voice_over_rounded;
      case 'technical interview':
        return Icons.code_rounded;
      case 'hr interview':
        return Icons.people_outline_rounded;
      case 'resume building':
        return Icons.description_rounded;
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
    final textPrimary = isDark ? AppColors.textPrimaryDark : const Color(0xFF111827);
    final textSubtitle = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    const royalBlue = Color(0xFF2563EB);
    const emeraldGreen = Color(0xFF10B981);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Campus Placement Hub',
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
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: royalBlue,
                      backgroundColor: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: isSelected ? royalBlue : borderColor),
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
                : provider.filteredResources.isEmpty
                    ? Center(
                        child: Text(
                          'No placement preparation items found.',
                          style: GoogleFonts.inter(color: textSubtitle, fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        itemCount: provider.filteredResources.length,
                        itemBuilder: (context, index) {
                          final item = provider.filteredResources[index];
                          return _buildPlacementCard(context, item, provider, royalBlue, emeraldGreen, cardColor, borderColor, textPrimary, textSubtitle, isDark)
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

  Widget _buildPlacementCard(
    BuildContext context,
    PlacementModel item,
    PlacementProvider provider,
    Color royalBlue,
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
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: emeraldGreen.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getCategoryIcon(item.category),
                    color: emeraldGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: royalBlue.withAlpha(15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '120 QUESTIONS',
                              style: GoogleFonts.inter(
                                color: royalBlue,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item.category} • 25 Practice Topics',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: emeraldGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    item.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    color: item.isSaved ? royalBlue : Colors.grey,
                  ),
                  onPressed: () => provider.toggleSave(item.id),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item.description,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: textSubtitle,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: () => _launchUrl(item.resourceLink),
                icon: const Icon(Icons.fitness_center_rounded, size: 18),
                label: Text(
                  'Practice Now ➔',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: emeraldGreen,
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

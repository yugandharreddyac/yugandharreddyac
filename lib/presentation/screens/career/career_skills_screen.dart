import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/career_models.dart';
import '../../providers/roadmap_provider.dart';

class CareerSkillsScreen extends StatelessWidget {
  const CareerSkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubtitle = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final whiteCardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Skill Matrix', style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: textPrimary)),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      body: Consumer<RoadmapProvider>(
        builder: (context, provider, child) {
          final skills = provider.getSkillMatrix();
          
          if (skills.isEmpty) {
             return Center(child: Text('No skills defined.', style: GoogleFonts.inter(color: textSubtitle)));
          }

          // Group by category
          final Map<String, List<SkillEvidenceModel>> grouped = {};
          for (final s in skills) {
            grouped.putIfAbsent(s.category, () => []).add(s);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: grouped.length,
            itemBuilder: (context, index) {
              final category = grouped.keys.elementAt(index);
              final categorySkills = grouped[category]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...categorySkills.map((skill) => _buildSkillTile(skill, isDark, textPrimary, textSubtitle, whiteCardColor)),
                  const SizedBox(height: 24),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSkillTile(SkillEvidenceModel skill, bool isDark, Color textPrimary, Color textSubtitle, Color whiteCardColor) {
    Color badgeColor;
    String badgeText;
    IconData badgeIcon;

    const emeraldGreen = Color(0xFF10B981);
    const royalBlue = Color(0xFF2563EB);
    const burntOrange = Color(0xFFF97316);

    switch (skill.level) {
      case SkillEvidenceLevel.demonstrated:
        badgeColor = emeraldGreen;
        badgeText = 'Demonstrated';
        badgeIcon = Icons.verified_rounded;
        break;
      case SkillEvidenceLevel.practiced:
        badgeColor = royalBlue;
        badgeText = 'Practiced';
        badgeIcon = Icons.fitness_center_rounded;
        break;
      case SkillEvidenceLevel.learning:
        badgeColor = burntOrange;
        badgeText = 'Learning';
        badgeIcon = Icons.menu_book_rounded;
        break;
      case SkillEvidenceLevel.notStarted:
      default:
        badgeColor = textSubtitle.withAlpha(100);
        badgeText = 'Not Started';
        badgeIcon = Icons.lock_outline_rounded;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: badgeColor.withAlpha(50)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.skillName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${skill.relatedTopicIds.length} related topics',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: textSubtitle,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withAlpha(isDark ? 30 : 15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: badgeColor.withAlpha(80)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(badgeIcon, size: 14, color: badgeColor),
                const SizedBox(width: 6),
                Text(
                  badgeText,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

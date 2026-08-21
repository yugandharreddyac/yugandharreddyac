import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/career_models.dart';
import '../../providers/roadmap_provider.dart';

class ProjectPortfolioScreen extends StatelessWidget {
  const ProjectPortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubtitle =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final whiteCardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    const royalBlue = Color(0xFF2563EB);
    const emeraldGreen = Color(0xFF10B981);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Project Portfolio',
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600, color: textPrimary)),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      body: Consumer<RoadmapProvider>(
        builder: (context, provider, child) {
          final projects = provider.getProjectPortfolio();

          if (projects.isEmpty) {
            return Center(
                child: Text('No projects available in the curriculum.',
                    style: GoogleFonts.inter(color: textSubtitle)));
          }

          final completedCount =
              projects.where((p) => p.state == ProjectState.completed).length;
          final inProgressCount = projects
              .where((p) =>
                  p.state != ProjectState.completed &&
                  p.state != ProjectState.notStarted)
              .length;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                            'Completed',
                            completedCount.toString(),
                            emeraldGreen,
                            whiteCardColor,
                            isDark,
                            textPrimary,
                            textSubtitle),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                            'In Progress',
                            inProgressCount.toString(),
                            royalBlue,
                            whiteCardColor,
                            isDark,
                            textPrimary,
                            textSubtitle),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final project = projects[index];
                      return _buildProjectCard(project, isDark, textPrimary,
                          textSubtitle, whiteCardColor);
                    },
                    childCount: projects.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color,
      Color cardColor, bool isDark, Color textPrimary, Color textSubtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  color: textSubtitle,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.outfit(
                  fontSize: 32, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildProjectCard(ProjectPortfolioModel project, bool isDark,
      Color textPrimary, Color textSubtitle, Color whiteCardColor) {
    Color stateColor;
    String stateLabel;
    IconData stateIcon;

    const emeraldGreen = Color(0xFF10B981);
    const secondaryPurple = Color(0xFF9333EA);
    const royalBlue = Color(0xFF2563EB);
    const burntOrange = Color(0xFFF97316);

    switch (project.state) {
      case ProjectState.completed:
        stateColor = emeraldGreen;
        stateLabel = 'Completed';
        stateIcon = Icons.check_circle_rounded;
        break;
      case ProjectState.testing:
      case ProjectState.documented:
        stateColor = secondaryPurple;
        stateLabel = 'Documenting';
        stateIcon = Icons.library_books_rounded;
        break;
      case ProjectState.building:
        stateColor = royalBlue;
        stateLabel = 'Building';
        stateIcon = Icons.construction_rounded;
        break;
      case ProjectState.planning:
        stateColor = burntOrange;
        stateLabel = 'Planning';
        stateIcon = Icons.design_services_rounded;
        break;
      case ProjectState.notStarted:
      default:
        stateColor = textSubtitle;
        stateLabel = 'Not Started';
        stateIcon = Icons.circle_outlined;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: stateColor.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  project.projectName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textPrimary,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: stateColor.withAlpha(isDark ? 30 : 15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: stateColor.withAlpha(50)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(stateIcon, size: 12, color: stateColor),
                    const SizedBox(width: 4),
                    Text(
                      stateLabel,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: stateColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (project.demonstratedSkills.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: project.demonstratedSkills.map((skill) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    skill,
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        color: textSubtitle,
                        fontWeight: FontWeight.w600),
                  ),
                );
              }).toList(),
            ),
          ]
        ],
      ),
    );
  }
}

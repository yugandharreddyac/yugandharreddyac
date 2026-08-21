import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/routes/app_routes.dart';
import '../../providers/roadmap_provider.dart';
import '../../../data/models/user_goal_model.dart';

class CareerDashboardScreen extends StatelessWidget {
  const CareerDashboardScreen({super.key});

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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Career Dashboard',
          style: GoogleFonts.outfit(
              fontWeight: FontWeight.w600, color: textPrimary),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      body: Consumer<RoadmapProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = provider.profile;
          if (profile == null) {
            return const Center(child: Text('No career profile found.'));
          }

          final readiness = provider.getCareerReadiness();
          final gaps = provider.getCareerGaps();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGoalHeader(
                    profile.goal.title, textPrimary, textSubtitle, royalBlue),
                const SizedBox(height: 24),
                _buildReadinessGrid(readiness, textPrimary, textSubtitle,
                    whiteCardColor, isDark),
                const SizedBox(height: 24),
                _buildQuickLinks(context, textPrimary, textSubtitle,
                    whiteCardColor, royalBlue),
                const SizedBox(height: 24),
                _buildCareerGaps(context, gaps, textPrimary, textSubtitle,
                    whiteCardColor, royalBlue),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGoalHeader(String goalTitle, Color textPrimary,
      Color textSubtitle, Color royalBlue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target Role',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textSubtitle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          goalTitle,
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: royalBlue,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildReadinessGrid(
    List<dynamic> readiness,
    Color textPrimary,
    Color textSubtitle,
    Color whiteCardColor,
    bool isDark,
  ) {
    const emeraldGreen = Color(0xFF10B981);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Readiness Profile',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: readiness.length,
          itemBuilder: (context, index) {
            final dim = readiness[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: whiteCardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 30 : 5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dim.dimensionName,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: textSubtitle,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${dim.completed}',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      Text(
                        ' / ${dim.total} Items',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: textSubtitle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: dim.percentage / 100.0,
                    backgroundColor: textSubtitle.withAlpha(50),
                    color: emeraldGreen,
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 6,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickLinks(BuildContext context, Color textPrimary,
      Color textSubtitle, Color whiteCardColor, Color royalBlue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Evidence & Portfolio',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _buildActionTile(
            context,
            'Skill Matrix',
            'View your proven skills',
            Icons.radar_rounded,
            AppRoutes.careerSkills,
            whiteCardColor,
            textPrimary,
            textSubtitle,
            royalBlue),
        const SizedBox(height: 8),
        _buildActionTile(
            context,
            'Project Portfolio',
            'Track project completions',
            Icons.folder_special_rounded,
            AppRoutes.projectPortfolio,
            whiteCardColor,
            textPrimary,
            textSubtitle,
            royalBlue),
        const SizedBox(height: 8),
        _buildActionTile(
            context,
            'Resume Readiness',
            'Checklist for career assets',
            Icons.description_rounded,
            AppRoutes.resumeReadiness,
            whiteCardColor,
            textPrimary,
            textSubtitle,
            royalBlue),
      ],
    );
  }

  Widget _buildActionTile(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      String route,
      Color whiteCardColor,
      Color textPrimary,
      Color textSubtitle,
      Color royalBlue) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: whiteCardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: royalBlue.withAlpha(30)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: royalBlue.withAlpha(20), shape: BoxShape.circle),
              child: Icon(icon, color: royalBlue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textPrimary)),
                  Text(subtitle,
                      style:
                          GoogleFonts.inter(fontSize: 13, color: textSubtitle)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: textSubtitle),
          ],
        ),
      ),
    );
  }

  Widget _buildCareerGaps(
      BuildContext context,
      List<dynamic> gaps,
      Color textPrimary,
      Color textSubtitle,
      Color whiteCardColor,
      Color royalBlue) {
    if (gaps.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What To Improve Next',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...gaps.map((gap) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: whiteCardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.withAlpha(50)),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.red.shade400, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gap.title,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        gap.description,
                        style: GoogleFonts.inter(
                            fontSize: 13, color: textSubtitle),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    if (gap.actionRoute == '/topic_detail' &&
                        gap.actionArguments != null) {
                      // Navigation is handled via arguments directly below.
                    }
                    Navigator.pushNamed(context, gap.actionRoute,
                        arguments: gap.actionArguments);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: royalBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    gap.actionLabel,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

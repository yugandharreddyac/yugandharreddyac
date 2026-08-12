import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/user_goal_model.dart';
import '../../providers/roadmap_provider.dart';

class StudentInsightsScreen extends StatelessWidget {
  const StudentInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roadmapProvider = context.watch<RoadmapProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const royalBlue = Color(0xFF2563EB);
    const emeraldGreen = Color(0xFF059669);
    const amberWarning = Color(0xFFD97706);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubtitle = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    final profile = roadmapProvider.profile;
    final insights = roadmapProvider.getStudentInsights();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Roadmap Insights',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
                      : [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF4338CA) : const Color(0xFFBFDBFE),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: royalBlue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(profile?.goal.icon ?? Icons.school_rounded, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?.goal.title ?? 'Software Engineering Target',
                              style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            Text(
                              '${profile?.year.label ?? '1st Year'} • ${profile?.preferredDomain ?? 'Full-Stack'}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: royalBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Overall Roadmap Completion',
                    style: GoogleFonts.inter(fontSize: 13, color: textSubtitle, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${insights.overallPercentage.toStringAsFixed(0)}%',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: insights.overallPercentage > 0 ? emeraldGreen : royalBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: insights.overallPercentage / 100.0,
                      minHeight: 10,
                      backgroundColor: isDark ? Colors.black.withAlpha(64) : const Color(0xFFCBD5E1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        insights.overallPercentage > 0 ? emeraldGreen : royalBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Empirical Topic Breakdown Grid
            Text(
              'Topic Progress Breakdown',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    label: 'Completed',
                    count: '${insights.completedTopicsCount}',
                    color: emeraldGreen,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricTile(
                    label: 'In Progress',
                    count: '${insights.inProgressTopicsCount}',
                    color: amberWarning,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricTile(
                    label: 'Not Started',
                    count: '${insights.notStartedTopicsCount}',
                    color: textSubtitle,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Stage-by-Stage Completion Progress
            Text(
              '4-Stage Completion Insights',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
            ),
            const SizedBox(height: 14),

            _buildStageProgressRow(
              stageName: 'Stage 1: FOUNDATION',
              percentage: insights.foundationPercentage,
              color: royalBlue,
              cardBg: cardBg,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSubtitle: textSubtitle,
            ),
            const SizedBox(height: 12),

            _buildStageProgressRow(
              stageName: 'Stage 2: CORE CS & DSA',
              percentage: insights.corePercentage,
              color: emeraldGreen,
              cardBg: cardBg,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSubtitle: textSubtitle,
            ),
            const SizedBox(height: 12),

            _buildStageProgressRow(
              stageName: 'Stage 3: BUILD & PROJECTS',
              percentage: insights.buildPercentage,
              color: amberWarning,
              cardBg: cardBg,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSubtitle: textSubtitle,
            ),
            const SizedBox(height: 12),

            _buildStageProgressRow(
              stageName: 'Stage 4: CAREER & PLACEMENT',
              percentage: insights.careerPercentage,
              color: const Color(0xFF7C3AED),
              cardBg: cardBg,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSubtitle: textSubtitle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String count,
    required Color color,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageProgressRow({
    required String stageName,
    required double percentage,
    required Color color,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSubtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stageName,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percentage / 100.0,
              minHeight: 8,
              backgroundColor: color.withAlpha(25),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

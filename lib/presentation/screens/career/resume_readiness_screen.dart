import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/roadmap_provider.dart';

class ResumeReadinessScreen extends StatelessWidget {
  const ResumeReadinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubtitle = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final whiteCardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    const royalBlue = Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Resume Readiness', style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: textPrimary)),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      body: Consumer<RoadmapProvider>(
        builder: (context, provider, child) {
          final checklist = provider.resumeChecklist;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [royalBlue, royalBlue.withAlpha(200)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Overall Readiness',
                              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${checklist.percentage.toStringAsFixed(0)}%',
                              style: GoogleFonts.outfit(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(
                              value: checklist.percentage / 100.0,
                              strokeWidth: 6,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                          Text(
                            '${checklist.completedCount}/${checklist.totalItems}',
                            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Preparation Checklist',
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
                ),
                const SizedBox(height: 16),
                _buildChecklistItem(
                  context: context,
                  title: 'Career Objective Prepared',
                  subtitle: 'Clear summary of your goals and value.',
                  isCompleted: checklist.careerObjectivePrepared,
                  onToggle: () => provider.toggleResumeItem('careerObjectivePrepared'),
                  isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                ),
                _buildChecklistItem(
                  context: context,
                  title: 'Education Formatted',
                  subtitle: 'Degree, university, GPA, and graduation date.',
                  isCompleted: checklist.educationPrepared,
                  onToggle: () => provider.toggleResumeItem('educationPrepared'),
                  isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                ),
                _buildChecklistItem(
                  context: context,
                  title: 'Technical Skills Identified',
                  subtitle: 'Skills mapped from your matrix to resume.',
                  isCompleted: checklist.technicalSkillsIdentified,
                  onToggle: () => provider.toggleResumeItem('technicalSkillsIdentified'),
                  isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                ),
                _buildChecklistItem(
                  context: context,
                  title: 'At Least One Completed Project',
                  subtitle: 'A major project is fully finished and documented.',
                  isCompleted: checklist.oneCompletedProject,
                  onToggle: () => provider.toggleResumeItem('oneCompletedProject'),
                  isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                ),
                _buildChecklistItem(
                  context: context,
                  title: 'Project Descriptions Prepared',
                  subtitle: 'STAR format (Situation, Task, Action, Result) bullet points.',
                  isCompleted: checklist.projectDescriptionsPrepared,
                  onToggle: () => provider.toggleResumeItem('projectDescriptionsPrepared'),
                  isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                ),
                _buildChecklistItem(
                  context: context,
                  title: 'Links & Evidence Available',
                  subtitle: 'GitHub, portfolio, or live links included.',
                  isCompleted: checklist.evidenceAvailable,
                  onToggle: () => provider.toggleResumeItem('evidenceAvailable'),
                  isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                ),
                _buildChecklistItem(
                  context: context,
                  title: 'Resume Reviewed',
                  subtitle: 'Proofread for errors and formatting consistency.',
                  isCompleted: checklist.resumeReviewed,
                  onToggle: () => provider.toggleResumeItem('resumeReviewed'),
                  isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChecklistItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required VoidCallback onToggle,
    required bool isDark,
    required Color textPrimary,
    required Color textSubtitle,
    required Color whiteCardColor,
  }) {
    const emeraldGreen = Color(0xFF10B981);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: whiteCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? emeraldGreen.withAlpha(50) : textSubtitle.withAlpha(20),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onToggle,
        leading: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isCompleted ? emeraldGreen : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: isCompleted ? emeraldGreen : textSubtitle, width: 2),
          ),
          child: Icon(
            Icons.check,
            size: 16,
            color: isCompleted ? Colors.white : Colors.transparent,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isCompleted ? textPrimary : textPrimary.withAlpha(200),
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 12, color: textSubtitle),
        ),
      ),
    );
  }
}

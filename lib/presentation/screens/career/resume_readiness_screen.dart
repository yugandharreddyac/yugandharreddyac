import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/roadmap_provider.dart';

class ResumeReadinessScreen extends StatefulWidget {
  const ResumeReadinessScreen({super.key});

  @override
  State<ResumeReadinessScreen> createState() => _ResumeReadinessScreenState();
}

class _ResumeReadinessScreenState extends State<ResumeReadinessScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        title: Text('Resume & LinkedIn Profile Readiness', style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: textPrimary)),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        bottom: TabBar(
          controller: _tabController,
          labelColor: royalBlue,
          unselectedLabelColor: textSubtitle,
          indicatorColor: royalBlue,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: '📄 Technical Resume'),
            Tab(text: '💼 LinkedIn Profile'),
          ],
        ),
      ),
      body: Consumer<RoadmapProvider>(
        builder: (context, provider, child) {
          final checklist = provider.resumeChecklist;

          return TabBarView(
            controller: _tabController,
            children: [
              // TAB 1: RESUME CHECKLIST
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderBanner(
                      title: 'Resume Readiness Progress',
                      percentage: (checklist.resumeCompletedCount / checklist.resumeTotalItems) * 100.0,
                      completedCount: checklist.resumeCompletedCount,
                      totalItems: checklist.resumeTotalItems,
                      royalBlue: royalBlue,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Technical Resume Checklist',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
                    ),
                    const SizedBox(height: 12),
                    _buildChecklistItem(
                      context: context,
                      title: '1. Technical Resume Started & Template Chosen',
                      subtitle: 'Use single-page LaTeX Jake\'s Resume or Overleaf standard Markdown template.',
                      guidance: 'Avoid multi-page resumes for software roles. Keep fonts professional (Inter, Computer Modern).',
                      isCompleted: checklist.careerObjectivePrepared,
                      onToggle: () => provider.toggleResumeItem('careerObjectivePrepared'),
                      isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                    ),
                    _buildChecklistItem(
                      context: context,
                      title: '2. Education Section Formatted',
                      subtitle: 'Degree name, university, expected graduation date, and CGPA/GPA.',
                      guidance: 'Place Education near top for first-year and college students.',
                      isCompleted: checklist.educationPrepared,
                      onToggle: () => provider.toggleResumeItem('educationPrepared'),
                      isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                    ),
                    _buildChecklistItem(
                      context: context,
                      title: '3. Technical Skills Categorized',
                      subtitle: 'Group skills by Languages (Python, Java), Frameworks (React, Flutter), Tools (Git, VS Code).',
                      guidance: 'Do not include rating bars (e.g. 5/5 stars). List skills strictly by technical confidence.',
                      isCompleted: checklist.technicalSkillsIdentified,
                      onToggle: () => provider.toggleResumeItem('technicalSkillsIdentified'),
                      isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                    ),
                    _buildChecklistItem(
                      context: context,
                      title: '4. At Least One Practical Project Finished',
                      subtitle: 'Include at least one complete hands-on project with clear problem statement.',
                      guidance: 'Describe your tech stack, system architecture, and individual contribution.',
                      isCompleted: checklist.oneCompletedProject,
                      onToggle: () => provider.toggleResumeItem('oneCompletedProject'),
                      isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                    ),
                    _buildChecklistItem(
                      context: context,
                      title: '5. Action Verb Bullet Points (STAR Method)',
                      subtitle: 'Format bullets: Action Verb + Technical Task + Quantifiable Impact Result.',
                      guidance: 'Example: "Engineered responsive Flutter app reducing network payload by 30%."',
                      isCompleted: checklist.projectDescriptionsPrepared,
                      onToggle: () => provider.toggleResumeItem('projectDescriptionsPrepared'),
                      isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                    ),
                    _buildChecklistItem(
                      context: context,
                      title: '6. GitHub & Live Portfolio Links Attached',
                      subtitle: 'Verify hyperlinked GitHub repository and live web app deployment URLs.',
                      guidance: 'Ensure GitHub repos have clean README.md files explaining setup steps.',
                      isCompleted: checklist.evidenceAvailable,
                      onToggle: () => provider.toggleResumeItem('evidenceAvailable'),
                      isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                    ),
                    _buildChecklistItem(
                      context: context,
                      title: '7. Final Proofread & ATS Scan Completed',
                      subtitle: 'Run ATS compatibility checker to verify PDF text parsing and zero typos.',
                      guidance: 'Export directly as PDF from LaTeX/Overleaf. Never submit image/PNG resumes.',
                      isCompleted: checklist.resumeReviewed,
                      onToggle: () => provider.toggleResumeItem('resumeReviewed'),
                      isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),

              // TAB 2: LINKEDIN CHECKLIST
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderBanner(
                      title: 'LinkedIn Profile Readiness Progress',
                      percentage: (checklist.linkedInCompletedCount / checklist.linkedInTotalItems) * 100.0,
                      completedCount: checklist.linkedInCompletedCount,
                      totalItems: checklist.linkedInTotalItems,
                      royalBlue: const Color(0xFF0A66C2), // LinkedIn Official Color
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'LinkedIn Professional Profile Checklist',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
                    ),
                    const SizedBox(height: 12),
                    _buildChecklistItem(
                      context: context,
                      title: '1. LinkedIn Account Created & Custom URL Saved',
                      subtitle: 'Claim clean custom profile URL (e.g. linkedin.com/in/first-last-cs).',
                      guidance: 'Remove random numbers from your URL to make it recruiter and resume friendly.',
                      isCompleted: checklist.linkedInProfileCreated,
                      onToggle: () => provider.toggleResumeItem('linkedInProfileCreated'),
                      isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                    ),
                    _buildChecklistItem(
                      context: context,
                      title: '2. Professional Profile Photo & Banner Added',
                      subtitle: 'Clear, high-resolution headshot with neutral background and clean banner.',
                      guidance: 'Profiles with professional headshots receive 21x more views from tech recruiters.',
                      isCompleted: checklist.linkedInPhotoAdded,
                      onToggle: () => provider.toggleResumeItem('linkedInPhotoAdded'),
                      isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                    ),
                    _buildChecklistItem(
                      context: context,
                      title: '3. Targeted Headline Drafted',
                      subtitle: 'Define role & tech skills (e.g. "CS Student @ University | Flutter & Python Developer").',
                      guidance: 'Include keywords recruiters search for: Python, Fullstack, Data Structures, Software Intern.',
                      isCompleted: checklist.linkedInHeadlineAdded,
                      onToggle: () => provider.toggleResumeItem('linkedInHeadlineAdded'),
                      isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                    ),
                    _buildChecklistItem(
                      context: context,
                      title: '4. Complete About / Summary Section Written',
                      subtitle: '3-paragraph story: current studies, technical interests, projects, and career goal.',
                      guidance: 'Keep it conversational yet professional. Mention your favorite programming languages and goals.',
                      isCompleted: checklist.linkedInAboutCompleted,
                      onToggle: () => provider.toggleResumeItem('linkedInAboutCompleted'),
                      isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                    ),
                    _buildChecklistItem(
                      context: context,
                      title: '5. Projects, Skills & Education Added',
                      subtitle: 'Fill out Education, top 5 technical Skills, and Featured Project cards.',
                      guidance: 'Request peer endorsements for core skills like Data Structures and C++.',
                      isCompleted: checklist.linkedInExperienceAdded,
                      onToggle: () => provider.toggleResumeItem('linkedInExperienceAdded'),
                      isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                    ),
                    _buildChecklistItem(
                      context: context,
                      title: '6. GitHub & Portfolio Linked to Featured Section',
                      subtitle: 'Add GitHub profile URL and portfolio site to Featured media items.',
                      guidance: 'Featured section allows recruiters to view your live applications with 1 click.',
                      isCompleted: checklist.linkedInUrlSaved,
                      onToggle: () => provider.toggleResumeItem('linkedInUrlSaved'),
                      isDark: isDark, textPrimary: textPrimary, textSubtitle: textSubtitle, whiteCardColor: whiteCardColor,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderBanner({
    required String title,
    required double percentage,
    required int completedCount,
    required int totalItems,
    required Color royalBlue,
  }) {
    return Container(
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
                  title,
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  '${percentage.toStringAsFixed(0)}%',
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
                  value: totalItems == 0 ? 0 : completedCount / totalItems,
                  strokeWidth: 6,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
              Text(
                '$completedCount/$totalItems',
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildChecklistItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String guidance,
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
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        leading: GestureDetector(
          onTap: onToggle,
          child: Container(
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
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isCompleted ? textPrimary : textPrimary.withAlpha(200),
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 12, color: textSubtitle),
        ),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF2563EB)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    guidance,
                    style: GoogleFonts.inter(fontSize: 12, color: textPrimary.withAlpha(220), height: 1.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

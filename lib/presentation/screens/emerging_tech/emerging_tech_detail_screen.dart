import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/beyond_academics_model.dart';
import '../../widgets/custom_app_bar.dart';

class EmergingTechDetailScreen extends StatefulWidget {
  final EmergingTechDetailModel technology;

  const EmergingTechDetailScreen({super.key, required this.technology});

  @override
  State<EmergingTechDetailScreen> createState() =>
      _EmergingTechDetailScreenState();
}

class _EmergingTechDetailScreenState extends State<EmergingTechDetailScreen> {
  Future<void> _launchUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tech = widget.technology;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : const Color(0xFF475569);

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: CustomAppBar(
          title: tech.title,
          subtitle: tech.category,
        ),
        body: Column(
          children: [
            // Top Master Header Card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.all(16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(40),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tech.category,
                          style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.bolt_rounded,
                          color: Colors.amber, size: 20),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tech.title,
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tech.overview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.05, end: 0),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: TabBar(
                isScrollable: true,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: textSecondary,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                tabs: const [
                  Tab(text: '💡 Overview'),
                  Tab(text: '🗺️ Roadmap'),
                  Tab(text: '🛠️ Tools & Skills'),
                  Tab(text: '📂 Projects'),
                  Tab(text: '💼 Careers'),
                  Tab(text: '📄 Resources'),
                ],
              ),
            ),

            // Tab View Contents
            Expanded(
              child: TabBarView(
                children: [
                  _buildOverviewTab(context, tech, cardBg, borderColor,
                      textPrimary, textSecondary, isDark),
                  _buildRoadmapTab(context, tech, cardBg, borderColor,
                      textPrimary, textSecondary, isDark),
                  _buildToolsSkillsTab(context, tech, cardBg, borderColor,
                      textPrimary, textSecondary, isDark),
                  _buildProjectsTab(context, tech, cardBg, borderColor,
                      textPrimary, textSecondary, isDark),
                  _buildCareersTab(context, tech, cardBg, borderColor,
                      textPrimary, textSecondary, isDark),
                  _buildResourcesTab(context, tech, cardBg, borderColor,
                      textPrimary, textSecondary, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: OVERVIEW
  Widget _buildOverviewTab(
      BuildContext context,
      EmergingTechDetailModel tech,
      Color cardBg,
      Color borderColor,
      Color textPrimary,
      Color textSecondary,
      bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Why It Matters', Icons.lightbulb_outline_rounded),
        const SizedBox(height: 8),
        _buildCard(cardBg, borderColor,
            child: Text(tech.whyItMatters,
                style: TextStyle(
                    color: textPrimary, fontSize: 13.5, height: 1.45))),
        const SizedBox(height: 18),
        _buildSectionHeader('Prerequisites', Icons.checklist_rounded),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tech.prerequisites.map((p) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withAlpha(50)),
              ),
              child: Text(p,
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        _buildSectionHeader(
            'Core Technical Concepts', Icons.psychology_rounded),
        const SizedBox(height: 8),
        _buildCard(
          cardBg,
          borderColor,
          child: Column(
            children: tech.coreConcepts.map((c) {
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle_outline_rounded,
                    color: AppColors.primary, size: 18),
                title: Text(c,
                    style: TextStyle(
                        fontSize: 12.5,
                        color: textPrimary,
                        fontWeight: FontWeight.w600)),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 18),
        _buildSectionHeader(
            'Mathematics & CS Fundamentals', Icons.functions_rounded),
        const SizedBox(height: 8),
        _buildCard(cardBg, borderColor,
            child: Text(
                tech.mathematics.isNotEmpty
                    ? tech.mathematics
                    : 'Linear Algebra, Probability, Calculus & Graph Algorithms.',
                style: TextStyle(
                    color: textSecondary, fontSize: 12.5, height: 1.4))),
      ],
    );
  }

  // TAB 2: ROADMAP
  Widget _buildRoadmapTab(
      BuildContext context,
      EmergingTechDetailModel tech,
      Color cardBg,
      Color borderColor,
      Color textPrimary,
      Color textSecondary,
      bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Phased Learning Roadmap', Icons.map_rounded),
        const SizedBox(height: 4),
        Text(
            'Follow these structured phases to go from beginner to industry ready.',
            style: TextStyle(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 14),
        if (tech.learningPhases.isNotEmpty) ...[
          ...tech.learningPhases.asMap().entries.map((entry) {
            final idx = entry.key + 1;
            final phase = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.primary,
                          child: Text('$idx',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold))),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(phase.phaseName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: textPrimary))),
                      Chip(
                          label: Text(phase.duration,
                              style: const TextStyle(fontSize: 10)),
                          backgroundColor: Colors.amber.withAlpha(20)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...phase.topics.map((top) => Padding(
                        padding: const EdgeInsets.only(left: 34, top: 2),
                        child: Text('• $top',
                            style:
                                TextStyle(fontSize: 12, color: textSecondary)),
                      )),
                ],
              ),
            );
          }),
        ] else ...[
          _buildCard(cardBg, borderColor,
              child: Text(
                  'Beginner -> Foundation -> Core Skills -> Projects -> Advanced -> Industry Ready.',
                  style: TextStyle(color: textPrimary, fontSize: 13))),
        ],
      ],
    );
  }

  // TAB 3: TOOLS & SKILLS
  Widget _buildToolsSkillsTab(
      BuildContext context,
      EmergingTechDetailModel tech,
      Color cardBg,
      Color borderColor,
      Color textPrimary,
      Color textSecondary,
      bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Programming Languages', Icons.code_rounded),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tech.programmingLanguages.map((lang) {
            return Chip(
              label: Text(lang,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
              backgroundColor: AppColors.primary.withAlpha(25),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        _buildSectionHeader(
            'Industry Standard Tools', Icons.build_circle_rounded),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tech.tools.map((t) {
            return Chip(
              avatar: const Icon(Icons.build_rounded,
                  size: 14, color: Colors.orangeAccent),
              label:
                  Text(t, style: TextStyle(fontSize: 12, color: textPrimary)),
              backgroundColor: cardBg,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: borderColor)),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        _buildSectionHeader(
            'Frameworks & Libraries', Icons.developer_mode_rounded),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tech.frameworks.map((f) {
            return Chip(
              avatar: const Icon(Icons.extension_rounded,
                  size: 14, color: Color(0xFF10B981)),
              label:
                  Text(f, style: TextStyle(fontSize: 12, color: textPrimary)),
              backgroundColor: cardBg,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: borderColor)),
            );
          }).toList(),
        ),
      ],
    );
  }

  // TAB 4: PROJECTS
  Widget _buildProjectsTab(
      BuildContext context,
      EmergingTechDetailModel tech,
      Color cardBg,
      Color borderColor,
      Color textPrimary,
      Color textSecondary,
      bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
            'Hands-on Project Blueprints', Icons.folder_special_rounded),
        const SizedBox(height: 4),
        Text('Build these projects to build a strong engineering portfolio.',
            style: TextStyle(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 14),
        ...tech.projects.map((proj) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                const Icon(Icons.rocket_launch_rounded,
                    color: AppColors.primary, size: 22),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(proj,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: textPrimary))),
              ],
            ),
          );
        }),
      ],
    );
  }

  // TAB 5: CAREERS
  Widget _buildCareersTab(
      BuildContext context,
      EmergingTechDetailModel tech,
      Color cardBg,
      Color borderColor,
      Color textPrimary,
      Color textSecondary,
      bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('High-Demand Job Roles', Icons.work_rounded),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tech.careerRoles.map((role) {
            return Chip(
              avatar: const Icon(Icons.badge_rounded,
                  size: 14, color: AppColors.primary),
              label: Text(role,
                  style: TextStyle(
                      fontSize: 12,
                      color: textPrimary,
                      fontWeight: FontWeight.bold)),
              backgroundColor: AppColors.primary.withAlpha(20),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        _buildSectionHeader(
            'Industry Applications', Icons.business_center_rounded),
        const SizedBox(height: 8),
        _buildCard(
          cardBg,
          borderColor,
          child: Column(
            children: tech.industryApplications.map((app) {
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.domain_rounded,
                    color: Color(0xFF10B981), size: 18),
                title: Text(app,
                    style: TextStyle(fontSize: 12.5, color: textPrimary)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // TAB 6: RESOURCES
  Widget _buildResourcesTab(
      BuildContext context,
      EmergingTechDetailModel tech,
      Color cardBg,
      Color borderColor,
      Color textPrimary,
      Color textSecondary,
      bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
            'Verified External Resources', Icons.verified_rounded),
        const SizedBox(height: 8),
        if (tech.officialResources.isNotEmpty) ...[
          ...tech.officialResources.map((res) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: ListTile(
                dense: true,
                leading: const Icon(Icons.open_in_new_rounded,
                    color: AppColors.primary, size: 18),
                title: Text(res.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: textPrimary)),
                subtitle: Text(res.category,
                    style: TextStyle(fontSize: 11, color: textSecondary)),
                onTap: () => _launchUrl(res.url),
              ),
            );
          }),
        ] else ...[
          _buildCard(cardBg, borderColor,
              child: Text(
                  'Visit official technology documentation and tutorial channels.',
                  style: TextStyle(color: textPrimary, fontSize: 13))),
        ],
      ],
    );
  }

  // HELPERS
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildCard(Color cardBg, Color borderColor, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}

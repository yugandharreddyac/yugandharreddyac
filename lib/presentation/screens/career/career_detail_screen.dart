import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/career_model.dart';
import '../../widgets/custom_app_bar.dart';

class CareerDetailScreen extends StatefulWidget {
  final CareerModel career;

  const CareerDetailScreen({super.key, required this.career});

  @override
  State<CareerDetailScreen> createState() => _CareerDetailScreenState();
}

class _CareerDetailScreenState extends State<CareerDetailScreen> {
  final Map<String, bool> _userChecklist = {};

  Future<void> _launchUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
    }
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
    final career = widget.career;

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : const Color(0xFF475569);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: CustomAppBar(
          title: career.name,
          subtitle: career.category,
        ),
        body: Column(
          children: [
            // Top Header Card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconData(career.icon),
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          career.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            career.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.05, end: 0),

            // Tab Bar Switcher
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
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 12.5),
                unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 12.5),
                tabs: const [
                  Tab(text: '📌 Overview'),
                  Tab(text: '🗺️ Roadmap'),
                  Tab(text: '⚡ Skill Matrix'),
                  Tab(text: '💻 Projects & Portfolio'),
                  Tab(text: '🎯 Interview Prep'),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                children: [
                  _buildOverviewTab(
                      context, career, isDark, textPrimary, textSecondary),
                  _buildRoadmapTab(
                      context, career, isDark, textPrimary, textSecondary),
                  _buildSkillMatrixTab(
                      context, career, isDark, textPrimary, textSecondary),
                  _buildProjectsTab(
                      context, career, isDark, textPrimary, textSecondary),
                  _buildInterviewPrepTab(
                      context, career, isDark, textPrimary, textSecondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: OVERVIEW & SCOPE
  Widget _buildOverviewTab(BuildContext context, CareerModel career,
      bool isDark, Color textPrimary, Color textSecondary) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
            'Overview & Role Definition', Icons.info_outline_rounded),
        const SizedBox(height: 8),
        _buildCard(
          context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                career.introduction,
                style: TextStyle(color: textPrimary, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 14),
              const Text(
                'Why Pursue This Master Career Path?',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                career.whyLearn,
                style:
                    TextStyle(color: textSecondary, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
        if (career.entryLevelResponsibilities.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildSectionHeader('Day-to-Day Entry Level Responsibilities',
              Icons.work_history_rounded),
          const SizedBox(height: 8),
          _buildCard(
            context,
            child: Column(
              children: career.entryLevelResponsibilities.map((resp) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.arrow_right_rounded,
                          color: AppColors.primary, size: 20),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Text(resp,
                              style: TextStyle(
                                  color: textPrimary,
                                  fontSize: 12.5,
                                  height: 1.35))),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
        const SizedBox(height: 20),
        _buildSectionHeader(
            'Target Industry Roles', Icons.work_outline_rounded),
        const SizedBox(height: 8),
        _buildCard(
          context,
          child: Column(
            children: career.careerOpportunities.map((role) {
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: 12,
                  child: Icon(Icons.check, size: 14, color: Colors.white),
                ),
                title: Text(
                  role,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                      fontSize: 13),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        _buildSectionHeader(
            'Future Industry Outlook', Icons.trending_up_rounded),
        const SizedBox(height: 8),
        _buildCard(
          context,
          child: Text(
            career.futureScope,
            style: TextStyle(
                color: textSecondary,
                fontSize: 13,
                height: 1.4,
                fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }

  // TAB 2: STEP-BY-STEP ROADMAP (Interactive Stepper Node Tree)
  Widget _buildRoadmapTab(BuildContext context, CareerModel career, bool isDark,
      Color textPrimary, Color textSecondary) {
    if (career.learningPhases.isNotEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(
              'Structured 8-Phase Learning Path', Icons.map_rounded),
          const SizedBox(height: 4),
          Text(
              'Follow these structured phases from fundamentals to industry deployment.',
              style: TextStyle(color: textSecondary, fontSize: 12)),
          const SizedBox(height: 16),
          ...career.learningPhases.map((phase) {
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : const Color(0xFFE2E8F0)),
              ),
              child: ExpansionTile(
                initiallyExpanded: phase.phaseNumber <= 2,
                leading: CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primary,
                  child: Text('${phase.phaseNumber}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
                title: Text(phase.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: textPrimary)),
                subtitle: Text(phase.subtitle,
                    style: TextStyle(fontSize: 11.5, color: textSecondary)),
                trailing: Chip(
                  label: Text(phase.estimatedDuration,
                      style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold)),
                  backgroundColor: AppColors.primary.withAlpha(20),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(phase.description,
                            style: TextStyle(
                                fontSize: 12.5,
                                color: textPrimary,
                                height: 1.4)),
                        const SizedBox(height: 10),
                        const Text('Key Learning Topics:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: AppColors.primary)),
                        const SizedBox(height: 4),
                        ...phase.topics.map((t) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text('• $t',
                                  style: TextStyle(
                                      fontSize: 12, color: textSecondary)),
                            )),
                        if (phase.milestones.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          const Text('Phase Milestones:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color(0xFF10B981))),
                          const SizedBox(height: 4),
                          ...phase.milestones.map((m) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text('✓ $m',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: textPrimary,
                                        fontWeight: FontWeight.w600)),
                              )),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Structured Learning Timeline', Icons.map_rounded),
        const SizedBox(height: 6),
        Text(
          'Follow these step-by-step milestones to complete your learning journey.',
          style: TextStyle(color: textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 16),
        ...career.learningRoadmap.asMap().entries.map((entry) {
          final idx = entry.key + 1;
          final stepText = entry.value;
          final isLast = idx == career.learningRoadmap.length;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      '$idx',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 50,
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: isDark
                            ? AppColors.borderDark
                            : const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    stepText,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                        fontSize: 13,
                        height: 1.4),
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  // TAB 3: SKILL MATRIX & CHECKLIST
  Widget _buildSkillMatrixTab(BuildContext context, CareerModel career,
      bool isDark, Color textPrimary, Color textSecondary) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Required Skill Matrix', Icons.tune_rounded),
        const SizedBox(height: 4),
        Text(
            'Categorized proficiency levels and importance tags for this role.',
            style: TextStyle(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 14),
        if (career.skillMatrix.isNotEmpty) ...[
          ...career.skillMatrix.map((sk) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(sk.skillName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                  color: textPrimary))),
                      Chip(
                          label: Text(sk.level,
                              style: const TextStyle(
                                  fontSize: 10, color: AppColors.primary)),
                          backgroundColor: AppColors.primary.withAlpha(20)),
                      const SizedBox(width: 6),
                      Chip(
                          label: Text(sk.importance,
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.orange)),
                          backgroundColor: Colors.orange.withAlpha(20)),
                    ],
                  ),
                  if (sk.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(sk.description,
                        style: TextStyle(fontSize: 11.5, color: textSecondary)),
                  ],
                ],
              ),
            );
          }),
        ] else ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: career.requiredSkills.map((skill) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primary.withOpacity(0.18)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    color: isDark ? Colors.cyanAccent : AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
        const SizedBox(height: 20),
        _buildSectionHeader(
            'Interactive Progress Checklist', Icons.task_alt_rounded),
        const SizedBox(height: 6),
        Text('Check off skills as you learn and practice them.',
            style: TextStyle(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 10),
        ...career.requiredSkills.map((skill) {
          final isChecked = _userChecklist[skill] ?? false;
          return CheckboxListTile(
            value: isChecked,
            dense: true,
            title: Text(skill,
                style: TextStyle(
                    fontSize: 12.5,
                    color: textPrimary,
                    decoration: isChecked ? TextDecoration.lineThrough : null)),
            activeColor: AppColors.primary,
            onChanged: (val) {
              setState(() {
                _userChecklist[skill] = val ?? false;
              });
            },
          );
        }),
      ],
    );
  }

  // TAB 4: PROJECTS & PORTFOLIO
  Widget _buildProjectsTab(BuildContext context, CareerModel career,
      bool isDark, Color textPrimary, Color textSecondary) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (career.portfolioRequirements.isNotEmpty) ...[
          _buildSectionHeader(
              'Portfolio & GitHub Guidelines', Icons.badge_rounded),
          const SizedBox(height: 8),
          _buildCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: career.portfolioRequirements.map((p) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Colors.amber, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                          child: Text(p,
                              style: TextStyle(
                                  color: textPrimary,
                                  fontSize: 12.5,
                                  height: 1.35))),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
        ],
        _buildSectionHeader(
            'Hands-On Portfolio Projects', Icons.folder_special_rounded),
        const SizedBox(height: 6),
        Text(
            'Build real-world applications to demonstrate industry engineering capability.',
            style: TextStyle(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 14),
        ...career.miniProjects.map((p) => _buildProjectTile(context, p,
            isAdvanced: false,
            isDark: isDark,
            textPrimary: textPrimary,
            textSecondary: textSecondary)),
        ...career.advancedProjects.map((p) => _buildProjectTile(context, p,
            isAdvanced: true,
            isDark: isDark,
            textPrimary: textPrimary,
            textSecondary: textSecondary)),
        if (career.githubRepos.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildSectionHeader(
              'Official Reference Repositories', Icons.code_rounded),
          const SizedBox(height: 10),
          ...career.githubRepos.map((repo) => _buildResourceTile(
              context, repo, isDark, textPrimary, textSecondary)),
        ],
      ],
    );
  }

  // TAB 5: INTERVIEW PREPARATION & VERIFIED LINKS
  Widget _buildInterviewPrepTab(BuildContext context, CareerModel career,
      bool isDark, Color textPrimary, Color textSecondary) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (career.interviewPrepTopics.isNotEmpty) ...[
          _buildSectionHeader(
              'Key Technical Interview Topics', Icons.psychology_rounded),
          const SizedBox(height: 8),
          _buildCard(
            context,
            child: Column(
              children: career.interviewPrepTopics.map((top) {
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.help_outline_rounded,
                      color: AppColors.primary, size: 18),
                  title: Text(top,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                          color: textPrimary)),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
        ],
        _buildSectionHeader(
            'Verified Learning Resources', Icons.verified_rounded),
        const SizedBox(height: 6),
        Text(
            'Hand-curated documentation, roadmap.sh paths, YouTube playlists, & books.',
            style: TextStyle(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 12),
        ...career.bestFreeResources.map((link) => _buildResourceTile(
            context, link, isDark, textPrimary, textSecondary)),
        ...career.youtubePlaylists.map((link) => _buildResourceTile(
            context, link, isDark, textPrimary, textSecondary)),
        ...career.books.map((link) => _buildResourceTile(
            context, link, isDark, textPrimary, textSecondary)),
        ...career.certifications.map((link) => _buildResourceTile(
            context, link, isDark, textPrimary, textSecondary)),
      ],
    );
  }

  // HELPER WIDGETS
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
        ),
      ),
      child: child,
    );
  }

  Widget _buildProjectTile(BuildContext context, CareerProjectInfo project,
      {required bool isAdvanced,
      required bool isDark,
      required Color textPrimary,
      required Color textSecondary}) {
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isAdvanced
                  ? Colors.orange.withOpacity(0.15)
                  : AppColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isAdvanced ? Icons.star_rounded : Icons.code_rounded,
              color: isAdvanced ? Colors.orange : AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                            color: textPrimary),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isAdvanced
                            ? Colors.orange.withOpacity(0.2)
                            : AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        project.difficulty,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isAdvanced ? Colors.orange : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  project.description,
                  style: TextStyle(
                      fontSize: 12, color: textSecondary, height: 1.35),
                ),
                if (project.url.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _launchUrl(project.url),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('View Project Reference',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 4),
                        Icon(Icons.open_in_new_rounded,
                            color: AppColors.primary, size: 12),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceTile(BuildContext context, CareerResourceLink link,
      bool isDark, Color textPrimary, Color textSecondary) {
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        dense: true,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.open_in_new_rounded,
              color: AppColors.primary, size: 16),
        ),
        title: Text(link.title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
                color: textPrimary)),
        subtitle: Text('${link.platform} • ${link.type}',
            style: TextStyle(fontSize: 11, color: textSecondary)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            size: 12, color: Colors.grey),
        onTap: () => _launchUrl(link.url),
      ),
    );
  }
}

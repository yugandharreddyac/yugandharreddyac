import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/project_model.dart';
import '../../widgets/custom_app_bar.dart';

class ProjectDetailScreen extends StatefulWidget {
  final ProjectModel project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final Map<String, bool> _projectChecklist = {};

  Future<void> _launchUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
    }
  }

  Color _getDifficultyColor(String diff) {
    switch (diff.toLowerCase()) {
      case 'beginner':
        return const Color(0xFF10B981);
      case 'intermediate':
        return const Color(0xFFF59E0B);
      case 'advanced':
        return const Color(0xFF8B5CF6);
      case 'industry level':
      case 'industry':
        return Colors.redAccent;
      default:
        return const Color(0xFF2563EB);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final project = widget.project;
    final diffColor = _getDifficultyColor(project.difficulty);

    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark ? AppColors.borderDark : const Color(0xFFE2E8F0);
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : const Color(0xFF475569);

    final checklistItems = [
      'Idea & Problem Statement Understood',
      'Architecture & DB Schema Designed',
      'Development Phase 1 Complete',
      'Core Features & REST APIs Implemented',
      'Testing Strategy Executed',
      'Deployed Live on Cloud',
      'GitHub README & Repo Configured',
      'Resume Description & Interview Ready',
    ];

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: CustomAppBar(
          title: project.title,
          subtitle: project.category,
        ),
        body: Column(
          children: [
            // Top Header Banner
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
                          project.category,
                          style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: diffColor.withAlpha(50),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: diffColor),
                        ),
                        child: Text(
                          project.difficulty,
                          style: TextStyle(
                              color: diffColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                        ),
                      ),
                      const Spacer(),
                      Chip(
                        label: Text(project.estimatedDuration,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white)),
                        backgroundColor: Colors.white.withAlpha(20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    project.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
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
                  Tab(text: '📌 Blueprint'),
                  Tab(text: '🏗️ Architecture'),
                  Tab(text: '🗺️ Roadmap'),
                  Tab(text: '🚀 Deployment'),
                  Tab(text: '🎯 Resume & Interview'),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                children: [
                  _buildBlueprintTab(context, project, cardBg, borderColor,
                      textPrimary, textSecondary, isDark),
                  _buildArchitectureTab(context, project, cardBg, borderColor,
                      textPrimary, textSecondary, isDark),
                  _buildRoadmapTab(context, project, cardBg, borderColor,
                      textPrimary, textSecondary, isDark),
                  _buildDeploymentTab(context, project, cardBg, borderColor,
                      textPrimary, textSecondary, isDark),
                  _buildResumeInterviewTab(context, project, checklistItems,
                      cardBg, borderColor, textPrimary, textSecondary, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: BLUEPRINT & OVERVIEW
  Widget _buildBlueprintTab(
      BuildContext context,
      ProjectModel project,
      Color cardBg,
      Color borderColor,
      Color textPrimary,
      Color textSecondary,
      bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
            'Problem Statement & Use Case', Icons.assignment_late_rounded),
        const SizedBox(height: 8),
        _buildCard(cardBg, borderColor,
            child: Text(
                project.problemStatement.isNotEmpty
                    ? project.problemStatement
                    : project.description,
                style: TextStyle(
                    color: textPrimary, fontSize: 13.5, height: 1.45))),
        if (project.realWorldUseCase.isNotEmpty) ...[
          const SizedBox(height: 18),
          _buildSectionHeader(
              'Real-World Industry Application', Icons.public_rounded),
          const SizedBox(height: 8),
          _buildCard(cardBg, borderColor,
              child: Text(project.realWorldUseCase,
                  style: TextStyle(
                      color: textSecondary, fontSize: 13, height: 1.4))),
        ],
        const SizedBox(height: 18),
        _buildSectionHeader(
            'Prerequisites & Required Skills', Icons.checklist_rtl_rounded),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (project.requiredSkills.isNotEmpty
                  ? project.requiredSkills
                  : project.technologies)
              .map((sk) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withAlpha(50)),
              ),
              child: Text(sk,
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        _buildSectionHeader('Technology Stack Selection', Icons.layers_rounded),
        const SizedBox(height: 8),
        _buildCard(cardBg, borderColor,
            child: Text(
                project.whyTheseTechnologies.isNotEmpty
                    ? project.whyTheseTechnologies
                    : project.learningOutcome,
                style:
                    TextStyle(color: textPrimary, fontSize: 13, height: 1.4))),
      ],
    );
  }

  // TAB 2: SYSTEM ARCHITECTURE & MODULES
  Widget _buildArchitectureTab(
      BuildContext context,
      ProjectModel project,
      Color cardBg,
      Color borderColor,
      Color textPrimary,
      Color textSecondary,
      bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
            'System Architecture Diagram', Icons.account_tree_rounded),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            project.systemArchitecture.isNotEmpty
                ? project.systemArchitecture
                : (project.architectureNotes.isNotEmpty
                    ? project.architectureNotes
                    : 'Client -> Backend API -> Database'),
            style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11.5,
                color: Colors.cyanAccent,
                height: 1.45),
          ),
        ),
        const SizedBox(height: 18),
        _buildSectionHeader('Major System Modules', Icons.view_module_rounded),
        const SizedBox(height: 8),
        _buildCard(
          cardBg,
          borderColor,
          child: Column(
            children: (project.majorModules.isNotEmpty
                    ? project.majorModules
                    : project.keyFeatures)
                .map((mod) {
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle_outline_rounded,
                    color: AppColors.primary, size: 18),
                title: Text(mod,
                    style: TextStyle(
                        fontSize: 12.5,
                        color: textPrimary,
                        fontWeight: FontWeight.w600)),
              );
            }).toList(),
          ),
        ),
        if (project.databaseDesign.isNotEmpty) ...[
          const SizedBox(height: 18),
          _buildSectionHeader(
              'Database Design & Schema', Icons.storage_rounded),
          const SizedBox(height: 8),
          _buildCard(cardBg, borderColor,
              child: Text(project.databaseDesign,
                  style: TextStyle(
                      color: textPrimary, fontSize: 12.5, height: 1.4))),
        ],
        if (project.folderStructure.isNotEmpty) ...[
          const SizedBox(height: 18),
          _buildSectionHeader(
              'Suggested Folder Structure', Icons.folder_open_rounded),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(project.folderStructure,
                style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: Colors.greenAccent,
                    height: 1.4)),
          ),
        ],
      ],
    );
  }

  // TAB 3: IMPLEMENTATION ROADMAP
  Widget _buildRoadmapTab(
      BuildContext context,
      ProjectModel project,
      Color cardBg,
      Color borderColor,
      Color textPrimary,
      Color textSecondary,
      bool isDark) {
    final roadmapSteps = project.implementationRoadmap.isNotEmpty
        ? project.implementationRoadmap
        : project.developmentPhases;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
            'Step-by-Step Implementation Roadmap', Icons.map_rounded),
        const SizedBox(height: 4),
        Text('Follow these phased steps to build the project from scratch.',
            style: TextStyle(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 14),
        if (roadmapSteps.isNotEmpty) ...[
          ...roadmapSteps.asMap().entries.map((entry) {
            final idx = entry.key + 1;
            final step = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.primary,
                      child: Text('$idx',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(step,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.5,
                              color: textPrimary))),
                ],
              ),
            );
          }),
        ] else ...[
          _buildCard(cardBg, borderColor,
              child: Text(
                  'Follow standard modular development: Setup -> DB Schema -> REST API -> UI Integration -> Testing.',
                  style: TextStyle(color: textPrimary, fontSize: 13))),
        ],
        if (project.testingStrategy.isNotEmpty) ...[
          const SizedBox(height: 18),
          _buildSectionHeader('Testing Strategy', Icons.bug_report_rounded),
          const SizedBox(height: 8),
          _buildCard(cardBg, borderColor,
              child: Text(project.testingStrategy,
                  style: TextStyle(color: textSecondary, fontSize: 12.5))),
        ],
      ],
    );
  }

  // TAB 4: DEPLOYMENT & GITHUB
  Widget _buildDeploymentTab(
      BuildContext context,
      ProjectModel project,
      Color cardBg,
      Color borderColor,
      Color textPrimary,
      Color textSecondary,
      bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Deployment Strategy', Icons.cloud_upload_rounded),
        const SizedBox(height: 8),
        _buildCard(cardBg, borderColor,
            child: Text(
                project.deploymentStrategy.isNotEmpty
                    ? project.deploymentStrategy
                    : 'Deploy frontend on Vercel / Netlify and backend server on Render / AWS.',
                style:
                    TextStyle(color: textPrimary, fontSize: 13, height: 1.4))),
        const SizedBox(height: 18),
        _buildSectionHeader(
            'GitHub Repository & README Guidelines', Icons.code_rounded),
        const SizedBox(height: 8),
        _buildCard(cardBg, borderColor,
            child: Text(
                project.readmeRequirements.isNotEmpty
                    ? project.readmeRequirements
                    : 'Include project description, setup commands, architecture diagram, and license.',
                style: TextStyle(
                    color: textSecondary, fontSize: 12.5, height: 1.4))),
        const SizedBox(height: 24),
        Row(
          children: [
            if (project.githubUrl.isNotEmpty)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _launchUrl(project.githubUrl),
                  icon: const Icon(Icons.code_rounded, size: 16),
                  label: const Text('View GitHub Repository',
                      style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDark ? AppColors.cardDark : Colors.black87,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12)),
                ),
              ),
            if (project.githubUrl.isNotEmpty &&
                project.sourceCodeUrl.isNotEmpty)
              const SizedBox(width: 10),
            if (project.sourceCodeUrl.isNotEmpty)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _launchUrl(project.sourceCodeUrl),
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: const Text('View Source Code',
                      style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12)),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // TAB 5: RESUME & INTERVIEW PREP
  Widget _buildResumeInterviewTab(
      BuildContext context,
      ProjectModel project,
      List<String> checklistItems,
      Color cardBg,
      Color borderColor,
      Color textPrimary,
      Color textSecondary,
      bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
            '30-Second Resume Description', Icons.description_rounded),
        const SizedBox(height: 8),
        _buildCard(
          cardBg,
          borderColor,
          child: SelectableText(
            project.resumeDescription.isNotEmpty
                ? project.resumeDescription
                : 'Built ${project.title} using ${project.technologies.join(", ")} delivering optimal performance and features.',
            style: TextStyle(
                color: textPrimary,
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.bold),
          ),
        ),
        if (project.interviewQuestions.isNotEmpty) ...[
          const SizedBox(height: 18),
          _buildSectionHeader('Project Interview Questions & Answers',
              Icons.psychology_rounded),
          const SizedBox(height: 8),
          _buildCard(
            cardBg,
            borderColor,
            child: Column(
              children: project.interviewQuestions.map((q) {
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.help_outline_rounded,
                      color: AppColors.primary, size: 18),
                  title: Text(q,
                      style: TextStyle(
                          fontSize: 12.5,
                          color: textPrimary,
                          fontWeight: FontWeight.w600)),
                );
              }).toList(),
            ),
          ),
        ],
        const SizedBox(height: 18),
        _buildSectionHeader(
            'Interactive Project Completion Checklist', Icons.task_alt_rounded),
        const SizedBox(height: 4),
        Text('Check off milestones as you build and prepare this project.',
            style: TextStyle(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 10),
        ...checklistItems.map((item) {
          final isChecked = _projectChecklist[item] ?? false;
          return CheckboxListTile(
            value: isChecked,
            dense: true,
            title: Text(item,
                style: TextStyle(
                    fontSize: 12.5,
                    color: textPrimary,
                    decoration: isChecked ? TextDecoration.lineThrough : null)),
            activeColor: AppColors.primary,
            onChanged: (val) {
              setState(() {
                _projectChecklist[item] = val ?? false;
              });
            },
          );
        }),
      ],
    );
  }

  // HELPER WIDGETS
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

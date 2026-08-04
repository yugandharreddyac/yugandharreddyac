import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/project_model.dart';
import '../../widgets/custom_app_bar.dart';

class ProjectDetailScreen extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailScreen({super.key, required this.project});

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
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final diffColor = _getDifficultyColor(project.difficulty);

    return Scaffold(
      appBar: CustomAppBar(
        title: project.title,
        subtitle: project.category,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header Container
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: isDark ? AppColors.darkHeaderGradient : AppColors.headerGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        project.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: diffColor.withAlpha(200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        project.difficulty,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  project.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: 0.1, end: 0),

          const SizedBox(height: 24),

          // Description
          const Text('Project Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          _buildCard(
            context,
            child: Text(
              project.description,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ),

          const SizedBox(height: 24),

          // Tech Stack
          const Text('Technologies Used', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: project.technologies.map((tech) {
              return Chip(
                avatar: const Icon(Icons.code_rounded, size: 16, color: AppColors.primary),
                label: Text(tech),
                backgroundColor: isDark ? AppColors.darkCardBackground : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Learning Outcomes & Features
          const Text('Learning Outcome', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          _buildCard(
            context,
            child: Text(
              project.learningOutcome,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ),

          if (project.keyFeatures.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text('Key Features', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _buildCard(
              context,
              child: Column(
                children: project.keyFeatures
                    .map((feat) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
                          title: Text(feat, style: const TextStyle(fontSize: 14)),
                        ))
                    .toList(),
              ),
            ),
          ],

          if (project.architectureNotes.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text('Architecture Notes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _buildCard(
              context,
              child: Text(
                project.architectureNotes,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5, fontStyle: FontStyle.italic),
              ),
            ),
          ],

          const SizedBox(height: 28),

          // Action Buttons (Source Code & GitHub)
          Row(
            children: [
              if (project.githubUrl.isNotEmpty)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _launchUrl(project.githubUrl),
                    icon: const Icon(Icons.code_rounded),
                    label: const Text('GitHub Repo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.darkCardBackground : Colors.black87,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              if (project.githubUrl.isNotEmpty && project.sourceCodeUrl.isNotEmpty)
                const SizedBox(width: 12),
              if (project.sourceCodeUrl.isNotEmpty)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _launchUrl(project.sourceCodeUrl),
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: const Text('Source Code'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
        ),
      ),
      child: child,
    );
  }
}

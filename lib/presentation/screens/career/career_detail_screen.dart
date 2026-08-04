import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/career_model.dart';
import '../../widgets/custom_app_bar.dart';

class CareerDetailScreen extends StatelessWidget {
  final CareerModel career;

  const CareerDetailScreen({super.key, required this.career});

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
      default:
        return Icons.terminal_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: career.name,
        subtitle: career.category,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: isDark ? AppColors.darkHeaderGradient : AppColors.headerGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(40),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconData(career.icon),
                    size: 38,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        career.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        career.category,
                        style: TextStyle(
                          color: Colors.white.withAlpha(200),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: 0.1, end: 0),

          const SizedBox(height: 24),

          // Introduction & Why Learn
          _buildSectionHeader(context, 'Overview & Purpose', Icons.info_outline_rounded),
          const SizedBox(height: 10),
          _buildCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  career.introduction,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 14),
                Text(
                  'Why Learn This?',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  career.whyLearn,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Required Skills
          _buildSectionHeader(context, 'Required Core Skills', Icons.checklist_rtl_rounded),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: career.requiredSkills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.primary.withAlpha(30) : AppColors.primary.withAlpha(15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withAlpha(50)),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    color: isDark ? AppColors.accent : AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Learning Roadmap
          _buildSectionHeader(context, 'Step-by-Step Learning Roadmap', Icons.map_rounded),
          const SizedBox(height: 10),
          _buildCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: career.learningRoadmap.map((step) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.arrow_right_rounded, color: AppColors.primary, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          step,
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Career Opportunities
          _buildSectionHeader(context, 'Career Opportunities & Roles', Icons.work_outline_rounded),
          const SizedBox(height: 10),
          _buildCard(
            context,
            child: Column(
              children: career.careerOpportunities.map((role) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.secondary,
                    radius: 14,
                    child: Icon(Icons.check, size: 16, color: Colors.white),
                  ),
                  title: Text(role, style: const TextStyle(fontWeight: FontWeight.w600)),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Best Free Resources & Playlists
          _buildSectionHeader(context, 'Free Resources & Playlists', Icons.ondemand_video_rounded),
          const SizedBox(height: 10),
          ...career.bestFreeResources.map((link) => _buildResourceTile(context, link)),
          ...career.youtubePlaylists.map((link) => _buildResourceTile(context, link)),

          const SizedBox(height: 24),

          // Mini & Advanced Projects
          _buildSectionHeader(context, 'Practice Projects', Icons.folder_special_rounded),
          const SizedBox(height: 10),
          ...career.miniProjects.map((p) => _buildProjectTile(context, p, isAdvanced: false)),
          ...career.advancedProjects.map((p) => _buildProjectTile(context, p, isAdvanced: true)),

          const SizedBox(height: 24),

          // Future Scope
          _buildSectionHeader(context, 'Future Scope & Evolution', Icons.trending_up_rounded),
          const SizedBox(height: 10),
          _buildCard(
            context,
            child: Text(
              career.futureScope,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5, fontStyle: FontStyle.italic),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 10),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
        ),
      ),
      child: child,
    );
  }

  Widget _buildResourceTile(BuildContext context, CareerResourceLink link) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: isDark ? AppColors.darkCardBackground : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
      ),
      child: ListTile(
        leading: Icon(
          link.platform.toLowerCase().contains('youtube') ? Icons.play_circle_fill : Icons.link_rounded,
          color: AppColors.primary,
        ),
        title: Text(link.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text('${link.platform} • ${link.type}'),
        trailing: const Icon(Icons.open_in_new_rounded, size: 18),
        onTap: () => _launchUrl(link.url),
      ),
    );
  }

  Widget _buildProjectTile(BuildContext context, CareerProjectInfo p, {required bool isAdvanced}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isAdvanced ? AppColors.accent.withAlpha(100) : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  p.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isAdvanced ? Colors.purple.withAlpha(30) : Colors.blue.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  p.difficulty,
                  style: TextStyle(
                    color: isAdvanced ? Colors.purple : Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(p.description, style: const TextStyle(fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }
}

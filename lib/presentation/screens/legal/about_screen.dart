import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'About CSSE Study Hub',
        subtitle: 'App specs, mission & academic curriculum',
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 64,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppConstants.appName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version 1.0.0 (Build +1)',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildCard(
            theme,
            isDark,
            title: '🎯 Mission & Objective',
            body:
                'CSSE Study Hub is designed to help Computer Science & Software Engineering students access high-quality syllabus guides, lecture notes, and previous question papers in seconds.',
          ),
          const SizedBox(height: 14),
          _buildCard(
            theme,
            isDark,
            title: '⚡ Tech Stack & Architecture',
            body:
                '• Framework: Flutter (Dart ^3.5.0)\n• Architecture: Clean Layered Architecture\n• State Management: Provider Pattern\n• Backend: Firebase Firestore, Firebase Storage & Auth\n• Local Storage & Offline Engine: SharedPreferences & Path Provider',
          ),
          const SizedBox(height: 14),
          _buildCard(
            theme,
            isDark,
            title: '📜 Open Source & Credits',
            body:
                'Built for the academic community. All trademarks, curriculum codes, and course names belong to their respective university academic departments.',
          ),
        ],
      ),
    );
  }

  Widget _buildCard(ThemeData theme, bool isDark,
      {required String title, required String body}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
